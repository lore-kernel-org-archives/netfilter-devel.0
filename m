Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECFE2EDD40
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791508192; cv=pass; b=lXvZwxEc5D8yp+AA1gLS2qvA1hyf38usFwGurktZ9xTHsGTKZ+1z/08qIvaqZCbIsvj2McWYgCkhCuustv9zmNQVSuOtl+4LQBDG0FemrBtr1nlgjqs67qOKgpF6JBsn2geVx7yWGYbqqFBH2PHcfshuiHSEm+UpUL6Xh55KVjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791508192; c=relaxed/simple;
	bh=zfbHOYPpmgOxH/7SdLKAnBHBmgz7/uJSAeYRBHo1Y9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cVJ5mdPh278pF9FXo4pwnDzyAGaL5yLmWtCkwgR+4a8VbFhqNZ+u0oWLwWNdcS5KPlRouSD78l3axKJT3+u2JE6uL483GcB5C/kvGtpl0Um7t5e9t1kFXe8FN/AxKO3dg84BOHF4GiGfCKeuH+wDBwiYT6NpSFP322Yt4fQqjYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=VdtQHaAF; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="VdtQHaAF"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba35c0df4fso3775090e87.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 18:09:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791508189; cv=none;
        d=google.com; s=arc-20260327;
        b=dTocWJeDsdskoGwjQnaYyuMz+yko7A+vrg33QzNfp2YzcwhTSNqRI86Dq6hfcDjb7E
         7GWA0ljNVtGmCfOOFevSj+PNyFPKWyir1C6LNg/oBSScT16GAA4+wsn4TD9ilYw1ZDLh
         gAAqCby5xbQPs8MKQPpeXN6XbP7yqGiVaC5ZYTgwnkLTTL9wvb0mDq1vOU+5qUSGhPCN
         szKoGbDd8GDqy5KpBS5Shyzac5OFOypc8jS3vMSy0hMSPt3g17TjbNEea++svHVZatQW
         FCfRDRnm3ATGmWxihD4uaDT9sRxB5aYm4scuAmgEQRM5drqtpbI3/OHEfiv6ghp69vcW
         zAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zfbHOYPpmgOxH/7SdLKAnBHBmgz7/uJSAeYRBHo1Y9E=;
        fh=19cYm9SyLzgb113vp9HLGOm0hPGMKVb24x36031LKQM=;
        b=UKsGjHY6/8g1Gsp7+LdnS8xMpARnHVUKs78VNS7aNeAGAoDDCM9ALK3juJaVoXQ7k/
         mJ1NnInAjmvDROXp/Xcoglt/t/K3qYGBYkgjIL+97LQ/KYZ8TB0/NGKoouUZmtP9IHyj
         nePVVpsndWLMLy+WrJccyrJZLEGl7ocKtuqe+zLPy3DoPQVBqifRY4VrmZiVDrEkrGif
         3naYVO7AH4EnVTEFYZGg4x4KdzG4fW1LfgdIx6zoPR9RnhvPIOqyB6wU6PcIvE2k7Hmr
         nERO4Ok9KrdnOVc9OKhsP2hyWii23KIQtXi1e3Y3IcIv3sAVJAdKyy7w0lAvNdZjSqEw
         gbJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791508189; x=1792112989; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zfbHOYPpmgOxH/7SdLKAnBHBmgz7/uJSAeYRBHo1Y9E=;
        b=VdtQHaAFWbaCLcI2lBQ4zcGk+rEru0nEXCPViade1MCjKs1JlyRoiwDs4yL/yRhb8D
         MVgwsLy6jyApwoLCCO6OvQbLtqtQVmqzOQ/M+7Z9o0q1/9Z5JwHDKA1QSaF4DNEp2uJ3
         4YtUIlwE5IoKsMtbkv5o0ZO0MmNeS7r2bv92bKmpMzUXmRX+OhQbjjY13AenyygB/lzI
         HiYAYRItyeyLN98Lw1/zcikdRhKoS/Qj43j3LUdhzWowkgxWhenCfWxsLJTNLq+pGBYi
         lXshJJtXM5GeSar2fjurnFJY14NVoevclALHeYaul05Os0Nm43KoC3skubw0icfp+npF
         Iw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791508189; x=1792112989;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zfbHOYPpmgOxH/7SdLKAnBHBmgz7/uJSAeYRBHo1Y9E=;
        b=vnZKw5rQdmYi+bmwzmSDsgNk72Ioa1ocvvDld3WUdnhEglt53JhcXY1U/845wSyYUe
         yVFH9Q7HLRgBFIWvAr1kv7Q6jtTmsTlaWJU0RMVBzddkNXaZ7Se/lHI6E2x7LFKPPyut
         VrtqvpuhzpjldwAIWlwdbA3qSLVb8TpQGLWR+5m1SZQcRgvInmcXTQbyZIEEtkBJeSQi
         41LMCgExJVW0tiHJuYBPga6q4fJ2yp8c4GRxa21hlab5FpVRmtyMNxFYFJ5xDnkGp7AF
         ZzI+L9RRG8gA85dVCaPLJrhyI51aOVmdCu6mhLGFCFdqlIaOF7MUOC2UBM47D0CW5mjY
         4BYQ==
X-Forwarded-Encrypted: i=1; AKwUvByzKyebdJedqYupqp6pzpRJOND3cEDpHkcitfugBsVLj5jFaZFXv8qd4jBMd+dvdNLzQ0Bs3HxNDiQpaq4gClY=@vger.kernel.org
X-Gm-Message-State: AFq9FYLyM9Vo23z8FReMXl62fSvAdppkjh+L2AvLPz5gOy6dC0f+YXBa
	mGfbBkIyRXKsdrQdYb9bPSXVzL6QTdiGGsVx0TlMI3MtjoM+MObuHqdsQi6BNEzp6nGV7MSZYH9
	RLnHMdspX0oGsgNswBay9eMqvxAKXiNyvLjZEcquaJroelKOlhLAEkWWOUDWOWab4
X-Gm-Gg: AYBFou1E+J5hNo3HOExtea8UG7ePRVGoP7PLdEav17mzrqhomWbs6fP1Vp1vtB8g54h
	PCSlA2ACpzVOnCb7EraANpVDBpI6fXYssbdJyLrUmzYg/blqU/rT9V9mik8KBQ7ZOw2oSzteHWt
	douNedf3cadse1B61qI/th3+b8WMIt28UYqqG77S4OrrB3fO8NT218t1JlkfRvbgxTVBHeiIjnf
	zHRcqsYqzXueZ5zDLXqc0X6A2gsLjPJiiOb4l7osoUHUEoxlGiTaiE+z7bHOAKdjLPW09fdyUWc
	Q5PTRpHWGaxKqu5frUfi5BqSYkv7vW0VZnl7H2+kxvb5G+HTFWzZ/97lxwFHNtEcYH6LkoG6Gtn
	cBCnp8lNgMw==
X-Received: by 2002:a05:6512:3b24:b0:5bb:7829:741c with SMTP id
 2adb3069b0e04-5bcde35ea87mr133020e87.1.1791508188824; Thu, 08 Oct 2026
 18:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789885804.git.zihanx@nebusec.ai> <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>
 <asgtQ3E2LVWqfV8D@chamomile> <asgwR9LsGCEMolQX@strlen.de> <asgx_COtYd1PifN2@chamomile>
In-Reply-To: <asgx_COtYd1PifN2@chamomile>
From: zihan xi <zihanx@nebusec.ai>
Date: Fri, 9 Oct 2026 09:09:37 +0800
X-Gm-Features: AclHuK_SUmv4p6WRojnrW3e-mI4nWpBMifWbKSG3UER4l70SEe-UheyaXxZXzZc
Message-ID: <CAANe3eSnAF6wRVqopQkgtQLv2Kat2sGT0Fc6vGkCFk8cCovbuA@mail.gmail.com>
Subject: Re: [PATCH nf v3 1/1] netfilter: x_tables: avoid holding mutex over
 faultable user copies
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	phil@nwl.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 8:14=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> On Fri, Oct 09, 2026 at 02:07:35AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > The ebtables GET paths use a separate ebt_mutex and are outside thi=
s
> > > > IPv4/IPv6/ARP series.
> > >
> > > I keep spinning on this, and I am not sure this fix is the right thin=
g
> > > to do. There is no single caller of this pagefault_disable/enable() m=
m
> > > subsystem function in the net folder.
> >
> > See:
> >
> > https://lore.kernel.org/all/CAL4Wiir+CBGE=3DhXxHEBkyk0Au9B6G3=3DAdHFd5b=
otrC-FF5BM5w@mail.gmail.com/raw
> >
> > Quote:
> > | We have many places where copy_{from,to}_user() runs while a mutex or
> > | a socket lock is held, and some of these locks are global.
>
> Indeed.
>
> > So I would not spend too much time on this, especially not for the
> > xtables get/setsockopt APIs.
>
> OK, I'll drop this patch in patchwork then.
>
> Thanks Florian.

Thanks Florian and Pablo for the discussion.

Understood. I'll drop this series and won't this approach further.

Best regards,
Zihan
