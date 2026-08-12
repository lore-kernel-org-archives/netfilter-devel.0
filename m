Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AB33624C9
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2026 01:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786497051; cv=pass; b=VgWRe405q8YTaNsxu5nFBqNZ4kMhfNj8tu71l6BROufzPudPcwaVum7jL6RRC/sCNPOW7V97xjHVkq51r2Xf7V0zElrV4RLyvLpZ72fRKBZerEQHnIFNw69Rtk785ALfjSDy++pfXGRcIPaDSxAkk7Vokx/IYZlFKZemn0p96k0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786497051; c=relaxed/simple;
	bh=5t3RlIc3kEj4RmoONu8QAh7Ng832/Cl8+ScHBGHKlaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=USPlm3HcrUrY4mZrwPI/I/djB7iHq1EAj0Jt4O33BqkpETmmmgSH+URaU70OyOwggbadyEbHUjnf5mSjazklRnNuhTCIBTA41FiPNpBIUvxAhn3Gjhczj283AtZn0m4ysxU676jcZIVLQk2cmRJr5M3uR3NhO4CbaQ77pVlntiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i6/hjLdK; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6/hjLdK"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-80e2cfe6918so4898407b3.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 18:10:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786497049; cv=none;
        d=google.com; s=arc-20260327;
        b=EZ41785EiPYqJS3gHaqJk6kMLZTTIGVA3s5QuWyosZakl6zuW7sXnqAkezK0C13mVU
         5d1xgdQl45Eqq1uqCazhDBRijvssSvIegMmNGu0TcRPCOHna77cjXvXc2NzAaIb4sVdO
         4VRrUx3rF4JYUX++bPpalME/aJGlY+G2XbIRTO+cJMOPivRPRKY69URqveazLNtUBpmd
         yuIaJLppFNDx3Cb0ndMpqmZeMwpRNj9b5QgEqExIrXNObUad/chHfNKZlJYAUxpEZ9z4
         qfR4jeYofSk0i7QtPQxjlIPYShfaqs6+GbPXZmNnSWgVSNaajb1QGWvell+/g2r6eLtE
         KyBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ePxAQ1gF6Cdxv8dE9tKiquqdBA8YHy7R3qxF5nLM8Bs=;
        fh=sfI1fWE/hMcQurr0IT2i54BJ2iudyZ/MBpJ2p8YCKfI=;
        b=LTue34Y9f0MaDzeZ2UNTP8msZdmRshk4Tp85nNWRFXwFdBwjJ64hsd8hKMcTdlIyGv
         kURHSgaznUbJ2p3AF3myF95uhcbJOxnmrxPPK+oPgSqUzINwWw/MNEMoMfwGmc+XM5dU
         BYP2QY2HdgUvjcwHtg081nRVSxMegcBajxQQ+0lWU1w4csaIrvr+RyVLwE1AishKjMW9
         SU0Bav8+ZTy1f2ocvLY0UFF0j4uJsqZ3GDjWL/ZhVqx6JBWbzQ7FInfPSQxeqZWN/Aa+
         Nu83TBMq+RtgpRgkKwNa068KnvCK2gtxSzvhqsUWjLrBa0fikE60oVgfXOQM4/DPLaym
         W1OQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786497049; x=1787101849; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ePxAQ1gF6Cdxv8dE9tKiquqdBA8YHy7R3qxF5nLM8Bs=;
        b=i6/hjLdKjPNAtLaQlKA3lChB9ziBannBtT6yj4eo1dY/zPiVQoS6c6RZ4hm9YM0mKh
         tecoacNhbX3vThbS7s4SZJIl9NSSdxRG6QPDOslu69S0KKZIz2c72pVHP7C+rlBvoYIB
         t1f9el55QURcYsS3r7sL/X9YksPyrXcNrp9JEqQv7Rd0SLBLmzxdM9Eajk9gXtqIOdHm
         R0AXoiV/TZWjYLZf7x7VgRHhLJMYH8t8i315JAWwec40HY5c27ZqbH6gsRBkErEgLUim
         zRJSjlu4sv7vD3n9HcWN1UaRt1Zjm9EB6FbABURgs1tQRaFG6wcecP6CI2eNji++vmRo
         c6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497049; x=1787101849;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ePxAQ1gF6Cdxv8dE9tKiquqdBA8YHy7R3qxF5nLM8Bs=;
        b=D7dI8IZCmufS2cRwxLtkpVVsmzdvmM6sIfe+fsTTP4paQQ9m+zl0b6ccE2MlF0l593
         y35AOm9LB6uCbuLmtw8mTq8NwgHJOpcG+bJ2APpGaRTwdWYEFBpQst4LUs8Qv7ZrUo9y
         xT95ihLbAyedMp5Ckzm2shDtV/3Yuh7ZcdUgTtgOCG1OtaFLI4Upcjir7N0O3rO9R2OO
         1U2V0KUp4Xw+xJIyLuH+OKGrfNGxU3tMc+Ry3Qh6WZ9luttm0dSK1eUkwM+0kRTnPmu0
         sd2Ncriu5/51QIckK3mjSHL93wQrqUVg84UNrrc1LZkE/ljeETlfGdXfcfFEE+1zez8G
         X0FQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBPp+DVQzlWAc+H4CkdSl+6PM369OBAGo0dfcT3krZkhj8vnkgRJWvV1X/D8oOCJo2TXhh3lqHBEoofq2nV80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj3cxt91I5eNQEhtUSt6xnhomjFgDd9pPXY9qS3ENfZPXzuCtr
	INyhh0fmvBUPYW1/nY6SgW42RLhkHLBUeSITXg7nlp2/aqfAkaO/j72JJloB4Kej+PPziHwxdgq
	qPO9R8Ocv+gqx+Qg7wD09G1wAw82dexhptLLt/IUOmA==
X-Gm-Gg: AR+sD12uJFKKkc3ZaNEdsivbrKhkdl7fYZ21x95IM8N9U7xLD6TMgN/N+j1o49U93Ar
	2L4zs+H84feO6KTnI/m5d4SwfI9xrVXsnFDiV4e3mY7Svmv0Jw4+0+EMRvriLBzNpznwFSaZNiw
	GPiPdCwLq2Ha9eqbtnMJwsm0kM8pnYk2xQgaArms5P95y2pm1rQxQGeBDerAoVgDLjJzSzcRtnY
	zBTXl+IMWcpR2yp4KAVmRHnotMRWcof/ZKWopoYbyjXBXrsQJFrbSqm6Ggs440RMbpdHS6ZFru+
	eaT9iYHOt50XHSvVULi23TonTW1E6AK7UT87QH//1cgmpA==
X-Received: by 2002:a05:690c:6e8a:b0:82d:aaf8:b263 with SMTP id
 00721157ae682-83105644946mr10914937b3.10.1786497048925; Tue, 11 Aug 2026
 18:10:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANE+tVpU7gL3ZJ9ro4oNKsqdN01mDMBpUou0ABakiO2WrT5gSw@mail.gmail.com>
 <antTASZYV9q81Ucc@chamomile>
In-Reply-To: <antTASZYV9q81Ucc@chamomile>
From: Wei Fang <void0red@gmail.com>
Date: Wed, 12 Aug 2026 09:10:38 +0800
X-Gm-Features: AUfX_mzNPWt8-9A5YfiRwXeRO2G3IDeBrCjSbnyHuFx6225wNASGATbNgDPNNeo
Message-ID: <CANE+tVq_U0dM7hXE3Vn5VVFR5iFD_JoSfQv0ZVn28RuepUy0cw@mail.gmail.com>
Subject: Re: [nf_tables] rbtree interval set: in one batch, re-adding element
 E0 makes deleting an unrelated interval E1 fail with -ENOENT
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"

Hi,

Understood - thank you for the explanation.  I accept the
ordering point: the reproducer's delete message sent the END
element before the START element of its interval, which does not
follow the element ordering this interface relies on.

Thanks again for your time.

Best regards,
