From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Ulogd crashes - NFCT polling mode + NACCT
Date: Wed, 18 Jul 2012 08:21:26 -0700
Message-ID: <CAAJpzgZdfV3_r4ymFLvWroRjJkaQVtUdwb4P-vf57fyGJL7bzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49811 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2GRPVr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:21:47 -0400
Received: by obbuo13 with SMTP id uo13so2262299obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jul 2012 08:21:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I try to use ulogd with NFCT polling mode and NACCT output. Ulogd
crashes with this options, and stacktrace is given as below
Could someone help me the reason for this failure?

== Stacktrace =================================
#0  0x00007fe46c334445 in raise () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#1  0x00007fe46c337bab in abort () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#2  0x00007fe46c32d10e in ?? () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#3  0x00007fe46c32d1b2 in __assert_fail () from /lib/x86_64-linux-gnu/libc.so.6
No symbol table info available.
#4  0x00007fe46b8d6274 in nfct_query (h=0x0, qt=<optimized out>,
data=<optimized out>) at api.c:942
        u = {buffer = 0x7fffa7a06bd0
"\377\377\377\377\377\377\377\377", req = {nlh = {nlmsg_len = 0,
nlmsg_type = 0, nlmsg_flags = 0, nlmsg_seq = 0, nlmsg_pid = 0}, nfmsg
= {nfgen_family = 0 '\000', version = 0 '\000', res_id = 0}}}
        __PRETTY_FUNCTION__ = "nfct_query"
#5  0x00007fe46bae8615 in polling_timer_cb (t=<optimized out>,
data=0xe5c8a0) at ulogd_inpflow_NFCT.c:999
        upi = 0xe5c8a0
        family = 0
#6  0x00000000004047d8 in ulogd_do_timer_run (next_run=0x7fffa7a07c80)
at timer.c:162
        alarm_run_queue = {next = 0xe5c998, prev = 0xe5a408}
        node = <optimized out>
        this = <optimized out>
        tv = {tv_sec = 1342590477, tv_usec = 250967}
#7  0x000000000040214a in ulogd_main_loop () at ulogd.c:907
        ret = <optimized out>
        next_alarm = {tv_sec = 0, tv_usec = 0}
        next = 0x7fffa7a07c80
#8  main (argc=<optimized out>, argv=<optimized out>) at ulogd.c:1248
        argch = <optimized out>
        daemonize = 1
        change_uid = 0
        user = 0x0
        pw = <optimized out>
        uid = 0
        gid = 0

Thanks & Regards,
