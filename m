From: Patrick McHardy <kaber@trash.net>
Subject: Re: snat local packets and arp
Date: Tue, 15 Jan 2008 17:42:45 +0100
Message-ID: <478CE285.8050900@trash.net>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl> <478CD804.4060309@trash.net> <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl> <478CE022.8060703@trash.net> <BAY103-DAV6A7F9ABB20DF8DAD84D17B2470@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYAOQm7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:42:59 -0500
In-Reply-To: <BAY103-DAV6A7F9ABB20DF8DAD84D17B2470@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marco Berizzi wrote:
>> Do the routers send arp queries to the Linux box?
> 
> Honestly, I don't know. This is the output running
> tcpdump -pnvi eth0 arp
> 
> 10:54:11.787680 : arp who-has adsl.129 tell adsl.134
> 10:54:11.788293 : arp reply adsl.129 is-at 00:1b:...
> 10:54:34.580798 : arp who-has adsl.129 tell adsl.134
> 10:54:34.581441 : arp reply adsl.129 is-at 00:1b:...
> 10:55:17.420198 : arp who-has adsl.129 tell adsl.134
> 10:55:17.420836 : arp reply adsl.129 is-at 00:1b:...
> 10:56:00.552606 : arp who-has adsl.129 tell adsl.134
> 10:56:00.553231 : arp reply adsl.129 is-at 00:1b:...
> 
> I only see the linux box quering the cisco and not
> viceversa. AFAIK the cisco has been configured by
> the ISP with very high timeout for the arp cache.
> 
> PS: The linux is 2.6.23 with default option except
> arp_filter/rp_filter/proxy_arp set to 1 on eth0


Try disabling rp_filter, that should make it behave similar
for both addresses. With rp_filter, the input routing done
by arp.c fails because the mark is different and it doesn't
go to your special routing table, so it doesn't update the
cache from arp queries from that router.
