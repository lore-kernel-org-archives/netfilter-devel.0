Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F662F0678
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756890776; cv=none; b=lXsVfpawo/ddBmRBLLf+viaGV2gi1FcSV8vl82Cv8F6O0u6v+rcqauJqNwv8NZCdzFnZ+gC+MzY8G8lzkzscDXbc8mZticzY9w3p0D3uJsxj/pmCgCh/6cdrwbVrPKWjn+UNGQUkLf/ahdOrTdheZceJKl9oqwAMLGBYMcNf8e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756890776; c=relaxed/simple;
	bh=7r8q4nSyRgGfhy8HRHGUCbYa2XZGLpW0wmKGaMJ1OcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wa1j7H8YHqucn4sFnbOZoRaRlFUUYpfkokNYfvkNaNJswDr/RT4f+k/zOuAG9rZdg3tbO42hSiaiMn0Bp25rbTP+O502odycg2bb2DsJTWh1NS0bMwmyuO7AmapHsm+s1uZqqXK+ISI9N9jI9xdRSNyQ2ODaf4rruZXBtwU1xQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BupNb2fp; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BupNb2fp"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3f65fc9b073so6664465ab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Sep 2025 02:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756890774; x=1757495574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdhCdrEY8aH5pPwYV/MwDdeN5ghAmazJw5FZH5uVyQ0=;
        b=BupNb2fp8pe2Z1H0baXz1wrQR9N/poGIuGLeSf8Fc+3Cci9ew+EdT0nAiqKYBmdGQA
         QJ/WlhVX7wWas8C9Xn8+IjVebT3avmSH7yYUOMqZNt7vSEhtDJynGYGVkJ8kHk/oOv3/
         LhcqSNBCBoX8rjGpFCr9IRk3kBdc4XAqoprIkTunyt3E29uywoTgXR9uHdFOB+Snkho1
         Vnsi8+yVLxtXJb0cyLFsKoebn/lBW86K6hxvSUMdTRIMhbrrf1ql+O4DbbVXOQljo+7K
         H3/ASYsTtSXXvv9H5HpNYL8sqhzE6gUi+Ma1e+JHXuQbiVpAZgEYLP/u6Moh0MLjWvhm
         s2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756890774; x=1757495574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdhCdrEY8aH5pPwYV/MwDdeN5ghAmazJw5FZH5uVyQ0=;
        b=GUj9Wv6KXJoq9gHSu6DUM4Tmhc2QBGDtnYJD0WZrM11kVdOxQBtJJsVpcyf0K6D0v5
         AAQraVBxSJSG1p8XzPGysUQW8tcL0JvDvx+JAErAhaBSn30RmzVtAIz49zcw8sEbI4q+
         0BBHK7KyMFBaP5g1h45fmmBYlecdg7uDvHhXR1qgyqgs1dVcVwJjE/Aqkvhl3t75APCQ
         A0XkDrEPeow7RXhDU7nQEV/WyisF2mTwaEnY/eQ62SAWxSlZsHYByI5FbDBFRvdBg9o+
         ueeYS5PtFC6cTWlX4xiyEg8gz/yloO6RRC4p8LkGH5RZJG0dNtxucphhuxifsQ5kjf0a
         OAdg==
X-Gm-Message-State: AOJu0YyjSaCDcSovk+IkEQIU63z9CQn09h+mWPJSNiV5RJOc138858Fy
	Za80Ao9cHjHG7paGrSmglpE/GkrH9ZTIiZ3qVzcyaVLx/cNEwif9i4Ya+IWPjXGt0wapj+J+BPn
	v/78Gvl1npHPDl92BxldVsLLZcK2A5lVUN5rjAWRKKvRB
X-Gm-Gg: ASbGnctX6fwiPpWWFfJ3cjFxy1LmaV9lUrJyapOEGpe9Sdnsy87iH8yiKxHkHYmvFL3
	biNrOVBIOps3jGcZnAaStVb51z2GfyNMWwZaG5kDuCSsNSsyNQ93GUuNn7DmGEQNf4GaptuYOm6
	8r0PuJUPHUw4TfRDh3lh9hXd4L+5qW1pJAtMerBifxnkuVytaIF4oHViQW+f3iBeAUQSPjIvUvd
	+tIddS//1zl54beKzRGo60EW6SeeWRyEpDSakoeitWwFHdraxhmKzUyn+67kGkgCAhExNziXmi1
	PWg=
X-Google-Smtp-Source: AGHT+IGPi10XO7i69qlu7zMhh4mIH72QpQD2FkRCw88qQALbjjyWAVLAmZUhjWJ625m123cDkJjQySONp5Z41TK5rGY=
X-Received: by 2002:a05:6e02:1c05:b0:3f1:96f1:fbd5 with SMTP id
 e9e14a558f8ab-3f3ffda2b13mr261000165ab.2.1756890773689; Wed, 03 Sep 2025
 02:12:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com> <aLdt7XRHLBtgPlwA@strlen.de>
In-Reply-To: <aLdt7XRHLBtgPlwA@strlen.de>
From: Nick Garlis <nickgarlis@gmail.com>
Date: Wed, 3 Sep 2025 11:12:42 +0200
X-Gm-Features: Ac12FXxrkxVfQGEr3SVre0hdNCRFUr-KWJ6II8kzmV8jMHYEyCfZSb8rWT719yY
Message-ID: <CA+jwDR=zv++WiiGXTjp3pMrev2UPxx9KY1Y-bCFxDbOV7uvjbQ@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> wrote:
> I don't think so, they are zeroed out, see nf_ct_get_tuple();
> init_conntrack copies the entire thing so I don't see how stack garbage
> can be placed in struct nf_conn and thus I don't see how registers can
> contains crap.

Yes they are zeroed out, sorry for the confusion. I haven't observed any
leaks. What I meant was that if you manage to create such rules from a
buggy userspace you get something like this:

table inet test-table {
  chain test-chain {
    type filter hook input priority filter; policy accept;
    ct original saddr 0xc0000201000000000000000000000000 [invalid
type] counter packets 0 bytes 0
    ct original saddr 0xc0000201 [invalid type] counter packets 0 bytes 0
  }
}

In my test, the first rule contains c000:201:: and the second one
192.0.2.1.

When I send test packets with:

    nping --tcp -p 80 --source-ip 192.0.2.1 127.0.0.1

I see the counters for both rules being increased suggesting that both
of them matched:

table inet test-table {
  chain test-chain {
    type filter hook input priority filter; policy accept;
    ct original saddr 0xc0000201000000000000000000000000 [invalid
type] counter packets 3 bytes 120
    ct original saddr 0xc0000201 [invalid type] counter packets 3 bytes 120
  }
}

> Thats a userspace bug; userspace that makes use of NFT_CT_SRC/DST must
> provide the dependency.

Yes I guess that makes sense, garbage in, garbage out. I was just used
to seeing some kind of errno being returned from any other invalid input
and I assumed that it might have been a bug in the validation.

> But why?  As far as I can see nothing is broken.

Honestly, I am not really sure whether it is an issue or not and this
was mostly driven by the assumption that the kernel shouldn't trust the
userspace to properly validate its input.

> We don't force dependencies for other expressions either, why make
> an exception here?

There is probably no strong enough reason to. Was the decision to not
force dependencies intentional or something that was left as a TODO?

> I'm sorry that I did not mention this earlier; in v1 i assumed intent
> was to zap unused code (but its still used by nft), hence i did not
> mention the above.

No problem, diving into this was mostly done for fun.

> Ouch, sorry, I think this is a non-starter, nft_expr
> should be kept as small as possible.

Yes, putting a pointer there was kinda silly.

Thanks for taking the time to explain. Let me know if you'd like any
more info about this or another patch involving nft_ctx instead.
Otherwise, I=E2=80=99m fine leaving this here.
