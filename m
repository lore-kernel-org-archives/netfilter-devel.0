From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: install nf_nat.h and nf_conntrack_tuple.h
 to INSTALL_HDR_PATH
Date: Mon, 12 Sep 2011 11:19:13 +0200
Message-ID: <20110912091913.GA2194@1984>
References: <1315527377-28528-1-git-send-email-basile@opensource.dyc.edu>
 <20110912083839.GA2017@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net, blueness@gentoo.org,
	gurligebis@gentoo.org, base-system@gentoo.org, kernel@gentoo.org,
	toolchain@gentoo.org, mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab1ILJTQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:19:16 -0400
Content-Disposition: inline
In-Reply-To: <20110912083839.GA2017@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2011 at 10:38:39AM +0200, Pablo Neira Ayuso wrote:
> > +/* Single range specification. */
> > +struct nf_nat_range {
> > +	/* Set to OR of flags above. */
> > +	unsigned int flags;
> > +
> > +	/* Inclusive: network order. */
> > +	__be32 min_ip, max_ip;
> > +
> > +	/* Inclusive: network order */
> > +	union nf_conntrack_man_proto min, max;
> 
> Better replace union nf_conntrack_man_proto by __be16, we don't break
> binary compatibility and we don't need to export the whole tuple
> definitions.

Hm, I just noticed that this will not work that easy.

git grep shows several NAT protocol helpers that rely on
nf_conntrack_man_proto under net/ipv4/netfilter/, we need to change
those as well to use the new definition of nf_nat_range.

I think I prefer the change that I'm proposing that exporting the
whole nf_conntrack_tuple.h header file.
