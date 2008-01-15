From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: snat local packets and arp
Date: Tue, 15 Jan 2008 17:40:27 +0100
Message-ID: <BAY103-DAV6A7F9ABB20DF8DAD84D17B2470@phx.gbl>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl> <478CD804.4060309@trash.net> <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl> <478CE022.8060703@trash.net>
Cc: <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc3-s36.bay0.hotmail.com ([65.54.246.236]:2702 "EHLO
	bay0-omc3-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbYAOQkg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:40:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:

> Marco Berizzi wrote:
> > Patrick McHardy wrote:
> >
> >>> Running ping adsl.129 stop linux from arping the
> >>> adsl.129 router.
> >> I don't get it. You say this box is using adsl.129 as
> >> nexthop for the locally generated squid packets.
> >
> > Yes I'm using this dirty trick:
> >
> > iptables -t mangle -I PREROUTING ... --dports 80,443 -j MARK
> > --set-mark 1
> > ip rule add fwmark 1 table adsl prio 400
> >
> > #ip route sh table adsl
> > default via adsl.129 dev eth0
> >
> >> So whats wrong with sending arp queries for that router?
> >
> > I don't understand why it is sending arp queries for
> > the adsl router every minute and it doesn't send a single
> > arp query for hours to the other hdsl router.
>
> Do the routers send arp queries to the Linux box?

Honestly, I don't know. This is the output running
tcpdump -pnvi eth0 arp

10:54:11.787680 : arp who-has adsl.129 tell adsl.134
10:54:11.788293 : arp reply adsl.129 is-at 00:1b:...
10:54:34.580798 : arp who-has adsl.129 tell adsl.134
10:54:34.581441 : arp reply adsl.129 is-at 00:1b:...
10:55:17.420198 : arp who-has adsl.129 tell adsl.134
10:55:17.420836 : arp reply adsl.129 is-at 00:1b:...
10:56:00.552606 : arp who-has adsl.129 tell adsl.134
10:56:00.553231 : arp reply adsl.129 is-at 00:1b:...

I only see the linux box quering the cisco and not
viceversa. AFAIK the cisco has been configured by
the ISP with very high timeout for the arp cache.

PS: The linux is 2.6.23 with default option except
arp_filter/rp_filter/proxy_arp set to 1 on eth0


