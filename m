Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529F134A8;
	Thu,  8 May 2025 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746683708; cv=none; b=BrGEGfxDG+N5i2E8IBX7OuGgxTLz/M5sxMf8i+nOdZJJZNVNn8YllbWNNPNo6aVsDZSVX8etjlGyfPGsF8eJ3SPMcsFHYp8rPgTOoJpXUa2NXeOFCy0HHCuvbk/4s8rpbLAGE8dkw2l7eKGpnCrdIZfIrqjI0HrGJNyut0tVTjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746683708; c=relaxed/simple;
	bh=FroMuEvuWQqdD+CjGgjf2gJQ8yth2lP2n41i535w2ao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RLa3c4msdfzc45vod8p7yvktiRVyPcJdpQDMQmAshsb8kTR7JasP0Augm8FHf1s/LRA0obfdjtVCHKixarmSIvY/BY0XV4/WgwBpG61E7OtfALAVD0/1PFviZtJRa3hKfCmC9qP7z/bW2ELLaN8KjpBJSsHB4lOhFwmIZbAi6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJnZOslS; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJnZOslS"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-523ffbe0dbcso525543e0c.0;
        Wed, 07 May 2025 22:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746683703; x=1747288503; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FroMuEvuWQqdD+CjGgjf2gJQ8yth2lP2n41i535w2ao=;
        b=iJnZOslSLJTmVnp9H91JLPibwJ81Kt56p53t2opU+RcRe0hXQMU45+Bs0EGOAS/j3i
         uG6PIjiSpR+hz+sGDvhLE/aHvD6zKhMrHNjJ2ynj8eizgKqjIRAaCvRGjHevouCU3ENt
         SdVhccLcMqlgF1+xPuA7FU3V0LXWU3ToN3MFli14fhILbiPbunyI6NS47nQMqatsW9l5
         ejSqGYl6cUNTkIl6JNE62Ei4jic3ZL4o+Mw2chLvjAH4XIvdJSLpHnPX7GCAg4Z8VFku
         UOG9Pvlf9uejlusnlaUZdbYc010Dm7Re1qJLjwvqCJY7Oha9pNghk8HzAzArLXVAYP/s
         5enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746683703; x=1747288503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FroMuEvuWQqdD+CjGgjf2gJQ8yth2lP2n41i535w2ao=;
        b=PU/qulVl0p+gQ1Wcfr9grywCKHT0k/Ccyp5nEhxEZMEV3vXmlqE7Qcx9apcXLKYPGV
         UrNCbu4eacasfDpJ9rXSIfhnCsmSmGIIMKmpw3ekEx+UnaY6gsA1bOH4ExcJO8BTFkpc
         p1trdg0ZSS48I7HFmAzOPnZa6qLoPCFQC0RPLN25EqbJz68Mdd+g0Iwpb4ARLzKgBWv0
         +eNYoqTwTV9HXIo9rybdHWdTjO7F954Atk/v/KhS/pZ9g2Av1+uJiQGwfXLN7n4XuM1H
         E+l7qMGSuni6TDEWl1b/wXLaBSDi0YcxRope8w3r7geB3pugnFpUo7EIss3kUl6VsO/B
         wBeA==
X-Forwarded-Encrypted: i=1; AJvYcCWMaltcbixmiUcni/42WWGg9Rq53K5F1XdiSmD9tFLILpHeReaQZopU5bX83ncDOpSnUNzjnfIh8Pfkuds=@vger.kernel.org, AJvYcCXPECxS2X20+SWG98bXGQHsxjNTWzOC/1i/VWgI0mOpHqDjUKrfhMzrd7EYS7QeAAY7Bqdtd/yCqQwB0BRCx66B@vger.kernel.org
X-Gm-Message-State: AOJu0YyDG1rgjfroyMAb/xN8hqEmz11/53iVw/i0TBgzvAs9Hn2hUhOB
	ykv6bqSQbS0m/jW6wFOG8i8BdgK7ythQzw8J8920tCHIAQIXknQbbz1BRQWKC6l91Q9SEOnHsNQ
	kWCYnoQau7t78eYxBV4uQwV83C8Y=
X-Gm-Gg: ASbGncv7eCwpvT8ItcCxnDcXqanhOyrT7y2DgzsjDQ0CVpCn2/pPIOr2KW7gL5kvkF9
	v0QPG9DKiukf39gLXExCQ/aoJMhto+31rs9NT2//cdG6ZEq+44/slQ3UhinjSBoBxpijPd0gME/
	xns9NUoo9TyftDKiMvUvLD5w==
X-Google-Smtp-Source: AGHT+IGfdOHjKBzFgdRr8h94hpW/B2/iMKDulXZ3doHb5Mh1JoBDxlVqh+59/lKQyBpjzggBShVOvaq49fjvchNtlXU=
X-Received: by 2002:a05:6122:8d3:b0:528:bd71:8932 with SMTP id
 71dfb90a1353d-52c37ad91cbmr4537207e0c.11.1746683702978; Wed, 07 May 2025
 22:55:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430071140.GA29525@breakpoint.cc> <20250430072810.63169-1-vimal.agrawal@sophos.com>
 <20250430075711.GA30698@breakpoint.cc> <CALkUMdQ4LjMXTgz_OB+=9Gu13L8qKN++5v6kQtWH6x89-N4jbA@mail.gmail.com>
In-Reply-To: <CALkUMdQ4LjMXTgz_OB+=9Gu13L8qKN++5v6kQtWH6x89-N4jbA@mail.gmail.com>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Thu, 8 May 2025 11:24:51 +0530
X-Gm-Features: ATxdqUHQ6xnI-IrRcFLhTtdVsJRkUD539XVgNznU2C922J2c03HVFvUYJkmxBuA
Message-ID: <CALkUMdTPQcWsgM-x-J=T6DPcbM18qiLyZ1VdNfAxhcB_n9gWPQ@mail.gmail.com>
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
To: Florian Westphal <fw@strlen.de>
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org, 
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	anirudh.gupta@sophos.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Let me know if you have any comment/s on the patch.

Thanks,
Vimal

On Sat, May 3, 2025 at 7:57=E2=80=AFAM Vimal Agrawal <avimalin@gmail.com> w=
rote:
>
> Thanks Florian for the suggestions and comments.
>
> Hi Pablo, netfilter-devel,
> Could you also please review the patch and let me know if you have any co=
mment/s
>
> Thanks,
> Vimal
>
> On Wed, Apr 30, 2025 at 1:27=E2=80=AFPM Florian Westphal <fw@strlen.de> w=
rote:
> >
> > avimalin@gmail.com <avimalin@gmail.com> wrote:
> > > From: Vimal Agrawal <vimal.agrawal@sophos.com>
> > >
> > > Default initial gc scan interval of 60 secs is too long for system
> > > with low number of conntracks causing delay in conntrack deletion.
> > > It is affecting userspace which are replying on timely arrival of
> > > conntrack destroy event. So it is better that this is controlled
> > > through sysctl
> >
> > Acked-by: Florian Westphal <fw@strlen.de>
> >
