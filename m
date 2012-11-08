From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Thu, 8 Nov 2012 21:40:23 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211082055570.29371@nerf07.vanv.qr>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:39427 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2KHUkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:40:25 -0500
In-Reply-To: <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-11-08 19:37, Chris Wilson wrote:
>
>> You can remove "old" NFCT entries by use of conntrack(8) if you the time
>> between preferred_lft and valid_lft running out is too short.
>
> Unfortunately I don't think conntrack works on the CentOS 5 kernel (2.6.18).
> Perhaps it's just too old, but it's widely used, and other 2.6.x kernels are
> widely used on routers too.

RHEL and its derivates do not really care about NF software.
Wide use is not going to fix that. (And that's why Windows
is considered an even greater mess ;)

>> An operating system can therefore never automatically know whether
>> it is ok to continue using certain tuples over a link or not, unless
>> the user intervenes in some way.
>
> I think it would rarely be acceptable to send a packet out of the wrong
> interface that doesn't match the source address (AB and BA in your matrix).

It is a standard practice that {the default gateway of one's
equipment} [=the first node on ISP's territory] and your own
subnet make a disjoint set.

$ ip r
2a01:4f8:161:3a0::1 dev eth0  metric 1024
2a01:4f8:161:fff::/64 dev eth1  proto kernel  metric 256 
default via 2a01:4f8:161:3a0::1 dev eth0  metric 1024 
$ ip -6 a
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    inet6 2a01:4f8:161:fff::1/128 scope global 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 500
    inet6 2a01:4f8:161:fff::1/64 scope global 
       valid_lft forever preferred_lft forever

(This similarly works for IPv4.)


> Even a default-off MASQUERADE flag that says "--update-source-address" would
> give us the option to have this fixed automatically, provided that people know
> about the flag and use it.

I'll leave this to the nf_nat maintainer(s) and what direction it
should go.
