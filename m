Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482D1399352
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 06:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782886279; cv=pass; b=kSWlXnkNKmnF4YTTJOd/oucGeKl2OYel5AuKzWfSTRuFvvvKUumVi3esCKMdolo/Bis3s2d/9+cEyjEQZWtAPjFx2sUQH4VUD12lkGyMSpiOUJsq3dyykxgnmVFdMJfqkM48a432Be+/6Ic6c0PpZKgFiGtEy4MeDan+192ViAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782886279; c=relaxed/simple;
	bh=ZxkEpGcaUnz5Szq84cetN2qcBNkJY5vj6Uao31D6ZxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c8UhMm51qXHpMcXAj6Fi9iPDtMDRRYpD1sH1vm9l+QpkAe6syO5vGyrMWtFLZAAsfxYJQQGVq62HDFCumeR98LFgihAqJnhS3fSRAS+mR1OPxC/D/XWU04WPcGvPdCvjqhkQBXmm+KUhI1FHNsNf9l3Xjfnwkr0jsdWRtzZ9sb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHYf5yei; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHYf5yei"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c127ec4447cso33716766b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 23:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782886277; cv=none;
        d=google.com; s=arc-20260327;
        b=iv44sFP0+P5vjkmu7GqHVdtWRUAcaCA7D+fbbS/fkqIrioq/S+f4DwuXq9p+SFVFJn
         bGxmT1IVIICymD0RfBLnyRZxvlMTLQQcczCh54Pg8sHuISTAZWVREPaS/uj0ZaM2R3Sr
         FPa0mE2AHA7lfPaOtBJmzf77heZXkaz/1Nb0oNbDg03EMq1K+D23UkI2BmLvcT9zdKIh
         ZZkjKciHo2YOTBbwyyQ7rmu896Aole1LSzayeEA4oxTxOCwnTr9l+Awtg5uS2fFE0MNJ
         XSzfbLHwJGh42Tx1pa72G4kUG5MrThJ+R1WvV/qtCsld+Fw63JeXzON5JjgMc984LsSJ
         I9aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CWhVhD5eLCMV4lXuEV0ZYaY1wQTvatZLeKGOm+NJE/g=;
        fh=ayY1lzLIidVB+qnNG8eezhuOpRrldLaompjcvbYZ83Y=;
        b=QSGJqvwGv/a9YJOU1eWQ/LyxZpr1UUij4Thncx/oLLTO/rlj1FQTWI3Pla2eAlaDzS
         t7nWc2sEPlPwq52pKZoHVlGCH3yaGqYyBif9u8t2XlnWf2bfDNTBPJeBhGFtZV1hYI+F
         LBk6a5BuwduJFUN0uUTsPz/Q8yfXiAW8zbIQYSfhByQPd3QSchrVr3czE38SgwHBLyhh
         I3RDwKEEYl1HMeB5pGe0yR2hhMrvheNdOXzlEzaRZTVh1ztd8Lj+Zz3a7sZ14bmxekaY
         0fwmh3CtUUQ9zwfeHqLI1arFwluRiCb9HspnBmeRqql1y2GSTeSxB4aWTOSmRN002Zk2
         ySzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782886277; x=1783491077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWhVhD5eLCMV4lXuEV0ZYaY1wQTvatZLeKGOm+NJE/g=;
        b=FHYf5yeinqSQ77fSHMUS0tyfkDoeyRwpL9mpP8b/zxD+iYWrLGu3UURm+sIYNya7yO
         CZajTWjLTrf5adYR60SIR/5nzbpB4kKYz1WSjIidpCEaWEicR1IUBCw0mMNFT8GiOAOt
         wGtGgFmsyA53ziFcMMmRUg4gtXy3cKcCYPl1uLzXT5wE1g3h7N9aZUOPJUPvTSrM0u2b
         swMD77/UiUo5DX3B1RaCV4rs+QoTx6bM3GYLhphuJGIIWyGY/V4FUx8dICj1EdJ0n/z/
         9qksd34pWkShL8zh+HElXE6uk/8CpOj2XSGJghK/tEyNBUbdGCzGVfYeznNgTrAv2ctk
         iqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782886277; x=1783491077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CWhVhD5eLCMV4lXuEV0ZYaY1wQTvatZLeKGOm+NJE/g=;
        b=pM0HvlRSJqhq1mxUOKhRfonxA4oqauabhAic6AO9MiffOg0V8NcvyrxvguHckQXeDP
         GpdgdvkXHFslP36dqySdijTh20LqnlQMfIBAT4i+/maS7TluTvHfH8NRBtoIs4zUtsl4
         HTwWZixfYwsSjT48yVZOOmkknCpxtKum0i9dG8mQ0RgoUWQIJcPSFklf3XjykAEv+0CH
         v8wdXIjgEy92eTe1ARZQb7a+61stULSLDCOWk/68xMidjaXW2XOMWgryTLH/lxsKdCGN
         cYmsRbJ+sQJB+jVUFJ9n4Mil4HlSg3VviE1U8pHKMvm1zA/MSJEAD8eH+zYkUiaWTcNN
         zQ9Q==
X-Gm-Message-State: AOJu0YxH/6UiWDPl7KjOwSH4U0HM8eQqBzxmosRBhUnujcAwBFuVVPao
	XHMkwOIHfa1ktd2FBtPcpIg/nchwyVgv5Pi0VjcFUBcCU7iPxxOra7hp0kv/fd04pnYow5RA1Jp
	5ALAM8K+IcV0g9uYvIWu4Z3OMWbqy4AE=
X-Gm-Gg: AfdE7cluI5qEQWmwxVZY4NUD4YfzRt2Oop7uds4Ny19wM3Vnhvq76dUJBs8W8uJ2mJI
	p0ORwD1eyWitnR7HKC16gP0e5A9O8G1H9rhKUpEo5F6lK1SXs1wf2ItUmtaGjqzvqZYeOTeFql1
	JHWZCbot8jcRc2k/R25UOCObXZsOQurslwa9gliRu9PMFZmU2jl0GNTPz6MRxzSNcSvcOcttYOg
	trK7Q5oph4oCIsTUKK4r7Ml6PpndsNg7Qg35MXyhM0u3VpwMpRo5R+Fp0ACt6H/y/57Kq4EkwqS
	SiEf2gE=
X-Received: by 2002:a17:907:3e18:b0:c12:a330:b92b with SMTP id
 a640c23a62f3a-c12aa14aac6mr6173366b.40.1782886276371; Tue, 30 Jun 2026
 23:11:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630065735.3341614-1-pawlik.dan@gmail.com> <akOCJI-2kAAwOQzz@chamomile>
In-Reply-To: <akOCJI-2kAAwOQzz@chamomile>
From: Daniel Pawlik <pawlik.dan@gmail.com>
Date: Wed, 1 Jul 2026 08:11:05 +0200
X-Gm-Features: AVVi8CfA9uhypD8RuUIaiCQhrLk2tdtBO915kC01GwUewd1n6TYEXO1SRl3IXQQ
Message-ID: <CALC2ApjGZFFPXr4d-r+4VNCpQO1N3Z4NOiBXwYU307jm-626OA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] netfilter: nf_flow_table_path: L2 bridge offload
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	bridge@lists.linux.dev, coreteam@netfilter.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian, Pablo,

I'll leave it up to you - if `br_netfilter` isn't the right approach
in this case, then we can drop that series.

Before your reply, I wasn't familiar with Eric Woudstra's
"bridge-fastpath" series - thanks for the tip.
I'll take a look at it and try to build on those patches.

Thanks, and best regards,
Dan


wt., 30 cze 2026 o 10:45 Pablo Neira Ayuso <pablo@netfilter.org> napisa=C5=
=82(a):
>
> Hi,
>
> On Tue, Jun 30, 2026 at 08:57:30AM +0200, Daniel Pawlik wrote:
> > This series adds L2 bridge offload support to nft_flow_offload, allowin=
g
> > bridged IPv4/IPv6 flows to be accelerated by the flowtable fast path
> > without requiring L3 routing.
> >
> > Background
> > ----------
> > Hardware flow offload engines (e.g. MediaTek PPE) can accelerate bridge=
d
> > traffic but require that nft_flow_offload detect and handle bridged flo=
ws
> > differently from routed ones: no routing table lookup, MAC addresses fr=
om
> > the Ethernet header, and VLAN context pre-populated from the bridge por=
t.
> >
> > v2: Fix missing Returns: tags in kernel-doc comments for the three new
> >     bridge helpers (br_fdb_has_forwarding_entry_rcu,
> >     br_vlan_get_offload_info_rcu, br_vlan_is_enabled_rcu).
> >
> > Patches
> > -------
> > 1/5  net: export __dev_fill_forward_path
> >      Refactors dev_fill_forward_path() to expose __dev_fill_forward_pat=
h()
> >      which accepts a caller-supplied net_device_path_ctx, needed to
> >      pre-populate VLAN state before the forward path walk.
> >
> > 2/5  net: bridge: add flow offload helpers
> >      Adds br_fdb_has_forwarding_entry_rcu(), br_vlan_get_offload_info_r=
cu()
> >      and br_vlan_is_enabled_rcu() to expose bridge state to nft_flow_of=
fload
> >      without requiring inclusion of net/bridge/br_private.h.
> >
> > 3/5  netfilter: nf_flow_table_path: add L2 bridge offload
> >      Core of the series. Adds nft_flow_offload_is_bridging() detection,
> >      nft_flow_route_bridging() which avoids nf_route() (fails for
> >      bridged-only subnets), MAC/VLAN pre-population for bridged flows,
> >      and a dst leak fix. nft_flow_route() becomes a thin dispatcher.
> >
> > 4/5  netfilter: nf_flow_table_path: handle DEV_PATH_MTK_WDMA in path in=
fo
> >      Fixes zero-source-MAC in PPE entries when a bridged flow traverses
> >      MT7996/MT7915 WiFi WDMA hardware.
> >
> > 5/5  netfilter: nf_flow_table_path: add VLAN passthrough support
> >      Records VLAN encap info for passthrough-mode bridge ports so hardw=
are
> >      offload entries include the correct VLAN tag.
> >
> > Rebase note
> > -----------
> > Originally developed against OpenWrt pending-6.18 patches by Ryan Chen
> > <rchen14b@gmail.com> and Bo-Cun Chen <bc-bocun.chen@mediatek.com>.
> > Rebased to current upstream: path discovery infrastructure moved to
> > nf_flow_table_path.c in commit 93d7a7ed0734 ("netfilter: flowtable: mov=
e
> > path discovery infrastructure to its own file"), so all netfilter chang=
es
> > now land in that file rather than nft_flow_offload.c.
> >
> > How to enable bridge offload
> > -----------------------------
> > 1. Load kmod-br-netfilter so that bridged IP traffic traverses the
> >    netfilter forward chain.
> >
> > 2. Enable netfilter hooks on the bridge:
> >      echo 1 > /sys/class/net/<br>/bridge/nf_call_iptables
> >      echo 1 > /sys/class/net/<br>/bridge/nf_call_ip6tables
>
> This requires br_netfilter which is a no go.
>
> Sorry, but we should really target at the native nf_conntrack_bridge
> support.
>
> > 3. Register bridge member interfaces in the nft flowtable:
> >      table inet filter {
> >          flowtable f {
> >              hook ingress priority filter
> >              devices =3D { eth0, wlan0 }
> >          }
> >          chain forward {
> >              type filter hook forward priority filter
> >              meta l4proto { tcp, udp } flow add @f
> >          }
> >      }
>
> Yes, but br_netfilter makes no sense for nftables.
>
> br_netfilter was made to fill gap at the time ebtables was lagging a
> lot behind iptables in terms of features. And getting ebtables on pair
> with iptables in functionality was not feasible either, because it
> required many new extensions that were specific of the bridge family,
> which probably was not a big deal, but it also required to get
> the ebtables command line tool on pair with iptables userspace, which
> has received more development attention/effort that the bridge tool.
>
> All of this does not stand true anymore with nftables, where the
> bridge family capabilities are at pair with the inet families.
>
> I am looking now at the native flowtable bridge support, I will get
> back to you with updates.
