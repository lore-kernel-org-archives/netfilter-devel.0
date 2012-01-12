From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: skb_checksum_help() vs GSO
Date: Fri, 13 Jan 2012 09:03:28 +1100
Message-ID: <20120112220328.GA10813@gondor.apana.org.au>
References: <1326400930.2740.10.camel@bwh-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev <netdev@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59034 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2ALWDe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:03:34 -0500
Content-Disposition: inline
In-Reply-To: <1326400930.2740.10.camel@bwh-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2012 at 08:42:10PM +0000, Ben Hutchings wrote:
> skb_checksum_help() does:
> 
> 	if (unlikely(skb_shinfo(skb)->gso_size)) {
> 		/* Let GSO fix up the checksum. */
> 		goto out_set_summed;
> 	}
> ...
> out_set_summed:
> 	skb->ip_summed = CHECKSUM_NONE;
> out:
> 	return ret;
> 
> but skb_gso_segment() requires that skb->ip_summed == CHECKSUM_PARTIAL
> and WARNs if not.  I don't think there's any case where it's valid to
> call both.  Shouldn't skb_checksum_help() also WARN and return an error
> code instead of muddling on?

I think so.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
