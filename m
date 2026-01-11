Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6606A1E1A3D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 21:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768168622; cv=none; b=GiLBSC7VdGQeOmIpp6vjcW+zw9ZJmY5d5tAzJsIyQ/Z/nJ6mpmFiS09bmAIoOpbNOD6fIGfbET5he8UesDFqim0lIPxAdfYH8aJMMzR4Hf/VbiErEijurPmMmvGRYzg90hJrlAJtZl6DxcHW0hixDcwu+KmGTW0FUjOyR63WnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768168622; c=relaxed/simple;
	bh=xFlWECxaoDZh26KeVqkC6WDEEOK3831sKkU5fLuGUS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZa4ef8LRu+UcIpN4b5HfDFrt7ZF7bl33idnRURxZsMsora3W4YpTQYrmSN+aoaujjjXK4uHIGHOdiCi5lsCtHV7IXSt7ygnA76cDUGKs3PUH2l7eKZiiYxqmQ2Mh14D1vuUD6b72UJ1G1lYd5sv4f7GWueJBDq+cGT57a9YUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=HwaQo05y; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="HwaQo05y"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c84ec3b6eso5551102a91.3
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 13:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768168621; x=1768773421; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O47s4215UWtpnw16+zm74FyVoUZmR1+LgwCphJTVcVo=;
        b=HwaQo05y261u5VQGvbb4Sj5c2EdslDVmv+UGOS30gOSaTvzJFb8yghWq93VilWmiuH
         UxjtJI55mrAXqIl8o7rM56bJ2TShffDynoN7/3DET/LpdpyEDudF/ynxV2j9YC9iidMv
         /0VF0UhlDEYULn2i7B/VjESgChsYlLSt0woXZ24X7ce/fMG5UUKTfeS4MgqErVV0rpfO
         Qho5E7Q/tDCKcYgMSNovJSC2yMA6mbSQ2Rr75uJV66GoXaizxoHujt1PRwEnLMkpGnHK
         SHe5rqdG1RxXa2gkjkMdO8x0s67XmRtbp9wn9bPATwn5ZNiw7fpnPDM+mt9n30jVzRms
         DHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768168621; x=1768773421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O47s4215UWtpnw16+zm74FyVoUZmR1+LgwCphJTVcVo=;
        b=TkaCUyBEJEA0CHkpcBjNzYKgdP8r39xFkftOzzLLEt88LFEa0H6T3WfpP8ATnisJNL
         mjDZ7qImscu+TA/5g5HZHkR62UlwMgALACTXak+pQb+Xs/2HL1P4phxFP7QHraDibrrw
         rMv7hJhE2HdcAVwiT82FuhGO8UpQSPuOXxopav3XF+CCnKk42OiBMZwjR8odINvEaoXN
         cf/KGLKRp/tHnubJzmg+07fqq1N8Ba9XUn0jkOlZnnLSUaOqUFudNxEtD8OpwJh2u4Aw
         KZ1B0cV1vbJ6A/Fna32pcQpxb68laR1iLvW/UBr8udeL4CO2qHLag4ibVNUHQAEUsWQB
         jrMw==
X-Forwarded-Encrypted: i=1; AJvYcCVS7FJloglAD4qSmHwt1pWQNTG18d+SsEx6YraM2l3wA7SLN52cyzFGwjViZTTx6UTbBl0uWoUjOpyij7GLvrw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5h3Sirvd8PQ88Hn0b+ArmhHe2BJcTaxZAMxitTy7069eNywf
	uDznOIIFHs74csXuAlxdEY4v7sZbI4YUUB2TFcQrWnwnElBgyB9qQRAUHUtfd9Q/5624bNH2Kiz
	dEyVK8sADDg744G4qr2SLVj9DOmmlXD9EnK748Xp5
X-Gm-Gg: AY/fxX7R9NaIw2GKYk31vrDJTaGYn9X1fZPnUfJOzRaQkNi+h4ikpLPQPqfhrwtlr7B
	n0GhKAVg1YpbmEx9F06iGb3iOJFEJq+EpggFg5lvApAs0qyRAmKA27NezdYyOizhK7xRqNfB+Y9
	8Yt/7zYt6RnMopmxGWHkQ1WKQj8HCu8mok0dXM8yAzEzdZkQgb/5aDNUeWe9AufvNa0HizclpHO
	tGs1B8aZEzepIKhbeW4r9NF5PeSTAUPKjGkil1CYGG3FqZ1cGzoVRPcLUIXDFm1z0fcQvyLaF+j
	tQ5twP5uUcDpBA==
X-Google-Smtp-Source: AGHT+IEy9t6bD7BrcaZMHhU56GXnz+UM8VXT2xgHbtTco0qAE+pRJDdH4z3zrllfCZtF/z+NYcth5hr/QUt9NNUgGbU=
X-Received: by 2002:a17:90b:540e:b0:343:5f43:933e with SMTP id
 98e67ed59e1d1-34f68cbe0b5mr14145356a91.19.1768168620712; Sun, 11 Jan 2026
 13:57:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260111163947.811248-6-jhs@mojatatu.com>
 <CAM_iQpVVJ=8dSj7pGo+68wG5zfMop_weUh_N9EX0kO5P11NQJw@mail.gmail.com>
In-Reply-To: <CAM_iQpVVJ=8dSj7pGo+68wG5zfMop_weUh_N9EX0kO5P11NQJw@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 11 Jan 2026 16:56:49 -0500
X-Gm-Features: AZwV_QjlT5Or4gJQl48Nxq5oe9d1hZ4KcOpAwnaklI5Wneq_ZH9aZCNwNx0WO4I
Message-ID: <CAM0EoMn7Mza5LqV5f6MMgacuELncbr1Ka6BOi7SA_2Fe3a7LCA@mail.gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: fix packet loop on netem when
 duplicate is on
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	netdev@vger.kernel.org, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	zyc199902@zohomail.cn, lrGerlinde@mailfence.com, jschung2@proton.me, 
	William Liu <will@willsroot.io>, Savino Dicanosa <savy@syst3mfailure.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 3:39=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> On Sun, Jan 11, 2026 at 8:40=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> > -               q->duplicate =3D 0;
> > +               skb2->ttl++; /* prevent duplicating a dup... */
> >                 rootq->enqueue(skb2, rootq, to_free);
> > -               q->duplicate =3D dupsave;
>
> As I already explained many times, the ROOT cause is enqueuing
> to the root qdisc, not anything else.
>
> We need to completely forget all the kernel knowledge and ask
> a very simple question here: is enqueuing to root qdisc a reasonable
> use? More importantly, could we really define it?
>
> I already provided my answer in my patch description, sorry for not
> keeping repeating it for at least the 3rd time.
>
> Therefore, I still don't think you fix the root cause here. The
> problematic behavior of enqueuing to root qdisc should be corrected,
> regardless of any kernel detail.
>

The root cause is a loop in the existing code, present since the
duplication feature was introduced into netem about 20 years ago. That
code enqueues to the root qdisc.

cheers,
jamal
