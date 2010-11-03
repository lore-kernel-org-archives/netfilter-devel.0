From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 13:56:45 +0100
Message-ID: <4CD15C0D.7070600@plouf.fr.eu.org>
References: <20101102.135254.226783976.davem@davemloft.net>	<4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58373 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0KCM4u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:56:50 -0400
In-Reply-To: <20101103.051925.193703726.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller a =E9crit :
>=20
> I thought it was painfully obvious but...  the use case is setting up
> a rule that matches the prefix addresses and having such rules still
> work properly when the link flaps onto a link with a different prefix

Sure, but what would be a use case of a rule that matches the prefix
addresses ?
Also, how is this specific to IPv6 ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
