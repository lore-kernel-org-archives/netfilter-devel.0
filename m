Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E69431E79
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938031; cv=pass; b=pjl7iDuwoHtcdwnHqPTCp1fs/7k2yS+UR2iidLNJ3NvpZLO/ZnVRkx4Ic7Wc4nT5gg1f07Rr8278ialUEuamb5NHCI92GFOl5P0EHCHQOyfVGgZQTrVl1plEfnmzSdTLbeUMrRRYmA1VyYPWBkbuZnJwvdmf5RbkUJPHmJgx5R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938031; c=relaxed/simple;
	bh=Up0tRfswt+77mjFqWVZX5W7neMwaKjOkcEe3Ahf+TVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RneQh+fsvkDXs8HY2zVtVQ6r1klO8axGSgBxThFO6VCW9pLPeSnT9YHhViNiDpJDtP5VceCP3Ar33K8IJ+PpiAyyuHVzp2uT3iVW+/L8O2oE1fLcN+sFehux4RO65SEFrZP8MRtFFDomeuJl3tjckA2GoaYPtaz4blFcgNqRKbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=XdApi4HK; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="XdApi4HK"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c9b1edf2bdso8498125ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jul 2026 13:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782938029; cv=none;
        d=google.com; s=arc-20260327;
        b=hbku0PC4SUHDjBD6zUx7Qwg2R+x4PZUel1gfZT7Eq5CXOUXGrkwTnoEYgAGCJt7pn9
         4mY9PuSdqntEci2PNmieELqno5jDSbeoOuStIvWZGGwhZUMG5THHEprNcwRwXTpXZRSQ
         JnTJ7oEJJ6tFFq0du8kKIv1rphjXrV6WAkEmz7dl9crLMkx52Pmr4jXsiCd61Al+9h9B
         K8QIpyceWD5owoO8zh+RiAkdvrn+U0x+ltzhjs1iO6QpSGjBNbnICtVjy8wGHqmz1+rZ
         bByRFN2+35JZkZU+FqxO/c66DZYG9N93oA1/HHdTZ5Qyd/K+VSVqS0Z6uNQVgw2s3K+j
         BDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Up0tRfswt+77mjFqWVZX5W7neMwaKjOkcEe3Ahf+TVs=;
        fh=GOqLCK599hd1P9+miwNxjlm4VDzh459hJ6/D9tXPwGg=;
        b=lRvGdI2OR3gbCqHbo3eHrcpwK6SS0xo9mnXgvC6T8DHfr4UofGjCR8QC6OMtiZHAB/
         rbW5NxEhFIt2w0X1Jr/P/js+zMaxHA9DVxhwcn1qOZo1lIkI/6y15ccb6dWLF0y3McWw
         +bVyBENpcpUUxrHBT+KYAaXOVIjzGJ+q8y4JjKKV/GFulEs5FevQgvrX14AgyTvRTNx+
         Ppf+XT7lK7oxG7VNqQfHXwUPVKXa7RYPKf/DSgCUruxh0mlbgA6EYSesk8iQ1njkcdgL
         +uG+he1Q+ytqiPCjn306BirjRraY+vX/tiPpJVTpll2XCIvgO9AI4LIOQxqdR9Vjc89u
         iPNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782938029; x=1783542829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Up0tRfswt+77mjFqWVZX5W7neMwaKjOkcEe3Ahf+TVs=;
        b=XdApi4HKez9CjQJPYdQr+A/fLFMgqKRmxF/6j/pOxWpHPBiCdMgXtk6kSsCpFuDtHO
         xAREFsYmoZdr1h2MXlgBH5a7wIJrMZEpcTB28g0xzcIxAd6puuGhxc/P2sznQlfqA/d5
         2tA2thAtJUu4BTeoD5kA4vW2693L4MGdHJmhGuaVNxbrQAq3zsCwyQAy8Nk3XXnFUCwW
         Zn6cHd9phNz3GQCYHuD7YHh/sUHaXjBU6vov2Glf8Bbtx2OBolGFc//Ywr4t/9H8JbFn
         YvWUuMcjWqnoke/U9ScpQbP0oFUGpNIhueD3MD4OFadK0CK5DUbqx3pPbwJA1ufdidhY
         X2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938029; x=1783542829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Up0tRfswt+77mjFqWVZX5W7neMwaKjOkcEe3Ahf+TVs=;
        b=eGl27tnfl43pDA3MUkhHZDWB+zQ748PBNt4kP489DLCKT3Gkuc4sPWoQzFp0tYMd9U
         oaJqsgho4fKfSWJEYT82TbKiIJdvdm04Me7PjSxHJCrVDSEBq9HEgruFAuecBoNpb+IM
         p06uJw4+4NjuV5/W7hzizNx8Fc/siR8PlljBHRhrE+ZQxl3A1o1r6tKk1Qmor7rSufvS
         I/J0lz/EazJVwFCee0OkYfSbGUfYFVqDoJ+QnNQdAu2etAyZHT+YhXU8+vNcOh97/Ky8
         Dkc/urmCtA0G7LJqgfrrN3yOzITdOLn21b3qa2Sq/MjfnPK6jc5z8vrXp7x09FRGPL2v
         Ed5w==
X-Forwarded-Encrypted: i=1; AHgh+Rom+nGAcuqL4qZYug2z2ZYPlfHI5QQQHFTNIdRwz1/6NdIRcRRACozVbfveV/XA56Oi8gcnez5ISN1LpVtWd+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzueHmXBOmmrwM0hr2UyUfImqP3yACfLHzD0BUQNd1bwOTCnokx
	sAJFxxeIpEnLdLvCR34TxlilSIl5A+JVxQdI4GQOuquZvDnE8atHaDHUeNVVfxSZgesjNBLcsSu
	XE9xP28J0gj1Q81K8u4E+vIO1H3JgOUTsH13VBWRZgVGJczVaGn3AYw==
X-Gm-Gg: AfdE7cn31PMvqgX55AiYx/Sti0uP/BRGPLWYG6RqNKlnqdMQUc8hF6ekRlDaZBAGBYV
	Hjvk9cOn9IF2XYLfSe4oR9I0ARHaAuP0dUPZgighj7A2d9aXMdhgaMVHHDXswdCuvSmZMPcbmxx
	eDfLtW0Ntk++fnqrn371qJ/C4KxE/SMfU/lmubbEgrnU0hXt4KzwI88IdjBXyv+EVXhI8fIbqpi
	oDYvs1r+ExSC30Keg3nk/hlUU29NNR1hYRA0TeSuDK4XuUcMn5pnulj8cAvTdO8N42Z9WrtoE/l
	7rnkshzlNdsShnZQuBxZtpwMT3J+
X-Received: by 2002:a17:90a:d44f:b0:37f:133a:3e07 with SMTP id
 98e67ed59e1d1-380aa0fc88cmr3135081a91.2.1782938029026; Wed, 01 Jul 2026
 13:33:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630045243.2657-1-fw@strlen.de> <20260630045243.2657-4-fw@strlen.de>
 <akShGOr3YKg1bs3r@strlen.de>
In-Reply-To: <akShGOr3YKg1bs3r@strlen.de>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 1 Jul 2026 13:33:38 -0700
X-Gm-Features: AVVi8CdAP4E5HbEEHn2Qa8InlB22fwub2VUQjNn1UnK_2DY9jxOTTw931Ja-CW4
Message-ID: <CAPpSM+Q0jAO7F_NOTsRngOkkvzFZNoULGvf9pHi8OVp9Co9+4A@mail.gmail.com>
Subject: Re: [PATCH net 3/9] netfilter: ipset: fix race between dump and
 ip_set_list resize
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, Florian,

I'll deliver an independent patch for that issue.

Xiang

On Tue, Jun 30, 2026 at 10:09=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Florian Westphal <fw@strlen.de> wrote:
> > From: Xiang Mei <xmei5@asu.edu>
>
> Xiang, Jozsef, could you please have a look at
>
> https://sashiko.dev/#/patchset/20260630045243.2657-1-fw%40strlen.de
>
> AFAICS it's correct but should be handled in a followup patch rather
> than a v2.
>
> Thanks!
