Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219113;
	b=SKv6x7AwZwD4JL+KM+L9cAXaJYJMWK9rR+8dUivmx7tB1nIcMnBCVRAZ5sR5HQVNyx3y
	 NJFP/alYrRnTmK23YEhL2GxnRd6JPlARhwz5b2SMAxVYaJKJh8Zqj1lz/SJrbbImGeiIr
	 GyhnOj1o5h6Tg3yXQffkGJGLfZwhL50RnW+N0BMknm7KTlCqaBNcOqirdP9ibdKy3e21D
	 9Jy7NomDxwmSihsv+U0V1e7Bt5rwCUDWaD28hx85yrwLL/YPrAlt5jvL0AiLLnTGK6fZB
	 whmDZNjcNfrhXjB1o97xqEk0sINlj3MGPDH7hjxn619y6UOJePsglpbwRm/W4SWsqYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219113;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=6LczOBrrxXlOmcr0hIxa5uA7k5jQ+bcXpGN4rjE6NVY=;
	b=G4JZEW4Wii/rtW7YY8/W8SErd/BrE8A/7vD11AytXcBZiWI8QlbNJVE4pC118vQC6BAY
	 JHDNC9LWmLtyMeypYvExPLBr5WrfRt+ozNo3ODL73YHAdJzHYPpeb3VunkZ3MF+bJA2Z4
	 s2k5VGlwM2FG5zNEjrUOuME9lSL5RkxJJMmCs7uHLx12OpTTkjMtxOXJyeBslAlDg8kRv
	 3rCKmzbjcZk8FbMSdaYJ/Z1divLsuwLa4Iqe9L+prGUZi5deDZf7leBHuwByZemCVMdPX
	 WIW1JFv9HI/Nw5xNRTxZtmqxbGipa5PvDBEf0quT4RD83l9xMKiagtJdW6TJ1rRG0bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="r6za/DKl";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E98A8606A31C;
	Mon,  9 Nov 2026 10:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E98A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=r6za/DKl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794219103;
	bh=6LczOBrrxXlOmcr0hIxa5uA7k5jQ+bcXpGN4rjE6NVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r6za/DKlZJfeVReiOxBIakEH5iQQVQsY/8UCwP8ikCxBrNty97VV1gDKhOI3gGUZX
	 biGXRwPN9b5RhQkQnniFja97drqPTCavgrlwG1OOF7VgOG9A6r5ihayy6DJRyxImar
	 MT7s0eo9VP7i1M65ZqtvTLsmaQaPO02rIceBZOzvl4ydBfjzxwUQJYL9A8HGI0Zt+0
	 TZI2F+/PVe5+okf0kLps9a22WBw9KuPcI/GXj95E3XwnFWKUbDwuU7l5uBYuGZ6eo1
	 4DI4Tevl9QimOxCbCK+dJFGf4RuZAOcNDbYw7hGpbzu/lzQru20/F8ok8zMiBqSRTs
	 LY8xK/dg1w2LA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CD47F60056;
	Mon,  9 Nov 2026 11:11:43 +0100 (CET)
Date: Mon, 9 Nov 2026 11:11:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Noah Weinberger <NoahWeinberger2003@proton.me>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nft_dynset: reject DELETE op when set lacks
 ->delete
Message-ID: <avGcXYd1ii96m8L0@chamomile>
References: <5aybqcVfq3WxYdpbT0Ea6bEWamp-4x10J9FF_5La7SSXJ57a4j176x_t3zUW8Ii2r84MsPX8xx_vNashO2PRWvuO9yNsaxS8YV_4TLc-QHU=@proton.me>
 <avExLOsc3ZWRF5hh@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avExLOsc3ZWRF5hh@strlen.de>

On Mon, Nov 09, 2026 at 03:34:20AM +0100, Florian Westphal wrote:
> Noah Weinberger <NoahWeinberger2003@proton.me> wrote:
> > Hello,
> > 
> > nft_dynset_init() checks that the referenced set implements ->update,
> > but for NFT_DYNSET_OP_DELETE the packet path calls set->ops->delete
> > unconditionally. Today the only set type with ->update (nft_set_hash)
> > also implements ->delete, so the call is always valid - but any future
> > set type implementing ->update without ->delete turns a rule evaluation
> > into a NULL function call.
> > 
> > Reject the DELETE op at init time when ->delete is missing, next to the
> > existing ->update check.
> > 
> > Affected version/commit: mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07), net/netfilter/nft_dynset.c:98-101 (eval), 209-217 (init).
> > Longstanding asymmetry.
> > 
> > This was found during an assisted (AI-supported) static source review of
> > mainline fa4ad798f6f681031775266044ba1b0cf3c670bd (v7.4-rc1, 2026-11-07); every code path cited below was re-verified by the
> > reporter against that tree. The patch below has NOT been compiled and has
> > NOT been runtime tested, and no reproducer was produced - the triggering
> > conditions are described above instead. Please treat this as a report for
> > verification rather than a battle-tested fix.
> 
> This would have been fine 1 year ago but we no longer have resources
> and time to reproduce and verify such "fixes".
> 
> Ask your LLM for a reproducer, run it, show a minimal backtrace.
> We have LLMs too and we can use them to create enough usless and
> time-consuming tasks as-is.
> 
> I have a db of +1k reports just like this one.

Right.

The reporter has to proof this is not theoretical.

LLM might no "understand" that only sets with dynamic backends are
eligible.

And this patch points to the /dev/null tree: Submitter has to specify
if this is for nf.git (unlikely) or nf-next.git (maybe, just for
hardening).
