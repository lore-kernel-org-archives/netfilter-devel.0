Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD0928B7EA
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216574; cv=pass; b=YOvgj9J8xA6L1JrePkcNoFh2+4DaosfxPD5o/H0kd94TW0D4wtlD0Ed2Mvfze2ZmN1A3EEu7H4wXxp1ouqGBEt0uiyTHUXNj0krCpwnQJIC6d/9NtZPfQjCOw6+XhAc7Ojo+addrHB+LyG047phDvZWnIsgk6UT1LTqdyVqIpYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216574; c=relaxed/simple;
	bh=8nCEmx9pGZawXqW4rJLwzwVeu7OiTlh9QZywlzs2leo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iBP4eoX1WoB3iDhLgYYX76awN9Jkx2J12Hye6nvkfucNTsx2o9trzJSvnqUY+qOPWRwCz+LRoT1F6mRfjlVT1GmUgc/0KSg3qIFXIORQkTFEJJiXQNg2+ULwvixy5XfogMkw3FYZEmUAhWdCrxcD1EJzlgh9o1wVzE4MIaOpMbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IFXxzn0s; arc=pass smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFXxzn0s"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64938fce805so6285253d50.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 06:49:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770216573; cv=none;
        d=google.com; s=arc-20240605;
        b=fdBUqVwWAq0H8oEEVTPiippL9LTj2LVsXE4B7KEkOuQMxxNDeLnHXkASYL2w9t1Ugi
         Ah9UW1pUZJrqaFxHmnG+5ThjT68+wAuVkHA9qb1JIyt4bQoxVxjPQJU7ip+feCwmwFUq
         Vy7l4uzLmIKlJNWscYEfompXeXxD+akPvqViN7h/ju+dA0yHthPdI1r+bkc9DlucOyFI
         ccuPotrQ3GcMkv7DgssbcH6eEGQr7J2sjMOl9n3Zu6VFAGyWB1WnWtHnTBC2bQDBhOk4
         icawJy7GmsKJflXnRNuNIMtQyDhL3tQGuLLnbUEG9CWTKAVD48SB0wcrZ0Q7PoGBDNzf
         E8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rRQJ8kmIh95B7cAXr3f9hZfMeO1OlXge14Yx9BKK9U0=;
        fh=PfJeYeC5KrdQvxWpislNZQpR5VXR7jycuVaxzvz4TUk=;
        b=is7fa9LWUCpJD0OvZzxKxUNv+ZHzU7mcPz5xg9vs35SnJdgY1Fh8bRZKA3alrmCo1b
         ls3m/0AlTrTQIgfHTm68+e7KEVtWB0i8ckFNgre7YLwcz7ujPmVmqI2UEKdHORD08IgM
         kfkvgyAivdmsoKNSTJyPUnlByQqSBKo69ha+ZHDqLTd/gUKPgLMlLsf0aCgtOQNCMTBJ
         E6j7TAZ+lk6BQMkH/T4Ps7gISHMB9WKg78Q5ooM22XcGQ6E7h0DeoagtrtqUKLlzCdsN
         eXfrFbV/vWqJB0BUydLNnxA0xak3ZgKH1YwV8gJL6DtTUIfcqVhVh/Bxv5z9Onwlv2jl
         6AGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770216573; x=1770821373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRQJ8kmIh95B7cAXr3f9hZfMeO1OlXge14Yx9BKK9U0=;
        b=IFXxzn0siJr/IDQgx5bREyPAw3Jaip/uiLI0MSz76ckGiYhclMN5worsdl/jJJ9EhK
         IlJl6T6ZjcLHOlNcFBGqGVTAXFX645PCwsiXlljvxjpyNAI0j0TkgMroQsqZhs7DzlBB
         vzHzOrbBLAzR/9pYRIdoCHdblT6U5PYzXheK54410R9nN19vjUxlHEwPsGKCxm3homon
         NGkRZ2/fDImqpZPqtCBC6XVvKQQNj37dWk0vEZ66cc7xLcDXybfPz8lpdeECF9Pc5w+Y
         WQ4Z8g2uPI5ecvMwHsknjrLu0xdf4oNgW8mnqLAv7SXdtFndBXxEfazZHKlSzxKVuBo1
         a7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770216573; x=1770821373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rRQJ8kmIh95B7cAXr3f9hZfMeO1OlXge14Yx9BKK9U0=;
        b=nlj4IT+zb6XvWpVhNHIShMZ+aqOQdwtJtUjZ2qy+lSAKG3EztirFtGjVL4TBEk4R2v
         MJHoFg6GhUfRqZq7A49n1/gATxEgdU5baOBdVnVvJhdEvlzLd7TXFBpmyljAB9AR0pot
         OC2SDjq2pKbX/7nQeI1yaqLqgItR7QfpdKTdkSs+HI8p2vy0UCp9V4PVc9WbIpUqGEjU
         IsK0QEjhqszzqsP3egpSWudXhBM2bDYK23h82C988RkXDBBv1mojGyY+e3OVIkqJpTwF
         LC9/M2tFNkgR/+BIHwDaiCievGCzpFpUIjChV6C28N/+UbVq7ovV/CokJk/7xirfwgo3
         BCJA==
X-Forwarded-Encrypted: i=1; AJvYcCX7uPI5znPI2KKW8YtsXkZCF/JHeGdM5bjJWmqX+SifxvxWJXNxZvd/+BcK+8mHMMMN3x/XsMNB6RHK2NjRSeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvCc6/9dqf9k11cj0whg3rfm6Nk+Ye7XfY0USpO4lrQf+Q1744
	LF6ySq8Qom4VrmkzesRfaUWzqdM4r+257ln6PFjJhBUPbZnw0H9Fl1oK1zMUghTD3i06bz1+Ghz
	yaSPO7YpzteiLxZsB9vna8W5y3g6VFd9GXQLR03AGeg==
X-Gm-Gg: AZuq6aKEfvb7BbCxXe+fwkGjdHjAUw7lsEZapnNVrutS1noIDg21miZxex8/x6yHQC6
	IQCgOd+o7iF87RVvSvtdN5H92lyTgnXHY5gTBCmQkHRyMCl5OHjR/TfIWP4IKe9FyGbHsg5Fnci
	y8mnmQKgxsiaXXldnpq9n9BGWc30YGC/F2ADl4IcxEGMpw7QUcsLx3PmOgQzlTq1zi8EmmSDE/J
	8ZqM3S0Fnu53VBLX69g8eAZtYe6b4T7XvnhjskXi5lC+GkQvwMh8bv7UybBMimiDIWjsG02fm/Q
	Nwor
X-Received: by 2002:a05:690e:483:b0:649:da7e:9967 with SMTP id
 956f58d0204a3-649db332f32mr2176272d50.16.1770216572926; Wed, 04 Feb 2026
 06:49:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com> <aYIOXk55_DRFKCqo@strlen.de>
 <CABFUUZG9LnhXc+nsQA28WHiiT33_5wQ82E1bBSBncWkxkXaKZA@mail.gmail.com>
 <aYIpcHBufnxrcv5O@strlen.de> <CABFUUZELXbEKyjMxOBfoL246dmtBSS_oe0zeWwnkmrXXpyv3Yg@mail.gmail.com>
 <CABFUUZFgXooeCgKGypByzePBsHpcPWqnY-Ea0qv4Vd7=yMOk+A@mail.gmail.com> <aYM6Wr7D4-7VvbX6@strlen.de>
In-Reply-To: <aYM6Wr7D4-7VvbX6@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Wed, 4 Feb 2026 22:49:20 +0800
X-Gm-Features: AZwV_Qgma9lT1f5fzgI2lPJjnVCSuuPAdp_7-Dop1oaLa1xobYf7wXabtSJ7WJE
Message-ID: <CABFUUZG2uPmCo=wiPe-p0YmhjwEpubmVOHUd6wJ3QtArh=pOJA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 8:24=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> sun jian <sun.jian.kdev@gmail.com> wrote:
> > To keep the code concise while stripping the RCU attribute, I'll use
> > the typeof(*hook) * pattern
>
> No, please leave this alone, the code is fine as-is, all sparse warnings
> are due to missing annotations only.
Ack. You are right: I've double-checked  my environment and confirmed
that adding the __rcu is sufficient to resolve those warnings.

I will just annotate them and leave other code as-is. V4 is on the way.

Regards,
sun jian
