From: Anton VG <anton.vazir@gmail.com>
Subject: Problem: nfnl_talk: recvmsg over-run and dead loop.
Date: Sat, 7 Feb 2009 15:12:43 +0500
Message-ID: <c4b050a10902070212x1a0671d9pd6e68560b37bb72b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:53517 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZBGKMp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 05:12:45 -0500
Received: by fxm13 with SMTP id 13so1702530fxm.13
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Feb 2009 02:12:43 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Friends,

Just came to a problem with nfnetlink_queue -

nfnl_talk: recvmsg over-run

GDB connected and backtrace showed the loop in the following:

in write () from /lib/libc.so.6
(gdb) bt
#0  0x00007f67b94c041f in write () from /lib/libc.so.6
#1  0x00007f67b946a743 in _IO_file_write () from /lib/libc.so.6
#2  0x00007f67b946baf8 in _IO_file_xsputn () from /lib/libc.so.6
#3  0x00007f67b9444442 in cuserid () from /lib/libc.so.6
#4  0x00007f67b944508f in vfprintf () from /lib/libc.so.6
#5  0x00007f67b944e328 in fprintf () from /lib/libc.so.6
#6  0x00007f67b930102d in nfnl_talk (nfnlh=0x53c4b0, n=<value
optimized out>, peer=<value optimized out>, groups=<value optimized
out>, answer=0x0,
   junk=0, jarg=0x0) at libnfnetlink.c:678
#7  0x00007f67b9be457f in __build_send_cfg_msg (h=0x5398d0, command=1
'\001', queuenum=<value optimized out>, pf=0) at
libnetfilter_queue.c:114
#8  0x00007f67b9be46e6 in nfq_create_queue (h=0x5398d0, num=40,
cb=0x41104a <cb>, data=0x5c8b68) at libnetfilter_queue.c:246
#9  0x0000000000410579 in nfqhandler::add_queue (this=0x53c3e0,
group=40, dev=0x551578 "ppp40", ip=318845450) at nfqlib.cpp:369
#10 0x00000000004065df in hndpptp::setda (this=0x5301a0,
pptp_pid=1505) at hndlib.cpp:418
#11 0x0000000000406b05 in hndpptp::dologin (this=0x5301a0, pi={_M_node
= 0x588a40}) at hndlib.cpp:453
#12 0x0000000000408603 in hndpptp::run (this=0x5301a0) at hndlib.cpp:268
#13 0x000000000040522c in main () at nfman.cpp:34

Also I'm watching the following in the dmesg (though, it does not kill
the service) - but maybe somehow influences?

__ratelimit: 14 messages suppressed
nf_queue: full at 1024 entries, dropping packets(s). Dropped: 679

Further details: using kernel 2.6.26.5 and
libnetfilter_queue-0.0.16
libnfnetlink-0.0.39

It's all while used in the environment where users do connect to a
host, and every
connected user (over PPP) get's a separate NF-QUEUE -
In this QUEUE i do packet accounting, to a different destination. When
number of simultaneous queues went to 40+  I just came to a problem -
deadloop with continues generation of the error to stderr - (3GB of
record in the log in 3 minutes of deadlock)


Do you think that increasing the NFQNL_QMAX_DEFAULT from 1024 to 10240
would solve the problem
(in linux-2.6.26.5/net/netfilter/nfnetlink_queue.c) - or the problem is deeper?

Maybe anything like this is fixed in further versions of the kernel of
libraries?

Will be grateful for any help

Anton.
