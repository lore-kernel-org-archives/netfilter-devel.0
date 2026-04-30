Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8E36605A
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777585800; cv=none; b=hZsJnD3JSI9QXpE76H7BgiWc291Nvi6NJrUJVmkRBVK5FGWkoxf4ha5F7nGtndtVfBeG6YhI/auEjRbMpCbWwgcS2u5weeLIg3cuM6iqL59pajiZyUnIXBw36CKRYcL20y71PRzbVfzvwwpZtbGxFDZqOVMBFJPycUB0Z5IDVYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777585800; c=relaxed/simple;
	bh=85tk5QsJ9uyjCVoVZBAl1BfLHBLBZIfxn5vihRLucTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X58TphrFxwykMjdq81hIy5L28Cf6aNiFqX3nV3EEDCM2oUiS2lISGqOjspZR54EpHA/ceBVUYadSB8u/d1EpfK7NzQrshV2BQFKlpg9GIqG4xghg4UZPtoxK77q37Jw/FNf1x6vMW+E3FM8bigmyAjECc/lO4iRQECLdiBdGSHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIeUjj3n; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIeUjj3n"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891f625344so15451895e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 14:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777585795; x=1778190595; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=co7aAOg5SysfklO7pgS2h74n35b039IvIzPWl7cCjfc=;
        b=CIeUjj3nCpEgA/zFx6LaFJLEDQpAnDz5HROpJ/A6b4WxragTW/tGTfNLNIyRyGgRxt
         2Qp3CJoLJAFXdqJedBoYx1t5v+EfFe1Y/PdJC4Gv56G9wCMETQp9EsaWw7ki5rKvMlbc
         xHQimS+0hEkPYJM3rQtWc53rHnb81PgBdKKzGle66RwccEHPx1miyurWzvABKJiOBnsc
         hqfWz/3W/dkJGaB3jT2jGfUudUrLb/RADufOudsSKi5PvnbXxArwptVZisb32Ys5YiWB
         219U4MIOjyRpgXyouIIFqZftPLOGDA5Ezkc/22SPFQh0xAo5xU6I/PlGm2cAJVoeoVgB
         TXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777585795; x=1778190595;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=co7aAOg5SysfklO7pgS2h74n35b039IvIzPWl7cCjfc=;
        b=tZ0tuoN7fUmRfa0QCAgjahTwZP077nIY+gEj0Ouej1T0qPFfQ/5KvtQM1W2ZqIyVR0
         sUGphmLUdSr/H6VsFyr4EOsV7tzvQzK5gFRQQOUH/B2xMnSxi5+QCY8cGBpL2eF5He7K
         JQKf+t7UL1tV3OcYbrAYRBbcehLcAd9fSijDk9lpc1KqQ/RiJ9PYeBowTUACHBxVaZSO
         ZnRDQ5aDWIZ8/1Xf1xF6B4YqJlWckYoKkfucIaOY3SJEOeo+dB2w2TXg8ihreKWSqSNE
         wfHm3bvNBQOzOjFFEZAPkyV15yRJp5S+XfYVpqL31mvjhsPeKLpWhe+t0+DKslEMGGFw
         4cOA==
X-Forwarded-Encrypted: i=1; AFNElJ+rZ/cNj9KnUdCPuzwbvcD2ONR81vpBKPMrFY7rLj8yDYVvxXXtMgwtsgNr5SP/zpLLcB7sAATNWbz1rXdK8GM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxorXzY1xcFDFXE5zEUDuSNRzGc7kjQQM+EACGw3ZtfWirUYbfV
	sX9uAts4+3+E5zkZV1nvgVmJIE2+DQNA9VJ4vZPNnsnrBL+Zp3qMguA=
X-Gm-Gg: AeBDietoJJpbQan50oEbBFxP0FDfyny0Dw2/sQh9ruWGDCgfpd8zrDqV37KJ33TsY3O
	PowgMSnvK/W/q0JzO4RGGdeM5EX/A1Ak6Ly2huAhWFKFz8FgFjFHEYv1E5iPDD/gnQhLz0hBEsm
	aJQD5Wck4gGCvTjWztB36LeG43QKV1J8Hv+0Bdam98Ez8Aogd0B2j30lMVN51G2OrovbWQIoOfM
	SulCOqeqik6mj4P2RjF2l47mPCrXo4TMLBnoTtzE3NKgq4hvMZ9Yaj4IY0hSRL7eerqiKoC9ETm
	aOndVizROT+eTTUShwOu1nb93ctPUhszQK/b/hsnnL7n7gj0t3Yco3kTijDTL22i/FPFf+hDHvQ
	gadoHnkoW8BrXM/R3wzHeJqZdYjyjsAzQ38aZZJ9mTvDfupc3N51aZk0djIczL42Gm52sPlDDEr
	bQ9Gyoo59gIPmElzpeJz6Xt1Q1iBu8z3CHWqYLvzdklYE=
X-Received: by 2002:a05:600c:4f52:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48a85e684a8mr63270095e9.6.1777585795291;
        Thu, 30 Apr 2026 14:49:55 -0700 (PDT)
Received: from kali (88-173-4-42.subs.proxad.net. [88.173.4.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb55be7sm2654625e9.19.2026.04.30.14.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:49:54 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: fw@strlen.de
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Date: Thu, 30 Apr 2026 21:49:49 -0000
Message-ID: <177758578919.118018.11758358602621428742@gmail.com>
In-Reply-To: <afNYqx41pBCyDnjR@strlen.de>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
 <177750474339.3016150.13196470704394042910@talencesecurity.com>
 <afNYqx41pBCyDnjR@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Florian Westphal <fw@strlen.de> wrote:
> Is there a reproducer for this bug?

Syzkaller hit it under failslab. The race is between the lazy
init path in ipt_register_table() and cleanup_net(). The table
becomes visible via xt_register_table() before ops is assigned,
so pre_exit can find it with NULL ops.

Cleaned crash log:

  Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000003: 0000 [#1] PREEMPT SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  CPU: 1 UID: 0 PID: 604 Comm: kworker/u8:19 Tainted: G            E      6.1=
4.11 #1
  Workqueue: netns cleanup_net
  RIP: 0010:nf_unregister_net_hook net/netfilter/core.c:531 [inline]
  RIP: 0010:nf_unregister_net_hooks+0xbc/0x150 net/netfilter/core.c:613
  Call Trace:
   <TASK>
   ipt_unregister_table_pre_exit+0x8a/0xc0 net/ipv4/netfilter/ip_tables.c:1814
   iptable_mangle_net_pre_exit+0x21/0x30 net/ipv4/netfilter/iptable_mangle.c:=
99
   ops_pre_exit_list net/core/net_namespace.c:162 [inline]
   cleanup_net+0x4b9/0xbe0 net/core/net_namespace.c:632
   process_one_work+0x98f/0x1750 kernel/workqueue.c:3238
   worker_thread+0x679/0xf50 kernel/workqueue.c:3402
   kthread+0x3f0/0x7e0 kernel/kthread.c:464
   ret_from_fork+0x60/0x90 arch/x86/kernel/process.c:153
   </TASK>

> I'm working on a new unreg scheme to avoid rmmod racing with
> concurrent calls into iptables set/getsockopts.

That sounds like a different issue (rmmod vs sockopt). This one
is init vs cleanup_net -- the NULL ops window exists regardless
of the unreg scheme. V2 is a minimal guard for that.

Thanks,
Tristan
