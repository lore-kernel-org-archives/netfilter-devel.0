Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D40134EF0C
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 08:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422959; cv=pass; b=RpfSebkODFybB5ANSBXAFezsuzBGCrSyadoQ3XhZO8DiWY5kn4l57LFiRU/lOoXYc6OTZk4DcBbl8ZwWIDaRxsmlNG6MejvuWnRWDDYdHtg2AdkfoJUrjz8itrLppUqwlHQr1Z1IDrV5rHrUlJYT6BtGRIB+2W+CcZOu4+6NEeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422959; c=relaxed/simple;
	bh=dWEo3mp7frOFVKITzORF+6HHk5U6mbYoC8XrjT44of8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AVorXTGRJq7CjtgotC0ldahHANeotBYKls0S0gejBMZM4pMJvBHILnwEdKhyaFuccYzxSws2uRkJqnW25Ium/uOIQF811yPX3x3uvjtnpuQLtKHD/goD72dlCNdMDpX1k0q/uyAXfs2mPcFcpJzuPIJ372QODs+eljeoV985gV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=k+HhOoMk; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="k+HhOoMk"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3a2e985245eso15305051fa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 01:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788422956; cv=none;
        d=google.com; s=arc-20260327;
        b=JvTi5bdNiClTjN7tc6yv1R0z3Z1hH7bnnSEq9DEQspo87hkDOwa6NMTDed+g53QGjF
         ua+gCgafD9x3onpi5aM4+nxtbYqWh2DS1XM49BrSb45PDhj0F8zzarAZ+9DNITtjQJWl
         KSUowdczm8h2RgrEvXhNcZy2HZ9k1g9IgJ4JFY0RqOYFXdSwz0B6g6n+GKnICRxSBul0
         jdDt9T0FARbguNtATFF5hdCn4A8rqiZo8MqFGuXlzIhXROH7qf+kHE9McHJAPvIXhllH
         pUc+0W/LnnlDDX77XMHF5y6/7Qw3VBVUNfEsEXZuHo4qH+HDZ+ZcLk//QAFCE8D5adTU
         0GKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XTfy45raSGSmQ3CPJ+k8R7TpaweRcKOSHtZadmJbOaM=;
        fh=XnAaFOEHODbcgK03uUB94aO8k75tlFmGP4rrQWYmH/w=;
        b=LgiuWfJNzIVc7AFJZOJMgJXNosNbU9zqQB4Sbr2ltj/5DKFWoamkayn6nimNiIa5V3
         7SZia+4kv9ANKj5rcxApOD+/xGlxNGJFudVhCr6PS8dwZ3yqVPK2r2PSg1BROreTLzEF
         XlBzK84Bb6U/3vPlTaY1N3MNBcoGW5KGxRbTQwHtBLKfRaMSngJHC7Bz2yjkZZulZYnu
         ucT0xGt/D7zor2PQdzhMcG0mR7U7HC34T5uldWqLFvuTZUViyfExnVUgAdoPQ385pGfj
         JsbbEvUbZ7caA0QUmXigxDVKcH2KZUGyUogeUYwy77fzQN18asn9VFV1/7pmA073uAVT
         ehZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788422956; x=1789027756; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XTfy45raSGSmQ3CPJ+k8R7TpaweRcKOSHtZadmJbOaM=;
        b=k+HhOoMk6tLRoMus9fcYwhdY69VwLNTc+4p+IDImaI4AoiK3BLP67bD4OJY3x17luV
         tZDTqDifOEFMu4J4vHkZwLZMr+HsyumkVqzkU6ZI3pMB9g8U0ltgFtrlxD2e2/OxHa0+
         iO6VWeVs5t2Yg9zM0mVufn79jPdTNOC/ffoVl0tSVHCYcm+oEHePv4JGolDmo7ARLW7s
         eDNd/OkC703ZRdRC0/T7I+OwjmecjtMnyHyvq6E2rbRLgW9o3YmVn654PbY1CDt+8NTB
         WMItEVfAcnlyzJkdSY6t2/9TlgxJtmbjfOXDXgRHiSAe4U3nJf0XZjZgTkFQqC2nsnJw
         0jkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788422956; x=1789027756;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTfy45raSGSmQ3CPJ+k8R7TpaweRcKOSHtZadmJbOaM=;
        b=V2HgDB5QPMEDKyFM4TKc9fN7EZqAWFA5uTRYaKSgWClqSABSpYDdJeP+uC53acQ3wy
         POiYubI5m2zQSN6VMgv9ZxXdaDtZlRJ8lVG6Wh1z85Eo7w9/4JUyR7XSnT44g5mikD8G
         ukXma9cDVOpHsk8iNabw8FZV6aEh5lLU46uydaD1SKdX8aR0kgLwhN932fbCoqzsyQS5
         s+qO6ParH3N/92/8v1JVohI96kjQv/knR0sBDUbqR5coAnlt6APvMtXzYN5lR5SoL9e6
         SygOZW1IL2kik9mYsmbXEMpW61GAohafUYrfG5K/yw8a7aBr+auuu/EF570oMUBIeEei
         X3qQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdg6iOox6kyOI7FRTA4hJaWBmfdSpGxtwvwidM0zbKD6zxMfgenLzX6H8VeanrsbntazU0xK/1vT7neK/PXhs=@vger.kernel.org
X-Gm-Message-State: AFuF++noIpvE2+P39N3HrTeWYROsqMzV8cPkc2tLBZMXOU1BgZ45I8+b
	HjWwnk+da7CV4diJeUHqQ7kpj5RU1ITwg4QFWSrsqH9RTbouHMqweqk27rVBEsui0xID/nbYBwX
	sVmd8KSVhcRKTzF8BWO/33T/ufCyV0sacOW0xT5xBZb0=
X-Gm-Gg: AYBFou3O6C6O0/bs5b3odaqlgQB9yxjIri7W5XmgiIpSVmQTJscAzho555Z4j5XV25B
	dvdQNxA6sawZu8tuPPmfo73rYpaGJVFq2h6DVP3/jBzhA9lR7rCD2Budo7ac08kuy0EJMY2Hpse
	tjnlNxmK3U7A6Dksro//kXroGgozizDjQ1azhiInc0bDx9ChzUB0VKm8R7PPSJ7pEjgJh6mAljQ
	mhEeyDkeWqY2BIwFuxM/D647R10fs1RIBxtVO2yIRIGfBOIl9b10x//GMgjZ/0ojpZsPUs/lJTg
	S+U8bEXtFQSoTmlKOtMdTz+wGd5X/1hJQyUiPzUgswUAbsMxosFMKZLet7J1UNh1fWiImgtmu0o
	=
X-Received: by 2002:a05:651c:4ca:b0:3a3:115d:daf0 with SMTP id
 38308e7fff4ca-3a35008931dmr18616021fa.6.1788422955902; Thu, 03 Sep 2026
 01:09:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1787903722.git.zihanx@nebusec.ai> <8e45ea5d0cf764267a90d959fa40f0f831aabf08.1787903722.git.zihanx@nebusec.ai>
 <apKl65BbdyWCtre7@strlen.de> <CAANe3eT8ycDkomgpzZmni7hMrUX1fr2dE4QvQOcKCPEcw=J=2A@mail.gmail.com>
 <apkahwSdQhuE6gRV@strlen.de>
In-Reply-To: <apkahwSdQhuE6gRV@strlen.de>
From: zihan xi <zihanx@nebusec.ai>
Date: Thu, 3 Sep 2026 16:09:03 +0800
X-Gm-Features: AcwNN1Wd0FgsqLjcXjqWHA6w1DrMXZKkBLBFaJpau8ih4FBDSOgZEW2Xg9zNQoQ
Message-ID: <CAANe3eS22cFoqz1DWAkLXkskZqO3istpX6ARSKvBKBBVKKKdtQ@mail.gmail.com>
Subject: Re: [PATCH nf 1/1] netfilter: nf_dup: prevent asynchronous duplicate recursion
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, coreteam@netfilter.org, 
	stable@vger.kernel.org, Vega <vega@nebusec.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 2:58=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> zihan xi <zihanx@nebusec.ai> wrote:
> > If you do prefer to keep a small nf_dup-only change, I can prepare eith=
er:
> >
> > 1. disable IPv4/IPv6 dup in network namespaces owned by a non-initial u=
ser
> >    namespace; or
>
> I think this is the better option, someone would have to explain
> the use-case for DUP in a user netns.

Thanks. I will take this option and send a v2 that skips IPv4/IPv6
duplication when the network namespace is owned by a non-initial user
namespace.

Best regards,
Zihan Xi
