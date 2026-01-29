Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC325F7A9
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 05:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769663221; cv=pass; b=k1MQDbBfT2hytHANIM0VGwDdC7K5ZE+kSKXywhF5BTodqE4t2c3io6R5bQ4UyEVnqHYxRgQTk0OyeinXEOcvM7J7JmMY/gFPLIQgWz6dkg3aTfuILDfkm1K+OZl5YVowV0t6x92deTvfT5NAj6M0Ktd2zxNQEgeR/XLdXd1FPiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769663221; c=relaxed/simple;
	bh=V7d4MzZRplCljG6BRDQE8wlf7tDBcNWfuYj1stm4g4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmA20xqP1PMX5DsT3cztpmo/pnkpK33rW+ADWGHh+mOc7428+YSVqNv2Ge2lnanVcsovSKRfp+mMeQzBBb86db71UJhbZA+XsMO7rPDC1tF3aTGyNBpBewXRT70cd1jnlXaeCa7BRZZUPM32ftVjzRBT2TA0gbYWmZhg15CfhtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hlr88dwB; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hlr88dwB"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7945838691aso21126357b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 21:07:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769663219; cv=none;
        d=google.com; s=arc-20240605;
        b=iAip8ACY8+e3PEu/iDVIG7KEC4B9n1Ue/qmXmpv8KFgGQulcUYgzupzA5lNMmjlCGI
         2UzZObO4aIXFkHP3h54f59Au5EnuhdJKsREY33a1cZbl3OM0XrcyIRJIjBUYDHK0ZHSk
         /hD/qanum+lL8g/h+j5nznqOpk7eRUEZqC8YY8aox3/JDmdnAvwLA/obdA/3eq+wP8Hy
         bBtp33BnfGtAqDHjHsAyWJP5g9tx+uRwHFd0/0NZR3yn80XsYEyFMZvGilVfwCxvOW9P
         74SV9y3wAs6aLch428xm0aEbTB91CMdOhqZoaiRWahC3ZrvK6OK7ouNbqArcW6uOnu66
         IbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V7d4MzZRplCljG6BRDQE8wlf7tDBcNWfuYj1stm4g4o=;
        fh=DZGLs0SukmC2cZxMMoX5YStdZG10yu3edyvOozVDaA0=;
        b=XfPE9b2XV0NGFdvFGebAKd5mjlx5Se0t+INwTBVor5IhWdB3Xg1Volh93xjrdwAzWE
         N6gwrVv3wvfLZX3Ro6cD6WKGKx8q9tgCXgdRkTSqDiQVS1JnXd0ax0cJENCm8dt0jXtt
         hRgs7irEsnwC0R7NeL/Fh1mViNjljZ51+0B1+9Sp/2H6m2FhFYPCKMuvgaxeE7NbVezO
         uLPSOX60TuemnjKczWbWzm2ffQPBk5+OgptHEdjngoc8u+I1/ZogOgwYj6Kvj+aqrrdE
         6YYwmNB9ETejXwIlnsVPrCvgCVF8qtAk71mwMAKXu11EERoKPTq9/YCc88dwt26WrgB/
         h/QA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769663219; x=1770268019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7d4MzZRplCljG6BRDQE8wlf7tDBcNWfuYj1stm4g4o=;
        b=Hlr88dwBOwdBhmFA7396wNOJRlleQj+Hcb6HICOBx1MkWSTwe3LrMbRpoxA+i5oRji
         HxugdSc5Kd/9Vv4AjU640sJBzDBKanIj/r/8D7et4q0UcZjGgb5U00tDdXA4Ld87bOwY
         FZihNZW+9ADyv3y+uHSTNqMMAOXRUzx4XMRdGT2nP2M/a0MpB3qjTrZxIACYT9F5es5M
         IpF1E9i6Y07RUBVwrb3vnfu+Ne8Oq8x5EjeiGO1WQ3c3XCMSqBjnfzpysMyJQNnbI2pQ
         hNyV2oEBstV6j6o2f3TfbGSWlpCXbszdhml/dOJ9B2C+iezEWD79uOVKvajmOnvyaSMm
         mu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769663219; x=1770268019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V7d4MzZRplCljG6BRDQE8wlf7tDBcNWfuYj1stm4g4o=;
        b=JJE05XgKvwzsn8YoSgPx8WHuknh0TeS6bDxTMBndsTJPGuQ4dUDfSA5nCHF6CGUdDN
         LrhUMks0z4qyIXEqoTrLutO15vp0i8GcelrLmVeJcbMX3lctp0bnmNikWu7ETVXkn7/e
         xyzjnECSdJFoPMz7toJRBWJFSi7FVsDqHXM+EpmMxW+SRguAl0Wt0hpP9/PY2o7o/AQ2
         mTTqobwbk1Ixtxmz+nU0VAqdOhIRwZvp23eAHyPgnlYLLJjvEk3epBiIy3/RDvKIB6ex
         96Z1AnaCaBEheSxerEmAsRCgTo4ucAIpwxmiaZOZy/wt7YL7N/7Pnoy4eYHInSi241uF
         iE8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBJYWCC0j2BIE0rliSRx1TSUPeSTOxSKSg5rvQtQEtkzMwKh2bi7rC1Eq3b3RFksBZS1RhrVSunkVkrz/0X18=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPm6v0/6qvH2H9GqYVVCdAVt88v7PBi/ir3Dp0e1PPNTPg8d07
	uKD1dXLzG1fcqK1qYHIcXldJ11CEAPlmC9NwgMlx4OrtwMKXaQzrWEclx11pLxLjvJigkqjnkbH
	ePB9KQ1IVsb/zW3hR0uyKifM6kLPpvjc=
X-Gm-Gg: AZuq6aL/J1zWhaJxeRi24buKsc1albFbHki1odPJPO449Z1aDbjVFEAFkrX9I73iFU3
	599GAoz5NsCjjYxlIui6S9uAAt6miEwHwhPhCYlcdO1wgy4HjkvG6e6iPewr6X6RGkdOCRLcDl4
	aJGj0B47584V7w/zZseu9qnmV6sBSHqVHi8kos3voqYZ+B+ie7MIvzB6fKDuzMyh3x7ebHg91Z9
	xmy+o2G7CzakiTJ90OQyWqc8FbTAkJZqRU0CtECRi+nSQtivGxtgpCV8WkCax5OgoR+
X-Received: by 2002:a05:690e:1208:b0:649:6053:15de with SMTP id
 956f58d0204a3-6499f0b7832mr1437952d50.27.1769663219410; Wed, 28 Jan 2026
 21:06:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
 <CAM0EoMkFMURPj3+gNOaqO60D4deeht2F3EZWZbmShjO+B4wJBA@mail.gmail.com>
In-Reply-To: <CAM0EoMkFMURPj3+gNOaqO60D4deeht2F3EZWZbmShjO+B4wJBA@mail.gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 28 Jan 2026 21:06:22 -0800
X-Gm-Features: AZwV_QiigrahvFpgRQhL2mt086FVJtoIxfuIYhj5RwxgHgTxRxpd66hOm8jbrbU
Message-ID: <CAF=yD-Jah3+1Sj3-Us72fKNu-__sg7pNb+-kC_knAV=iTHAitQ@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	victor@mojatatu.com, dcaratti@redhat.com, lariel@nvidia.com, 
	daniel@iogearbox.net, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	phil@nwl.cc, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:33=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Thu, Jan 15, 2026 at 5:23=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> w=
rote:
> >
> > On 1/11/26 5:39 PM, Jamal Hadi Salim wrote:
> > > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how w=
e puti
> > > together those bits. Patches #2 and patch #5 use these bits.
> > > I added Fixes tags to patch #1 in case it is useful for backporting.
> > > Patch #3 and #4 revert William's earlier netem commits. Patch #6 intr=
oduces
> > > tdc test cases.
> >
> > Generally speaking I think that a more self-encapsulated solution shoul=
d
> > be preferable.
> >
>
> I dont see a way to do that with mirred. I am more than happy if
> someone else solves that issue or gives me an idea how to.

It might be informative that there used to be a redirect ttl field. I
removed it as part of tc_verd in commit aec745e2c520 ("net-tc: remove
unused tc_verd fields"). It was already unused by that time. The
mechanism was removed earlier in commit c19ae86a510c ("tc: remove
unused redirect ttl").

The IFB specific redirect logic remains (tc_at_ingress,
tc_skip_classify, from_ingress, redirected). Maybe some of those bits
can be used more efficiently. The cover letter for commit aec745e2c520
had a few suggestions [1].

Another redirect limit we have is XMIT_RECURSION_LIMIT. Though this
assumes running in a single call stack. BPF redirect uses it as of
commit a70b506efe89 ("bpf: enforce recursion limit on redirects"). For
tx. Rx takes netif_rx, so enqueue_to_backlog. So it does not seem that
this can address the entire request.

[1] https://lists.openwall.net/netdev/2017/01/07/92
