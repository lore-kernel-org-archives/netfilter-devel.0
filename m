From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Building the conntrack rule from scratch
Date: Thu, 27 Nov 2008 00:05:18 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811270003121.21265@fbirervta.pbzchgretzou.qr>
References: <492DC363.3040304@astrocorp.com> <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr> <492DD46A.7000209@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55748 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYKZXFU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:05:20 -0500
In-Reply-To: <492DD46A.7000209@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-26 23:57, Bryan Duff wrote:

> Here is the rule:
>
> conntrack -I --orig-src 192.168.10.10 --orig-dst 192.168.2.206 --reply-src
> 192.168.2.206 --reply-dst 192.168.2.204 -p udp --orig-port-src 5000
> --orig-port-dst 7002 --reply-port-src 7002 --reply-port-dst 7000 -u ASSURED -t
> 60
>
> 192.168.10.10 is the phone in my LAN.
> 192.168.2.204 is the local WAN address.
> 192.168.2.206 is the remote address.
>
> If that above rule is inserted, and I send traffic (that matches the rule) out
> the WAN from the LAN, why would it not SNAT the rule on the way out  (from
> orig-src  192.168.10.10  to reply-dst 192.168.2.204)?

You just set up a NAT mapping and even marked it ASSURED,
so no further mapping modifications are accepted.

> iptables -t nat -A POSTROUTING -o eth1 -s 192.168.10.1/24 -m realm --realm 1 -j
> SNAT --to 192.168.2.204
