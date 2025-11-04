/*

    Jay Logger - default logger for jay engine

*/


#import "String";
#import "Basic";

jay_logger :: (message: string, data: *void, info: Log_Info) {
    message_builder: String_Builder;

    prefix_builder: String_Builder;
    
    print_to_builder(*prefix_builder, "\u001b\u001b");
    print_to_builder(*prefix_builder, "[T-%] ", context.thread_index);
    print_to_builder(*prefix_builder, calendar_to_log_string(to_calendar(current_time_consensus())));
    print_to_builder(*prefix_builder, "\x1b[0m ");
    if info.common_flags == {
        case .ERROR;
        {
            print_to_builder(*prefix_builder, "[\x1b[31mError\x1b[0m]   \x1b[31m");
        }
        case .WARNING;
        {
            print_to_builder(*prefix_builder, "[\x1b[33mWarning\x1b[0m] \x1b[33m");
        }
        case .CONTENT;
        {
            print_to_builder(*prefix_builder, "[\x1b[35m\x1b[1mContent\x1b[0m] \x1b[1m");
        } 
        case;
        {
            print_to_builder(*prefix_builder, "\x1b[2m[\x1b[36mInfo\x1b[0m\x1b[2m]\x1b[0m    ");
        }
    }

    prefix := builder_to_string(*prefix_builder,, temp);
    suffix := join("\n", prefix,, temp);
    s := trim(message, "\n",, temp);
    //offseted := replace(s, "\n", "\n                                    ",, temp);
    offseted := s;
    print_to_builder(*message_builder, prefix);
    print_to_builder(*message_builder, offseted);
    print_to_builder(*message_builder, "\x1b[0m\n");
    write_builder(*message_builder);
}

log_warning :: (format_string: string, args: .. Any, loc := #caller_location, flags := Log_Flags.NONE, user_flags : u32 = 0, section : *Log_Section = null) {
    new_flags := flags | .WARNING;
    log(format_string, ..args, loc, new_flags, user_flags, section);
} @PrintLike

#scope_file

calendar_to_log_string :: (ct: Calendar_Time) -> string {

    month := ct.month_starting_at_0;
    month = clamp(month, 0, 11)+1;
    {
        using ct;

        Clock :: #bake_arguments formatInt(minimum_digits=2);

        time_string := tprint("%.%.% %:%:%", day_of_month_starting_at_0+1, Clock(month), year, Clock(hour), Clock(minute), Clock(second));
        
        return time_string;
    }
}
