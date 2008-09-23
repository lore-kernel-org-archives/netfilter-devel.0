From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Kernel netfilter and iptables gateway extension patch
Date: Tue, 23 Sep 2008 11:01:32 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809231057550.22542@fbirervta.pbzchgretzou.qr>
References: <48D8F008.7040602@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45175 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYIWPBe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:01:34 -0400
In-Reply-To: <48D8F008.7040602@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-23 09:32, Bryan Duff wrote:

> From the manpage:
>
> +This matches the gateway by IP address on routed packets.
> +It does not match packets that are not routed, or which
> +are directly addresses to the gateway.
>
> With this patch it doesn't work quite like that.  It now matches 
> packets that are "directly addresses to the gateway".  Because 
> frankly, why not?  Otherwise those addresses are missed, and it 
> requires more rules.  It also changes the iptables interface to allow 
> the specifying of a mask on the cli.
>
> //e.g. (assume my interface is 192.168.1.100, gateway 192.168.1.1):
> iptables -t mangle -A POSTROUTING -o eth0 -m gateway --gateway 192.168.1.1/24
> //end e.g.
>
> Now any packets routed out eth0 to gateway 192.168.1.1 (or anything on that
> subnet - if I send to 192.168.1.2 - then that is the gateway, and also
> matches).  This is most useful for multi-homed ports.  The gateway and nexthop
> options do the same thing.

It should not. Assuming you have a route "192.168.1.0/24 dev eth0", then 
gateway should be 0.0.0.0 for any packets to 192.168.1.2 and the 
nexthop shoul dbe 192.168.1.2.

For packets going to 123.45.67.89, gateway and nexthop would be 
192.168.1.1.

> I'm not sure if this is useful to anyone but me.  I can clean up the patches
> (fix the man page and whatever else).

No, xt_gateway (you're even using the even-older ipt_gateway) has been 
deprecated a few days after the patch was posted, as you can use routing 
realms to mark based on gateway/nexthop.
