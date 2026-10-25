Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792946918;
	b=1UflKqaADsZj5EZgtUmQ7Q8sWtrqDY0sJRnXfqO2tnKiez863mvTqVsB9CAa68wozKgd
	 yXXJTu0N8Vhh4WWzzwvkswMeJatTmWGzy3uIBnJZysrP9n4EXWdgo53Gy1DMBNCaL/kc4
	 ArCWUwhN401ZxweMMMf5EH4djHhXwVeAkH5OYKalQgqZ5dsp5LBpyOJJh3arTNlLhafsd
	 BY6Tkr7LQr7aNo/MCMmlFA+tyKh/pKpwGo6e1d5TDjE69RTziQDCdxSgrwIc7NuQWnbCp
	 CdnS0dWsonzP/3Wtq2P0BEdohg27df/yh54ZlT1vUsNFbutnEUOzYrownBYZ/jVjDPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=OQ5OjXs0aIahC9OVKlKWWMFSX1nU2p7OCig10Q5/wzk=;
	b=24pEzLOIScpcBj6WXyFEd0xwRVEd3J8Bd7Gcty6/FbB0cpq520OkyZqCjtchJBw37xVq
	 l4bgyC8X2OTe5XkIByzQ6udPp7/g+6hFZk25UCKcot9dk49jUyPJS5xliOotERrN1jur2
	 weMNUtXjU0e/1SYtMRx8gGw4FgdTf6wXtwUEoKp9wzTM5etMEO9QD+d1TrZ+trE7cY7id
	 F5ARH8w7BM8+Jt/4FDjVRDn+G3i13XblS6mSsD9nR+ZXim+8IN9GmZ5R0KmSCcoioYfJV
	 qItAiACsE8OSl+AYRkx44SzZNIVLYSNIwKtZntKghEf//aEJcbB0oK0StNiEbAy/JTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KYmnvVXK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E65606A31F
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 16:48:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67E65606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KYmnvVXK
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35f036b17easo5967230eec.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2026 09:48:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792946917; cv=none;
        d=google.com; s=arc-20260327;
        b=jCrWHe13PCP7Rg+f9+fx3eMYGuUiMr8MvjgMYYuEnJqPq+LmexNUNYNzkaNLyb2rBa
         kvA2o+0HS+KPWDT7NR1UO4P5WidX0Q2csXYNBWIchyTW8O22d9VlYMFjJVVTyjWbyUIT
         Jp/21edFThwYdIdE3eOuFyyMkgWo1frC2AUbCLnOGXXEvm2W+vzJD9BaXk0l4iWF9QNG
         ZLlHMDkyjlbw9GcKI6um/lwrMVKJ1Vih1TRC8/JfQAbpYokCCXj1C50A52gIEu5xtxxK
         liCue19lFIK8BR/TKGbCwJOFOjwcP+7snws5bkbMYZ5wFTL9y62MD7+t0vW3UiLPmZbt
         X3YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OQ5OjXs0aIahC9OVKlKWWMFSX1nU2p7OCig10Q5/wzk=;
        fh=VU5DO+LMZMBUnpQjDixXQVopXb6nwd7C9HkeVLDQ8zY=;
        b=nFGOqea3ECpysl6nuTj7+xvoejkCQ4HACxDbO6XrQvVUerEddcrb3lcl554HQYb/Lz
         mZ9q4LC42+7/kDrrv8c6RMXR96TUMnRuo/lipWLg98jfrsA2qggzFoaOUc8e+X5kwD+I
         5Qe0hgjCxaxANHsO3TDAfWMwz6bL/r0oKSsjByLmRV/ozKFJMbWX/02bt4KC80/wbf5C
         98VLcTIfVl6kjwOFxxA9xdz2zPu52Us/Hjyu13sGfJ/pCQXRWbVw5cxk1VTh1MKwuxXV
         NezwkzkRJpZC97QXIkvf7JBSRoK75uZ8B4Shv80Rm0NRXyKCPChIUAgWyzk4LguANZvO
         9cGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792946917; x=1793551717; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OQ5OjXs0aIahC9OVKlKWWMFSX1nU2p7OCig10Q5/wzk=;
        b=KYmnvVXKqmgzmzcYvgaBaE2o02vTlgFEhxL1z9bImYcjsrPqSwTb/uT4x98PWQ3Avz
         xmWPMeKQzEN55YHwCXqXnABiZx039OJtIL8+lt6hdomTYYNtNqizDQXSjWavfeHB4LJu
         dNI274UzUkEtefjRtU2EUFZLWxLV8VPxJgT7c+ARjxaBt6KjMYVAPfn8ub2Kd+fi/pKJ
         y1IJO9RgQlIwu/psiG2D1NnGKhd1julDHjPg0GejY/VoWMcUo2X9nER+AnjGuTq5jE34
         pnBaXMrW2nYwKZ09gRlN8+I87/aOlBTdynHQhDr3c3h6CLdyyyerNOEEOldanrfp7vos
         5fUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792946917; x=1793551717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQ5OjXs0aIahC9OVKlKWWMFSX1nU2p7OCig10Q5/wzk=;
        b=fcJBk7Sn5kPgTKGGBhvsHsf9m3/3bWzIOV8MCEB+PNOXOcVS7lX6RFkjlsEK0Jdw2q
         h2qepf2Bu2IZWeS3VPYpgEWThq6fXgi0z9inmkdXY1wwMq6TcXQ1O3gEEYNcD35U7qcn
         KrSGh8JpD84hoSjeaRtoh47oTmQyUce7tatfWG25WAjhyFBBkigi0hSA8wBClVE54ZXq
         CC0Qip7Ys0ZVBYiEJZzvdv9k+EF7QfLEep0psppXusd8oZRiMhfExV+8u9txgzFTsy7W
         peiGR8he1Vbz2X/maU8hnq2GH7Cc5vIE39BETp1ETULI6rO6GxLdy5SBjVK47kP09lgW
         gt+w==
X-Forwarded-Encrypted: i=1; AKwUvBxvecRJc7xL96vEzewsU+nIxFT+vJwrlJqDCgPOfZG9oHfIrGZ3A0RcWmn+wq6GLF1hgkiFmtG9+FErShRfryU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLEuMAvhujBYLVbNnKda7vITR0crCVAjWAWFwQnmggiVcAM2Gzp
	gnil0X5WFdWpQrdhPlNchA+jBURyKmGCI0+z8EZ0b1k3KowahxxTi/K2K76fG8U+A0gav7a7YsI
	M2+/XXLLNXxpL4w4dIb3ZERDIGcjZ+H4=
X-Gm-Gg: AYBFou1pV7txybGRdwHZZpeoOjrB2yaDeKZ0VsmFzpQqxUdVTpPgLMPGUce3pguO35o
	cZqJSR2kIYfV0x/dSD3gDRdctMVTgA4LP+uZ61O1Olq0WPjyjj3d8XODS4VajuBFP6CMPakqY/A
	TDKMzWrorWt+EN/mkujxDV4IFB2MjD2nnmpM95RSov57KiRQm7w1RvsoAhY5OJLihcHjQchpHbD
	1QgOKDDByb0hwy+yKUthBZONy+RvowZAgVWu+i7x7FSXWY/Ne4l6HHde7SOUbua8E4qJ//FbBUO
	YzZnvnyv0TQXKWo6vocTewUOJpplcdczllkOfnKikqvV5cWMxhQNSbOjXxrlIHq7K5Fbfwljipj
	9s6i981wz2C95aHCsnZWkCawYqr6doKIh8fO7LidcAJAmZiW+3wRILx0eoPJ7r5IPM8+SWdNiao
	otyMFWUbvFPAh8kR5p0lLGh8xOUQ==
X-Received: by 2002:a05:693c:87dc:20b0:350:2a5c:56c with SMTP id
 5a478bee46e88-369e84b1873mr7142255eec.20.1792946917425; Sun, 25 Oct 2026
 09:48:37 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179287943591.17355.17353179557993329094@gmail.com>
 <at0vzdlVTF8XAzHj@strlen.de> <179288180870.24716.7833838593165388250@gmail.com>
 <at2V3g-B1Ko2x1iK@strlen.de>
In-Reply-To: <at2V3g-B1Ko2x1iK@strlen.de>
From: Joas Antonio <joasantonio108@gmail.com>
Date: Sun, 25 Oct 2026 13:48:26 -0300
X-Gm-Features: AclHuK8nWBBaduAuSBl0zsyZnm0f5QTkQEz1Yhbnl-LnIzySkyTP_8D8glFnwKY
Message-ID: <CAOCBhwFsbHzRuxngYoG3DDOB_KgBL5c0aHvZEVh58Xkeu=h1oA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: skip transaction elements
 during GC
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Weiming Shi <bestswngs@gmail.com>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

You are right, and I was wrong. Sorry for the noise.

nft_set_elem_init() does stamp the expiration at parse time:

    nf_tables_api.c:6860
    nft_set_ext_timeout(ext)->expiration =3D get_jiffies_64() + expiration;

but I misread where the reference timestamp comes from. It is taken
in nf_tables_valid_genid(), before the first message of the batch is
processed, not in nf_tables_commit(). So expiration is always at least
tstamp + timeout, and the sync gc in pipapo_gc_scan() cannot see a
new element as expired, no matter how long the transaction takes.

The "empty set" I observed is explained by the elements simply timing
out after the commit (10ms timeout), and the dump skipping expired
elements. It was not the gc collecting inactive elements. The
comparison with 86b6471e690c was also wrong.

Please drop the patch. I'm withdrawing it.

Thanks for taking the time to check it.
Joas


Em dom., 25 de out. de 2026 =C3=A0s 02:38, Florian Westphal <fw@strlen.de> =
escreveu:
>
> Joas Antonio dos Santos <joasantonio108@gmail.com> wrote:
> > The catch is that the expiration isn't stamped at activation, it's
> > stamped when the element is allocated. nft_set_elem_init() does:
> >
> >       nft_set_ext_timeout(ext)->expiration =3D get_jiffies_64() + expir=
ation;
> >
> > and that happens back in the parse phase (nft_add_set_elem), while we'r=
e
> > still going through the batch. The element only goes active later, in
> > nf_tables_commit(), which is also where the gc tstamp is taken
> > (nft_net->tstamp =3D get_jiffies_64()).
>
>
> Can you name the line in the source code?
> I am not seeing it :-(
>
> > So the expiration is really parse_time + timeout, and the commit-time g=
c
> > scan checks it against commit_time. If you add a big batch of elements
> > with a short timeout, they get parsed one by one and the commit only
> > happens at the very end, so the ones parsed early in the batch have
> > already gone past their timeout by the time we reach the commit tstamp.
>
> Thats not supposed to cause a gc?
>
> All the sync gc functions are supposed to check against the reference
> timestamp taken at the beginning of the transaction start, in
> nf_tables_valid_genid().
>
> They are NOT supposed to check against wall clock time.
> Even if transaction takes 5 minutes: the sync gc step should
> NOT observe even a single timed out elemenent.
>
> They become stale only AFTER the sync gc step.
>
> tstamp is coming from nft_nat->tstamp, i.e. start of transaction.
> e->ext timestamp therefore should never be in the past compared
> to that reference time.
>
> 1751                 if (__nft_set_elem_expired(&e->ext, tstamp)) {
> 1752                         if (!nft_trans_gc_space(gc)) {
> 1753                                 gc =3D nft_trans_gc_alloc(set, 0, GF=
P_KERNEL);
> 1754                                 if (!gc)
>
> > I confirmed it on an unpatched 7.3-rc6 + KASAN: add 20000 elements with
> > "timeout 10ms" to an interval+timeout pipapo set (the parse alone takes
> > ~6s) and the set ends up basically empty. pipapo_gc_scan() collected th=
e
> > new, not-yet-activated elements during the same commit that added them.
>
> How? I'm not seeing it :-(
>
> > It's the same thing you already fixed for rbtree in 86b6471e690c, the
>
> I thought that was about false zap of rbtree end nodes which doesn't
> apply here :-(
>
> > races the grace period just like the rbtree case, but the precondition
> > (gc picking up the not-yet-active elements) reproduces every time.
>
> How?
>
> > If it'd help, I can respin v2 with the parse-time vs commit-time
> > expiration written out in the commit message, just let me know.
>
> Yes, please explain in detail how time can advance during transaction,
> because its supposedly impossible.



--=20
Joas Antonio dos Santos
Cyber Security Specialist and Ethical Hacker
joasantonio108@gmail.com
LinkedIn
