Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814699;
	b=0nzwFIy+FI/UgY2Rz+bqtKd710UyuTDo9gfl96OGwAVvsztT+6spXApEDU8aXCLETT08
	 IMdaPeksEvirwXNx/6grtaGOwxEEBNKWEndzOYVwK4G8YZO0YcWX6lmO1egA/JR4XWjPW
	 t9Mhr5zeAJMAfm1DnfGnCQodwQsN7ZeI3VaBnZkkv17KT5CfVjC0oAHZbVsGu9vY8g0Cj
	 FUIYzMJyv+OWWU2e0a4O7Il+odUAEJixgXGUv18rwLy5Q6WoU+S3Ii1kizd/ozdC2bqIT
	 mKyuFqlLyk2D7giOQ5Yz0v/Fi5ydzXzgyOVZj9uCUmq4PUoeDF23ROJ2XQ1BFlAbSBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814699;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=XY0mubsP7uDO9gkwtpBmX8933oxcyhJjKuVbFSfAAss=;
	b=JaIHqU639JNMRSF26oz6CbjrbEb0vhWYuK55Q3kS1ox87fXutQFXYfNwusrMqwwvj+6G
	 FR9VB4rFUBsbZ35DKM+UAxglsRoZ4vGZGu+HoYlBbWevCnx1qEBji9arpAgglhnAHTQR3
	 BT26YpCndJbpibJdTWV37+aKU/LAPlTg4EIv17J8dyji0FW9SAySX9J3Y34CXjceK4EGI
	 66iGc7wfUqXQIJblZlzADoHzWzj/fgk7HM3gEdv+mQLUJx53xyZTIwL9AU91ZkDEj2Cjw
	 G9UweAAoDx9GAGVGSGO7lUNjMPCsncVMMIP6IkZL1WaBC9lRjKYBvcK9mBQKtFZnfqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b="1Xjl3Cj/";
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373C606F6AC;
	Wed,  4 Nov 2026 17:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A373C606F6AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=1Xjl3Cj/
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 8747A213F4;
	Wed, 04 Nov 2026 19:51:34 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=XY0mubsP7uDO9gkwtpBmX8933oxcyhJjKuVbFSfAAss=; b=1Xjl3Cj/bqhx
	akeGNSpPwXW9PrJLykxK1jWN/431hbHPJIqVC1N1Pq1TNlhDGDyYq/ktuYfO2kfK
	IXBukpm+WMZQMC2bSSlB3hd86B0XOZmbByKBd7NeDkXTq5W+ws4zr0y+o6cx5/il
	1Y3NrdD6Dx1AhidXK1atxcp5oqVcNXo503kW4/1u09smYatIr/p8Nwkr2xL14qu7
	bnaSYf8lXyLpOrCyDz1VFTU/lef8JHoafczDrv2ImbsCE1s7ISCgsbVygzhqDI2b
	HTOe819T5Yw18aSUwuV6Z3EgavbUz/O2k6QpfsANvoKC4Gs8a4oS17plLApCjlZb
	IymfGgI1neRtS0MibubbRNiIpDWLiGjrQwPzrdavJfTrckz4DXtIqXXjNYVlYqiQ
	FoB/CbZdOkscaJd8Nj+DJcwLGBcW/FfIif5AU19LJKN+aoIiOrSlRkJfY8+ItpPK
	VAYkmyecqYvmxBkIy+zFu81qc80FJXZID/0y2YKT9vzrbPP67MmljMXEq34Q2m1i
	Aej/YbovugwIv+yJ9031HdzOyK3gEq5VxSjS8D00td8LLo6Sbpqxtbq6TmaLk9mC
	FPUZAvmzhtKyXEhbzuNOyK9DZ9TGamaS2DO5+9FP02u67DpfyI3y+X/TC6EWrjFn
	h1pB5sB840V6a1hslhEUh8kOvigx/uI=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Wed, 04 Nov 2026 19:51:34 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 0E024602AD;
	Wed,  4 Nov 2026 19:51:34 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6A4HpUCb126453;
	Wed, 4 Nov 2026 19:51:30 +0200
Date: Wed, 4 Nov 2026 19:51:30 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
        horms@kernel.org, fw@strlen.de, Ren Wei <weir@nebusec.ai>,
        vega@nebusec.ai, zzyy19904204639@163.com, jiayuan.chen@linux.dev
Subject: Re: [PATCH net 02/15] ipvs: wait grace period while reusing dest
 from trash
In-Reply-To: <179380256244.488856.5201657810018142750@kernel.org>
Message-ID: <a0fe09d8-9f3b-d3dc-bee4-c8495ccd9598@ssi.bg>
References: <20261103140308.591690-4-pablo@netfilter.org> <179380256244.488856.5201657810018142750@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1120207573-1793814692=:116704"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1120207573-1793814692=:116704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

	Adding other authors to CC. In short, the plan is to
create new version.

On Wed, 4 Nov 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] ipvs: wait for RCU grace period before calling
>   ip_vs_start_estimator()
> - [Low] The comment on the new `rcu_state` field in `struct ip_vs_dest`
>   (include/net/ip_vs.h:1024) reads `/* GP cookie when trashed */`, but…
> 
> --
> 
> ipvs: wait grace period while reusing dest from trash
> 
> This patch fixes looping readers of the destination list. The loop happens
> when a dest is removed and re-added through the destination trash before
> an RCU grace period has elapsed. A grace-period cookie is saved with
> get_state_synchronize_rcu() when dests are unlinked, and
> cond_synchronize_rcu() is called before the dest is relinked. Dest edits
> that unhash and rehash an entry in rs_table use the same mechanism.
> 
> Link: https://patch.msgid.link/cover.1789117690.git.zzyy19904204639@163.com/
> 
> > diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> > index 9a83bff32569d..50a2999beb01f 100644
> > --- a/include/net/ip_vs.h
> > +++ b/include/net/ip_vs.h
> > @@ -1021,7 +1021,9 @@ struct ip_vs_dest {
> >  
> >  	struct rcu_head		rcu_head;
> >  	struct list_head	t_list;		/* in dest_trash */
> > -	unsigned int		in_rs_table:1;	/* we are in rs_table */
> > +	unsigned long		rcu_state;	/* GP cookie when trashed */
>                                                    ^^^^
> 
> [Severity: Low]
> This isn't a bug, but is this comment on struct ip_vs_dest::rcu_state
> complete?
> 
> The patch also writes rcu_state in __ip_vs_update_dest() when a live dest
> is edited and unhashed from rs_table. That dest stays on
> svc->destinations and never goes to the trash:
> 
> net/netfilter/ipvs/ip_vs_ctl.c:__ip_vs_update_dest() {
>     ...
> 		if (unlinked) {
> 			dest->rcu_state = get_state_synchronize_rcu();
> 			/* Need grace period in this or next dest update */
> 			dest->need_gp = 1;
> 		}
>     ...
> }
> 
> ip_vs_rs_hash() then reads that cookie through need_gp before
> hlist_add_head_rcu().
> 
> So the field holds either the trash-time cookie read by ip_vs_add_dest(),
> or the edit-time unhash cookie read by ip_vs_rs_hash().
> 
> Could the comment say something like "GP cookie when unlinked (trash or
> rehash)" to cover both uses?

	Sounds good

> 
> > +	unsigned int		in_rs_table:1,	/* we are in rs_table */
> > +				need_gp:1;	/* Need GP on rehash */
> >  };
> >  
> >  /* The scheduler object */
> 
> [ ... ]
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -1566,11 +1615,18 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
> >  
> >  		ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
> >  		/* On error put back dest into the trash */
> > -		if (ret < 0)
> > -			ip_vs_trash_put_dest(svc->ipvs, dest, dest->idle_start,
> > -					     false);
> > -		else
> > +		if (ret < 0) {
> > +			ip_vs_trash_put_back(svc->ipvs, dest);
> > +		} else {
> > +			/* Readers may still follow the n_list/d_list of the
> > +			 * unlinked dest, wait before linking it again.
> > +			 */
> > +			cond_synchronize_rcu(dest->rcu_state);
> > +			/* need_gp matters only on dest edit, reinit it */
> > +			dest->need_gp = 0;
> > +
> >  			__ip_vs_update_dest(svc, dest, udest, 1);
> > +		}
> >  	} else {
> >  		/*
> >  		 * Allocate and initialize the dest structure
> 
> [Severity: High]
> Does cond_synchronize_rcu() need to come before ip_vs_start_estimator()
> here?
> 
> The comment covers n_list and d_list, but dest->stats.est.list is a
> third RCU-linked node that gets reused on this path. When the dest was
> deleted, __ip_vs_del_dest() called ip_vs_stop_estimator(). For an
> estimator that kthread 0 had already moved to a tick chain
> (est->ktid >= 0), that does hlist_del_rcu(&est->list) on
> td->chains[cid] and does not wait for a grace period.
> 
> The estimator kthreads walk that chain without service_mutex. They do it
> in ip_vs_chain_estimation() under rcu_read_lock() taken in
> ip_vs_tick_estimation(). So a reader can still be positioned on this
> est when the dest is taken back out of the trash.
> 
> ip_vs_add_dest() calls ip_vs_start_estimator() before the new grace
> period wait, and that rewrites the node right away:
> 
> net/netfilter/ipvs/ip_vs_est.c:ip_vs_start_estimator() {
>     ...
> 	if (ret >= 0)
> 		hlist_add_head(&est->list, &ipvs->est_temp_list);
> 	else
> 		INIT_HLIST_NODE(&est->list);
>     ...
> }
> 
> On success, a reader still on the old chain follows est->list.next onto
> ipvs->est_temp_list. That list is not RCU protected, and
> ip_vs_stop_estimator() uses plain hlist_del() for ktid < 0 entries. The
> reader can therefore end up dereferencing LIST_POISON1.
> 
> On failure, next becomes NULL and the walk ends early, skipping the
> remaining estimators on td->chains[cid]. The failure path also never
> reaches cond_synchronize_rcu() at all.
> 
> This is the same unlink-then-relink-without-a-grace-period problem the
> patch fixes for n_list and d_list. It is reachable with the same
> delete/re-add sequence from netlink or sockopt, as long as estimator
> kthreads are running.
> 
> Would it work to move cond_synchronize_rcu(dest->rcu_state) up to just
> after ip_vs_trash_get_dest() returns a dest? The wait would then cover
> est->list too, on both the success and error paths. The comment could
> be updated to mention the estimator list as well.

	Yep, this is the right thing to do

> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1120207573-1793814692=:116704--

