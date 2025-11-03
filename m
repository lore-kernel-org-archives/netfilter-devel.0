Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC05301704
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167940; cv=none; b=lRWE/AJZqNM/oGF/ZTDVm0sx8HwVVcFf7D4jl/KQ/8cBvzrQbZRtQqeXqDhMCfcqDCx34y2i08z4gQzcKuVR0FdIKHuN8n6buzDBL2XssgS0r7INwXSAMnx0/v3/8k+7W7pM1/lODgDLckSUtODEs2sxT4VVV50KDkpOTFCEOKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167940; c=relaxed/simple;
	bh=gfTwUykB/RnmTajqRSHRxKNiOaTJwE/JIgeSdjNjNDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pivZW8d9/yDZiPiOsoWed2P9bZw9MFMmZjbkVM38d+zTrZazZRyr+4970MRfD1yvibXF4SjceKSrg+S3OshsYv3ZoGhS4z2jg+lrjQYtEN4yLhytvJvUpigCz4a7+7Op4nAZC6KnoFNLKwRZ015d0o3tn+hYVtd+BKpAFCcd4NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMv4kxOF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dom5Qxpm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMv4kxOF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dom5Qxpm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762167937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9xCrDGRchnnGTkwO6YdV7uPKVA0+6GBpSaManbFOJHM=;
	b=FMv4kxOF9OrN58AMVvanVWHzLkeknnlm7z8Sf9M0Ao5UvLcCnOhCG/euzW0x5d/NA3bc6c
	otFy7EFHi0mx8+dBzN1PnCTdBHLiWqmcB3Grbt8qY6JcqHbCQaM7sUJSx3aJWoWQyTCivU
	LCu6jt0vaQ5F8tLZLIyHrvQkXa7obOM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-rfSnFjSIMEmcvTVhjokfuw-1; Mon, 03 Nov 2025 06:05:36 -0500
X-MC-Unique: rfSnFjSIMEmcvTVhjokfuw-1
X-Mimecast-MFC-AGG-ID: rfSnFjSIMEmcvTVhjokfuw_1762167935
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2956cdcdc17so16172955ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2025 03:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762167935; x=1762772735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xCrDGRchnnGTkwO6YdV7uPKVA0+6GBpSaManbFOJHM=;
        b=Dom5Qxpmybg5uWgVL6MHt+QvS3sxwwjVF3JIBiqyw9ISex1xSidbn9WxTEmenRZMjS
         NVs/UOr6JoNxubV6Eq5SwM87faS5c+9VkoiKEGUqLdJsiCrn8SB582eScn+i8YCGXZhE
         hCzhKE/VNA9n2PpLVyS9LJSqTR5HO691O34z7P6f2h0lfuHD+lN6I3/vSyC/ywUbhkAS
         tlKf6FpsQkHfUjsCpBqyxBvEGefNjgXSTMolVHXFC7x1PwBAvqWxdvx19m7xkFh0/y8/
         ZBDzUOfbsIfb6xSc9H26gpzUNaAQM/aPsqQqOYq5Cax9wwhsTIB/CYuUFP2VIvi9dmEw
         fmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167935; x=1762772735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xCrDGRchnnGTkwO6YdV7uPKVA0+6GBpSaManbFOJHM=;
        b=WALbUtePWtXp3kRkVCVa/cqVL91p+lSE+PKxBKY18AMWCrKbPzjMHOkTFS0H1FrZrc
         Qwuou0/lnjPHWYcMFGPlOTQ217+hu60a/oCXG/Fz7JYv54SQa0uRUGwQdL/Xp8X/XVUe
         4QDLR1e0hMBfOUUGDO3NDmq0dG3lHDf2FmBrmOQFX9SNudtbGDccyI2RFUIeFNxJ+vCH
         EZxUwU3bwNmh/Urbl2N4T25rS+2oOOOq2vVEbuXEwijCEYvqxulTAqh2CEyWSIGbtE0R
         IQHu6DDuoff7f6Td8IECBdvV+AJz8TuGJ5AYMhVu203eoTY0gcJoG4lIZFaEdmVUor0e
         CNfw==
X-Forwarded-Encrypted: i=1; AJvYcCW9A8jrzCp6XuDu0iIlCTWyzdpfF+yqS57DMaFoyj3f6ui+KRf5WuMRjxIPpG9cOuIkhWx6c8JIzvz5p3sPl7I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+dqMB90B0X9MzNltOSClFPSZkGoVMLEGAwo8XYdRX5oMQETSb
	zxazENj3jpdxITK81Uh0FitSXZbjYzKxzsnvGl8FtTzT0ME7ryeQUE78YiYFzjPOLaklLn69fhj
	rROe7AHC+YBZRpRYmN/voLsduOl1IubitUsC4lLuJRwgknHkog63h0juFiuAzWjWSSiB2ShoC7T
	PJAiLDxkiu1MdRu3u60+hxGtVYxA+IrWQIidjOAtobSRcK
X-Gm-Gg: ASbGncvDbWO9C1IaapkFhRR9IoE1cowK5ToiKDXH7A48pqvjhYmP04yYwr7EhyfjqgZ
	8vN0Y4n3+mBGwc0Jk2Rw9zmH9GxoY5V9FH2YmCx2CPCsHr8y87hvFHTlWKn5dsmnseIxWFYDyiO
	kGe/TT+PGNSmPUAFH9MfqoURNZFhUEMXQGkWx8Pho020RSBAzBzEW61f8=
X-Received: by 2002:a17:903:11cd:b0:27d:c542:fe25 with SMTP id d9443c01a7336-2951a587e32mr155174795ad.41.1762167934871;
        Mon, 03 Nov 2025 03:05:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGA5xxOqESC5njIUuwo8X7aUkUUbc4ngsKRBvL0f6Uy3SwdFfrZxjJ/xB3v9LkidFvC0hMkhLozQ/mE6e5SuA8=
X-Received: by 2002:a17:903:11cd:b0:27d:c542:fe25 with SMTP id
 d9443c01a7336-2951a587e32mr155174295ad.41.1762167934419; Mon, 03 Nov 2025
 03:05:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6ac2baf0d5ae176cbd3279a4dff9e2c7750c6d45.1761918165.git.rrobaina@redhat.com>
 <202511011146.aPtw8SOn-lkp@intel.com>
In-Reply-To: <202511011146.aPtw8SOn-lkp@intel.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Mon, 3 Nov 2025 08:05:22 -0300
X-Gm-Features: AWmQ_blix0O5YM7w_tT0WXs6Pqjmi5gLv0k1Qz_HlHfym8b0laV-ctbmO_s95gk
Message-ID: <CAABTaaCqzGoWKiRp40wh8JzJCq5OukdH+3HpGYN9OvnORpdjaA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] audit: include source and destination ports to NETFILTER_PKT
To: kernel test robot <lkp@intel.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com, 
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Same thing here. I didn't get these warning messages in my local
build. I'll fix it and submit a new version.

On Sat, Nov 1, 2025 at 1:05=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> Hi Ricardo,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on pcmoore-audit/next]
> [also build test ERROR on netfilter-nf/main nf-next/master linus/master v=
6.18-rc3 next-20251031]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Ricardo-Robaina/au=
dit-add-audit_log_packet_ip4-and-audit_log_packet_ip6-helper-functions/2025=
1031-220605
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git=
 next
> patch link:    https://lore.kernel.org/r/6ac2baf0d5ae176cbd3279a4dff9e2c7=
750c6d45.1761918165.git.rrobaina%40redhat.com
> patch subject: [PATCH v4 2/2] audit: include source and destination ports=
 to NETFILTER_PKT
> config: arc-randconfig-002-20251101 (https://download.01.org/0day-ci/arch=
ive/20251101/202511011146.aPtw8SOn-lkp@intel.com/config)
> compiler: arc-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251101/202511011146.aPtw8SOn-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511011146.aPtw8SOn-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    kernel/audit.c: In function 'audit_log_packet_ip4':
> >> kernel/audit.c:2555:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct tcphdr _tcph;
>       ^~~~~~
> >> kernel/audit.c:2556:3: error: expected expression before 'const'
>       const struct tcphdr *th;
>       ^~~~~
> >> kernel/audit.c:2558:3: error: 'th' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       th =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_t=
cph), &_tcph);
>       ^~
>       ih
>    kernel/audit.c:2558:3: note: each undeclared identifier is reported on=
ly once for each function it appears in
>    kernel/audit.c:2568:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct udphdr _udph;
>       ^~~~~~
>    kernel/audit.c:2569:3: error: expected expression before 'const'
>       const struct udphdr *uh;
>       ^~~~~
> >> kernel/audit.c:2571:3: error: 'uh' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       uh =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_u=
dph), &_udph);
>       ^~
>       ih
>    kernel/audit.c:2580:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct sctphdr _sctph;
>       ^~~~~~
>    kernel/audit.c:2581:3: error: expected expression before 'const'
>       const struct sctphdr *sh;
>       ^~~~~
> >> kernel/audit.c:2583:3: error: 'sh' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       sh =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_s=
ctph), &_sctph);
>       ^~
>       ih
>    kernel/audit.c: In function 'audit_log_packet_ip6':
>    kernel/audit.c:2616:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct tcphdr _tcph;
>       ^~~~~~
>    kernel/audit.c:2617:3: error: expected expression before 'const'
>       const struct tcphdr *th;
>       ^~~~~
>    kernel/audit.c:2619:3: error: 'th' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       th =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_t=
cph), &_tcph);
>       ^~
>       ih
>    kernel/audit.c:2629:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct udphdr _udph;
>       ^~~~~~
>    kernel/audit.c:2630:3: error: expected expression before 'const'
>       const struct udphdr *uh;
>       ^~~~~
>    kernel/audit.c:2632:3: error: 'uh' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       uh =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_u=
dph), &_udph);
>       ^~
>       ih
>    kernel/audit.c:2641:3: error: a label can only be part of a statement =
and a declaration is not a statement
>       struct sctphdr _sctph;
>       ^~~~~~
>    kernel/audit.c:2642:3: error: expected expression before 'const'
>       const struct sctphdr *sh;
>       ^~~~~
>    kernel/audit.c:2644:3: error: 'sh' undeclared (first use in this funct=
ion); did you mean 'ih'?
>       sh =3D skb_header_pointer(skb, skb_transport_offset(skb), sizeof(_s=
ctph), &_sctph);
>       ^~
>       ih
>
>
> vim +2555 kernel/audit.c
>
>   2543
>   2544  bool audit_log_packet_ip4(struct audit_buffer *ab, struct sk_buff=
 *skb)
>   2545  {
>   2546          struct iphdr _iph;
>   2547          const struct iphdr *ih;
>   2548
>   2549          ih =3D skb_header_pointer(skb, skb_network_offset(skb), s=
izeof(_iph), &_iph);
>   2550          if (!ih)
>   2551                  return false;
>   2552
>   2553          switch (ih->protocol) {
>   2554          case IPPROTO_TCP:
> > 2555                  struct tcphdr _tcph;
> > 2556                  const struct tcphdr *th;
>   2557
> > 2558                  th =3D skb_header_pointer(skb, skb_transport_offs=
et(skb), sizeof(_tcph), &_tcph);
>   2559                  if (!th)
>   2560                          return false;
>   2561
>   2562                  audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 =
proto=3D%hhu sport=3D%hu dport=3D%hu",
>   2563                                   &ih->saddr, &ih->daddr, ih->prot=
ocol,
>   2564                                   ntohs(th->source), ntohs(th->des=
t));
>   2565                  break;
>   2566          case IPPROTO_UDP:
>   2567          case IPPROTO_UDPLITE:
>   2568                  struct udphdr _udph;
>   2569                  const struct udphdr *uh;
>   2570
> > 2571                  uh =3D skb_header_pointer(skb, skb_transport_offs=
et(skb), sizeof(_udph), &_udph);
>   2572                  if (!uh)
>   2573                          return false;
>   2574
>   2575                  audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 =
proto=3D%hhu sport=3D%hu dport=3D%hu",
>   2576                                   &ih->saddr, &ih->daddr, ih->prot=
ocol,
>   2577                                   ntohs(uh->source), ntohs(uh->des=
t));
>   2578                  break;
>   2579          case IPPROTO_SCTP:
>   2580                  struct sctphdr _sctph;
>   2581                  const struct sctphdr *sh;
>   2582
> > 2583                  sh =3D skb_header_pointer(skb, skb_transport_offs=
et(skb), sizeof(_sctph), &_sctph);
>   2584                  if (!sh)
>   2585                          return false;
>   2586
>   2587                  audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 =
proto=3D%hhu sport=3D%hu dport=3D%hu",
>   2588                                   &ih->saddr, &ih->daddr, ih->prot=
ocol,
>   2589                                   ntohs(sh->source), ntohs(sh->des=
t));
>   2590                  break;
>   2591          default:
>   2592                  audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 =
proto=3D%hhu",
>   2593                                   &ih->saddr, &ih->daddr, ih->prot=
ocol);
>   2594          }
>   2595
>   2596          return true;
>   2597  }
>   2598  EXPORT_SYMBOL(audit_log_packet_ip4);
>   2599
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

