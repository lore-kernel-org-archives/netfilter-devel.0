Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FC36CE0E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 21:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755723964; cv=none; b=PR734EUH9X30Al1YrVTXV71fxzqb2XPMM4bzcDPVbG6rnwIr52KygceLgFxxY4mt6WhkDI9DegmsU2UWLgxIH2W18ztEE/JCilSuLdymWk6rm9FdFP4zP8AXG9DWzEw2B/eGEcnDC06f5yPUzbsMd42sMpys4lja5fwn8+JCHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755723964; c=relaxed/simple;
	bh=IKJbwqq+ssNGPLwPN3v4e0iOAM+LPgDURBWPrEr0kJs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYm5BXKTKVnuLGa50XjoxX4fKmKRKWj+D1A2K7TBdp6lIatnVGW8uUyv8tG4+Bt89605ohgCOYIm7Kt5Jbzgql7iUFdYygNBPlY3MQVXBJhvReYsNA9rA7vF5xMSgd9bCVfJaU8TUuUriU0YRGvxfo5ddk9QE5XsaiiCmEDw08k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WuKAxwwr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WuKAxwwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755723961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQ2M3ssKjP0d9Xh1Ek+WadutufEi9zJhnd27cRI5G8A=;
	b=WuKAxwwrOSt55twqL3jEXX8Wog7dXWXMhaWz7EaSpBKzyKLqM8atdrkRLgykpryVWhUTg6
	9vU9n08DCdj+gzwJCpGwQ0AictzqJjCw4011cwJY7iVZmPYaDCc4t+Brc1o6YC2OjT1nbv
	2WDiT/dyJswQZ5J/U/RxusqmU4ne3/I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-kN2MxwNMOs2gnfZ8taJMHw-1; Wed, 20 Aug 2025 17:04:48 -0400
X-MC-Unique: kN2MxwNMOs2gnfZ8taJMHw-1
X-Mimecast-MFC-AGG-ID: kN2MxwNMOs2gnfZ8taJMHw_1755723888
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b4d6f3ab0so86465e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 14:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755723887; x=1756328687;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XQ2M3ssKjP0d9Xh1Ek+WadutufEi9zJhnd27cRI5G8A=;
        b=QJXroPzOMxqFCTXM3/dEwKmC7j4uCajIIT3NdhngZP1J5cgkaRy7vlOzeP2EWpxMao
         bP7udMMkOL4AQNlMmQMpT9J1/oT6QnonbviDt+GC0M1qOZGS4ADN7sbj6UStiZxHI2It
         CXij8UGLjJboLUfBUk/itys2pFnFySULs31CTSUB5Thm36kTBI9yuK6KWzTFuanhDFG5
         vzJ43XxGjt4QNDVhGmSHsiO+TIJDWBEzQC0cPlVsuViMcF6yOk8vExWb0z/50H+/dJg6
         WTenOQhaBgy8uxiGOQYD5IVYFRaPRFgt216ICr9Oxu/zmkA4zquYFHhGeY5Bq+sMoRpU
         eRmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX10Gko7N4311lcfO3OP1djzR6TkZqS3rxS2pKLanGR/x+Ix919pX2GDv0wR0KaFRBMG3i0GZU3GwyxxEp25BI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoxGIiNmWNZaNA8Md2Qsfbnu1xmxJOCVCri5GptWj+fcmA0O66
	7rw2Lvp4Rdfl+S6MYE5CyVe13l3aeDQ5qfaNCmP7OC39DfyHFgoeqU/sSedx3L87BCr9kuGGB4M
	wW6/hamAQ/Zr9LJyWYI8NitoYrTvoU37134jQIgo11tKMLfKAf2WcxBY1qrFRU/tFv27lxQ==
X-Gm-Gg: ASbGncto5eBlgBppowlGsDLwy2iYGq9XY8/IPCCmtJafvGubfqUPgIn17E5e2FWvy/n
	+SU7wP/K+INp0T4ZbVhSGKId84roMoNXDOXqrvnbqg5TdBlFoAQJAMUTAMAuxaO/Nnyq7GJ9qG+
	VdFZsE/TFiBVii00ws9MZ66RC4MHEHbE6Y96pcYdDCpeGeqZpvgtZO1vQXVPr07ohmGtf2ZxV13
	FrpcbWJaHdAMopDufSMCs8Cwh3WGv/DhfZpKyPazDrsvKsyHt+uN22VEJoj/rz16h+PAqeh+WkC
	evBlkfpqqagRMwa+dVWzBX3ibGoShhSExMduIqz8nP8h66pjfGA=
X-Received: by 2002:a05:6000:2911:b0:3b7:8b64:3107 with SMTP id ffacd0b85a97d-3c49596de8fmr158910f8f.26.1755723887514;
        Wed, 20 Aug 2025 14:04:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENTGvNEwXbMl+xZ0oyhHsf6vLUKYl8/dRuAw2oc1UIlhxoMdK7YtucqNa4pIrp81fAdXgyKw==
X-Received: by 2002:a05:6000:2911:b0:3b7:8b64:3107 with SMTP id ffacd0b85a97d-3c49596de8fmr158880f8f.26.1755723886994;
        Wed, 20 Aug 2025 14:04:46 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c33203sm47048595e9.9.2025.08.20.14.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 14:04:46 -0700 (PDT)
Date: Wed, 20 Aug 2025 23:04:45 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820230445.05f5029f@elisabeth>
In-Reply-To: <20250820183451.6b4749d6@elisabeth>
References: <20250820144738.24250-1-fw@strlen.de>
	<20250820144738.24250-6-fw@strlen.de>
	<20250820174401.5addbfc1@elisabeth>
	<20250820160114.LI90UJWx@linutronix.de>
	<20250820181536.02e50df6@elisabeth>
	<20250820162925.CWZJJo36@linutronix.de>
	<20250820183451.6b4749d6@elisabeth>
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

On Wed, 20 Aug 2025 18:34:51 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Wed, 20 Aug 2025 18:29:25 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > On 2025-08-20 18:15:36 [+0200], Stefano Brivio wrote:  
> > > > As far as I remember the alignment code expects that the "hole" at the
> > > > begin does not exceed a certain size and the lock there exceeds it.    
> > > 
> > > I think you're right. But again, the alignment itself should be fast,
> > > that's not what I'm concerned about.    
> > 
> > Are we good are do you want me to do the performance check, that you
> > suggested?  
> 
> I think it would be good if you could give that a try (I don't have a
> stable setup to run that at hand right now, sorry). It shouldn't take
> long.

Never mind, I just found a moment to run that for you. Before your
change (net-next a couple of weeks old -- I didn't realise that Florian
introduced a 'nft_concat_range_perf.sh' meanwhile):

---
# ./nft_concat_range_perf.sh 
TEST: performance
  net,port                             28s                              [ OK ]
    baseline (drop from netdev hook):              26079726pps
    baseline hash (non-ranged entries):            18795587pps
    baseline rbtree (match on first field only):    9461059pps
    set with  1000 full, ranged entries:           14358957pps
  port,net                             22s                              [ OK ]
    baseline (drop from netdev hook):              26183255pps
    baseline hash (non-ranged entries):            18738336pps
    baseline rbtree (match on first field only):   12578272pps
    set with   100 full, ranged entries:           15277135pps
  net6,port                            28s                              [ OK ]
    baseline (drop from netdev hook):              25094125pps
    baseline hash (non-ranged entries):            17011489pps
    baseline rbtree (match on first field only):    6964647pps
    set with  1000 full, ranged entries:           11721714pps
  port,proto                          304s                              [ OK ]
    baseline (drop from netdev hook):              26174580pps
    baseline hash (non-ranged entries):            19252254pps
    baseline rbtree (match on first field only):    8516771pps
    set with 30000 full, ranged entries:            6064576pps
  net6,port,mac                        23s                              [ OK ]
    baseline (drop from netdev hook):              24996893pps
    baseline hash (non-ranged entries):            14526917pps
    baseline rbtree (match on first field only):   12596905pps
    set with    10 full, ranged entries:           12089867pps
  net6,port,mac,proto                  35s                              [ OK ]
    baseline (drop from netdev hook):              24874223pps
    baseline hash (non-ranged entries):            14352580pps
    baseline rbtree (match on first field only):    6884754pps
    set with  1000 full, ranged entries:            8787067pps
  net,mac                              29s                              [ OK ]
    baseline (drop from netdev hook):              25956434pps
    baseline hash (non-ranged entries):            17166976pps
    baseline rbtree (match on first field only):    9423341pps
    set with  1000 full, ranged entries:           12150579pps
---

after your change:

---
# ./nft_concat_range_perf.sh 
TEST: performance
  net,port                             27s                              [ OK ]
    baseline (drop from netdev hook):              27212033pps
    baseline hash (non-ranged entries):            19494836pps
    baseline rbtree (match on first field only):    9669798pps
    set with  1000 full, ranged entries:           14931543pps
  port,net                             23s                              [ OK ]
    baseline (drop from netdev hook):              27085267pps
    baseline hash (non-ranged entries):            19642549pps
    baseline rbtree (match on first field only):   12852031pps
    set with   100 full, ranged entries:           15882440pps
  net6,port                            29s                              [ OK ]
    baseline (drop from netdev hook):              26134468pps
    baseline hash (non-ranged entries):            17732410pps
    baseline rbtree (match on first field only):    7044812pps
    set with  1000 full, ranged entries:           11670109pps
  port,proto                          300s                              [ OK ]
    baseline (drop from netdev hook):              27227915pps
    baseline hash (non-ranged entries):            20266609pps
    baseline rbtree (match on first field only):    8662566pps
    set with 30000 full, ranged entries:            6147235pps
  net6,port,mac                        23s                              [ OK ]
    baseline (drop from netdev hook):              26001705pps
    baseline hash (non-ranged entries):            15448524pps
    baseline rbtree (match on first field only):   12867457pps
    set with    10 full, ranged entries:           12140558pps
  net6,port,mac,proto                  34s                              [ OK ]
    baseline (drop from netdev hook):              25485866pps
    baseline hash (non-ranged entries):            14794412pps
    baseline rbtree (match on first field only):    6929897pps
    set with  1000 full, ranged entries:            8754555pps
  net,mac                              28s                              [ OK ]
    baseline (drop from netdev hook):              27095870pps
    baseline hash (non-ranged entries):            17848010pps
    baseline rbtree (match on first field only):    9576292pps
    set with  1000 full, ranged entries:           12568702pps
---

it's a single run and not exactly from the same baseline (you see that
the baseline actually improved), but I'd say it's enough to be
confident that the change doesn't affect matching rate significantly,
so:

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

...thanks for making this simpler!

-- 
Stefano

