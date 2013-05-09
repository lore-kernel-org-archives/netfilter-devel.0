From: Chris <fisch.666@gmx.de>
Subject: ip6tables: Memory allocation problem with xt_geoip on debian wheezy
Date: Thu, 09 May 2013 14:23:12 +0200
Message-ID: <518B9530.9010203@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49344 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3EIMXX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 May 2013 08:23:23 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LpAT4-1U6Ylq1Hkq-00eqcf for
 <netfilter-devel@vger.kernel.org>; Thu, 09 May 2013 14:23:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi list,

i'm using the xt_geoip module from the xtables-addons-dkms package
version 1.42-2 on a debian wheezy amd64 system with iptables and a few
rules without a problem.

Today i've tried to add new ip6tables rules which should use the geoip
module too and just get this message:

ip6tables: Memory allocation problem

Additional the at the buttom of this message pasted log is shown in
/var/log/syslog. (Hope it is not too long if i send it in this message)

Any hints whats wrong here? If you need any more infos let me know and
CC me, i'm not subscribed to the list atm.

Thanks in advance for a reply.

Chris


vmalloc: allocation failure: 0 bytes
ip6tables: page allocation failure: order:0, mode:0xd2
Pid: 14122, comm: ip6tables Tainted: G           O 3.2.0-4-amd64 #1
Debian 3.2.41-2
Call Trace:
[<ffffffff810b85bf>] ? warn_alloc_failed+0x11a/0x12d
[<ffffffffa0509271>] ? xt_geoip_mt_checkentry+0x102/0x20d [xt_geoip]
[<ffffffff810dbdf7>] ? __vmalloc_node_range+0x1e6/0x1fa
[<ffffffff810dbe37>] ? __vmalloc_node+0x2c/0x31
[<ffffffffa0509271>] ? xt_geoip_mt_checkentry+0x102/0x20d [xt_geoip]
[<ffffffff810dbf0d>] ? vmalloc+0x24/0x27
[<ffffffffa0509271>] ? xt_geoip_mt_checkentry+0x102/0x20d [xt_geoip]
[<ffffffff81036428>] ? should_resched+0x5/0x23
[<ffffffffa02fa6fc>] ? xt_check_match+0x169/0x19e [x_tables]
[<ffffffff81036428>] ? should_resched+0x5/0x23
[<ffffffff8134c68f>] ? _cond_resched+0x7/0x1c
[<ffffffffa02fa486>] ? xt_find_match+0x79/0xd6 [x_tables]
[<ffffffffa04ef769>] ? check_match+0x3a/0x46 [ip6_tables]
[<ffffffffa04f16fa>] ? translate_table+0x2c9/0x43a [ip6_tables]
[<ffffffffa04f1bef>] ? do_ip6t_set_ctl+0xe0/0x17a [ip6_tables]
[<ffffffff812b0ed8>] ? nf_sockopt+0x7e/0x9e
[<ffffffff812b0f21>] ? nf_setsockopt+0x1a/0x21
[<ffffffff8130ba9f>] ? ipv6_setsockopt+0x79/0x92
[<ffffffff8127f657>] ? sys_setsockopt+0x7d/0x9c
[<ffffffff81352952>] ? system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  28
CPU    1: hi:  186, btch:  31 usd: 145
active_anon:179551 inactive_anon:83705 isolated_anon:0
active_file:8108 inactive_file:18856 isolated_file:0
unevictable:0 dirty:153 writeback:0 unstable:0
free:197094 slab_reclaimable:4876 slab_unreclaimable:5712
mapped:18410 shmem:24956 pagetables:5519 bounce:0
Node 0 DMA free:14576kB min:340kB low:424kB high:508kB active_anon:8kB
inactive_anon:52kB active_file:680kB inactive_file:560kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15688kB mlocked:0kB
dirty:8kB writeback:0kB mapped:188kB shmem:0kB slab_reclaimable:36kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1992 1992 1992
Node 0 DMA32 free:773800kB min:44712kB low:55888kB high:67068kB
active_anon:718196kB inactive_anon:334768kB active_file:31752kB
inactive_file:74864kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:2040408kB mlocked:0kB dirty:604kB
writeback:0kB mapped:73452kB shmem:99824kB slab_reclaimable:19468kB
slab_unreclaimable:22848kB kernel_stack:1960kB pagetables:22076kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 110*4kB 79*8kB 40*16kB 22*32kB 8*64kB 3*128kB 2*256kB
1*512kB 2*1024kB 2*2048kB 1*4096kB = 14576kB
Node 0 DMA32: 6538*4kB 12633*8kB 2743*16kB 935*32kB 403*64kB 177*128kB
28*256kB 12*512kB 1*1024kB 17*2048kB 116*4096kB = 773760kB
71382 total pagecache pages
19438 pages in swap cache
Swap cache stats: add 1098605, delete 1079167, find 1623835/1699092
Free swap  = 30237176kB
Total swap = 30717944kB
521712 pages RAM
9481 pages reserved
112355 pages shared
286220 pages non-shared
xt_geoip: unable to load 'KP' into memory: -12
