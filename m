From: "Jeff Haran" <jharan@bytemobile.com>
Subject: testing packet marks from the mangle table doesn't seem to work
Date: Thu, 28 Jul 2011 19:05:17 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A70295D1E6@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:35487 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1G2CFi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 22:05:38 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am not sure if this is a bug or a feature or if I am just confused,
but is seems that attempting to test for packet marks from the mangle
table does not work. I have the following rules:

 [root@cap-x2100m2-01 ~]# iptables -t filter -L -n -v
Chain INPUT (policy ACCEPT 1192 packets, 111K bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 75 packets, 9652 bytes)
 pkts bytes target     prot opt in     out     source
destination
   41  4540 LOG        all  --  eth2.11 eth1.111  0.0.0.0/0
0.0.0.0/0           mark match !0x0/0xfff LOG flags 0 level 3 prefix
`marked_filter'
   34  5112 LOG        all  --  eth1.111 eth2.11  0.0.0.0/0
0.0.0.0/0           mark match !0x0/0xfff LOG flags 0 level 3 prefix
`marked_filter'
   82  9080 NFQUEUE    all  --  eth2.11 eth1.111  0.0.0.0/0
0.0.0.0/0           mark match 0x0/0xfff NFQUEUE num 10
   68 10224 NFQUEUE    all  --  eth1.111 eth2.11  0.0.0.0/0
0.0.0.0/0           mark match 0x0/0xfff NFQUEUE num 10

Chain OUTPUT (policy ACCEPT 654 packets, 127K bytes)
 pkts bytes target     prot opt in     out     source
destination
[root@cap-x2100m2-01 ~]#
[root@cap-x2100m2-01 ~]# iptables -t mangle -L -n -v
Chain PREROUTING (policy ACCEPT 1304 packets, 124K bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain INPUT (policy ACCEPT 1206 packets, 111K bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 75 packets, 9652 bytes)
 pkts bytes target     prot opt in     out     source
destination
    0     0 LOG        all  --  eth2.11 eth1.111  0.0.0.0/0
0.0.0.0/0           mark match !0x0/0xfff LOG flags 0 level 3 prefix
`marked_mangle'
    0     0 LOG        all  --  eth1.111 eth2.11  0.0.0.0/0
0.0.0.0/0           mark match !0x0/0xfff LOG flags 0 level 3 prefix
`marked_mangle'

Chain OUTPUT (policy ACCEPT 653 packets, 128K bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain POSTROUTING (policy ACCEPT 728 packets, 138K bytes)
 pkts bytes target     prot opt in     out     source
destination
[root@cap-x2100m2-01 ~]#

I also have an application that reads NFQUEUE 10 and calls
nfq_set_verdict_mark() to set a non-zero value in the packet mark with
NF_REPEAT.

When I look at the output of the above LOG targets. I see logs prefixed
with "marked_filter" but none with "marked_mangle".

[root@cap-x2100m2-01 ~]# grep marked_filter /var/log/kernel_log.txt
Jul 28 18:34:23 cap-x2100m2-01 kernel: marked_filterIN=eth2.11
OUT=eth1.111 SRC=192.168.11.2 DST=192.168.3.101 LEN=64 TOS=0x00
PREC=0x00 TTL=63 ID=2269 DF PROTO=TCP SPT=51213 DPT=22 WINDOW=32850
RES=0x00 SYN URGP=0 MARK=0x46c0c046
Jul 28 18:34:23 cap-x2100m2-01 kernel: marked_filterIN=eth1.111
OUT=eth2.11 SRC=192.168.3.101 DST=192.168.11.2 LEN=64 TOS=0x00 PREC=0x00
TTL=59 ID=24577 DF PROTO=TCP SPT=22 DPT=51213 WINDOW=49232 RES=0x00 ACK
SYN URGP=0 MARK=0x46c0c046
Jul 28 18:34:23 cap-x2100m2-01 kernel: marked_filterIN=eth2.11
OUT=eth1.111 SRC=192.168.11.2 DST=192.168.3.101 LEN=52 TOS=0x00
PREC=0x00 TTL=63 ID=2270 DF PROTO=TCP SPT=51213 DPT=22 WINDOW=33304
RES=0x00 ACK URGP=0 MARK=0x46c0c046
...

[root@cap-x2100m2-01 ~]# grep marked_mangle /var/log/kernel_log.txt
[root@cap-x2100m2-01 ~]#

This is happening in RHEL6.0.

[root@cap-x2100m2-01 proc]# cat /proc/version
Linux version 2.6.32-71.el6.x86_64
(mockbuild@x86-007.build.bos.redhat.com) (gcc version 4.4.4 20100726
(Red Hat 4.4.4-13) (GCC) ) #1 SMP Wed Sep 1 01:33:01 EDT 2010
[root@cap-x2100m2-01 proc]#

It would seem that using the match extension "mark match !0x0/0xfff"
works in the filter table but not in the mangle table. I expected it to
work the same in both.

Is this by design, is this a bug, or I am missing something more
fundamental here?

Thanks,

Jeff Haran



