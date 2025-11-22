Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D1B663
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Nov 2025 12:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763813887; cv=none; b=e3i/d8CtuzRU49x1f8fFSqrcPS1Q2EepCUQs2HIZtMKYyYsTjNd62h220E4S1VJAIJk/gbJuPPjVOsZ1PJhBen/hkVLhhRYoWsxT31fL88QSSxEP701Y/Kdx5pH+qXunbbORnmagTicAH7bD/FTmZeKTYdsA5OH+WhrQbRGqXQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763813887; c=relaxed/simple;
	bh=HTgIUGiLDQqggKOjDSgjwSIFLJZnuTP1u0eT8ENTtXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qxh5UvIyNPg8K58hNcNfkSsi6MqyikFaejlfjDTdnMGynjZ1UqYKL+Enj2sEKhA3gWwLM0dab0/CbrKQ4RILUKm8OSxxo95OBvUkwhdlA/B/a8QUdHTy2l/aI1ABZk48PxRJ3J2iOwlsvfKi3w2Urp6ewPyEp1CKFoqorobPXEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SyUYy0l7; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SyUYy0l7"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so4717790a12.0
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Nov 2025 04:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763813883; x=1764418683; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=girrHLR0m/g+NWHZBv9P/L4+mIbz6FyO5z2W/emw3pQ=;
        b=SyUYy0l7lKQQPxTkZRwzcSLyxQevz0G2SwyjZmoGjZvhayqI9hu3BJ9NWGQo+zz+Jf
         iPN2n6L4c/FFUBwZ7Fyw7viNxGEzJ8W9WSP22r/GUkiKzO/jx8ehqY7MMIvHIz6tLVt1
         wEaTZLhbFgGcfuKSF0sfPFUbRsuVtJ7ddrwxzXWhLOE4nUQ1coZNGdSKSA9ZgDv3YwQV
         hlOZaQvV/93ldXpLDUUDRIFq9WVey5vZyBUCAfsPMgE9oDeNocRvcCDGumU3vOVAKuTJ
         pwmiUj6WaJkfoIhX79yq6o+5c+hINstQOkDj770ApBCtyKxoW1H1qC451uESYoIUXe6i
         qSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763813883; x=1764418683;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=girrHLR0m/g+NWHZBv9P/L4+mIbz6FyO5z2W/emw3pQ=;
        b=ltUxnEZFscdD42n09zyYXB3yWjZ3imNB0C4Ic5mFJL+6jeNE6EPSOJPsSEWUQHfdv+
         vuO8hcgOJql/Qzzb2Ev8Bt8J6JcAKcpsopc/7V2drv65ALyp2h8awlTVEq4lpOryWC6k
         gQejOiMYJOEFq+xJKLGrX+6iufboqKSpK2c6sIv/p28Fg8oM7lejWjVVnKr0JGUyTxWH
         YkeHV8v7PxU1I1l9wXgoTu5E+Zis7MsWeI2PmrsdqPBKKIzdTZmv1LqkGzDJkv7AXuIP
         KaltsZb99R5dMSyGWrvLXKxHSbfpyXBEXBzplxFjg/uW+F0+aU2HzJLC5gofus2noeIj
         9dBg==
X-Forwarded-Encrypted: i=1; AJvYcCVYvwW1B5nUqAnKD5A+AbpaXrBRFBMxuojuA8wE29xJSgMt2nvM1wlUwMGEXU1LKYDnDv2jMurQmZkiRMpLdPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+3A5PuaRcK9TTpnYNpJ8fEFJMMDTWW/lcoSDLmCNVYHp57if/
	mf5WTMAHxtRulioRzPcdVtS005sZ65suziB63wVhHtcukY6aUNOedqb0
X-Gm-Gg: ASbGncvK3ms8T3wwm2KZFYNh7FaZvSXBfulkcZlD/lVlaQKi7ZrPD7BdIRhS7R38wOd
	8oX8NsmDPSmUbQ5oolR9bMncjD8th4WmxmAdrKSdPxZn0OfvEnkRjXNe+WJyjhE0RVNaDSEKHCW
	HY3x0Sy2p5Vbexb3L+aXQGfCYmgXNJFOSeBg/skztA24By+A+xXPc2PnE5nkN/1mw+maDs7RjZ3
	yRrbuasyGzBnF4SV0WPYFfBPxazfhbikogW/e9StxlnFZulOZiRiQ1uXJYcYmJVMdSl4HJnBQtD
	jGiuXvpxfs2h1aCsK5lUtl4AAWOCuOW+PbfQ/WMCl4BNJ/t06kvr95bDWtGNwNWQzu7Rls6bxdV
	Y/R7HaG7GWnA05UPgRFlUz9WG/55j32ZsdMbTUeVVLmPy6pYjv96ZzMKgnhnnNu9L7BH5OnFZao
	0rkfMkctXZizjNEzRrXsBXtGZ+9azR45futmNZ
X-Google-Smtp-Source: AGHT+IE1t/vYxPaVE9MtZnSqtzCrYqsVun7IMMceLZS07i4Tk93Hq5JwelP81Ii7m2d2DMmluIXGaA==
X-Received: by 2002:a17:907:1b28:b0:b73:8b79:a31a with SMTP id a640c23a62f3a-b767156fe02mr661099966b.16.1763813883115;
        Sat, 22 Nov 2025 04:18:03 -0800 (PST)
Received: from localhost (ip87-106-108-193.pbiaas.com. [87.106.108.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd5bfsm729743866b.9.2025.11.22.04.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 04:18:02 -0800 (PST)
Date: Sat, 22 Nov 2025 13:18:00 +0100
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>, mic@digikod.net
Cc: mic@digikod.net, gnoack@google.com, willemdebruijn.kernel@gmail.com,
	matthieu@buffet.re, linux-security-module@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	yusongping@huawei.com, artem.kuzin@huawei.com,
	konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v4 01/19] landlock: Support socket access-control
Message-ID: <20251122.d391a246d7dd@gnoack.org>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
 <20251118134639.3314803-2-ivanov.mikhail1@huawei-partners.com>
 <20251122.e645d2f1b8a1@gnoack.org>
 <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af464773-b01b-f3a4-474d-0efb2cfae142@huawei-partners.com>

On Sat, Nov 22, 2025 at 02:13:08PM +0300, Mikhail Ivanov wrote:
> On 11/22/2025 1:49 PM, Günther Noack wrote:
> > (Remark, should those be exposed as constants?)
> 
> I thought it could overcomplicate socket rules definition and Landlock
> API. Do you think introducing such constants will be better decision?

No, I am not convinced either.  FWIW, there is a bit of prior art for
"wildcard-like" -1 constants (grepping include/uapi for 'define.*-1'),
but then again, the places where people did the opposite are hard to
grep for.  I would also be OK if we documented "-1" in that place and
left out the constant.

Mickaël, maybe you have a preference for the API style here?


> > > diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> > > index 33eafb71e4f3..e9f500f97c86 100644
> > > --- a/security/landlock/syscalls.c
> > > +++ b/security/landlock/syscalls.c
> > > @@ -407,6 +458,8 @@ static int add_rule_net_port(struct landlock_ruleset *ruleset,
> > >    *   &landlock_net_port_attr.allowed_access is not a subset of the ruleset
> > >    *   handled accesses)
> > >    * - %EINVAL: &landlock_net_port_attr.port is greater than 65535;
> > > + * - %EINVAL: &landlock_socket_attr.{family, type} are greater than 254 or
> > > + *   &landlock_socket_attr.protocol is greater than 65534;
> > 
> > Hmm, this is a bit annoying that these values have such unusual
> > bounds, even though the input parameters are 32 bit.  We are exposing
> > a little bit that we are internally storing this with only 8 and 16
> > bits...  (I don't know a better solution immediately either, though. I
> > think we discussed this on a previous version of the patch set as well
> > and ended up with permitting larger values than the narrower SOCK_MAX
> > etc bounds.)
> 
> I agree, one of the possible solutions may be to store larger values in
> socket keys (eg. s32), but this would require to make a separate
> interface for storing socket rules (in order to not change key size for
> other type of rules which is currently 32-64 bit depending on virtual
> address size).

Yes, I'd be OK with it.

Do I remember this correctly that we settled on enforcing the looser
UINT8_MAX and UINT16_MAX instead of SOCK_MAX, AF_MAX, which we used in
v3 and before?  I tried to find the conversation but could not find it
any more.  (Or did you have other reasons why you switched the
implementation to use these larger bounds?)

Thanks,
–Günther
