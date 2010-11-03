From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 10:29:47 +0100
Message-ID: <4CD12B8B.9090506@plouf.fr.eu.org>
References: <20101102.135254.226783976.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:60045 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0KCJ3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:29:52 -0400
In-Reply-To: <20101102.135254.226783976.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

David Miller a =E9crit :
> H. Peter Anvin just mentioned something interesting to me,
> basically it's the fact that when your prefix addresses
> change on an interface in ipv6, this can invalidate your
> netfilter rules.
>=20
> So it would be nice if there were some way to match "the
> ipv6 prefix address on interface X", and through some
> kind of caching this could be optimized so it wouldn't
> really cost anything.
>=20
> Thoughts?

What would be a use case ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
