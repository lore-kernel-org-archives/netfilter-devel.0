Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794207198;
	b=RKeJl8o0LziM11evQANZ7z2RzVR1+O11Jy55wsqCzvN5C5mzyrMHcwrnnaeWA1bLUr4t
	 Y+pkmxK8NH/NKN0aTjC99o+SWsZQRjqK1LaEzPgwMdLFNE39GGiIW26GdlgyaFoNvEAJm
	 Aa7c614xH4LTcrizFeJIY7HwP5LzmqkFYBcsz7Ez1eGx3vRGtxF9VTZqfcT4B5BiEWiXA
	 FKBXMpZgKQ9GiZyuAImau6EX9AEDCyOJraNURjpL3RIDxBNvLkti2j3ZfBxJuaoSK8UvC
	 DZqw53m3F7RMjNwmxLVf5Vx16dasUl1TDiLrwzJVPVp+j4YPdvJI4ptkBIjHI/ovM7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
	b=Dp5I71fM6O0m8lafMVfc9McXAJ0NB+LfxfNjuh9egeiYNXcuWmv+wGD6iMeLZ5y36mR4
	 PSMcC6s55O+3yfns4mSysr7LI+frBVqZTzQDm1pjjaF/HuZvN+jB/V+z6pzYZ/ULs+m9l
	 rrwZBS3eHbi4R8ePeJ4m9oFw5uhfZZ3Hrirfl0a/dWVibxjyTaWb2VZiq7pEYnJlxGmMv
	 Txk2yaS8ebJc37tw9xao7sg0/HuLuPVdzw0phDQTETfxUEKA3QZLB7x3qYuxYnOKjGaWD
	 61SgZG1152Tmv2vtcB/dYW0tb6ZVLvIg0nPUAa9pP+TlueVLdrXXNri3e04bx7rDDpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C1606A332
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 06:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C8C1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c0a520df2eso354282e87.0
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2026 22:53:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794207196; cv=none;
        d=google.com; s=arc-20260327;
        b=bSggqVeREe5UHxvMsFQ1dhyfQioc3nhItdsfssQ82ywrxOxZkYaQq2HbRnVQpKlvCN
         uhHpUnax7QOB7H8kqNEAqw8/Dea0zmF9gYMJ1Q14nH/MRQJ7ZBbaDSpS+/X69+f7oi9E
         febeMUJ3MWazFH+fBHgl+KUpLcCkCuWxAI1AOQiHI9+rGVVq/j+HVmBqHdJQPPAT840U
         WL7WG9vrzYJ47Pc1WzALn8bx59UTcMCUMQ9VngEzMLvcqocj8wclyvA6RVOJhJUQF/6z
         IjX//aK8W3ORD21YXF8bGxNW05TRpo6rIPIcAfeVNjpMJZnC3bMpjKNzCzZtzyaIsWw5
         5j7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        fh=/NeSHJW4n0NLH7Q5OsLDvEgndUj1Rxr2X4Z+i6p4Xi8=;
        b=PR0HJtsixNszb6W71YYXl6Q8vA7Vxlv7sGO/FTDQiLoGS/ikMHqvEVY+t8O5R91tCy
         oRyiDiE7GswhjgJebtKVNNsmzZo+efS+Qjssy6sKai0tR202WBlFvcs6mI6pOL3OwBqf
         0PY8nsDLzybgcPF2nrYv8C0peyi6oF5Va90fb6vschDemnuYlgpjqvC+CETbZYJsg0Gu
         LfCSptLsOQVjHYvSHybz2SmRFQFVSxrovrQ0D5WloxkzFB0RrWShx7DNfNnLKNcnfZtO
         A1Tfhvnj07qz3dzgWakDEvxsBdVwNsV3vdS0a3jYN0OjVperI1qEMlolqZFwOW4smWVF
         yhhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794207196; x=1794811996; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=sgWujCEBcLnI2rCZx2+HrV0hdHuKHGWZkbP/T95hfWdHOsdro1qJU1Fvk+8OO9MdfB
         0BqsBZTh492PGUlz+uiD5cFVvZc+vlVmSZhYzi+w/tlD80Sl6tEzuWFCWZhv/N6pbH35
         rLWt1UHkkGkHK24Z/h6vBhtLRJVzr1jbqDl3LlT+eJtmAmj2BiR6ABZnJcxKkIEwjeuj
         rKb8qVeksOei/N1ZYTOxCXuIYcRzPS0XXno11fSFmwYvkRxmBZ3+yYmHEczZNKiPx5RZ
         oHt9g8LUVuNFkbZtPXFWBtwsCaMo3xAJFO6XAxUED9WmEkoDJbCWdP6YC+ZT/ijPGBxT
         E53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794207196; x=1794811996;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=RmJBcW4MkjO7Od2Q3PBytjgoVOa3Yc7Q2yNJEnONBUjUyAEvvNkdLyD4amkT4hwj2H
         FPaUrE3/rqyV3imH33ZG8Yjfu+SayjJGcXaWGkcqL9fKPtILipjn0PCmtW0mi9LKjnzF
         3+jEDhtxhf6WL4pB9s2WKRtK6dRwb9x2zP2Tl8c5zftTz/Ynrs+8EZbRdm+d1v2HOrAX
         ob/qb/qOlUvgB/uIuB6mZee1PbdytLE1R+B+WvceXkNPKFDupk/EvPkVxdYCzqVlqtLN
         5PrW1rXLWeEqNtwGePOA84LQGpLFi/6PEc43EIPII0LaaczhUSAYw/LernOArUdjgB91
         iUuQ==
X-Forwarded-Encrypted: i=1; AL+hErECH+A+u+goYHG3RuvxFYjsmPMWpg7bG+SHY3hfJ1H7UqYBUdbmDNJCOKaL4qpR5MeAvwZImTSPiObbfSUGMEc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9FEBIKLNLPfVEOMPKVY9yM+s+Vadgxg9m/jXNVSoY0BHw5L8uH
	apUfEZ8GFuuHgCm1OOp4I1UWNTdEqpdKNrxCWYLMmyjoCMDifeU+NALsuyGZUKcwkm056+FQPmW
	kKwKqrFqWkwF7FmKGMSLXcCePk1V5wkZXcA==
X-Gm-Gg: AYBFou3W33tLwnvLjkHfGnWz0/vNOEdbFVyCG0AwJvuFQvmH+ATB2FOaqYxj2rSuf5m
	pECMs2m8rm70s2aRxTJClpvnsPMgT/iKTbWrvplt3SgLevPvfv9fp0JkIGVLudbQhGx/P16Sqv8
	3IYosu2jXDujWEzXqb61cpnoAmgLUYqaBNHOqPka/pHrt24z/3m1Ahs9zbT5WTEpLO+c6pYxHtv
	pPCwNQTC0fT/nsHiJrk+Q+qtV0c6MqWHtXO55/Dct7Fz+T9oIPyUSnPRV5xoL+dmBjOXPI/3cRa
	7faTaJ7QrH8zP8r81aVFeQeMQ1+t8aGFKMNRvNXLn358BnzYdOUIetFsuJslW4xiZXaDSeViZmC
	eVcGpifEywcHG1Tw6DUXIctwKVbH8Qn5GIh4ajQacjHqHrFsKD0054BJyDvlnFxxIXQttZUvbv3
	EhFbsNyBYtdoG9uqoWybpzHcvW5fLL3ugYvNNK90PBsxWtJth+FUw=
X-Received: by 2002:a05:6512:3e1c:b0:5c1:4a48:c2db with SMTP id
 2adb3069b0e04-5c14c01f805mr810751e87.43.1794207196170; Sun, 08 Nov 2026
 22:53:16 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com> <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
In-Reply-To: <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 9 Nov 2026 14:52:37 +0800
X-Gm-Features: AclHuK9hO_h4FFhel_M7AacjBweA615sygy6vgIfEMNG5ukVHhzyCYoysXzMOxw
Message-ID: <CAL+tcoA6_gROiprd7YgxvwbaiuzEUPfuWTNMjKu6vDkbUJ5KPw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/14] net: annotate data-races around sysctl knobs
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, Paul Moore <paul@paul-moore.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Julian Anastasov <ja@ssi.bg>, Allison Henderson <achender@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev, 
	linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, 
	lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 11:33=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 11/9/26 11:11 AM, Jason Xing wrote:
> > On Mon, Nov 9, 2026 at 10:55=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linu=
x.dev> wrote:
> >> While testing the recent sysctl range fixes I noticed that a lot of ou=
r
> >> sysctl knobs are read with plain loads while the handlers update them
> >> with WRITE_ONCE() and no lock, so KCSAN reports them as data races. I
> >> then used an LLM to go through every ctl_table under net/ and list the
> >> readers that were left behind. This series annotates them with
> >> READ_ONCE(), and adds WRITE_ONCE() to a few custom handlers and netlin=
k
> >> paths that store to the same fields with plain writes. Most of it is a
> >> plain READ_ONCE() at each read; where a function reads the same knob
> >> twice to make one decision, it now reads it once into a local, so the
> >> comparison and the value it acts on cannot come from two different
> >> writes.
> >>
> >> There are no Fixes tags. Done one knob per patch this would be well ov=
er
> >> a hundred commits, so I grouped them by subsystem and feature instead =
to
> >> keep the review manageable. If maintainers prefer, I can split it up
> >> further with a Fixes tag on each one, as several smaller series.
> > Over the last year, I've been thinking about the annotation stuff
> > especially around sysctls, which, I suppose, shouldn't actually affect
> > the real workload but does affect the outcome of the syzbot.
> >
> > Out of sheer curiosity, my question would be what is the point of
> > trying to change all of them? Or what kind of benefits can we get from
> > the big series?
>
>
> Three things:
>
> 1. A plain load may be emitted twice by the compiler. ip_error() compares
> peer->rate_tokens against ip_rt_error_cost and then subtracts it again;
> if the sysctl changes in between, the u32 wraps. A few readers have that
> shape and now read the knob once into a local.
>
> 2. Tearing is not involved here, all the fields are at most word sized.
>
> 3. The rest is the memory model: a lockless read of a field written with
> WRITE_ONCE() is a data race unless it is marked
> (tools/memory-model/Documentation/access-marking.txt). That is what KCSAN
> reports, and why most of the series is plain READ_ONCE().
>
>
> I think the benefit is doing it in one pass.
>
>

I was curious about the REAL impact. If this thing really matters, we
have a lot of work to do even not only in the networking subsystem.
Sorry, I still think none of those points are convincing enough, but
that doesn't mean I object to this series. Anyway, it's just my
2-cents.

Thanks,
Jason
