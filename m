From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6 IPSEC + SNAT
Date: Wed, 8 Oct 2003 22:56:06 +1000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20031008125606.GA31685@gondor.apana.org.au>
References: <20031001121648.GA8755@gondor.apana.org.au> <200310071251.QAA32679@yakov.inr.ac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@redhat.com, jmorris@redhat.com, linux-net@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: kuznet@ms2.inr.ac.ru
Content-Disposition: inline
In-Reply-To: <200310071251.QAA32679@yakov.inr.ac.ru>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 07, 2003 at 04:51:22PM +0400, kuznet@ms2.inr.ac.ru wrote:
> 
> I thought about this (ages ago, so this can be stale)
> The verdict was that self-consistent picture is possible only
> when NAT rules are integral part of SPD. It does not look like
> a stimulating idea. :-)

That's very scary indeed :)

Hmm you've just given me another reason to strengthen the policy
check :) If two or more disjoint real addresses are SNATed
into one address before entering an IPSEC tunnel, then the SA
selectors cannot protect us at all if it has to use real addresses.

> I do not understand this. In this case IPsec is to be applied to _translated_
> packet, is not it? Am I wrong? If I am not wrong, there is no place to add
> an additional hook.

You're right.  There is no place for it currently.

Cheers,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
