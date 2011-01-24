From: Thomas Jacob <jacob@internet24.de>
Subject: Re: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Mon, 24 Jan 2011 12:31:11 +0100
Message-ID: <1295868671.15034.15.camel@enterprise.ims-firmen.de>
References: <1295705432-2588-1-git-send-email-jacob@internet24.de>
	 <1295705432-2588-2-git-send-email-jacob@internet24.de>
	 <alpine.DEB.2.00.1101231446550.13261@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:49911 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1AXLbQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:31:16 -0500
In-Reply-To: <alpine.DEB.2.00.1101231446550.13261@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2011-01-23 at 14:53 +0100, Jozsef Kadlecsik wrote:
> > -			return r;
> > +		if(ntohl(a->s6_addr32[i]) != ntohl(b->s6_addr32[i]))
> > +			return ntohl(a->s6_addr32[i]) < ntohl(b->s6_addr32[i]);
> >  	}
> 
> Why do you convert to host order in the inequality test? It could be left 
> out.

Yes it can be, just a left over from the old code I suppose. Didn't
really thing about that ;)

But if we are talking about performance, what about the following
part:       

if (info->flags & IPRANGE_SRC) {
  m  = iprange_ipv6_lt(&iph->saddr, &info->src_min.in6);
  m |= iprange_ipv6_lt(&info->src_max.in6, &iph->saddr);
  m ^= !!(info->flags & IPRANGE_SRC_INV);
  if (m)
    return false;
}

Shouldn't this be  m ||= .. in the second call to iprange_ipv6_lt,
to allow for some short circuit optimizations? Or in order
to reduce the rather asymmetric behaviour then, shouldn't these two
function calls be merged into something like

static inline int
iprange_ipv6_cmp(const struct in6_addr *a, const struct in6_addr *b,  
   const struct in6_addr *x )
{
        unsigned int i;

        for (i = 0; i < 4; ++i) {
                if(x->s6_addr32[i] != a->s6_addr32[i])
                  return ntohl(x->s6_addr32[i])<ntohl(a->s6_addr32[i]);
                if(x->s6_addr32[i] != b->s6_addr32[i])
                  return ntohl(b->s6_addr32[i])<ntohl(x->s6_addr32[i]);
               
        }

        return 0;
}

Or would that be bad from a 1st level caching point of view?

