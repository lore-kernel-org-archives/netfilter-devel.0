From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 07/07]: ebt_arp: fix --arp-gratuitous matching
 dependence on --arp-ip-{src,dst}
Date: Mon, 05 Nov 2007 21:00:01 -0800 (PST)
Message-ID: <20071105.210001.32496780.davem@davemloft.net>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
	<20071102112009.22803.31470.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45743
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756445AbXKFFAC convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:00:02 -0500
In-Reply-To: <20071102112009.22803.31470.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: Patrick McHardy <kaber@trash.net>
Date: Fri,  2 Nov 2007 12:23:20 +0100 (MET)

> [NETFILTER]: ebt_arp: fix --arp-gratuitous matching dependence on --a=
rp-ip-{src,dst}
>=20
> Fix --arp-gratuitous matching dependence on --arp-ip-{src,dst}
>=20
> Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
> Signed-off-by: Lutz Pre=DFler <Lutz.Pressler@SerNet.DE>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
