Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD071BDD9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710320569; cv=none; b=ZtSFzewzo2ifB8OLF5kKokry2I9VfefdikkVUWoC1rHySoIAX4ztt+FTeyY4YXB0jPwwb/w0rfLcuIx9mlgKsqkpRdxfyQ9hKM+y6cqp6otw0A45aMnzfd6lFZtTVLPmC+HNleCpDQ9wYiXPQ78q6lO0d5bGKFAmEtjteA29LHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710320569; c=relaxed/simple;
	bh=ockOgnKHqu/ALZC0Otog0Rj0eCzAj+5UDnPy8Js+FFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbIJiqe8XeFhOD+LZNv0UIXKhmaBI6+Cpdpje6GqlsBQ8gaK4TcbjS8Wag+aBMZDb6nNEj22ICQ1MYotCmNRHJhN3N5TkNtaZqqKdSD+1XpCPqh8FBtLHpz04bF1S65rofVNodFhZB4spXKX0okfuVCbOsB/Sioui9ufGer2l/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dS3bXuFY; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dS3bXuFY"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-690bd329df2so32928366d6.2
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 02:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710320566; x=1710925366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ockOgnKHqu/ALZC0Otog0Rj0eCzAj+5UDnPy8Js+FFE=;
        b=dS3bXuFYf7xm9+Qp7j1x9fC3uJLjZ8WWoRfF6O9NL1fOfTQM+iKpmWGNZm3THIuKby
         oCJT2+vp5ZzysM1Cd2Mk4X3vn0UyaqBSsJ32PCz2xfW2t4B3889awx5vu5hZZlostDmA
         +era45I1/wYCv+Lpe3wMCIot2ZrYmP6/a2s6w/cJNeVFv/A7eqC+bjzjF0TKLPWla4zU
         Ih656l0G7KZ6/3JsgBLVs0tBl53zWCDiDSZQeK1rdZNk5fxncEYNtE0DCNzeJQZCJXt2
         znr7hz+acu+7vnKSKP3RW6eQeKidqoi/lB+vFdIiHWZhWQBL5rC0jWuwuBvFu3Jvna1x
         TyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710320566; x=1710925366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ockOgnKHqu/ALZC0Otog0Rj0eCzAj+5UDnPy8Js+FFE=;
        b=XD5qdJN3rPwCal9wRdPw9d8R8ezJoUXUCiKcDDnwHYSA+kMvnvZnanmkn8cs8OHEaA
         yEC+wWZ4DxpE1e/WvQIL4Hm5x8urWhrpsZIaMEZurz94VG0HsFIcKk94XDN/tWjSdY2Y
         yd3V2+0OnYepkT2Grcr28RU5cd8ryXBMhZQ9L/ZS1jKKek2ZfhbX/s0HJ1SoADYsNn8U
         c5ZgXANFHG/rAkiYqQOKfPPhITPRmwQ9lwPeblUEA5rP3Z0qlN5X76xrFtw/nl/3wmEE
         ZI9y8kdOy/MVL3qXU8WFtldg6mYxkY1nX1d27bJEE0ij0aIPNat9lQMwXj0kA4L/CjFg
         LTQQ==
X-Gm-Message-State: AOJu0YxTFufCpbK+PpN42CqBV6hxkVjkV8+x5JkjuXOuxkWD0cKQ1Vtw
	S4JjxKwXkYJgW59emKg49raZ2WywDXqY3fgcM+dDYUj2PdxfhQheTudPn1nxd6rcppXy4mUCrJ/
	v6HhX/Wlwq6EGj/ZKK6nPGEMiQTdEwFop
X-Google-Smtp-Source: AGHT+IH+nfS7sALQtyGIShdCC3yM4YGtkmrlGoMooYXDkKajn6hsJlOjnwFhhAAInx71s3k1pCpVS8wXcTVi3NtD7Tw=
X-Received: by 2002:ad4:4a68:0:b0:690:bfb2:8a53 with SMTP id
 cn8-20020ad44a68000000b00690bfb28a53mr3497074qvb.64.1710320566364; Wed, 13
 Mar 2024 02:02:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
 <20240308133718.GC22451@breakpoint.cc> <CAPtndGCRdMbE6t8psfdkK=rGyqtYW_t0Q3BPdmSCL_08SQzmmg@mail.gmail.com>
 <20240312103451.GA15190@breakpoint.cc>
In-Reply-To: <20240312103451.GA15190@breakpoint.cc>
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 14:32:34 +0530
Message-ID: <CAPtndGCH33BYY9JDaq9PDU0Y+ADNZMMz-EEJnebeVs1soMb9oQ@mail.gmail.com>
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 4:04=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Sriram Rajagopalan <bglsriram@gmail.com> wrote:
> > Sure, it makes sense to prevent this at the caller of
> > payload_do_merge(), i.e within stmt_reduce() itself.
>
> Will you submit a patch?
Sure, submitted the patch separately.
>
> Thanks,
> Florian
