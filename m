From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Out Of Bound Read in Netfilter Conntrack
Date: Thu, 12 Oct 2017 02:03:46 +0200
Message-ID: <20171012000346.GE26835@breakpoint.cc>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43532 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750718AbdJLADy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 20:03:54 -0400
Content-Disposition: inline
In-Reply-To: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Sesterhenn <eric.sesterhenn@x41-dsec.de> wrote:
> Add missing counter decrement to prevent out of bounds memory read.
> 
> Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c
> b/net/netfilter/nf_conntrack_h323_asn1.c
> index 89b2e46925c4..2a9d1acd0cbd 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -877,6 +877,7 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931
> *q931)
>  		if (sz < 1)
>  			break;
>  		len = *p++;
> +		sz--;
>  		if (sz < len)
>  			break;
>  		p += len;

LGTM.
Acked-by: Florian Westphal <fw@strlen.de>
