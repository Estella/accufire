namespace eval history {
    proc add? {w} {
        variable $w
        variable n$w
        upvar 0 $w hist
        set s [set ::[$w cget -textvariable]]
        if {$s == ""} return
        if [string compare $s [lindex $hist end]] {
            lappend hist $s
            set n$w [llength $hist]
        }
    }
    proc move {w where} {
        variable $w
        variable n$w
        upvar 0 $w hist
        incr n$w $where
        if {[set n$w]<0} {set n$w 0}
        if {[set n$w]>=[llength $hist]+1} {
            set n$w [llength $hist]
        }
        set ::[$w cget -textvar] [lindex $hist [set n$w]]
    }
    proc for {type name args} {
        switch -- $type {
            entry - ttk::entry {
                uplevel $type $name $args
                bind $name <Up> {history::move %W -1}
                bind $name <Down> {history::move %W 1}
                bind $name <Return> {history::add? %W}
                variable $name {}
                variable n$name 0
            }
            default {error "usage: history::for entry <w> <args>"}
        }
    }
}
