From: Patrick McHardy <kaber@trash.net>
Subject: Re: snat local packets and arp
Date: Tue, 15 Jan 2008 16:57:56 +0100
Message-ID: <478CD804.4060309@trash.net>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43310 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYAOP6K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:58:10 -0500
In-Reply-To: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marco Berizzi wrote:
> Hello everybody.
> I have configured a linux 2.6.23 box with two ip
> addresses on a single interface:
> 
> # ip a s dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
>     link/ether 00:30:05:cb:27:c1 brd ff:ff:ff:ff:ff:ff
>     inet hdsl.254/27 brd hdsl.255 scope global eth0
>     inet adsl.134/29 brd adsl.135 scope global eth0
> 
> This box is running squid as a proxy server. The
> default gateway is hdsl.225
> Locally generated packets from squid are snated with
> adsl.134 and then they are market so they are forwarded
> to the adsl router (adsl.129).
> There is always (one/second) packet flow between both
> the cisco routers (hdsl.225 and adsl.129) and the
> linux box.
> But linux is arping every few seconds the adsl.129
> router:
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
> It is like linux doesn't undestand it is using
> also the adsl.129, because it is generating packets
> with source ip=hdsl.254 and then I snat them with
> adsl.134 in the postrouting chain.
> 
> Is this behaviour expected?
> 
> Running ping adsl.129 stop linux from arping the
> adsl.129 router.

I don't get it. You say this box is using adsl.129 as
nexthop for the locally generated squid packets.
So whats wrong with sending arp queries for that router?

