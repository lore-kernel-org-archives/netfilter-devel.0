Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E302264B0
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2025 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207067; cv=none; b=s0wTNh6wvMiX1OgQGWboPHjnIOcsft+ZvNgvbn2XVSf5tcxw7N9i2yj2g/g6clLblCLZnEF2mBe13S1fcoEObEJX7r28pHxI+A0MmCubQHFF4KaJM2av7AFeyLxuIXGLHM7pLTa8hPsfumhMQEb9/5/RieFisCXFhY33i/x/pa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207067; c=relaxed/simple;
	bh=izizD3VjgpVVdOW3BC8PfHRSOs6E0jjQfdGsV27pIiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lD7fVisWh2YI2l7x+nGstcT1GFEuu056hm/ZHykm09GTuVEdu2Ia1QhB7poIWpAMecdzudXaokn8HTQdC4XEH+xlF9ktPDTJPSma+AtGbPT3zNInql7oUHXZH3vJh4IAN5a/kEp6i/DaJ3Y+UapRMYZ4Qyku6nJr0f0CueeBgU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IQFxLVLd; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQFxLVLd"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b5c81bd953so408057485a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Dec 2025 07:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765207064; x=1765811864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izizD3VjgpVVdOW3BC8PfHRSOs6E0jjQfdGsV27pIiQ=;
        b=IQFxLVLd8SpFLKiPA5qnp4mMOCaKBmHil7Po/taDeabViEDKZrr7t0ouR6SIbPJbaw
         I5kZr6csOAYqcnYEGb5gqQVGcwluqIWkI3QX+SfzjGxG2bkDw4f71VSLw6DUBcI/2XvA
         94lRxA0agyK7ClbwCE/xSoZhQ6VzZcvMMBXmwCheO3HLhKsBinbGK7gBp+bRwlz/Odo7
         ixyVzIt3a66PH/gQXZriEo54Pz6h92Q0XiplxPIpxqKOa/LZ31/8zNkrctCX9HOVEdFx
         PpxhipyUs1A2g33G5ZIYHTz8G7IEGkVbGAWfN14o0XoKxfSjCpEO3jeRaJbNApUG1EWU
         l38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765207064; x=1765811864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=izizD3VjgpVVdOW3BC8PfHRSOs6E0jjQfdGsV27pIiQ=;
        b=xFyauso15L4sAGg+pQwndRk80vFGG8IJkyKA0liXrEWIJea5B2FgYtVRBd3GoFMog0
         Fo/2SeXyiu6Jo/0qoqLyWTwJzSKBiLG+zk/r9bgbvrnMAhjDNViEOjRAMuT7NKJ591rg
         g4J65uYmEGQ0XOAVGlqI8Ju/qoZgykhfu1fJl4LsDVlJlucg84G6NABf38YR0x2IcdIK
         9YXsolI0hEf9l+NpVd0S1e1fWGo95imfPDc+nwALoRYmcPY8tSAVQm9SgIAfmlZXHJnc
         KsKsA0L7dmZ+dV6XY2t5ID4iF8jvPwHRjQyURsrjKIkV0q9pA43OT0qwCDRl9/xqNMdS
         Uhvw==
X-Forwarded-Encrypted: i=1; AJvYcCWrskrDlFtULC4mYOQFXcacV26BjCklpWk3QsVMusKzOMUwwlh5lU9n/gUGuB5f7eQ4gXTTpR6k25tUf/p9rAU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNGnGK5xiggOPLzs7r7r3MF24wICRl1WQLKKMSOCYF8ErG8Ir/
	5BYD9QGxRW9EySUvS7YAoTj+gtyOgIZ91A/ybbUg4D5eRi4O47iE+Ij9D8J+SO4PYeuPSk+3i5Q
	XYiEIDla/A4OmpPCR+T7zjxaOqPWPjbOLMrjuQm+I
X-Gm-Gg: ASbGncsxuTGdz1U5TywrNFPUYjWQk8L/Ju8ohLbqZbd3/Opn1BS/yrEAO7MvnDqDNrr
	xFVG1wSgtTVsxob51g/nDz6cec2qWncPkqABqPXJu7RvF8M2nNxD7fmnRLsW/dIIvc3U7tLpue4
	8lKk6vzFNRLTmGnt11lzyzrx6a+MYn3d3aYQ+Qf/dS1Q7rhFcD2OYEclSAq4xIZRcnruxf/XIlF
	Oi9PU8IVDAfgm0Um/PqX1YDJWkglvI/6eZ7w41zzNYs9LD0g2NF6ny/o9iSLCRQNXtDY1w=
X-Google-Smtp-Source: AGHT+IFS+w6QDxMLDyPgYwa89+TWhIuFIv1sv1yUhL3jFz9Ar5QN3KkcOF8P1l32aGce+lkI52/LTtQ94IwqUUmK3jo=
X-Received: by 2002:a05:622a:58c3:b0:4f0:2258:fe1e with SMTP id
 d75a77b69052e-4f03fde931bmr102885071cf.10.1765207064084; Mon, 08 Dec 2025
 07:17:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207010942.1672972-1-kuba@kernel.org> <20251207010942.1672972-4-kuba@kernel.org>
In-Reply-To: <20251207010942.1672972-4-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 8 Dec 2025 07:17:33 -0800
X-Gm-Features: AQt7F2oX_UOv9MW-_6378FuuUImQnAfrJK7Esmwm2N09qzF03GjECuOURZmcBzU
Message-ID: <CANn89iJgoxOjGjhBAHeaCdcd3X9wzRoUg27e3TSY4X+SR0aBdQ@mail.gmail.com>
Subject: Re: [PATCH net 3/4] inet: frags: flush pending skbs in fqdir_pre_exit()
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, fw@strlen.de, 
	netfilter-devel@vger.kernel.org, willemdebruijn.kernel@gmail.com, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 5:10=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> We have been seeing occasional deadlocks on pernet_ops_rwsem since
> September in NIPA. The stuck task was usually modprobe (often loading
> a driver like ipvlan), trying to take the lock as a Writer.
> lockdep does not track readers for rwsems so the read wasn't obvious
> from the reports.
>
> On closer inspection the Reader holding the lock was conntrack looping
> forever in nf_conntrack_cleanup_net_list(). Based on past experience
> with occasional NIPA crashes I looked thru the tests which run before
> the crash and noticed that the crash follows ip_defrag.sh. An immediate
> red flag. Scouring thru (de)fragmentation queues reveals skbs sitting
> around, holding conntrack references.
>
> The problem is that since conntrack depends on nf_defrag_ipv6,
> nf_defrag_ipv6 will load first. Since nf_defrag_ipv6 loads first its
> netns exit hooks run _after_ conntrack's netns exit hook.
>
> Flush all fragment queue SKBs during fqdir_pre_exit() to release
> conntrack references before conntrack cleanup runs. Also flush
> the queues in timer expiry handlers when they discover fqdir->dead
> is set, in case packet sneaks in while we're running the pre_exit
> flush.
>
> The commit under Fixes is not exactly the culprit, but I think
> previously the timer firing would eventually unblock the spinning
> conntrack.
>
> Fixes: d5dd88794a13 ("inet: fix various use-after-free in defrags units")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>
