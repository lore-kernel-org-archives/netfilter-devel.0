Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4658034AAE5
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755608402; cv=none; b=g+LHE955P+zifxTU64TU+B91CTizkKGnUKsWWN35RckR8Vp9XIK8QZWg2xp/XFWBtwFOduYL4ySHNaQakv/t8EhmojMaC9loC0fRppnZUn6oeEFO3qkhunHwid4arJKaWchsUqGOz0dyBnwzQ+uTE3NsLr+HWvsoGZhuIFi9rgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755608402; c=relaxed/simple;
	bh=U008D6yWMfR+8RcVczdsL2UwXvzqRii4jG4VuOUITLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+8g0paEP5r1uUZNaWU2yjMPAAkCbJ0St+zHRk6/FcoR+e0jPL9a2YBFEBSKK7A7UKWB3FLWHGz1YCTn4pMooJeMgcMFUIVXdSRH1WXvyK9495drsRQuY+my5+Ezxudl4BUOqnkQmsSppn/iqfrt6ma7cCCisL09cVpfyQ2/dV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D2zj2+3u; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D2zj2+3u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D2zj2+3u";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D2zj2+3u"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7AB596027E; Tue, 19 Aug 2025 14:59:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755608398;
	bh=0VPGAbwl4mzmcS0Z2T5djcanrgQQj9Iq8BY3VXfqKHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2zj2+3u0ZRJvS6uK9tkQyb50y1KzOHF6J4yyryXdf73YoPRLbwBvlyteqXw2Zw19
	 Puy53w8Ejdz78a7ckZnj4NlzHcErUMqLZBM5/8a5fjEutCVaL1YRx445J4ArgxhUmQ
	 m5AF4M6G90L1+38Qx0CUvvqlA+rFalNUYgA8whKxj47h+VOcoslCUugDzyIbZgMCYL
	 WSbNPY3JD103Qo2XyBfXMDN/L1M83wqrkP+eGlfQ/3Pv2o38TTVYwmvlRe7UK7civW
	 vpjjtSF1+/PkCSbqQPiDokvcd5ao5rSUDsFqXPdXvQ8VED6cVd+G8orGllEyYYhPhe
	 AVcexpkQXAf8Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CEE206027E;
	Tue, 19 Aug 2025 14:59:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755608398;
	bh=0VPGAbwl4mzmcS0Z2T5djcanrgQQj9Iq8BY3VXfqKHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2zj2+3u0ZRJvS6uK9tkQyb50y1KzOHF6J4yyryXdf73YoPRLbwBvlyteqXw2Zw19
	 Puy53w8Ejdz78a7ckZnj4NlzHcErUMqLZBM5/8a5fjEutCVaL1YRx445J4ArgxhUmQ
	 m5AF4M6G90L1+38Qx0CUvvqlA+rFalNUYgA8whKxj47h+VOcoslCUugDzyIbZgMCYL
	 WSbNPY3JD103Qo2XyBfXMDN/L1M83wqrkP+eGlfQ/3Pv2o38TTVYwmvlRe7UK7civW
	 vpjjtSF1+/PkCSbqQPiDokvcd5ao5rSUDsFqXPdXvQ8VED6cVd+G8orGllEyYYhPhe
	 AVcexpkQXAf8Q==
Date: Tue, 19 Aug 2025 14:59:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: fix memory leak in anon chain error handling
Message-ID: <aKR1S8woWjmfz_OT@calendula>
References: <20250724102205.4663-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250724102205.4663-1-fw@strlen.de>

On Thu, Jul 24, 2025 at 12:22:02PM +0200, Florian Westphal wrote:
> chain_stmt_destroy is called from bison destructor, but it turns out
> this function won't free the associated chain.
> 
> There is no memory leak when bison can parse the input because the chain
> statement evaluation step queues the embedded anon chain via cmd_alloc.
> Then, a later cmd_free() releases the chain and the embedded statements.
> 
> In case of a parser error, the evaluation step is never reached and the
> chain object leaks, e.g. in
> 
>   foo bar jump { return }
> 
> Bison calls the right destructor but the anonon chain and all
> statements/expressions in it are not released:
> 
> HEAP SUMMARY:
>     in use at exit: 1,136 bytes in 4 blocks
>   total heap usage: 98 allocs, 94 frees, 840,255 bytes allocated
> 
> 1,136 (568 direct, 568 indirect) bytes in 1 blocks are definitely lost in loss record 4 of 4
>    at: calloc (vg_replace_malloc.c:1675)
>    by: xzalloc (in libnftables.so.1.1.0)
>    by: chain_alloc (in libnftables.so.1.1.0)
>    by: nft_parse (in libnftables.so.1.1.0)
>    by: __nft_run_cmd_from_filename (in libnftables.so.1.1.0)
>    by: nft_run_cmd_from_filename (in libnftables.so.1.1.0)
> 
> To resolve this, make chain_stmt_destroy also release the embedded
> chain.  This in turn requires chain refcount increases whenever a chain
> is assocated with a chain statement, else we get double-free of the
> chain.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
