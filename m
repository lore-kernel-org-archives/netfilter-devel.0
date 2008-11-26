From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Wed, 26 Nov 2008 17:25:13 +0100
Message-ID: <492D7869.6090808@trash.net>
References: <op.uky4wc2dqigx4y@cyprus.local> <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr> <op.ukze8tjtqigx4y@cyprus.local> <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr> <op.uk6pzalwqigx4y@cyprus.local> <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr> <op.uk6vd0boqigx4y@cyprus.local> <alpine.LNX.1.10.0811261711080.2741@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Wu <davidwu@arcturusnetworks.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61912 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYKZQZZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:25:25 -0500
In-Reply-To: <alpine.LNX.1.10.0811261711080.2741@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> (Patrick, try not to screw up utf-8 in the git log too often ;-)

If you try not to use it at every possible opportunity ... :)

> commit 3430170eca6bf73b590ddbd1a1ee0573862ff555
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Nov 26 17:13:57 2008 +0100
>=20
> libiptc: guard chain index allocation for different malloc implementa=
tions
>=20
> Some libc implementations such as =B5Clibc return NULL on malloc(0).
> They are free to do that per C standard.

Applied, thanks.

That behaviour is a bit stupid in my opinion though, it puts the burden
on every caller using dynamically calculated sizes. I would expect more
things to break from this.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
