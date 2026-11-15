Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794780587;
	b=2xDgjHRR9fppZMIROBYqn7WjqQCLSHbKrSHB8340+JdNcnI6LEVXMqYasVttP/01Uhdw
	 HzoVgyNgZ4Qm3rsDlBoaPtwBoYaMu58tLDa6zCruRRntOsAY5ZvLii4srFlilJrwvn/dH
	 2JccqpFkMUGNe1vPJpfwtH78atirrUHfoH4thFcidIfijN7WAVeYjX/AEmDGZ+ZzziKVH
	 XV4ZWndeYU0uvenyAe3/DH2AkohIEOSs/UkYL3cBgWDje7819PmgOeLwCBR/Ur51lDtZn
	 e+LtUppxxbNgB8xVKeNz1Ynt3guyEqJl95E8wOPEbsTt6D5w4Sxj3KhXV/rw/YXf+5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780587;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ho/wZGc1oAeiTgg3BwYQjWFIdQwxPbuaNNwg/HhMHZA=;
	b=HmUWNKYA9zoTIEORKji610zvczvtO72EgxupAleGJl7X5zFcQZIBz4hrL2Bo9GgkNTS5
	 F53dr3GHJuiIhLCahV8NNULfl5DXurWW1JMQDR4ekfv6QxA2Xtmbz8H9/4EO9kw4NNyEB
	 8FYEJZMURZjwjoO1grla0vENmKZJb0L28ZpBd3OFM/cNkf8L9hGp8rkxLRE+GayuInhZ2
	 51EGc5QvxQWDIfZ1WDhiDzOo2kApV0ebRnpBeFHyRbzNVUQuVKIGslOZnT707KYy6NSDs
	 u+e8umoom/PWi6Ic+Cscx4sTGwyO9V4U3OyozgMJEhqpz08chsfu0Lc1HkaUowDzZXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=e0GCsMMO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6700E606A31F
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 22:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6700E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=e0GCsMMO
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b600fae14dso1242092b3a.2
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 14:09:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794780584; cv=none;
        d=google.com; s=arc-20260327;
        b=R6F1bZkMrsIr+2aYcnsQDedZbbUH863J5dJj4XzNnFF7R3Abm76dyBCxMsKoBd4/eE
         KURm4IHc+jD9PxezHums9tLQHYqncaiXfW2PWVynTZG2yC62XW+30M52JHUg7fgIRWOL
         RKhSreIuXMmblc6fMq4EBHaACrZEfKvHptOC+VJcIsfBIkBFYn6/xPZcsrZXQfcBGfKF
         +prgY73tnIgioH4tlUkaDgzoxhOLRa+RQUoIejQNdATcXNbpQ4/t/vw28r+eFNFICJdZ
         fBrlPhsIrd5BHlYBD2NC2txJc9+eRJ6yLa/sisV4SVwFh1UHdzm6W1W67OAweE4paBPq
         cxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ho/wZGc1oAeiTgg3BwYQjWFIdQwxPbuaNNwg/HhMHZA=;
        fh=qs2GyFWIreG8UrGl3El5hZADO/jQuHeHZDCieurMXTc=;
        b=qK2SonbNmFMdm/DTb5ubnKqphOCbXKzdPACcS1F3YhKfFH8tnw57M8zEpryJOOXWFh
         PkxiRqUjA5vuCC1IuPEcqt0IHbC52jJrzlL+9Q9D7FU33vUuylVU3s1qOn6OZzpdR4yz
         ycX/I9wIe2klJPzct/BSVUsglDkvLjaGoFQJj6I42kzJdg2tjUe+VbxwbK/TYk+4QjSE
         FM/48NTEO/+7LSYw+A1H+84KWBxqGDvF0oY4U3JQrAeIb6QYzC24z3mAMYD/3grv4UWd
         VI4v6Am6230bEj5XmCDUD7O83apEQQy79JA6VLalwDAwbDYbEBBjoWxo4Mcz3wxWmg8P
         IBmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794780584; x=1795385384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ho/wZGc1oAeiTgg3BwYQjWFIdQwxPbuaNNwg/HhMHZA=;
        b=e0GCsMMOp1Dao9zeusMhZYvci8yLuyBL4czmaO42yrtXUVn/Y8umMrreu4S4XmqbWx
         H2HaZ9aAu57cwNLZETXntFNeo1neShIjyUys8qo6KJRAmfWdqxKstAqk/MItHnFd2iRt
         Gtvtx6t+aQkmrEe4BOk4r6OvTlzYdPp0RgT7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794780584; x=1795385384;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ho/wZGc1oAeiTgg3BwYQjWFIdQwxPbuaNNwg/HhMHZA=;
        b=fOt3LMaibzDesUZG6JukGWVufMYbpsr89hZLmv+VsJMFCg/MoRnCh9Nq9rB7SKE//K
         ac3FiuFpOCXJcP3lhr1z3diYRS58ohtvCwU4Vj4KAhPDt+K2NykFDq8rnysrIGscDG5E
         LsNCsBlevGtVzom66Qr607KUNKq2zeDaCOYcm0TA4TOl0AEw2VlFzViQAJqP1DfWwXYs
         KQEL0z3CAlyBKwLmEp3jJksaTqZXTKqLUU53OvItpVbI7d89g2AV1bi+tKVF22MVDNEN
         9GPPJJPKFAT5TsLJbRyYz8yE0VFxudHhZrwf7yzjXK1b2zBHpR3Qkaip7Njk05pZWafs
         mgDg==
X-Forwarded-Encrypted: i=1; AL+hErFmNnVKChMI0bsfz6bfJPHnT1rDtKfkP+1pvy8lRtgbYx0G04jutcGkAFAZKjBHaMynL8xslaFJthY9lB+TRgM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/KXkOJynFu5skievsi1OvG5ib+AC8b24g1dYpB1ou57mzGfqwj
	xmOfO4E0kNMp0SMaMl0rAdKjQc+cjYGPqKDIaompl/34FTs8M1YJ98D++T7e5qEHCe9IZqQ06Hb
	fAEXK5fjlYOMa01zZl+6Pb4fe4p/W8ScLSreEzkE2sC4bV8ghU+s=
X-Gm-Gg: AYBFou2dVknCrppbATg7mmX2Zm6m7meqJYQ9D0DQhD8d/Nfqho9vkR2SqSgVeWBryEw
	6KQe+KebQ01DhBtihE4mIQAD+KdT4yxL1APhUgrspr8XAJjVYytPDF1Ntcqri5S9XlICapibPat
	Ui3crSdi/rgVMEnKG3yFPfPuBqhKV8jpnRxq3U5rEjxfupcqJVegKe+4AIKunEtYtQuVCruUQ7d
	tPnbtRIJ4Imm7FQZ8OR2a0NIXUflckcJ1F1Hs5c7tlORZNXe1kVwF8OlvzQyv2jWisIbN1N2x7c
	3wA8JK7Ru4Tgg/eB/VzzCIPb48x6vMt1sMVEXCxGNqIANxMheJfwd+9P42M+wRde4yth8lOHT+W
	BYhA9Tzw7ImeAQi49pDsrqEKsCXuzOR8fmO0Nv5z0wrvPB0ufNA425+luxLgS/zNh02fiDVBKzT
	GreztESgIHbI6fbzKKfVia
X-Received: by 2002:a05:6a00:4f90:b0:886:ead5:6d36 with SMTP id
 d2e1a72fcca58-8beb7442276mr7434876b3a.45.1794780584568; Sun, 15 Nov 2026
 14:09:44 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com> <179475377256.2199510.7063513352863534262@kernel.org>
In-Reply-To: <179475377256.2199510.7063513352863534262@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 15 Nov 2026 17:09:32 -0500
X-Gm-Features: AclHuK96qBlwP4faLIuMLL_7nmfrPum2P-_Cevt3cb_lwGWMT9vftm0n26OY5as
Message-ID: <CAM0EoM=kEnHcDyuZNBNQDdJ67ZEOcYWESWKBDCy0V8Kqzi+ZMA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nft_fwd_netdev: drop the stale
 dst when steering to a device
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
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in ca=
se
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] The commit fixes a real wire-level bug in nft_fwd_neigh_eval()
>   (net/netfilter/nft_fwd_netdev.c) but has no Fixes: tag and no Cc:=E2=80=
=A6
> - [Low] The commit message says the rule supplies both the device and the
>   nexthop "so the route dst is never consulted", which implies dropping=
=E2=80=A6
>

You should be reviewing v3 bud. A bit rude to show up with v1 now...
If you have something meaningful to say on v3 other than these
comments then we can talk.

cheers,
jamal

> --
>
> netfilter: nft_fwd_netdev: drop the stale dst when steering to a device
>
> This patch makes nft_fwd_neigh_eval() drop the skb's dst before it
> switches skb->dev to the configured output device and calls neigh_xmit().
> Without the drop, a packet parked on an incomplete neighbour's arp_queue
> can be re-resolved through the stale dst when the queue drains. It then
> leaves the configured device carrying another device's link-layer
> addresses.
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
> Should this have a Fixes: tag and Cc: stable?
>
> The skb->dev =3D dev; followed by neigh_xmit() in nft_fwd_neigh_eval(),
> with the skb's dst still attached, came in with:
>
> d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via ne=
ighbour layer")
>
> The bug became much easier to hit once nft_fwd_validate() allowed
> NF_NETDEV_EGRESS, because egress skbs always carry the output route's
> dst:
>
> f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
>
> The reproducer in the commit message uses an egress chain. Without a
> Fixes: tag, stable backporters can't tell which trees need this fix.
>
> > diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_net=
dev.c
> > index a48c2f765bbaa..ad4d61d64cdde 100644
> > --- a/net/netfilter/nft_fwd_netdev.c
> > +++ b/net/netfilter/nft_fwd_netdev.c
> > @@ -175,6 +175,7 @@ static void nft_fwd_neigh_eval(const struct nft_exp=
r *expr,
> >               }
> >       }
> >
> > +     skb_dst_drop(skb);
>
> [Severity: Low]
> The commit message says:
>
>     Both lookup inputs the neighbour transmission needs, the device and
>     the nexthop, are supplied by the rule, so the route dst is never
>     consulted.
>
> Is that accurate? The arp_queue drain is not the only place that reads
> the dst. If the target neighbour never resolves, the neighbour's
> error_report hook also reads it:
>
> neigh_xmit()
>   neigh->output()
>     ... resolution fails ...
>     arp_error_report() / ndisc_error_report()
>       dst_link_failure(skb)
>
> include/net/dst.h:dst_link_failure() {
>     ...
>         if (dst && dst->ops && dst->ops->link_failure)
>                 dst->ops->link_failure(skb);
>     ...
> }
>
> Before this patch, an egress skb handled by "fwd ip to <nh> device <dev>"
> whose nexthop never resolved still had its route dst. So
> ipv4_link_failure() or ip6_link_failure() sent ICMP host unreachable or
> ICMPv6 address unreachable back to the sender, and expired or
> invalidated the original route.
>
> Once the dst is dropped, dst_link_failure() returns without doing
> anything. __icmp_send() also needs skb_rtable(skb_in), so the packet is
> now dropped silently. Local senders no longer get EHOSTUNREACH feedback,
> and the route is not expired.
>
> The new behaviour is arguably more correct. The old ICMP and route
> expiry applied to a route and device the packet was no longer using,
> and the new behaviour matches the ingress hook, where skbs normally have
> no dst.
>
> Could the commit message mention this change in user-visible behaviour?
>
> The follow-up patch "bpf: drop the stale dst when redirecting to an
> explicit nexthop" makes the same claim for bpf_redirect_neigh(), so the
> same question may apply there.
>
> >       skb->dev =3D dev;
> >       skb_clear_tstamp(skb);
> >
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/CORE-9NOG.v1.r0.20261111073528%40mojatatu.com
