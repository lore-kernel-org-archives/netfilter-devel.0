Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B234374751
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Feb 2026 13:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772283931; cv=pass; b=OYtUdAO0g16XKg7ukx4evLC8MYPrWLI9ttQr8WD/cNjXCMtxA0iJl+Yw6o8b/J1NE7R+iOQ4KBV0aD52Uru7+TJYU8eHu4RlVUjRFl1ZPfwUZE22PkSVDr0J1WM/Zf0ZK+5c9rMlY58OyDovUKGhcCwojh2nXBV4EHGPslvaEyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772283931; c=relaxed/simple;
	bh=OqozRgE+7Hr2AbFLJnG6hrQ5TWyJLeOE7GLaUeOb7A0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/f7icxEFt/+y7AOkCa6qHjUqCGkWb1BveRhaktI0HBWmlXuhPhiX4PRpclDE1H2uTfUDkDs72QlUioIMUGDkeTuTXG3EBFLgQa2xsYky8T0OafyZQE5ElfCrI5JyeOwSRueT3zKHglIOV2oWVIJxkmZsGoO4KF2UzNhSDsrLaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=LdWYHt/z; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="LdWYHt/z"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2adff872068so14830625ad.1
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Feb 2026 05:05:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772283930; cv=none;
        d=google.com; s=arc-20240605;
        b=WqqxprG/mr+zS14CetQ7Fdt3PzWqdkVzkLUnidxHOAMxHY5j9B4uvHgcxEPSkvPDIb
         tCtjlXSJtOeJK5Te05ztq2ark5EfbmyOAC6KnGFhK+y7xCTKZSUzuNE4LFV0/XReJfvO
         h+m6pq9U0BgqcVfIhrP86bpXQvcjQrJuIvLfoSMXuoNmwETCN45ReZ8sKi4sjn8T4OR8
         LzyyumNdduLPF2GBWVLYkANRl1KfIxA/HxeHuFrIBIgsYliCbMSkIOfwsDJjNN+7SK6w
         zQUFhgNuxHqaXSwVnI7iNCelhlY3HYOCC2cPBAIzLTk9SrRqaaewO70VnDn1+hz9wF5d
         ZS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OqozRgE+7Hr2AbFLJnG6hrQ5TWyJLeOE7GLaUeOb7A0=;
        fh=YrWhaMUpjUro9sHuY5SiVL3Co1ZTxUaIn7IwBGndN30=;
        b=ihETCmNlLbBW2YDOv2IS5icPT6qt+p2C+//3zu0fvn9oA5Ie0+WDzsyW6PFYqpTtI/
         Re34Kj9vIhMr6DGvjqjjy7vmRhfNnXW4CMGEV5J9hzXFoVAx9FcJGk8NIc2pbT9Gclvu
         T7ytc+svDTt6/7M9iD4X7p25YJzxJDc/7xiQf1ubOWaXkTHCUFrpru6NA6uVfLgz0WP8
         hFZEZlIm8l8+cPrllnCuhMNvn3xUt3IPZoBBiEfQn1y57zzzPqe9R5gf+wkXuE/vxJj0
         BC25EIl2KKKWaEt9ORrEB6r6Gw3ispmSLNOmx3+iXcSinWQhwcs+pMkMmEn8V1chj2rX
         1Xyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1772283930; x=1772888730; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqozRgE+7Hr2AbFLJnG6hrQ5TWyJLeOE7GLaUeOb7A0=;
        b=LdWYHt/z7UszWxsjf2OOzfhxDD5y9UTAr37f0eD793Z1/354DhMychY27Dl5AdKmS7
         0tnSiuN/1u6EHiQ1c7gfR+0qx1vDkgg6y2H5kFW3zv9fwItp3+NzWyV9Jr3PIaI6emgA
         ni8t0OvdSEAXdImwHwu9QmrpoxYo0kfwZ/ptUW15MfThkPrg+ZbNX9VehwnLynX6cryk
         7jn4+i2LUJt0hpjkKrXam6FjsGMvWNuIoteW1X6AURnW60TmzuvsWs5qlrVl2Ioh/Ld5
         ujhzCaGfFVyi6L7z63DNonnNuH/ZC3JhWyjz2VLS8QtXxVZhNnsFDU565TlL/ziwsK+f
         v8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772283930; x=1772888730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OqozRgE+7Hr2AbFLJnG6hrQ5TWyJLeOE7GLaUeOb7A0=;
        b=ppxTzkVM0dEe6oW+/DboGd2Fny5omoBtPmt4smr4C/O9BiM8mvQK1LYuvOl/tjP7N/
         8l7fyHrn3LxaVuDEFH5Q5ah1RZRqtAuFzo8gBt/mX14LxJQB9A6QTumr1SM2tTWy4gzy
         9Ne8lqbT+DYtHQqUQWdcEsirRKrKGmhW4lKJ4oi9nqP5VT646q0azVkABbyewr/rXg5O
         nACYFAouC4v4K3TxXDuHtnfFumOO462r7zQjQT45BS2nGaSe+U7nE5e7CiRD224ckv5y
         6YlJEH5eKj0XjGluR55vK+pjUsliQODyrOyE/7WIAhHe1caqBASzPIEuuLV6n644egn5
         ueUQ==
X-Forwarded-Encrypted: i=1; AJvYcCURmyFflG1eGSnytLNEJxEIYuAFkbEhCV0ajV/nfonjqXDEPwTI4GBUi0Bnp5LweoAlI6lv+VoM0RUV7Morg1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhKq2r2Yyw0qCcHgzPZn/qWeaoZQgRcRwyWuZUnlHRXGnPuMWZ
	UAyG5er7Dj8Pu5ge/F94nsVXf9inWqL4xXjuOH5G+W3PQn3Dk5uXvl8V9O59eoZPoVkOM0TEM4E
	U5WZsWiofiLsr+hH78rmLXBA26luCXD0iqQWZMHf+
X-Gm-Gg: ATEYQzwBryCz9n4DuXkCcBYtYbsUn5GNJPyS2gZ1imDjQnh5gBD6Z64qE5YCPuF7h2P
	DnYhQO20LnMK9bkvhRwzbIeGRjTz+eV2RHX+FFU7TbqLEEXrKsw/TloFFYEp2HNcF88BpjtkBFC
	zgpZtz4idqArYX7/BRBAndPBrudp7jGRu+pYgSi4wjolLaGICdd5II/ecsOrSpW0hRMlf6o7pe7
	neg4WZq081kh8fzL3IGWOSsr0l+wO3bE0ScmSMWp430Kc2eD9IP5zW2E4Rd03EWQuv5xdg2EecG
	T27PuHXn0Y0grv/4mogY8vqC/A==
X-Received: by 2002:a17:902:cf0f:b0:2ad:99bb:3129 with SMTP id
 d9443c01a7336-2ae2e4e8d73mr54637665ad.50.1772283929489; Sat, 28 Feb 2026
 05:05:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
 <CAM0EoMkFMURPj3+gNOaqO60D4deeht2F3EZWZbmShjO+B4wJBA@mail.gmail.com>
 <CAF=yD-Jah3+1Sj3-Us72fKNu-__sg7pNb+-kC_knAV=iTHAitQ@mail.gmail.com> <CAM0EoMmAQ8RvHRmyEeMwehhNe0yXzn8NU5UvwitzAoL3cwVPqg@mail.gmail.com>
In-Reply-To: <CAM0EoMmAQ8RvHRmyEeMwehhNe0yXzn8NU5UvwitzAoL3cwVPqg@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 28 Feb 2026 08:05:18 -0500
X-Gm-Features: AaiRm50J7n10K1tJc5XtV8aE3FRKjaSqWroTN1RyVqgLAaiRSaTEaJr15HC97dA
Message-ID: <CAM0EoMmXq67kso-n_+Y6sCMhJkkiE8b0R1Kn-d0rLb_X=ALV3A@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

()
Sorry, I was busied out so dropped the ball on this one...

On Thu, Jan 29, 2026 at 4:22=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Thu, Jan 29, 2026 at 12:06=E2=80=AFAM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Jan 15, 2026 at 6:33=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.=
com> wrote:
> > >
> > > On Thu, Jan 15, 2026 at 5:23=E2=80=AFAM Paolo Abeni <pabeni@redhat.co=
m> wrote:

[..]

> > > > Generally speaking I think that a more self-encapsulated solution s=
hould
> > > > be preferable.
> > > >
> > >
> > > I dont see a way to do that with mirred. I am more than happy if
> > > someone else solves that issue or gives me an idea how to.
> >
> > It might be informative that there used to be a redirect ttl field. I
> > removed it as part of tc_verd in commit aec745e2c520 ("net-tc: remove
> > unused tc_verd fields"). It was already unused by that time. The
> > mechanism was removed earlier in commit c19ae86a510c ("tc: remove
> > unused redirect ttl").
>
> True - we used to have 3 bits, but we can leave with two;
> Unfortunately, a single bit won't work - otherwise we could have just
> used the one available.
> Only one bit was available, so we recouped another (skb->from_ingress)
> and adapted it to use the tc cb struct.
> There is still a chance that could cause issues - all the users of
> this field were CC'ed and i was hoping they would respond.
>

And indeed reclaiming that bit is problematic. So the AI didnt catch this ;=
->
Stephen, see if you can improve your prompt to catch this in the
future. Should be noted this would be nice to include as well in the
netdev type AI to catch cb stomping bugs. Turning skb->from_ingress
into an skb->cb field is problematic because the bit gets written way
before we hit tc. First the mlnx driver writes it in
mlx5e_tc_int_port_dev_fwd() and then the GRO code trumples over it. So
by the time it gets to tc it could have an arbitrary value. So I guess
our overlords are not ready to take over ;->

> > The IFB specific redirect logic remains (tc_at_ingress,
> > tc_skip_classify, from_ingress, redirected). Maybe some of those bits
> > can be used more efficiently. The cover letter for commit aec745e2c520
> > had a few suggestions [1].
> >
>
> Using the iif check against netdev feels a bit "dirty," but if there's
> a strong view that it's okay, we could liberate that bit (some testing
> needed) and in that case i would leave skb->from_ingress alone.
>

Let me try to reclaim skb->tc_skip_classify first and see if that
causes any issues.

cheers,
jamal
