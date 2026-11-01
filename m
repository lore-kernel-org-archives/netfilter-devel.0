Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793548470;
	b=ia3B4i5o8gGQkZGtPqd0xSBdY29ByHpIC7AaNZEzaCT0UjU+Hc8JZU9ODcYsh6xbNeFI
	 NNHgIjgZrrRhiW+YRGM/kzVbH3mR+ya6yJOLC1u/NCwROqLEASV9YR/ggLgZQgbh6a8Uv
	 ir6I7ycq+hVfYVWUvABvNAYr9J21PxAHYbycwjI27pKz88t+FzH29hNmIKhpdRC5aisH+
	 L5WKFNitWwqEcurwec68mlV8XxnIyykV9Zy3lSQiZJgKe+av/4WaGhARTAwLObo55i9jm
	 fyCxM/wV2NlDMCbMKk90qGTPrOjNEKlSr/tYg87cLD2NNLIb5PzUzEXswMbGgnXp89A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793548470;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8Ol42oqNQB9bpHXLsAG3YClpLWwidNzN9Gqb9wYpJ9Y=;
	b=nocnmeCUWLj9gol+odSEDOGh0dpnqZpKXXKGJ9ZL61FnJA004uXJqsBi+ezCz/y9so5h
	 P31JNOiRadXYCG3BKuIcmMmedytABONZOS1JgVRbyl8+19rj+l1tOjOLYpUjmqEKMxbK9
	 vmPV7KHbZXGxvfJLUF7X2XJRzz5CDYbcQFvbgzCjfleWXclwq9Lf8RmdW5oW4s1adcyLZ
	 nq2q65yylYQopQPCvhZ3xk0CElGg8UAiUqSt8EKA3aRiuM79rDrFxkdNhejG+itdNMMzZ
	 1RHqAkE7W26Ly6cNiVSEVaNlFDyihgYip/29EU08NVK+DJvqbhTaANmoLIn65Ol/lTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=okFL4KW9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AB2606A324
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 15:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88AB2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=okFL4KW9
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36a1947498bso1156125eec.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 07:54:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793548470; cv=none;
        d=google.com; s=arc-20260327;
        b=YmAj+yBft8+QpRAzMUy4OSrWnPTGCVv0t9cTIhMg2KqCn4FizZbiH5sAfaO1z3inCf
         /eGLJidzJaqCLozO04SJnwWWH42LcFwMdswi8TFa3GfvfhQUD32g6EroVK7DfaLZV4hs
         b+39nWwXAOReFUtRPGjWOj9e77zcAkehCdj6RXWZzbDjjHDAFRBCNmxjs+B0KZKJP/lJ
         FFVPrnaTyFkBfwnGR3WASCVxbGjS1SwqoPC+pmy08RzabIz7ISp9OLlaLHqD7OLguyLn
         P1Ks5S/VDh932CX8TdU59Q2y28e/M01MtfNJ2tNYlfJ/5hbaCpv7fkKtBTNprd5PMWMN
         pDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Ol42oqNQB9bpHXLsAG3YClpLWwidNzN9Gqb9wYpJ9Y=;
        fh=03YDR3GBY22s8FLuQ/j88hHm3s6hBF69pjSSQ0QbmnQ=;
        b=FFkXzQdfVVezCm3cxTW5OeihPNJyeG2afyMqzo+DT/x7j9CNP+BINNYOlJwpJ3zkBV
         651tYfD0UOIbUDnyvPWvBbgHQxWHtHJzCzPJjCMXQJzKxvd92i3GkMkbGx0mLezwXlnK
         EBnUhZHkkeskWHfcwxKS4O9idUa2b1YeZC28sBmHEMv5wiUu4t1Bah1KzQXqmqP0DZPP
         bm0BpWctWGUSJfaNQUdiaui8o8DDI5agZ5JB+hOsgE/PJ3NdAURcUDf4CZemAOim7nMa
         oBzxUCG6gWZQrxsj9FfJ0YXrvhAj0hzMXf+5PCQysv8uIn15r523azi1J/PqLBJiw9N+
         PS+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793548470; x=1794153270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Ol42oqNQB9bpHXLsAG3YClpLWwidNzN9Gqb9wYpJ9Y=;
        b=okFL4KW9F/hRBawGds3EZGCybauFp9RxsAmEkkieJx+uvAqcSmWR+CdYbiNCjnIVt5
         BDFKGPdW0PAdmLUSvA30DhawcdbMwdgHoXQ1O0Ll6b4kN9lc/3VFcDJytgWrZJFODTO4
         zF7tQF5LLuvcvAeVpZm/wW1iF5MS+e2OqOvfyRofB894OhLOZ3faVwC0UesSQ9z3gdJb
         Tctw0euGgHB1Lx8vIMNnxYR/Ez32P2O2nrFzzptzoq7KgaHbvxZB8RH0bkwbDXQUk/1K
         +8TwBY0PdUe0Dp8wbGliFSjseD6IGcqObUuearPdJn3ffAkhMTB/Bn6mMiso6PD/1VOM
         6jPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793548470; x=1794153270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Ol42oqNQB9bpHXLsAG3YClpLWwidNzN9Gqb9wYpJ9Y=;
        b=fc/Ve/XfHuy5c1CbWhMpIGBxPjHaWskn8Sdsr/dFboabmY4mVXm8flqVYSiM8lK+KA
         NiGsRmDVkr198eWxISS38q7hKh9b1bCzdgwUYhgTZIO64bxsaOAp9sJuEyH+YKSDaXux
         sUmfE9OQfr8dlNCOhRHfqI7rSRcr2wgpN6nzRoY7gmx9fY96ZnJcn4tvd764CY4Liyzf
         AiQEqc21X4BtmQc61cGDihtJR1zFsosnxQuvzdRgwsrJ439yByUZl5cB2SNDyhVKU4EA
         U0BqRBNgUWQ8dgl/xLjaI5jG8STTdlOufCGpV1aq87b+YWr+WMIiGAsSta6nKR+2w7f2
         0+Cw==
X-Forwarded-Encrypted: i=1; AKwUvBx9HuJZ7EW95gWFkB/kgpIsPtZZaRgOvFkAoSlS8IMern/PWOKltjNsIDI61bCWYmI1Sjw5dyh5CzOc0MDzCgE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLknGcIA0MeX1hwoNqnMoQ9IWcECIf+SMqiRzNgbGSuG8a0bavD
	V0rLum69XLHtWqRGZpV+2udjDP+clWCHqmXVES3EJkyzqBZhIogJ5F/vG8Rp1AgMJHKYGQoRw7K
	iUqIRffUaESxuwbYC3q2NkB5fgiGYi9k=
X-Gm-Gg: AYBFou3CD0UCrRWG4otiae3rjfMktajvrWg0q5N6RJTvI2aW9pBPzFKvNX+f4nCE2r4
	RubcPQHX2fS1fN5mbOOD5p5cwGgIGB3nFSxy4Uz2qrTgZO4L4lOnQZmYelSQm9eBsvurPpGTWU7
	KxAblZifwN29+2YBAPfmf2oOZffJMVf7t7DWXLjKHteKnp6P7I2xbhxexNSMdBU+gzbP9eojfN6
	8gLdgEhCOlaB0XC26im5/ra7NDKlPNLWMXZmi7mRPdbSZ6BuX2y2MDD57mtmPZjpPnCeH0mGQfd
	haCvP4ymHGKNnwoWvweVyI/pxQignR0xWz59MBoS9831WGnt8nlMEocFf3QQzC68yReRx3drteD
	9i0LFqTAH1QTHCf7QnS8fTgpTmoFdmLOF1uc0y6tAEJiCbTVaYFyUi/SsMUBSlkZny0Uy9QcRqq
	8JuoQX3oPuM5s4uBui2VIx1ncIfg==
X-Received: by 2002:a05:693c:4151:20b0:36a:f99:ae79 with SMTP id
 5a478bee46e88-36a4232f3f8mr13332360eec.7.1793548469528; Sun, 01 Nov 2026
 07:54:29 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101-nfexp-pair-6-12-y-v1-1-56cef5744745@gmail.com> <2026110153-headfirst-rift-1d96@gregkh>
In-Reply-To: <2026110153-headfirst-rift-1d96@gregkh>
From: Joas Antonio <joasantonio108@gmail.com>
Date: Sun, 1 Nov 2026 12:54:17 -0300
X-Gm-Features: AclHuK8AXD9H53KSgzNVUTodqPaN2_tNYg1yHV8DPG6o6d5skT37RG4wQLh6XnU
Message-ID: <CAOCBhwFHdydRCh87VNAnTC0Bh4_2NU_77zViQHUOF1QC_XP5pQ@mail.gmail.com>
Subject: Re: [PATCH 6.12.y] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	Sasha Levin <sashal@kernel.org>, Jaeyeong Lee <iostreampy@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

6.18.y does not need it: it does not have b8b09dc2bf35 ("netfilter:
nf_conntrack_expect: use conntrack GC to reap expectations"), which
is what makes this follow-up necessary.  In v6.18.60
nf_ct_unexpect_related() still unlinks the expectation through
nf_ct_remove_expect() (net/netfilter/nf_conntrack_expect.c:292-297),
so the SIP/H.323 loops there are fine.  7.3.y has both commits.

b8b09dc2bf35 is only in 6.12.y, 6.6.y and 6.1.y (since 6.12.114,
6.6.160 and 6.1.191), and those are the trees that need this fix.

If b8b09dc2bf35 is queued for 6.18.y later, 4aa63842fc92 should go
with it; I can send both for 6.18.y if you want that.

thanks,
Joas


Em dom., 1 de nov. de 2026 =C3=A0s 12:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> escreveu:
>
> On Sun, Nov 01, 2026 at 03:27:30PM +0000, Joas Antonio dos Santos via B4 =
Relay wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> >
> > commit 4aa63842fc92de1bce59d4709a0d32e718890bb2 upstream.
>
> <snip>
>
> What about a backport for 6.18.y first?
>
> thanks,
>
> greg k-h



--=20
Joas Antonio dos Santos
Cyber Security Specialist and Ethical Hacker
joasantonio108@gmail.com
LinkedIn
