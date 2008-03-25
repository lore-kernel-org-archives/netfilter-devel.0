From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: ebtables and iptables different behavior between 2.6.18 on fc6
 and 2.6.23 on fc8
Date: Tue, 25 Mar 2008 03:28:52 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33783 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYCYC2y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:28:54 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2008-03-25 02:18, Greg Scott wrote:

> This issue cost me most of a night's sleep and it will take me a few
> paragraphs to describe.  The one sentence summary is, marking packets
> with ebtables and reading later with iptables seems to behave
> differently with 2.6.23 than it did with 2.6.18 and earlier.
>
> I put together a firewall system based on fc8 and the RedHat kernel that
> ships with fc8.  I think this one is 2.6.23-2.  My previous latest and
> greatest was with a 2.6.18 variant that shipped with fc6.
>
> This config requires that I bridge.  I need to bridge because I have
> various H.323 videoconference codecs behind the firewall system and some
> of these, especially older ones, do not work very well with NAT.  The
> other choice besides bridging is proxy ARP, but I learned the hard way
> that proxy ARP is horrible in colocation situations.  So I need to
> bridge.
>
> But I also need NAT to handle traditional PCs and other stuff behind the
> firewall.
>
> To make this work, I need to know which way packets are headed.  I need
> to know on which interface packets come in, and which interface they go
> out.  This is easy with routing, more challenging with bridging.
> iptables had a facility that would let me test --physdev with bridged
> packets.  It might still be there but I remember reading a discussion
> about how this violated layering and would not be supported long term.

It still is, and I do not think it will change.
And actually, it is pretty easy, in two rules, unless I made a mistake 
somewhere:

 	# obviously bridged
 	iptables -t mangle -A FORWARD -i br0 -o br0 -j MARK --set-mark 111
 	(Or equivalently: ebtables -t filter -A FORWARD -p ipv4 -j mark
 	--set-mark 111)

 	# snat non-bridged
 	iptables -t nat -A POSTROUTING -o br0 -m physdev --physdev-out eth0
 		-m mark ! --mark 111 -j SNAT ...


> None of my packets that were supposed to have that "3" mark ever kept
> them.  For some reason, they either never were marked or they were
> marked and then the mark disappeared.

I can reproduce it. Testcase is actually a two-liner:

 	ebtables -A OUTPUT -o eth0 -j mark --set-mark 99
 	iptables -t mangle -A POSTROUTING -o br0 -j LOGMARK

LOGMARK (yay - this target really seems to show off :^)  tells me:

 	[214558.490202] nfmark=0x0 secmark=0x0 classify=0x2
 	ct=0xede74954 ctmark=0x0 ctstate=ESTABLISHED
 	ctstatus=,SEEN_REPLY,ASSURED,CONFIRMED

Now that is indeed interesting. I had this thought, maybe the mark does 
not disappear, maybe ebtables is run -- contrary to most graphics 
depicting the netfilter flow -- _after_ iptables. So I tried:

 	iptables -t mangle -A POSTROUTING -j LOG --log-prefix "[ipt] " -d 134.76.13.21
 	ebtables -A OUTPUT -p ipv4 --ip-destination 134.76.13.21 --log --log-prefix "[ebt] "

with the result of:

 	[214961.190130] [ipt] IN= OUT=br0 SRC=10.10.106.161 DST=134.76.13.21
 	LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0
 	ID=59252 SEQ=1

 	[214961.190186] [ebt]  IN= OUT=sis0 MAC source = 00:0a:e6:98:ed:d7 MAC
 	dest = 68:a8:3e:d3:d0:fb proto = 0x0800

which means ebtables actually comes after iptables, and hence, your mark 
3 will not show up as you expected.


> So my questions - what changed with the interaction betweem iptables and
> ebtables?

I'm going to figure out now...

