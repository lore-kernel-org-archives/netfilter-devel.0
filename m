Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1450235836B;
	Tue, 28 Apr 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777390063; cv=none; b=jgwkyx05aRVbgSMzJAEUaiDnFYBeQfGM3ZkhUpZZrKFQUK0M+qgBLOmphqiv2BMQTxJ965VNTdHEeKIKYy3998qvQ+wB3lrNZ8Y3bIaHvhRcJwvrJBFFfJScVsDZTrZBnqRjtASYHf+vyGuWQXutmWvmj2bxjibg2jayRVKjjCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777390063; c=relaxed/simple;
	bh=lsjtwml+YyGG0YaI8ATuHSZR2T/x/VtRiCX7ZflwJ8o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kMQqedn1+v2KgCr2PVRFE1K1fU0S9XFO3/UwKvwDVBpP8GLzvq+6PeUZgNKh9DmkKXwj4X1a77hydBhc81K5IY+CdMR5BZxA/39qXBK4VoKo8HRyzvUgp5sqF9AkecwbA+UBWyMdZPFe5UntkS55aonVfFAukqskQkzBFDdd6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=NncjKPWn; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="NncjKPWn"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 874BB211C1;
	Tue, 28 Apr 2026 18:27:37 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=pjpyrc4xMqg+uJtCyIqcY2E8Dl2BnGTrVI0ieQmBu9o=; b=NncjKPWnt8Dn
	sCea/Lc99bDQo+rHD8TYU9Hti7z1M3TdQ1y1RpHhSIQ0/qopds1BHlgmvumxZnov
	+dq+vXj+wEFWwI5OfQ8aws7+2MAoV0LZdR1Yp4RwzG9N0yNPwodxLeRKJ0xvshCA
	7lGwFq++hoeN8Gpr3N7wvI9Wcy9DZF3sL3Q+slHBp2A8T4DgOB6UHnf/5glX3g1L
	XRfWpmEs8k3dGInTKVf169ABNgR0ZoZg6CvsAc+SKgJBKlbwxRXOvF7A4uZJXU3S
	sa78uGEHVqc9Qh7L1qSlD1Cw9yN5vuTM2mzGj+NbqARzMTEYhIx1xwaHpeBi5XVN
	gl/S9T9HiOC3jeSk7GBcMpX8+57f4o0xfMjC1HXUZb7Wgjvbe5gwG0rXdP6tESV1
	I8Itp67FuWUc5LIDtoJCZZvfH3jYzubjjmSLOtzKyO1AKNYEsFB6C1h7LsjA893T
	Oh+gggyUbISD6S9mT1kdNuU5y0/b67rZycIuZNj031/8L9EBX0TKNzbEcyOdLHqW
	WAC25/QSGWlgDh9CxuOrg7HL6g9YwNHw8ez78xS6f0Pp0vdhb8R9lxm7Z8RT5DTC
	wSel0dbylDleAA16orVy7YepBapWyxhpuhvf7j8CgCRcxxXSHyPhjj/6DjRfUfwP
	nDmi59T8ek9mwihbHhVnvCnAWpbf7Oc=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 28 Apr 2026 18:27:36 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 901096089E;
	Tue, 28 Apr 2026 18:27:35 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.18.1) with ESMTP id 63SFRYQE053671;
	Tue, 28 Apr 2026 18:27:34 +0300
Date: Tue, 28 Apr 2026 18:27:34 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 11/11] ipvs: fix the spin_lock usage for RT build
In-Reply-To: <20260428021343.793695-1-kuba@kernel.org>
Message-ID: <b50e8ade-41ba-ab49-b1e4-81ebe8df03c2@ssi.bg>
References: <20260424190513.32823-12-pablo@netfilter.org> <20260428021343.793695-1-kuba@kernel.org>
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
> This commit fixes spin_lock sleeping issues on PREEMPT_RT by adjusting the
> use of cp->lock in combination with hlist_bl bit locks. It removes the
> spin_lock from ip_vs_conn_hash() and ip_vs_conn_unlink(), and changes the
> lock ordering in ip_vs_conn_fill_cport().
> 
> Link: https://sashiko.dev/#/patchset/20260415200216.79699-1-ja%40ssi.bg
> Link: https://sashiko.dev/#/patchset/20260420165539.85174-4-ja%40ssi.bg
> Link: https://sashiko.dev/#/patchset/20260422135823.50489-4-ja%40ssi.bg
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 84a4921a7865a9..9e23cda8482588 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> 
> [ ... ]
> 
> > @@ -704,14 +702,23 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
> >  		hlist_bl_unlock(head);
> >  		write_seqcount_end(&t->seqc[hash_key & t->seqc_mask]);
> >  		preempt_enable_nested();
> > -		spin_unlock_bh(&t->lock[hash_key & t->lock_mask].l);
> > +		spin_unlock(&t->lock[hash_key & t->lock_mask].l);
> > +		spin_unlock_bh(&cp->lock);
> >  		hash_key = hash_key_new;
> >  		goto retry;
> >  	}
> >  
> > -	spin_lock(&cp->lock);
> > -	if ((cp->flags & IP_VS_CONN_F_NO_CPORT) &&
> > -	    (cp->flags & IP_VS_CONN_F_HASHED)) {
> > +	/* Fill cport once, even if multiple packets try to do it */
> > +	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
> 
> Does removing the IP_VS_CONN_F_HASHED check here lead to a NULL pointer
> dereference for IP_VS_CONN_F_ONE_PACKET connections?
> 
> Connections flagged with IP_VS_CONN_F_ONE_PACKET bypass hashing:
> 
> ip_vs_conn_hash() {
>     if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
>         return 0;
>     ...
> }
> 
> Because they bypass hashing, their hash list nodes (hn->node) are never
> linked, leaving hn->node.pprev as NULL. If such a connection is created
> with a source port of 0, it gets the IP_VS_CONN_F_NO_CPORT flag.
> 
> When ip_vs_conn_fill_cport() is later invoked to populate the port, the
> missing IP_VS_CONN_F_HASHED check allows the execution to proceed.

	But ip_vs_conn_fill_cport() is called for connection
that is hashed and later found by lookup. If IP_VS_CONN_F_ONE_PACKET
is set the conn is not hashed and is released immediately after
creation by ip_vs_conn_put(). Both flags can not coexist, one or
the other wins.

	As for IP_VS_CONN_F_NO_CPORT, ip_vs_bind_dest() clears the
IP_VS_CONN_F_ONE_PACKET flag if not UDP and we use NO_CPORT for TCP.
So, IP_VS_CONN_F_ONE_PACKET is simply ignored for TCP. If one day
we start to use IP_VS_CONN_F_NO_CPORT for UDP and use
IP_VS_CONN_F_ONE_PACKET then it will not work because the conn will
not be hashed and as result never found to fill the cport.
This time IP_VS_CONN_F_ONE_PACKET will win the game.

> 
> > +		/* If we race with resizing make sure cport is set for dir 1 */
> > +		if (!cp->cport) {
> > +			cp->cport = cport;
> > +			by_me = true;
> > +		}
> > +		if (!dir) {
> > +			atomic_dec(&ipvs->no_cport_conns[af_id]);
> > +			cp->flags &= ~IP_VS_CONN_F_NO_CPORT;
> > +		}
> >  		/* We do not recalc hash_key_r under lock, we assume the
> >  		 * parameters in cp do not change, i.e. cport is
> >  		 * the only possible change.
> > @@ -726,21 +733,17 @@ void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport)
> >  			hlist_bl_del_rcu(&hn->node);
> 
> If head != head2 here, hlist_bl_del_rcu(&hn->node) is called. Since
> hn->node.pprev is NULL, wouldn't this cause a panic when __hlist_bl_del()
> executes *pprev = next?
> 
> Is it possible to retain the IP_VS_CONN_F_HASHED check or otherwise
> ensure unhashed nodes aren't unlinked?

	As IP_VS_CONN_F_ONE_PACKET conns are not hashed,
ip_vs_conn_unlink() has check not to unlink the conn nodes from
tables. The conn is invisible to others except the packet
that created it. And the hash nodes are not touched.

Regards

--
Julian Anastasov <ja@ssi.bg>

