Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802563;
	b=F/n+unA285iC/7h/bdqQYm6qM5H6iF1roByNjLd/DUfBCxLL0vPPhQPRsOI9WpTIOv2Z
	 zc8g6UJIaAce+G6v0mbGk+oIXd1/k1dktVM4quqC7B+za8cfPyWWt9FU4rp0phO9zWIla
	 RNkft51emybhcRwx3tEteQSwQyeo1U8V5Z+NkkPpXvjFM625TYFE1W/otDkqHr1K75/Tn
	 p3mo00vB4QGXP7yD2EgI+RrMRm6PeZbuNdxYwI5yKS3PlQJtuSaWoyTdqPJASDS+xqgyv
	 TQd+YV3tsMUers6SCQYkHvSxqW2nwFk/ZQhZ2ayvDkOLaEC6+LeJPSZycQAI5YzrCsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802563;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=I5DNhQKBXKWPfnks7El/ZApj2ggp1ly0AvEZnMXFAI8=;
	b=hDj/vNM5U6km8yppfRDjPrhhat/u4A9Nrh83w3PJ9YkS16zl2LjIVnm9IKgU3cfXwyz2
	 BVW5ebubwaX49wkem3w8u4r18aeLJRA1/YkUMeGDo9dOYWwr8Ll83AHSnKDioinqZRAWI
	 YX73S8zdTwho8o5vByBsCU+glwkAxCjYhzJmrnoLy9JU0+9ZYiqlFWpzs9UZEXwoUyXpb
	 tZLJtpUUHbWew6UnI950qS6wfPKgNQyaowxEHo/OqdFD7+lzUrfdIqMDReJS+j+1nXRoU
	 hfyE28ZL+UshhsoXfWpufU3UCgjZD4Bg1+rlB+RlZYDaaHiaZnyviGsuHxxfTyHzi+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="f8asL/xu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9688D606A326;
	Wed,  4 Nov 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f8asL/xu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E31F00A02;
	Wed,  4 Nov 2026 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802563;
	bh=I5DNhQKBXKWPfnks7El/ZApj2ggp1ly0AvEZnMXFAI8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f8asL/xuHHkritAodra6rGoOFizLFTrwmQcy8AHQN+6IvlRDA0kjLNTwFfLeHgv1k
	 iDy+jwgfds4Imkft8yIqwPJ6MR7jYk9bpVPBK4jPHaYsk+E/lpu5ivQ3CeLjvGYIUq
	 zRZpEW5cgHBcPOG/c0+g5F5gSkSiex7Xqqu1ZDTysNSVSe6rH6sashVZUqV85YZIyu
	 CCOlHNmawoNlsj361DZgWHqOEM5zXajhjSepoMmaEyfPvgDsumgRX5ihKPcTqKUub3
	 AzFtmIttFnykgRUoS7Rc6BaU6YvpnVQtpzJ6Cr+pNqZvQOQBprFZbCpl4reNDpyRBi
	 LgfenO6B1vJUA==
Subject:
 Re: [PATCH net 02/15] ipvs: wait grace period while reusing dest from trash
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Wed, 04 Nov 2026 14:29:22 +0000
Message-ID: <179380256244.488856.5201657810018142750@kernel.org>
In-Reply-To: <20261103140308.591690-4-pablo@netfilter.org>
References: <20261103140308.591690-4-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] ipvs: wait for RCU grace period before calling
  ip_vs_start_estimator()
- [Low] The comment on the new `rcu_state` field in `struct ip_vs_dest`
  (include/net/ip_vs.h:1024) reads `/* GP cookie when trashed */`, but…

--

ipvs: wait grace period while reusing dest from trash

This patch fixes looping readers of the destination list. The loop happens
when a dest is removed and re-added through the destination trash before
an RCU grace period has elapsed. A grace-period cookie is saved with
get_state_synchronize_rcu() when dests are unlinked, and
cond_synchronize_rcu() is called before the dest is relinked. Dest edits
that unhash and rehash an entry in rs_table use the same mechanism.

Link: https://patch.msgid.link/cover.1789117690.git.zzyy19904204639@163.com/

> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 9a83bff32569d..50a2999beb01f 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1021,7 +1021,9 @@ struct ip_vs_dest {
>  
>  	struct rcu_head		rcu_head;
>  	struct list_head	t_list;		/* in dest_trash */
> -	unsigned int		in_rs_table:1;	/* we are in rs_table */
> +	unsigned long		rcu_state;	/* GP cookie when trashed */
                                                   ^^^^

[Severity: Low]
This isn't a bug, but is this comment on struct ip_vs_dest::rcu_state
complete?

The patch also writes rcu_state in __ip_vs_update_dest() when a live dest
is edited and unhashed from rs_table. That dest stays on
svc->destinations and never goes to the trash:

net/netfilter/ipvs/ip_vs_ctl.c:__ip_vs_update_dest() {
    ...
		if (unlinked) {
			dest->rcu_state = get_state_synchronize_rcu();
			/* Need grace period in this or next dest update */
			dest->need_gp = 1;
		}
    ...
}

ip_vs_rs_hash() then reads that cookie through need_gp before
hlist_add_head_rcu().

So the field holds either the trash-time cookie read by ip_vs_add_dest(),
or the edit-time unhash cookie read by ip_vs_rs_hash().

Could the comment say something like "GP cookie when unlinked (trash or
rehash)" to cover both uses?

> +	unsigned int		in_rs_table:1,	/* we are in rs_table */
> +				need_gp:1;	/* Need GP on rehash */
>  };
>  
>  /* The scheduler object */

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1566,11 +1615,18 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>  
>  		ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
>  		/* On error put back dest into the trash */
> -		if (ret < 0)
> -			ip_vs_trash_put_dest(svc->ipvs, dest, dest->idle_start,
> -					     false);
> -		else
> +		if (ret < 0) {
> +			ip_vs_trash_put_back(svc->ipvs, dest);
> +		} else {
> +			/* Readers may still follow the n_list/d_list of the
> +			 * unlinked dest, wait before linking it again.
> +			 */
> +			cond_synchronize_rcu(dest->rcu_state);
> +			/* need_gp matters only on dest edit, reinit it */
> +			dest->need_gp = 0;
> +
>  			__ip_vs_update_dest(svc, dest, udest, 1);
> +		}
>  	} else {
>  		/*
>  		 * Allocate and initialize the dest structure

[Severity: High]
Does cond_synchronize_rcu() need to come before ip_vs_start_estimator()
here?

The comment covers n_list and d_list, but dest->stats.est.list is a
third RCU-linked node that gets reused on this path. When the dest was
deleted, __ip_vs_del_dest() called ip_vs_stop_estimator(). For an
estimator that kthread 0 had already moved to a tick chain
(est->ktid >= 0), that does hlist_del_rcu(&est->list) on
td->chains[cid] and does not wait for a grace period.

The estimator kthreads walk that chain without service_mutex. They do it
in ip_vs_chain_estimation() under rcu_read_lock() taken in
ip_vs_tick_estimation(). So a reader can still be positioned on this
est when the dest is taken back out of the trash.

ip_vs_add_dest() calls ip_vs_start_estimator() before the new grace
period wait, and that rewrites the node right away:

net/netfilter/ipvs/ip_vs_est.c:ip_vs_start_estimator() {
    ...
	if (ret >= 0)
		hlist_add_head(&est->list, &ipvs->est_temp_list);
	else
		INIT_HLIST_NODE(&est->list);
    ...
}

On success, a reader still on the old chain follows est->list.next onto
ipvs->est_temp_list. That list is not RCU protected, and
ip_vs_stop_estimator() uses plain hlist_del() for ktid < 0 entries. The
reader can therefore end up dereferencing LIST_POISON1.

On failure, next becomes NULL and the walk ends early, skipping the
remaining estimators on td->chains[cid]. The failure path also never
reaches cond_synchronize_rcu() at all.

This is the same unlink-then-relink-without-a-grace-period problem the
patch fixes for n_list and d_list. It is reachable with the same
delete/re-add sequence from netlink or sockopt, as long as estimator
kthreads are running.

Would it work to move cond_synchronize_rcu(dest->rcu_state) up to just
after ip_vs_trash_get_dest() returns a dest? The wait would then cover
est->list too, on both the success and error paths. The comment could
be updated to mention the estimator list as well.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
