From: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Subject: Kernel 2.6.24 and ipset - problem
Date: Sun, 03 Feb 2008 19:34:41 +0100
Message-ID: <1202063681.6433.10.camel@steven.kity.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:46213 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYBCSlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:41:24 -0500
Received: from unknown ([127.0.0.2])
 by localhost (psyche.piasta.pl [127.0.0.2]) (amavisd-new, port 10628)
 id 10516-06 for <netfilter-devel@vger.kernel.org>;
 Sun,  3 Feb 2008 19:34:41 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.
I have kernel 2.6.24 and ipset with patch-o-matic-ng-20080122.

# ipset -V
ipset v2.2.9a Protocol version 2.

Below logs from syslog.

=46eb  2 13:05:11 cerber2h ipset: page allocation failure. order:7, mod=
e:0xd0
=46eb  2 13:05:11 cerber2h Pid: 12861, comm: ipset Not tainted 2.6.24-n=
on-smp #4
=46eb  2 13:05:11 cerber2h [<c0133414>] __alloc_pages+0x2b5/0x2c6
=46eb  2 13:05:11 cerber2h [<c0144c9c>] cache_alloc_refill+0x239/0x3e8
=46eb  2 13:05:11 cerber2h [<c0144ea6>] __kmalloc+0x5b/0x95
=46eb  2 13:05:11 cerber2h [<f88df475>] create+0xfd/0x134 [ip_set_macip=
map]
=46eb  2 13:05:11 cerber2h [<f88b5a9c>] ip_set_create+0x115/0x213 [ip_s=
et]
=46eb  2 13:05:11 cerber2h [<f88b63ea>] ip_set_sockfn_get+0x850/0xa33 [=
ip_set]
=46eb  2 13:05:11 cerber2h [<f88b5691>] ip_set_testip_kernel+0x95/0x9f =
[ip_set]
=46eb  2 13:05:11 cerber2h [<c02eac21>] nf_sockopt+0xb1/0xd9
=46eb  2 13:05:11 cerber2h [<c02eac69>] nf_getsockopt+0x20/0x25
=46eb  2 13:05:11 cerber2h [<c02fbca8>] ip_getsockopt+0x538/0x572
=46eb  2 13:05:11 cerber2h [<c02d65fd>] dev_hard_start_xmit+0x20c/0x266
=46eb  2 13:05:11 cerber2h [<c02f0dc8>] nf_ct_deliver_cached_events+0x3=
5/0x69
=46eb  2 13:05:11 cerber2h [<c0321f70>] ipv4_confirm+0x34/0x39
=46eb  2 13:05:11 cerber2h [<f8860aea>] e1000_clean_rx_irq+0x264/0x297 =
[e1000e]
=46eb  2 13:05:11 cerber2h [<c02e22d3>] __qdisc_run+0x4d/0x115
=46eb  2 13:05:11 cerber2h [<c02d85bc>] dev_queue_xmit+0x22c/0x254
=46eb  2 13:05:11 cerber2h [<f885d8db>] e1000_clean+0x410/0x427 [e1000e=
]
=46eb  2 13:05:11 cerber2h [<c02cf149>] sk_prot_alloc+0x12/0x54
=46eb  2 13:05:11 cerber2h [<c0154670>] d_alloc+0x1b/0x150
=46eb  2 13:05:11 cerber2h [<c02ce68e>] sock_common_getsockopt+0x1d/0x2=
2
=46eb  2 13:05:11 cerber2h [<c02ccdbc>] sys_getsockopt+0x61/0x80
=46eb  2 13:05:11 cerber2h [<c02ce475>] sys_socketcall+0x20d/0x242
=46eb  2 13:05:11 cerber2h [<c0104364>] do_IRQ+0x58/0x6b
=46eb  2 13:05:11 cerber2h [<c01022ee>] sysenter_past_esp+0x5f/0x85
=46eb  2 13:05:11 cerber2h =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
=46eb  2 13:05:11 cerber2h Mem-info:
=46eb  2 13:05:11 cerber2h DMA per-cpu:
=46eb  2 13:05:11 cerber2h CPU    0: Hot: hi:    0, btch:   1 usd:   0 =
  Cold: hi:    0, btch:   1 usd:   0
=46eb  2 13:05:11 cerber2h Normal per-cpu:
=46eb  2 13:05:11 cerber2h CPU    0: Hot: hi:  186, btch:  31 usd:   0 =
  Cold: hi:   62, btch:  15 usd:   0
=46eb  2 13:05:11 cerber2h HighMem per-cpu:
=46eb  2 13:05:11 cerber2h CPU    0: Hot: hi:   42, btch:   7 usd:   0 =
  Cold: hi:   14, btch:   3 usd:   0
=46eb  2 13:05:11 cerber2h Active:37525 inactive:125849 dirty:1986 writ=
eback:1 unstable:0
=46eb  2 13:05:11 cerber2h free:19097 slab:72096 mapped:3141 pagetables=
:255 bounce:0
=46eb  2 13:05:11 cerber2h DMA free:5688kB min:68kB low:84kB high:100kB=
 active:8kB inactive:1724kB present:16256kB pages_scanned:0 all_unrecla=
imable? no
=46eb  2 13:05:11 cerber2h lowmem_reserve[]: 0 873 999 999
=46eb  2 13:05:11 cerber2h Normal free:70396kB min:3744kB low:4680kB hi=
gh:5616kB active:100320kB inactive:424792kB present:894080kB pages_scan=
ned:0 all_unreclaimable? no
=46eb  2 13:05:11 cerber2h lowmem_reserve[]: 0 0 1008 1008
=46eb  2 13:05:11 cerber2h HighMem free:304kB min:128kB low:260kB high:=
396kB active:49772kB inactive:76880kB present:129032kB pages_scanned:0 =
all_unreclaimable? no
=46eb  2 13:05:11 cerber2h lowmem_reserve[]: 0 0 0 0
=46eb  2 13:05:11 cerber2h DMA: 370*4kB 86*8kB 24*16kB 6*32kB 8*64kB 9*=
128kB 5*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 5688kB
=46eb  2 13:05:11 cerber2h Normal: 2645*4kB 2625*8kB 1082*16kB 316*32kB=
 104*64kB 31*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 70396=
kB
=46eb  2 13:05:11 cerber2h HighMem: 12*4kB 2*8kB 1*16kB 1*32kB 1*64kB 1=
*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 304kB
=46eb  2 13:05:11 cerber2h Swap cache: add 6156, delete 4792, find 2144=
81/214988, race 0+0
=46eb  2 13:05:11 cerber2h Free swap  =3D 1952316kB
=46eb  2 13:05:11 cerber2h Total swap =3D 1959800kB
=46eb  2 13:05:11 cerber2h Free swap:       1952316kB
=46eb  2 13:05:11 cerber2h 261888 pages of RAM
=46eb  2 13:05:11 cerber2h 32512 pages of HIGHMEM
=46eb  2 13:05:11 cerber2h 3628 reserved pages
=46eb  2 13:05:11 cerber2h 146365 pages shared
=46eb  2 13:05:11 cerber2h 1364 pages swap cached
=46eb  2 13:05:11 cerber2h 1986 pages dirty
=46eb  2 13:05:11 cerber2h 1 pages writeback
=46eb  2 13:05:11 cerber2h 3141 pages mapped
=46eb  2 13:05:11 cerber2h 72096 pages slab
=46eb  2 13:05:11 cerber2h 255 pages pagetables


Please help.

--=20
Krzysztof Mo=C5=9Bcicki

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
