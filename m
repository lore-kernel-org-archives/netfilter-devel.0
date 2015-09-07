From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Mon, 7 Sep 2015 20:28:47 +0200
Message-ID: <20150907182847.GA16494@salvia>
References: <20150905210746.GA13600@salvia>
 <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
 <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ville =?iso-8859-1?Q?Skytt=E4?= <ville.skytta@iki.fi>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbbIGSWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 14:22:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 06, 2015 at 09:15:51AM +0200, Jan Engelhardt wrote:
>=20
> On Sunday 2015-09-06 08:22, Ville Skytt=E4 wrote:
> >=20
> >-/* print a given ip including mask if neccessary */
> >+/* Print a given ip including mask if necessary.
> >+ */
> > static void print_ip(const char *prefix, const struct in6_addr *ip,
> > 		     const struct in6_addr *mask, int invert)
> > {
>=20
> Hm that really looks worse than it did before.

It's not so bad.

I have manually mangled the patch so it sticks to the format when the
comments fit into one line, ie.

+/* Print a given ip including mask if necessary. */

@Ville: I forgot to indicate that comments that fit into one line look
like above. The format below ...

/* ... Only applies when the comment that doesn't it into one line for
 * whatever reason.
 */

I hope it clarifies.

So applied, thanks for following up Ville.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
