Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65525361641
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131602; cv=pass; b=cYAxuEgVa6pBWRPkkGqrpxGUf6r59ykYnwpu6S/xD9Br11dOYkjtnjF2U2Lv8lokhKNm8gnumaEPKkyx8jx8F6MokJ7q5dQhx6m4pz2cKJ7jSnjJaXQ1lB+iexU4jlJKTZX83yr9h1cALXrHbGBkOWzym7rgH32Crp+S/K3Ud7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131602; c=relaxed/simple;
	bh=8vDes+e7/1V7VR8Nz218XUkz8Pq+TNyxUOlsiUiLAs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PjJaUEsKf8zyS5hSEKoWB9JgtyD4+15JowT5iDYg1GSRAHEJdUoR5KwFN0zNl9dV+sOsz5/HpPHakJv/Gz1uBuZVTcAi2xXgOKmJB3N1kodMhequHfvLdNYEmdr01ynLeGd+Rvtx/4qKg8uOCy0B7DjulIy778+IqCgFSfwLGAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZKbfXwqT; arc=pass smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZKbfXwqT"
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-915aa0a9293so565529085a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782131600; cv=none;
        d=google.com; s=arc-20240605;
        b=K6ZGSkUEJmVywI/WelzGrspROrH/XbfUd56y7XC2Bb1p7k+RjY1n5LU7lR89YPP3uX
         iHmfBpYPkNCwvVyZqeVp8MFLxJANl9P7Cqimp9gUlJNTSUdiHEvTMsBj0knrsBnvkCQX
         kBKeOsuADQw5XAsQ5J9esvDLOCQkP5dv5uhCFUn08O1Vk76F0PVHZZtECE5JXYiXDVpg
         PZpELDwd4cGWUo8zpuAIr2kYVWkB/KoeMw0A0XMpMzRbIRIpzfWi/LCAlipNH8OE+Hua
         YhufI+hKvC1lgK0b/UYZG4g90r+BvHAV8vCVRbGslXudWA1ES1aY9XcHSiyvlQiY8RCl
         iOgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YmRvukfSJvgUJLvig9hb0giMVedRKpfKlkMKmCdzG6E=;
        fh=zj0Lm1Llio/6Mgriapc6UE6cUMiCirMil99bO3jAdVo=;
        b=L/B4+xoeqdqPYpfYJPt+aUFmfJwsjGCTNN/rFcs8ppuGf6OAuvLqrB3Qk9XIdzq68m
         CQEEUCiq0fCqgYRVIOtuwA5TyHqZjaMDZQxHKSa04AiMVutSb8Bj3LzuPqs3drGnVBmf
         xZFEVi/37GBVryw+qw38RjOfuq0NAGc6tG2ctIYXi8rT9j+NZyq1mh+yLgSP8q1bWTsi
         pCagTVPsIv+qDlX7hyfuWnvfTaUUcZvnHDcekeSEo2z3TiAgQr//AjXrq8LjuPCEj0+F
         fojxw+VpBZq2/XxJYwqHPdORg7DFVLVsu1XfSS9lr/Y991XmrpX+FiLLw0knE8oCXSpZ
         axmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782131600; x=1782736400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmRvukfSJvgUJLvig9hb0giMVedRKpfKlkMKmCdzG6E=;
        b=ZKbfXwqTfYWeJ4Dy3ATCTWY/wwV5z039Fhx6AehOHXE3JCsY2Y+mXtU8OG/bGeXJbc
         /5r7F1202BR/EY2sNMqOnza5QSmHubVQaLMd11gCon7Q6OlXUsm7n+YuLEWlOz0tvN5v
         HCte8XwVFAVBg2V+Gd3kjghUNDLnRoU9RNqmB4YyADlxXQ3OhWSiRSfWbxrMOHosnH1E
         fFnSyhk/tKTatNaYcRFbe3iiNbiL1cudV7ASV8oK++4YnktG0Y7jlwdg0H0KUvu7iPgp
         yUV8dSo9DxqcnZJoK+lp68y7MrHleEX6H43pIjUGjrgrYEYFoQgZE7TxD3YyKh5j+NgX
         4O3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782131600; x=1782736400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YmRvukfSJvgUJLvig9hb0giMVedRKpfKlkMKmCdzG6E=;
        b=gp3DFzek9NiJIVhMgOoObY1oJyjyzQmcx7gn8ibntDlG6Pr1pdYYPLrHxu0+AsADJG
         1K2dzBM+RUvRpER1GQnuNiVyAf88IyTyt1bmEbdZhBb6udFwoSfgSO6Eb//DObaqXkkB
         yLYobWPRUU0Sx3qo8jYBGSXc2QCiXun8hEHGuE3FO987Nwb4fCuEiSLPVhEv18/W6aSx
         aqjMJbDLw15pgOXOq0Mp2BqPJrtPaLy5iy4aSqecOtpXbDeyOysqz7BahwXc2L84yqvF
         hcxhq526jZmdGc2xqJ5ul0XBSjtPAfgtqIzboopWMONaexJclyff6A0NEEU54AalvYR4
         3Zjw==
X-Forwarded-Encrypted: i=1; AHgh+RpY00DVhK1i/0smTPyBLVSiO8NTALnvPGhWVW34r4wTrZ7V8FxUxgo3ft5/vx2otELhPThtbmYLzKuEjhjWIFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPTkJvkcT/fjGkX8y4lCRGrvywD5dDfp/IOXO3JOIv+xYrv+Va
	FWYHg0d2DfL+1zH+cAqlybrK2zCXWHnEB1X/f7MIDNuoFaHd2g6Dp0O8QDMfPcy7ATLdeWQRWiN
	rbboDGrRFh8a0amJ9leLkP0/ROw7vPYQ=
X-Gm-Gg: AfdE7ckUhISZN0tp4bEiRi7fw1FeM4IpIhM7Wib+FlFtiqu6iGxHYw8v/HEyPKk5S57
	6hCM4sVtciYHhMpmHHNJdbv+OM0Cfm/gqtoDY/ZXkTd0HXkHWutXuNDQ3ahuRW4z2EiZ2Nh7Vfq
	itxSW4YYvzW/UheCCJdWxWw26mnl/egJwM0L0+OoWZ27HmaVJmrbhRPoIFn6x0tEMldxPZuHuXg
	+ngKaGXqTGKGXRbo4F8CK+6c4oO/yDSSB2+wT6IDHrt+ke9LEuOWT5gHRESUNRlUlacCuIL1A==
X-Received: by 2002:a05:6214:2306:b0:8ca:1e84:4e79 with SMTP id
 6a1803df08f44-8de499920a7mr168892476d6.4.1782131600408; Mon, 22 Jun 2026
 05:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>
 <aih7PqPryonzP7cI@chamomile> <CAHPqNmxbS+YLQeOLOibm5rOBxA_nciMAVuEe5ERCOs3uE6+8+Q@mail.gmail.com>
 <d26c8934-6d4c-4171-9e6f-f58a249dd9ff@linux.dev>
In-Reply-To: <d26c8934-6d4c-4171-9e6f-f58a249dd9ff@linux.dev>
From: Longxing Li <coregee2000@gmail.com>
Date: Mon, 22 Jun 2026 20:33:09 +0800
X-Gm-Features: AVVi8Cc3g-9OGtbUN98eEDlvqip_g98UCHITOr6LdAmxjZsGiv90lF7uZn7ybfU
Message-ID: <CAHPqNmz32qs57+w4kLgJvDnKqMtwi+Ca-4OUcP1SYmC3No2dwg@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: task hung in xt_find_table
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, syzkaller@googlegroups.com, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jiayuan,
Thanks for explaining the situation. I will double check this problem.

Best regards,
Longxing Li

Jiayuan Chen <jiayuan.chen@linux.dev> =E4=BA=8E2026=E5=B9=B46=E6=9C=8810=E6=
=97=A5=E5=91=A8=E4=B8=89 17:26=E5=86=99=E9=81=93=EF=BC=9A
>
>
> On 6/10/26 3:14 PM, Longxing Li wrote:
> > sorry for not containing report plain text in last email. the report
> > is as follows:
> >
> > INFO: task syz-executor.4:42949 blocked for more than 143 seconds.
> >        Not tainted 7.0.6 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:syz-executor.4  state:D stack:26456 pid:42949 tgid:42937
> > ppid:9759   task_flags:0x400140 flags:0x00080002
> > Call Trace:
> >   <TASK>
> >   context_switch kernel/sched/core.c:5298 [inline]
> >   __schedule+0x1006/0x5f00 kernel/sched/core.c:6911
> >   __schedule_loop kernel/sched/core.c:6993 [inline]
> >   schedule+0xe7/0x3a0 kernel/sched/core.c:7008
> >   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7065
> >   __mutex_lock_common kernel/locking/mutex.c:692 [inline]
> >   __mutex_lock+0xd9e/0x1df0 kernel/locking/mutex.c:776
> >   xt_find_table+0x59/0x1a0 net/netfilter/x_tables.c:1245
> >   ip6t_unregister_table_exit+0x22/0x50 net/ipv6/netfilter/ip6_tables.c:=
1808
> >   ops_exit_list net/core/net_namespace.c:199 [inline]
> >   ops_undo_list+0x2dd/0xa50 net/core/net_namespace.c:252
> >   setup_net+0x1f3/0x3a0 net/core/net_namespace.c:462
> >   copy_net_ns+0x351/0x7c0 net/core/net_namespace.c:579
> >   create_new_namespaces+0x3f6/0xac0 kernel/nsproxy.c:130
> >   copy_namespaces+0x45c/0x580 kernel/nsproxy.c:195
> >   copy_process+0x30cc/0x76d0 kernel/fork.c:2227
> >   kernel_clone+0xea/0x8f0 kernel/fork.c:2655
> >   __do_sys_clone+0xce/0x120 kernel/fork.c:2796
> >   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >   do_syscall_64+0x11b/0xf80 arch/x86/entry/syscall_64.c:94
> >   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x471ecd
> > RSP: 002b:00007f51f163e008 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
> > RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040080020
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000202 R12: 000000000059bf8c
> > R13: 000000000000000b R14: 000000000059bf80 R15: 00007f51f161e000
> >   </TASK>
>
>
>
> This is not a deadlock =E2=80=94 there's no lock cycle.
>
> The runner is simply under heavy pressure on all three axes: CPU (zswap
> compression) + memory (direct reclaim) + IO (swap).
>
> The hung task is just a victim. The actual holder is another task that
> took the mutex and then fell into direct reclaim.
>
> Likely stack of the holder:
> get_entries
>    xt_find_table_lock
>    copy_entries_to_user
>      alloc_counters
>         vzalloc  -> direct reclaim
>
> "INFO: task hung" reports of this kind are common on the official
> syzkaller dashboard https://syzkaller.appspot.com/upstream/
>
>
