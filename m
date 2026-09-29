Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB5D17993;
	Tue, 29 Sep 2026 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790655455; cv=none; b=kW/zNTcEJKEZadiKf5G+HcfpyHX/G5qwV9AFmNfV5V1qpz85wGRCWeIGN7hF2FVidI2Lw3Ggc8C/IdZ40tjqacvazwCE17pUch8o2G8jTvVHLAPxp9E2RwwQcD3znmwdLhomAZFDYS4sKJDVsrVPE5sSajzs1vjQotuffY5qpgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790655455; c=relaxed/simple;
	bh=EYhDhqY+Ljn+TNnK4RzNonTKlaTtfBJc+jnLzWZt528=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=FGhnIZ9llhvZHZxEOvacqMNNkn86UEfYQnVesW6evi62gDCujY9M4MjxgCHQZLQ1nPJMlH0gC9QIKgnyrSDoEsE64YJbs8NytyD5Z8955X4EcDoXJocxYBn5vogXjT4eWMMeOEZQoU8Ww292WrOxqhjO92Kp1FIJCaO81d7cDnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=QMf01yVa; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="QMf01yVa"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 772BB20F96;
	Tue, 29 Sep 2026 07:17:27 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=T6Zpt5Quh0T3VAwLwirkUS/8PJbDl3g0NQgbJk8ucok=; b=QMf01yVayCUz
	YtjBqGAzTALwIwMC4/NR3CvrVbSI8RuSxucyCDP6WhUo5UQM0ywK55azkfp2Ebjl
	z71X+42ehtj/cO/ivQLEMFSjmJ4YXgZIcsdc+CdHN/TznKZ22Oi7Wylh/mBKBYx+
	rurEWn8cvkE2RxHFONZ0ofWynO306IIm64LkpnrBJba3vM715+/I5ZXya+IgpbxK
	0vVVhekP0Tt6kc3cp7A6c0IG9c+oL0HpqKMf7SmaAcr1Ypzz8KhjfS5IgmUlyroH
	BXtvyndcZAbSsh7QgxR3mC5FFB7xnIiXbut4tpmJOvWg53LALuDIXwU+xuMi+coi
	joJ5yj1QBvUu9H9dRfTAmYoLcVW21mMhWvl5je1UCy//LouOs6hSckygL3thhy6j
	XjvsN3btVZp+G1sFChIGiAlAQwjBv21/hKwFAFWnpT+aFpz5pgxGO13bx1zx9G1l
	6H0yH8savZBC6xbHwrOGpNBQbde/Kf8ffr1BjTFdAm8QNTPTDueAzPgiBDhlPm47
	u2VX7o7MyEeOQDgVBenW36uWCyDbho11GxzcTAkWVSkwmHfqSJQZSwkrLGnuEVHN
	DfXyGLUdfsu/uU17j8/gqdVbt0wy9cKQ1BoQTvJBQAR1GMBuk7GpyPoK4MBSFUDX
	PVXRs290etmAxZcZwR7bBBHq1KnghQ4=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 29 Sep 2026 07:17:27 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id C9336608F5;
	Tue, 29 Sep 2026 07:17:29 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68T4HR0Z008888;
	Tue, 29 Sep 2026 07:17:27 +0300
Date: Tue, 29 Sep 2026 07:17:27 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: netdev-bot+sashiko@kernel.org
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 07/11] ipvs: filter some flags received in the backup
 server
In-Reply-To: <179063970245.3145.10108068112601989477@kernel.org>
Message-ID: <85e556a9-08f5-41c7-c513-794e39ffdff2@ssi.bg>
References: <20260927220816.268206-8-pablo@netfilter.org> <179063970245.3145.10108068112601989477@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1543624073-1790655448=:5433"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1543624073-1790655448=:5433
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Mon, 28 Sep 2026, netdev-bot+sashiko@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0 (1)

	This patch is fine, see below. It is another patch
by another author that adds the missing checks.

> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch does not stop forged sync messages from creating
>   templates that normal-connection lookups can hit.
> 
> Pre-existing issues:
> - [Low] This problem wasn't introduced by this patch, but
>   ip_vs_sync_validate_flags() still accepts NO_CPORT on non-template…
> 
> --
> 
> ipvs: filter some flags received in the backup server
> 
> This commit adds ip_vs_sync_validate_flags() so the backup drops sync
> entries that have both NO_CPORT and TEMPLATE set, or that have ONE_PACKET
> set. It also applies IP_VS_CONN_F_BACKUP_MASK to v0 message flags, to
> match the existing v1 handling.
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> > index dfa8487ec0c20..1a30817fbbafe 100644
> > --- a/net/netfilter/ipvs/ip_vs_sync.c
> > +++ b/net/netfilter/ipvs/ip_vs_sync.c
> > @@ -954,6 +954,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
> >  	ip_vs_conn_put(cp);
> >  }
> >  
> > +/* Check for incompatible flags */
> > +static bool ip_vs_sync_validate_flags(u32 flags)
> > +{
> > +	/* We do not expect NO_CPORT, especially to allow lookups
> > +	 * to hit templates
> > +	 */
> > +	if (flags & IP_VS_CONN_F_NO_CPORT) {
> > +		if (flags & IP_VS_CONN_F_TEMPLATE)
> > +			return false;
> > +	}
> 
> [Severity: High]
> Does this fully stop sync messages from creating templates that
> normal-connection lookups can hit?
> 
> Take a v0 or v1 entry with TEMPLATE set, NO_CPORT clear and a non-zero
> cport. It passes this check and survives IP_VS_CONN_F_BACKUP_MASK. Then
> ip_vs_proc_conn()->ip_vs_conn_new() creates it with the cport from the
> message: ip_vs_conn_fill_param_sync() for v1, s->cport for v0.
> 
> With no PE data, the template is hashed on the same (proto, caddr, cport,
> vaddr, vport) key a normal connection uses. __ip_vs_conn_in_get() does
> not check IP_VS_CONN_F_TEMPLATE:
> 
> net/netfilter/ipvs/ip_vs_conn.c:__ip_vs_conn_in_get() {
>     ...
> 				if (p->cport == cp->cport &&
> 				    p->vport == cp->vport && cp->af == p->af &&
> 				    ...
> 				    (!p->cport ^
> 				     (!(cp->flags & IP_VS_CONN_F_NO_CPORT))) &&
> 				    p->protocol == cp->protocol) {
>     ...
> }
> 
> When p->cport == cp->cport != 0 and NO_CPORT is clear, the XOR term is 1,
> so the lookup returns the template.
> 
> A later non-template sync for that tuple then gets the template back from
> ip_vs_conn_in_get() in ip_vs_proc_conn(). It either expires the template,
> or it toggles dest->activeconns on the template's dest and overwrites
> cp->flags, state, timeout and seq:
> 
> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
>     ...
> 		if ((cp->flags ^ flags) & IP_VS_CONN_F_INACTIVE &&
> 		    !(flags & IP_VS_CONN_F_TEMPLATE) && dest) {
> 			if (flags & IP_VS_CONN_F_INACTIVE)
> 				atomic_dec(&dest->activeconns);
> 			else
> 				atomic_inc(&dest->activeconns);
> 		}
>     ...
> }
> 
> For templates, ip_vs_unbind_dest() only decrements persistconns, so the
> activeconns change is never undone. After failover, real client packets
> for that tuple would also be handled by the template in the ip_vs_in()
> path.
> 
> The master always builds templates with cport 0. Both
> ip_vs_conn_fill_param_persist() callers in ip_vs_core.c pass a literal 0.
> 
> Should the backup also reject TEMPLATE entries with a non-zero cport when
> there is no PE data?

	Above is solved with a pending patch
"ipvs: validate cport in received sync records".

> 
> [Severity: Low]
> This is a pre-existing issue, not one introduced by this patch. NO_CPORT
> without TEMPLATE is still accepted here, and nothing checks that the
> synced cport is 0. Is that intended?
> 
> Other code assumes NO_CPORT means cport == 0. ip_vs_ftp creates NO_CPORT
> connections with cport 0, and ip_vs_conn_fill_cport() uses !cp->cport to
> mean the cport has not been filled in yet:
> 
> 	if (cp->flags & IP_VS_CONN_F_NO_CPORT && (!cp->cport || by_me)) {
> 
> ip_vs_conn_new() creates a NO_CPORT entry with cport X != 0 and
> increments ipvs->no_cport_conns[af]. ip_vs_conn_in_get() can never find
> that entry. The exact lookup fails the XOR term in __ip_vs_conn_in_get(),
> and the cport_zero_p retry fails the cport comparison.
> 
> So each refresh in ip_vs_proc_conn() would create another duplicate entry,
> and each one lasts until its timeout. no_cport_conns also stays non-zero,
> which forces the second lookup on every in-direction miss. The entry can
> still be matched in the reply direction, because ip_vs_conn_out_get()
> does not check NO_CPORT.
> 
> Would it make sense to also require cport == 0 when NO_CPORT is accepted
> on a non-template entry?

	Above is solved with a pending patch
"ipvs: validate cport in received sync records".

> 
> > +	if (flags & IP_VS_CONN_F_ONE_PACKET)
> > +		return false;
> > +	return true;
> > +}
> > +
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
> 

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1543624073-1790655448=:5433--

