From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/8] chain: Break the line properly when
 printing out the chain
Date: Tue, 11 Feb 2014 12:47:10 +0100
Message-ID: <20140211114710.GA5534@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140211105843.GA4299@localhost>
 <52FA099C.8020805@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45905 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaBKLrP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:47:15 -0500
Content-Disposition: inline
In-Reply-To: <52FA099C.8020805@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 01:29:32PM +0200, Tomasz Bursztyka wrote:
> Le 11/02/2014 12:58, Pablo Neira Ayuso a =E9crit :
> >>As when a rule is printed etc... It fixes a bug in iptables when
> >>>printing out the chain in debug mode.
> >All the example in libnftnl rely on that missing \n, including nft.
> >Better fix this in iptables-compat?
>=20
> I followed what have been done in src/rule.c
>=20
> Actually a fix has to be done there as well:
>=20
> removing the '\n' in "%s %s %s %"PRIu64" %"PRIu64"\n"
>=20
> and changing the expression printing loop so:
> it does "\n  [ %s " and "]" instead of "]\n".
>=20
> And fixing iptables-compat so it add the relevant '\n' at the end.

I see, that's inconsistent. Let's add the \n to nft and any other
caller first and wait until next nft utility is released to update the
library not to break the output with different library versions (ie.
just to keep a very short term backward compatibility). I think we
should also nul-terminated the strings for all _snprintf functions.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
