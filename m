Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D393D47C6
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164705; cv=none; b=f+Kqas4abPPZyzFvIYhEH031c5mzSTQ7TZejnMOpWbnvMP7xtjAFPKI7nIzveZb9RL8218uS/pq1zKpuff5H1XAnrVA+vJumebTJSS9vo4t+73+qCHdcsPINawznYbpXVCnfziI5gol+CjeegzZtqtwwlo2HWUBZ1OcblyxXmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164705; c=relaxed/simple;
	bh=FjHgUnFXlfKG+mUmi7mczB3M2JkjiNySJ2ao2PuB7/Y=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=TDcSbz9/+2XCBqLaRWkcAo5C98VouXkXXYx3OpdvAESSbQUW3/0dodPGD3rb3vJYR93ArA2bzqPmUNdPbvUMCQImut5Eq67PuKwYv7xH6c4pvMK5wOxQ6pfflGwIZB+RokKkwMaq4tW9rYEKENNZ5PqxT64Z1oz/vgSQ14n/TEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WYH0in9l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kr3OUD9C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WYH0in9l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kr3OUD9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773164702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZmsVJnJ6tnDYK1sHh6S9C7IYMU//kP93+xeloxRdsk=;
	b=WYH0in9lU7QwqdnmWMvreJwve1jCdZQw4IW7T+useSlsKaVGZIrv2ovVRzDNfpKesGG7nm
	Gl29kIyqRG9hcN08HNXIJ9qQq37/vcHPpU4kYdLxfkjli/+sdbPij9FkQN5pvyKeZgMgAb
	eFgBiJrKU5xOUXme4T5/gpwR7UjYjT8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-b585GtClN9G6sbY0PvGqbg-1; Tue, 10 Mar 2026 13:45:01 -0400
X-MC-Unique: b585GtClN9G6sbY0PvGqbg-1
X-Mimecast-MFC-AGG-ID: b585GtClN9G6sbY0PvGqbg_1773164699
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-485345e2fdfso15901945e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 10:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773164699; x=1773769499; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZmsVJnJ6tnDYK1sHh6S9C7IYMU//kP93+xeloxRdsk=;
        b=kr3OUD9C9Qv9TYe+D0WVYEYT0YZSzauIRKuIHGyZ4RwR8dllkVw6xrTpn18BQE9pf/
         IMaXB6UateRx98kLG1CQz3C5ZV4Sp6Jf5UVedKsMCNqrJX95qqh71qQaQXGrk4fgefm4
         2VjGMoxOrtSa+o/uVvxpS/APZLssXZVC7qALW6xScax0OqKAJYvywSWUCFOSlQFmERqo
         qFIr0qGGq/HxJXSQCMCaaCPCyMELMD8ZsdulxH+Hkuvdttf5m38N1sMHirQSOqPO5PBN
         MoFpJrCztp2sOGP5GN0bDVwCYWVpD8yEVnG1UmO+1uof7577tQW99nsrV7PppkzXMTNH
         HZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773164699; x=1773769499;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZmsVJnJ6tnDYK1sHh6S9C7IYMU//kP93+xeloxRdsk=;
        b=TSnDpTCZA5dbdnAvWSZqR2aodjUhu6wp/UrdOdhe9WwbFCFj/XwOtDXkEci73Ra5ZD
         VQrs0BmvWteVS3aemaHkRB6MH++5ATEAIoNpsBEyHcjej4M+m10Mi5zXvGiZo/UYW22r
         TuAunamgipM3d1Ih7vM7VYcrIza/rppXkluuuu6ZR4a8Nqm3T7aVx3mD/bey/wG/JSKk
         NhmgAzA0TKDdI8eM0HG1HYSQdW4NLAR6aODlirZRGBog1V5zw8FepcjPR2gzlSpnia5H
         RjKDCoKEfBU6xLoIShGW4y7jXGPMaL+viy77W9Il9iYPaUOwBzym5T3jdat9wLooxoYp
         B8tQ==
X-Gm-Message-State: AOJu0YyfDlrSVBhoDrI4EhVkKb9vgzKgjw+FM+AkAp5sscxMmFee/nZd
	VYqhx/37CsXU2rcGbxW6/DeAlCJZuRGkVDfE1/WdgfUhCdPltXTsBKwh9oTNbS/t85TWWDbCg1L
	xD+NqvgCD+PW2AsnzJDaPk0n+ocweWtYJpp4KyD9asOk3VowHC+4lbyr6uV3+D0LEi13dkg==
X-Gm-Gg: ATEYQzzJZK+TakZE2U7jwDUlIUW5ocBMZObxSMsrPnPVXUb7vO4EliWIzuEfcJW+B8R
	ZC99ciLqMBFFeyACdiD51y54kGrX3/z0TKk3ObVCGHw+8sQmCV+38HodSkeWptcGzSxGz6L55xG
	iK+PNqnOIxJ6hoR2NGEJJaEc3Sz+kq2wWMNw0gLHaoOQL1BgObxkuzvnF8LSmBC7Fxgno+Hwsmy
	cyFsgDbzBaCWBy7y8iyjdhGXBldqoeUMrlgvBOQHBvTkQWi1xlQePj3rlFdpwOMqbgO6XyhIwn2
	hc0OAGhrC9ysIvEOwFAzfrY5GC89JBuChcqifeAALvrDaHy7hj5c8+T838rMcl2QOpLa/kS87Wf
	SRLSqzv7j8QBbWLgo/7pwKX7VY3t01lyiGvVfIPPZOWQdBGf9rg==
X-Received: by 2002:a05:600c:4752:b0:483:7783:537b with SMTP id 5b1f17b1804b1-4852697a593mr276095555e9.24.1773164699260;
        Tue, 10 Mar 2026 10:44:59 -0700 (PDT)
X-Received: by 2002:a05:600c:4752:b0:483:7783:537b with SMTP id 5b1f17b1804b1-4852697a593mr276095055e9.24.1773164698726;
        Tue, 10 Mar 2026 10:44:58 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541aa73easm87440895e9.3.2026.03.10.10.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 10:44:58 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Yiming Qian <yimingqian591@gmail.com>
Subject: Re: [PATCH v2 nf] netfilter: nft_set_pipapo: split gc in unlink and
 reclaim phase
Message-ID: <20260310184455.3ab682f0@elisabeth>
In-Reply-To: <abBXVm9Fh1ZjkKG6@strlen.de>
References: <20260304053611.15197-1-fw@strlen.de>
	<20260310170221.086297b2@elisabeth>
	<abBXVm9Fh1ZjkKG6@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2026 18:44:57 +0100 (CET)

On Tue, 10 Mar 2026 18:39:34 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > Sorry for the late review. Just one (perhaps dumb) question:  
> 
> No problem, thanks for reviewing.
> 
> > >  	struct nft_pipapo *priv = nft_set_priv(set);
> > >  	struct net *net = read_pnet(&set->net);
> > > @@ -1697,6 +1697,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
> > >  	if (!gc)
> > >  		return;
> > >  
> > > +	list_add(&gc->list, &priv->gc_head);  
> > 
> > ...is there a reason why we need to do this unconditionally, or could
> > we do this opportunistically if (__nft_set_elem_expired(&e->ext,
> > tstamp)) below, including the nft_trans_gc_alloc() call?  
> 
> Yes, its to make sure we run the catchall gc, which is external
> to the pipapo core datastructure.

Ah, right, it wouldn't run otherwise, I missed that. Thanks for
explaining.

> I admit we could be more clever and try to supress this
> gc container allocation, but I preferred to keep it simpler for now.

Yeah it sounds very reasonable.

-- 
Stefano

