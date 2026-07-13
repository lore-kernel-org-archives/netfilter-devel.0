Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60285426EA8;
	Mon, 13 Jul 2026 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948892; cv=none; b=DjoEOhnE631cUjljICY7QxXiSeVhhDyXQSNqz49F8vgpYHEtRHkG6GH1TYIHJyJJMT8ASOMaHp6Fid94Kr4X2HBMOdMLFQc6kac3Er9pGncKngdEE9UF05q30pKynae2oK/ht/EZAyal3XGrazs0p8kwqU7FvteXP+OXBtjL5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948892; c=relaxed/simple;
	bh=CLvOMuTGzK0B9UMbrs4BcMOxKRHnFjD8dC/fxRzRXiY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l9iM0PRurGnR6ywG9zy0fgLybP5lB/Zaw+WUlv2RrhBSjEtxqTlnwgusDsQOlQdDqPmf780wKErsrgkziLp9OkMePSVs3xe7b1H4tLTrYFZaWTQTU3KrHrPlaCp72/q/8ClCBSkVwUXw9GUpRxK9r5qKNblqJKi7KXBIFH3RmJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=jsuZad9b; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jsuZad9b"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gzNC64STBz7s7wb;
	Mon, 13 Jul 2026 15:12:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1783948352; x=1785762753; bh=bU3QVDxuYL
	ifBEDECxq11ROerf4rx5150fNX0c5ItPU=; b=jsuZad9bJ4Zvd34yJl5KRB1YeQ
	HIBhprnbt/jelZDAs8Cduhs6srZdPjKr8gSvvJUSHsf2nLl6YFGvpzVRvnMQMhro
	Ui64n7c5ycE7XKiIYMIPImZwLhOVmMiNpLpFdHADN7eKweAZMejXEhV9ekUrkkns
	uEzyTjEe/DrYMuJLY=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ktaVqrb7ZuZ4; Mon, 13 Jul 2026 15:12:32 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gzNC41S29z7s7wX;
	Mon, 13 Jul 2026 15:12:32 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 1FC6B34316E; Mon, 13 Jul 2026 15:12:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 1E4DF34316D;
	Mon, 13 Jul 2026 15:12:32 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:12:32 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: David Lee <david.lee@trailofbits.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
    Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
    stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: do not update comments from
 kernel-side hash adds
In-Reply-To: <20260713095918.173450-1-david.lee@trailofbits.com>
Message-ID: <288616cf-27fa-eed8-2e4c-898d723cc283@blackhole.kfki.hu>
References: <20260713095918.173450-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Mon, 13 Jul 2026, David Lee wrote:

> mtype_resize() copies comment pointers with memcpy(), not the comment objects
> themselves. During the window after an entry has been copied but before the
> table swap and backlog replay, the old table is still published for
> packet-side updates while the replacement-table entry already holds the same
> ip_set_comment_rcu pointer.
>
> If xt_SET --add-set ... --exist hits that old entry in this window,
> mtype_add() calls ip_set_init_comment() even though packet-side adds carry no
> comment payload. That call frees the shared comment through the old entry, so
> the replacement-table entry now holds a stale pointer. When the queued add is
> replayed on the new table, mtype_add() calls ip_set_init_comment() again and
> strlen() dereferences the stale pointer.
>
> Fix this in mtype_add() by skipping ip_set_init_comment() when ext->target
> marks a packet-side add. Userspace adds still update comments, while
> packet-side adds can no longer free comment storage shared with a resize copy.
>
> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> Assisted-by: Codex:gpt-5.5
> ---
> A reproducer triggers a KASAN slab-use-after-free in strlen() from
> ip_set_init_comment() during hash_ip4_resize().
>
> Trail of Bits has a privilege escalation PoC for this bug on a
> custom kernel, which can be shared further if needed.
>
> net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 8231317b0f1f..b2d77973272d 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1005,7 +1005,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> #endif
> 	if (SET_WITH_COUNTER(set))
> 		ip_set_init_counter(ext_counter(data, set), ext);
> -	if (SET_WITH_COMMENT(set))
> +	if (SET_WITH_COMMENT(set) && !ext->target)
> 		ip_set_init_comment(set, ext_comment(data, set), ext);
> 	if (SET_WITH_SKBINFO(set))
> 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
> --

Thanks! Resize is a can of worms for edge cases and hopefully all of them 
caught one by one.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
