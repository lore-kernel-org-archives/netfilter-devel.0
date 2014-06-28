From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: Re: [RFC PATCH iptables] Hide FORWARD chain if forwarding is not
 enabled
Date: Sat, 28 Jun 2014 11:28:43 +0200
Message-ID: <53AE8ACB.1030800@plouf.fr.eu.org>
References: <53AE6FFD.5080109@jbeekman.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jethro Beekman <kernel@jbeekman.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bamako.nerim.net ([178.132.17.28]:50026 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaF1JiN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2014 05:38:13 -0400
In-Reply-To: <53AE6FFD.5080109@jbeekman.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jethro Beekman a =E9crit :
> Most Linux distributions have IP forwarding disabled and it gets me e=
very time.
> The FORWARD chain is pretty much useless with forwarding disabled, so=
 make
> ip{,6}tables -L print a message notifying the user instead of actuall=
y listing
> the contents.

As a user I prefer to have the ability to check rules in the FORWARD
chains before enabling IP forwarding.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
