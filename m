From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: TPROXY target returns NF_ACCEPT
Date: Wed, 17 Jun 2009 11:20:35 +0200
Message-ID: <20090617092035.GB26580@sch.bme.hu>
References: <4A376156.60106@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:32821 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbZFQJwR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:52:17 -0400
Content-Disposition: inline
In-Reply-To: <4A376156.60106@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On k, j=FAn 16, 2009 at 07:09:42 +1000, Philip Craig wrote:
> The TPROXY target returns NF_ACCEPT rather than XT_CONTINUE.
> Is there a reason for this, or is it left over from when
> there was a tproxy table?  I can place the tproxy rules last
> if needed, but this behaviour was unexpected.

It has more to do with the REDIRECT-like functionality of the target.
TPROXY 'redirection' is tricky, since it does not actually touch the sk=
b
but the packet ends up in a local socket with a different address/port.

> Also, does tproxy handle related ICMP packets too?

The 'socket' match matches for related ICMP, so if you use TPROXY in
conjuction with that, then yes, it does handle related ICMP.

--=20
KOVACS Krisztian
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
