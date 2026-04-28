Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA11379EC4;
	Tue, 28 Apr 2026 02:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777342395; cv=none; b=fcw2gmlgxePZUTWqD0bQF+DIx2CPErZo8lMybrikqrH+Td+YgoRuARtEwvE9nYHFL5T6/e/G4ZyUJFQNQMu22FXJo8eBM5LBWCkt4vS5p2AkBbHjtNiP18tasdb7CbGHoeUQiv23UziwGAOPAHNSOvdVtm7wy0u2ddszkkA+2+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777342395; c=relaxed/simple;
	bh=xyMpV0FK4Ngqyen1vRZuh5Pl2265SYBluoI7GajV8uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jna4T+FOfky2w4wT0hgvMe6CQoU3BRTEEjYNR5cUvmLuesQokQU/19W6t5357WuTHEkNekDwmnWyTC0NhGOzumVA0i9A7ZzlzyawzSnXWgB5BvooCQnCwvNIenVzIb/gd8OY388Ay0nGTwvwMRe/CTJxZcYP2FO0R8TcuUZbTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE0G5cD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE0G5cD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9987C19425;
	Tue, 28 Apr 2026 02:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777342395;
	bh=xyMpV0FK4Ngqyen1vRZuh5Pl2265SYBluoI7GajV8uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE0G5cD80VLE+Fseoeh9/IybAY83APnABjoyYWqAuJEx1dnjheOTtZD1S8/zKYWp7
	 f/DTErocbqIgkBQ/kuTh+eA7C70v/+qo8smTBO2RU+TtmuBWYXzQ8qNaor5odjUta/
	 nHaVg/3Pwt72mrhGg11B9okpeXwLjLEcoQ5cj5Apy0KVPkoUxYzTnmYx8h/IrcIAgm
	 w1quN8sjWOE6hdaDvptZ5+OYOaL1Q1b31lGrVSyQZY0sQQ1isIXavv7LzRi8kQCPFb
	 NwgxXBzSYcUuHPhodxIbOP1zZZtDYSoY2kUFC/wOW0XSubN6vIY6FqEmqZBztxRTIn
	 kq7rjJ7iexeeg==
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
Date: Mon, 27 Apr 2026 19:13:11 -0700
Message-ID: <20260428021311.793367-1-kuba@kernel.org>
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

This patch fixes PREEMPT_RT issues with spin_lock usage under bit
locks in the IPVS resizable hash tables, and reworks ip_vs_conn_hash(),
ip_vs_conn_unlink(), and ip_vs_conn_fill_cport() accordingly.

Link: https://sashiko.dev/#/patchset/20260415200216.79699-1-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260420165539.85174-4-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260422135823.50489-4-ja%40ssi.bg

> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 84a4921a7865..9e23cda84825 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c

[ ... ]

> @@ -637,6 +628,7 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
>  	struct ip_vs_conn_hnode *hn;
>  	u32 hash_key, hash_key_new;
>  	struct ip_vs_conn_param p;
> +	bool by_me = false;
>  	int ntbl;
>  	int dir;
>  
> @@ -664,8 +656,11 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
>  		t = rcu_dereference(t->new_tbl);
>  		ntbl++;
>  		/* We are lost? */
> -		if (ntbl >= 2)
> +		if (ntbl >= 2) {
> +			IP_VS_ERR_RL("%s(): Too many ht changes for dir %d\n",
> +				     __func__, dir);
>  			return;
> +		}
>  	}

Can the ntbl >= 2 early return strand cp in an unrecoverable state
when it is reached on the dir=0 iteration after dir=1 has already
committed partial state?

In the pre-patch code, cp->cport, the clearing of
IP_VS_CONN_F_NO_CPORT, and the atomic_dec() of no_cport_conns[] were
all performed together inside a single if (!dir) critical section, so
an abort via ntbl >= 2 simply left cp->cport == 0 and a later packet
could retry from scratch.

[ ... ]

> -	spin_lock(&cp->lock);
> -	if ((cp->flags & IP_VS_CONN_F_NO_CPORT) &&
> -	    (cp->flags & IP_VS_CONN_F_HASHED)) {
> +	/* Fill cport once, even if multiple packets try to do it */
> +	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
> +		/* If we race with resizing make sure cport is set for dir 1 */
> +		if (!cp->cport) {
> +			cp->cport = cport;
> +			by_me = true;
> +		}
> +		if (!dir) {
> +			atomic_dec(&ipvs->no_cport_conns[af_id]);
> +			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> +		}

With the new structure, the dir=1 iteration (which runs first when
use2 is true) sets cp->cport = cport and by_me = true, but leaves
IP_VS_CONN_F_NO_CPORT set and does not touch no_cport_conns[].  The
flag clear and the atomic_dec happen only in the subsequent dir=0
iteration.

If the dir=0 iteration then returns early via the ntbl >= 2 path,
either directly on entry or after an accumulated ntbl across retry:
restarts (ntbl is reset per next_dir, not per retry), cp ends up
with cp->cport set to the new value but IP_VS_CONN_F_NO_CPORT still
set.

Can any subsequent ip_vs_conn_fill_cport() call complete the
transition?  The gate is:

	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {

For a fresh caller, by_me is false and cp->cport is now non-zero, so
the gate is structurally unsatisfiable and the flag clear /
atomic_dec never runs.

In __ip_vs_conn_in_get() the lookup

	!p->cport ^ !(cp->flags & IP_VS_CONN_F_NO_CPORT)

evaluates false for this cp (flag still set, p->cport non-zero), and
the cport=0 fallback also fails since p->cport != cp->cport (cp->cport
is now non-zero).  Does this leave cp unreachable via forward
direction lookup until the timer expires?

As a side effect, does no_cport_conns[af_id] stay elevated for the
remainder of cp's lifetime, forcing ip_vs_conn_in_get() into the
slower cport=0 fallback path for that af/netns while the stuck entry
lives?

> -		if (!dir) {
> -			atomic_dec(&ipvs->no_cport_conns[af_id]);
> -			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> -			cp->cport = cport;
> -		}
>  	}
> -	spin_unlock(&cp->lock);
>  
>  	if (head != head2)
>  		hlist_bl_unlock(head2);
>  	hlist_bl_unlock(head);
>  	write_seqcount_end(&t->seqc[hash_key & t->seqc_mask]);
>  	preempt_enable_nested();
> -	spin_unlock_bh(&t->lock[hash_key & t->lock_mask].l);
> -	if (dir--)
> +	spin_unlock(&t->lock[hash_key & t->lock_mask].l);
> +
> +	spin_unlock_bh(&cp->lock);
> +	if (dir-- && by_me)
>  		goto next_dir;
>  }
-- 
pw-bot: cr
