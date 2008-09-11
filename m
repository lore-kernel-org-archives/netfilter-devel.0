From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RAWNAT problem
Date: Thu, 11 Sep 2008 10:02:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809110925360.16098@fbirervta.pbzchgretzou.qr>
References: <48C91C06.4050201@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35100 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYIKOCg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:02:36 -0400
In-Reply-To: <48C91C06.4050201@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-11 09:24, Manu wrote:
>
> Jan, thank you for fixing the RAWNAT targets in xtables-addons!!! It works very
> well, without any crashes!

Not that I remember having made any significant changes
other than rebasing, but thanks ;-)

> For my issue ( I want to exchange the source address for incoming pakets, and
> to exchange the destination address for outgoing pakets) I modified the
> xt_RAWNAT.c like that:
>
> function: static unsigned int rawsnat_tg4
> ...
> //      na  = remask(iph->saddr, info->addr.ip, info->mask);
>       na = info->addr.ip;
> ...

Ok I fixed a slight calculation error in remask() that should
make this unnecessary now.

>rules in PC1:
>iptables:
>iptables -t raw -I PREROUTING -i eth1 -s 192.168.150.111 -j RAWSNAT --to-source 10.0.12.2                                                           
>and                                                                             
>iptables -t rawpost -I POSTROUTING -o eth1 -d 10.0.12.2 -j RAWDNAT --to-destination 192.168.150.111
>
> Ping works fine, but if I open a browser, I didn't get the web-page displayed.
> In my iptables nat rules I set a rule to redirect requests for port 53 to local
> process! But these requests went into FORWARD chain of mangle table?! Is there
> a problem with connection tracking?!

You also need a rule in the OUTPUT chain of the raw table
if you are initiating connections from the machine itself.
libxt_RAWSNAT.man has been updated with this info.
