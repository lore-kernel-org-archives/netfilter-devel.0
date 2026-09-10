Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B47309EE7
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077102; cv=pass; b=uAbE+sUosep2ySPPuBLDyEbFToFXyD/E88bF8fSZ3vM65/agzJ0lWa3PVZW+C5j5hsiPSmbQNmMo7bfMZaLvHq4vS8zvz2cznhq6aCo6Qnipk7G+RUoxSfPGxPv42/ZdB4N2jLpxiQTWNuPLW7XtuH5i5DvqR0wzKAk9cqL9Iig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077102; c=relaxed/simple;
	bh=lhs76FyKVwZRItwelNW4OtOwlChghkIa3jULBZPX+us=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mMCAfreSzA5MtbLA9JUmZzFobW8di9P4+hrzreXMokb5VK0FGmHZPgeoPLPIB3ZGw6UhZ2Otq12LKgAWw1jH1+vaaUJuJS+ei5W+DRkoEOBi87ndBiYLzNFM5zCzhaj1zBQj0QHaB1i65vsl9uzUf6sG2nDZtH++oHWDq03ekuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=IkUO7+SK; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="IkUO7+SK"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e2254dso37670b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 14:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789077100; cv=none;
        d=google.com; s=arc-20260327;
        b=qsHN9lGHxulFubBrvfY2Mj36eusg+SksfReAW+W4KTpapbXigrUcAJdfEEIEntxM1R
         k2GfkjYb08CVZiCP02QhHlil/kPK2RulHGN9nV9Rl6NYkcg4Ub3QQU+o88J8oAWjPtXp
         c0E+TYXfXWYwFwDVt5XozoBDWLw5qMScGL+6jGrF6HfbhRefrh9rWxMSzJbsVp3POqjt
         B4u5kc9N6mDuiYCLqJfBqwnutWols44kx1ZrLpTDgvV3PIpXqF6OU7s5EyWfUaOR74qm
         9ueTDBjGOZAuQ6jfBtMoV2LQWTW1Vg24WCtbJNIVgOixDDz2kKEM1OO6h4QYK8AOVDdx
         fIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5SuoWo/qcxFa02IePOvfyCN8Bj+egwtwpWvLSt2OeZk=;
        fh=fslMPOhhycsHdEcSzazUJlk3iNWSDPasw2HP/EoFdWo=;
        b=fY3BeXUvqVnGUAkYxA+uMLWyBd0Er+IhPX3WQ3R5wGHJfVDNNp1WkOAAiHUY8WKg36
         uo3e/QU5n5x8QTrEhav8xP6viLUJSPLwzrYnj2Afuu66dcoY6jV1FRcltKiSzEayswkk
         WP5jF8ulkE7BwSyI4MlmiSWGb8gLyKllksETMrPuWvhSsRqaCBxUndU5+III1y4SBoe3
         WP9t9ERLIF69P34L3Y9boDD/VFmWVH0PuhWjMXr8oJ1YH/kBCL+dbf6s6Vb9aaxokDzS
         K5jGdFXTv90URr1vCDY6mYImOOmT9ai3iQnTmLvdUau3hDBU1r1COl0iJThPwDVOWjbC
         X6Rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789077100; x=1789681900; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5SuoWo/qcxFa02IePOvfyCN8Bj+egwtwpWvLSt2OeZk=;
        b=IkUO7+SKozN9BjZFjgCAqaBkbC+w5PhTp8QqwXNco0ZhvpWfuxaLcR1V5d3LyxoPeb
         7dkRIP+l4fg1oJwGrI3NBGnM7IWHlK5/C6V7U1ElmiafgcrixXlocKJAoqV5Yzil+Wz2
         VCk6QHJ3jyXPkRRdBD0nanNvOCfhO6uLw3cEbxOKmtU2Fpn7AZkrDRH5ecKr9yWPVu5m
         eHotDFzA+sAYTY/kkRZfl9XOUCs8RYljuLoK2MxpS6cU2JTyzdS3+qSZixm4zFXeT3Ix
         eMkmCo+M8ih07yFtfppJvxesQ6NixZPp3bPaCHYMAQhn72AIcTYqW5cUwHrJ2JbEN2fM
         nfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789077100; x=1789681900;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5SuoWo/qcxFa02IePOvfyCN8Bj+egwtwpWvLSt2OeZk=;
        b=N8QvJX/3WWjpItA+trk5bjaCJ/dAesYK5Zy342v9+k+GOqBL96SUahBFnY1cMTcX7n
         AixzFqw3u1/eI26iK6E/lDgcSwyAIXHtgPhCq3cINEFexuRNEJyQUnEL2fCsnjduLcEz
         ESy51oOPDxI3V5sW60cqm08jkPS78ymaZEmXdHZCZpwkDN6YvkeYR96RkqMCcLQ03iEl
         WAXIBSR4xgiNHnecdsdNe2wcjuz6Hj1h1ZJxpsctN/Td260+yCsci5vBatQWy/kPivps
         PVmoIdS8ebHw10bW+YYFKXMyBdRkc52+ky9iLWIl8QLJHSMOWNh9A+WMsvvowPeWzOlY
         k18A==
X-Forwarded-Encrypted: i=1; AKwUvBzisPAU6aNihGmycTMe9/5tJl/+Cbx02JE4cU0fJuwgGRDdACM6OPKgAy6NcPMplZTmACE1dJoLRy+iD/1bXNc=@vger.kernel.org
X-Gm-Message-State: AFuF++nssA7g9OeGweo3sDADM03bQp4oaKlitkxPPw6uRHXZ+kNNOR2z
	+TteIvIAKPv1JNobsJoL0drMYgvCVOd5v0SOc4ZPew9O8P9GDJKuJfFn4OnPSpi3Z5f+52otiSB
	Wt6H0xfuVDg1hmQ8po05vEIDPEuPtVp5itYziIoEZ
X-Gm-Gg: AYBFou2bj/GIru9XLUxx6QK1bqNiZCFPa/2xySkKHuxIq2rvAS6VzChpZUJ11n/+Otp
	Wj6dMY1g/zTEh/0kLF5t53q1z9Dxl4cWelCc3IfN/8AAkoqWn/XgfMZIMcDCg9OrXSfEkIZmfc2
	lzMNMLuJA7PYC7HCMKmL06yDzrYCPpkTnRbSgEbaxS4sCccbtWBdbLZ60cxp4UMZwRCn3XS/rPd
	pusf4K+F0pTNPDYJ/MOLsH3qFDDUw3n3noT2yT+E9KlWVieCppr3qoxq3KxL2rZlPWjwGS9GHpN
	zMfsX2zzOiAb/1NB9VVlqWKZwfc7m9yk6EcJ19NiDguJefIntWiHeVEyCUQvQREP6X2xv/4NJ1h
	ivaO2HHrnjusGKge+bSq5L3mB5lhzatGMYHLBdhJH
X-Received: by 2002:a05:6a00:4b4e:b0:84e:354:422b with SMTP id
 d2e1a72fcca58-86b100bc1a6mr1371801b3a.2.1789077098407; Thu, 10 Sep 2026
 14:51:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Thu, 10 Sep 2026 14:51:27 -0700
X-Gm-Features: AcwNN1Xd-D8JftvAWLwFYH-u_F_XMldqhEIkq-mPDSztt6wnPgNveRvqXECB3VI
Message-ID: <CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com>
Subject: [BUG] WARNING in dev_fill_forward_path
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Farhad Alemi <falemi@asu.edu>, Simon Horman <horms@kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000ee1c1a065b27f8cd"

--000000000000ee1c1a065b27f8cd
Content-Type: text/plain; charset="UTF-8"

Hello,

We are reporting the following crash (reproducer attached and a
proposed patch forthcoming):
Linux version 7.3.0-rc2 50d05c7c76c96b90462f24debacca971d2e86713
Build Config: UpstreamAppArmorKASAN (KASAN + UBSAN, panic_on_warn=1)


[   45.799560][ T9488] last_dev == ctx->dev
[   45.799566][ T9488] WARNING: net/core/dev.c:792 at
dev_fill_forward_path+0x4bf/0x560, CPU#1: repro/9488
[   45.801619][ T9488] Modules linked in:
[   45.802014][ T9488] CPU: 1 UID: 0 PID: 9488 Comm: repro Not tainted
7.3.0-rc2-00099-g50d05c7c76c9 #1 PREEMPT(full)
[   45.803017][ T9488] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[   45.804019][ T9488] RIP: 0010:dev_fill_forward_path+0x4bf/0x560
[   45.804616][ T9488] Code: 48 8b 44 24 08 42 0f b6 04 28 84 c0 0f 85
93 00 00 00 41 ff 07 e9 c4 fd ff ff e8 cc 1a 2e f8 e9 f2 fd ff ff e8
c2 1a 2e f8 90 <0f> 0b 90 e9 e8 fd ff ff 44 89 f9 80 e1 07 80 c1 03 38
c1 0f 8c 68
[   45.806463][ T9488] RSP: 0018:ffffc9000276e988 EFLAGS: 00010293
[   45.807057][ T9488] RAX: ffffffff899981be RBX: ffff888106e34000
RCX: ffff8881129f0000
[   45.807826][ T9488] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[   45.808575][ T9488] RBP: 0000000000000000 R08: ffff8881061ad443
R09: 1ffff11020c35a88
[   45.809387][ T9488] R10: dffffc0000000000 R11: ffffed1020c35a89
R12: ffffc9000276eae0
[   45.810156][ T9488] R13: dffffc0000000000 R14: ffffc9000276eaa0
R15: ffff888106e34000
[   45.810906][ T9488] FS:  000000003e3ab400(0000)
GS:ffff8881da588000(0000) knlGS:0000000000000000
[   45.811743][ T9488] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.812356][ T9488] CR2: 00005653de6aef80 CR3: 0000000028114000
CR4: 0000000000752ef0
[   45.813109][ T9488] PKRU: 55555554
[   45.813466][ T9488] Call Trace:
[   45.813791][ T9488]  <TASK>
[   45.814082][ T9488]  nft_dev_forward_path+0x4a3/0x1d60
[   45.814595][ T9488]  ? dst_init+0xd9/0x480
[   45.815004][ T9488]  ? dst_alloc+0x12a/0x170
[   45.815435][ T9488]  ? ip_route_output_key_hash_rcu+0x14d0/0x25d0
[   45.816031][ T9488]  ? nft_do_chain_ipv4+0x195/0x290
[   45.816528][ T9488]  ? NF_HOOK+0x25a/0x3b0
[   45.816940][ T9488]  ? netif_receive_skb+0x45b/0xbf0
[   45.817435][ T9488]  ? tun_rx_batched+0x1de/0x790
[   45.817901][ T9488]  ? tun_get_user+0x2c20/0x4490
[   45.818368][ T9488]  ? trace_kmem_cache_alloc+0x29/0xe0
[   45.818890][ T9488]  ? dst_alloc+0x105/0x170
[   45.819375][ T9488]  ? __pfx_nft_dev_forward_path+0x10/0x10
[   45.819938][ T9488]  ? rt_cache_route+0x229/0x2a0
[   45.820450][ T9488]  ? __pfx_ip_route_output_key_hash+0x10/0x10
[   45.821032][ T9488]  ? _raw_spin_unlock_irqrestore+0x4c/0x80
[   45.821596][ T9488]  ? ip_route_output_flow+0xe6/0x150
[   45.822095][ T9488]  nft_flow_route+0x8c0/0xdd0
[   45.822562][ T9488]  ? __pfx_nft_flow_route+0x10/0x10
[   45.823068][ T9488]  nft_flow_offload_eval+0x6a6/0xae0
[   45.823585][ T9488]  ? __pfx_nft_flow_offload_eval+0x10/0x10
[   45.824145][ T9488]  nft_do_chain+0x48d/0x1b10
[   45.824607][ T9488]  ? stack_depot_save_flags+0x33/0x7f0
[   45.825133][ T9488]  ? kasan_save_track+0x3e/0x80
[   45.825618][ T9488]  ? __pfx_nft_do_chain+0x10/0x10
[   45.826097][ T9488]  ? ip_forward+0xc58/0x1520
[   45.826587][ T9488]  ? __lock_acquire+0x74c/0x2db0
[   45.827087][ T9488]  nft_do_chain_ipv4+0x195/0x290
[   45.827593][ T9488]  ? __pfx_nft_do_chain_ipv4+0x10/0x10
[   45.828123][ T9488]  ? lock_acquire+0x115/0x350
[   45.828591][ T9488]  ? __pfx_nft_do_chain_ipv4+0x10/0x10
[   45.829203][ T9488]  nf_hook_slow+0xc5/0x220
[   45.829670][ T9488]  NF_HOOK+0x25a/0x3b0
[   45.830080][ T9488]  ? NF_HOOK+0xf6/0x3b0
[   45.830505][ T9488]  ? __pfx_NF_HOOK+0x10/0x10
[   45.830933][ T9488]  ? __pfx_ip_forward_finish+0x10/0x10
[   45.831437][ T9488]  NF_HOOK+0x336/0x3c0
[   45.831814][ T9488]  ? sock_wfree+0x2aa/0x740
[   45.832236][ T9488]  ? __pfx_ip_rcv_finish+0x10/0x10
[   45.832746][ T9488]  ? NF_HOOK+0x9e/0x3c0
[   45.833150][ T9488]  ? __pfx_NF_HOOK+0x10/0x10
[   45.833600][ T9488]  ? __pfx_ip_rcv_finish+0x10/0x10
[   45.834082][ T9488]  ? netif_receive_skb+0x102/0xbf0
[   45.834551][ T9488]  ? __pfx_ip_rcv+0x10/0x10
[   45.834970][ T9488]  netif_receive_skb+0x45b/0xbf0
[   45.835427][ T9488]  ? __pfx_netif_receive_skb+0x10/0x10
[   45.835925][ T9488]  ? tun_rx_batched+0x185/0x790
[   45.836395][ T9488]  tun_rx_batched+0x1de/0x790
[   45.836856][ T9488]  ? __pfx_tun_rx_batched+0x10/0x10
[   45.837361][ T9488]  ? lock_acquire+0x115/0x350
[   45.837819][ T9488]  ? tun_get_user+0x23c9/0x4490
[   45.838276][ T9488]  ? __local_bh_enable_ip+0xd6/0x140
[   45.838758][ T9488]  tun_get_user+0x2c20/0x4490
[   45.839290][ T9488]  ? tun_get_user+0x27eb/0x4490
[   45.839779][ T9488]  ? aa_file_perm+0x192/0x15e0
[   45.840242][ T9488]  ? aa_file_perm+0x50e/0x15e0
[   45.840705][ T9488]  ? __pfx_tun_get_user+0x10/0x10
[   45.841190][ T9488]  ? __lock_acquire+0x74c/0x2db0
[   45.841683][ T9488]  ? ref_tracker_alloc+0x35c/0x4c0
[   45.842152][ T9488]  ? __pfx_ref_tracker_alloc+0x10/0x10
[   45.842653][ T9488]  ? lock_acquire+0x115/0x350
[   45.843087][ T9488]  ? tun_get+0x1c/0x2f0
[   45.843475][ T9488]  ? tun_get+0x1c/0x2f0
[   45.843858][ T9488]  ? tun_get+0x1c/0x2f0
[   45.844244][ T9488]  tun_chr_write_iter+0x113/0x200
[   45.844746][ T9488]  vfs_write+0x61d/0xb90
[   45.845164][ T9488]  ? __pfx_vfs_write+0x10/0x10
[   45.845646][ T9488]  ksys_write+0x150/0x270
[   45.846070][ T9488]  ? __pfx_ksys_write+0x10/0x10
[   45.846546][ T9488]  do_syscall_64+0x155/0x510
[   45.846996][ T9488]  ? trace_irq_disable+0x3b/0x140
[   45.847483][ T9488]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.848034][ T9488]  ? clear_bhb_loop+0x30/0x80
[   45.848494][ T9488]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.849110][ T9488] RIP: 0033:0x42fb46
[   45.849497][ T9488] Code: 47 ba 04 00 00 00 48 c7 c0 f0 ff ff ff 64
89 10 48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48
8b 45 10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e
0f 1f 84 00
[   45.851281][ T9488] RSP: 002b:00007ffe031de340 EFLAGS: 00000202
ORIG_RAX: 0000000000000001
[   45.852049][ T9488] RAX: ffffffffffffffda RBX: 0000000000000001
RCX: 000000000042fb46
[   45.852833][ T9488] RDX: 0000000000000032 RSI: 00007ffe031de4a0
RDI: 0000000000000003
[   45.853604][ T9488] RBP: 00007ffe031de350 R08: 0000000000000000
R09: 0000000000000000
[   45.854372][ T9488] R10: 0000000000000000 R11: 0000000000000202
R12: 00007ffe031de618
[   45.855123][ T9488] R13: 00007ffe031de628 R14: 0000000000000002
R15: 00000000004b0140
[   45.855915][ T9488]  </TASK>
[   45.856236][ T9488] Kernel panic - not syncing: kernel: panic_on_warn set ...
[   45.856927][ T9488] CPU: 1 UID: 0 PID: 9488 Comm: repro Not tainted
7.3.0-rc2-00099-g50d05c7c76c9 #1 PREEMPT(full)
[   45.857959][ T9488] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[   45.859245][ T9488] Call Trace:
[   45.859604][ T9488]  <TASK>
[   45.859928][ T9488]  vpanic+0x56d/0xa60
[   45.860335][ T9488]  ? __pfx__printk+0x10/0x10
[   45.860802][ T9488]  ? __pfx_vpanic+0x10/0x10
[   45.861238][ T9488]  ? is_bpf_text_address+0x292/0x2b0
[   45.861752][ T9488]  ? is_bpf_text_address+0x26/0x2b0
[   45.862255][ T9488]  panic+0xc5/0xd0
[   45.862626][ T9488]  ? __pfx_panic+0x10/0x10
[   45.863063][ T9488]  __warn+0x315/0x4c0
[   45.863453][ T9488]  ? dev_fill_forward_path+0x4bf/0x560
[   45.863974][ T9488]  ? dev_fill_forward_path+0x4bf/0x560
[   45.864498][ T9488]  __report_bug+0x273/0x580
[   45.864943][ T9488]  ? dev_fill_forward_path+0x4bf/0x560
[   45.865466][ T9488]  ? __pfx___report_bug+0x10/0x10
[   45.865954][ T9488]  ? __lock_acquire+0x74c/0x2db0
[   45.866435][ T9488]  ? ip_route_output_flow+0xe6/0x150
[   45.866946][ T9488]  ? dev_fill_forward_path+0x4bf/0x560
[   45.867469][ T9488]  report_bug+0x16b/0x220
[   45.867888][ T9488]  ? dev_fill_forward_path+0x4bf/0x560
[   45.868411][ T9488]  ? dev_fill_forward_path+0x4c1/0x560
[   45.868929][ T9488]  handle_bug+0x9c/0x200
[   45.869404][ T9488]  exc_invalid_op+0x1a/0x50
[   45.869841][ T9488]  asm_exc_invalid_op+0x1a/0x20
[   45.870311][ T9488] RIP: 0010:dev_fill_forward_path+0x4bf/0x560
[   45.870888][ T9488] Code: 48 8b 44 24 08 42 0f b6 04 28 84 c0 0f 85
93 00 00 00 41 ff 07 e9 c4 fd ff ff e8 cc 1a 2e f8 e9 f2 fd ff ff e8
c2 1a 2e f8 90 <0f> 0b 90 e9 e8 fd ff ff 44 89 f9 80 e1 07 80 c1 03 38
c1 0f 8c 68
[   45.872668][ T9488] RSP: 0018:ffffc9000276e988 EFLAGS: 00010293
[   45.873242][ T9488] RAX: ffffffff899981be RBX: ffff888106e34000
RCX: ffff8881129f0000
[   45.873988][ T9488] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[   45.874734][ T9488] RBP: 0000000000000000 R08: ffff8881061ad443
R09: 1ffff11020c35a88
[   45.875492][ T9488] R10: dffffc0000000000 R11: ffffed1020c35a89
R12: ffffc9000276eae0
[   45.876198][ T9488] R13: dffffc0000000000 R14: ffffc9000276eaa0
R15: ffff888106e34000
[   45.876957][ T9488]  ? dev_fill_forward_path+0x4be/0x560
[   45.877481][ T9488]  ? dev_fill_forward_path+0x4be/0x560
[   45.878000][ T9488]  nft_dev_forward_path+0x4a3/0x1d60
[   45.878507][ T9488]  ? dst_init+0xd9/0x480
[   45.878914][ T9488]  ? dst_alloc+0x12a/0x170
[   45.879436][ T9488]  ? ip_route_output_key_hash_rcu+0x14d0/0x25d0
[   45.880030][ T9488]  ? nft_do_chain_ipv4+0x195/0x290
[   45.880552][ T9488]  ? NF_HOOK+0x25a/0x3b0
[   45.880965][ T9488]  ? netif_receive_skb+0x45b/0xbf0
[   45.881457][ T9488]  ? tun_rx_batched+0x1de/0x790
[   45.881923][ T9488]  ? tun_get_user+0x2c20/0x4490
[   45.882393][ T9488]  ? trace_kmem_cache_alloc+0x29/0xe0
[   45.882907][ T9488]  ? dst_alloc+0x105/0x170
[   45.883366][ T9488]  ? __pfx_nft_dev_forward_path+0x10/0x10
[   45.883924][ T9488]  ? rt_cache_route+0x229/0x2a0
[   45.884420][ T9488]  ? __pfx_ip_route_output_key_hash+0x10/0x10
[   45.885014][ T9488]  ? _raw_spin_unlock_irqrestore+0x4c/0x80
[   45.885594][ T9488]  ? ip_route_output_flow+0xe6/0x150
[   45.886117][ T9488]  nft_flow_route+0x8c0/0xdd0
[   45.886588][ T9488]  ? __pfx_nft_flow_route+0x10/0x10
[   45.887115][ T9488]  nft_flow_offload_eval+0x6a6/0xae0
[   45.887635][ T9488]  ? __pfx_nft_flow_offload_eval+0x10/0x10
[   45.888176][ T9488]  nft_do_chain+0x48d/0x1b10
[   45.888639][ T9488]  ? stack_depot_save_flags+0x33/0x7f0
[   45.889215][ T9488]  ? kasan_save_track+0x3e/0x80
[   45.889693][ T9488]  ? __pfx_nft_do_chain+0x10/0x10
[   45.890175][ T9488]  ? ip_forward+0xc58/0x1520
[   45.890635][ T9488]  ? __lock_acquire+0x74c/0x2db0
[   45.891116][ T9488]  nft_do_chain_ipv4+0x195/0x290
[   45.891603][ T9488]  ? __pfx_nft_do_chain_ipv4+0x10/0x10
[   45.892103][ T9488]  ? lock_acquire+0x115/0x350
[   45.892566][ T9488]  ? __pfx_nft_do_chain_ipv4+0x10/0x10
[   45.893088][ T9488]  nf_hook_slow+0xc5/0x220
[   45.893522][ T9488]  NF_HOOK+0x25a/0x3b0
[   45.893918][ T9488]  ? NF_HOOK+0xf6/0x3b0
[   45.894324][ T9488]  ? __pfx_NF_HOOK+0x10/0x10
[   45.894771][ T9488]  ? __pfx_ip_forward_finish+0x10/0x10
[   45.895299][ T9488]  NF_HOOK+0x336/0x3c0
[   45.895694][ T9488]  ? sock_wfree+0x2aa/0x740
[   45.896113][ T9488]  ? __pfx_ip_rcv_finish+0x10/0x10
[   45.896613][ T9488]  ? NF_HOOK+0x9e/0x3c0
[   45.897015][ T9488]  ? __pfx_NF_HOOK+0x10/0x10
[   45.897466][ T9488]  ? __pfx_ip_rcv_finish+0x10/0x10
[   45.897958][ T9488]  ? netif_receive_skb+0x102/0xbf0
[   45.898453][ T9488]  ? __pfx_ip_rcv+0x10/0x10
[   45.898890][ T9488]  netif_receive_skb+0x45b/0xbf0
[   45.899436][ T9488]  ? __pfx_netif_receive_skb+0x10/0x10
[   45.899971][ T9488]  ? tun_rx_batched+0x185/0x790
[   45.900461][ T9488]  tun_rx_batched+0x1de/0x790
[   45.900915][ T9488]  ? __pfx_tun_rx_batched+0x10/0x10
[   45.901417][ T9488]  ? lock_acquire+0x115/0x350
[   45.901877][ T9488]  ? tun_get_user+0x23c9/0x4490
[   45.902348][ T9488]  ? __local_bh_enable_ip+0xd6/0x140
[   45.902856][ T9488]  tun_get_user+0x2c20/0x4490
[   45.903312][ T9488]  ? tun_get_user+0x27eb/0x4490
[   45.903787][ T9488]  ? aa_file_perm+0x192/0x15e0
[   45.904229][ T9488]  ? aa_file_perm+0x50e/0x15e0
[   45.904704][ T9488]  ? __pfx_tun_get_user+0x10/0x10
[   45.905188][ T9488]  ? __lock_acquire+0x74c/0x2db0
[   45.905674][ T9488]  ? ref_tracker_alloc+0x35c/0x4c0
[   45.906164][ T9488]  ? __pfx_ref_tracker_alloc+0x10/0x10
[   45.906688][ T9488]  ? lock_acquire+0x115/0x350
[   45.907141][ T9488]  ? tun_get+0x1c/0x2f0
[   45.907555][ T9488]  ? tun_get+0x1c/0x2f0
[   45.907939][ T9488]  ? tun_get+0x1c/0x2f0
[   45.908345][ T9488]  tun_chr_write_iter+0x113/0x200
[   45.908828][ T9488]  vfs_write+0x61d/0xb90
[   45.909311][ T9488]  ? __pfx_vfs_write+0x10/0x10
[   45.909777][ T9488]  ksys_write+0x150/0x270
[   45.910195][ T9488]  ? __pfx_ksys_write+0x10/0x10
[   45.910668][ T9488]  do_syscall_64+0x155/0x510
[   45.911115][ T9488]  ? trace_irq_disable+0x3b/0x140
[   45.911624][ T9488]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.912217][ T9488]  ? clear_bhb_loop+0x30/0x80
[   45.912685][ T9488]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.913264][ T9488] RIP: 0033:0x42fb46
[   45.913645][ T9488] Code: 47 ba 04 00 00 00 48 c7 c0 f0 ff ff ff 64
89 10 48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48
8b 45 10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e
0f 1f 84 00
[   45.915443][ T9488] RSP: 002b:00007ffe031de340 EFLAGS: 00000202
ORIG_RAX: 0000000000000001
[   45.916225][ T9488] RAX: ffffffffffffffda RBX: 0000000000000001
RCX: 000000000042fb46
[   45.916969][ T9488] RDX: 0000000000000032 RSI: 00007ffe031de4a0
RDI: 0000000000000003
[   45.917713][ T9488] RBP: 00007ffe031de350 R08: 0000000000000000
R09: 0000000000000000
[   45.918460][ T9488] R10: 0000000000000000 R11: 0000000000000202
R12: 00007ffe031de618
[   45.919267][ T9488] R13: 00007ffe031de628 R14: 0000000000000002
R15: 00000000004b0140
[   45.920021][ T9488]  </TASK>
[   45.920650][ T9488] Kernel Offset: disabled
[   45.921194][ T9488] Rebooting in 86400 seconds..

Regards,
SEFCOM Lab @ ASU

--000000000000ee1c1a065b27f8cd
Content-Type: application/octet-stream; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mtw2aw9f0>
X-Attachment-Id: f_mtw2aw9f0

LyoKICogMjE0LXdhcm5pbmctaW4tZGV2LWZpbGwtZm9yd2FyZC1wYXRoCiAqLwojZGVmaW5lIF9H
TlVfU09VUkNFCiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVk
ZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVkZSA8c3lzL3NvY2tldC5o
PgojaW5jbHVkZSA8bmV0L2lmLmg+CiNpbmNsdWRlIDxuZXRpbmV0L2luLmg+CiNpbmNsdWRlIDxh
cnBhL2luZXQuaD4KI2luY2x1ZGUgPGxpbnV4L2lmX3R1bi5oPgojaW5jbHVkZSA8bGludXgvaXAu
aD4KI2luY2x1ZGUgPGxpbnV4L3VkcC5oPgojaW5jbHVkZSA8bGludXgvbmV0bGluay5oPgojaW5j
bHVkZSA8bGludXgvcm91dGUuaD4KI2luY2x1ZGUgPGxpbnV4L3NvY2tpb3MuaD4KCi8qIGxpbnV4
L2lmX3R1bm5lbC5oIGlzIG5vdCBhbHdheXMgaW5zdGFsbGVkOyBTSU9DQUREVFVOTkVMIHRha2Vz
IHRoaXMgbGF5b3V0LiAqLwpzdHJ1Y3QgaXBfdHVubmVsX3Bhcm1fbG9jYWwgewoJY2hhcgkJbmFt
ZVtJRk5BTVNJWl07CglpbnQJCWxpbms7CglfX2JlMTYJCWlfZmxhZ3M7CglfX2JlMTYJCW9fZmxh
Z3M7CglfX2JlMzIJCWlfa2V5OwoJX19iZTMyCQlvX2tleTsKCXN0cnVjdCBpcGhkcglpcGg7Cn07
CiNpZm5kZWYgU0lPQ0FERFRVTk5FTAojZGVmaW5lIFNJT0NBRERUVU5ORUwgKFNJT0NERVZQUklW
QVRFICsgMSkKI2VuZGlmCgovKiBuZm5ldGxpbmsgLyBuZl90YWJsZXMgY29uc3RhbnRzIChsaW51
eC9uZXRmaWx0ZXIvbmZfdGFibGVzLmggbm90IGFzc3VtZWQpLiAqLwojZGVmaW5lIE5GTkxfU1VC
U1lTX05GVEFCTEVTCQkxMAojZGVmaW5lIE5GTkxfTVNHX0JBVENIX0JFR0lOCQkxNgojZGVmaW5l
IE5GTkxfTVNHX0JBVENIX0VORAkJMTcKI2RlZmluZSBORlRfTVNHX05FV1RBQkxFCQkwCiNkZWZp
bmUgTkZUX01TR19ORVdDSEFJTgkJMwojZGVmaW5lIE5GVF9NU0dfTkVXUlVMRQkJCTYKI2RlZmlu
ZSBORlRfTVNHX05FV0ZMT1dUQUJMRQkJMjIKI2RlZmluZSBORlRBX1RBQkxFX05BTUUJCQkxCiNk
ZWZpbmUgTkZUQV9DSEFJTl9UQUJMRQkJMQojZGVmaW5lIE5GVEFfQ0hBSU5fTkFNRQkJCTMKI2Rl
ZmluZSBORlRBX0NIQUlOX0hPT0sJCQk0CiNkZWZpbmUgTkZUQV9DSEFJTl9UWVBFCQkJNwojZGVm
aW5lIE5GVEFfSE9PS19IT09LTlVNCQkxCiNkZWZpbmUgTkZUQV9IT09LX1BSSU9SSVRZCQkyCiNk
ZWZpbmUgTkZUQV9SVUxFX1RBQkxFCQkJMQojZGVmaW5lIE5GVEFfUlVMRV9DSEFJTgkJCTIKI2Rl
ZmluZSBORlRBX1JVTEVfRVhQUkVTU0lPTlMJCTQKI2RlZmluZSBORlRBX0xJU1RfRUxFTQkJCTEK
I2RlZmluZSBORlRBX0VYUFJfTkFNRQkJCTEKI2RlZmluZSBORlRBX0VYUFJfREFUQQkJCTIKI2Rl
ZmluZSBORlRBX0ZMT1dfVEFCTEVfTkFNRQkJMQojZGVmaW5lIE5GVEFfRkxPV1RBQkxFX1RBQkxF
CQkxCiNkZWZpbmUgTkZUQV9GTE9XVEFCTEVfTkFNRQkJMgojZGVmaW5lIE5GVEFfRkxPV1RBQkxF
X0hPT0sJCTMKI2RlZmluZSBORlRBX0ZMT1dUQUJMRV9IT09LX05VTQkJMQojZGVmaW5lIE5GVEFf
RkxPV1RBQkxFX0hPT0tfUFJJT1JJVFkJMgojZGVmaW5lIE5GVEFfRkxPV1RBQkxFX0hPT0tfREVW
UwkzCiNkZWZpbmUgTkZUQV9ERVZJQ0VfTkFNRQkJMQojaWZuZGVmIE5MQV9GX05FU1RFRAojZGVm
aW5lIE5MQV9GX05FU1RFRCAoMSA8PCAxNSkKI2VuZGlmCgpzdHJ1Y3QgbmZnZW5tc2dfbG9jYWwg
eyBfX3U4IG5mZ2VuX2ZhbWlseTsgX191OCB2ZXJzaW9uOyBfX2JlMTYgcmVzX2lkOyB9OwoKLyog
T25lIG5mbmV0bGluayBiYXRjaCBpcyBhc3NlbWJsZWQgaGVyZSBhbmQgc2VudCB3aXRoIGEgc2lu
Z2xlIHNlbmR0bygpLiAqLwpzdGF0aWMgdW5zaWduZWQgY2hhciBuZnRfYmF0Y2hbMTYzODRdOwpz
dGF0aWMgc2l6ZV90IG5mdF9iYXRjaF9sZW47CnN0YXRpYyBzaXplX3QgY3VycmVudF9tc2dfb2Zm
c2V0OwpzdGF0aWMgdW5zaWduZWQgbmZ0X3NlcSA9IDE7CgpzdGF0aWMgc3RydWN0IG5sbXNnaGRy
ICpjdXJyZW50X25sbXNnKHZvaWQpCnsKCXJldHVybiAoc3RydWN0IG5sbXNnaGRyICopKG5mdF9i
YXRjaCArIGN1cnJlbnRfbXNnX29mZnNldCk7Cn0KCnN0YXRpYyB2b2lkIG5mdF9tc2dfYmVnaW4o
aW50IHR5cGUsIGludCBmbGFncywgaW50IGZhbWlseSwgaW50IHJlc19pZCkKewoJc3RydWN0IG5s
bXNnaGRyICpubGg7CglzdHJ1Y3QgbmZnZW5tc2dfbG9jYWwgKm5mZ2VuOwoKCWN1cnJlbnRfbXNn
X29mZnNldCA9IG5mdF9iYXRjaF9sZW47CglubGggPSBjdXJyZW50X25sbXNnKCk7CgltZW1zZXQo
bmxoLCAwLCBzaXplb2YoKm5saCkgKyBzaXplb2YoKm5mZ2VuKSk7CglubGgtPm5sbXNnX2xlbiA9
IE5MTVNHX0xFTkdUSChzaXplb2YoKm5mZ2VuKSk7CglubGgtPm5sbXNnX3R5cGUgPSB0eXBlOwoJ
bmxoLT5ubG1zZ19mbGFncyA9IGZsYWdzOwoJbmxoLT5ubG1zZ19zZXEgPSBuZnRfc2VxKys7Cglu
ZmdlbiA9IChzdHJ1Y3QgbmZnZW5tc2dfbG9jYWwgKilOTE1TR19EQVRBKG5saCk7CgluZmdlbi0+
bmZnZW5fZmFtaWx5ID0gZmFtaWx5OwoJbmZnZW4tPnJlc19pZCA9IGh0b25zKHJlc19pZCk7Cn0K
CnN0YXRpYyB2b2lkIG5mdF9tc2dfZW5kKHZvaWQpCnsKCW5mdF9iYXRjaF9sZW4gPSBjdXJyZW50
X21zZ19vZmZzZXQgKyBOTE1TR19BTElHTihjdXJyZW50X25sbXNnKCktPm5sbXNnX2xlbik7Cn0K
CnN0YXRpYyB2b2lkIHB1dF9hdHRyKGludCB0eXBlLCBjb25zdCB2b2lkICpkYXRhLCBpbnQgZGF0
YV9sZW4pCnsKCXN0cnVjdCBubG1zZ2hkciAqbmxoID0gY3VycmVudF9ubG1zZygpOwoJc3RydWN0
IG5sYXR0ciAqYXR0ciA9IChzdHJ1Y3QgbmxhdHRyICopKG5mdF9iYXRjaCArIGN1cnJlbnRfbXNn
X29mZnNldCArIG5saC0+bmxtc2dfbGVuKTsKCglhdHRyLT5ubGFfdHlwZSA9IHR5cGU7CglhdHRy
LT5ubGFfbGVuID0gTkxBX0hEUkxFTiArIGRhdGFfbGVuOwoJbWVtY3B5KChjaGFyICopYXR0ciAr
IE5MQV9IRFJMRU4sIGRhdGEsIGRhdGFfbGVuKTsKCW5saC0+bmxtc2dfbGVuICs9IE5MQV9BTElH
TihhdHRyLT5ubGFfbGVuKTsKfQoKc3RhdGljIHZvaWQgcHV0X2F0dHJfc3RyaW5nKGludCB0eXBl
LCBjb25zdCBjaGFyICpzdHIpCnsKCXB1dF9hdHRyKHR5cGUsIHN0ciwgc3RybGVuKHN0cikgKyAx
KTsKfQoKc3RhdGljIHZvaWQgcHV0X2F0dHJfYmUzMihpbnQgdHlwZSwgdW5zaWduZWQgdmFsdWUp
CnsKCXVuc2lnbmVkIGJpZ19lbmRpYW4gPSBodG9ubCh2YWx1ZSk7CgoJcHV0X2F0dHIodHlwZSwg
JmJpZ19lbmRpYW4sIDQpOwp9CgpzdGF0aWMgaW50IG5lc3RfYmVnaW4oaW50IHR5cGUpCnsKCXN0
cnVjdCBubG1zZ2hkciAqbmxoID0gY3VycmVudF9ubG1zZygpOwoJaW50IG5lc3Rfb2Zmc2V0ID0g
bmxoLT5ubG1zZ19sZW47CglzdHJ1Y3QgbmxhdHRyICphdHRyID0gKHN0cnVjdCBubGF0dHIgKiko
bmZ0X2JhdGNoICsgY3VycmVudF9tc2dfb2Zmc2V0ICsgbmVzdF9vZmZzZXQpOwoKCWF0dHItPm5s
YV90eXBlID0gdHlwZSB8IE5MQV9GX05FU1RFRDsKCWF0dHItPm5sYV9sZW4gPSBOTEFfSERSTEVO
OwoJbmxoLT5ubG1zZ19sZW4gKz0gTkxBX0hEUkxFTjsKCXJldHVybiBuZXN0X29mZnNldDsKfQoK
c3RhdGljIHZvaWQgbmVzdF9lbmQoaW50IG5lc3Rfb2Zmc2V0KQp7CglzdHJ1Y3Qgbmxtc2doZHIg
Km5saCA9IGN1cnJlbnRfbmxtc2coKTsKCXN0cnVjdCBubGF0dHIgKmF0dHIgPSAoc3RydWN0IG5s
YXR0ciAqKShuZnRfYmF0Y2ggKyBjdXJyZW50X21zZ19vZmZzZXQgKyBuZXN0X29mZnNldCk7CgoJ
YXR0ci0+bmxhX2xlbiA9IG5saC0+bmxtc2dfbGVuIC0gbmVzdF9vZmZzZXQ7Cn0KCi8qIHRhYmxl
IHQgKyBmbG93dGFibGUgZiBvbiBpbmdyZXNzX2RldiArIGZvcndhcmQgY2hhaW4gYyB3aXRoICJm
bG93IGFkZCBAZiIuICovCnN0YXRpYyB2b2lkIHNldHVwX25mdGFibGVzX2Zsb3d0YWJsZShjb25z
dCBjaGFyICppbmdyZXNzX2RldikKewoJaW50IG5ldGxpbmtfZmQ7CglzdHJ1Y3Qgc29ja2FkZHJf
bmwga2VybmVsX2FkZHI7CglpbnQgaG9va19uZXN0LCBkZXZzX25lc3QsIGV4cHJzX25lc3QsIGVs
ZW1fbmVzdCwgZXhwcl9kYXRhX25lc3Q7CgoJbmV0bGlua19mZCA9IHNvY2tldChBRl9ORVRMSU5L
LCBTT0NLX1JBVywgTkVUTElOS19ORVRGSUxURVIpOwoJbWVtc2V0KCZrZXJuZWxfYWRkciwgMCwg
c2l6ZW9mKGtlcm5lbF9hZGRyKSk7CglrZXJuZWxfYWRkci5ubF9mYW1pbHkgPSBBRl9ORVRMSU5L
OwoJYmluZChuZXRsaW5rX2ZkLCAoc3RydWN0IHNvY2thZGRyICopJmtlcm5lbF9hZGRyLCBzaXpl
b2Yoa2VybmVsX2FkZHIpKTsKCgluZnRfbXNnX2JlZ2luKE5GTkxfTVNHX0JBVENIX0JFR0lOLCBO
TE1fRl9SRVFVRVNULCBBRl9VTlNQRUMsIE5GTkxfU1VCU1lTX05GVEFCTEVTKTsKCW5mdF9tc2df
ZW5kKCk7CgoJbmZ0X21zZ19iZWdpbigoTkZOTF9TVUJTWVNfTkZUQUJMRVMgPDwgOCkgfCBORlRf
TVNHX05FV1RBQkxFLAoJCSAgICAgIE5MTV9GX1JFUVVFU1QgfCBOTE1fRl9DUkVBVEUgfCBOTE1f
Rl9BQ0ssIEFGX0lORVQsIDApOwoJcHV0X2F0dHJfc3RyaW5nKE5GVEFfVEFCTEVfTkFNRSwgInQi
KTsKCW5mdF9tc2dfZW5kKCk7CgoJbmZ0X21zZ19iZWdpbigoTkZOTF9TVUJTWVNfTkZUQUJMRVMg
PDwgOCkgfCBORlRfTVNHX05FV0ZMT1dUQUJMRSwKCQkgICAgICBOTE1fRl9SRVFVRVNUIHwgTkxN
X0ZfQ1JFQVRFIHwgTkxNX0ZfQUNLLCBBRl9JTkVULCAwKTsKCXB1dF9hdHRyX3N0cmluZyhORlRB
X0ZMT1dUQUJMRV9UQUJMRSwgInQiKTsKCXB1dF9hdHRyX3N0cmluZyhORlRBX0ZMT1dUQUJMRV9O
QU1FLCAiZiIpOwoJaG9va19uZXN0ID0gbmVzdF9iZWdpbihORlRBX0ZMT1dUQUJMRV9IT09LKTsK
CXB1dF9hdHRyX2JlMzIoTkZUQV9GTE9XVEFCTEVfSE9PS19OVU0sIDApOwkvKiBORl9ORVRERVZf
SU5HUkVTUyAqLwoJcHV0X2F0dHJfYmUzMihORlRBX0ZMT1dUQUJMRV9IT09LX1BSSU9SSVRZLCAw
KTsKCWRldnNfbmVzdCA9IG5lc3RfYmVnaW4oTkZUQV9GTE9XVEFCTEVfSE9PS19ERVZTKTsKCXB1
dF9hdHRyX3N0cmluZyhORlRBX0RFVklDRV9OQU1FLCBpbmdyZXNzX2Rldik7CgluZXN0X2VuZChk
ZXZzX25lc3QpOwoJbmVzdF9lbmQoaG9va19uZXN0KTsKCW5mdF9tc2dfZW5kKCk7CgoJbmZ0X21z
Z19iZWdpbigoTkZOTF9TVUJTWVNfTkZUQUJMRVMgPDwgOCkgfCBORlRfTVNHX05FV0NIQUlOLAoJ
CSAgICAgIE5MTV9GX1JFUVVFU1QgfCBOTE1fRl9DUkVBVEUgfCBOTE1fRl9BQ0ssIEFGX0lORVQs
IDApOwoJcHV0X2F0dHJfc3RyaW5nKE5GVEFfQ0hBSU5fVEFCTEUsICJ0Iik7CglwdXRfYXR0cl9z
dHJpbmcoTkZUQV9DSEFJTl9OQU1FLCAiYyIpOwoJaG9va19uZXN0ID0gbmVzdF9iZWdpbihORlRB
X0NIQUlOX0hPT0spOwoJcHV0X2F0dHJfYmUzMihORlRBX0hPT0tfSE9PS05VTSwgMik7CQkvKiBO
Rl9JTkVUX0ZPUldBUkQgKi8KCXB1dF9hdHRyX2JlMzIoTkZUQV9IT09LX1BSSU9SSVRZLCAwKTsK
CW5lc3RfZW5kKGhvb2tfbmVzdCk7CglwdXRfYXR0cl9zdHJpbmcoTkZUQV9DSEFJTl9UWVBFLCAi
ZmlsdGVyIik7CgluZnRfbXNnX2VuZCgpOwoKCW5mdF9tc2dfYmVnaW4oKE5GTkxfU1VCU1lTX05G
VEFCTEVTIDw8IDgpIHwgTkZUX01TR19ORVdSVUxFLAoJCSAgICAgIE5MTV9GX1JFUVVFU1QgfCBO
TE1fRl9DUkVBVEUgfCBOTE1fRl9BUFBFTkQgfCBOTE1fRl9BQ0ssIEFGX0lORVQsIDApOwoJcHV0
X2F0dHJfc3RyaW5nKE5GVEFfUlVMRV9UQUJMRSwgInQiKTsKCXB1dF9hdHRyX3N0cmluZyhORlRB
X1JVTEVfQ0hBSU4sICJjIik7CglleHByc19uZXN0ID0gbmVzdF9iZWdpbihORlRBX1JVTEVfRVhQ
UkVTU0lPTlMpOwoJZWxlbV9uZXN0ID0gbmVzdF9iZWdpbihORlRBX0xJU1RfRUxFTSk7CglwdXRf
YXR0cl9zdHJpbmcoTkZUQV9FWFBSX05BTUUsICJmbG93X29mZmxvYWQiKTsKCWV4cHJfZGF0YV9u
ZXN0ID0gbmVzdF9iZWdpbihORlRBX0VYUFJfREFUQSk7CglwdXRfYXR0cl9zdHJpbmcoTkZUQV9G
TE9XX1RBQkxFX05BTUUsICJmIik7CgluZXN0X2VuZChleHByX2RhdGFfbmVzdCk7CgluZXN0X2Vu
ZChlbGVtX25lc3QpOwoJbmVzdF9lbmQoZXhwcnNfbmVzdCk7CgluZnRfbXNnX2VuZCgpOwoKCW5m
dF9tc2dfYmVnaW4oTkZOTF9NU0dfQkFUQ0hfRU5ELCBOTE1fRl9SRVFVRVNULCBBRl9VTlNQRUMs
IE5GTkxfU1VCU1lTX05GVEFCTEVTKTsKCW5mdF9tc2dfZW5kKCk7CgoJLyogbmZuZXRsaW5rIHBy
b2Nlc3NlcyB0aGUgd2hvbGUgYmF0Y2ggc3luY2hyb25vdXNseSBpbnNpZGUgc2VuZHRvKCkuICov
CglzZW5kdG8obmV0bGlua19mZCwgbmZ0X2JhdGNoLCBuZnRfYmF0Y2hfbGVuLCAwLAoJICAgICAg
IChzdHJ1Y3Qgc29ja2FkZHIgKikma2VybmVsX2FkZHIsIHNpemVvZihrZXJuZWxfYWRkcikpOwoJ
Y2xvc2UobmV0bGlua19mZCk7Cn0KCnN0YXRpYyB2b2lkIGludGVyZmFjZV91cChpbnQgaW9jdGxf
c29ja2V0LCBjb25zdCBjaGFyICpuYW1lKQp7CglzdHJ1Y3QgaWZyZXEgaWZyOwoKCW1lbXNldCgm
aWZyLCAwLCBzaXplb2YoaWZyKSk7CglzdHJuY3B5KGlmci5pZnJfbmFtZSwgbmFtZSwgSUZOQU1T
SVogLSAxKTsKCWlvY3RsKGlvY3RsX3NvY2tldCwgU0lPQ0dJRkZMQUdTLCAmaWZyKTsKCWlmci5p
ZnJfZmxhZ3MgfD0gSUZGX1VQIHwgSUZGX1JVTk5JTkc7Cglpb2N0bChpb2N0bF9zb2NrZXQsIFNJ
T0NTSUZGTEFHUywgJmlmcik7Cn0KCnN0YXRpYyB2b2lkIHNldF9pbnRlcmZhY2VfYWRkcmVzcyhp
bnQgaW9jdGxfc29ja2V0LCBjb25zdCBjaGFyICpuYW1lLAoJCQkJICBjb25zdCBjaGFyICphZGRy
ZXNzLCBjb25zdCBjaGFyICpuZXRtYXNrKQp7CglzdHJ1Y3QgaWZyZXEgaWZyOwoJc3RydWN0IHNv
Y2thZGRyX2luICpzaW47CgoJbWVtc2V0KCZpZnIsIDAsIHNpemVvZihpZnIpKTsKCXN0cm5jcHko
aWZyLmlmcl9uYW1lLCBuYW1lLCBJRk5BTVNJWiAtIDEpOwoJc2luID0gKHN0cnVjdCBzb2NrYWRk
cl9pbiAqKSZpZnIuaWZyX2FkZHI7CglzaW4tPnNpbl9mYW1pbHkgPSBBRl9JTkVUOwoJc2luLT5z
aW5fYWRkci5zX2FkZHIgPSBpbmV0X2FkZHIoYWRkcmVzcyk7Cglpb2N0bChpb2N0bF9zb2NrZXQs
IFNJT0NTSUZBRERSLCAmaWZyKTsKCgltZW1zZXQoJmlmciwgMCwgc2l6ZW9mKGlmcikpOwoJc3Ry
bmNweShpZnIuaWZyX25hbWUsIG5hbWUsIElGTkFNU0laIC0gMSk7CglzaW4gPSAoc3RydWN0IHNv
Y2thZGRyX2luICopJmlmci5pZnJfbmV0bWFzazsKCXNpbi0+c2luX2ZhbWlseSA9IEFGX0lORVQ7
CglzaW4tPnNpbl9hZGRyLnNfYWRkciA9IGluZXRfYWRkcihuZXRtYXNrKTsKCWlvY3RsKGlvY3Rs
X3NvY2tldCwgU0lPQ1NJRk5FVE1BU0ssICZpZnIpOwp9CgpzdGF0aWMgdm9pZCB3cml0ZV9wcm9j
X2ZpbGUoY29uc3QgY2hhciAqcGF0aCwgY29uc3QgY2hhciAqdmFsdWUpCnsKCWludCBmZCA9IG9w
ZW4ocGF0aCwgT19XUk9OTFkpOwoKCWlmIChmZCA8IDApCgkJcmV0dXJuOwoJd3JpdGUoZmQsIHZh
bHVlLCBzdHJsZW4odmFsdWUpKTsKCWNsb3NlKGZkKTsKfQoKc3RhdGljIHVuc2lnbmVkIHNob3J0
IGlwX2hlYWRlcl9jaGVja3N1bShjb25zdCB2b2lkICpoZWFkZXIsIGludCBuYnl0ZXMpCnsKCWNv
bnN0IHVuc2lnbmVkIGNoYXIgKmJ5dGVzID0gaGVhZGVyOwoJdW5zaWduZWQgbG9uZyBzdW0gPSAw
OwoKCXdoaWxlIChuYnl0ZXMgPiAxKSB7CgkJc3VtICs9IChieXRlc1swXSA8PCA4KSB8IGJ5dGVz
WzFdOwoJCWJ5dGVzICs9IDI7CgkJbmJ5dGVzIC09IDI7Cgl9CglpZiAobmJ5dGVzKQoJCXN1bSAr
PSBieXRlc1swXSA8PCA4OwoJd2hpbGUgKHN1bSA+PiAxNikKCQlzdW0gPSAoc3VtICYgMHhmZmZm
KSArIChzdW0gPj4gMTYpOwoJcmV0dXJuIGh0b25zKH5zdW0gJiAweGZmZmYpOwp9CgppbnQgbWFp
bih2b2lkKQp7CglpbnQgdGFwX2ZkLCBpb2N0bF9zb2NrZXQsIGl0ZXJhdGlvbjsKCXN0cnVjdCBp
ZnJlcSBpZnI7CglzdHJ1Y3QgaXBfdHVubmVsX3Bhcm1fbG9jYWwgdHVubmVsX3Bhcm07CglzdHJ1
Y3QgcnRlbnRyeSB0dW5uZWxfcm91dGU7CglzdHJ1Y3Qgc29ja2FkZHJfaW4gKnNpbjsKCXVuc2ln
bmVkIGNoYXIgZnJhbWVbNjRdOwoJc3RydWN0IGlwaGRyICppcF9oZWFkZXI7CglzdHJ1Y3QgdWRw
aGRyICp1ZHBfaGVhZGVyOwoKCXRhcF9mZCA9IG9wZW4oIi9kZXYvbmV0L3R1biIsIE9fUkRXUik7
CglpZiAodGFwX2ZkIDwgMCkKCQlyZXR1cm4gMTsKCW1lbXNldCgmaWZyLCAwLCBzaXplb2YoaWZy
KSk7CglpZnIuaWZyX2ZsYWdzID0gSUZGX1RBUCB8IElGRl9OT19QSTsKCXN0cmNweShpZnIuaWZy
X25hbWUsICJ0YXAwIik7CglpZiAoaW9jdGwodGFwX2ZkLCBUVU5TRVRJRkYsICZpZnIpIDwgMCkK
CQlyZXR1cm4gMTsKCglpb2N0bF9zb2NrZXQgPSBzb2NrZXQoQUZfSU5FVCwgU09DS19ER1JBTSwg
MCk7CglzZXRfaW50ZXJmYWNlX2FkZHJlc3MoaW9jdGxfc29ja2V0LCAidGFwMCIsICIxMC4wLjAu
MSIsICIyNTUuMjU1LjI1NS4wIik7CglpbnRlcmZhY2VfdXAoaW9jdGxfc29ja2V0LCAidGFwMCIp
OwoJd3JpdGVfcHJvY19maWxlKCIvcHJvYy9zeXMvbmV0L2lwdjQvaXBfZm9yd2FyZCIsICIxIik7
CgoJLyogaXBpcDA6IGxvY2FsIDEwLjAuMC4xLCByZW1vdGUgMTAuOS4wLjkuICBDcmVhdGVkIHZp
YSB0aGUgZmFsbGJhY2sKCSAgIGRldmljZSB0dW5sMCwgd2hpY2ggb3ducyB0aGUgaXBpcCBTSU9D
QUREVFVOTkVMIGhhbmRsZXIuICovCgltZW1zZXQoJnR1bm5lbF9wYXJtLCAwLCBzaXplb2YodHVu
bmVsX3Bhcm0pKTsKCXN0cmNweSh0dW5uZWxfcGFybS5uYW1lLCAiaXBpcDAiKTsKCXR1bm5lbF9w
YXJtLmlwaC52ZXJzaW9uID0gNDsKCXR1bm5lbF9wYXJtLmlwaC5paGwgPSA1OwoJdHVubmVsX3Bh
cm0uaXBoLnByb3RvY29sID0gSVBQUk9UT19JUElQOwoJdHVubmVsX3Bhcm0uaXBoLnR0bCA9IDY0
OwoJdHVubmVsX3Bhcm0uaXBoLnNhZGRyID0gaW5ldF9hZGRyKCIxMC4wLjAuMSIpOwoJdHVubmVs
X3Bhcm0uaXBoLmRhZGRyID0gaW5ldF9hZGRyKCIxMC45LjAuOSIpOwoJbWVtc2V0KCZpZnIsIDAs
IHNpemVvZihpZnIpKTsKCXN0cmNweShpZnIuaWZyX25hbWUsICJ0dW5sMCIpOwoJaWZyLmlmcl9k
YXRhID0gKHZvaWQgKikmdHVubmVsX3Bhcm07Cglpb2N0bChpb2N0bF9zb2NrZXQsIFNJT0NBRERU
VU5ORUwsICZpZnIpOwoJaW50ZXJmYWNlX3VwKGlvY3RsX3NvY2tldCwgImlwaXAwIik7CgoJLyog
cm91dGUgMTAuOS4wLjAvMjQgZGV2IGlwaXAwIC0tIHRoaXMgaXMgdGhlIHNlbGYtbG9vcCB0aGF0
IG1ha2VzIHRoZQoJICAgdHVubmVsJ3Mgb3duIHJlbW90ZSBhZGRyZXNzIHJlc29sdmUgYmFjayBv
dXQgb2YgdGhlIHR1bm5lbC4gKi8KCW1lbXNldCgmdHVubmVsX3JvdXRlLCAwLCBzaXplb2YodHVu
bmVsX3JvdXRlKSk7CglzaW4gPSAoc3RydWN0IHNvY2thZGRyX2luICopJnR1bm5lbF9yb3V0ZS5y
dF9kc3Q7CglzaW4tPnNpbl9mYW1pbHkgPSBBRl9JTkVUOwoJc2luLT5zaW5fYWRkci5zX2FkZHIg
PSBpbmV0X2FkZHIoIjEwLjkuMC4wIik7CglzaW4gPSAoc3RydWN0IHNvY2thZGRyX2luICopJnR1
bm5lbF9yb3V0ZS5ydF9nZW5tYXNrOwoJc2luLT5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKCXNpbi0+
c2luX2FkZHIuc19hZGRyID0gaW5ldF9hZGRyKCIyNTUuMjU1LjI1NS4wIik7CglzaW4gPSAoc3Ry
dWN0IHNvY2thZGRyX2luICopJnR1bm5lbF9yb3V0ZS5ydF9nYXRld2F5OwoJc2luLT5zaW5fZmFt
aWx5ID0gQUZfSU5FVDsKCXR1bm5lbF9yb3V0ZS5ydF9mbGFncyA9IFJURl9VUDsKCXR1bm5lbF9y
b3V0ZS5ydF9kZXYgPSAoY2hhciAqKSJpcGlwMCI7Cglpb2N0bChpb2N0bF9zb2NrZXQsIFNJT0NB
RERSVCwgJnR1bm5lbF9yb3V0ZSk7CgoJc2V0dXBfbmZ0YWJsZXNfZmxvd3RhYmxlKCJ0YXAwIik7
CgoJbWVtc2V0KGZyYW1lLCAwLCBzaXplb2YoZnJhbWUpKTsKCWZyYW1lWzZdID0gMHgwMjsgZnJh
bWVbMTFdID0gMHgwMjsJCS8qIHNvdXJjZSBNQUMgKi8KCWZyYW1lWzEyXSA9IDB4MDg7IGZyYW1l
WzEzXSA9IDB4MDA7CQkvKiBFVEhfUF9JUCAqLwoJaXBfaGVhZGVyID0gKHN0cnVjdCBpcGhkciAq
KShmcmFtZSArIDE0KTsKCXVkcF9oZWFkZXIgPSAoc3RydWN0IHVkcGhkciAqKShmcmFtZSArIDE0
ICsgMjApOwoJaXBfaGVhZGVyLT52ZXJzaW9uID0gNDsKCWlwX2hlYWRlci0+aWhsID0gNTsKCWlw
X2hlYWRlci0+dG90X2xlbiA9IGh0b25zKDIwICsgOCArIDgpOwoJaXBfaGVhZGVyLT5pZCA9IGh0
b25zKDB4MTIzNCk7CglpcF9oZWFkZXItPnR0bCA9IDY0OwoJaXBfaGVhZGVyLT5wcm90b2NvbCA9
IElQUFJPVE9fVURQOwoJaXBfaGVhZGVyLT5zYWRkciA9IGluZXRfYWRkcigiMTAuMC4wLjIiKTsK
CWlwX2hlYWRlci0+ZGFkZHIgPSBpbmV0X2FkZHIoIjEwLjkuMC41Iik7CS8qIGZvcndhcmRlZCBv
dXQgaXBpcDAgKi8KCWlwX2hlYWRlci0+Y2hlY2sgPSBpcF9oZWFkZXJfY2hlY2tzdW0oaXBfaGVh
ZGVyLCAyMCk7Cgl1ZHBfaGVhZGVyLT5zb3VyY2UgPSBodG9ucygxMjM0KTsKCXVkcF9oZWFkZXIt
PmRlc3QgPSBodG9ucyg1Njc4KTsKCXVkcF9oZWFkZXItPmxlbiA9IGh0b25zKDggKyA4KTsKCgkv
KiBUd28gdGhpbmdzIGZvcmNlIGEgbG9vcCByYXRoZXIgdGhhbiBhIHNpbmdsZSB3cml0ZSgpLiAg
dWRldiByZXdyaXRlcyB0aGUKCSAgIE1BQyBvZiBhIGZyZXNobHkgY3JlYXRlZCB0YXAgZGV2aWNl
IGEgZmV3IGh1bmRyZWQgbXMgYWZ0ZXIgaXQgYXBwZWFycywgYW5kCgkgICBhIGZyYW1lIHdob3Nl
IGRlc3RpbmF0aW9uIE1BQyBpcyBzdGFsZSBpcyBjb3VudGVkIGFzIG90aGVyaG9zdCBhbmQgbmV2
ZXIKCSAgIHJlYWNoZXMgaXBfcmN2IC0tIHNvIHRoZSBkZXN0aW5hdGlvbiBNQUMgaXMgcmVmcmVz
aGVkIG9uIGV2ZXJ5IHBhc3MuICBBbmQKCSAgIHRoZSBmaXJzdCBhY2NlcHRlZCBwYWNrZXQgb25s
eSBjcmVhdGVzIHRoZSBjb25udHJhY2sgZW50cnk7CgkgICBuZnRfZmxvd19vZmZsb2FkX2V2YWwo
KSBiYWlscyBvdXQgdW50aWwgbmZfY3RfaXNfY29uZmlybWVkKCksIHNvIHRoZQoJICAgb2ZmbG9h
ZCBwYXRoIGlzIGVudGVyZWQgYnkgYSBsYXRlciBwYWNrZXQuICovCglmb3IgKGl0ZXJhdGlvbiA9
IDA7IGl0ZXJhdGlvbiA8IDUwOyBpdGVyYXRpb24rKykgewoJCW1lbXNldCgmaWZyLCAwLCBzaXpl
b2YoaWZyKSk7CgkJc3RyY3B5KGlmci5pZnJfbmFtZSwgInRhcDAiKTsKCQlpZiAoaW9jdGwoaW9j
dGxfc29ja2V0LCBTSU9DR0lGSFdBRERSLCAmaWZyKSA9PSAwKQoJCQltZW1jcHkoZnJhbWUsIGlm
ci5pZnJfaHdhZGRyLnNhX2RhdGEsIDYpOwkvKiBkZXN0aW5hdGlvbiBNQUMgKi8KCQl3cml0ZSh0
YXBfZmQsIGZyYW1lLCAxNCArIDIwICsgOCArIDgpOwoJCXVzbGVlcCgyMDAwMCk7Cgl9CglyZXR1
cm4gMDsKfQo=
--000000000000ee1c1a065b27f8cd--
