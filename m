Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C669253B60
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 20:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742935707; cv=none; b=fZSgDg7nnsMiv+60QfEGRbWVJQr5nRjL2jwJSYFv0FpmqyZnDWyPMP2T8BkjRX1y73wfV0UmU9VOh7pRK/zK+KDi9K7kN9w0MWJzYzc/ZlaLtGfMs3gXsYluNHg/02up8A4inTD1ouBQg7hb9hGvN5J8wiiKaAtsVI6CkisEEHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742935707; c=relaxed/simple;
	bh=GCAhGVtueceq1ubCUXU7aIifbCxnCpAKEuI8oUAtt/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDZRgDTaevk6YGDDK7/YpdyT09ZQzVqmd97GApNxLxnEC8URlaWrUoJqbcUK/rCT2GmUHCV96yNrM7QKnOmdtS7BmyDlKac5r1Ub13/MR4xf42YIlAi0g4bBPxGCd6EMwxhpWx2/kdxy2Cs5KsztHasaDtFRhKn8Y0nTxAS5nBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MIF3IKEA; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MIF3IKEA"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30bfb6ab47cso58934301fa.3
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 13:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1742935703; x=1743540503; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=MIF3IKEA4wpIXgxiiy1U1tKZtzDEXxOA7rv0DPvOjQsz6HhmXK8CaaHpLqUwvVWMmH
         MWbso0MNnMrppECKeRUHSQ19fPeNaslrCHkW2oqHPkM6qJN9/R9CC7wr/6GY1zmul5Zi
         ZtnyKze9FSvEJ4VdWBE+k5KoINUl9na09Zje8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742935703; x=1743540503;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=ghmhGlqgE7/r/HhEmcbOd5hfcc15iFD5Up5065sZPlGPSyTyKXseHYTEHwAg6DUmsL
         I2ycz4ArBfty9k2g6zL9TNaJ6d7ZZWB611bQELPLrfIbMtMYi8RJjPcFgZzxJCBP4E7v
         rBdW6BW9KEkbae0Lxc2Qg1G/6pj0q3hVz3jxccgTyLUV2f3ekrNabGzCJZlIfNBd3YZi
         +85F50DTkTjZwz8vm4/iGKAA9idfrx51k6sTKEWVaB1LUL7K21MkRascyS3/Nj3rCl8Z
         qC6XljtlJVUrz4drW3vpXkWDBcTccEboI0gImONNJPxC6JGCC9IawgGGR0EFA1tdmc/Z
         xj+w==
X-Forwarded-Encrypted: i=1; AJvYcCVhiyT5BUGx49GXKf035YqSca4/eBbIs+96WG4YlqCdFqjF42xlI/P51XjGnnJNksD8pBOSQirfAdSLO9Q913U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyewQolsuvfrPTLXFx8eiclINPj5JO5jloaMR4foypZSI8L5FCz
	XjIrL4SWUvzR81TDkz9r/Da/QscXZJMDp9vXFT1/jdZk2NRQ+ugYbg3Ns2FCzKcRNILLovaFjdq
	EPA8FSg==
X-Gm-Gg: ASbGnctr1QsW0ThVoOjYnpjFVOJtfttQ2pmzYw52YL6rqUZzKIsyqyHqMxkQ8E45urw
	Pq1q1JNenw5ZZ5ldretXx68O2tv+/Khk6a87VtBQQ8nbv+b77FANoqO1V08Sw2Xt34JvddROG4+
	NrE+UFsVV6bp7IDoBJ8jM1tieIa/ohIiO8uttPT3DSLZhE/k0UifnbmMeH5Q78pqZ/qBOiCb/Tj
	tVpCuR4rVN5PCxnh6eq40F8AL2rJqCj5pvrRv6k2ShOt0ie868L8YFBC1ZQwiR7AtEs6O4KJFSN
	RqvclmKZ7Fsm/4fLmKCLqpuJTW2O+HhW668rlE1rnBcTjRLwUuFD9RL/0FJBub8FBsG3zq8iydR
	vEk6HCQTAEIZRw1SpRRQ=
X-Google-Smtp-Source: AGHT+IFoghVgJX5zn5DQUb5BxJ3V0TChxJxuNWT0A0Ucraq4hOofmbcIN6kA8WWxC3fpKIHEy94tTQ==
X-Received: by 2002:a05:651c:b0f:b0:308:f580:729e with SMTP id 38308e7fff4ca-30d7e2ba2fbmr64680201fa.27.1742935702889;
        Tue, 25 Mar 2025 13:48:22 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30d7d800b1asm19355831fa.60.2025.03.25.13.48.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 13:48:21 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54996d30bfbso5658678e87.2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 13:48:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU7bzIMDmcJ8crQToBlbG2IuL1qwAr27Msa+HJ26kxlWSpwrE1OXz1rIO75TjIOjdBlybhimP5XxJQb/wLPilQ=@vger.kernel.org
X-Received: by 2002:a17:907:95a4:b0:ac3:48e4:f8bc with SMTP id
 a640c23a62f3a-ac3f27fd3b3mr1859596466b.48.1742935307883; Tue, 25 Mar 2025
 13:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325121624.523258-1-guoren@kernel.org> <20250325121624.523258-2-guoren@kernel.org>
In-Reply-To: <20250325121624.523258-2-guoren@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Mar 2025 13:41:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
X-Gm-Features: AQ5f1JpwFc7ifwGuAhyrs4E5qPgHx1McCR38KFycRhkLFRMKTveHrmoaWi4zba4
Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 01/43] rv64ilp32_abi: uapi: Reuse lp64 ABI interface
To: guoren@kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org, 
	oleg@redhat.com, kees@kernel.org, tglx@linutronix.de, will@kernel.org, 
	mark.rutland@arm.com, brauner@kernel.org, akpm@linux-foundation.org, 
	rostedt@goodmis.org, edumazet@google.com, unicorn_wang@outlook.com, 
	inochiama@outlook.com, gaohan@iscas.ac.cn, shihua@iscas.ac.cn, 
	jiawei@iscas.ac.cn, wuwei2016@iscas.ac.cn, drew@pdp7.com, 
	prabhakar.mahadev-lad.rj@bp.renesas.com, ctsai390@andestech.com, 
	wefu@redhat.com, kuba@kernel.org, pabeni@redhat.com, josef@toxicpanda.com, 
	dsterba@suse.com, mingo@redhat.com, peterz@infradead.org, 
	boqun.feng@gmail.com, xiao.w.wang@intel.com, qingfang.deng@siflower.com.cn, 
	leobras@redhat.com, jszhang@kernel.org, conor.dooley@microchip.com, 
	samuel.holland@sifive.com, yongxuan.wang@sifive.com, 
	luxu.kernel@bytedance.com, david@redhat.com, ruanjinjie@huawei.com, 
	cuiyunhui@bytedance.com, wangkefeng.wang@huawei.com, qiaozhe@iscas.ac.cn, 
	ardb@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, bpf@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-atm-general@lists.sourceforge.net, linux-btrfs@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 05:17, <guoren@kernel.org> wrote:
>
> The rv64ilp32 abi kernel accommodates the lp64 abi userspace and
> leverages the lp64 abi Linux interface. Hence, unify the
> BITS_PER_LONG = 32 memory layout to match BITS_PER_LONG = 64.

No.

This isn't happening.

You can't do crazy things in the RISC-V code and then expect the rest
of the kernel to just go "ok, we'll do crazy things".

We're not doing crazy __riscv_xlen hackery with random structures
containing 64-bit values that the kernel then only looks at the low 32
bits. That's wrong on *so* many levels.

I'm willing to say "big-endian is dead", but I'm not willing to accept
this kind of crazy hackery.

Not today, not ever.

If you want to run a ilp32 kernel on 64-bit hardware (and support
64-bit ABI just in a 32-bit virtual memory size), I would suggest you

 (a) treat the kernel as natively 32-bit (obviously you can then tell
the compiler to use the rv64 instructions, which I presume you're
already doing - I didn't look)

 (b) look at making the compat stuff do the conversion the "wrong way".

And btw, that (b) implies *not* just ignoring the high bits. If
user-space gives 64-bit pointer, you don't just treat it as a 32-bit
one by dropping the high bits. You add some logic to convert it to an
invalid pointer so that user space gets -EFAULT.

            Linus
