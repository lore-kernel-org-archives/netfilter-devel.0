Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E493783C3
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593195; cv=pass; b=keGRagurGGq2VUYI1W1UNBynuWnsTAEzD19QuId8liZJ3reW7odBQ3GCYDm8tIQeq6Nxz2j49VOVvwGRGkyGlMHmriD7y/DlSZJL0Kgkug5dR9qg7xzKxKmynTgBO19iyaNEs5Xh121trwPv+71RsOse6g41fm21llE5mXBTxZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593195; c=relaxed/simple;
	bh=cIcwh02YeJrScNHPq9X6XdHj5CJSHTdteY/DkuKKTzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wz4DeWY9MrMJ2HdABbljw2jv70xVapUbgVdtiolBbAnuVFPy1fAiugOlTeixCZW0EYXbrvPoIkvkA9DrcdO+wMAVVhc1Qdof5/6NXhLS7hu2ygID7C5nKwEx/pRpqOZzambjK+cFzJZSllz6IOZxhUc3rWHCbgo89Z4rB+OypRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t4JYq1KP; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t4JYq1KP"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso7153905a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 13:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593193; cv=none;
        d=google.com; s=arc-20240605;
        b=hE2s1ReFrkyCfxEh9ZvIfn7cTLhaUYjEqpz+HEyHlXUgAwWkOPvkmsan29aJvQh+R5
         6W0axaxv4TwreLqgWZvEdsqW9nOqrgwrsJSEBqnWtTBuQnU+6zSZ91SP9S7+vaHyInPH
         1x10P6PIUUFZILdTrAvfmM1GpF8khGrNT9qT6Fo7QN982E58kk51SPTKyp/bB99jwg6v
         a5FNMltpPW8wnQ7v9nzNafywv4pNqMxboWXKPQYwIZiDB1vDnWrldePvgNugRhWALXfp
         wNNj7vS6w8PNLoEl14G2YJDtxakRYqEdhn4JCymUw/wPfh1+9DIDQLyypFiVCOvFZgZc
         hlyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5F/h7KugE6fbvjgPOHVFnVDYl0H2cgQ8aKqNXa/3w5M=;
        fh=mgOvn/qRSKAsPHiY/1udALgzvxa0KKMOdtDlWlvUqtM=;
        b=GrYGquuYd06/EVT15wjNZ9ZnM2PxdkxPE6yVM3ybRNuTVghCLww/5ni7h0b2oHJ/nU
         CvEiTnMy5PkQ+FocWmgxh93F/w1t9iD0LOAE4cCK0h2U54mwG6U9y5PaMHxAfhxcRhqa
         WOI8RBJQ4f/6A0JijynNKZQIDID6DJJK/+UH3PyBhtb+H8XkdE6I+hu2fkt/4wekW4MD
         NQUDwSNfsuvBxhCo/zpMVmzVYHU9EtgvxUJ3z5BxzwLnoIkFIB9HzZhf/lIwp6RgmD2m
         b3yNu/rnWQB8Fg/wnmyTXLGufa7ayATR+o0p/9Bw3HDb2Pxohx7qMOb4HgzzBhfLx3xk
         mmEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775593193; x=1776197993; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5F/h7KugE6fbvjgPOHVFnVDYl0H2cgQ8aKqNXa/3w5M=;
        b=t4JYq1KPWphomxLwlxZw2h52L+wJN/krZfUbfEyboUwujMfUydewGc9bVWZiTOtINg
         z2pcM1htrDAmXF3K6Wn9IRu98sZ7prefzavrXARvujxIVsoezieOIxkWfZmftHlJTOoR
         s1JQlVIqOnHeWXhpHFPRW67O+nCrng8WczRcKfh+qqH3dCW5JMxAYTqnuTi3/y/PMD3q
         uKA5bWy/yZlDmkL22Jd8/H4CysmMmeXGy9RDOOQpTSG4rKevZcUGEUYD2H/EtofU1UHK
         haAbc+dLSLg9p4EeaSMe2/lJjBNT/CT8hBjnwSFMdjl7TVGIip2i4Knw953SvCCpmZqh
         QnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593193; x=1776197993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5F/h7KugE6fbvjgPOHVFnVDYl0H2cgQ8aKqNXa/3w5M=;
        b=l2NEagMWTAFHhZbe7lyf/92Jzq/hE7SBxk/U6C8AYM3V0IM9pfS3NJ0i2pZ12E8ZF8
         KpE1IUgaec47KSzzF9yso/qawX2pBAdQG5c9/929qP3Vlfa8W5gFXcFvyImgEPQ5EZ/Y
         n+oix7iK7yC+5P82hybwzRwaJAwwamtQtPZn6/JtA24PoWFUKhQ5SG966h6JbWyvSATN
         08VHhYDdqXTG58Jjq6b/6C0Sw7TWsF0bDuwaKdKYAr5ZHz2GRQVFbgy0ZEXCMwBf0NTE
         ZeOO7v5aoHgJudHefxKkKJImu55erUI72mMRYU4gKCYIfhMrBzGPWM5gU82r6/XQiFB6
         +Oag==
X-Forwarded-Encrypted: i=1; AJvYcCUXYwvBG3JNvx7LqvtPJdHjKxqNZGQ9ZGs2CgGWUTshv3tQgxnsYo6SztVsvQL0C0aYC/CyxtCl4oQP0e9hDao=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJdxl/yZVRanJJyVNal1onen4MQxlAfAycGktRVoLcD8mM85SV
	yE+WARQEdpRN0oCqUgjmsx3LPGmf9Zs8EDF/PbJ43eQD3O3wI7Yn1AvqkLQkP5ZtH1RCL+f+efw
	QXXqsmRjU6KUGwyTVqB2Nb/DpRdT9KsFwdHSZyMM=
X-Gm-Gg: AeBDiesArQsI+i28fuxtnGeMiUsHJGDcqAVBSLinAY5gAy9OhS3/hNlsQNqLkOAMNv/
	eM5ryuawKqInebgL8uh+jygoECRM3vw2Rawkzqbham5BQE7hfhSGEyjF7UhFV9kEzCHjcxwwrVz
	PDem7+kgeXOEJ3lgKg91gVI3OOlUyIAtUSQDE3leqai1g2+p9qhtEZQCH1bQlcCdDFVHM7nNWfv
	u1/49QTulJL7H1iOWP/yqZ1PhddtcZvslzINyOZiPg+jt3YR3qHc7IY5vIUsimvzepZZv4OI72N
	b0SiZ3YOhJdyXmcjoNgqphS7tVAVUWJl99j8
X-Received: by 2002:a17:907:3e99:b0:b97:7d03:68c1 with SMTP id
 a640c23a62f3a-b9c67957b45mr816891966b.30.1775593192032; Tue, 07 Apr 2026
 13:19:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407083219.478203185@kernel.org> <20260407083248.035227538@kernel.org>
In-Reply-To: <20260407083248.035227538@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Tue, 7 Apr 2026 13:19:39 -0700
X-Gm-Features: AQROBzB5Kk-9wmWuv1ZegtmjY7I9xuAgB8C2jMw495vm72Eo-cG6s6UJbujlAjQ
Message-ID: <CANDhNCp9TRWAF1EHQAcFHLv3eRusVycTrNDk=UFpzg0oTBjQyQ@mail.gmail.com>
Subject: Re: [patch 08/12] alarmtimer: Convert posix timer functions to alarmtimer_start()
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
	Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 1:54=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> wr=
ote:
>
> Use the new alarmtimer_start() for arming and rearming posix interval
> timers and for clock_nanosleep() so that already expired timers do not go
> through the full timer interrupt cycle.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> ---
>  kernel/time/alarmtimer.c |   20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

Acked-by: John Stultz <jstultz@google.com>
