From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: snat local packets and arp
Date: Wed, 16 Jan 2008 09:46:40 +0100
Message-ID: <BAY103-DAV736E490B7718BC608943EB2400@phx.gbl>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl> <478CD804.4060309@trash.net> <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl> <478CE022.8060703@trash.net> <BAY103-DAV6A7F9ABB20DF8DAD84D17B2470@phx.gbl> <478CE285.8050900@trash.net>
Cc: <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc3-s39.bay0.hotmail.com ([65.54.246.239]:37197 "EHLO
	bay0-omc3-s39.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbYAPIqv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:46:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:


> Marco Berizzi wrote:
> >> Do the routers send arp queries to the Linux box?
> >
> > Honestly, I don't know. This is the output running
> > tcpdump -pnvi eth0 arp
> >
> > 10:54:11.787680 : arp who-has adsl.129 tell adsl.134
> > 10:54:11.788293 : arp reply adsl.129 is-at 00:1b:...
> > 10:54:34.580798 : arp who-has adsl.129 tell adsl.134
> > 10:54:34.581441 : arp reply adsl.129 is-at 00:1b:...
> > 10:55:17.420198 : arp who-has adsl.129 tell adsl.134
> > 10:55:17.420836 : arp reply adsl.129 is-at 00:1b:...
> > 10:56:00.552606 : arp who-has adsl.129 tell adsl.134
> > 10:56:00.553231 : arp reply adsl.129 is-at 00:1b:...
> >
> > I only see the linux box quering the cisco and not
> > viceversa. AFAIK the cisco has been configured by
> > the ISP with very high timeout for the arp cache.
> >
> > PS: The linux is 2.6.23 with default option except
> > arp_filter/rp_filter/proxy_arp set to 1 on eth0
>
>
> Try disabling rp_filter, that should make it behave similar
> for both addresses. With rp_filter, the input routing done
> by arp.c fails because the mark is different and it doesn't
> go to your special routing table, so it doesn't update the
> cache from arp queries from that router.

Done (echo 0 > /proc/sys/net/ipv4/conf/eth0 && ip route
flush cache), but no luck: same behaviour. Now only
arp_filter and proxy_arp are set to one on eth0. Here
is a capture taken few minuted ago:

09:25:30.784282 IP (tos 0x0, ttl  51, id 45968, offset 0, flags [none],
length: 675) 72.14.221.18.80 > adsl.134.45712: P 4827:5450(623) ack 1835
win 11344 <nop,nop,timestamp 1942678180 568666441>
09:25:30.785267 IP (tos 0x0, ttl  64, id 36780, offset 0, flags [DF],
length: 52) adsl.134.45712 > 72.14.221.18.80: . [tcp sum ok] ack 5450
win 2525 <nop,nop,timestamp 568666460 1942678180>
09:25:34.346859 arp who-has adsl.129 tell adsl.134
09:25:34.347517 arp reply adsl.129 is-at 00:1b:90:c8:06:b8


