Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FEB2798EA
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336344; cv=pass; b=ivNQNdTL8kHpbrewijioIj4LFTXqKjktGas39Zc7tXjyidT+jCpsd2emfrFCtqEKGtqt+z+CGUFCaohaPULCBUmXeyZ7r2+wlcOXlB0NFGyNVzPA3qFdjeT+dIyMq0e7DTijiQvDVjoNfcDwMN/D9PTdnZprnAHcM7V8xKd5mqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336344; c=relaxed/simple;
	bh=0nkUNRQwTzHqoT1DaGX+LpxhmuXqRjKg5bgijFBosyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpeCYEwJzC1753Io/nwAYV1k1zo2mFALL1YNJCQapR4EjEOlItr4zE52CK8ohAzcZ9NB8XmBL0H4k0PQci3BYnHnXg36F4fNSx7CJrIb42wt9pDYk2J/mIQgriwbUbUvVfmPL+aGoB6bvDfnuunu3wgoDtRzBFtaV1LO6ReJJas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=G+A+Kcfh; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="G+A+Kcfh"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39c7ef2b1e2so8955251fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 07:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785336341; cv=none;
        d=google.com; s=arc-20260327;
        b=mJ8yWctBuhi+oVjPesp1u3o/gaTIPpye724ldjhZBUs7K9l7jfte2gu91y6Xhp3dAd
         QGdlcu6l/7FhuacMjB9/yj03zSTTHl4TrVwG9geLTKXs1/0t9/JoIeBMgWS2LV1ZHvgg
         +uMu6JoS+qU1/+/epF2uHuvZABFZbP0QhYYjgI7I7VrMBCGNn8uBmYJLV8yh7fS8jqjY
         pWReb11M0l/JcDklsrBm5xqbpMCck+DUZaUDSg6JuCDH+ZGf4r7ZiGDTb5eD+wcfx8Zu
         aVvsjQqUiPbg64umpnetxdRbc+cF8DdzVBnq5UuGRyUxAZ/MbxH324qaz5NXF0EMRURG
         FpSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DYS0v1t2T66GCdIi41YH7dRJyc21daUpl4n8kvcUuQE=;
        fh=u8dIxQU3SWrNqxCK517bCjyw3/Anh3QemTml9voAR4Q=;
        b=OZWSPqlMUBeaBsnyrkmptck5suDmg8EQl9R2JZxx+CEcopsq9bIzutkBwZE1ER4yx9
         bIXH/qjI9oqzK8hP3HjsBB3rDu2l1HMc7jsQKzb8J+rkujfqzbg3Hvlu47DxG3y39xyU
         uV64SouH6NryGKS8pyiN/n6G/jtyB8yTJqiEflypAEZWuzcJgFQRboaTy7RjLMq4jVA7
         YPy78jViOtm2A8KPwkMw5qr8etoezLx60gn9x/JdOYTRhR/iamxbRwY/9PEzjfHoq7x6
         veRbU5BOYJ5he82Lhb8khBx/RShH/hY1Cn9j8KdPMQeq0G2goETfqrJVxQq5crtxDNvk
         iUSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785336341; x=1785941141; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DYS0v1t2T66GCdIi41YH7dRJyc21daUpl4n8kvcUuQE=;
        b=G+A+Kcfh74oX1Db2sf1gXQqyPbYQ7y2JDdUAO5MwFp4kIdXiuaM8uA0tGZ6HOp9d67
         73cENgZSTx9S7gs8AMXQOkayCflU9Xzof85WtkclCGjAOxO9HfmHQ1J9LJJpfY/TdP5G
         sevohNbU0SpdtjbnS79SrJQoL5jON4VyBXJ+GcxBovBzZ1EovN5u6P35D+VpXPQ2V5NQ
         HzJBo6HDndYK/nTuL8YdyOeYgRLAaOWJKd31zctpoVzI83tQcmGJTe1I8FBiVrT9wSBI
         Xx3/mxuuR2pH/0Xp4YJ3UFQZcBrICbw6aSV7We89hgW+k6QR9pWjDTKfLi5MpDX+VyM1
         4utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785336341; x=1785941141;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DYS0v1t2T66GCdIi41YH7dRJyc21daUpl4n8kvcUuQE=;
        b=gHLS4YBSwT7k+5ZneT/q4RI0OkkXZCi2cf0qbxAzScYX2aBVSW044Rr0ljKVBl/QYJ
         mLLB/s4XcTzF/wIDctaAB5tYo6oaE2Az+wkAytROHVFRm8/Rkui6lpu+zGg/wPq6iXOt
         E+Vrq7awmK73d0415ZWlaxLBx7jDdqQk5i22H9dIqpCMFraOPlBGhG+Nt+ISO1eyPoVt
         VkSsvzWlL+T3gATNYJztK2OL4Ch0tO88IMQN40UwqRIiV3i/E7YZwBrJgupxJ01pH7PG
         ig0AYFF9kPqZEfoUV+C42h7T3eO22Wb4woA6pN4vMWFcz/tj9/z9w5yJDfuuUx3ZvFOW
         eJBw==
X-Forwarded-Encrypted: i=1; AHgh+RpZHJ9gRGbENr+0P3m32h3d6B2+DglWDhFT0uTho08u3LoPRT18bRlgc16paXr0uySksu8eKq3SUFDgQYYOk0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiIJwIt3MLKBwRUlJOaYl/38dtHhCn+oANdBHAavltVyNiNSXh
	ZY+qv669KKeKd5BMo2oCnh77WQOc/NzY+W4/4S55859cnRyD8rBuQAQPpl1oo9h5al4EOh9bhK4
	grJ/XLtR4nSR4a1ATT6h3noScOhm+urIT88lMXVQ7BWU=
X-Gm-Gg: AR+sD11htByG9jvSpoD89VNud/My5tAXtLk2rXX95UCrHPNOGp+bmEChKZchVWyG84n
	Po4rWXLYh2VmpORrXHfFz5fmUqTs2PqkkG4Wfbb+VMRtERO6+vPmie1wWN5+dSv68Sn1ViTKZ1a
	s4NoZldN9FezGt1LDJ5bgSmAnYv+tXwBqoB3cBHolgWnYxwj+aLdcye0CI+Q7veCLqtjAZHlcJY
	hez1er8hL6lXjtc7lxeCPDmYincJAdN3UnwJfBTqRjFPcu8QNktmQWkapW1ufG66BaR3E3ROTYv
	ZcS9x4k5eB3m0w4cdfbkZUxK72BUK+bmVVWKbELVb47e
X-Received: by 2002:a05:6512:3d1a:b0:5ae:a4f9:fa8 with SMTP id
 2adb3069b0e04-5b2d023af2bmr1693957e87.21.1785336341058; Wed, 29 Jul 2026
 07:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785133455.git.zhilinz@nebusec.ai> <amkFqw-2vdtxEogs@chamomile>
 <CANB6i5yBvEWuF36SQ0BH+1msCxhgsmT11zdd6Az7gt4oKQ6P-Q@mail.gmail.com> <ammsH8vWEf8u2tuj@strlen.de>
In-Reply-To: <ammsH8vWEf8u2tuj@strlen.de>
From: zhilin zou <zhilinz@nebusec.ai>
Date: Wed, 29 Jul 2026 22:45:28 +0800
X-Gm-Features: AUfX_mzXxD5tfvrdcFjGKOiL9W76BtE6en8f-2Ut_Hbn5v4RpSnfzsJKC37-lZg
Message-ID: <CANB6i5yDYHazjc8uexnqHKvL=peTz6ZWYoAersCPCuXXFwPQeQ@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] netfilter: h323: fix helper NAT mangling
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Ren Wei <enjou1224z@gmail.com>, 
	netfilter-devel@vger.kernel.org, phil@nwl.cc, davem@davemloft.net, 
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	zhaojignmin@hotmail.com, kaber@trash.net, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 3:30=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> zhilin zou <zhilinz@nebusec.ai> wrote:
> > > > packet's current IPv4 protocol byte. A namespace-local packet modif=
ier
> > > > can rewrite that byte after conntrack has accepted the original lay=
out
> > > > and before helper processing at the confirm hook.
>
> But it can mangle packet in other ways, no?
>
> AFAICS this fix papers over the problem and only "fixes" this particular =
reproducer.
>
> > > commit 54f34607d184c1cc056c59a5b3d86d96dd6a515c
> > > Author: Florian Westphal <fw@strlen.de>
> > > Date:   Tue Jun 9 13:51:53 2026 +0200
> > >
> > >     netfilter: nfnetlink_queue: restrict writes to network header
> > >
> > > commit df07998dfd40796a05fff7ffea2661ad65ed42a7
> > > Author: Florian Westphal <fw@strlen.de>
> > > Date:   Tue Jun 9 13:51:54 2026 +0200
> > >
> > >     netfilter: nftables: restrict linklayer and network header writes
> > >
> > > are you running a kernel with this patches?
>
> Neither fixes are sufficient, afaics, as no tcp revalidation is done.
>
> Ideally we could just remove nfqueue write support, but we can't.
>
> > The issue still reproduces. The crash is:
> >
> > BUG: KASAN: out-of-bounds in mangle_contents+0x13a/0x680
> >
> > and the trace goes through:
> >
> > mangle_contents()
> > __nf_nat_mangle_tcp_packet()
> > set_addr()
> > set_ras_addr()
> > ras_help()
> > nfqnl_recv_verdict()
> >
> > So these commits do not seem to block this NFQUEUE/H.323 NAT mangling p=
ath.
>
> Why do you think your patches block this path?
>
> Can't you make a valid TCP packet, then mangle it so that tcp options
> will get you into end-of-buffer territory?
>
> AFAICS you will need to ask your AI to extend the two commits, for nfqueu=
e,
> add nfqnl_validate_l4(), called from the tail of ip option validation, fo=
r
> ipv6, called from ipv6 exthdr validation, with the last "next" header as
> argument.
>
> - Validate minimal size of base header
> - validate length in case of IPPROTO_TCP (data_len >=3D sizeof(struct tcp=
hdr)
>   and data_len >=3D __tcp_hdrlen())
> - reject unknown headers
> - reject if l4 proto is different from attached
>   nf_conn l4proto (if any).
>
> For nft_payload.c: add nft_th_write_ok(), which
> rejects writes to TCP th->doff.
>
> nft_nh_write() rejects writes to nexthdr value, so "nf_conn l4 proto
> changes underneath" should not be possible via nft_payload.

Hi Florian,

Thanks for the detailed feedback.

I agree that the current H.323-specific change only addresses the
mismatch used by this reproducer, and does not cover the more general
case where NFQUEUE can return a packet whose L4 header is no longer
consistent with the conntrack state or with its own header lengths.

I will rework this for v2 along the lines you suggested: add L4
validation after NFQUEUE packet modification/reinjection, including TCP
minimum header and data-offset checks, reject packets whose L4 protocol
no longer matches an attached nf_conn where applicable, and update
nft_payload.c to reject writes to TCP doff.

Thanks,
Zhiling
