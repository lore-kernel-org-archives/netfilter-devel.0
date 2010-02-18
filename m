From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re[2]: [IMPORTANT] !!! tun ifaces don't visible by nfnetlink library
Date: Thu, 18 Feb 2010 23:00:43 +0300
Message-ID: <1882621284.20100218230043@yandex.ru>
References: <1012927142.20100218091404@yandex.ru> <4B7D73BF.4070908@trash.net>
 <alpine.LSU.2.01.1002181819500.5999@obet.zrqbmnf.qr>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward15.mail.yandex.net ([95.108.130.119]:53429 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab0BRT5N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:57:13 -0500
In-Reply-To: <alpine.LSU.2.01.1002181819500.5999@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>Kuzin Andrey wrote:
>>> Hello! I wrote about this problem later, but no any effect.
>>> Kernel somewhere or nfnetlink library has error.
>>> In kernel 2.6.27.x all forking fine.
>>> In kernel 2.6.30.5 only latest up tun iface was visible.
>>> Now i use kernel 2.6.32.3 and all tun ifaces become invisible. 
>>> 
>>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# gcc iftest.c -lnfnetlink
>>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./a.out
>>> index (1) is lo (RUNNING)
>>> index (2) is eth0 (RUNNING)
>>> index (3) is eth1 (RUNNING)
>>> index (4) is eth2 (RUNNING)
>>> index (5) is eth3 (RUNNING)
>>> index (6) is teql0 (NOT RUNNING)
>>> index (7) is tunl0 (NOT RUNNING)
>>> index (8) is gre0 (NOT RUNNING)
>>> index (9) is eth0.11 (RUNNING)
>>> index (10) is eth0.14 (RUNNING)
>>> index (11) is eth0.15 (RUNNING)
>>> index (12) is eth0.2 (RUNNING)
>>> index (13) is eth0.3 (RUNNING)
>>> 
>>> iftest output ifaces with index from 0 to 64.
>>> 
>>> Here is ifaces list by ifconfig
>>> ---------------------------------
>>> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ifconfig | grep Link
>>> eth0      Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth1      Link encap:Ethernet  HWaddr 00:22:15:39:a3:34
>>> eth2      Link encap:Ethernet  HWaddr 00:22:15:39:a3:35
>>> eth3      Link encap:Ethernet  HWaddr 00:22:15:39:a3:36
>>> eth0.2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth0.3    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth0.5    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth0.11   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth0.14   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> eth0.15   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
>>> lo        Link encap:Local Loopback
>>> tun1      Link encap:UNSPEC  HWaddr
>>> 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
>>> tun2      Link encap:UNSPEC  HWaddr
>>> 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
>>> 
>>> In my program uses NFQUEUE packets from tun1 and tun2 coming
>>> with indexex 14 and 17. But iftest not output any information
>>> about this (and such code in my program).
>>> I don't know another way to get name of iface by his index.
>>
>>I can't reproduce this hear with tap devices. Please try to
>>figure out whether there are no netlink messages for these
>>devices or whether userspace ignores them.

JE> Can't reproduce either. Andrey, also try `ip addr` besides
JE> iftest, just to be really sure.

JE> 18:18 ares:../libnfnetlink/utils # tunctl -t tun0
JE> Set 'tun0' persistent and owned by uid 0
JE> 18:19 ares:../libnfnetlink/utils # tunctl -pt tap0
JE> Set 'tap0' persistent and owned by uid 0
JE> 18:19 ares:../libnfnetlink/utils # ip a
JE> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
JE>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
JE>     inet 127.0.0.1/8 brd 127.255.255.255 scope host lo
JE>     inet 127.0.0.2/8 brd 127.255.255.255 scope host secondary lo
JE>     inet6 ::1/128 scope host 
JE>        valid_lft forever preferred_lft forever
JE> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
JE>     link/ether 00:14:4f:e1:d1:24 brd ff:ff:ff:ff:ff:ff
JE> 3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
JE>     link/ether 00:14:4f:e1:d1:25 brd ff:ff:ff:ff:ff:ff
JE> 4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
JE>     link/ether 00:14:4f:e1:d1:26 brd ff:ff:ff:ff:ff:ff
JE> 5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
JE>     link/ether 00:14:4f:e1:d1:27 brd ff:ff:ff:ff:ff:ff
JE> 6: sit0: <NOARP> mtu 1480 qdisc noop state DOWN 
JE>     link/sit 0.0.0.0 brd 0.0.0.0
JE> 8: tun0: <POINTOPOINT,MULTICAST,NOARP> mtu 1500 qdisc noop state DOWN qlen 500
JE>     link/[65534] 
JE> 9: tap0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 500
JE>     link/ether aa:6d:76:59:17:e7 brd ff:ff:ff:ff:ff:ff
JE> 18:19 ares:../libnfnetlink/utils # ./iftest 
JE> index (1) is lo (RUNNING)
JE> index (2) is eth0 (RUNNING)
JE> index (3) is eth1 (NOT RUNNING)
JE> index (4) is eth2 (NOT RUNNING)
JE> index (5) is eth3 (NOT RUNNING)
JE> index (6) is sit0 (NOT RUNNING)
JE> index (8) is tun0 (NOT RUNNING)
JE> index (9) is tap0 (NOT RUNNING)

Thanks for answer.
This is my 'ip addr' results:
root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
........[skipped].......
12: eth0.2@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc htb state UP
    link/ether 00:22:15:39:a3:33 brd ff:ff:ff:ff:ff:ff
    inet 10.248.249.1/24 brd 10.248.249.255 scope global eth0.2
13: eth0.3@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 00:22:15:39:a3:33 brd ff:ff:ff:ff:ff:ff
    inet 192.168.18.1/24 brd 192.168.18.255 scope global eth0.3
14: eth0.5@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc htb state UP
    link/ether 00:22:15:39:a3:33 brd ff:ff:ff:ff:ff:ff
    inet 10.10.1.1/24 brd 10.10.1.255 scope global eth0.5
17: tun2: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc htb state UNKNOWN qlen 500
    link/[65534]
    inet 10.2.0.3 peer 10.2.0.4/32 scope global tun2
24: tun1: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc htb state UNKNOWN qlen 500
    link/[65534]
    inet 10.2.0.1 peer 10.2.0.2/32 scope global tun1

And 'iftest' results:
root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./iftest
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

Here is no iface eth0.5@eth0=14, and as i see tun ifaces both has
'state UNKNOWN'
I try to modify iftest to find error:

      for (i=0; i<64; i++) {
            char name[IFNAMSIZ];
            unsigned int flags;

            if (nlif_index2name(h, i, name) == -1) {
                  printf("can't get name for index=%d\n",i);
                  continue;
            }
            if (nlif_get_ifflags(h, i, &flags) == -1) {
                  printf("can't get flags for index=%d\n",i);
                  continue;
            }
            printf("index (%d) is %s (%s)\n", i, name,
                  flags & IFF_RUNNING ? "RUNNING" : "NOT RUNNING");
      }

And here is result:
./a.outnana:/tmp/tgz/libnfnetlink-1.0.0/utils#
can't get flags for index=0
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
can't get name for index=14
can't get name for index=15
can't get name for index=16
can't get name for index=17
can't get name for index=18
can't get name for index=19
can't get name for index=20
can't get name for index=21
can't get name for index=22
can't get name for index=23
can't get name for index=24
can't get name for index=25
can't get name for index=26
can't get name for index=27
..........
can't get name for index=62
can't get name for index=63

I know only this way (described in iftest) how to get name of
interface by index. May be another way ?
I try to find source of "ip addr".
But this is strange because in older kernel this code working right.





