From: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Advice requested: de-masquerading from a qdisc?
Date: Tue, 28 Jun 2016 15:32:07 +0100
Message-ID: <57728A67.2090708@darbyshire-bryant.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-am1on0086.outbound.protection.outlook.com ([157.56.112.86]:60544
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752503AbcF1UJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jun 2016 16:09:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

First post and I'm very much in a position of not knowing what I don't 
know, so be relatively gentle if you can :-)

So, the basic question first:  Is it possible to access the NAT tables 
to de-masquerade a packet from a qdisc?

Longer question/background:  I'm slightly involved in a qdisc AQM 
project (cake) that amongst other things has 'per host' flow grouping 
modes.  Typically 2 qdiscs are instantiated, one on the WAN interface 
for egress traffic and another on a WAN IFB interface for ingress.  This 
is all fine for IPv6, but in typical usage where IPv4 masquerading is 
involved, the only host the ingress qdisc sees is the router's public 
IPv4.  Similarly the egress qdisc doesn't see the internal LAN addresses 
as it's all post NAT.

All I have in the qdisc is the skb...and it looks like the pointer to 
the nfct structure can help me but.....I'm really at the starting end of 
a learning vertical cliff.  Where should I start reading? :-)

Thanks for your time,

Kevin


