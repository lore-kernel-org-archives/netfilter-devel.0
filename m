From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: snat local packets and arp
Date: Tue, 15 Jan 2008 17:22:07 +0100
Message-ID: <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl> <478CD804.4060309@trash.net>
Cc: <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc1-s18.bay0.hotmail.com ([65.54.246.90]:40551 "EHLO
	bay0-omc1-s18.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYAOQWP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:22:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:

> Marco Berizzi wrote:
> > Hello everybody.
> > I have configured a linux 2.6.23 box with two ip
> > addresses on a single interface:
> >
> > # ip a s dev eth0
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
> >     link/ether 00:30:05:cb:27:c1 brd ff:ff:ff:ff:ff:ff
> >     inet hdsl.254/27 brd hdsl.255 scope global eth0
> >     inet adsl.134/29 brd adsl.135 scope global eth0
> >
> > This box is running squid as a proxy server. The
> > default gateway is hdsl.225
> > Locally generated packets from squid are snated with
> > adsl.134 and then they are market so they are forwarded
> > to the adsl router (adsl.129).
> > There is always (one/second) packet flow between both
> > the cisco routers (hdsl.225 and adsl.129) and the
> > linux box.
> > But linux is arping every few seconds the adsl.129
> > router:
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
> > It is like linux doesn't undestand it is using
> > also the adsl.129, because it is generating packets
> > with source ip=hdsl.254 and then I snat them with
> > adsl.134 in the postrouting chain.
> >
> > Is this behaviour expected?
> >
> > Running ping adsl.129 stop linux from arping the
> > adsl.129 router.
>
> I don't get it. You say this box is using adsl.129 as
> nexthop for the locally generated squid packets.

Yes I'm using this dirty trick:

iptables -t mangle -I PREROUTING ... --dports 80,443 -j MARK
--set-mark 1
ip rule add fwmark 1 table adsl prio 400

#ip route sh table adsl
default via adsl.129 dev eth0

> So whats wrong with sending arp queries for that router?

I don't understand why it is sending arp queries for
the adsl router every minute and it doesn't send a single
arp query for hours to the other hdsl router.


