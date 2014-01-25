From: Eric Leblond <eric@regit.org>
Subject: Re: Fwd: ULOGD2 with MYSQL
Date: Sat, 25 Jan 2014 21:26:48 +0100
Message-ID: <1390681608.15795.2.camel@ice-age2.regit.org>
References: <CACHQFzHmmxy6G-2Nh_t4aSqafr1JPwEg5HG1uy+otX1T=zm62Q@mail.gmail.com>
	 <CACHQFzHFvghfcVpn4N3BGUB7Gmz-+YEeN6THLmyve1SjyCminw@mail.gmail.com>
	 <1388479400.3787.2.camel@ice-age2.regit.org>
	 <CACHQFzE=wV0yYZnJcWHXg5+nxsv=Wkydd_pg8VLO9svJ0Es5-g@mail.gmail.com>
	 <1388496314.3787.10.camel@ice-age2.regit.org>
	 <CACHQFzH_KMaNMqhZ4QFWowtcv7GQQv1L2Nis=o2tAfxxDHw_fA@mail.gmail.com>
	 <CACHQFzEk7jUHELN9TgFyQWHoyeaOBvWNLY3mxD12NpfV3QZ7Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Sassy Natan <sassyn@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50670 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaAYU04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:26:56 -0500
In-Reply-To: <CACHQFzEk7jUHELN9TgFyQWHoyeaOBvWNLY3mxD12NpfV3QZ7Mw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

First of all, sorry for the delay in the answer.

On Thu, 2014-01-02 at 12:05 +0200, Sassy Natan wrote:
> Hi
> 
> I'm not sure.
> 
> I change some of the mysql timeout settings in the server side.
> Also run ulogd -v -l -2 manually
> 
> 
> 
> Once I cancel it via CTRL+C
> 
> I got this:
> ^CTue Dec 31 14:02:24 2013 <5> ulogd.c:1231 Terminal signal received, exiting
> Tue Dec 31 14:02:24 2013 <1> ulogd.c:1198 calling stop for IFINDEX
> Tue Dec 31 14:02:24 2013 <1> ulogd.c:1198 calling stop for MYSQL
> Tue Dec 31 14:02:24 2013 <5> ../../util/db.c:197 stopping
> *** Error in `ulogd': double free or corruption (top): 0x00007f9b8ef509a0 ***

I've just pushed to git a set of patches that should fix the issue. I've
observed a segfault when terminating too and these patches have fixed it
on my test system.

Regarding the timeout problem, I'm currently running tests and I will
try to reproduce the problem. By the way, can you tell me if your MySQL
configuration change did fix the problem ?

BR,

> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(+0x80996)[0x7f9b8ddbc996]
> /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so(+0x1110)[0x7f9b8b8e1110]
> /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so(+0x14c0)[0x7f9b8b8e14c0]
> /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so(ulogd_db_stop+0x9)[0x7f9b8b8e1ee9]
> ulogd(+0x4baf)[0x7f9b8e531baf]
> /lib/x86_64-linux-gnu/libc.so.6(+0x36ff0)[0x7f9b8dd72ff0]
> /lib/x86_64-linux-gnu/libc.so.6(__select+0x33)[0x7f9b8de2ede3]
> ulogd(ulogd_select_main+0x2d2)[0x7f9b8e532382]
> ulogd(main+0x7b7)[0x7f9b8e52fd37]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f9b8dd5dde5]
> ulogd(+0x3122)[0x7f9b8e530122]
> ======= Memory map: ========
> 7f9b84000000-7f9b84021000 rw-p 00000000 00:00 0
> 7f9b84021000-7f9b88000000 ---p 00000000 00:00 0
> 7f9b89a40000-7f9b89a4c000 r-xp 00000000 08:01 2061
>   /lib/x86_64-linux-gnu/libnss_files-2.17.so
> 7f9b89a4c000-7f9b89c4b000 ---p 0000c000 08:01 2061
>   /lib/x86_64-linux-gnu/libnss_files-2.17.so
> 7f9b89c4b000-7f9b89c4c000 r--p 0000b000 08:01 2061
>   /lib/x86_64-linux-gnu/libnss_files-2.17.so
> 7f9b89c4c000-7f9b89c4d000 rw-p 0000c000 08:01 2061
>   /lib/x86_64-linux-gnu/libnss_files-2.17.so
> 7f9b89c4d000-7f9b89c62000 r-xp 00000000 08:01 2180
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9b89c62000-7f9b89e61000 ---p 00015000 08:01 2180
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9b89e61000-7f9b89e62000 r--p 00014000 08:01 2180
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9b89e62000-7f9b89e63000 rw-p 00015000 08:01 2180
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9b89e63000-7f9b89e64000 ---p 00000000 00:00 0
> 7f9b89e64000-7f9b8a664000 rw-p 00000000 00:00 0
> 7f9b8a664000-7f9b8a666000 r-xp 00000000 08:01 131600
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GRAPHITE.so
> 7f9b8a666000-7f9b8a865000 ---p 00002000 08:01 131600
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GRAPHITE.so
> 7f9b8a865000-7f9b8a866000 r--p 00001000 08:01 131600
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GRAPHITE.so
> 7f9b8a866000-7f9b8a867000 rw-p 00002000 08:01 131600
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GRAPHITE.so
> 7f9b8a867000-7f9b8a869000 r-xp 00000000 08:01 131581
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFACCT.so
> 7f9b8a869000-7f9b8aa68000 ---p 00002000 08:01 131581
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFACCT.so
> 7f9b8aa68000-7f9b8aa69000 r--p 00001000 08:01 131581
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFACCT.so
> 7f9b8aa69000-7f9b8aa6a000 rw-p 00002000 08:01 131581
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFACCT.so
> 7f9b8aa6a000-7f9b8aa6c000 r-xp 00000000 08:01 131594
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_raw2packet_BASE.so
> 7f9b8aa6c000-7f9b8ac6b000 ---p 00002000 08:01 131594
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_raw2packet_BASE.so
> 7f9b8ac6b000-7f9b8ac6c000 r--p 00001000 08:01 131594
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_raw2packet_BASE.so
> 7f9b8ac6c000-7f9b8ac6e000 rw-p 00002000 08:01 131594
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_raw2packet_BASE.so
> 7f9b8ac6e000-7f9b8ad71000 r-xp 00000000 08:01 2194
>   /lib/x86_64-linux-gnu/libm-2.17.so
> 7f9b8ad71000-7f9b8af70000 ---p 00103000 08:01 2194
>   /lib/x86_64-linux-gnu/libm-2.17.so
> 7f9b8af70000-7f9b8af71000 r--p 00102000 08:01 2194
>   /lib/x86_64-linux-gnu/libm-2.17.so
> 7f9b8af71000-7f9b8af72000 rw-p 00103000 08:01 2194
>   /lib/x86_64-linux-gnu/libm-2.17.so
> 7f9b8af72000-7f9b8af89000 r-xp 00000000 08:01 2075
>   /lib/x86_64-linux-gnu/libpthread-2.17.so
> 7f9b8af89000-7f9b8b189000 ---p 00017000 08:01 2075
>   /lib/x86_64-linux-gnu/libpthread-2.17.so
> 7f9b8b189000-7f9b8b18a000 r--p 00017000 08:01 2075
>   /lib/x86_64-linux-gnu/libpthread-2.17.so
> 7f9b8b18a000-7f9b8b18b000 rw-p 00018000 08:01 2075
>   /lib/x86_64-linux-gnu/libpthread-2.17.so
> 7f9b8b18b000-7f9b8b18f000 rw-p 00000000 00:00 0
> 7f9b8b18f000-7f9b8b1a7000 r-xp 00000000 08:01 2048
>   /lib/x86_64-linux-gnu/libz.so.1.2.8
> 7f9b8b1a7000-7f9b8b3a6000 ---p 00018000 08:01 2048
>   /lib/x86_64-linux-gnu/libz.so.1.2.8
> 7f9b8b3a6000-7f9b8b3a7000 r--p 00017000 08:01 2048
>   /lib/x86_64-linux-gnu/libz.so.1.2.8
> 7f9b8b3a7000-7f9b8b3a8000 rw-p 00018000 08:01 2048
>   /lib/x86_64-linux-gnu/libz.so.1.2.8
> 7f9b8b3a8000-7f9b8b658000 r-xp 00000000 08:01 65476
>   /usr/lib/x86_64-linux-gnu/libmysqlclient.so.18.0.0
> 7f9b8b658000-7f9b8b857000 ---p 002b0000 08:01 65476
>   /usr/lib/x86_64-linux-gnu/libmysqlclient.so.18.0.0
> 7f9b8b857000-7f9b8b85d000 r--p 002af000 08:01 65476
>   /usr/lib/x86_64-linux-gnu/libmysqlclient.so.18.0.0
> 7f9b8b85d000-7f9b8b8db000 rw-p 002b5000 08:01 65476
>   /usr/lib/x86_64-linux-gnu/libmysqlclient.so.18.0.0
> 7f9b8b8db000-7f9b8b8e0000 rw-p 00000000 00:00 0
> 7f9b8b8e0000-7f9b8b8e3000 r-xp 00000000 08:01 131603
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so
> 7f9b8b8e3000-7f9b8bae2000 ---p 00003000 08:01 131603
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so
> 7f9b8bae2000-7f9b8bae3000 r--p 00002000 08:01 131603
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so
> 7f9b8bae3000-7f9b8bae4000 rw-p 00003000 08:01 131603
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_MYSQL.so
> 7f9b8bae4000-7f9b8bae6000 r-xp 00000000 08:01 131592
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GPRINT.so
> 7f9b8bae6000-7f9b8bce5000 ---p 00002000 08:01 131592
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GPRINT.so
> 7f9b8bce5000-7f9b8bce6000 r--p 00001000 08:01 131592
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GPRINT.so
> 7f9b8bce6000-7f9b8bce7000 rw-p 00002000 08:01 131592
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_GPRINT.so
> 7f9b8bce7000-7f9b8bce9000 r-xp 00000000 08:01 65501
>   /usr/lib/x86_64-linux-gnu/libnetfilter_acct.so.1.0.0
> 7f9b8bce9000-7f9b8bee8000 ---p 00002000 08:01 65501
>   /usr/lib/x86_64-linux-gnu/libnetfilter_acct.so.1.0.0
> 7f9b8bee8000-7f9b8bee9000 r--p 00001000 08:01 65501
>   /usr/lib/x86_64-linux-gnu/libnetfilter_acct.so.1.0.0
> 7f9b8bee9000-7f9b8beea000 rw-p 00002000 08:01 65501
>   /usr/lib/x86_64-linux-gnu/libnetfilter_acct.so.1.0.0
> 7f9b8beea000-7f9b8beec000 r-xp 00000000 08:01 131599
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_XML.so
> 7f9b8beec000-7f9b8c0eb000 ---p 00002000 08:01 131599
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_XML.so
> 7f9b8c0eb000-7f9b8c0ec000 r--p 00001000 08:01 131599
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_XML.so
> 7f9b8c0ec000-7f9b8c0ed000 rw-p 00002000 08:01 131599
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_XML.so
> 7f9b8c0ed000-7f9b8c0ee000 rw-p 00000000 00:00 0
> 7f9b8c0ee000-7f9b8c0ef000 r-xp 00000000 08:01 131593
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_SYSLOG.so
> 7f9b8c0ef000-7f9b8c2ef000 ---p 00001000 08:01 131593
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_SYSLOG.so
> 7f9b8c2ef000-7f9b8c2f0000 r--p 00001000 08:01 131593
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_SYSLOG.so
> 7f9b8c2f0000-7f9b8c2f1000 rw-p 00002000 08:01 131593
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_SYSLOG.so
> 7f9b8c2f1000-7f9b8c2f3000 r-xp 00000000 08:01 131591
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_LOGEMU.so
> 7f9b8c2f3000-7f9b8c4f2000 ---p 00002000 08:01 131591
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_LOGEMU.so
> 7f9b8c4f2000-7f9b8c4f3000 r--p 00001000 08:01 131591
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_LOGEMU.so
> 7f9b8c4f3000-7f9b8c4f4000 rw-p 00002000 08:01 131591
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_output_LOGEMU.so
> 7f9b8c4f4000-7f9b8c4f6000 r-xp 00000000 08:01 131597
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTFLOW.so
> 7f9b8c4f6000-7f9b8c6f5000 ---p 00002000 08:01 131597
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTFLOW.so
> 7f9b8c6f5000-7f9b8c6f6000 r--p 00001000 08:01 131597
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTFLOW.so
> 7f9b8c6f6000-7f9b8c6f7000 rw-p 00002000 08:01 131597
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTFLOW.so
> 7f9b8c6f7000-7f9b8c6f8000 rw-p 00000000 00:00 0
> 7f9b8c6f8000-7f9b8c6f9000 r-xp 00000000 08:01 131588
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_HWHDR.so
> 7f9b8c6f9000-7f9b8c8f8000 ---p 00001000 08:01 131588
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_HWHDR.so
> 7f9b8c8f8000-7f9b8c8f9000 r--p 00000000 08:01 131588
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_HWHDR.so
> 7f9b8c8f9000-7f9b8c8fa000 rw-p 00001000 08:01 131588
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_HWHDR.so
> 7f9b8c8fa000-7f9b8c8fc000 r-xp 00000000 08:01 131579
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTPKT.so
> 7f9b8c8fc000-7f9b8cafc000 ---p 00002000 08:01 131579
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTPKT.so
> 7f9b8cafc000-7f9b8cafd000 r--p 00002000 08:01 131579
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTPKT.so
> 7f9b8cafd000-7f9b8caff000 rw-p 00003000 08:01 131579
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_PRINTPKT.so
> 7f9b8caff000-7f9b8cb00000 rw-p 00000000 00:00 0
> 7f9b8cb00000-7f9b8cb01000 r-xp 00000000 08:01 131587
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2BIN.so
> 7f9b8cb01000-7f9b8cd00000 ---p 00001000 08:01 131587
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2BIN.so
> 7f9b8cd00000-7f9b8cd01000 r--p 00000000 08:01 131587
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2BIN.so
> 7f9b8cd01000-7f9b8cd02000 rw-p 00001000 08:01 131587
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2BIN.so
> 7f9b8cd02000-7f9b8cd03000 r-xp 00000000 08:01 131584
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2STR.so
> 7f9b8cd03000-7f9b8cf02000 ---p 00001000 08:01 131584
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2STR.so
> 7f9b8cf02000-7f9b8cf03000 r--p 00000000 08:01 131584
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2STR.so
> 7f9b8cf03000-7f9b8cf04000 rw-p 00001000 08:01 131584
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IP2STR.so
> 7f9b8cf04000-7f9b8cf05000 r-xp 00000000 08:01 131590
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IFINDEX.so
> 7f9b8cf05000-7f9b8d104000 ---p 00001000 08:01 131590
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IFINDEX.so
> 7f9b8d104000-7f9b8d105000 r--p 00000000 08:01 131590
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IFINDEX.so
> 7f9b8d105000-7f9b8d106000 rw-p 00001000 08:01 131590
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_filter_IFINDEX.so
> 7f9b8d106000-7f9b8d10a000 r-xp 00000000 08:01 65495
>   /usr/lib/x86_64-linux-gnu/libmnl.so.0.1.0
> 7f9b8d10a000-7f9b8d309000 ---p 00004000 08:01 65495
>   /usr/lib/x86_64-linux-gnu/libmnl.so.0.1.0
> 7f9b8d309000-7f9b8d30a000 r--p 00003000 08:01 65495
>   /usr/lib/x86_64-linux-gnu/libmnl.so.0.1.0
> 7f9b8d30a000-7f9b8d30b000 rw-p 00004000 08:01 65495
>   /usr/lib/x86_64-linux-gnu/libmnl.so.0.1.0
> 7f9b8d30b000-7f9b8d323000 r-xp 00000000 08:01 65507
>   /usr/lib/x86_64-linux-gnu/libnetfilter_conntrack.so.3.4.0
> 7f9b8d323000-7f9b8d522000 ---p 00018000 08:01 65507
>   /usr/lib/x86_64-linux-gnu/libnetfilter_conntrack.so.3.4.0
> 7f9b8d522000-7f9b8d524000 r--p 00017000 08:01 65507
>   /usr/lib/x86_64-linux-gnu/libnetfilter_conntrack.so.3.4.0
> 7f9b8d524000-7f9b8d525000 rw-p 00019000 08:01 65507
>   /usr/lib/x86_64-linux-gnu/libnetfilter_conntrack.so.3.4.0
> 7f9b8d525000-7f9b8d52a000 r-xp 00000000 08:01 131585
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFCT.so
> 7f9b8d52a000-7f9b8d729000 ---p 00005000 08:01 131585
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFCT.so
> 7f9b8d729000-7f9b8d72a000 r--p 00004000 08:01 131585
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFCT.so
> 7f9b8d72a000-7f9b8d72c000 rw-p 00005000 08:01 131585
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inpflow_NFCT.so
> 7f9b8d72c000-7f9b8d732000 r-xp 00000000 08:01 4329
>   /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0
> 7f9b8d732000-7f9b8d931000 ---p 00006000 08:01 4329
>   /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0
> 7f9b8d931000-7f9b8d932000 r--p 00005000 08:01 4329
>   /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0
> 7f9b8d932000-7f9b8d933000 rw-p 00006000 08:01 4329
>   /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0
> 7f9b8d933000-7f9b8d936000 r-xp 00000000 08:01 65513
>   /usr/lib/libnetfilter_log.so.1.1.0
> 7f9b8d936000-7f9b8db35000 ---p 00003000 08:01 65513
>   /usr/lib/libnetfilter_log.so.1.1.0
> 7f9b8db35000-7f9b8db36000 r--p 00002000 08:01 65513
>   /usr/lib/libnetfilter_log.so.1.1.0
> 7f9b8db36000-7f9b8db37000 rw-p 00003000 08:01 65513
>   /usr/lib/libnetfilter_log.so.1.1.0
> 7f9b8db37000-7f9b8db3a000 r-xp 00000000 08:01 131580
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inppkt_NFLOG.so
> 7f9b8db3a000-7f9b8dd39000 ---p 00003000 08:01 131580
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inppkt_NFLOG.so
> 7f9b8dd39000-7f9b8dd3a000 r--p 00002000 08:01 131580
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inppkt_NFLOG.so
> 7f9b8dd3a000-7f9b8dd3c000 rw-p 00003000 08:01 131580
>   /usr/lib/x86_64-linux-gnu/ulogd/ulogd_inppkt_NFLOG.so
> 7f9b8dd3c000-7f9b8def9000 r-xp 00000000 08:01 2088
>   /lib/x86_64-linux-gnu/libc-2.17.so
> 7f9b8def9000-7f9b8e0f9000 ---p 001bd000 08:01 2088
>   /lib/x86_64-linux-gnu/libc-2.17.so
> 7f9b8e0f9000-7f9b8e0fd000 r--p 001bd000 08:01 2088
>   /lib/x86_64-linux-gnu/libc-2.17.so
> 7f9b8e0fd000-7f9b8e0ff000 rw-p 001c1000 08:01 2088
>   /lib/x86_64-linux-gnu/libc-2.17.so
> 7f9b8e0ff000-7f9b8e104000 rw-p 00000000 00:00 0
> 7f9b8e104000-7f9b8e107000 r-xp 00000000 08:01 2090
>   /lib/x86_64-linux-gnu/libdl-2.17.so
> 7f9b8e107000-7f9b8e306000 ---p 00003000 08:01 2090
>   /lib/x86_64-linux-gnu/libdl-2.17.so
> 7f9b8e306000-7f9b8e307000 r--p 00002000 08:01 2090
>   /lib/x86_64-linux-gnu/libdl-2.17.so
> 7f9b8e307000-7f9b8e308000 rw-p 00003000 08:01 2090
>   /lib/x86_64-linux-gnu/libdl-2.17.so
> 7f9b8e308000-7f9b8e32b000 r-xp 00000000 08:01 2094
>   /lib/x86_64-linux-gnu/ld-2.17.so
> 7f9b8e4d6000-7f9b8e523000 rw-p 00000000 00:00 0
> 7f9b8e525000-7f9b8e52a000 rw-p 00000000 00:00 0
> 7f9b8e52a000-7f9b8e52b000 r--p 00022000 08:01 2094
>   /lib/x86_64-linux-gnu/ld-2.17.so
> 7f9b8e52b000-7f9b8e52d000 rw-p 00023000 08:01 2094
>   /lib/x86_64-linux-gnu/ld-2.17.so
> 7f9b8e52d000-7f9b8e536000 r-xp 00000000 08:01 65525
>   /usr/sbin/ulogd
> 7f9b8e735000-7f9b8e736000 r--p 00008000 08:01 65525
>   /usr/sbin/ulogd
> 7f9b8e736000-7f9b8e737000 rw-p 00009000 08:01 65525
>   /usr/sbin/ulogd
> 7f9b8ef22000-7f9b8ef64000 rw-p 00000000 00:00 0                          [heap]
> 7fffd9485000-7fffd94a6000 rw-p 00000000 00:00 0                          [stack]
> 7fffd958b000-7fffd958d000 r-xp 00000000 00:00 0                          [vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
>   [vsyscall]
> 
> 
> 
> On Tue, Dec 31, 2013 at 3:25 PM, Eric Leblond <eric@regit.org> wrote:
> > Hello,
> >
> > On Tue, 2013-12-31 at 12:41 +0200, Sassy Natan wrote:
> >> Hi Eric
> >>
> >> I'm using ulog version 2.0.3 on ubuntu system 13.10
> >>
> >> If I keep generate some network traffic  that should be log under ulog
> >> - log get into the remote DB.
> >> So say I running ping -t 8.8.8.8 - this works
> >>
> >> However, once the ping stop, and no network traffic in or out from the
> >> machine - like for 10 min (or in case I don't log such a traffic in my
> >> iptables) no more insert into the DB.
> >>
> >> Here is what I have in the ulog.conf file
> >>
> >>
> >> stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL
> >>
> >> [mysql1]
> >> db="nulog"
> >> host="x.x.x.x"
> >> user="xxx"
> >> table="ulog"
> >> pass="xxx"
> >> procedure="INSERT_PACKET_FULL"
> >> reconnect=2
> >> connect_timeout=100
> >> backlog_memcap=1000000
> >> backlog_oneshot_requests=10
> >>
> >>
> >> and this is what I have in the log file when no network is being generated
> >>
> >> Mon Dec 30 10:20:57 2013 <5> ulogd_inppkt_NFLOG.c:503 forcing unbind
> >> of existing log handler for protocol 10
> >> Mon Dec 30 10:20:57 2013 <5> ulogd_inppkt_NFLOG.c:503 forcing unbind
> >> of existing log handler for protocol 7
> >> Mon Dec 30 10:20:57 2013 <5> ../../util/db.c:179 starting
> >> Mon Dec 30 10:20:57 2013 <5> ulogd.c:1428 Changing UID / GID
> >> Mon Dec 30 20:37:38 2013 <7> ulogd_output_MYSQL.c:235 execute failed
> >> (Lost connection to MySQL server during query)
> >
> > Is it possible you have a firewall with short connection timeout between
> > machine running ulogd and the database ? That could explain that the
> > connection get lost.
> >
> >> Mon Dec 30 20:37:38 2013 <7> ../../util/db.c:234 no connection to
> >> database, attempting to reconnect after 1 seconds
> >> Mon Dec 30 20:37:38 2013 <5> ulogd.c:522 error during propagate_results
> >> Mon Dec 30 23:02:14 2013 <5> ulogd.c:1231 Terminal signal received, exiting
> >> Mon Dec 30 23:02:14 2013 <5> ../../util/db.c:197 stopping
> >> Mon Dec 30 23:02:14 2013 <5> ulogd.c:382 registering plugin `NFLOG'
> >>
> >>
> >> Any idea?
> >>
> >> Thank you
> >> Sassy
> >>
> >>
> >>
> >> On Tue, Dec 31, 2013 at 10:43 AM, Eric Leblond <eric@regit.org> wrote:
> >> > Hello,
> >> >
> >> > On Mon, 2013-12-30 at 01:25 +0200, Sassy Natan wrote:
> >> >> Hi Group,
> >> >>
> >> >> Running ulogd2 with remote MYSQL seems to stop working after 10 min.
> >> >>
> >> >> Running MYSQL on the localhost work just fine.
> >> >>
> >> >> I was trying to change the parameters of the ULOG without any success
> >> >>
> >> >> Any idea how to solve it? is it a bug?
> >> >
> >> > What version are you using ? Do you use the new multithreaded system ?
> >> > Any other information like log messages ?
> >> >
> >> > ++
> >> >
> >> >> Thanks
> >> >>
> >> >>
> >> >> --
> >> >> Regards,
> >> >>
> >> >> Sassy Natan
> >> >> 972-(05)54-2203702
> >> >>
> >> >> On Mon, Dec 30, 2013 at 1:01 AM, Sassy Natan <sassyn@gmail.com> wrote:
> >> >> > Hi Group,
> >> >> >
> >> >> > Running ulogd2 with remote MYSQL seems to stop working after 10 min.
> >> >> >
> >> >> > Running MYSQL on the localhost work just fine.
> >> >> >
> >> >> > I was trying to change the parameters of the ULOG without any success
> >> >> >
> >> >> > Any idea how to solve it? is it a bug?
> >> >> > Thanks
> >> >> >
> >> >> >
> >> >> > --
> >> >> > Regards,
> >> >> >
> >> >> > Sassy Natan
> >> >> > 972-(05)54-2203702
> >> >>
> >> >>
> >> >>
> >> >
> >> > --
> >> > Eric Leblond <eric@regit.org>
> >> >
> >>
> >>
> >>
> >
> > --
> > Eric Leblond <eric@regit.org>
> >
> 
> 
> 
> --
> Regards,
> 
> Sassy Natan
> 972-(05)54-2203702
> 
> 

-- 
Eric Leblond <eric@regit.org>

-- 
Eric Leblond <eric@regit.org>

