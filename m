Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.219.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792594648;
	b=rljzfUfW9x+hlMyF3eFPwrSihbYaI/hw8OSR6ukFPF9VzZ/3KRts6Cf9ZWHryXIl9hkr
	 CmfSGNJ3dV8Pco4acDcynh9AT18pCIKfKzrbqCZG0QemsLfNKADyGADVEdtiuKouAvGQy
	 AU8slKWTU/wosXWJBQW/70Pvo66fhlqMa7UyowKKSlAh69CoTNli42Cl/Xv7H2jFezcqF
	 JyXwpPL+9GWeOk3kMELokbrDzHBrDDqDgVEYzEQqGoSo0ZNUMSNSjsJRcIm6p4x3oP26B
	 y0Yel15cM02GDbt0TX35b/qZTlzSr3lvJT48HH3IrfKUB//VH1UaifhVWJCFieaHUaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XYRHXttcoUT1gbbyFLjXMXCP2cq8DKJEz/8O7DRwAR4=;
	b=CBLrOfhurfafewf2O8sQ0Gqpy5H0b4pNZVAJAfIYpTUioOjV60FefVRW/0O8BQhwAgwb
	 l0HOZ6wvrldF4Yb1VWUEQYfeICSwYXzRuzOZFevw/J6OF8MmW4LXPojRJgoXsb+9VODj8
	 pIbtgCV37rSfcORCDp3WGWLYZzY39nR1Ky/7Uc4wcPxmI4XObDcLP+CzZ+PTWdXd3Gb6H
	 AKlAt6v/5Z5+Og4q80hZmMgnRXJSOJSlz4l6+3wKQT2rpQfu0GX3wnYxmyf+x6VwaEi3L
	 BhwSiIqxHw1YQ6LLGGCMcBCfHlZGouIA8Yt9H8fpUzq92QFHAuo3vmXW2VpoRM3fN8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PC9OR+hN;
	arc=fail smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F453606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 14:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F453606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PC9OR+hN
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-918f75a68f0so11265706d6.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792594646; cv=none;
        d=google.com; s=arc-20260327;
        b=TjImXpqsSs3EL2L2ZyHBcoAWonOPg/e6qiXQyZi8AUvNXebbXntwNshIrPjKHBpWNA
         X2eujpzebK1Dthvt0TFgJ03mooDtbhXUAkDK0HH2GTvjB2EtwLVS7y4//3+LkwOBUVYB
         L5QAEU1MorjOCVdFeuV0zZeX/xRDTIlS0eXuxAGaaMCoSPs6vOPWeIZZ4PTI6SRwDaMb
         ttUxh/Vgw0GS9q0qpvn8ME0S98/oFz/dlE8go5v3Hl+SuRV0m9GNcgy9ufSVxuRf6Llo
         CVd586fRiUi3ZCWDfMC9+CYfGIKCEiW+HLOTAaA04URSvZDGJ8EXo/iOo+1/Hd+DeWMu
         2JpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XYRHXttcoUT1gbbyFLjXMXCP2cq8DKJEz/8O7DRwAR4=;
        fh=ZKVZ9iKXAQUDZvbneHbvF39VscSFBLEjF5ZTcrjVR24=;
        b=pSJP/COGNKv8ztajhtqxJY/pmo2hCvcv99gYgbn8B2R6neHUbfeGzGdNheSleGsH3C
         SpUWfHSAmirDwNx77QETFaLf8EB56vtTJMciSkYamBV1Vq7FTQvFspkF6+Z44kIddVMk
         uE5ij3PEood27xlqT2FfJzu/9ZU2kpYYsqfoRqdZiZj3ipw2zL8OEytomssmUW8stXAf
         LknKCHVJ6k6OHfeXpkODr6dOwtsodt50FMvYJryGmNZXc9nGLvfA99PP6GTF+4mp0WV9
         87/mT3S6UHyMOfVlO8YDn0ILVcvg4qzCqVsup9vDlyaMNKRqP5Fi7SRDXoeU3NfP6GSY
         u63Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792594646; x=1793199446; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XYRHXttcoUT1gbbyFLjXMXCP2cq8DKJEz/8O7DRwAR4=;
        b=PC9OR+hNUprq3Ntc8hkF/BzQ2YaTZNs2WB+R0qJfEN2f/3fwEosgfDYtPgtDJtZ2vo
         w8hmBzVevXLk4WSthgrcY2119AwbFS/RAqGJbDFJ6P92ca7CqkUliASetL36XyuHTQkF
         HnJh4EJ5RFGWIOGZXTtimfM4ArAyqjaarTYZF8IHnVct2KR64cqukjVOSrXlDo2VFozO
         9XXj5o41dlLYRV/3TSiT/I25QvSyJw02jm3aQsB119KgnSBIFoVoVVIgk4CjFIzvwLi0
         y57Oj5sM8KCjGeztZNnJ/6zLQ1TiqgtcJayMtGiNDuwM2/LbP82thvBAleiWYgk5jjar
         SDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792594646; x=1793199446;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XYRHXttcoUT1gbbyFLjXMXCP2cq8DKJEz/8O7DRwAR4=;
        b=NFYz2eOrpc/J2QTDiJdHPS9mfp9MWuTYmw5kwAQXjtMpLRP+gVl4q45FtM0N+W+qtf
         QRk/Gc9i2U5Yr/2ERwSk7MsHj1jpLDTHKFJfLKw2XgZg5nAc4sX34iX5EYOk1Q2ymFuP
         n1rCSQvOjHRP+ccjDV6/bExQ5SSaivU1IMw3ne/gkxphx0L6F9GYbbiSpp8LdOhwpi6w
         gbh+ub5GbwYTjKnqzSSdSPW+BIvEhRt9DjgkgP/eCmUmcbdcT1ewA1xbvd+oVTfQObkJ
         YYRf1FUfhUaafABWyySA20CDXC+/3aM0eCqrZ340iWnkeaNHU/t2MVEDWLZqVeVnRysw
         28GQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwnfHxGa3UVkGdOHQ0v3v2htmrziTn+A+jILFhhA1TEjYWxcTihMZMbvbLvKsazXFoGeeqlFCv6XvkkR8hN1I=@vger.kernel.org
X-Gm-Message-State: AFq9FYIu1lmxtz7OHNDul3QbYXWP/ASo6EE4HmINrcge+2mWaL6qEEfb
	3zUkqqrphlRa2O3eFYb2vPUKVfjGLuEWWEbytPrGTmUwvy59qPEUJtT+qve8F3EKExwC8T0AZoW
	77W6yTljXodhAQOZnfr46g4bWbZNMaMQMPghRHplNnL+FL0DexTKNTNAU
X-Gm-Gg: AYBFou3iri9wgxcZz3tCV+hFnFLIQx9jDQ3pEP91RKL3DJ5ithB+9rLHlpNWSh8TudX
	7DlqS//jG6v1dSlWyIYDN8wr3blVu34SSxf2zhTnKNpuPn8cDtMkEC4f1TyndcovIbpTsiW3/Tp
	wXD1+xOXd0dEtEEmtMlTJksORTm1ogBQk5nBluphESOWeGZJDZ+9E7wGs79oDlV87npne8J4L6R
	C23g41pvutAx8NOWu8Xp239TLUVZTT1nmE9RuSpgC8aZbbPrdgeE0bvMnRgTmyjUG/xtgt4vpHn
	Mny3qeKR+7sBn35QZbN101LCDntVPFc8HLpQju/TCojIt36UnBMW51rEry/P9h2fyuvJ7XCUzx6
	wA+MG/NU+5dWHNfjYcO5IRTs7VN8tkLLVU+g=
X-Received: by 2002:ad4:5ca3:0:b0:917:863b:8409 with SMTP id
 6a1803df08f44-91c12df8b3dmr39244756d6.5.1792594645621; Wed, 21 Oct 2026
 07:57:25 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260928185803.335307-1-aojea@google.com> <20261016133304.1755951-1-aojea@google.com>
 <atfxlqHrKr3n3Qy3@chamomile> <athscka5B9UmNsJz@strlen.de>
In-Reply-To: <athscka5B9UmNsJz@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Wed, 21 Oct 2026 16:57:12 +0200
X-Gm-Features: AclHuK-MgeRYrbunzOvnW_y9zt3PRXOSCZCGgEM75-eQ83h4P1NSay44cjJXLjc
Message-ID: <CAAdXToQqzrqitnP_s+DSyYnVdrbh8Ed21r99wx7_sGuoBu6W0A@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 9:40=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Oct 16, 2026 at 01:33:04PM +0000, Antonio Ojea wrote:
> > > Is there a chance to pick it up for nf-next before the 7.4 merge wind=
ow,
> > > or do you prefer that I resend once 7.4-rc1 is out?
> >
> > This is now in the net-next tree:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/com=
mit/?id=3D5d1b850ea3f6e6ba2090ebc437e9bbec1d7e5ae4
> >
> > according to:
> >
> > https://lore.kernel.org/netfilter-devel/atXgURtsFB4UFXES@chamomile/T/#u
> >
> > this needs a follow up. Florian, please, confirm this.
>
> Yes, this needs a followup, both br_netfilter and conntrack should
> flush nfqueued packets explicitly.
>
> Antonio, could you make such a patch?  Thanks.


 Acknowledged, I will do it
