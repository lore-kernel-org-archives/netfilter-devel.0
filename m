From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: libnfnetlink list of interfaces
Date: Sat, 3 Oct 2009 10:08:00 +0400
Message-ID: <17010436980.20091003100800@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward9.yandex.ru ([77.88.61.48]:48823 "EHLO
	forward9.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZJCGKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:10:04 -0400
Received: from smtp7.yandex.ru (smtp7.yandex.ru [77.88.61.55])
	by forward9.yandex.ru (Yandex) with ESMTP id C23CA46855D
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2009 10:04:48 +0400 (MSD)
Received: from www1.firststeps.ru (unknown [212.45.5.114])
	by smtp7.yandex.ru (Yandex) with ESMTPA id 9C3051CF8171
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2009 10:04:47 +0400 (MSD)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I use nlif_index2name() to get interfaces list in my programm.
After uptime 44 days and many reconnections by vtund i can't
get tun/tap interfaces numbers.

For example output of iftest (example in nfnetlink library):

root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./iftest
index (1) is lo (RUNNING)
index (2) is eth0 (RUNNING)
index (3) is eth1 (RUNNING)
index (4) is eth2 (NOT RUNNING)
index (5) is eth3 (RUNNING)
index (6) is teql0 (NOT RUNNING)
index (7) is tunl0 (NOT RUNNING)
index (8) is gre0 (NOT RUNNING)
index (9) is eth0.11 (RUNNING)
index (10) is eth0.14 (RUNNING)
index (11) is eth0.15 (RUNNING)
index (12) is eth0.2 (RUNNING)
index (13) is eth0.5 (RUNNING)

Output by ifconfig:
eth0      Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0:1    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0:2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0:3    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth1      Link encap:Ethernet  HWaddr 00:22:15:39:a3:34
eth2      Link encap:Ethernet  HWaddr 00:22:15:39:a3:35
eth3      Link encap:Ethernet  HWaddr 00:22:15:39:a3:36
eth0.2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.5    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.11   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.14   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.14:1 Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.15   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
lo        Link encap:Local Loopback
tun1      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
tun2      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00


In iftest.c we have:
      for (i=0; i<64; i++) {
            char name[IFNAMSIZ];
            unsigned int flags;

            if (nlif_index2name(h, i, name) == -1)
                  continue;
            if (nlif_get_ifflags(h, i, &flags) == -1)
                  continue;
            printf("index (%d) is %s (%s)\n", i, name,
                  flags & IFF_RUNNING ? "RUNNING" : "NOT RUNNING");
      }

Only 64 interfaces numbers checked. It mean that tun ifaces have
number greater than 64.

I think libnfnetlink need better way to get list of interfaces,
better than stupid checking random number by nlif_index2name.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Kuzin Andrey  -  kuzinandrey@yandex.ru
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


