Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF4F2F1FD2
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167823; cv=none; b=mYToHoDeR8zlmbrsxGXI7TiaqvrSlCU+kcsm55h1tI8WwRWW+Wdq4OAQPduvNEdNo/wzl/FSBFWx47G7cS6Mo/6BBQtVyinR8vP48ooqcM4uJSz6GO7yWoCD5EBpVeJjHFxT8MqHWG8i7n51a4Nao2dp+Q4K6m06FMIMlIUXPnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167823; c=relaxed/simple;
	bh=ZWKf1U4K8p8K7ajfbNKacDFOZXuDZuDDSYcIrkzA/N0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1DAV+K2IfES+KPuQcJ/2YdGGl2I+ALZSzD5k/C2VP8v+jxQdUBya1McSqTGNmSrj467HubE3opPhXoRh0lf8riTdGkOpUrSjx40oZQQbLBt6SuA/A2OB5t84OsUBbhqCIzy1KoVt7NAUUPDq37s9raeoriZGQt890rR5k9nCzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZB0hduKS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCkvRS/R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZB0hduKS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCkvRS/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762167819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zhTdrnjfA8ppQxzFb9fDiTAH4jVhlOQqvIRjACG6oMI=;
	b=ZB0hduKS/dieRehumqJUKctMnxl/5gFS6/wrcm3LDOxO8UZRBmfu2cGpcBXpvHdUCKdVSW
	snfCnojyL1pzDimiG/7C5vyZhXM2N/5lKHbjr71JTiZ1rk2kTDyyGmSFVElO8Icb/frVRb
	0utqaAC+pGocJopVvM4nH5c8jYkyLrY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-wjoRmh1vM0Gd-dxCyzudZQ-1; Mon, 03 Nov 2025 06:03:37 -0500
X-MC-Unique: wjoRmh1vM0Gd-dxCyzudZQ-1
X-Mimecast-MFC-AGG-ID: wjoRmh1vM0Gd-dxCyzudZQ_1762167815
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b5a8827e692so310857566b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2025 03:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762167814; x=1762772614; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhTdrnjfA8ppQxzFb9fDiTAH4jVhlOQqvIRjACG6oMI=;
        b=hCkvRS/Ribp6ASBG1FHRVpshS7QKtRzANGVovMCtgfsDKFgyKH6ynspCdCfnFL0pYZ
         JA6gUnKnDOPD1NYjeOkNXO/+B3RVifOFy5iqe+fY4ZDkmxXtUYh844dbDKJ67EAjmCR1
         zgw3ON9BvrOm0ofo/uW7WDyuM8KUlW8tm/ZhOXrOBdwJRwEqcjpu0o6dSiN5pxMxZeGZ
         LcuI2K0Q93la+pdqIiC5OUxRIWGaVbBCoxXgGb2Fj4XrHKQ9MTVoVYVSq7baXsz/qJ3w
         h4O2Wgvv0XkuKD9T2oSg9HMdOhxxT1+lIoJFkbFKO9i/dm5Eb2rCypx/W4b6wlK9U8mR
         Tzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167814; x=1762772614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhTdrnjfA8ppQxzFb9fDiTAH4jVhlOQqvIRjACG6oMI=;
        b=t6iiseNZS9yN9oEl2n27WkEbU9QLrXTCVnRQM1AmQlXkbABupiXskubNbbotW8ySAZ
         e2iWaWMtOlzSY84gVXAvU7pjIf/xEezyqzmPrJaPAg2L8gnM4krMv+8B2QSmkoktwm+H
         sCMxms6WSj5eDcgk7O4ugrnTgRat/JLLxPArJiN1NCY8FuwjEZaKYvWjbzqihEc+pre6
         h5LwIFWglVIjOXZQYfom65oLXOg/RPTXczTtPcFXD6HTpwAAys80mkWZrNZzMZmwVVfd
         uWyLXCDRsTLi5HFTQNZEs0TOeWc1siusablTdapnf+1lmFv1nZjaYdhTHewSSmFqFyL9
         lU0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW19OksR+Kwj+K8Cf9qIgr+07vJsZs+dq4lOwuZEi+5UXFeyQ38KMhP9K4BWQuFAAYWLW7LEKxKoRDthYfRo7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzQ9fVn2BuLUrqLkJ49/sa4rA7v6VjFA2P6LcwikMskdai43bt
	QLgU+Uxn3lEtyOq6TCHn/ix3eACxAsF4WwsKP97M2ecou8idcz27yWGYcTX24M7rkOR0GWwMcic
	0knnQ8bA7xblt5XQjz/8Icz1tBp3Zrle3VtLcMV6uATvJYhbTYi+iqgCe0ITSrUqfcTQFKYlQ4b
	sugDwsbv2iiJqqo/hpCBUo1evk/5LDb7k5suguusmWldGsqRxsVi+hy0c=
X-Gm-Gg: ASbGncvC4RJVw1GMD3zMkmzMBss/28TZLsVY8yBCAsUnxupIEXfk8rZNw9SgBG2zXdE
	5N1wCA9qFk6V0q92nuKfXJYjXzBucRMs9Wc5bJ5YkVzCpKpKYlno482KwnrinnjQ6fKiOj53gtk
	eOkIE8sPsB0cwufdVtfEiV1k2jHZC7GPa6+nVVT+/JMxXnPEfFVTl/QVg=
X-Received: by 2002:a17:907:1c93:b0:b40:8deb:9cbe with SMTP id a640c23a62f3a-b70700bad7dmr1398096266b.2.1762167814112;
        Mon, 03 Nov 2025 03:03:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF70Lv5L7m6M605bcYwYl5gdYYQmJQe9fOmppY9gxiQqdJv0qTmTVSWhGn8kw4mBFNTlWE3YlDmM/dVhBYh+OE=
X-Received: by 2002:a17:907:1c93:b0:b40:8deb:9cbe with SMTP id
 a640c23a62f3a-b70700bad7dmr1398093866b.2.1762167813668; Mon, 03 Nov 2025
 03:03:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cfafc5247fbfcd2561de16bcff67c1afd5676c9e.1761918165.git.rrobaina@redhat.com>
 <202511012016.TaXzGDDi-lkp@intel.com>
In-Reply-To: <202511012016.TaXzGDDi-lkp@intel.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Mon, 3 Nov 2025 08:03:22 -0300
X-Gm-Features: AWmQ_bnNelXrYhZN2hvHONfShTGA5EvaaCJcqVosrEermFLRrvdG6VLVDrGvFk4
Message-ID: <CAABTaaCf+5mY8gze4Ojy2fttEuuEtjj3Zm1dHScXVfWtKAQbSQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] audit: add audit_log_packet_ip4 and
 audit_log_packet_ip6 helper functions
To: kernel test robot <lkp@intel.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com, 
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I didn't get these warning messages in my local build. I'll fix it and
submit a new version.

On Sat, Nov 1, 2025 at 10:15=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
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
> patch link:    https://lore.kernel.org/r/cfafc5247fbfcd2561de16bcff67c1af=
d5676c9e.1761918165.git.rrobaina%40redhat.com
> patch subject: [PATCH v4 1/2] audit: add audit_log_packet_ip4 and audit_l=
og_packet_ip6 helper functions
> config: m68k-defconfig (https://download.01.org/0day-ci/archive/20251101/=
202511012016.TaXzGDDi-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251101/202511012016.TaXzGDDi-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511012016.TaXzGDDi-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    net/netfilter/nft_log.c: In function 'nft_log_eval_audit':
> >> net/netfilter/nft_log.c:48:31: error: implicit declaration of function=
 'audit_log_packet_ip4'; did you mean 'audit_log_capset'? [-Wimplicit-funct=
ion-declaration]
>       48 |                         fam =3D audit_log_packet_ip4(ab, skb) =
? NFPROTO_IPV4 : -1;
>          |                               ^~~~~~~~~~~~~~~~~~~~
>          |                               audit_log_capset
> >> net/netfilter/nft_log.c:51:31: error: implicit declaration of function=
 'audit_log_packet_ip6'; did you mean 'audit_log_capset'? [-Wimplicit-funct=
ion-declaration]
>       51 |                         fam =3D audit_log_packet_ip6(ab, skb) =
? NFPROTO_IPV6 : -1;
>          |                               ^~~~~~~~~~~~~~~~~~~~
>          |                               audit_log_capset
>
>
> vim +48 net/netfilter/nft_log.c
>
>     28
>     29  static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
>     30  {
>     31          struct sk_buff *skb =3D pkt->skb;
>     32          struct audit_buffer *ab;
>     33          int fam =3D -1;
>     34
>     35          if (!audit_enabled)
>     36                  return;
>     37
>     38          ab =3D audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_=
PKT);
>     39          if (!ab)
>     40                  return;
>     41
>     42          audit_log_format(ab, "mark=3D%#x", skb->mark);
>     43
>     44          switch (nft_pf(pkt)) {
>     45          case NFPROTO_BRIDGE:
>     46                  switch (eth_hdr(skb)->h_proto) {
>     47                  case htons(ETH_P_IP):
>   > 48                          fam =3D audit_log_packet_ip4(ab, skb) ? N=
FPROTO_IPV4 : -1;
>     49                          break;
>     50                  case htons(ETH_P_IPV6):
>   > 51                          fam =3D audit_log_packet_ip6(ab, skb) ? N=
FPROTO_IPV6 : -1;
>     52                          break;
>     53                  }
>     54                  break;
>     55          case NFPROTO_IPV4:
>     56                  fam =3D audit_log_packet_ip4(ab, skb) ? NFPROTO_I=
PV4 : -1;
>     57                  break;
>     58          case NFPROTO_IPV6:
>     59                  fam =3D audit_log_packet_ip6(ab, skb) ? NFPROTO_I=
PV6 : -1;
>     60                  break;
>     61          }
>     62
>     63          if (fam =3D=3D -1)
>     64                  audit_log_format(ab, " saddr=3D? daddr=3D? proto=
=3D-1");
>     65
>     66          audit_log_end(ab);
>     67  }
>     68
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

