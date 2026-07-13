Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7D13382C9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783978437; cv=pass; b=gMYtCgMkohxMZK3oSDm4kBzCgNUZLG85h1WtDhYTIvTQC4+/Rl3iBpUviyWGEuiwXvNK/7HvyWr6+p/WlK701OG7Q9b7+klJVMtXkOY4KSlLs5Tpct/jl+IugvUS0IGcwA2+4WA8AqJcVr5F6fcX6G9pz93lNhbtRLrccKI4fdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783978437; c=relaxed/simple;
	bh=ar9W89D4Ih0LFa4BPdqkCf8t2Kg9okLoqOOiffiJC1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MhYME8kl8TOugbgUZVnW4l4nAPeqnQWtqyWRi9VztNwfNnCHFvWFIb2DMlbVZexSxVg5taSR8P3k7uGiO8nLXdC3Zc+SLmeLjWFfK2gOWRrUotQfNjDGiQctf4wKznGIFV5fcn5wXCwwxBMlkXDj2KiWjC1Fv7y+THRGBBD5Ij4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=ILr8ar2C; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="ILr8ar2C"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so3461636a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 14:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783978435; cv=none;
        d=google.com; s=arc-20260327;
        b=WOhrayaN2GpMVoCzVoM2pyn0w6qlRblAG3l0RbNvVMfzVPpuoH7M+rG248h6DoRzxX
         Uw8A1YbtmC48Maa+SWroEhRHtgxMeMqoZxEE1DK7OX6XZozQS3uEMB7VkZpUwYlslKhg
         /ZSt3dkmduQWDbreZz+wB3zgZK+bhzG1S8WLuFQi/tyozBvo7ZjXvyqj0GY+yRSvBmcy
         NlWDGPM8KeoXeIKzCevGmXuIxh0hXg2jszm8mhaCrCC8QHvIKwL2BlbQGd6YmIrvBXvu
         bdtPuAEZSlatGTDqdRVcqh5Rpu2/z8O5WvSI4zF9Cambv5QABoEcZWOzDEsf0Hl6H3xX
         QXUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Iezwh3ME7S217GUTr7unthJmQNFJnH6e1rXTj1TNmsQ=;
        fh=VzhjG7KDpOg/3PgP12wPh1aNOYYduiIg5Qmru4Bbx7c=;
        b=JhLWDBVoZW8C7DrW4QQ0pnL/zAHKejlaepHRC2IKElEDnKwJ4hKn9kRzMCQhPefAzW
         QNKiCyoV/s6CqzKo/RN8v/atEvVpznPnpIaXgdEe8oC64txoCWHw+5hvHSyBLBWhVIuK
         id2hmLn4izIC6V6H+y9RQjRGa3kwGxpV+7DgmeOhTfcd5MJNyM5ipwfjhZkxTIvC1j32
         rl7PApZwZUccRJDQBZwJf4oH9dm/q5xebfGkF/HpDl6ojezz5clTrPZlhz2yG0aNxBkt
         ovnNEfDAqJ56mQ4ExfUH2uOvZA7ybwfp0WI3XSfEwAt+rKlt1SsaB7F+9cRefjYGSudR
         SMhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783978435; x=1784583235; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Iezwh3ME7S217GUTr7unthJmQNFJnH6e1rXTj1TNmsQ=;
        b=ILr8ar2CP6p3UrUSfiW9KBumpyCKw03jE9qq7xaWiv1DA8lFDTSLcPGuw1tN9SLFqu
         HQsVzVn5atjaBRzdZgE4+EfmHkBHR4xXspgxLv/v7lYrwMSLKmN1Y3uxsTy8BxCe07Ug
         IJfPdwnIjWzPqW0HhM/DGVkvcX7rwIHZPa7F5GxVQztDUdR8wmPOm+ht5uTVS3JxYz5q
         n57Tq0QVwsysNjXghgVNOpCleOUcv58ZpUqI0nbm7rZNfbaoZRVt/mRwHYePFdBZIYwM
         9Cq7VolP5kzZ5SZ4+ADokR9YSw2sslURcQufY90/kcvgWPbPn9h1loR9sms4uMudSGX1
         b+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783978435; x=1784583235;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iezwh3ME7S217GUTr7unthJmQNFJnH6e1rXTj1TNmsQ=;
        b=fZWvVM2Tx5bS521t0nl0SdhhR30IiEGmyR0Nr/LqN1wtcCgbvi1EVGrfJUSU8SeS08
         ZTMhpa1/S1m8wusk3BrBa2gjGj5Uo06i8kQOX5YNK2w5xTLi8MUC2MOLXQregbf7MA5v
         FvjICXoKoZo9DjyKhdi1amRF5uPTGDmZ5RMn8dqGkl2EKBpNbmYSqh5WzLgOnTzcFJL7
         9iJVBgR+ij22DJpHxcBz7uhwiCkPh2f2pF1DUDhB2mwltTW9A6Se0jKcpnchbHlIkrnS
         5AYk//j1aKd54MdFuck0uePls3eOaptkWlxA9Wi+NfEsXW0bDWvmHWHL/bZtO8wKiXCM
         dGkg==
X-Forwarded-Encrypted: i=1; AHgh+RoAIR8gTsiukJ5uy5qfuBVesyC4QFYrxPJ4dP6Mo93rNQYJRXTAGGdaHwTM3KdKcbyDdYWQJn0Kt8NobFzJZp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YypIoI9TXXuA+iijxL7JhZNK/lwTyLetkLrFUUqtaFNgM1rgQdB
	bMVW65UA5L3wvrsCDMYO3dmmt73C9t+0w1oePZ4QzVefkpIkBjD9QCbX9qj8leSgGqUAFGSYjAo
	gx43+9UGwJXDghz+vcLpN1B4Q2csglBggN6n8bQlg
X-Gm-Gg: AfdE7cm+V5BbiJROp7nDi52OSU9llfJ3DtBqTclaa471Sk3gQktMUz2dUVwyvDKQi9/
	XZ3ZwQccUsVrF16Lebkq1DizpzYpzmhEuBIIx66gg70WYIWbCIY2bL03zuZuXUb/m2z0Zvjm0pX
	g4ZxA4PDVj7RV12LJgYkdtVD9lUbxNJhu/70ob86vBnplQLn0i9no0/1BYQzrkeFuddm0SW7Ad1
	QtJlnNT/xwuYTwRYhagl4f37iSKxVTHnVmYJuxVkcBBThVJa+D3ZuG9LzAKs26odlbH8NZy0VAv
	UYRMjFBqnSscWEqM9kDslnWC4ntpI0H5b3v+HlBkBcW1dhJb
X-Received: by 2002:a17:90b:5112:b0:381:6c5:3f63 with SMTP id
 98e67ed59e1d1-38e17d96405mr594631a91.6.1783978435335; Mon, 13 Jul 2026
 14:33:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713183614.2975972-1-xmei5@asu.edu> <alVUka8INN918W0K@chamomile>
In-Reply-To: <alVUka8INN918W0K@chamomile>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 13 Jul 2026 14:33:44 -0700
X-Gm-Features: AVVi8CfWIx0IdHw9ndeEiFA6ywDR0d_SyV2cDqSjXU8pv4s3O00HljjD2IZSQ4c
Message-ID: <CAPpSM+S6+Wu+FJn=Pob4rmOKOGUggUdKHB+pJxfueGxNv5KnoQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_fib: bail out if input device is missing
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com, 
	kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 2:11=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,
>
> On Mon, Jul 13, 2026 at 06:36:14PM +0000, Xiang Mei (Microsoft) wrote:
> > nft_fib_can_skip() dereferences the input device (indev->ifindex, and
> > in->flags via nft_fib_is_loopback()) without a NULL check, assuming the
> > hook switch only admits PRE_ROUTING/INGRESS/LOCAL_IN. But NF_NETDEV_EGR=
ESS
> > =3D=3D NF_INET_LOCAL_IN =3D=3D 1, so a netdev-family base chain on the =
egress hook
> > passes both the switch and nft_fib_validate() (which also keys only on =
the
> > hook number). Egress packets have no input device, so nft_fib_can_skip(=
)
> > dereferences NULL.
>
> By reading your description, does your kernel include this patch?
>
Thanks for pointing this out. I just rechecked my verification script
and found a bug that failed to pull the latest version of nf.
(I wrongly assumed it succeeded and checked on a code-based one month older=
).

Sorry for the false alarm. Nvm about this email; I fixed the issue,
and it won't happen again.

Xiang

> commit d07955dd34ecae17d35d8c7d0a273a3fba653a8c
> Author: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
> Date:   Mon Jun 29 12:53:11 2026 +0200
>
>     netfilter: nft_fib: reject fib expression on the netdev egress hook
>
