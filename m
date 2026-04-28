Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B2A3A5E72;
	Tue, 28 Apr 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388695; cv=none; b=MLfvPrM/qgq6KrajDd5myAXETu2dHrFcf7viM66RkSPo7bqEpED9VpjsG0VbmOpPs9i4p9HspZDLw6jcRMmjxQ28KibDRhbVjXS9pnac8IQZ++86Qk019SIiNFAoMcs1zK5VuXRGWXCSkldOVPIqeUskkHqqD862xUB2Xm1cpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388695; c=relaxed/simple;
	bh=GCK1Onfc/iDsKlQ8MeSIyUf2d0br21BFvxYAoZqp9D0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hZ1xSxOuDMj3+X3yePNaBTv9jJrOQwI7/tKxp3vaDyO5Y7nIC5M5C0mzCAig/xRtZh9hQ+bJ8Ac1a2r9c4VJK45rGTviLofJdogl4L8YlUA3TeMDhMRUITFvNrzG2w44qZEMsSSbq4brNEVTAZC4MLkkLTJxYpaXRHtj4CzWitM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=XwFjzUiU; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="XwFjzUiU"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 887952126E;
	Tue, 28 Apr 2026 18:04:46 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=vJ6PcO/uzYm11u5aAK8YNiVd7NpqRbZ/8+JgYipo2XM=; b=XwFjzUiUCTkP
	aYNoUlp2LeSuHc42pUo8UQtW1xQr+io7FWosV2HIT3QUI6QxwsoqZ7fpsKdQqgqA
	YSzJHISpb4sPIuBBKW073GmwmjFnG2xwacD/L/UN4Usv1vS6qpSO2oXFbLOVjJI5
	SPdIP91JoaooVTmK4+YXW7C2sxqqajuG4JWNSrQsrC1evsEbeHcIdH1I4XeYqVCT
	uOgjmBKP3ZXN1MVJQM/1f4ByoI8Rk39HUQmLs7b9IVJqxMpqaFLaQRvfFxP/n8Fy
	YH1N+a3WjvLJrdjN9rnaOG9phiInzHMVqvEUBrhK720MU1rsNUoMg2ghMYPHATdZ
	sJbt5u2+9APQKWTBkDwdA7YS2a2XmeJfUQpmpcfSw9XzP+L7jXMG/FbW9MiQdtiq
	Cg0X0w+v0G6m2GQuoiycu5pytMZK/Vf/a2/QqwGB8dYuzJMGXwzOuT29CXdxuAEk
	hyGVe1VVR7NcVM4unRyoGgkE3+POEG+0pRF7rSg5532IRfbUfZ4RFOo/3wlgXt3y
	8tazWXPS7movwNSISi9XTF29G0vjiCu91VDBG7Rs02W1sBa0UjDvgpYp3NMTWZuK
	thiPg66a3agd3/W9/ngnzwsV9nJ3ssrpoC8j0LmX3lPpUa10E3jVw2xc1TfuL4/L
	NqP+dc2+PyrrRIeQXKU0pYbNGmHadqQ=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 28 Apr 2026 18:04:44 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id B50626294A;
	Tue, 28 Apr 2026 18:04:42 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.18.1) with ESMTP id 63SF4exl051871;
	Tue, 28 Apr 2026 18:04:41 +0300
Date: Tue, 28 Apr 2026 18:04:40 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 11/11] ipvs: fix the spin_lock usage for RT build
In-Reply-To: <20260428021311.793367-1-kuba@kernel.org>
Message-ID: <e9ca18be-235a-81bf-a966-ca0414c86a9f@ssi.bg>
References: <20260424190513.32823-12-pablo@netfilter.org> <20260428021311.793367-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Mon, 27 Apr 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: fix the spin_lock usage for RT build
> 
> This patch fixes PREEMPT_RT issues with spin_lock usage under bit
> locks in the IPVS resizable hash tables, and reworks ip_vs_conn_hash(),
> ip_vs_conn_unlink(), and ip_vs_conn_fill_cport() accordingly.
> 
> Link: https://sashiko.dev/#/patchset/20260415200216.79699-1-ja%40ssi.bg
> Link: https://sashiko.dev/#/patchset/20260420165539.85174-4-ja%40ssi.bg
> Link: https://sashiko.dev/#/patchset/20260422135823.50489-4-ja%40ssi.bg
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 84a4921a7865..9e23cda84825 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> 
> [ ... ]
> 
> > @@ -637,6 +628,7 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
> >  	struct ip_vs_conn_hnode *hn;
> >  	u32 hash_key, hash_key_new;
> >  	struct ip_vs_conn_param p;
> > +	bool by_me = false;
> >  	int ntbl;
> >  	int dir;
> >  
> > @@ -664,8 +656,11 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
> >  		t = rcu_dereference(t->new_tbl);
> >  		ntbl++;
> >  		/* We are lost? */
> > -		if (ntbl >= 2)
> > +		if (ntbl >= 2) {
> > +			IP_VS_ERR_RL("%s(): Too many ht changes for dir %d\n",
> > +				     __func__, dir);
> >  			return;
> > +		}
> >  	}
> 
> Can the ntbl >= 2 early return strand cp in an unrecoverable state
> when it is reached on the dir=0 iteration after dir=1 has already
> committed partial state?

	The right word here is "unreachable" but still recovarable
on expiration.

> In the pre-patch code, cp->cport, the clearing of
> IP_VS_CONN_F_NO_CPORT, and the atomic_dec() of no_cport_conns[] were
> all performed together inside a single if (!dir) critical section, so
> an abort via ntbl >= 2 simply left cp->cport == 0 and a later packet
> could retry from scratch.

	We saw this concern in previous review, and now it
reappeared. We explained in the commit that this ntbl >= 2 is a
situation that should not occur and added error to catch it. It is
a code that avoids dead loop. For connection with double hashing,
filling cport is a two-step operation, we fill cport early in
dir 1 (dir 0 follows in second step) to allow the resizing work (if 
running concurrently) to see valid hash key (cp->cport) all the time.
It is not fatal if we attempt second rehashing after this resizing,
ip_vs_conn_fill_cport() detects this with a 'if (head != head2)'
check, i.e. we are already on the desired bucket. Here is what
happens on resizing running concurrently with filling cport:

conn_resize_work_handler                ip_vs_conn_fill_cport
-------------------------------------------------------------
Still keep old ipvs->conn_tab but
rcu_assign_pointer(t->new_tbl, t_new)
to attach new table to the current
one

                                        Any RCU read-side sections here
                                        complete before the resizing.
                                        They may see the new table and
                                        move the nodes there. ntbl will
                                        not change above 0.
                                        
first synchronize_rcu() call

                                        rcu_read_lock() - after the
                                        synchronize_rcu() in resize_work

                                        - we see the new table in t->new_tbl
start to move conn nodes to             - we first process dir=1 concurrently
t->new_tbl:                             with resizing, successfully
- change hn->hash_key under             
locks, now hn->hash_key points to       We now process dir=0 (hn0):
t->new_tbl and it is not changed        We may see the old hn->hash_key or
until new resize/fill_cport             the new one. The old matches the
                                        current table. When we reach the locks
                                        we will see the new value if it 
                                        is already assigned.

                                        When we see the early change of
                                        hn->hash_key which matches
                                        t->new_tbl (not t) => ntbl++ (ntbl
                                        becomes 1) and t jumps to t->new_tbl,
                                        i.e. we see that entry is linked
                                        already on the new table.

                                        In all cases we should see ntbl
                                        to reach 1, not more. Because we
                                        do the resizing in steps which
                                        avoid one RCU section to see many
                                        new tables.
                                        If ntbl becomes 2 we have some 
                                        kind of corruption,
                                        so we just exit the loop.

Finally, install t_new as
ipvs->conn_tab
                                        Alternatively, for dir=0 we can see
                                        the new ipvs->conn_tab, so here
                                        hn->hash_key will match both t and
                                        t->new_tbl (they are same) and
                                        dir=0 will never goto retry,
                                        ntbl remains 0.

> 
> [ ... ]
> 
> > -	spin_lock(&cp->lock);
> > -	if ((cp->flags & IP_VS_CONN_F_NO_CPORT) &&
> > -	    (cp->flags & IP_VS_CONN_F_HASHED)) {
> > +	/* Fill cport once, even if multiple packets try to do it */
> > +	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
> > +		/* If we race with resizing make sure cport is set for dir 1 */
> > +		if (!cp->cport) {
> > +			cp->cport = cport;
> > +			by_me = true;
> > +		}
> > +		if (!dir) {
> > +			atomic_dec(&ipvs->no_cport_conns[af_id]);
> > +			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> > +		}
> 
> With the new structure, the dir=1 iteration (which runs first when
> use2 is true) sets cp->cport = cport and by_me = true, but leaves
> IP_VS_CONN_F_NO_CPORT set and does not touch no_cport_conns[].  The
> flag clear and the atomic_dec happen only in the subsequent dir=0
> iteration.
> 
> If the dir=0 iteration then returns early via the ntbl >= 2 path,
> either directly on entry or after an accumulated ntbl across retry:
> restarts (ntbl is reset per next_dir, not per retry), cp ends up
> with cp->cport set to the new value but IP_VS_CONN_F_NO_CPORT still
> set.
> 
> Can any subsequent ip_vs_conn_fill_cport() call complete the
> transition?  The gate is:
> 
> 	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
> 
> For a fresh caller, by_me is false and cp->cport is now non-zero, so
> the gate is structurally unsatisfiable and the flag clear /
> atomic_dec never runs.
> 
> In __ip_vs_conn_in_get() the lookup
> 
> 	!p->cport ^ !(cp->flags & IP_VS_CONN_F_NO_CPORT)
> 
> evaluates false for this cp (flag still set, p->cport non-zero), and
> the cport=0 fallback also fails since p->cport != cp->cport (cp->cport
> is now non-zero).  Does this leave cp unreachable via forward
> direction lookup until the timer expires?

	Yes, we suspect corruption. If it is broken data in
the connection we isolate it (not reachable via lookup) and
then let it expire and later restore the no_cport_conns
counter. If we try to restore the cp->cport to 0 on ntbl >= 2
then we should go and rehash hn1 (dir=1) but it is not fatal
if we do not rehash it because next packet will come again in 
ip_vs_conn_fill_cport() and rehash it properly. This can be
done if we want retransmitted packet to continue with the
connection instead of expiring it:

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 9e23cda84825..9ea6b4fa78bf 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -657,6 +657,11 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
 		ntbl++;
 		/* We are lost? */
 		if (ntbl >= 2) {
+			spin_lock_bh(&cp->lock);
+			if (cp->flags & IP_VS_CONN_F_NO_CPORT && by_me)
+				cp->cport = 0;
+			/* hn1 will be rehashed on next packet */
+			spin_unlock_bh(&cp->lock);
 			IP_VS_ERR_RL("%s(): Too many ht changes for dir %d\n",
 				     __func__, dir);
 			return;

	I.e. this is a change we can do but in all cases we
are not sure why ntbl reaches 2.

> As a side effect, does no_cport_conns[af_id] stay elevated for the
> remainder of cp's lifetime, forcing ip_vs_conn_in_get() into the
> slower cport=0 fallback path for that af/netns while the stuck entry
> lives?

	For FTP service we are often using double lookup
when PASV connections are in negotiation phase (each up
to 120 secs).

Regards

--
Julian Anastasov <ja@ssi.bg>

