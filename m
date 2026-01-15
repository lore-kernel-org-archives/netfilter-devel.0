Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7FE22173A
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768508224; cv=none; b=L9ihJYl0ZEC/eV/HsX+NISxUNqIT7x3kmmBcL2TkljJ9OC6E2E6u+ggBZOSgGVSogGfhYMnaK4e5V3NoTZoJvVGATDFtkGv9Y/o3vPAtQU2jrEVAd/83UH5r2rrBMm76DV+eg/yCh4kBGppx5cHnEywvkqZutJHYs98ogznlGrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768508224; c=relaxed/simple;
	bh=sr/hdWFQ9KkD+TzkczJguG2xe/t5a33rnbeMI16o8vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pA6JOK0OTbh1oD4ekuI2mS9UPl9U0fgUI/4BVsKa7twD0/ZoaEwuTTOTgms/zW7ijBJWL+/g8x3O4HwxEVajOfZ00TtXciKzJvk3jdtAxZEiA8lzqjNjoIbdO7XJNAxXUFBfXlzPIro36qcPrZqZqbA9J0fdPBS6+AbtcuuDXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I92j7Tnl; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I92j7Tnl"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-93f63d46f34so429027241.2
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 12:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768508222; x=1769113022; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhclwvWvzEdw1QOphaqNrn+NFyAYXreTgP2FFPklQQc=;
        b=I92j7TnliemfJnMFfkzH8K1qOtoPPhKuxyFWjqRGET/VEkq5JEcMZ2WIQWM2HYgvGo
         cEVN/5HRn9XNfKDIJRTxs19ysbUwamA+EaNaZZUWF7sEtNSj3U/gxsVCdgDy4/QsIDb1
         XVCRHbiuqK2I7gzq+eEWlPDrL5zMRt1lT2C16H58HkIybrJkp5dU7K++IyjaIdPOyT9M
         0vZtVtlKCO1jXkTYpbdh00zxRVczsEklcd6XeDz4s6poA+aTL5pDyfbfxD0iLnULMo/8
         Aog/aGXmLXT2NJNHSDGNK+XgvpfCVUQlwXR8FWzHe68Vx4LUSsyCqfEBO7hu0vQlKPSD
         d8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768508222; x=1769113022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zhclwvWvzEdw1QOphaqNrn+NFyAYXreTgP2FFPklQQc=;
        b=ehtb3+MUeKuDbZRIQupQu46kF8p5bH3bFfRAYyufQSYjQb0ghXk4f9YvMLQ+fgptep
         b7LBoyGOfkbYEyxXrXtE0wcK3yqFH9D4Jm3pBdKtmGJG/6b63pXd+haVTqMaMIzIeGnr
         ki3gZPvaCtBDjSXTyBJuxIOvjwY+t6WJGMzxYCOaNVM/BZMA6QMo21LhzsvnO3eTbJ/x
         lJsl5EB+BLVFvK4Gj7erOi0kzYliIutErubjRH7m/1LZqYNwwD6RCUfLMRPlppWqsjuC
         sIw32K1b3D5UbjaGd4t2sFYKNMb/VAC/f0s7G3bBCPCJYGIx72FKovZHep85yU1hTFDQ
         fKpQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1thPP6ZEZcvjzT5xyp0WrhEhVzoVQf7NklJXRO9gO/ryElzcvu2BHlTbjFs4+JfWmR6BjzSjjLu4AYDw09lw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw69WbAxwvKW3vb8bo3JV9dk5l0hNSPa5ESZPx/hSAnI2H+qCgN
	aQoBjlj5SslRHndUU13Ep2OsY4OM7XJcvHMcoenizSCv/LxEB53WRIKtpW8zAXtG3+u3P5skITm
	YSEcWQbMW3awuesh0V5+DzCvHJaNMKU//8Q==
X-Gm-Gg: AY/fxX4Rl5ZGeBnAmpO0f8UiRTH/mPtJIfZrKr/rQm1+D4bEC9TPXdz7En5cHb/1Yed
	GXv7pHia2WX4acWdHYN4rx4Li/D17qjCzXhgWriGKMtp7YWZXlGTZ1K9CUxcaENiSfHNp90nd5e
	6UPjtdSna3b+oa1E0vBDYkmodB2Y/zW+cyrqggC6JpHhNBR0jwTlY1zPQ5NkIhhq4hC79WB5JM6
	KCNSm7L2xBTS+4aQLRWGU5M486M3nKoboBGYgL5yTnBi40u99sriNkTbsPfy5A8xs9/auTQ4WEP
	zzTa5BDBejQV4xVYnYXx0bkCAQh0
X-Received: by 2002:a05:6102:3f52:b0:5ee:a068:b349 with SMTP id
 ada2fe7eead31-5f1a53b0fc9mr385805137.15.1768508221761; Thu, 15 Jan 2026
 12:17:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <CAM_iQpXXiOj=+jbZbmcth06-46LoU_XQd5-NuusaRdJn-80_HQ@mail.gmail.com>
 <CAM0EoM=VHt3VakG6n81Lt+6LFzOVKAL-uzjM2y_xuWMv5kE+JA@mail.gmail.com>
In-Reply-To: <CAM0EoM=VHt3VakG6n81Lt+6LFzOVKAL-uzjM2y_xuWMv5kE+JA@mail.gmail.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 15 Jan 2026 12:16:49 -0800
X-Gm-Features: AZwV_QiCf4MFAT586C7BvNoVP7RL0PfDmrffbC94GvHxKxhZrmwebHR7iUFKT-A
Message-ID: <CAM_iQpUGvHLB2cZmdd=0a4KAW2+RALNH=_jZruE1sju2gBGTeA@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	William Liu <will@willsroot.io>, Savy <savy@syst3mfailure.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 8:34=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Tue, Jan 13, 2026 at 3:10=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.c=
om> wrote:
> >
> > On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.=
com> wrote:
> > >
> > >
> > > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how w=
e puti
> > > together those bits. Patches #2 and patch #5 use these bits.
> > > I added Fixes tags to patch #1 in case it is useful for backporting.
> > > Patch #3 and #4 revert William's earlier netem commits. Patch #6 intr=
oduces
> > > tdc test cases.
> >
> > 3 reasons why this patchset should be rejected:
> >
> > 1) It increases sk_buff size potentially by 1 byte with minimal config
> >
>
> All distro vendors turn all options. So no change in size happens.
> Regardless, it's a non-arguement there is no way to resolve the mirred
> issue without global state.
> It's a twofer - fixing mirred and netem.

This makes little sense, because otherwise people could easily add:

struct sk_buff {
....
#ifdef CONFIG_NOT_ENABLED_BY_DEFAULT
  struct a_huge_field very_big;
#endif
};

What's the boundary?

>
> > 2) Infinite loop is the symptom caused by enqueuing to the root qdisc,
> > fixing the infinite loop itself is fixing the symptom and covering up t=
he
> > root cause deeper.
> >
>
> The behavior of sending to the root has been around for ~20 years.

So what?

> I just saw your patches - do you mind explaining why you didnt Cc me on t=
hem?

You were the one who refused anyone's feedback on your broken and
hard-coded policy in the kernel.

Please enlighten me on how we should talk to a person who refused
any feedback? More importantly, why should we waste time on that?

BTW, I am sure you are on netdev.

>
> > 3) Using skb->ttl makes netem duplication behavior less predictable
> > for users. With a TTL-based approach, the duplication depth is limited
> > by a kernel-internal constant that is invisible to userspace. Users
> > configuring nested netem hierarchies cannot determine from tc
> > commands alone whether their packets will be duplicated at each
> > stage or silently pass through when TTL is exhausted.
> >
>
> The patch is not using the ttl as a counter for netem, it's being
> treated as boolean (just like your patch is doing). We are only using
> this as a counter for the mirred loop use case.

This does not change this argument for a bit. It is still hidden
and users are still unable to figure it out (even before your patch).

Regards,
Cong
