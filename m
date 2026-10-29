Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294349;
	b=lYG+Td7BlFEO6WrhlU2PFFCzUtenYSLQpk4PQBq3wWPBxUCGOX1H0/uUgdl66BF0Wilm
	 cOMi7wq31iii9siUpqD3MegGyme1D2hLpgcr7iw561TF7MVjodVcvqIrZolYgj0R2ZpSz
	 yucCWAXz+86sexCxhD5yEpcVmhXNDNlRVJ50GUkFCgz1lPjXBE1hj1aD8rWEofyMkHvVN
	 zNQD9BuqwuJ8zvQQf8XfTCJqAZEM1D7zoXaMFO7bKAPQobhPO6ZwqWuXeuKtAKipCHUNC
	 393Wtu45h0ggwj1Ce6RK2Wo1wdez1ZWyYugiOXCqEgckyh6iecEvBsY94VQyqZtUZ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294349;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=HPyqLQuIjx8631zl1aB4f9rqUIyeQ7nvI2XxpSodotE=;
	b=BlINOgSsWO9WZLwAzo+7HYjHECGxJVH/4eF7YI3xJzglCixOKd+X+qLSYn7F6RhMwJvm
	 ScMnluWy4VESnO4PH/FYBwHQvj1SZ0rkKUaKrVU/6t5eI8uUnUstiYso9Hz0CTBPeR8wN
	 /aYHS5Q4MuPEODHxU3wTdAOUuT7Llvnn4PBYXb8K4ZdBkUGdlo7u1gWywNo7opk35RRF+
	 wLvA0YLyAk8EM8JkTbm8l0TnTKW+FFgguZlU/Yrmy2PraYCnXLXqpvIXE/z8BbIWya4iB
	 5GCaF1n4RksoAsLvBUnleUMW6jNXfBLDJAkwggpFdTTEeVSDC7nMlw+q/50d39bxfgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b="Ue4R/XkQ";
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39995606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39995606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=Ue4R/XkQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HPyqLQuIjx8631zl1aB4f9rqUIyeQ7nvI2XxpSodotE=; b=Ue4R/XkQhX4hAWXWawdhT0Vvh+
	Mqp/mbJjB5NFdLLA3jqeM8SpMnKIuOBOmzVRz5dCx8xl+jpyRovFlccO9TLg4KvA5eK//4/DGzlZH
	HKZNLn1BX37gMizQZdvezbGf1i2zmqQGVT8/Mf+9wP0l0G15yqrqT91LBNYcE+6hKUFWEFsMBtB8Y
	0T0vsVys9NHFvb/CJgphzDEFLHlSbXHvUlQ3hfJKb4KWhgVjNxmF8Ay0CYBZ/WGtfkLwI+0rchLbL
	hlCqL3di5Ld//qQo1hW86bh8iQcbdJW34UzY9FfGk2XmVt+0zypvYmRjY1sTzNBVzJEQTenzcjjoi
	GwOxHKAQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMTmM-000000003mJ-12IK;
	Thu, 29 Oct 2026 18:19:06 +0100
Date: Thu, 29 Oct 2026 18:19:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libftnl 00/12] more misc LLM fixes
Message-ID: <auOACuSrLLA5qXgx@orbyte.nwl.cc>
References: <20261028145632.7089-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>

On Wed, Oct 28, 2026 at 03:56:20PM +0100, Florian Westphal wrote:
> Another round of LLM findings.  These commits are all unrelated,
> except that they are LLM findigs with no observed bug reports.
> 
> 1) Check mnl_nlmsg_batch_start() for a NULL return. Avoid potential NULL
> pointer dereference in src/common.
> 
> 2) Fix uninitialised attr arrays by zero-initialising tb[] arrays.
> 
> 3) Move several MNL_STRING attribute types to MNL_NUL_STRING so
> mnl_attr_validate enforces NUL termination. Harden future
> netlink-attribute parsing against non-kernel sources that may omit the
> terminator.
> 
> 4) Validate NFTA_EXPR_NAME parse success. Upgrade string validation to
> NUL_STRING, since the kernel always appends a trailing NUL.
> 
> 5) Forbid re-setting or clearing the object type field to prevent
> inconsistent state and segfaults. Check the correct subtype before freeing
> to guard against a latent union overlap crash.
> 
> 6) Drop trailing semicolon from the xfree macro. Callers already append their
> own ;, so the macro's is redundant.
> 
> 7) Remove the obsolete set_elem member from the ruleset union. Its last
> consumer (the removed json interface) no longer exists, and the shared
> nftnl_set_free path masked a latent type-confusion bug.
> 
> 8) Clear field_len array before copying to avoid reading stale values from a
> prior call. Fix a bug where shrinking the array on a second invocation
> leaks leftover field counts.
> 
> 9) Guard the s->expr_list traversal against the empty-list case to avoid
> returning a pointer into the middle of nftnl_set. Initialize data_len to 0.
> 
> 10) Fix use-after-free by calling list_del() before freeing expressions in
> set_elem. Prevents dangling next/prev pointers from corrupting a
> subsequent list_add on the same list.
> 
> 11) Clamp buf->end to the actually copied size in udata_buf_put. Prevent
> nftnl_udata_buf_space() from observing an end pointer past the buffer.
> 
> 12) Remove all remaining MNL_STRING users, switch to MNL_NUL_STRING and
> mnl_attr_put_strz. Enforce NUL-termination checking on all string
> attributes to prevent illegal strlen/strdup on unchecked data.
> 
> Florian Westphal (12):
>   src: common: mnl_nlmsg_batch_start may return NULL
>   src: fix uninitialised attr arrays
>   src: move several MNL_STRING types to MNL_NUL_STRING
>   src: expr: make sure NFTA_EXPR_NAME was parsed successfuly
>   src: object: don't permit to re-set or clear object type field
>   include: drop semicolon at end of xfree macro
>   src: ruleset: remove set_elem member from union
>   src: set: clear field_len array before copying
>   src: set: check for empty list explicitly
>   src: set_elem: list_del before freeing
>   src: udata: clamp buf->end to actally copied size
>   src: remove all remaining MNL_STRING users

Reviewed-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
