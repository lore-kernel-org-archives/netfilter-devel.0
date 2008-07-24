From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH 2/4] Add parsing module for raw.mac.
Date: Thu, 24 Jul 2008 09:37:34 +0200
Message-ID: <20080724073733.GD2250@khasse.inl.fr>
References: <1216848048-13516-2-git-send-email-eric@inl.fr> <48882B03.2030806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:46434 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYGXHhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:37:36 -0400
Content-Disposition: inline
In-Reply-To: <48882B03.2030806@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thursday, 2008 July 24 at  9:10:59 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > This patch adds a module named RAWMAC which is in charge of parsing the
> > hardware header to extract source and destination hardware address.
> 
> I think that this should be merged with MAC2STR, can you see any other
> potential user of this information apart from the string converter?

No, this was also my conclusion before falling asleep yesterday ;)

> Also, it would be nice to rename it to HW2STR instead.

Ok.
 
> Minor glitch below:
> 
> > +static int parse_rawmac(struct ulogd_key *ret, struct ulogd_key *inp, int type)
> > +{
> > +	switch (type) {
> > +		case ARPHRD_ETHER:
> > +			return parse_ethernet(ret, inp);
> > +		default:
> > +			ulogd_log(ULOGD_NOTICE, "Unsupported hardware type (%d), "
> > +				  "unable to parse.\n", GET_VALUE(ret, KEY_RAW_TYPE).ui16);
> 
> This can generate lots of log messages. I prefer to remove this and
> document that only ethernet is supported at the moment.

Ok, good idea.

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
