Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B647A27EFEF
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695828; cv=none; b=u5AdVQPs5n+0dB4DYGPtoG8dUhkQrnCQ1EGWRWsCA59YgpeGMhpMJOlcT9Lu+0roBXsPZdWxvk2nzzmKTMAreejGUJTvZqVSCx3jrs8myeU9E2oB86tw98FeuDJgBdQdpwx0nGHuvbkgA+hehtYQoe1b7XzyoBwdYhsF/asi5pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695828; c=relaxed/simple;
	bh=VBz1KWhFCpG8jWrLgoBKbwZBD5H16rQ3iUyc84d5BWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PdqEYx9AWXYS+SOa1bEviILLTH7zYC87xkZrVD7OpbxiTUsT4uYTYO727gYPs1hV4n15ZuhniVvXJmFY32cEPpgSerYRFt2w/5U94kE8mBOSG8X3sY7b7HfqJVudd366+nFIisuH1Pd0koXkv5KuGOm7skU6cJ3UuAiB7d9E7JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BiuQRenX; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BiuQRenX"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b289cdc86aso16002391cf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 06:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755695825; x=1756300625; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLhF8h1sqXy3sl3VwtKNT/mJ1yJVmt1iTz/LotLfR2E=;
        b=BiuQRenXBV7UfXMFPFwnroKc37taQYxlynjkSp7OFtuHm4yrgTSRktaliW1avyKnR2
         QHGhgALBVc2FNHzeg4BdBcl3DCjaxS1d921+XaJfOoVxld+iPcOUrVtw4dsi7cUo5wFs
         /88JBh+MfnrDFqs/tydARoFMvbYAHvLtYcG75Es4XlCbpJNIKbNREdsILs2jsusPLRJM
         kfbwtHQljhwavXzrN08CYVRDGZQFJ4khAjMQDSw6lt4Hvgtm9h7WmQsay5MftCE42inb
         EorlFB1fdOaFc4pyxqP2DFUOJP0REKf4VsosuMKxn6ffRt6YMlfoPiP5s1KbvfOGj6sT
         vbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755695825; x=1756300625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLhF8h1sqXy3sl3VwtKNT/mJ1yJVmt1iTz/LotLfR2E=;
        b=BNJW017bTw8fz4ZoIB1zjONNK4imX7RczCLN4Br727xDy1JfQPmlghKZWjPTFncVoT
         1f7A+afntMvhDqsZGdR/v7YDtMHqZ0K810ZpOWoo6C0QeMpRJyGvKaTpNZCVCKwVhTgT
         tvwAufomGFKiWhG/lOTODWwmwsT2hyjQL8oPnKcNuFvE+TEE2Ro+JYE1sUr1eMk4HwpP
         h8qL/U47UC982ENSB4JCaArdCo+29kKd0dw0Fj4n/8X1buBQs5lzMEvlaG8GgmdfYcJP
         NV4g61XCwpM7QqW081DuR/IM6TDMLPcvtV0hpR0twKivkjb/rtNwlE1F7gUHzyhD9pL3
         HJ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjSJ2RcemY/m55ivwQZhrL/C9YSIBk1iWiPUsk3ovoq7jYrDsaMciwytppPWD35U9AQxqaENGHIcH1sz5+2OU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd5q0ld1YH6iWjxwWcMaWD09UZvRfgNWYJoTKtP9jgn5ydOfOD
	ltnZe/1RhQW7jp33hNY7AomZ6Rx1xSK6aXembh67bvt2hNdmFPEiyQ6/mVhvqGdyK2UW3Ttb87I
	tKvaa0CmTgsCzW1Ht2+4+ruVEQCsrvU2FDIxEWQaD
X-Gm-Gg: ASbGncsuuezrcF2OBQFctkQu63CVAIvrDJ2+gRfeGNhap73q9Niyt1Fd5vCPxTyrJ14
	XKKv0MicyTirwiRdhUP1CSPdpeO+OBmMOVZpleLOPDDe4c3c7DHH1Q4AF7NBniXsSKwOM1c7MOm
	Hj3dizrr/0OS4xybEGEq9bN8AXbyPirEkSjBUJdL7WxbB2zFXv0jv1WNtFxzDFlUVPjM/ZGkhPd
	woeSV4Pn4hfLmhI3QpjgAWLYHSzoRuzD3s=
X-Google-Smtp-Source: AGHT+IFa83VqXeT0ie2ajR21WbocvR/2Bz8rM4LhXwoCUHU2FVbpTmSPqfLAprLGPUGGUdW6Pck4HNxdhSq6MmcIu8Y=
X-Received: by 2002:a05:622a:4c0d:b0:4b0:78fb:39da with SMTP id
 d75a77b69052e-4b291a970acmr40724321cf.21.1755695824952; Wed, 20 Aug 2025
 06:17:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820123707.10671-1-fw@strlen.de>
In-Reply-To: <20250820123707.10671-1-fw@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 20 Aug 2025 06:16:54 -0700
X-Gm-Features: Ac12FXzQjiSGePtH8Nfvv5F1MFLdawJfQS_iax-aouAf9UNAQdyMF4GaKRbuoiE
Message-ID: <CANn89i+EQTt8eaBT0=1U=1JjOb5K5_hH=OhESo9_1hnU5XZU1g@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 5:37=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> recent patches to add a WARN() when replacing skb dst entry found an
> old bug:
>
> WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/sk=
buff.h:1164 [inline]
> WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1=
210 [inline]
> WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 n=
et/ipv4/netfilter/nf_reject_ipv4.c:234
> [..]
> Call Trace:
>  nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
>  nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
>  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
>  ..
>
> This is because blamed commit forgot about loopback packets.
> Such packets already have a dst_entry attached, even at PRE_ROUTING stage=
.
>
> Instead of checking hook just check if the skb already has a route
> attached to it.
>
> Fixes: f53b9b0bdc59 ("netfilter: introduce support for reject at prerouti=
ng stage")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Sending this instead of a pull request. the only other two
>  candidates for -net are still under review.
>
>  Let me know if you prefer a normal pull request even in this case.
>  Thanks!
>

Great, I was looking at an internal syzbot report with this exact issue.



WARNING: CPU: 1 PID: 5922 at ./include/linux/skbuff.h:1165
skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 5922 at ./include/linux/skbuff.h:1165 skb_dst_set
include/linux/skbuff.h:1211 [inline]
WARNING: CPU: 1 PID: 5922 at ./include/linux/skbuff.h:1165
nf_reject6_fill_skb_dst net/ipv6/netfilter/nf_reject_ipv6.c:264
[inline]
WARNING: CPU: 1 PID: 5922 at ./include/linux/skbuff.h:1165
nf_send_unreach6+0x828/0xa20 net/ipv6/netfilter/nf_reject_ipv6.c:401
Modules linked in:
CPU: 1 UID: 0 PID: 5922 Comm: kworker/1:3 Not tainted syzkaller #0 PREEMPT(=
full)
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 07/12/2025
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
RIP: 0010:skb_dst_set include/linux/skbuff.h:1211 [inline]
RIP: 0010:nf_reject6_fill_skb_dst
net/ipv6/netfilter/nf_reject_ipv6.c:264 [inline]
RIP: 0010:nf_send_unreach6+0x828/0xa20 net/ipv6/netfilter/nf_reject_ipv6.c:=
401
Code: 85 f6 74 0a e8 a9 6c 7a f7 e9 c8 fc ff ff e8 9f 6c 7a f7 4c 8b
7c 24 18 e9 34 fa ff ff e8 90 6c 7a f7 eb 9b e8 89 6c 7a f7 90 <0f> 0b
90 e9 c7 fb ff ff 48 85 db 0f 84 81 00 00 00 4c 8d a4 24 20
RSP: 0018:ffffc90000a083c0 EFLAGS: 00010246
RAX: ffffffff8a453fa7 RBX: ffff88802e6888c0 RCX: ffff88802fc3da00
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90000a08568 R08: ffff888078550b83 R09: 1ffff1100f0aa170
R10: dffffc0000000000 R11: ffffed100f0aa171 R12: ffff888079bb4101
R13: dffffc0000000001 R14: 1ffff11005cd1123 R15: 0000000000000000
FS: 0000000000000000(0000) GS:ffff888125d1b000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd4758e56c0 CR3: 00000000776ca000 CR4: 00000000003526f0
Call Trace:
<IRQ>
nft_reject_inet_eval+0x441/0x690 net/netfilter/nft_reject_inet.c:44
expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
nft_do_chain+0x40c/0x1920 net/netfilter/nf_tables_core.c:285
nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
nf_hook include/linux/netfilter.h:273 [inline]
NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
__netif_receive_skb_one_core net/core/dev.c:5979 [inline]
__netif_receive_skb+0xd3/0x380 net/core/dev.c:6092
process_backlog+0x60e/0x14f0 net/core/dev.c:6444
__napi_poll+0xc7/0x360 net/core/dev.c:7494
napi_poll net/core/dev.c:7557 [inline]
net_rx_action+0x707/0xe30 net/core/dev.c:7684
handle_softirqs+0x283/0x870 kernel/softirq.c:579
do_softirq+0xec/0x180 kernel/softirq.c:480
</IRQ>
<TASK>
__local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
wg_socket_send_skb_to_peer+0x16b/0x1d0 drivers/net/wireguard/socket.c:184
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x1c8/0x7c0 drivers/net/wireguard/send.c:276
process_one_work kernel/workqueue.c:3236 [inline]
process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
kthread+0x711/0x8a0 kernel/kthread.c:463
ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
</TASK>
