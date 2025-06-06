Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639CC1EF091;
	Fri,  6 Jun 2025 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749249828; cv=none; b=JmbI27qM+ADvOkrwkUkwwls3z5/jcRZ0ZZyAFOce4qLsVNx6+DvjQlBUnF2jiQBqu75PCDzwRP3zu+/dBc0jDVdh0nUFat+P+afePk19Mkzzpru13/bICYoX866zBP80oro3b+RwbyMv/0mJAcr35I4guy4GDHmcyIOhQouG1/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749249828; c=relaxed/simple;
	bh=HN34rSnhpwUhiCxBdO8bEkaZpPDUMJPzG0R3Eks/3+I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AukZXjOefF8/E3jRQAXrGZv26cT/8GzrgVawxc5KRejT5AzDPXpH1mB6qFBXBRXZQOh/WSw3iVX5AB/QhbJ4zo8fG6+D0jtVFnAbFx2fIkRn1b0y9o0iqffgFt2KsQJJoVxDOJ4oQpJ2xzniG+LP9r0+28mMiG7KoJa4NlTv3W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=O9Lit9VT; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="O9Lit9VT"
Received: from [192.168.1.114] (unknown [185.145.125.130])
	by mail.ispras.ru (Postfix) with ESMTPSA id 853F8552F52E;
	Fri,  6 Jun 2025 22:43:34 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 853F8552F52E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1749249815;
	bh=4FNrxbrDLezJtGVSd30QPAcSgY0PsKN5mciA3269qaI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=O9Lit9VTcu1dYostvlsJ0kivcghmnYDfLqv64c1yU59Zj++arBnRWKdAro3K9OrHk
	 4h+GShxSQZsx3TXasDaXvcH7ijV82hFbdwyjB3uekD1DI7xVmLr/GLwKGJWJaff+bS
	 TZ5kgEnAF0v5EK3d5qq1bzy3ymms3nSb4eFlsfcs=
Subject: Re: [PATCH 5.10 114/270] netfilter: nf_tables: do not defer rule
 destruction via call_rcu
To: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
References: <20250602134307.195171844@linuxfoundation.org>
 <20250602134311.887199759@linuxfoundation.org>
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Message-ID: <99fd0bfd-7bab-d0dc-76b9-9aa7a61c1410@ispras.ru>
Date: Sat, 7 Jun 2025 01:43:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250602134311.887199759@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit

On 02.06.2025 16:46, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Florian Westphal <fw@strlen.de>
> 
> commit b04df3da1b5c6f6dc7cdccc37941740c078c4043 upstream.
> 
..skip..

> Also add a few lockdep asserts to make this more explicit.
> 
..skip..

> +/* can only be used if rule is no longer visible to dumps */
>  static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
>  {
> +	lockdep_commit_lock_is_held(ctx->net);
> +
>  	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
>  }
> @@ -4858,6 +4860,8 @@ void nf_tables_deactivate_set(const stru
>  			      struct nft_set_binding *binding,
>  			      enum nft_trans_phase phase)
>  {
> +	lockdep_commit_lock_is_held(ctx->net);

I guess you meant WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
here?


Found by Linux Verification Center (linuxtesting.org) with SVACE.

--
Alexey



