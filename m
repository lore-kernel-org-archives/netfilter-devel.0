From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IMPORTANT] !!! tun ifaces don't visible by nfnetlink library
Date: Thu, 18 Feb 2010 18:21:25 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002181819500.5999@obet.zrqbmnf.qr>
References: <1012927142.20100218091404@yandex.ru> <4B7D73BF.4070908@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40558 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab0BRRV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:21:27 -0500
In-Reply-To: <4B7D73BF.4070908@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-18 18:07, Patrick McHardy wrote:

>Kuzin Andrey wrote:
>> Hello! I wrote about this problem later, but no any effect.
>> Kernel somewhere or nfnetlink library has error.
>> In kernel 2.6.27.x all forking fine.
>> In kernel 2.6.30.5 only latest up tun iface was visible.
>> Now i use kernel 2.6.32.3 and all tun ifaces become invisible. 
>> 
>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# gcc iftest.c -lnfnetlink
>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./a.out
>> index (1) is lo (RUNNING)
>> index (2) is eth0 (RUNNING)
>> index (3) is eth1 (RUNNING)
>> index (4) is eth2 (RUNNING)
>> index (5) is eth3 (RUNNING)
>> index (6) is teql0 (NOT RUNNING)
>> index (7) is tunl0 (NOT RUNNING)
>> index (8) is gre0 (NOT RUNNING)
>> index (9) is eth0.11 (RUNNING)
>> index (10) is eth0.14 (RUNNING)
>> index (11) is eth0.15 (RUNNING)
>> index (12) is eth0.2 (RUNNING)
>> index (13) is eth0.3 (RUNNING)
>> 
>> iftest output ifaces with index from 0 to 64.
>> 
>> Here is ifaces list by ifconfig
>> ---------------------------------
>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ifconfig | grep Link
>> eth0      Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth1      Link encap:Ethernet  HWaddr 00:22:15:39:a3:34
>> eth2      Link encap:Ethernet  HWaddr 00:22:15:39:a3:35
>> eth3      Link encap:Ethernet  HWaddr 00:22:15:39:a3:36
>> eth0.2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth0.3    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth0.5    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth0.11   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth0.14   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> eth0.15   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>> lo        Link encap:Local Loopback
>> tun1      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
>> tun2      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
>> 
>> In my program uses NFQUEUE packets from tun1 and tun2 coming
>> with indexex 14 and 17. But iftest not output any information
>> about this (and such code in my program).
>> I don't know another way to get name of iface by his index.
>
>I can't reproduce this hear with tap devices. Please try to
>figure out whether there are no netlink messages for these
>devices or whether userspace ignores them.

Can't reproduce either. Andrey, also try `ip addr` besides
iftest, just to be really sure.

18:18 ares:../libnfnetlink/utils # tunctl -t tun0
Set 'tun0' persistent and owned by uid 0
18:19 ares:../libnfnetlink/utils # tunctl -pt tap0
Set 'tap0' persistent and owned by uid 0
18:19 ares:../libnfnetlink/utils # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo
    inet 127.0.0.2/8 brd 127.255.255.255 scope host secondary lo
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 00:14:4f:e1:d1:24 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:14:4f:e1:d1:25 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:14:4f:e1:d1:26 brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:14:4f:e1:d1:27 brd ff:ff:ff:ff:ff:ff
6: sit0: <NOARP> mtu 1480 qdisc noop state DOWN 
    link/sit 0.0.0.0 brd 0.0.0.0
8: tun0: <POINTOPOINT,MULTICAST,NOARP> mtu 1500 qdisc noop state DOWN qlen 500
    link/[65534] 
9: tap0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 500
    link/ether aa:6d:76:59:17:e7 brd ff:ff:ff:ff:ff:ff
18:19 ares:../libnfnetlink/utils # ./iftest 
index (1) is lo (RUNNING)
index (2) is eth0 (RUNNING)
index (3) is eth1 (NOT RUNNING)
index (4) is eth2 (NOT RUNNING)
index (5) is eth3 (NOT RUNNING)
index (6) is sit0 (NOT RUNNING)
index (8) is tun0 (NOT RUNNING)
index (9) is tap0 (NOT RUNNING)
