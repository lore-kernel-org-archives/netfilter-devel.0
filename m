Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792642352;
	b=o1Urokxeulb2+Gw6FXoUuisdGNCy2nuQ4gjG8QtPY/J3vwxAm2xo5x/n1bUp9MdI1rYB
	 UcrRW+nChjEc1mpkLbbuNM01rHPZWwY6GT6NTa4AGdAvrpd3eC09wkiZgAdGFk31X1pLj
	 PiTunTga8pP3lGCF/tHd18Gy1eZtA+ipsPZ+1e2oPSDCvh47eYMc/wbjFbgIEiScGEAjp
	 Be7OY+t0nGI4g4+6CmexfBMKcOepdfPxU8KxkaXh38p1f+1Py5wVfrAIt8T85EAYfPYlu
	 /2HqtBgthVCYG0hgTytqdN28D8PwzAUs5uUg1tUKlbFSnH8+n7w7s4swXubn/SM5REg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792642352;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=hwivbQe60nlfp+5zir3I+UkPExP1y7S/LrONdfDBgLM=;
	b=CRwMs2SbKdcC/L5YYH/FYKkCYIxJrHjoZIVGeKHXqdMaIRO+6pJCyfa6qQazRWx7BbSX
	 u2Y98hdy1TAPecofd+6lQy0XNREI1Pb4EhUyxPByzI/onhiqjKgh5VdiuOg3dKstAGC2k
	 70AozUYMV4PiTLQVnLLX34wxSkMSNQ+UzYFUkediLN9XI9/v8moGIIAgN6xM98e3wVK5z
	 s+FwhakOsXbgOgcZJPKf+TdxQ0xuHN1kxf8YFO936fYfxmS/ageIpoNOJ2tfhMFbee9Uu
	 1dyQY0DLIUdczE2VBdjg9kfUCct4iYw6k8lt/oyWiPPb018XlPTrXvMVWWgXC9j6RfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F98606A320;
	Thu, 22 Oct 2026 04:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1F98606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 906F5225BB;
	Thu, 22 Oct 2026 07:12:26 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=hwivbQe60nlfp+5zir3I+UkPExP1y7S/LrONdfDBgLM=; b=fjLVZF9Vh5Gc
	aHp6NOW2vyo3G1iKzpDPOm3VBWDNOIaQqJHSWVFkDGn6iV7cWHvHSn2SF/j4ek1i
	Mj2+4TztlIg/FoHKUWykj7VnOryNeq/iR2ROUH87/6T5a6SlF1eAhXQ8bMfmwFYl
	/OoGL7Z+fg30IAd8Lp9HlQ/3tZ5E93LUrFmOZwzwmUiadt9IG24ovoMVttAomDyK
	eJN894127DWn+phQrDldfMcXLhHoyL6P4HwPksvFW+BzzI0sRQGiFV5d+IId3D/G
	BYi9AFeFO6+pw8w3NjvMImWkuaUi+xQKu62jSmHrkSa8zIY4tbj+t4uNFFeUTtEw
	taUe9d0pfW1DX9ll9UIuVRp+wYJ/Z/uZCo2zQRjL4/VgfbGXjqfxBG8K8+PfXP+C
	qzCkfAybLlKutftRnWvP4EgU0EQB5A6VggSsgqnz7/tiMNG5XJDFVwa2JIOQ23nA
	+wUm9CGbPmkHRQ57UM4Ho/Imt6uovWxm6osXe8GKhFHWY394moFzvNRoAr2dju1l
	8M4y9WxxzQR1SQkf+1xXbUt6JC7aTsF5f7ZATL1EHo4sXHx93H5F5JK3bmnba9eN
	vlir6RuQk7lb4ueNQwTmAPVC8ggKdVeSPQbDBWTJce0uW5urqnRv2ArnpOq88ncO
	EoE5LRg6cZlhS1wnyNTTUEAyGIv4Q+k=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Thu, 22 Oct 2026 07:12:26 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 4079F609C4;
	Thu, 22 Oct 2026 07:12:27 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 69M4CNfe011887;
	Thu, 22 Oct 2026 07:12:24 +0300
Date: Thu, 22 Oct 2026 07:12:23 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 03/10] ipvs: fix more races around the overload
 flag
In-Reply-To: <179251059359.3135.4423672797381402162@kernel.org>
Message-ID: <d0fa3d74-3e93-326b-8865-23ea69b84afb@ssi.bg>
References: <20261019150249.1879516-4-pablo@netfilter.org> <179251059359.3135.4423672797381402162@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-190150251-1792642345=:9148"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-190150251-1792642345=:9148
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Tue, 20 Oct 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 (1) · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] A threshold edit that moves a dest into the overloaded state can
>   race with the unbind of its last connection, and the clear is lost.
> - [Low] A new dest created with no thresholds (u_threshold == 0 and
>   l_threshold == 0) is published with u_threshold_val == 0 instead of…
> - [Low] The commit message and the comments do not match what the code
>   now does.
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but on a cache
>   hit ip_vs_lblc_schedule() (net/netfilter/ipvs/ip_vs_lblc.c:509-511)…
> 
> --
> 
> ipvs: fix more races around the overload flag
> 
> This commit replaces the IP_VS_DEST_F_OVERLOAD flag with a two-state
> scheme built on l_threshold_val and u_threshold_val. With it,
> ip_vs_bind_dest() and ip_vs_unbind_dest() can change the overload state
> at any count beyond the thresholds, not only at the exact threshold
> values. All schedulers now use the new ip_vs_dest_is_overloaded() helper,
> and struct ip_vs_dest is reordered to keep the hot fields in the first
> cacheline.
> 
> Link: https://sashiko.dev/#/patchset/20260810190621.894119-1-pablo%40netfilter.org
> 
> > diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> > index 32fde731bceb..9a83bff32569 100644
> > --- a/include/net/ip_vs.h
> > +++ b/include/net/ip_vs.h
> 
> [ ... ]
> 
> > @@ -973,32 +970,43 @@ struct ip_vs_dest_dst {
> >   * and so on.
> >   */
> >  struct ip_vs_dest {
> 
> [ ... ]
> 
> > +	/* connection thresholds */
> > +	u32			l_threshold_val;/* used lower threshold */
> > +	u32			u_threshold_val;/* used upper threshold */
> 
> [Severity: Low]
> This isn't a bug, but the commit message says:
> 
>     To make it work without entering the locked region for
>     every connection, we introduce l_threshold_val.
> 
> l_threshold_val already existed. It was added by 8f843441c4e7, and this
> hunk removes the old __u32 l_threshold_val declaration further down. The
> only new field is u_threshold_val. What changed is the meaning: a
> non-zero l_threshold_val now means overloaded, which is what
> ip_vs_dest_is_overloaded() returns.
> 
> The field comments here still say "used lower threshold" and "used upper
> threshold". But l_threshold_val now also encodes the overload state, and
> u_threshold_val holds INT_MAX while the dest is overloaded.
> 
> The comment above __ip_vs_dest_update_overload() in ip_vs_ctl.c also
> still describes setting and clearing the flag that this patch removes:
> 
>  * - conns reach u_threshold and exceed it: set the flag
>  * - conns go below l_threshold (or 75% of u_threshold): clear the flag
> 
> With overload == true, the state is now kept once conns >= l, not when
> conns reach u_threshold.
> 
> The new bool overload argument is not documented, and callers use it in
> two ways. __ip_vs_update_dest() passes the current state, while
> ip_vs_bind_dest() and ip_vs_unbind_dest() pass the direction they want.
> 
> Could the commit message and these comments be updated? The Fixes:
> target is marked for stable, so this patch will likely be backported
> along with it.

	I'll update the comments in the code

> 
> [ ... ]
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index 4c1c739446b7..3003547dcabe 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -1309,32 +1309,32 @@ void ip_vs_stats_free(struct ip_vs_stats *stats)
> >   * - conns reach u_threshold and exceed it: set the flag
> >   * - conns go below l_threshold (or 75% of u_threshold): clear the flag
> >   */
> > -static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
> > +static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
> >  {
> >  	int conns;
> >  	u32 l, u;
> >  
> >  	lockdep_assert_held(&dest->dst_lock);
> >  	u = READ_ONCE(dest->u_threshold);
> > -	if (!u)
> > -		goto unset;
> > -	l = READ_ONCE(dest->l_threshold_val);
> > -	conns = atomic_read(&dest->totalconns);
> > -	if (conns >= (mode > 0 ? l : u)) {
> > -		dest->flags |= IP_VS_DEST_F_OVERLOAD;
> > -		return;
> > +	if (u) {
> > +		/* Low threshold defaults to 75% of upper threshold */
> > +		l = READ_ONCE(dest->l_threshold) ? : (u - (u >> 2));
> > +		conns = atomic_read(&dest->totalconns);
> > +		if (conns >= (overload ? l : u)) {
> > +			WRITE_ONCE(dest->u_threshold_val, INT_MAX);
> > +			WRITE_ONCE(dest->l_threshold_val, l);
> > +			return;
> > +		}
> 
> [Severity: High]
> Can a threshold edit race with the unbind of the last connection here,
> and leave the dest overloaded with zero connections?
> 
> totalconns is read before l_threshold_val is published, and it is not
> read again afterwards. Meanwhile ip_vs_unbind_dest() reads
> l_threshold_val without dst_lock:
> 
> net/netfilter/ipvs/ip_vs_conn.c:ip_vs_unbind_dest() {
>     ...
> 		tc = atomic_fetch_dec(&dest->totalconns);
> 		if (tc <= READ_ONCE(dest->l_threshold_val))
> 			ip_vs_dest_update_overload(dest, false);
>     ...
> }
> 
> Take a dest with one bound connection. The admin lowers u_threshold to 1
> (so l defaults to 1) while that connection expires:
> 
> CPU0 (ip_vs_edit_dest)               CPU1 (ip_vs_conn_expire)
> __ip_vs_update_dest()
>   __ip_vs_dest_update_overload()
>     conns = 1, decides overloaded
>                                      ip_vs_unbind_dest()
>                                        tc = 1, totalconns is now 0
>                                        reads l_threshold_val == 0
>                                        tc <= 0 is false, skips update
>     WRITE_ONCE(dest->u_threshold_val, INT_MAX);
>     WRITE_ONCE(dest->l_threshold_val, l);
> 
> After this, ip_vs_dest_is_overloaded() is true while totalconns is 0.
> Every scheduler skips the dest, so no new binds happen, and with no
> connections left there are no unbinds to clear the state. The bind gate
> is also closed, since u_threshold_val == INT_MAX.
> 
> Repeating the edit with the same thresholds does not help.
> __ip_vs_update_dest() only calls __ip_vs_dest_update_overload() when
> u_threshold or l_threshold actually change. The dest stays out of
> service until the thresholds change again, or until a template or sync
> conn happens to bind and unbind on it.
> 
> The old code in __ip_vs_update_dest() wrote l_threshold_val before
> totalconns was sampled. The same interleaving then made the unbind take
> the lock. This patch moves the gate write after the read.
> 
> This looks like the case the commit message describes as lockless
> readers that "may use old threshold values and as result to skip the
> required flag change". Transitions started from ip_vs_bind_dest() seem
> safe, because the connection being bound will unbind later. The admin
> path has no such guarantee.
> 
> Would it work to publish l_threshold_val and u_threshold_val first, then
> smp_mb(), then re-read totalconns and revert if it is below l? That
> would pair with the fully ordered atomic_fetch_dec() in
> ip_vs_unbind_dest().

	Yes, I'll post new fix for this problem

> 
> [ ... ]
> 
> > @@ -1406,15 +1406,13 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
> >  
> >  	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
> >  	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
> > +		bool overload;
> > +
> >  		spin_lock_bh(&dest->dst_lock);
> >  		WRITE_ONCE(dest->u_threshold, udest->u_threshold);
> >  		WRITE_ONCE(dest->l_threshold, udest->l_threshold);
> > -		/* Low threshold defaults to 75% of upper threshold */
> > -		WRITE_ONCE(dest->l_threshold_val,
> > -			   udest->l_threshold ? :
> > -			   (udest->u_threshold -
> > -			    (udest->u_threshold >> 2)));
> > -		__ip_vs_dest_update_overload(dest, 0);
> > +		overload = ip_vs_dest_is_overloaded(dest);
> > +		__ip_vs_dest_update_overload(dest, overload);
> >  		spin_unlock_bh(&dest->dst_lock);
> >  	}
> 
> [Severity: Low]
> Is u_threshold_val ever set to INT_MAX for a new dest that has no
> thresholds?
> 
> ip_vs_new_dest() allocates the dest with kzalloc_obj(), and this block
> is the only place that sets u_threshold_val. If ipvsadm -a is run
> without -x/-y, udest->u_threshold and udest->l_threshold are both 0. The
> condition above is then false, and list_add_rcu() publishes the dest
> with u_threshold_val still 0.
> 
> So the fast-path check in ip_vs_bind_dest():
> 
> 		if (tc >= READ_ONCE(dest->u_threshold_val))
> 			ip_vs_dest_update_overload(dest, true);
> 
> is true for the first connections. Each of them takes dst_lock until
> one writes u_threshold_val = INT_MAX. The overload state stays correct
> because l_threshold_val stays 0. Before this patch, the
> tc == u_threshold check never fired when u_threshold was 0.
> 
> Could ip_vs_new_dest() set u_threshold_val to INT_MAX? Or could the
> update always run when add is set?

	We moved the cost of calling the update from config to
the packet processing, for now we prefer this way.

> 
> [ ... ]
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> > index 55af77a56929..e1111c3b2721 100644
> > --- a/net/netfilter/ipvs/ip_vs_lblc.c
> > +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> > @@ -418,7 +418,7 @@ __ip_vs_lblc_schedule(struct ip_vs_service *svc)
> >  	 * new connection.
> >  	 */
> >  	list_for_each_entry_rcu(dest, &svc->destinations, n_list) {
> > -		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
> > +		if (ip_vs_dest_is_overloaded(dest))
> >  			continue;
> >  		if (atomic_read(&dest->weight) > 0) {
> >  			least = dest;
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but should the cache hit path
> in ip_vs_lblc_schedule() also check ip_vs_dest_is_overloaded()?
> 
> Only the fallback __ip_vs_lblc_schedule() checks the threshold-based
> state. On a cache hit, the cached dest is returned based on the local
> is_overloaded() heuristic, which only compares activeconns with weight:
> 
> net/netfilter/ipvs/ip_vs_lblc.c:ip_vs_lblc_schedule() {
>     ...
> 		dest = en->dest;
> 		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
> 		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
> 			goto out;
>     ...
> }
> 
> So a dest that has reached its u_threshold keeps getting new connections
> for cached destination addresses, as long as activeconns <= weight.
> 
> The LBLCR cache path goes through ip_vs_dest_set_min(), which does check
> the overload state. The same LBLC cache hit condition is in the base
> tree.

	May be such ip_vs_dest_is_overloaded() check is good to add.
Even if LBLC has its way to check for overload, it still should honor the
global overload limits. Adding to TODO.

> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
> 

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-190150251-1792642345=:9148--

