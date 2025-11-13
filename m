Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94712D5A07
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763025305; cv=none; b=Od+F9P1qm0DQlXdpTYwqg4J0I8sdKgtNLA/7NW4gOGgh1kLClsBCYIeP9bf/nsAolIQwqOJoZNilTL8oPAU6OpYHPsWdc1pDCUn+Elj7CqyKE78iAPkitjjsbfqYx6RBfR9DLwUBs91rRkyD4TdtnL1ZiTRDZHE4mgWPZavokp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763025305; c=relaxed/simple;
	bh=kb8GCBzISZxMBObnJYLcLo1xyRlhTxQlzt5p10iy9/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jl/8ZnELLk5Ec3zGsovH/NBZffkRMw2DTVC6kmp0xy/K3Yz9K8o3/ediHaV2Jea7QmDDgWpLQwMlpxl25WFTzCzHnp7nGEhJpD+Knn6uG7Cg39UjqDZ7rEGfgUde/UlykICYkBTDK+RtcRpEegR1K3wRwE554UNbxmCeJ0cRqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KrN+bVY/; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KrN+bVY/"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-935134ef989so394898241.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 01:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763025303; x=1763630103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9KVozUkK/zJH0JaBiGr0HN/eCPVvCbe07YpCEdnuQg=;
        b=KrN+bVY/dq99OhtAHYodpmFQIlE31s6hpnjCPIsWXhlRN87kjFkJp8w9wF1XlvOFZo
         wkQuwTjv5GDKV45YZ168eoF/W7eizMjfjPH69fRpRxXRpbsKlyvTI+lhpkSAEtUP2un4
         aSmPPWgG1Ed9OkiqvmiiXj3EDu/767C0K4/JNLd4aPh6fNzT7nrJBusvxfOkRcWUGrfO
         4yAYJGEKxUfzEQbdyDMj9226dafz7+sMwGAQMRNg6bOEcL/Xy/5vGm8erJ9oT5wkLyh4
         DHaEIGbIiuQ5qnwtomRS0i6gD77KV7SLm5l189HtSANk0qvvjkskXpgyt7DfLLBWoZEa
         PYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763025303; x=1763630103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S9KVozUkK/zJH0JaBiGr0HN/eCPVvCbe07YpCEdnuQg=;
        b=qvo/Xkyoa+nx0GYh0YKQBsHxCSI6pXucl2BLUOJgRYYdqrrcMKZgNlwNxtMrImUKry
         h7IhHav90RrjH2JiNVl70Bu8O4dRC5prAvkVeSr4QHN8PNeK0wgh0bGXdnO+8Gs4iXXC
         GENz8qRFGQHIeExt50v55vABNBXHa1bT+XYLWTDMtlOb+ldtxAWIsRbhzsKqudJhQ9kn
         UGxtABtcgW8wNkb3RBK/qDmY5zztE8r6swky52AQurYwydz14tW2pOOFgRzUdlJYjchx
         UVUejDAJF8yuuEzJJtX4heBzjA2GKqJPxhHo1Pi482aSUHvkXCHOSUpJUx/TjtWUltDR
         KYrg==
X-Forwarded-Encrypted: i=1; AJvYcCW4BwYCz8IuoG5o2ZAnVEJTIwRWYNjSdhbrfkX0a8ZVMAfscfQZmvTeDiKB42wso6U8LlnXv7CxmgzmOQ+lK3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YykLqBJ69IX+Sm9dNOZJowP97Ox5LaNedSdTKeb/mz+HxzDjLwF
	8xlqlt7tE6TgoBM2tWjtrnUd275B8O+DYf6HmJKE3yGDFzNFc+OpfR/3CAAKBeO8Jm8YUFXG14v
	H5GRmwf36D7Dv0+EFgNyOWUgQtZV9C7A=
X-Gm-Gg: ASbGncuYfpRRR8qr0WB52zuOJgeLW4djwMtW4Jz2rVPRVZ1JBKwrEWHQD3Q1urpB2SA
	WCKnz6asDadcZOyd+Ysg74Lwalnxv2UaV8sa7MLOjXeKQGCsqhAXBz/1hlndwxvyuq19BlZz6le
	lArDP7gqzLqdof9PkpZK0hyvy6arkiBBM3L3XTwkHF/v05HUoyxFFMr5yk4aPJ8+OircQrSwCpq
	Q9lhCNcQmUEmX12ThqrXBgsIv5WaNao5+r38IGXtj8vxL7UQ+xyTO7TNZwv
X-Google-Smtp-Source: AGHT+IGCKlT8KlNNXDeE29mhTzV1PY6dXe3xu2it3WaIVDyYn0hULj3RhvJmaX44OFowRvQL1IhQ+AzGvfsm/iLeSEQ=
X-Received: by 2002:a05:6102:374a:b0:5de:736:71d9 with SMTP id
 ada2fe7eead31-5de07e15d59mr2473324137.28.1763025302810; Thu, 13 Nov 2025
 01:15:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112160333.30883-1-scott_mitchell@apple.com> <aRUT2PIAqo3VY9SJ@strlen.de>
In-Reply-To: <aRUT2PIAqo3VY9SJ@strlen.de>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 01:14:52 -0800
X-Gm-Features: AWmQ_bnfBe6KH2h_Rc9kOZTesdBr9bneRKpm-4Xm2O-RYSOUtmVGAZ2AtJRiAdk
Message-ID: <CAFn2buBaQNSWtb8eU1Mwm-L2i2vaU4MVSjHi3OTwdd9ZyYx4RA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: optimize verdict lookup with
 hash table
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Scott Mitchell <scott_mitchell@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 3:10=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> >  static inline u_int8_t instance_hashfn(u_int16_t queue_num)
> >  {
> >       return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
> > @@ -114,13 +153,63 @@ instance_lookup(struct nfnl_queue_net *q, u_int16=
_t queue_num)
> >       return NULL;
> >  }
> >
> > +static int
> > +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> > +{
> > +     struct hlist_head *new_hash, *old_hash;
> > +     struct nf_queue_entry *entry;
> > +     unsigned int h, hash_mask;
> > +
> > +     /* lock scope includes kcalloc/kfree to bound memory if concurren=
t resizes.
> > +      * lock scope could be reduced to exclude the  kcalloc/kfree at t=
he cost
> > +      * of increased code complexity (re-check of hash_size) and relax=
ed memory
> > +      * bounds (concurrent resize may each do allocations). since resi=
ze is
> > +      * expected to be rare, the broader lock scope is simpler and pre=
ferred.
> > +      */
>
> I'm all for simplicity. but I don't see how concurrent resizes are
> possible.  NFQNL_MSG_CONFIG runs under nfnetlink subsystem mutex.
>
> Or did I miss something?

This makes sense, and I will fix this.

>
> > +     new_hash =3D kcalloc(hash_size, sizeof(*new_hash), GFP_ATOMIC);
>
> Since the hash table could be large I would prefer if this could
> be GFP_KERNEL_ACCOUNT + kvcalloc to permit vmalloc fallback.

Good feedback, done.

>
> > +     if (nfqa[NFQA_CFG_HASH_SIZE]) {
> > +             hash_size =3D ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZE]=
));
> > +     }
>
> Nit, no { } here.

Fixed.

Thanks for the review! I'll send v2 shortly.
