Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DE836074F;
	Tue, 28 Apr 2026 02:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777342427; cv=none; b=aUuna0SEzjiBDMArmDK2VH/PsgMcbVQwaTyJDK0wIpO0UZbEhPCW0ZczAKWCaU2qTkm+/6KCXq08ZcwzUddvbtbbn0SDWRvVKdJtMMj1zk4buqcseaFSwgdqcmuRJbNxOh7YCtj1R/mQZxnHZYo/59JvqMnCCLjbS/UTFbc06QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777342427; c=relaxed/simple;
	bh=9apv2i2QPAsYoinyRWJylyF2T/wcpEO7UkuN3fvm1GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrQQ5l71SNwHGi9v55nnwNipbVQJ8wtafZIkSNt3yVGAc3brleVaBdl+KPgIsJAveEZ+aSzbP439SbDjE1ZMHYt+SuWLNj8aoPrXeAYNCCJF63cat6U5UACFNzWFPxnSkgL6s1x9+Qz2zNL+AgnBAyz/Z1hPoCC9UV/MoT3Rj9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtuUB/jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtuUB/jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3070C19425;
	Tue, 28 Apr 2026 02:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777342427;
	bh=9apv2i2QPAsYoinyRWJylyF2T/wcpEO7UkuN3fvm1GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtuUB/jRa5wuNYnE0lRtY4rk3VkAxxPAVr8yF33JEYFWi1EsMPLC4EUvTz9LZ7bvI
	 nengcgVoq9YSYOCnKi4w1YdujB3BAgH6rVQDdiZTysPuOmQz26YxFvvBQnCxBBJGCG
	 U4CAzq2RwLwNHpEzaQMOxMswJUQEsmw6o2z7qQe2vfCTFPN+PwGK0XJQ/sMc8DPllI
	 EURbirPrBYzFNEyA3xlqDu0ZgN2NcOvgc+epFhprwF0Bo07GOZ93E5nYTeck+U+0OW
	 OiUKE/lGLCXMaYJwTAFXw8o5KIRdq7yiN378VoNs2fktwYQFjzWkIM/GPkEglhInUK
	 3hbLTpbY3SKLw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 11/11] ipvs: fix the spin_lock usage for RT build
Date: Mon, 27 Apr 2026 19:13:43 -0700
Message-ID: <20260428021343.793695-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424190513.32823-12-pablo@netfilter.org>
References: <20260424190513.32823-12-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
ipvs: fix the spin_lock usage for RT build

This commit fixes spin_lock sleeping issues on PREEMPT_RT by adjusting the
use of cp->lock in combination with hlist_bl bit locks. It removes the
spin_lock from ip_vs_conn_hash() and ip_vs_conn_unlink(), and changes the
lock ordering in ip_vs_conn_fill_cport().

Link: https://sashiko.dev/#/patchset/20260415200216.79699-1-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260420165539.85174-4-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260422135823.50489-4-ja%40ssi.bg

> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 84a4921a7865a9..9e23cda8482588 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c

[ ... ]

> @@ -704,14 +702,23 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
>  		hlist_bl_unlock(head);
>  		write_seqcount_end(&t->seqc[hash_key & t->seqc_mask]);
>  		preempt_enable_nested();
> -		spin_unlock_bh(&t->lock[hash_key & t->lock_mask].l);
> +		spin_unlock(&t->lock[hash_key & t->lock_mask].l);
> +		spin_unlock_bh(&cp->lock);
>  		hash_key = hash_key_new;
>  		goto retry;
>  	}
>  
> -	spin_lock(&cp->lock);
> -	if ((cp->flags & IP_VS_CONN_F_NO_CPORT) &&
> -	    (cp->flags & IP_VS_CONN_F_HASHED)) {
> +	/* Fill cport once, even if multiple packets try to do it */
> +	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {

Does removing the IP_VS_CONN_F_HASHED check here lead to a NULL pointer
dereference for IP_VS_CONN_F_ONE_PACKET connections?

Connections flagged with IP_VS_CONN_F_ONE_PACKET bypass hashing:

ip_vs_conn_hash() {
    if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
        return 0;
    ...
}

Because they bypass hashing, their hash list nodes (hn->node) are never
linked, leaving hn->node.pprev as NULL. If such a connection is created
with a source port of 0, it gets the IP_VS_CONN_F_NO_CPORT flag.

When ip_vs_conn_fill_cport() is later invoked to populate the port, the
missing IP_VS_CONN_F_HASHED check allows the execution to proceed.

> +		/* If we race with resizing make sure cport is set for dir 1 */
> +		if (!cp->cport) {
> +			cp->cport = cport;
> +			by_me = true;
> +		}
> +		if (!dir) {
> +			atomic_dec(&ipvs->no_cport_conns[af_id]);
> +			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> +		}
>  		/* We do not recalc hash_key_r under lock, we assume the
>  		 * parameters in cp do not change, i.e. cport is
>  		 * the only possible change.
> @@ -726,21 +733,17 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
>  			hlist_bl_del_rcu(&hn->node);

If head != head2 here, hlist_bl_del_rcu(&hn->node) is called. Since
hn->node.pprev is NULL, wouldn't this cause a panic when __hlist_bl_del()
executes *pprev = next?

Is it possible to retain the IP_VS_CONN_F_HASHED check or otherwise
ensure unhashed nodes aren't unlinked?

>  			hlist_bl_add_head_rcu(&hn->node, head_new);
>  		}
> -		if (!dir) {
> -			atomic_dec(&ipvs->no_cport_conns[af_id]);
> -			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> -			cp->cport = cport;
> -		}
>  	}
-- 
pw-bot: cr
