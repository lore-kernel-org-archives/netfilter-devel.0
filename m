From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 13:07:19 +0100
Message-ID: <4CD2A1F7.80106@plouf.fr.eu.org>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <alpine.LNX.2.01.1011040943200.4050@obet.zrqbmnf.qr> <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:54883 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0KDMHW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:07:22 -0400
In-Reply-To: <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

H. Peter Anvin a =E9crit :
> Guess what... other services like DNS needs to deal with this too,
> and so far has not; this is part of what needs to happen before nontr=
ivial scale
> IPv6 deployment happens...

In this case, wouldn't a daemon listening for address changes and
managing all related operations such as ruleset or DNS updates, as
someone suggested in this thread, be a more generic approach ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
