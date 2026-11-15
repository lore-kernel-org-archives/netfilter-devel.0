Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794780632;
	b=uDZtXC76fLb+DyQtulJV2Jx+rGfR6Z9G/FMA/pPxUAt1SWG+SgmvjYrWrARhUwsYo5kP
	 a3ypUqw0qogZMenneay3rOPZolHCg410oyBWmKIMaH3USXHoPqYIaMFq1xrAB3PCj8YCF
	 xv17wVfbRubESABsJ3k15dz1Fu7O1WHdejusAgB0pYR/a4aFm0iyukZXYS6bulZLUM14S
	 TYsGofQx55KsGjekroke/KCZjnTZuyP/KduANAOABwcel9k/Wp1Ich0ClZm8Vv+scwzrG
	 jpjKGjTWbBER9mgyuTvCPW70ZXWcrTpCRL6vtAZ/0mAPPt4RVxJVsYBJtP4rwC7bhzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=k8AnZ18aru1FtW2cyKbe/6niu0aza/YFK7phDBGX51M=;
	b=u1Lhs3TpRNtGy6IxMCbBxFVrjdGCjEtQ1XMQdhStLBy38yQYTvx03JroNElI5P+qEpTw
	 18j+0cDxFeMAzkQ/OyU9igqM04Gp5qrEvKrB7n4EQI/Uo9x+ltj72h/zTyorAsIg0gjkL
	 sjHj1TJVSnvJeE0VIOGx2f5vQpShV3/Rs1N9Rgkin1vcgwBV59rNOXN22Mi5yQSujS396
	 wLk2nQ89cZIRxK2NU+uUFgw3/tl2FoXPcVXCtag0Czt2B0Lo3hN4uepaptZNM1f9wttfO
	 g266z+KRtsSM/QgYAjBtEN9LpR8MwRzB3b0RKpoV2oa98UWhrrNflJ64pYIW/WBXvWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=HSo9Q+0I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15BC606A323
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 22:10:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C15BC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=HSo9Q+0I
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070755c8cso1447164b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 14:10:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794780631; cv=none;
        d=google.com; s=arc-20260327;
        b=MzkuNAfaG/A7rulBkCjK0S5KrkWKLVxhetTvyDHqeYEB4Qq66j91+6snJLJdI9TyqP
         rMAJ4c0Z2+MkcSZqyIS0Lme2ZpynefLnV5flCTUfSiHzSnHqrqpi2pxy6TOpWNL14IS1
         YRgTcB4TwadiCzi1fqaolASSLMPzg6oDwdhZNo+Po2YIsMcMlubl/7a7ocei8py80i36
         LX4CoAWUMQxAYAuuJ5QXx5ohvhhWlCRbT0qAXRtb1gJTgcQpI3g31er9SZrl2XF7qCFB
         Kor1JhH8u82w7uZjNQBKaBCsLDp/020sipU8NQGJlH7pXqli5UTOMTCdrvngIYYS8PJz
         Z+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k8AnZ18aru1FtW2cyKbe/6niu0aza/YFK7phDBGX51M=;
        fh=6/j3lIw0I3Go1K6g29CcwzgObY+5kXGzvMLe4ynZy0o=;
        b=fe53n3rfz/WthBrjMFSbyzou9JM9izPe1Xcu/KZ1o6vpHhYaNnot3dalGqvZN5YeCL
         u53QXsdM7PzTIlXN5i2z7O1IRlE8NQXUaaV6tVqWc47+IRxRRr94uiZImlE6iVDTelma
         fWi9Mx0XK5OXfcwcQLV46qMrFusV3V5rvicmQXynbHhNp4GQzjH2K5mmcBtjhjuGEwBd
         kwcbkiUOSTjTCyQ4//2rKKVAIHhTIVkgfdNvEUVtPp910r2mW3twzq6Zgdn8cvpbmBMY
         yn8ZkQrl2zen7jn2M/NbWulxyR9zhOCiEoWIb3oMqxyvw/eXeE18vBdKcbLLFD6q8iRK
         4iCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794780631; x=1795385431; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k8AnZ18aru1FtW2cyKbe/6niu0aza/YFK7phDBGX51M=;
        b=HSo9Q+0I24bd2mov1qSQp+hL7lvePSwpVIA2XZ+sJqKoQRgPUfQJHVj5kLEvkJyaww
         mPhVpF10QU9+BXYHzNj4zGg0xeGq+nKV7HCyqwz2dgJoq3DTRkz9YNx3nUDdr8mkRBMf
         qMU7UP2KJh2E8aXAq1upy7pY2f3nOsjWJJxGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794780631; x=1795385431;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8AnZ18aru1FtW2cyKbe/6niu0aza/YFK7phDBGX51M=;
        b=LLdatxKA4CZZ/cq1vKk6WyPESB08uaWc2WnHpscjWYFvOqm1pv07QE4rVQa0PBZ/Ir
         0GWoND+iP+bFPRRWXv6VnmatFxQ3JWzr0M5ToebEZNWFkuXpnVL30iAPM+ijavpViAgM
         iwMMnctnUwQIfV8icQmmhOc6qZpbIXL0lXrhvqh63wAy1HNbXRm6I/EGb5X9jOvFagZS
         cXEvALIyZrnjbnS0ArXQGgSW7NS7SE10U0DXZYP08+z7l3yOybCeSWxKSMbcQGBhu5nE
         y0b0mKGd8WLEnZ63j8FfvImFCwj/x5b50X0yloovNHiX+OPRD8YdPsuFGEoI8ZOg8qy6
         FWyg==
X-Forwarded-Encrypted: i=1; AL+hErERHFhD8HkQrzPCqlN4FBhVbZaXX26LYXOKR7u0s1MYvPIBWlmzDytJ67zYmokE+2fgBHXodPjgLNVSQJ1a6w0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/7836E1LND79tTtDXQkhp66laqyUlHjuLBD723OYnkiOIQupyt
	DmVJ9fZathm3ewq2MUD6OTE8Xi/LNuhH4uZJ81qEIENadpI/XXfHQic7zNZKhKgm179V6hjg534
	D79iInADVYZmH2R0CiUV9MveUncwrTgIgavtqr7Kw
X-Gm-Gg: AYBFou2QSNMpd2Zu1vMZBDLJxZpolDh4bIjpskoENq/BYW0V84lygbtt+lw4eTbBezK
	FkTcsUTISMcuPFKdPKMeGeo6ZeC1EUXsjfkRjkat8FY5BjodqC5DkzbQFPCxvBL/laM+66knyT/
	tgcerM2VEPWbQ4xS2YCmLOgUiqRq8Y7Zu1yQYfE1ZcPWPxgRgs9cIR3v6zVPTKRJaSXhfEEVmn1
	189vNSnj9EXmciSqLj7wNQ18ri/17UTGnAZjd4oYxfp4STdIyrd98lrVHCJdHwH/UVVQWKx/xIq
	6BE8pjIAPN5JMnHrRyy2n2W1Mx2Jwf2M26flSAwY60KOA4pk+EaRA9FFNSQZdLSyWoNuoEHECIQ
	UfjM79ezL1hTY8LF15X6TkuHU9eMOeptyh/ICiQ4qnVqNwbEZlAOAIWy81GGahNz2p/8rVglw4T
	9Sxp/K7K1ipI9LiiacJIumYji7h1kVuUYhXwy5JRpm6Q==
X-Received: by 2002:a05:6a21:3989:b0:3fa:3e8f:4b3e with SMTP id
 adf61e73a8af0-3fa3e8f4d04mr2650692637.44.1794780631111; Sun, 15 Nov 2026
 14:10:31 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CORE-9NOG.v1.r0.20261111073528-2@mojatatu.com> <179475377405.2199510.12212399228969931993@kernel.org>
In-Reply-To: <179475377405.2199510.12212399228969931993@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 15 Nov 2026 17:10:20 -0500
X-Gm-Features: AclHuK_z8aEVhc2FxuQy91-PkD3dMAVo6ObqLrhxcdxE1HSSwLwSHIP0MoO-QJE
Message-ID: <CAM0EoMk6faX=as_jjwpna9wpv=LpC=PHEZRWDsjrZzj7Q7pCPQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] bpf: drop the stale dst when redirecting to
 an explicit nexthop
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	victor@mojatatu.com, jiri@resnulli.us, sashiko-bot@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 9:42=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 0 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] The new `else { skb_dst_drop(skb); }` branches in
>   __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6()=E2=80=A6
> - [Low] The commit fixes a user-visible bug but has no Fixes: tag (and no
>   stable Cc).

Review v3, not this one.

cheers,
jamal
> --
>
> bpf: drop the stale dst when redirecting to an explicit nexthop
>
> With BPF_F_NEXTHOP, __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6=
()
> skip the FIB lookup. They leave the packet's original dst attached while
> skb->dev is switched to the target device. If the packet is parked on the
> target's arp_queue, the drain looks the neighbour up again from that stal=
e
> dst and builds the frame with the wrong link-layer header, so the patch
> drops the dst on the explicit-nexthop branch.
>
> Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mo=
jatatu.com/
>
> > Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
> > Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.=
v3.r0.20261103062649-2@mojatatu.com
> > Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@=
mojatatu.com/
> > Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> [Severity: Low]
> Should this patch carry a Fixes: tag? The explicit-nexthop branches in
> __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6() that keep the
> original route dst came from:
>
> Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support s=
upplying nexthop")
>
> The related fix for the non-nexthop branch, commit 23f3770e1a53 ("bpf: Fi=
x
> metadata_dst leak __bpf_redirect_neigh_v{4,6}"), had a Fixes: tag.
> Without one here, stable kernels that contain ba452c9e996d may not get
> this fix.
>
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index aca8160b26a1a..2af24f371648a 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2318,6 +2318,8 @@ static int __bpf_redirect_neigh_v6(struct sk_buff=
 *skb, struct net_device *dev,
> >               skb_dst_set(skb, dst);
> >       } else if (nh->nh_family !=3D AF_INET6) {
> >               goto out_drop;
> > +     } else {
> > +             skb_dst_drop(skb);
> >       }
>
> [Severity: High]
> Can this drop a metadata dst that was attached by
> bpf_skb_set_tunnel_key()?
>
> The new else branch drops any dst on the skb and does not check whether
> it is a route dst. bpf_skb_set_tunnel_key() stores the TX tunnel info in
> a DST_METADATA dst:
>
> net/core/filter.c:bpf_skb_set_tunnel_key() {
>     ...
>         skb_dst_drop(skb);
>         dst_hold((struct dst_entry *) md);
>         skb_dst_set(skb, (struct dst_entry *) md);
>     ...
> }
>
> Take a tc program that calls bpf_skb_set_tunnel_key() and then
> bpf_redirect_neigh() to a collect_md vxlan or geneve device, using an nh
> from bpf_fib_lookup().
>
> Before this patch the metadata dst stayed on the skb. vxlan and geneve
> call netif_keep_dst(), so __dev_queue_xmit() keeps it. vxlan_xmit() then
> finds skb_tunnel_info() with IP_TUNNEL_INFO_TX and encapsulates.
>
> After this patch skb_tunnel_info() returns NULL. In collect_md mode,
> vxlan_xmit() then drops the packet:
>
> drivers/net/vxlan/vxlan_core.c:vxlan_xmit() {
>     ...
>                         if (info && info->mode & IP_TUNNEL_INFO_TX)
>                                 vxlan_xmit_one(skb, dev, cfg, vni, NULL, =
false);
>                         else
>                                 kfree_skb_reason(skb, SKB_DROP_REASON_TUN=
NEL_TXINFO);
>     ...
> }
>
> Geneve behaves the same way.
>
> If the overlay neighbour is not yet resolved, arp_solicit() also reads
> the tunnel metadata for the ARP request from the parked skb's dst:
>
> net/ipv4/arp.c:arp_solicit() {
>     ...
>         if (skb && !(dev->priv_flags & IFF_XMIT_DST_RELEASE))
>                 dst =3D skb_dst(skb);
>     ...
> }
>
> With that dst now NULL, would the solicitation be dropped too, so the
> neighbour never resolves?
>
> The commit message says:
>
>   That branch never consults the route dst, so nothing is lost
>
> That is true for a routing dst. The target device's xmit path does read
> a metadata dst, though.
>
> Metadata dsts use dst_blackhole_ops, and dst_blackhole_neigh_lookup()
> returns NULL. For those dsts, the arp_queue drain already falls back to
> the parking neighbour.
>
> Would skipping the drop when skb_metadata_dst(skb) is set fix the
> reported bug without this regression?
>
> The same question applies to the new else branch in
> __bpf_redirect_neigh_v4().
>
> No selftest covers this case. test_tc_neigh_fib.c only redirects with a
> FIB-derived nexthop and no tunnel key.
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/CORE-9NOG.v1.r0.20261111073528%40mojatatu.com
