Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2434455293A;
	Wed,  9 Sep 2026 12:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956698; cv=none; b=dclUTLHnvgd8VpY0ESEQAeKGD+Jd9SnirKUtN43xB8iMg5sPRC/WUCo8XuJ/5iK/Z3kFn9FbPdnO7OzSKwHCgvpFgHwAh+Z7rb+FSZTHOBNcfXNsdkO/pDBUDrFf4kF/bkWf6YB59w/Hl/u9PCUiEMfkZRjoAcWdmSPQ4XcPxUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956698; c=relaxed/simple;
	bh=EcZ8W+1kjoACdsS3xmzW1uTqVrdYVj+PsiYu9eJBikk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NM7cEFtBbiUdZtoUMg8zgCM0R6MVaRh8sTwrgy1isKfqClquMy+wv0JzuDfk9giMJ4HgXE2eGVN9ZZjuOylwyvWGi8j+mozqv1Yzrhgvg6ozIm4xhZ9tow5FvfwppGCcf+TKVGqbdTZRBBIUbaar/4K58rdRuCrx8GdfofKi3Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=oaHiQT/+; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="oaHiQT/+"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id B23D922737;
	Wed, 09 Sep 2026 15:24:48 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=wrA+rcJ4H9d7bZk22B3ujZIwuNz+IiagwlXBipbogo0=; b=oaHiQT/+/x6w
	t0XUGQjdLaD15uFNXH/ueIQh/kAAhuxcgyMqg8dYm/dBTdwPiAltY4lcU78lXMOY
	dFwUzF2wpGVC29Rz341TJd/fQBJWhuPCVWJja51CaO7eaJh0dbfyDyei4zY4mxT6
	sT7Tuj4m/KXClLQ7yBFnWCy4NgANs9YdU0flwW8mEq+W4rqiUCnfl0PQeSKFED2h
	Y1hTVuRt60lYEQpMNtussrAWpOd53KXVzQndE9ZDYOWZCR3CFQqsu0FxCp0Ilc7S
	KhRIKoh5O+vDIZY7l3de9aCyoj/52QHRfdNnyjA++6gSOqR+z+6P7i9OpXAy2lhi
	EzTCJkkYpATYvCwdxBtMyHXG77AKooCZ9FGu69L1lmi1LFiSXqTdBU5vt1xIY08A
	AQ20y1VofGzImoAxu3Wq7TypICzwjJ59pqU+W0onjQTew/i5oRRw4Y6bFG+dq3Ug
	o/Ibp3Jhgqt+pUB2riVJKSuvch2puYB5WfHKhelV7ylD6sylqzQrhUEQX9xJANpg
	hbt/Ml+IC0PlN524PIC02WqcWGSoxCEbTMMXMzqTdgA37QDwEJeFZVDfeW5K2xQy
	/WftC8z/Po5atZexP5HH37l6ZQndro7SKMaiV1uPMWsyzDw3vTGD+mlmJMUhiNhQ
	XkeGahDvLsU0bL+tF8FvxOsyEFeSCD8=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Wed, 09 Sep 2026 15:24:48 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 3538361B90;
	Wed,  9 Sep 2026 15:24:50 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 689COm6T049601;
	Wed, 9 Sep 2026 15:24:48 +0300
Date: Wed, 9 Sep 2026 15:24:48 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
In-Reply-To: <0afb3b53-f4b5-7cb8-0f06-7582a50ef83b@ssi.bg>
Message-ID: <2051dadb-fa1a-02bd-42fb-57719e6acb7c@ssi.bg>
References: <20260903004149.1037028-7-pablo@netfilter.org> <20260904020140.3549818-1-kuba@kernel.org> <0afb3b53-f4b5-7cb8-0f06-7582a50ef83b@ssi.bg>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hi Pablo,

On Fri, 4 Sep 2026, Julian Anastasov wrote:

> On Thu, 3 Sep 2026, Jakub Kicinski wrote:
> 
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> > ---
> > ipvs: bound LBLCR and LBLC cache growth
> > 
> > This adds a hard admission limit to ip_vs_lblc_new() and
> > ip_vs_lblcr_new(), rejecting new cache entries once atomic_read(&tbl->entries)
> > reaches max_size * 3 / 2.  The stated intent is to leave headroom so the
> > periodic collector can catch up while the scheduler fallback keeps serving
> > traffic.
> > 
> > > diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> > > index 693bcc82ccb7..8180a7ba9f53 100644
> > > --- a/net/netfilter/ipvs/ip_vs_lblc.c
> > > +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> > > @@ -204,6 +204,9 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
> > >  			return en;
> > >  		ip_vs_lblc_del(en);
> > >  	}
> > > +	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
> > > +		return NULL;
> > > +
> > >  	en = kmalloc_obj(*en, GFP_ATOMIC);
> > >  	if (!en)
> > >  		return NULL;
> > 
> > [Severity: High]
> > Can tbl->entries be trusted as a bound on the number of live entries in
> > ip_vs_lblc_new()?  The replacement path just above the new test is the only
> > ip_vs_lblc_del() call site that does not decrement the counter:
> > 
> > net/netfilter/ipvs/ip_vs_lblc.c:ip_vs_lblc_new() {
> > 	en = ip_vs_lblc_get(af, tbl, daddr);
> > 	if (en) {
> > 		if (en->dest == dest)
> > 			return en;
> > 		ip_vs_lblc_del(en);	/* no atomic_dec(&tbl->entries) */
> 
> 	Yes, we remember this place from the previous Sashiko
> review but the new change depends on the current patch to
> apply gracefully.

	I expected this patch to be applied before posting
a separate fix for the missing atomic_dec(&tbl->entries).
Another option is to post the atomic_dec fix on top of the
current patch or better before it, so that both can be applied together.
If needed, I can repost them together in a new patchset, so that
they can be reviewed together properly.

> > 	hlist_for_each_entry_rcu(en, &tbl->bucket[hash], list)
> > 		if (ip_vs_addr_equal(af, &en->addr, addr))
> > 			return en;
> > 
> > Since the new test caps only the total entry count and not the chain length,
> > can all 24576 permitted entries be steered into a single one of the 1024
> > buckets, leaving the lookup in softirq context (and again under
> > spin_lock_bh(&svc->sched_lock) from ip_vs_lblc_new()) walking a ~24k element
> > list per packet?  The patch does reduce the worst case compared to the
> > unbounded chain before it, so this is a pre-existing exposure rather than
> > something the patch adds, but would seeding the hash or bounding chain length
> > be worth doing on top?
> 
> 	Yes, adding random seed and changing the hash function
> can be useful improvement. Added to TODO.

	As for the hashing change, it can be a -next material.

Regards

--
Julian Anastasov <ja@ssi.bg>

