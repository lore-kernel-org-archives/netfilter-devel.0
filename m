Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292AC357A35
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763050560; cv=none; b=bJuu2xhKjydUdwIB0ugvRaaSyxM20kTaefed9e69btcWNEtukMFj5x7xNPdUXUhTnNrmmSwvtxlwaXl8/K8EvETsQdxOeNfBack3omna5JeBvzZ/dzlmsfUFEZIMDBS00XsWJnAZppWSlm9h+80uoycEJ3GpDQNFn8YS3EBc27Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763050560; c=relaxed/simple;
	bh=kafW6vm77X+S5eJdFGrqID+7DDj+I7gbTIu7zvP37RI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FkxjjwCyDGW1m8HNv6bshbhfCrraUQjxv0eFtxrKg4Mygf8MYSnNJcJcyozx+pAig3TCiQfOKF0uJw5myNFwEEYmXFtE+rZnh598H/NvYQfgsmccNrZ4tiwSchTwHKMhkSKpJKG9IvFDxH9igFc8hOeP45Q4zZGk2CqRDn7DM90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1pjjSg4; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1pjjSg4"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-5dbcd54d2d8so894004137.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 08:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763050558; x=1763655358; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtZrc8pcV94m9BaS5IFrkwCaXzwDk1JO5Dgtlvx9nnI=;
        b=C1pjjSg4y7VbbIQiWGAig7QPRE5zgmqH/55gQfJZRM+KANtXd2Mb8clkAgb1X9mKIh
         YS0lWKizGIfFUaVm6RNL2rm6pr2XytoNAyfBoyNK9Wi5baNBLqIBLAxR9oibluvYcAP3
         CAYYdn5eQheU7At9zJ2ShrWKV5RyLWDeeYAIj0Lo80XPUkp3kBtE7G1Ggo1aQ17aqGbj
         jgY2wjdJac1QkXXJ4YXh1+INLFcxEQQSz6wHIwZnBMO9wNR4lv0kFGiusFT3YBO79Hg1
         XrRdOPbCMWcSHSgWodgoRvlYBdpdjNIRDBApUsmQJe+i2E+7oHPxiUM+nVrNUKsVRWer
         83LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763050558; x=1763655358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QtZrc8pcV94m9BaS5IFrkwCaXzwDk1JO5Dgtlvx9nnI=;
        b=r9Fd4X74s4Ex2AdQ1lO/cMvfSBPITSTO4WE2REyNlkvXpeuXKLVt7ShYK9C7ZslzPI
         O9gvDHPmv5KsTRP+TE+4J3AmLYFo0ZI+CLE8JA0OtO5WGOP0tKXqh05AOLEkYgIu9/KR
         ja+VZ0qLdsk3FQoL7sFC7tBqGi3dAyGG6m3UU2+bDSI4cD6v/jlqduY84HR/L/4287aV
         Tw4cnVSDoEl9m3yl43OmPFg6N+/13fPUagJUCpVLhUd3g5vskS+uyVA4A67bnEihOxwC
         vD1c8JIs8a/rYFes5+gbjzXQ8jtVsDi/RKwpHM1HQR9FhVyc15vpw/ret5ZnXs2+zSMU
         IFOQ==
X-Forwarded-Encrypted: i=1; AJvYcCURoG27UpSSC4tZ7YQcC8qmT2DdEC0vQ2qv5MvRJVsEuv6c2qabQXplqjMC/CqxykzKtb8fVe81GO7RRQ7kLVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ifFlO/Ov1WtLU+UaX/cJAnFfSYBZ3SqONlRyAAoOKqcPP6Zn
	L2NUQ8sVAET5a77x5ORB4Za3S3kT/fo2DABLy8pI/ceyxmh5tb43Uxj66VXfQ+WR0qIAkfxJCuk
	cYvu4Os6pe0nIAWrG0IGewaWBx7WNH9o=
X-Gm-Gg: ASbGncuy148QqUzvUQdd+UfdT3VrlDHEVsA0m8K4KGjpitB+7s3jiWTThZ02ksS3Nwr
	GXJJFNlFHl10c7270asEfRpEXxQYsr5+gDi/kI2fXn1UM0d25db5jmUoaUaNmflE6dzEY9j5gsc
	QyecLqSOlJ1k7XeCFfiV4I2moFewE/BqysmU4aVsMlUm+Ko4gJPvQ7v4VXMB+ldSHEkeOO1MMLI
	YCn02G1Y5j6ao2TTEoaae/ibhXiBwr24KOh/HEfgBdaT3AZdZDTRXJ/ew+bCrQ=
X-Google-Smtp-Source: AGHT+IH2HUQ+XY5AWd7wrPGPnvmbvbSLt8KzksKdJcvdqRJKUPwqI37CvV3L4gFpgWh2H8+Lncy/ncP5xaKiRgSBfY0=
X-Received: by 2002:a05:6102:947:b0:5df:af0f:3094 with SMTP id
 ada2fe7eead31-5dfc5b9fa3amr116681137.42.1763050557931; Thu, 13 Nov 2025
 08:15:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113153220.16961-1-scott_mitchell@apple.com> <aRX_VP61EqRM-8z7@strlen.de>
In-Reply-To: <aRX_VP61EqRM-8z7@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 08:15:46 -0800
X-Gm-Features: AWmQ_bmfelQ7mL859A_WFlpN488ACFKOjNy8IKc90uyX9-mjfPmXI3utiSYZVBs
Message-ID: <CAFn2buAJY0RpSBAevCVavq9cUkenBKe3QcnXFA+5qqiS=8z5rA@mail.gmail.com>
Subject: Re: [PATCH v3] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 7:55=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > +static int
> > +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> > +{
> > +     struct hlist_head *new_hash, *old_hash;
> > +     struct nf_queue_entry *entry;
> > +     unsigned int h, hash_mask;
> > +
> > +     hash_size =3D nfqnl_normalize_hash_size(hash_size);
> > +     if (hash_size =3D=3D inst->queue_hash_size)
> > +             return 0;
> > +
> > +     new_hash =3D kvcalloc(hash_size, sizeof(*new_hash), GFP_KERNEL_AC=
COUNT);
>
> This doesn't work, please re-test with LOCKDEP enabled before sending
> next version.
>
> > +     inst->queue_hash =3D kvcalloc(hash_size, sizeof(*inst->queue_hash=
),
> > +                                 GFP_KERNEL_ACCOUNT);
>
> .. and this doesn't work either, we are holding rcu read lock and
> the queue instance spinlock, so we cannot do a sleeping allocation.
>
> That said, I don't see a compelling reason why rcu read lock is held
> here, but resolving that needs prep work :-/
>
> So there are only two choices:
> 1. add a prep patch that pushes the locks to where they are needed,
>    the rebase this patch on top
> 2. use GFP_ATOMIC like in v1 and update comment to say that
>    GFP_KERNEL_ACCOUNT would need more work to place allocations
>    outside of the locks.

I will go with option 2 to make incremental progress.
