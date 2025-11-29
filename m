Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701FF3B2BA
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Nov 2025 01:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764379339; cv=none; b=ubBsM5NOOt31HXKhFZ8jCvJIMaCcrqhWKndMqBH2u9+rctdvkoAsbHJOzu+nCnG9gje6Zg6VHUTQTDtk1l/uCVXDU/hFuD1ZzTfVOL2c1Nw5ZZ2iUMRZD5q0bgsGzZT/yydJ44f2/ER/tAhFHy6yFuNxniUDGgI/mRoAHfIUV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764379339; c=relaxed/simple;
	bh=iLd812kZZh3S6GBQ2C3wTbrw4azDi2uzz2IB7cnkdac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEZT5waB+Auh2q6Zp/CWcc++DIKpKnPlUZXOYWTuTLH1KsFOZVnpJCdZtGUmSt535hQRl/9lrqvtptiUYld/1V/Rwbll4vBMJByGhiy+4e78083ZIJ8U9sS+EzYxlmma59LovGT6gz3ZrxihBAlEFOSNGtRYWEcP4bhDTFp6tw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VRe7GRlD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VRe7GRlD"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id E43AC2126F9E; Fri, 28 Nov 2025 17:22:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E43AC2126F9E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764379331;
	bh=d+MHBlGBLyRiw6TAn7GfdnBSOpONOGPm5aiQ+tbRFgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VRe7GRlDSQgArtEUZZBsRjNvGTQkiFuBl6i6ybbtSj+10FGev3LLrK/fSIvWpnWcH
	 OAsoXdCtphKcFCkJOvPwl7X2pM5G5xZnvk4Es8o16dHEVJKKUXLgKYa7SkWM+PWLZf
	 Ed8GMStEhCLWqEZ5+kI5OIGs09uqdkfffzBsP7P4=
Date: Fri, 28 Nov 2025 17:22:11 -0800
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: avoid chain re-validation
 if possible
Message-ID: <20251129012211.GA29847@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20251126114703.8826-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126114703.8826-1-fw@strlen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Nov 26, 2025 at 12:47:00PM +0100, Florian Westphal wrote:
> Consider:
>   input -> j2 -> j3
>   input -> j2 -> j3
>   input -> j1 -> j2 -> j3
> 
> Then the second rule does not need to revalidate j2, and, by extension j3.
> We need to validate it only for rule 3.
> 
> This is needed because chain loop detection also ensures we do not
> exceed the jump stack: Just because we know that j2 is cycle free, its
> last jump might now exceed the allowed stack.  We also need to update
> the new largest call depth for all the reachable nodes.
> 
> Care has to be taken to revalidate even if the chain depth won't be an
> issue, as the chain validation also ensures that expressions are not
> called from invalid context (e.g., masquerade from a filter chain
> or NAT prerouting hook).
> 
> Therefore we also need to stash the base chain context (type, hooknum)
> and revalidate if the chain became reachable from a different hook or type.

The issue is reproducible with this version of the patch applied, unless
I make the following change:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cf9f0aa1f49..a7b415c53df6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4145,14 +4145,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 	if (ctx->level == NFT_JUMP_STACK_SIZE)
 		return -EMLINK;
 
-	if (ctx->level > 0) {
-		/* jumps to base chains are not allowed. */
-		if (nft_is_base_chain(chain))
-			return -ELOOP;
-
-		if (nft_chain_vstate_valid(ctx, chain))
-			return 0;
-	}
+	if (ctx->level && nft_chain_vstate_valid(ctx, chain))
+		return 0;
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (fatal_signal_pending(current))

It is also worth noting that I'm still seeing the cpu usage spike up to
100% for a couple of seconds (attributed to an iptables process) with
this version of the patch (even with the above change), while the
previous rendition seemd to have resolved that.

Hamza
