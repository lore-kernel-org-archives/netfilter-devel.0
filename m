From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of
 the connection tracking tuple for bridged traffic
Date: Wed, 31 Mar 2010 12:17:06 +0200
Message-ID: <4BB32122.8070101@plouf.fr.eu.org>
References: <4BB207B5.2020001@pandora.be> <1269962855.10116.15.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64878 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab0CaKRJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:17:09 -0400
In-Reply-To: <1269962855.10116.15.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet a =E9crit :
>=20
> This really sounds very strange, layering violation or something.

Isn't the whole bridge-netfilter concept already a layering violation b=
y
design ?

> You mix conntracking, bridge and vlan here.
>=20
> Why setups without bridge should not care of vlan + conntracking side
> effects ?

Because without bridge, the host is attached at the IP layer level to
the VLANs, so their IP ranges are not supposed to overlap.

Anyway your objection applies to hosts with multiple bridges without
VLAN so the bridges may see overlapping IP ranges. Conntrack zones with
a dedicated target seems a more generic approach.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
