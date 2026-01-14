Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E8A3A0B39
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768408832; cv=none; b=KeuOVFxfNGXsEkKi3RLodKHpNvq8NylKTUwXQ/CHG2rm87aij2OjR6dvpOftJJ0clA3jNkezeYMfSKCa2fXzM67lHNPr+1zPNx4AkHoHgKoearD/z54Vb26Bz5eNxiF5rS3OTRx02NnOD64fD1R9Q1u3IJc+h6xFa95rtNdoEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768408832; c=relaxed/simple;
	bh=s/fD5xvGs2utvhqODnMb/L+upL6xmROHs/yMeG5HRGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJbRNHEWYqBLKQDI49KM12aoRNEBo1ZP5OidPH6Ki+PMCLfW6lU2BA6+rXu0B0/0MHCCm0CKgXrclrQ+euLLAPD1QM+p2pAFHm60i7ibFaW9nms44N7PxAZtNPJZuigMQ8S5vipftqLO0g09CmA1NlF+Bb4BtX74ycten1BagFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=TdlnJSQa; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="TdlnJSQa"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c2af7d09533so23847a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jan 2026 08:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768408830; x=1769013630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/fD5xvGs2utvhqODnMb/L+upL6xmROHs/yMeG5HRGg=;
        b=TdlnJSQaZjFuHx6q9SlZFnsROeRujZK98HANzkvdlfS79zBGXPBx3bOLt9U5kB/sos
         ssk0CRqHyYuVrk0xRwPO6I3F5vQ7nM8DqXhlZgboI8eylzJzS5EAhTptGwCFLJU3FiIH
         CuUuq5AAtsYaSBvAgeFePm70hpXIbOdkdahArAgt/m9sEOaEUUVnlAjGw5yu4e5/36nC
         vjvPz8qPIih9Sbg3W5oH08U58PPjmcM/THsDyWhwfoU+cu56h+o39tdgdZwtGee4CfE/
         VavPTIG2p08tSi3YLueVB9cpzTtv4Ll8wdL3cXWENJRGDlBJQTcwrf+qMzqD+8GtAQrO
         EUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768408830; x=1769013630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s/fD5xvGs2utvhqODnMb/L+upL6xmROHs/yMeG5HRGg=;
        b=c++4Eab2OMZ4A0iBFKDM6KY9CAzN6t409cDKQhHCUveMIo048v5UeH2wT9mcgyvu0F
         fIHF+kiGZxHqZqNQjXHW9ig8l2eCG+VigfTbZYlWOue6e418G0V5USKxaOXx1RAU4W3V
         w2nsU+CxupsLCpncPKtjESAk+g6vp+kYPU74cZUjGpfvFcGv3jNnIfsc1xfZ6zc6Fpxr
         PfPwo2SoboJ4HmcBlmUPIgzbdYN3TO7EXj8PrivsGOs6H8QJbGxs00aJtg966mvqtT93
         gdQeiUUDxr3Z9JAdCztK6juzIwN3smxRzeCBhR5TddP1xr6Ldttf25gqDO1o0/rW7yES
         MLNg==
X-Forwarded-Encrypted: i=1; AJvYcCUzF6E9MGKvm0zz7bp2tKIk4T60O7MWsigCFazqbPIsZIOlfwhgZ5KGB5a6Gcl3T98jkx2KtbcuwF73OQvf9wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN8RauQwA0W/nT9FtSxNZGrAzQyFTAYwc0krgnsumeqmzStTix
	AG4t+238Tj/TvX7D+kpSzqq6u/4g7m5XIH75151KVoIzodNNi17ovlCU9gZZNaG3X0bPExWJaJ2
	LdsBrBzL2boIBgasGJjd60rfTfIeQuI6ShuSeOx65SuBKNDQ7QUM=
X-Gm-Gg: AY/fxX7GQN/NJx8zqfrcK36sSX4S5hqhVaNOIK9ddDthOCvdDMBfNBqTprb4ayuL/c1
	oTKG8oULKcK9HbgMljGyDYYWedhy1ng0gT0deTEdNfMbzSOco6YExj1oJVgxdns/EfFj+sHBwvB
	lNtGW3xCpu6TRTMY0JQ/ZXyL3bPaWtc674CckKL8xn0VUitPYO2mmbUB9E4T/c9NBftqEfWBmoW
	fWdSajcD/JCe55MbDIM0KQE2uwDQvibSTsreJt+As9nvK+VU/h5pAFJPQ3tTFXBwhjMqLtkjhHW
	Z6A=
X-Received: by 2002:a05:6a20:e290:b0:38b:de3d:d52c with SMTP id
 adf61e73a8af0-38befa93994mr2928287637.3.1768408830348; Wed, 14 Jan 2026
 08:40:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260111163947.811248-1-jhs@mojatatu.com> <20260113180720.08bbf8e1@kernel.org>
In-Reply-To: <20260113180720.08bbf8e1@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 14 Jan 2026 11:40:18 -0500
X-Gm-Features: AZwV_QhQpZ25u2X2LNZn5BpYx8rrhPXxGdKMryc_JQfQo8v_CapUiIOJGhkcc6c
Message-ID: <CAM0EoMmZA_1R8fJ=60z_dvABpW3-f0-5WhYzpn1B1uY9BA4x4A@mail.gmail.com>
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	horms@kernel.org, andrew+netdev@lunn.ch, netdev@vger.kernel.org, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, victor@mojatatu.com, 
	dcaratti@redhat.com, lariel@nvidia.com, daniel@iogearbox.net, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 9:07=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sun, 11 Jan 2026 11:39:41 -0500 Jamal Hadi Salim wrote:
> > We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we =
puti
> > together those bits. Patches #2 and patch #5 use these bits.
> > I added Fixes tags to patch #1 in case it is useful for backporting.
> > Patch #3 and #4 revert William's earlier netem commits. Patch #6 introd=
uces
> > tdc test cases.
>
> TC is not the only way one can loop packets in the kernel forever.
> Are we now supposed to find and prevent them all?

These two are trivial to reproduce with simple configs. They consume
both CPU and memory resources.
I am not aware of other forever packet loops - but if you are we can
look into them.

cheers,
jamal
