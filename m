From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 11:22:25 +0200
Message-ID: <471F0ED1.202@plouf.fr.eu.org>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0597.4030203@plouf.fr.eu.org> <471F0D18.1030606@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:50647 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbXJXJW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:22:27 -0400
In-Reply-To: <471F0D18.1030606@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Philip Craig a =E9crit :
> Pascal Hambourg wrote:
>=20
>>Do you mean that the "bridged" flag (or whatever way this is=20
>>implemented) is not reset when the packet is routed ? Doesn't this so=
und=20
>>like a bug ?
>=20
> It's not set at all for routed packets, which is correct behaviour.

Sure, but what about packets that enter a bridged interface and then ar=
e=20
routed ?
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
