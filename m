Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA21F329C49
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028197; cv=none; b=RF3lK8uyNN0UcfWHln2Bm71sEjiUfLlcN0Craicd+2w2N2Fi3n+CBBfws5XPkGybxgkJ9OnS+zc7TCfi5Moa2cay+qEObFL1UES7SkykiegKRQ4b1jT9bCcGU9hsdSF1D2g8zBpYwTuH2o9DrshE2kB1YwxzwVlGXV3R/mZWNhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028197; c=relaxed/simple;
	bh=MDLwY3hGJOdNA7uVlHCfOymMULOe/4nAfCiZBHj7HMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZ4z6zauknldr5FFwcqAdiTK751BZe9DsT3yjMWoQ8SgQ/nmPTixqdjKdjF4ZXby01p4H1kb1AdBQiRoJarOgMzR9/bPZAtMF/PVvWst61rscxEqiovAx9P6Eul+QY7gzFjLwWz/sMuRNLHmfdy/ikgEYN210WsIcg5aRDE93EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qLoC3ncD; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qLoC3ncD"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b2494440f3so13361735ad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 00:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775028195; x=1775632995; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0/p1uDng2sgquUAGmXmR5OASn6msZGNk3CdQw5m8PQ=;
        b=qLoC3ncDvvk5mbQ1jb3pIZf5f2VQSqtZ2nXIE9RG2NaDoCNs6OMlEmtJVnWbXLygTn
         x0py0JALZO7zcEQmlBiliBxFa9tMd7xsKLXnfjmpVi1yh+Ch5SbuJBK4uvPkvbVbt/0n
         YdPs8MbWokTC3mQtejVBrReNrXkUSWcQazC8qChMxaDVQpU42G5ftQoQJFC32vcc1OMw
         XqglEsgfk/A/0gZSMgJylg/lLVJa9ITc4z1bj2TruBdyjJJc78zAfiLc1tC0IEwjqe5w
         M8Xa8dWuAr79hF61rzutk49CsLb+iKpCp032G4CmhTGDWBuV/lwomJASYIQhwWVcy/qk
         DOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775028195; x=1775632995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0/p1uDng2sgquUAGmXmR5OASn6msZGNk3CdQw5m8PQ=;
        b=CDWX75WucRp7sJw2iwlVu2dlrupphznbKLdcl2Lij/yA+c9NBTKmNRToz5K8fmeDv4
         Nx4F7/fcEoN2wGBsqps4kjAWaqiAa0UEW3J5CBPbBtziIMjeVvxy0Bsz04zaTBsNDTs4
         QHAJNnhmaZXBmjTBoywTGFthqpMWyo2mw7A4JRPveLBBbL3YqZU7Kh5e1HWYKb/o98nY
         FNpsuh0SokCClel99yCvStDklH+aQ3fUy6U1p66YoIEwLGANemSjcg8l7c7KE0tN3pvQ
         8zaJYBmX5l4bivu6DQus1PaCaInrIzR9kD0LOaxWb6TYOPs+wW7CZMe24JGmnNClTFHg
         6wlw==
X-Forwarded-Encrypted: i=1; AJvYcCURLxT8NTha896L4a2oyVCFeWjmDBQY8AXLkBO73SAZ9+U3nBnxjpZmoLX+ovfvNdW3cWiwu+RI2hN1+ftazgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGLrp0yPisi9F7zEAc5dXNUt0Auvc7AZdX6gwT4HZZOuY1VbP/
	yfrxpqCJiu3USyyNIzAefXQplN26bbXW/SoL5P49OMu7JWd6WKokRfgw
X-Gm-Gg: ATEYQzztB4Zeq2eqOsrnxJdB8JpZOqetbyY59YgJkxyC3MYeXBFoTibb4OzZnkJH0mX
	GsptoddaD+Q2mt4YoBV5Tqvba9ZKZl9vrfaM4AUxoY+9H+O9fhPIJak1gmz54SWUucTY/tHi6Wl
	NUD0UPgToeRMyT3GwbX4XYhxHI+er8lTYMCNRm88uqn5S2s7n40SjzvrTxqxAlBhRfaorvLYOjC
	fzFEB0aK7MRtokcA4VDI72M34Oy4rqreMfusUIUSYI8g7eAlsn7bEAeMif8jigd14owTUGoTbct
	3aMZDtyxu6XWF37ULe6SY1RVsmHwONefDm3Q7HBAw146ba4E+uknmPjjCii4rgt+zg1cfSyjbUF
	ghAfeK9A5uAQPYt/ZKBAV2w/BtbubitbFyq4AmZ3b5bmRhuUWqt+yNU7KI+Ng8g0nuamDKoljgg
	6rj1VdiOG4ride8mT3XZy0yrLVM9hbVVw+dU9IXcEAL/QVyd3j7I6yi9nN88on
X-Received: by 2002:a17:902:e785:b0:2b0:ac1e:9737 with SMTP id d9443c01a7336-2b269ab02f1mr24259755ad.12.1775028194753;
        Wed, 01 Apr 2026 00:23:14 -0700 (PDT)
Received: from SLSGDTSWING002 ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765c7bsm140048795ad.49.2026.04.01.00.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 00:23:14 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:23:08 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH net] ipvs: fix NULL deref in ip_vs_add_service error path
Message-ID: <aczH3FtMMM4vC5Fq@SLSGDTSWING002>
References: <20260401041611.3302189-2-bestswngs@gmail.com>
 <55c32c6e-8126-8a85-9ddb-1ecebedf2b67@ssi.bg>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c32c6e-8126-8a85-9ddb-1ecebedf2b67@ssi.bg>

On 26-04-01 09:38, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 1 Apr 2026, Weiming Shi wrote:
> 
> > When ip_vs_bind_scheduler() succeeds in ip_vs_add_service(), the local
> > variable sched is set to NULL.  If ip_vs_start_estimator() subsequently
> > fails, the out_err cleanup calls ip_vs_unbind_scheduler(svc, sched)
> > with sched == NULL.  ip_vs_unbind_scheduler() passes the cur_sched NULL
> > check (because svc->scheduler was set by the successful bind) but then
> > dereferences the NULL sched parameter at sched->done_service, causing a
> > kernel panic at offset 0x30 from NULL.
> > 
> >  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN NOPTI
> >  KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
> >  RIP: 0010:ip_vs_unbind_scheduler (net/netfilter/ipvs/ip_vs_sched.c:69)
> >  Call Trace:
> >   <TASK>
> >   ip_vs_add_service.isra.0 (net/netfilter/ipvs/ip_vs_ctl.c:1500)
> >   do_ip_vs_set_ctl (net/netfilter/ipvs/ip_vs_ctl.c:2809)
> >   nf_setsockopt (net/netfilter/nf_sockopt.c:102)
> >   ip_setsockopt (net/ipv4/ip_sockglue.c:1427)
> >   raw_setsockopt (net/ipv4/raw.c:850)
> >   do_sock_setsockopt (net/socket.c:2322)
> >   __sys_setsockopt (net/socket.c:2339)
> >   __x64_sys_setsockopt (net/socket.c:2350)
> >   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
> >   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> >   </TASK>
> > 
> > Fix by recovering the scheduler pointer from svc->scheduler before
> > cleanup when the local sched variable has been cleared.  This also
> > prevents a latent module refcount leak: without the recovery,
> > ip_vs_scheduler_put(sched) receives NULL and skips the module_put(),
> > so the scheduler module could never be unloaded if the kernel survived
> > past the dereference.
> > 
> > Fixes: 05f00505a89a ("ipvs: fix crash if scheduler is changed")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  net/netfilter/ipvs/ip_vs_ctl.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index 35642de2a0fee..e0c978def9749 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -1497,6 +1497,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
> >  	if (ret_hooks >= 0)
> >  		ip_vs_unregister_hooks(ipvs, u->af);
> >  	if (svc != NULL) {
> > +		if (!sched)
> > +			sched = rcu_dereference_protected(svc->scheduler, 1);
> 
> 	Good catch. But may be it should be enough if
> we just remove the sched = NULL after successful
> ip_vs_bind_scheduler(), what do you think? ip_vs_unbind_scheduler()
> already detects if the scheduler is installed.
> 
> >  		ip_vs_unbind_scheduler(svc, sched);
> >  		ip_vs_service_free(svc);
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 

Hi Julian,

Thanks for the review. You're right, removing the sched = NULL is
simpler and sufficient

I'll send a v2 patch.

Best,
Weiming Shi
