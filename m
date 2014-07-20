From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: Re: [RFC PATCH iptables] Hide FORWARD chain if forwarding is not
 enabled
Date: Sun, 20 Jul 2014 10:58:15 +0200
Message-ID: <53CB84A7.10103@plouf.fr.eu.org>
References: <53AE6FFD.5080109@jbeekman.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jethro Beekman <kernel@jbeekman.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bamako.nerim.net ([178.132.17.28]:50988 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaGTI6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jul 2014 04:58:20 -0400
In-Reply-To: <53AE6FFD.5080109@jbeekman.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jethro Beekman a =E9crit :
> The FORWARD chain is pretty much useless with forwarding disabled

Not on a bridge with bridge-nf enabled (which is the default).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
