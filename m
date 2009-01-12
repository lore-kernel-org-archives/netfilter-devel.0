From: Patrick McHardy <kaber@trash.net>
Subject: Re: multicast forwarding
Date: Mon, 12 Jan 2009 06:08:08 +0100
Message-ID: <496AD038.4090904@trash.net>
References: <1228160659.8392.94.camel@irbt-1279>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Kaplowitz, David" <dkaplowitz@irobot.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55530 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZALFIX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:08:23 -0500
In-Reply-To: <1228160659.8392.94.camel@irbt-1279>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kaplowitz, David wrote:
> Greetings,
>=20
> I have an interesting difficulty.  I want to be able to grab a multic=
ast
> stream from a machine (192.168.12.13) and forward/rebroadcast/rewrite
> it, such that the packets seem to come from my DMZ host (192.168.12.1=
2).
>=20
> I have been trying an iptables solution, but that doesn't seem to be
> working at the moment, and it was recommended to me by =EF=BB=BFj_eng=
elh on the
> #iptables channel to ask at this address for further assistance.

stateless NAT using the TC NAT action might work.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
