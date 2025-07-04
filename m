Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F901E832A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751640408; cv=none; b=b4kZf1o5OTcnKYC7HOiYt+Nk+kh3n1tj3dSYtrd0ELMOm9XW2sc9A+4MZheI7J2CMYHGYbig0T86G19CEKjVLYTdn3wrTgA5xhREfpgW3Y05mUeKc+RP93iDmER0hcERQoVtMF9VW/WvsdYXdP0X8W32UrOr1C1rGICWLHjWu34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751640408; c=relaxed/simple;
	bh=M8luuMfD5FOO1x7G+/XGJl5aatHMUxLlkPdYgmgl9so=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPV1qS94tOBp95A7xBfoouDQ1bToVuwVb33y9upKAdWd/fGvDVz2jS7L1j7BBERK5FqETIoNpUStOtzGgAW/kXpWnWJ9Kxqg4B1OjwQjpNembkv2WPDNYIypYDCqjCfs8hbiBgI1z8pUf6zrDUjVR6KvVwF057m8lqkLr0wSzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cf36Tg9R; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cf36Tg9R"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fae04a3795so12183556d6.3
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 07:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751640406; x=1752245206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8luuMfD5FOO1x7G+/XGJl5aatHMUxLlkPdYgmgl9so=;
        b=Cf36Tg9REq4DGZAbMyna+Z/nulR5seX0M+QVkrmLG52+rARn1z+5YDaTPGMpxdyBD3
         JKcK611b9dH3xkBzcbuYmvhIcMK+m4OBY5utnddZUzuehMqjuhlsOdKDVPuUiKVKoEET
         woB1e55HpqsgJaazv/SiaSE399OHmM83n1vGlXBkQWMm/8IScsxH/UWyF3c52Cg39IHe
         PokxUmzNr2Pe+2DrcZs59m4w/HlHRNGaxIQXEPMWRPmQoCdjiHLI5WDKOMEcc+U51vtB
         /13Tq6K6i9N1tV31khZigQztuXzG8usp8+JI7xXaYnIKsgMsPPaJUFmZTyH48Ri6CFo/
         HrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751640406; x=1752245206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8luuMfD5FOO1x7G+/XGJl5aatHMUxLlkPdYgmgl9so=;
        b=TegCerfv08WXVRbBq7K7DMh5PfD0BwdOtNGlv3lKpySD6fh2CiNsk3J22hIjQCAEoP
         3SLfx3DoWc83Cj6OaC3u7YvF4d/hzygSf7KA4eJG6BfT7sk1azxR45+9UMQHx+EohUkn
         CzzXF69fYxUFTq+4I7I3yp4LGv+l5oEGVX+MR9KEoa3EdIVZxfmck7jdMvWxa0BErOI+
         ZRuCRaQagMkFK7lEjpdpgVMHGLMzIuC11VAt9lsCNER9JOP0sn9VLlbBjqnzppoznTc5
         Xos1N44SQ1BvW5ru88zbhl0jt4QYUJqlft2QUi9k3LpussgkTPOCKklKk4Jrh1T9bkYB
         TS0g==
X-Forwarded-Encrypted: i=1; AJvYcCVoSaB1ZoeGSijb7alWAjcrOpS3gbkvz8que4U/pRlsJbe6tOKvENYpn9GJEgnn+ck4o5gaeXPthbl2rFeOVMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUqKIz736i733l8jPgND1Tok3QZ2Vgim4qm9KSmzcN5I60nj9+
	p3VpK6I0n0gmNQhX2B2fMaD04sAtd+M648baKz9z+g/FOHrvgf4DBTQq4/gipeoya7kvBIABqia
	TLl7BVuqLwY7QvrmNqOQsd7xzTICGFU0=
X-Gm-Gg: ASbGncuCJBJOQ45YUR074AF0q5ID4q80+Xm49UrDqoN9H+Sbe/r5L1eVgm+Nu1P3Sq6
	SWKlAFQIuqU7ZmFML5EP1neFnctZLJ+yPBMISmUTF3Ln+6GD8voiU1cqUbkvzQrQI60ng2QQszm
	mP5q6fgDrwYGEaNVZGHEKdh/ca+b1RHSTR3JlNYiwpk4Q=
X-Google-Smtp-Source: AGHT+IGaPlFnTvR4b5zNmlSgAuSVBb65QZPekKAWG0I8zXf069A0sBIRcwY9Q9SywcYikqMkbBjG9HT9YRkVeCKa4F4=
X-Received: by 2002:a05:6214:500a:b0:6fd:7508:9c04 with SMTP id
 6a1803df08f44-702c6db71f6mr33789276d6.20.1751640405637; Fri, 04 Jul 2025
 07:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
 <20250704113947.676-2-dzq.aishenghu0@gmail.com> <aGfIqX2im5ut1WNn@strlen.de>
In-Reply-To: <aGfIqX2im5ut1WNn@strlen.de>
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Date: Fri, 4 Jul 2025 22:46:34 +0800
X-Gm-Features: Ac12FXxLF5il_XXO-qoE0D8jID4zktAtWDEKpVgB1kTReIDhXVh3jvzzv-3L3h4
Message-ID: <CAFmV8Nd71iUaf8+-0QM6L0+df4LLZUQxRmQQcC=9i0uPMPO1Fw@mail.gmail.com>
Subject: Re: [PATCH nft 1/3] src: make the mss and wscale fields optional for
 synproxy object
To: Florian Westphal <fw@strlen.de>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Simon Horman <horms@kernel.org>, Fernando Fernandez Mancera <ffmancera@riseup.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 8:27=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
> > The mss and wscale fields is optional for synproxy statement, this patc=
h
> > to make the same behavior for synproxy object, and also makes the
> > timestamp and sack-perm flags no longer order-sensitive.
>
> Whats the use case for omitting the mss field?
> It seems this should be made mandatory, no?
>

Agree, I think mss should be set in almost all cases.

This patch is mainly to keep the same syntax support between the synproxy
statement and object.

> Also I think we should reject wscale > 14 from the parsers (can be done
> in extra patch).
>
> And also reject it in kernel by updating the nla_policy in
> net/netfiler/nft_synproxy.c in the kernel.
