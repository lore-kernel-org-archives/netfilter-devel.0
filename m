From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: [IMPORTANT] !!! tun ifaces don't visible by nfnetlink library
Date: Thu, 18 Feb 2010 09:14:04 +0300
Message-ID: <1012927142.20100218091404@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward12.mail.yandex.net ([95.108.130.94]:32895 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0BRGPc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 01:15:32 -0500
Received: from smtp3.mail.yandex.net (smtp3.mail.yandex.net [77.88.46.103])
	by forward12.mail.yandex.net (Yandex) with ESMTP id 951AC15D07FF
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 09:10:26 +0300 (MSK)
Received: from dron (unknown [212.45.5.114])
	by smtp3.mail.yandex.net (Yandex) with ESMTPA id 561828B80D1
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 09:10:26 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello! I wrote about this problem later, but no any effect.
Kernel somewhere or nfnetlink library has error.
In kernel 2.6.27.x all forking fine.
In kernel 2.6.30.5 only latest up tun iface was visible.
Now i use kernel 2.6.32.3 and all tun ifaces become invisible. 

root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# gcc iftest.c -lnfnetlink
root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./a.out
index (1) is lo (RUNNING)
index (2) is eth0 (RUNNING)
index (3) is eth1 (RUNNING)
index (4) is eth2 (RUNNING)
index (5) is eth3 (RUNNING)
index (6) is teql0 (NOT RUNNING)
index (7) is tunl0 (NOT RUNNING)
index (8) is gre0 (NOT RUNNING)
index (9) is eth0.11 (RUNNING)
index (10) is eth0.14 (RUNNING)
index (11) is eth0.15 (RUNNING)
index (12) is eth0.2 (RUNNING)
index (13) is eth0.3 (RUNNING)

iftest output ifaces with index from 0 to 64.

Here is ifaces list by ifconfig
---------------------------------
root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ifconfig | grep Link
eth0      Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth1      Link encap:Ethernet  HWaddr 00:22:15:39:a3:34
eth2      Link encap:Ethernet  HWaddr 00:22:15:39:a3:35
eth3      Link encap:Ethernet  HWaddr 00:22:15:39:a3:36
eth0.2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.3    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.5    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.11   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.14   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
eth0.15   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
lo        Link encap:Local Loopback
tun1      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
tun2      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00

In my program uses NFQUEUE packets from tun1 and tun2 coming
with indexex 14 and 17. But iftest not output any information
about this (and such code in my program).
I don't know another way to get name of iface by his index.

Thanks !

