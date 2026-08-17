Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109963F4830
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 23:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787009785; cv=none; b=Q4Hwc6iTX40I3arIZkD+exNwb251AlKcX9EZs25ms6gQH0nN5GNc809D5FQfOyIvVLMaoJPOjP43UI51k3drpQM4ADxelXTD5KDKsPvPihKiTvdQcl6s91OYR2NZ4v/dn22t9oTAhbXbJ46ARc4IeIWUJxctm2IaMz8e006sSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787009785; c=relaxed/simple;
	bh=IV8gChb9sVJO0Q/bDi3rhoMMarr8v1MMRe7VGP98m+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oro1v8lNBmPI6MJ+3EC1HGAzQcySuaMZZM0NrpgfJP5qy+sjxtazvRRD83BXUIZ+yiSitJYf3t6qafTRUnOk5JUUPXC0zyOHj7t+XtaTeSadAvAE8ziGP80elhycpyoWMklpQqFmc8JV8kDVHozVI8UQJT014GyamUb+XBNFGF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IU3dZ6et; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IU3dZ6et"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787009778;
	bh=6JLBGu3v9bqq12GStKLzM7fb3kS1ZQ8CHiiF5ef0B/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IU3dZ6etV9ocEwaKaLqOmqx7QN7rxaKBIdynMK1fJ3FMXc+r1m2bYahbZTWeGQE4Q
	 0rm7VyEwGTTkQ4ocKqkYxP1aobENeAITdvRAeIONv/6lxXiu0whaAQkqI2rqCXUI0H
	 6IiJKSscif4AuokXZx5IbN17kmrAlmU8J2v1jvASJ0BsiguAgdIR8mctGpOby+Njjc
	 99mE94I9nJiSvKKyxxfRPcb9/X5JWnj7XeBj80vJNZWMdkg0nK4MT+IV+5t7PSoSRE
	 KxufDdm5cGpyv3neVERXJPRUco/7BOD3teWz1Kqx+BaXvJZucp8u1MXVFdv5c9CMke
	 2dVPbwwiQ/HpA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C3D5660074;
	Tue, 18 Aug 2026 01:36:18 +0200 (CEST)
Date: Tue, 18 Aug 2026 01:36:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net v2] netfilter: nf_conntrack_sip: fix OOB read in
 sip_skip_whitespace()
Message-ID: <aoOa8LIQN7uCFL2B@chamomile>
References: <6a7f6bac.8210807c.2888e8.47c5@mx.google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a7f6bac.8210807c.2888e8.47c5@mx.google.com>

Hi,

Could you please repost with a shorter commit description?

Thanks.

On Fri, Aug 14, 2026 at 12:25:32PM -0700, Joas Antonio dos Santos wrote:
> Resending with the correct tree tag in the subject (this fixes a bug, so it targets net, not net-next) -- apologies for the noise on the first message.
> 
> Summary: sip_skip_whitespace() in net/netfilter/nf_conntrack_sip.c has two
> distinct "ran out of data" outcomes but only signals one of them to its
> caller. When every remaining byte up to the buffer limit is a space or
> tab, its own for-loop condition ends the loop and it returns dptr ==
> limit, instead of the NULL that its sibling sip_follow_continuation()
> returns on its own "no more data" path. ct_sip_get_header() only checks
> for the NULL case; the next statement dereferences *dptr before checking
> it against limit, causing a 1-byte out-of-bounds read.
> 
> Affected version: Linux mainline, commit 3d6d817622b0a9721e3cc404df
> 3469171582be13 (2026-08-12), current as of this report. Verified
> identical (empty diff) against origin/master of torvalds/linux on
> 2026-08-13; no prior fix exists upstream.
> 
> File / function: net/netfilter/nf_conntrack_sip.c, sip_skip_whitespace()
> (around line 422), consumed by ct_sip_get_header() (around line 493).
> 
> Impact: out-of-bounds read of 1 byte past the end of the SIP payload
> buffer. Confirmed by AddressSanitizer against a userspace harness
> linking the unmodified, extracted parsing functions from this file.
> In the real call path (sip_help_tcp()), dptr/datalen come directly
> from the linearized skb with no slack: dptr = skb->data + dataoff,
> datalen = skb->len - dataoff, so limit is exactly skb->data + skb->len,
> the true end of packet data -- unlike some other conntrack helpers
> that operate on a slightly larger scratch buffer, there is no spare
> byte here. Impact is a potential crash (denial of service) if the
> byte read falls on an unmapped page.
> 
> Conditions: requires the nf_conntrack_sip helper to be attached to a
> TCP/UDP flow on the SIP port (5060 by default, or any port configured
> via the "ports" module parameter) -- a commonly enabled helper on
> routers/firewalls doing VoIP/SIP NAT. No authentication or established
> call state is required; ct_sip_get_header() is the primary header
> lookup used throughout SIP request/response and SDP processing, called
> for every recognized header (Via, From, To, Contact, CSeq, Expires,
> Content-Length, Call-Id).
> 
> Reproducer: a 7-byte input triggers the bug directly against
> ct_sip_get_header(): a recognized header name followed only by
> spaces/tabs running exactly to the end of the payload, no colon
> present. Tested against the exact kernel source (functions extracted
> verbatim, unmodified, from net/netfilter/nf_conntrack_sip.c) compiled
> into a small userspace harness, reusing the kernel's own
> in4_pton()/in6_pton()/hex_to_bin() (net/core/utils.c, lib/hexdump.c)
> rather than reimplementing them. AddressSanitizer reports:
> 
>   heap-buffer-overflow, READ of size 1
>   #0 ct_sip_get_header  nf_conntrack_sip.c:493
> 
> Also reproduced organically via libFuzzer+ASAN against the same
> extracted functions (ct_sip_parse_request, ct_sip_get_header,
> ct_sip_parse_header_uri, ct_sip_parse_param, ct_sip_parse_address_param,
> ct_sip_parse_numerical_param, ct_sip_get_sdp_header,
> ct_sip_parse_sdp_addr), from a well-formed INVITE seed within ~2200
> executions.
> 
> The reproducer bytes are not attached to this message; available on
> request.
> 
> Details: sip_skip_whitespace() is:
> 
>   static const char *sip_skip_whitespace(const char *dptr, const char *limit)
>   {
>           for (; dptr < limit; dptr++) {
>                   if (*dptr == ' ' || *dptr == '\t')
>                           continue;
>                   if (*dptr != '\r' && *dptr != '\n')
>                           break;
>                   dptr = sip_follow_continuation(dptr, limit);
>                   break;
>           }
>           return dptr;
>   }
> 
> If every byte from dptr to limit is a space/tab, the for loop exits via
> its own condition with dptr == limit, which is returned as-is -- a
> different "no more data" signal than the NULL returned by
> sip_follow_continuation() on its own exhausted-input path. The caller,
> ct_sip_get_header(), only guards the NULL case:
> 
>   dptr = sip_skip_whitespace(dptr, limit);
>   if (dptr == NULL)
>           break;
>   if (*dptr != ':' || ++dptr >= limit)   /* OOB read when dptr == limit */
>           break;
> 
> Before reporting, I checked every netfilter-devel thread touching
> nf_conntrack_sip.c from 2026-03 through 2026-08 (~15 threads, via
> marc.info since patchwork.ozlabs.org sits behind an anti-bot
> challenge), plus targeted searches for ct_sip_get_header and
> sip_skip_whitespace. None address this issue. Summary of what does
> exist, all distinct root causes, all already merged or in unrelated
> threads: port parsing after the address in sip_parse_port (merged,
> present in current mainline); a datalen integer-wraparound in
> sip_help_tcp()'s NAT rewrite-delta computation (KASAN symptom lands in
> ct_sip_get_header, but the root cause is in the caller); a NULL
> skb_dst() crash in set_expected_rtp_rtcp() under tc-ingress/openvswitch
> (two patches, unrelated SDP external-media code path); a memory-leak
> fix around nf_ct_expect_alloc() ordering in process_register_request();
> a cosmetic u_int*_t -> standard-types rename. None of these touch
> sip_skip_whitespace() or the dptr check that follows it in
> ct_sip_get_header().
> 
> Proposed fix (tested: reproducer no longer crashes under ASAN;
> 500000-iteration fuzz regression run clean, no behavior change on the
> existing corpus): make sip_skip_whitespace() report both "no more data"
> outcomes the same way, matching the convention its own
> sip_follow_continuation() already uses and that both existing call
> sites already check for:
> 
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -429,7 +429,7 @@ static const char *sip_skip_whitespace(const char *dptr, const char *limit)
>  		dptr = sip_follow_continuation(dptr, limit);
>  		break;
>  	}
> -	return dptr;
> +	return dptr < limit ? dptr : NULL;
>  }
> 
> Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
