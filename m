Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CE33F4DC3
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 09:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786960598; cv=pass; b=QLRVufcMuQbDyDDp0iz4Ypb+0C+wewHzJHAOKnuvbEWQAtmJWg6/gH4GMzXQDFuXPwV6PXZ05uF1gZdw1e31KCkPsoutTzc5C5PJj45HAMhGNSbzhB4CqE5fc0jNt8Vc74JU/B9VcCIB9ALh713G7U4T9OQ1FJxNWmBmZtqLIVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786960598; c=relaxed/simple;
	bh=KuXUBvhfhE3y5DgpU3Vl/1kCrN+YZ4Q6LLbAfUSCbvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j3lQW9Mt3n4Sk6XoxRs0mS76LStwtnN5uJIwv8QF6akbz1hNwUxis7L1aSOnjnmtjGYDNZqkEC2Q7kLYz1XFYf63B/UQHnJLlX1SCkvdpJdu2EsltMo20fJjcsNfDF6tHO83HOJG4RfZpTyq64XeyhjpktRliIZGAxVLR7s+emE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSlQ4NdX; arc=pass smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSlQ4NdX"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-97622cc1f40so1737958241.3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 02:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786960591; cv=none;
        d=google.com; s=arc-20260327;
        b=kqdzTiaLSlbd+qfORgmjH16G6Hwi2Iap4nhhJdB7xK+cNcsssQn5BiCwxrYn1DpMWz
         wuzYblCCbZlr3XwQZeL4Bi0AKreREpP/3KWn1cZUIA7YqCC2wDGqoqNty9lct+OnuBpc
         VoUkAe+aPn12PdPhOU6Xz/TBRHM+Q8zXnfYPZyE2TWfcCCZSG+ESEw6wEARcgpIDgRRX
         1Ljj3ArJGGDeb+klKWxoUt3tvIqhwZVVihroqSxTLvbgoraDUqt91J0acMTb4K/2/50S
         KenT2vqf8DtF/Qx41SPtGZRknbabhzTOuvCgQDqU+YoyB4fTH74BGlP4NgHPuL0PM7yF
         vA0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GtXlTVxHUTBpC+BdrK0r4Vvmqh2DwG0t1CehSg6ooxE=;
        fh=1ktU3/Th7SmvqZSpU18w67JIquaK18wLFpbOnDoiKX4=;
        b=Ox+gNVGbEIY0o0DuQB1N+ltEBTdHBPciGdmOzjQx/eYwAy8mim7zAr0Si3ymInJkYw
         zp5HuVXWqTg9lHOZITZzmDEETdeat8sw29rEHPYpHMhIG+F0LLnhOFEvxz6zuaL2EGH5
         med8puGMzLIeZIRie25HeDSEarQ80cHV8uFFsNKq0h3dfPy+e0RO8RmUw1kD/vSlr+uN
         +oYggmNvfvcqDV1CtY56Q7jumpWq6BWb+q1nA8VN+MkaSlTKmLqOAT5Cf7pNpdP54Otx
         GqyR0QLLS9e5oHyLaS32sW/CFkGi9clF20gRSioWcC2v3+gBoHAySOcQ+gG0zMKgahbY
         HQgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786960591; x=1787565391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GtXlTVxHUTBpC+BdrK0r4Vvmqh2DwG0t1CehSg6ooxE=;
        b=MSlQ4NdXOL7Ncdvnmw1S8We1FTQw2mGdcXWguqbmYPPQ1wola3bqDTWgWYlJVgmRe1
         taFctKf8wY9hQ9VwSvWeFeN8MYOFRqwTp3UQy7q2ANLYvgSdhFQynQIky+7IeUOmbVsk
         72K/OTbxTnLBxoKpeX4gh+TAWMYd5cb88zWwxp7ckc/4aPywt4gmQ+jDAETvoTWHI+l5
         kIwtsIYyh7/zMxOgrZzQvT7+yjgO/ORvJijC69IU+/pKTJOTU7l8H0Ewhj99N6dGR8Bd
         Scup2D1mTtKEMhd8Ul0Lnyf/RX2aecojAdeY6Pjfi0zAQqNL+ACYLn0vmnOfjrRB73Gk
         UV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786960591; x=1787565391;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtXlTVxHUTBpC+BdrK0r4Vvmqh2DwG0t1CehSg6ooxE=;
        b=RgVMtMLRqRm6K89aecJMJJmoHW5upiAd8jgk1b1YgalG0Bu1jwBa0GtFOHdMkuNeSw
         vMmTXD+kjnnb2Trs0dqJVMU3dKjJSdX7qvZCtKftqwGFTBkzjD1XR1R2mVsA5UAGhaxf
         yp1fNLmimwukaZh/6hVzHo4JVfZpOoxvDoUPObwuIgssGet/Ztyu+YpTHBZ+ZArHCiAz
         8XUqD3PGaFQFnU6zJDqEGXjPxh/NiPKX1R7LPbHTUgf81+/eTfWoKcu9fkswPXmgqAaK
         hj9KJ1Vi1ex/SsJJWy2LwOlwYlFMGRSvHaW37my+sd9vtmZyI+jVig5SEL9VSoI4ECM5
         jKew==
X-Gm-Message-State: AOJu0YzNhPh5joATMSfXfIfn27RrsQ0eEmRS47fnm2AtlexenbO2MhmZ
	LUHWPQXty+ANuPYHIhv0hiWz32LS6fBrgs8Oiee/l+A9e147jSEETp5XUT3dNQk7RmYw6ARiGSZ
	P840QSmOPmV9VHjHZArlH3d+MKK6OHp4=
X-Gm-Gg: AR+sD1352EMV6921uejo7LbuVQW2YZrV1sZMEA/YmAjF2Xu3Xa228x5dnRsmZ6JnXMH
	rvYvXizmGr3uFEZq/yGEZ7c3Ym5OuEwuIV8RqQE6QdIOTcavGbs8ua6irLe6Hyl0EtBEdVx54o9
	8/lLz868VOX+xKCkimSZ4usrAVcaN4Tv8OacPfbB6h995ECL1FyyW8OCmtX1csi62c5qRvSAIcV
	QVqP23c44MBaIgzU8mH0VXRmlKqqvmO4XX3Jv8L1LIIzN0SyqnV4AcW0ijz/Ix42v0c/osJnPoz
	RThxH11MXjcFVdvecNwBEUGDnX2h5f6z7IyVBm0bD+VCfXlzEjPuuZfTY9m9b9LWnd+kMmTumzH
	Q8JvavkSh9X4=
X-Received: by 2002:a05:6122:f05:b0:5bf:8469:c7a0 with SMTP id
 71dfb90a1353d-5c591cbdc96mr6079061e0c.3.1786960590652; Mon, 17 Aug 2026
 02:56:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALkUMdRXAB1nGsBhg77zg2VGZyh-D+rL8kxqDDiEs6qmcXev=g@mail.gmail.com>
 <aoHISuGf2vzWk2s0@strlen.de>
In-Reply-To: <aoHISuGf2vzWk2s0@strlen.de>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Mon, 17 Aug 2026 15:26:19 +0530
X-Gm-Features: AcwNN1V79vkKRL9or9aNvDUQV3ZqO75Y2wbAXI8c2DVSPMgU0hlTm-fXytw4MKk
Message-ID: <CALkUMdRqwCXbA+9tSFgxxA=pBCAPymRbLBa-UXUi6PE1qytvAA@mail.gmail.com>
Subject: Re: netfilter: nf_nat: race in nf_nat_setup_info() corrupts
 nat_bysource list (GPF / soft lockup)
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org, 
	Vimal Agrawal <vimal.agrawal@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

I do see some conntrack updates passed nf_nat_initialized check in
nf_nat_setup_info so ideally it should not do anything for the second
or other run for the same conntrack.
How about locking out the whole of nf_nat_setup_info on ct->lock. i..e
spin_lock_bh(&ct->lock) at the start of the function and unlock before
return.

On Sun, Aug 16, 2026 at 7:55=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Vimal Agrawal <avimalin@gmail.com> wrote:
> > Our custom module can decide to send the first packet of a conntrack
> > to userspace via NFQUEUE while the rest of the packets for that
> > conntrack follow the standard kernel forward path.
> > In the case of a bridge, br_flood() clones skbs, and those clones
> > share one unconfirmed conntrack for the initial packet(s) (via
> > skb_clone()'s __nf_copy(), which just bumps the refcount and copies
> > the same ct pointer).
> >
> > br_flood() clones the skb; Skb1 and Skb2 share one unconfirmed ct:
> >   Skb1 (cpu1): -> nfqueue -> [userspace verdict] -> reinject -> SNAT
> > -> confirm (cpu2)
> >   Skb2 (cpu1): -> SNAT -> confirm (cpu1)
> > Skb1's reinject-triggered SNAT (cpu2) races Skb2's synchronous SNAT
> > (cpu1) on the same, still-unconfirmed ct.
> >
> > Because of this, SNAT for the two skbs sharing the unconfirmed
> > conntrack races across two different CPUs. nf_nat_setup_info() sees on
> > both CPUs that the conntrack isn't yet SNAT-initialized, and both try
> > to initialize it =E2=80=94 pushing the same conntrack node onto the
> > nat_bysource hash chain twice, corrupting the list.
>
> Yes, conntrack assumes exclusive access, this is why nfqueue has all
> these hacks to drop cloned skbs where we don't own the unconfirmed skb,
> e.g. in nfqnl_enqueue_packet().
>
> We could add more hacks but "fixing" nf_nat_setup_info() doesn't really
> help, its only one of many possible races.
>
> If you want to add more hacks, you could move:
>
>         /* It's done. */
>         if (maniptype =3D=3D NF_NAT_MANIP_DST)
>                 ct->status |=3D IPS_DST_NAT_DONE;
>         else
>                 ct->status |=3D IPS_SRC_NAT_DONE;
>
> in nf_nat_setup_info to test_and_Set_bit() done while holding the
> lock to add to unconfirmed list, failure causes drop.
> But it won't solve the underlying design defects.
