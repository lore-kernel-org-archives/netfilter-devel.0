From: Patrick McHardy <kaber@trash.net>
Subject: Re: [IMPORTANT] !!! tun ifaces don't visible by nfnetlink library
Date: Thu, 18 Feb 2010 18:07:11 +0100
Message-ID: <4B7D73BF.4070908@trash.net>
References: <1012927142.20100218091404@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab0BRRHN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:07:13 -0500
In-Reply-To: <1012927142.20100218091404@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kuzin Andrey wrote:
> Hello! I wrote about this problem later, but no any effect.
> Kernel somewhere or nfnetlink library has error.
> In kernel 2.6.27.x all forking fine.
> In kernel 2.6.30.5 only latest up tun iface was visible.
> Now i use kernel 2.6.32.3 and all tun ifaces become invisible. 
> 
> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# gcc iftest.c -lnfnetlink
> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ./a.out
> index (1) is lo (RUNNING)
> index (2) is eth0 (RUNNING)
> index (3) is eth1 (RUNNING)
> index (4) is eth2 (RUNNING)
> index (5) is eth3 (RUNNING)
> index (6) is teql0 (NOT RUNNING)
> index (7) is tunl0 (NOT RUNNING)
> index (8) is gre0 (NOT RUNNING)
> index (9) is eth0.11 (RUNNING)
> index (10) is eth0.14 (RUNNING)
> index (11) is eth0.15 (RUNNING)
> index (12) is eth0.2 (RUNNING)
> index (13) is eth0.3 (RUNNING)
> 
> iftest output ifaces with index from 0 to 64.
> 
> Here is ifaces list by ifconfig
> ---------------------------------
> root@banana:/tmp/tgz/libnfnetlink-1.0.0/utils# ifconfig | grep Link
> eth0      Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth1      Link encap:Ethernet  HWaddr 00:22:15:39:a3:34
> eth2      Link encap:Ethernet  HWaddr 00:22:15:39:a3:35
> eth3      Link encap:Ethernet  HWaddr 00:22:15:39:a3:36
> eth0.2    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth0.3    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth0.5    Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth0.11   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth0.14   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> eth0.15   Link encap:Ethernet  HWaddr 00:22:15:39:a3:33
> lo        Link encap:Local Loopback
> tun1      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
> tun2      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
> 
> In my program uses NFQUEUE packets from tun1 and tun2 coming
> with indexex 14 and 17. But iftest not output any information
> about this (and such code in my program).
> I don't know another way to get name of iface by his index.

I can't reproduce this hear with tap devices. Please try to
figure out whether there are no netlink messages for these
devices or whether userspace ignores them.
