From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: lnf_conntrack: nfct_cmp NFCT_CMP_TIMEOUT_* flags not supported?
Date: Wed, 28 Nov 2012 16:16:06 +0100
Message-ID: <20121128151606.GA13155@1984>
References: <20121128125930.GF14156@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab2K1PQS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:16:18 -0500
Content-Disposition: inline
In-Reply-To: <20121128125930.GF14156@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, Nov 28, 2012 at 01:59:30PM +0100, Florian Westphal wrote:
> Hi.
> 
> I added api_tests for the various nfct_cmp timeout flags.
> And guess what: They don't work 8-}
> 
> It fails on the 2nd assert below:
> assert(nfct_cmp(ct, ct2, NFCT_CMP_TIMEOUT_EQ) == 1);
> nfct_set_attr_u32(ct2, ATTR_TIMEOUT, nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1);
> assert(nfct_cmp(ct2, ct, NFCT_CMP_TIMEOUT_EQ) == 0);
> 
> The reason is that __compare() doesn't know about NFCT_CMP_TIMEOUT*
> flags and returns 1 unconditionally.
> 
> So, my question is:
> How are the NFCT_CMP_TIMEOUT flags supposed to be used?

They planned to be used by the conntrack utility. To obtain timers
that are over/under some given timeout. But that was never
implemented, so that code has remain untested there so far until
someone has come to show some interest on it ;-).

> From the documentation it appears as if they should be used
> together with _ALL, _ORIG, _REPLY, or even standalone, i.e.
> __compare needs to check for these, too:

I think standalone if the way to go, I think they deserve special
treatment. Note that I'm using nfct_cmp in conntrackd to look up for
entries in the internal cache hashtable, so enabling that comparison
with _ALL, _ORIG and _REPLY would resulting in mismatching.

> diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
> index b18f7fc..7cd28e7 100644
> --- a/src/conntrack/compare.c
> +++ b/src/conntrack/compare.c
> @@ -407,5 +407,8 @@ int __compare(const struct nf_conntrack *ct1,
>         if (flags & NFCT_CMP_REPL && !cmp_repl(ct1, ct2, flags))
>                 return 0;
>  
> +       if (flags & (NFCT_CMP_TIMEOUT_GT|NFCT_CMP_TIMEOUT_LE))
> +               return cmp_meta(ct1, ct2, flags);
> +
>         return 1;
>  }
> 
> With the above change the new tests pass.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
