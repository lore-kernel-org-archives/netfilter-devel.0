Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50771F613
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBofTakm"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2cc7b9281d1so30442471fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 00:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703061183; x=1703665983; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WF0efVm6ZV8/TmsokCS5TiRwurME+TrplXjHAPhTwvA=;
        b=hBofTakm2ZjFxpXQsQupK7UA/FtveF+RvhXZTZc6ve8QAyqp7vl+XGGN9y3+1H6vlZ
         BNAb73slSOb4SNH3A5qYhXeFw4huyIAmHhjoZ4yExO4sarzZnTyVyNVK7fmNFV0cAbRz
         W9TTMMXMECkArI+XXnmxYunLg2DLGaIkbaGLlymvaw5ZhHp62vjZbjQzfas2yCnsBtYX
         Yhx/hwhbE3b77d5m+5viIKj3FIEDn8MC6yfOWnp1DGaPAa+NgfwJdiARqx26pEPBIuil
         +NveppMWqpRjiyuRcprEazCtoSjvNdVsKL2rn+GAkDdwjA4JrD6oO+DttmjcS0tDYKST
         kiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703061183; x=1703665983;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WF0efVm6ZV8/TmsokCS5TiRwurME+TrplXjHAPhTwvA=;
        b=Zz1OxWkXNQpYG4HA6D958KWmMOD2fD66WAzccbWzZlW1EhQIE337D5O40yW+GVPYfW
         uSovDw6rAPBhMYJZRGr/8WKpr4bvDwSJv0rOZMMVtPT6NWEXaM2DupGMuH4bT9Vvh8BH
         ppGUyeeROgv3nBtSGje9ewcfCvXX9BHbCG+SdNnlu89v4EHBtNbDJ0wfcxGOrIVt27+X
         bZAwTx/Ym/JqpZeLoIfs6q6Zcwb3dyBPsHXxnEjUD2gCSocumrhoqarDGZWfNeI7B/fF
         DxR+2tqCQGjibEM6Dyfz2byOupoJwIQqlj8CruwJrVlDGpeUF+vZORtyH6KYrF4l49/E
         JYqg==
X-Gm-Message-State: AOJu0Yw93b6orM/YOnxqoZUITQYDm8ihhpDYHCZxe8R0Kkl9jyOObvUv
	9CJQj4vP/gv96Hb8FoMAwZmxY1df6QrLP6Iv+pMl9yM0wxc=
X-Google-Smtp-Source: AGHT+IFzF9SyuOQdsPXEj6NxRh6zkPERvtG5jvtOWOqfBumt+OEbISb2WiRPx1s4DWgFPn1gMEcZCvFK5GeRcc4CyYc=
X-Received: by 2002:a2e:be9d:0:b0:2cc:6ca3:2476 with SMTP id
 a29-20020a2ebe9d000000b002cc6ca32476mr3489870ljr.67.1703061183351; Wed, 20
 Dec 2023 00:33:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Pierre Bourdon <delroth@gmail.com>
Date: Wed, 20 Dec 2023 09:32:52 +0100
Message-ID: <CA+V6dmgeQwLcsZQRpBFiQEwKBUGcEZGvaVtStU0DK9V_5q2tiA@mail.gmail.com>
Subject: netfilter ipv6 flow offloading seemingly causing hangs - how to debug?
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi netfilter folks,

A few months ago I enabled netfilter flow offloading on my home router
(via nftables "flowtable" / "flow offload"). However, when flow
offloading is enabled, the router randomly dies every few days with
RCU stalls in its logs. Example seen in a recent kernel log before the
device completely froze up:

Nov 26 00:40:57 aether kernel: rcu: INFO: rcu_sched self-detected stall on =
CPU
Nov 26 00:40:57 aether kernel: rcu:         4-...!: (5249 ticks this
GP) idle=3D5cb4/1/0x4000000000000000 softirq=3D3138386/3138386 fqs=3D290
Nov 26 00:40:57 aether kernel: rcu:         (t=3D5250 jiffies g=3D6113853
q=3D1934 ncpus=3D16)
Nov 26 00:40:57 aether kernel: rcu: rcu_sched kthread timer wakeup
didn't happen for 4673 jiffies! g6113853 f0x0 RCU_GP_WAIT_FQS(5)
->state=3D0x402
Nov 26 00:40:57 aether kernel: rcu:         Possible timer handling
issue on cpu=3D11 timer-softirq=3D879795
Nov 26 00:40:57 aether kernel: rcu: rcu_sched kthread starved for 4679
jiffies! g6113853 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D11
Nov 26 00:40:57 aether kernel: rcu:         Unless rcu_sched kthread
gets sufficient CPU time, OOM is now expected behavior.
Nov 26 00:40:57 aether kernel: rcu: RCU grace-period kthread stack dump:
Nov 26 00:40:57 aether kernel: task:rcu_sched       state:I stack:0
 pid:15    ppid:2      flags:0x00000008
Nov 26 00:40:57 aether kernel: Call trace:
Nov 26 00:40:57 aether kernel:  __switch_to+0xf0/0x170
Nov 26 00:40:57 aether kernel:  __schedule+0x374/0x1750
Nov 26 00:40:57 aether kernel:  schedule+0x58/0xf0
Nov 26 00:40:57 aether kernel:  schedule_timeout+0xa4/0x188
Nov 26 00:40:57 aether kernel:  rcu_gp_fqs_loop+0x13c/0x4b8
Nov 26 00:40:57 aether kernel:  rcu_gp_kthread+0x1d4/0x210
Nov 26 00:40:57 aether kernel:  kthread+0xec/0xf8
Nov 26 00:40:57 aether kernel:  ret_from_fork+0x10/0x20
Nov 26 00:40:57 aether kernel: rcu: Stack dump where RCU GP kthread last ra=
n:
Nov 26 00:40:57 aether kernel: Task dump for CPU 11:
Nov 26 00:40:57 aether kernel: task:swapper/11      state:R  running
task     stack:0     pid:0     ppid:1      flags:0x0000000a
Nov 26 00:40:57 aether kernel: Call trace:
Nov 26 00:40:57 aether kernel:  __switch_to+0xf0/0x170
Nov 26 00:40:57 aether kernel:  0x0
Nov 26 00:40:57 aether kernel: CPU: 4 PID: 258788 Comm: kworker/u32:7
Not tainted 6.5.5 #1-NixOS
Nov 26 00:40:57 aether kernel: Hardware name: SolidRun Ltd. SolidRun
CEX7 Platform, BIOS EDK II Aug  9 2021
Nov 26 00:40:57 aether kernel: Workqueue: events_power_efficient
nf_flow_offload_work_gc [nf_flow_table]
Nov 26 00:40:57 aether kernel: pstate: 00000005 (nzcv daif -PAN -UAO
-TCO -DIT -SSBS BTYPE=3D--)
Nov 26 00:40:57 aether kernel: pc : rhashtable_walk_next+0x7c/0xa8
Nov 26 00:40:57 aether kernel: lr : nf_flow_offload_work_gc+0x5c/0x100
[nf_flow_table]
Nov 26 00:40:57 aether kernel: sp : ffff800082b83d40
Nov 26 00:40:57 aether kernel: x29: ffff800082b83d40 x28:
0000000000000000 x27: ffff499960019000
Nov 26 00:40:57 aether kernel: x26: ffff499960019098 x25:
ffff4999d620ff40 x24: ffff49996002f205
Nov 26 00:40:57 aether kernel: x23: ffff49996278e300 x22:
ffff49996002f200 x21: ffff499960019000
Nov 26 00:40:57 aether kernel: x20: ffff49996278e250 x19:
ffff49996278e2f8 x18: 0000000000000000
Nov 26 00:40:57 aether kernel: x17: 0000000000000000 x16:
ffffcb4ea90f8c70 x15: 0000000000000000
Nov 26 00:40:57 aether kernel: x14: ffffffffffffffff x13:
0000000000000030 x12: ffff49996278e260
Nov 26 00:40:57 aether kernel: x11: ffff499c7eba0000 x10:
ffff800082b83d68 x9 : 0000000000001c03
Nov 26 00:40:57 aether kernel: x8 : 0000000000000000 x7 :
0000000000000000 x6 : 0000000000000000
Nov 26 00:40:57 aether kernel: x5 : ffff49996278e2e0 x4 :
ffff4999b4408958 x3 : 000000009437e358
Nov 26 00:40:57 aether kernel: x2 : ffff49996278e260 x1 :
ffff4999b4408958 x0 : ffff800082b83d68
Nov 26 00:40:57 aether kernel: Call trace:
Nov 26 00:40:57 aether kernel:  rhashtable_walk_next+0x7c/0xa8
Nov 26 00:40:57 aether kernel:  process_one_work+0x1fc/0x460
Nov 26 00:40:57 aether kernel:  worker_thread+0x170/0x4a8
Nov 26 00:40:57 aether kernel:  kthread+0xec/0xf8
Nov 26 00:40:57 aether kernel:  ret_from_fork+0x10/0x20

By playing a bit with the nftables configuration I've isolated it
further: it's only happening with IPv6 flow offloading. "ip protocol {
tcp, udp } flow offload @f;" doesn't cause hangs, but "ip6 nexthdr {
tcp, udp } flow offload @f;" consistently does.

The device this is happening on is NXP LX2160A based (ARMv8, 16
cores). This has been happening since at least kernel 6.1 and I've
tested all the way to 6.6.3.

Has anyone ever reported something similar?

What would be good next steps to help track this down further? Any
useful .config options? I've never debugged hangs like this in the
Linux kernel, unfortunately. My router doesn't have a JTAG for me to
plug in a hardware debugger and get stack traces while everything is
frozen. The fact that it takes 1-4 days for the issue to reproduce
also doesn't help...

Cheers,

--=20
Pierre Bourdon <delroth@gmail.com>
Software Engineer @ Z=C3=BCrich, Switzerland
https://delroth.net/
