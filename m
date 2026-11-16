Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794830787;
	b=0GuBUO93r0NhlkLpl6KtRITWOV8OtupRfPaYRoJcpHRw7CyKQOStXI5StU8fyTx6NK5o
	 zY2vP5sxROMC2xgnobMSVxiM06VNRdPo7h9rZ+s/VTXAeZN1EtrvBBe4buuRzeq11Q428
	 0/+XSZHCmIdRlLo+faCSwwlsyHVhwGqqG9skIag98krfbcv/DNy9P5xeNaE1uvFA30TW0
	 +c3EW5oAdr0GeKw0lZAMNEcEdE7t/+FUMSIqUG0LHPEH5unaCmp7U2SRge+bWu2Z84QbX
	 VWV3jUf15yri6nWG1PDbYXYewSp+F0jMWsraeLG/MLoVpyDN14NslA8uEPuFkzkWQqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rPPFh6fS1YXim6NZpoxuPDCahiP9PcoFMX4GJs+IA80=;
	b=zqE7QbJhbKDzZ6bKx50Gz2f5SLkZa+PYNT5wi6tF0AncFs9Vtmxpsww/w9qURVvHpjSI
	 /V1onvJTlqCa+mbFibx7gDBHYJ0iHwJnW3RYuZTNdlUHvDFMwZIPN5IXS/6AYgPqagPS5
	 BO8Rv/GIlGE8Uni1ZXcoW0mCLdhiicGGmbJTePjd1CniSIwgtwcw0tX4UBe4j+miQSbgZ
	 nyUFgx6Jms+hlc+1XKDkXqATPtGwsqMVzXNR7qyXMvho02AXiI2qrbET4sRKprzmMbAhQ
	 s1DUZp/vC0T4ofespoPtRw2U49+UBl8feavv5W6dOZu8bOV0pl7iteCnyx0LxjBnONg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=xyVb4HaK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5E4606A329
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 12:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF5E4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=xyVb4HaK
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a39e5161c1so3614491b3a.3
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 04:06:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794830786; cv=none;
        d=google.com; s=arc-20260327;
        b=UIBE3XLhqOQZzHiYsh/BlfHSdIh+1yX+LcTN+00drGd1mFvYc3MWGoeIW0ccHaXica
         trKLFbwGpw9teMFoq5isq7gbPy31H/b6vd55B9cT1ohx8WAn1peeFGxm5ishMz0ND9vR
         vdn34ICIp1rI8cD1tIsIV04gx4oJIz1ElGfNEzNRiRAESYmPRG6KhVfMZnKFLs7qChvP
         SeK9ekCoVpDl2oLR6kuilbC7WkcPJani2tponkbVuYs+dB8BKPvXaa8RijXSgVF9+MUu
         R0WQAEa5uJV1DVMJt45rEGaawpm7t8Nr2eybVc8x1get9KsYV1QzNzl2BEeTr7kNK8yn
         +NAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rPPFh6fS1YXim6NZpoxuPDCahiP9PcoFMX4GJs+IA80=;
        fh=/nMyRQscq/ooAiGZVBaxbbdRaGnwoDej9usZGNrpNkY=;
        b=XuxA+HRra+jJlFoipoBVU7EsJN7nCdVViO2TyUUuahfKflZphe1me6GIq85p/Rj00j
         sL43idz8Jr+6f7+3W93eJHNX6458/Nn+TuV/xKdBDO0QMcUUiCnL/BNruR5JKO5P/3IW
         ameytP5WE3UemfO7LzFpaa0yY9tvBfIeN5GS/YFyjAqU2scInLr2Rfmye1DbIElMPNy6
         K5JYSS/3/GxyyvtsMSeBNQR/I9iVTgarZ6g5YW8O7fQKIBcqSl34Cw4OQWf6vQB6EM3f
         io6onflCOb/4RF99Yz6P9VDbfBJsNgbFknueROGpPDXnHyWshe8lKJm/wznFxxDnbqj3
         aCkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794830786; x=1795435586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rPPFh6fS1YXim6NZpoxuPDCahiP9PcoFMX4GJs+IA80=;
        b=xyVb4HaKEPx6w/4dT+pRmRrxl6DGkSJG07mOE0XQmjlK1woMgeJHw26rqFspk5IfuX
         WG8OWFwJ9+WfBnWBY2DgIRIsuM7XGZGCwYCyX51EVmpVkqUgDWrrOBlPw9H8N2mZiAmv
         jabbh/qRKPlCIHibQnelRIPb0QgN8+0lNOpEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794830786; x=1795435586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPPFh6fS1YXim6NZpoxuPDCahiP9PcoFMX4GJs+IA80=;
        b=CF6DAYHGxlTqcJWTFUzS+lzyyFIKt9WHYc55MfTtVX7AehaXEXSLiPcWw2KUk4Sbh/
         HNnSjVkKwOZvppsNxq0KfGOI1QzmzKdCW+zrDffKUanzMoU1wpNyE6RESI6RNXEX9ACn
         UZfrO8Qq/ShmByy/dZ+wubp3CnrB38KD0PtZj5n1mFRuLjSQ3ypvc0IKtSXpXrAnpmuv
         5jq3VSB0fp+KRqE4z/B69eHnL6lsgbEHdmoctnU7ymRJuiprGY04dOw2m5frKCsA7yc3
         kT4KyTw6+edu1K2NGoe8RAci9bjGWSHZDGp6UEB5ELQ4lzlGai+tttM20JMhVUlE8d4c
         VdJQ==
X-Forwarded-Encrypted: i=1; AL+hErE702ge0a8tToNBOgX7kkYhBLtirSFmfWa7H4cBJgUZF2WPxj4+tgxcmwAwNKkShf24eASnVvIqHzgaFPKxuSE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Uophm4wT3qi6Bnl9yI2qCQGfRoJgiQLzdXpfgZzBCd1qj5vAj
	NFnvUTEYrR5OgE77nuoeiUYcwZAYTTj7XoxDVTeMeGg4iVDJgqgnTJkdkjuxMjTklVUNIp5NluG
	heDB3rQOtmJEz1VW0mW06grH/54tgYy/m6cmkOxX0
X-Gm-Gg: AYBFou2E1Yld74yNLh7RMGbMJ4Rqa7HgVOLBFvL8vElpTMhf+CTTkAzOSoKPFhr7Ht1
	p0tTz26H4b7LNGCYfiAfRC+CZod02A0J1/A4yptP1jKkXIcuNYrajyFAFvG5dv+RKXXMiOexRNQ
	cfvQTORl+YaoMhJVCFla4v7T2/7ViLYVoyIZlYW6D9KMJZIJhZvRe9HBgn99LdDapLWiwTO+YxS
	A0NoYjueVT/R4PU5JVTAzl3KiC4hAhe8UnwS0hA6mBwFkD32jHo2Da/7u62PIkqn8fouCd+reCe
	W/6mhhFWznIqn1huh/VCcGVC32QeQCbxTrOsZqn86OmWtemyKzQ0VL3ThPT23cuyaYqEZFlJiQu
	3WrsDsalUbZfIC3QlOw3S1HoK12VfM3ZXZeYiUdxikyMzSkjoKn+gKB2J3f32EkLYD4MoP+IEie
	4I+nL+0MR7CSwtsvI=
X-Received: by 2002:a05:6a00:2d1b:b0:89e:37b0:d1bc with SMTP id
 d2e1a72fcca58-8beb658dfa5mr9915498b3a.28.1794830785927; Mon, 16 Nov 2026
 04:06:25 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CORE-9NOG.v3.r0.20261115050625-4@mojatatu.com> <179482609749.3136.1445693542374471720@kernel.org>
In-Reply-To: <179482609749.3136.1445693542374471720@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 16 Nov 2026 07:06:14 -0500
X-Gm-Features: AclHuK8iJFEUq6Q_26gVf20P94raQrsg_d6PBEON853um224-7FS-5CpbIubgr0
Message-ID: <CAM0EoMmk5kKHNHMw6HOUJoDa-vjM-uFqG6==yUF8V4inpYZ9wQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] bpf: drop the stale dst when redirecting
 to an explicit nexthop
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	jiri@resnulli.us, victor@mojatatu.com, sashiko-bot@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 5:48=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The commit message says the explicit-nexthop branch "never
>   consults the route dst, so nothing that describes the route is lost".
> - [Low] The patch fixes a user-visible bug but has no Fixes: tag, and its
>   commit message does not say which earlier patches it needs.
>

For all of the patches in this patch set:
- i will send a v4 that fixes the commit logs and code comments you
are complaining about. There is no code change coming.
- remember going forward, net-next does not require a Fixes tag.

pw-bot: cr

cheers,
jamal

> --
>
> bpf: drop the stale dst when redirecting to an explicit nexthop
>
> The patch changes __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6()=
.
> When the BPF program supplies the nexthop, they now release the dst the
> packet arrived with, using skb_dst_drop_keep_metadata(). This stops a fra=
me
> parked on the target device's arp_queue from being rebuilt later from the
> original route.
>
> Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mo=
jatatu.com/
> Link: https://lore.kernel.org/netdev/avTfQjFQYR2NNdRg@chamomile/
>
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index bd98d29ed7f8f..ae5346d6abd23 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2318,6 +2318,8 @@ static int __bpf_redirect_neigh_v6(struct sk_buff=
 *skb, struct net_device *dev,
> >               skb_dst_set(skb, dst);
> >       } else if (nh->nh_family !=3D AF_INET6) {
> >               goto out_drop;
> > +     } else if (!skb_dst_drop_keep_metadata(skb)) {
> > +             goto out_drop;
> >       }
>
> [Severity: Low]
> This isn't a runtime bug, but should this patch carry a Fixes: tag?
>
> In both __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6(), the
> if (!nh) { ... skb_dst_drop(); skb_dst_set(); } block with no else branch
> for an explicit nexthop came from:
>
>   ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support supply=
ing nexthop")
>
> So the stale dst has been reachable since that commit. Something like thi=
s
> would get the fix into stable:
>
>   Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support=
 supplying nexthop")
>
> The baseline tree also has no skb_dst_drop_keep_metadata(). It is added
> earlier in this series by "net: dst: keep the LWT metadata of a dropped
> route".
>
> The METADATA_XFRM dst it can install also depends on "net: xfrm: interfac=
e:
> restore dst_orig on every xfrm interface". Without that commit, xfrmi_xmi=
t2()
> hits the skb_dst_set() warning, which panics under panic_on_warn.
>
> Could the commit message name these prerequisites? A backport of this pat=
ch
> alone will not build. A backport with only the helper would bring back th=
e
> xfrmi warning.
>
> >
> >       err =3D bpf_out_neigh_v6(net, skb, dev, nh);
> > @@ -2433,6 +2435,8 @@ static int __bpf_redirect_neigh_v4(struct sk_buff=
 *skb, struct net_device *dev,
> >
> >               skb_dst_drop(skb);
> >               skb_dst_set(skb, &rt->dst);
> > +     } else if (!skb_dst_drop_keep_metadata(skb)) {
> > +             goto out_drop;
> >       }
>
> [Severity: Medium]
> The commit message says:
>
>   That branch never consults the route dst, so nothing that describes the
>   route is lost
>
> That holds for bpf_out_neigh_v4() and bpf_out_neigh_v6(). Does it also ho=
ld
> for the target device's xmit path when the target is an NBMA tunnel (ipip=
,
> gre, sit or ip6tnl with no remote address)?
>
> On those devices the neighbour is NOARP with direct output, so the BPF
> nexthop has no effect. The tunnel picks its outer endpoint from skb_dst()=
:
>
> tc egress prog
>   bpf_redirect_neigh(nbma_ifindex, &nh, ...)
>     __bpf_redirect_neigh_v4()
>       skb_dst_drop_keep_metadata()
>       bpf_out_neigh_v4()
>         neigh_output() -> dev_queue_xmit()
>           ipip_tunnel_xmit() / ipgre_xmit()
>             ip_tunnel_xmit()
>
> If the incoming route has no LWT state, skb_dst_drop_keep_metadata() leav=
es
> the skb with no dst. ip_tunnel_xmit() then always drops the packet:
>
> net/ipv4/ip_tunnel.c:ip_tunnel_xmit() {
>     ...
>         dst =3D tnl_params->daddr;
>         if (dst =3D=3D 0) {
>                 /* NBMA tunnel */
>
>                 if (!skb_dst(skb)) {
>                         DEV_STATS_INC(dev, tx_fifo_errors);
>                         goto tx_error;
>                 }
>     ...
> }
>
> ip6_tnl_xmit() goes to tx_err_link_failure in the same situation, and sit=
's
> ipip6_tunnel_dst_find() returns false. Before this patch these
> configurations transmitted, using rt_nexthop() of the original route.
>
> If the incoming route has LWTUNNEL_ENCAP_IP or LWTUNNEL_ENCAP_IP6, the sk=
b
> gets a METADATA_IP_TUNNEL metadata_dst instead. When that tun_info is not=
 a
> usable IPv4 endpoint (encap ip6, or encap ip with no dst), ip_tunnel_xmit=
()
> falls through to:
>
>                 } else if (payload_protocol =3D=3D htons(ETH_P_IP)) {
>                         rt =3D skb_rtable(skb);
>                         dst =3D rt_nexthop(rt, inner_iph->daddr);
>                 }
>
> and ip6_tnl_xmit() does:
>
>                 } else if (payload_protocol =3D=3D htons(ETH_P_IP)) {
>                         const struct rtable *rt =3D skb_rtable(skb);
>                         ...
>                         if (rt->rt_gw_family =3D=3D AF_INET6)
>                                 memcpy(&fl6->daddr, &rt->rt_gw6, sizeof(f=
l6->daddr));
>                 }
>
> skb_rtable() is a plain cast. Doesn't that mean rt_gw_family and
> rt_gw4/rt_gw6 are read from the metadata_dst's tun_info key bytes?
>
> The reads stay inside the metadata_dst allocation, and rt is not used as
> the output route. The outer endpoint would still come from unrelated byte=
s,
> though.
>
> >From the struct layouts, rt_gw_family appears to overlay the first byte =
of
> key.u.ipv4.src. If so, a 10.x.x.x source address would look like AF_INET6
> to ip6_tnl_xmit() and produce a bogus fl6->daddr.
>
> The tunnel drivers calling skb_rtable() without skb_valid_dst() is not ne=
w.
> bpf_skb_set_tunnel_key() plus bpf_redirect() can already reach it. This
> patch adds another way to get there, though, and turns a configuration th=
at
> used to transmit into one that always drops.
>
> The same applies to __bpf_redirect_neigh_v6() when it hands packets to si=
t
> and ip6tnl NBMA devices.
>
> Is this change in behaviour intended? Could the commit message mention it=
?
>
> >
> >       err =3D bpf_out_neigh_v4(net, skb, dev, nh);
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/CORE-9NOG.v3.r0.20261115050625%40mojatatu.com
