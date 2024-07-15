Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADCD10A2A;
	Mon, 15 Jul 2024 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721067503; cv=none; b=dw3VhX2CYKdXTQcPx0mAX+TR3SNniP42gf8ftUO5FqLBjyuOvHCLWygU57mjVF3fE7T6MqpgWvMaWa+E4nLT5mhCDis1IJvHcaVDesx1LUKYYT4nJMrhlBEb8GwWUfHJqo56ygidGlFDsr0Q/78qtWUyE5ecgcDfj83W2x+K6AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721067503; c=relaxed/simple;
	bh=dSFMdMwXY82MZ3qDGBu0+q+kEdGr+5JZfHK4QyzYUJ8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=YzG5IFuB7AS1kT8jnYLwgPem4GCjgYgbFIL9hK4s6XEyUvy8maNTyew2MLF43inYjWbV4spVpZxaOU98xYj228U6gwai2KkqY4RfisUThri+7+5Ai8UmZrzE/nQ++UIjkhVqyd3M32kFiCVcO9lbW6ISRMRfbuc1w0gVh3K1Xdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CJodtI76; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJodtI76"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-79f178e6225so322799085a.2;
        Mon, 15 Jul 2024 11:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721067500; x=1721672300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JdmbicsHA1eZpBDvD12TITVsyaXmn/yyPkv0C2f5fI=;
        b=CJodtI76VKjIjKIogoj799GgawWGj7q/yOjaSy8FSjbIM6ogiJsYu7XttHb6TDNQMP
         HZQRYKxPqDGktCXTIRpn1jvRjEkGkkuPugKfzL+zd+fy9D1VAXAn9vwXNpamV2u2A1Iv
         k+fPWFpgj2aZoQ1jOH/poju6NpKeZvmuBFQT0GSlK2TKMwfHCQjhxgQwDZxH71121OXB
         iyW7y4+i+KobM24WNgYSg+/bT/CqbCFLvEtLeP0TModaKTrGG+ZpogK5bruix+NOiqiN
         Dh3bLOIeCaZW8XEUXT7ULdaISfXinPh3YdMZ6rR7ErNEbrzwhmJmOV8dsnyjgezoovBu
         nJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721067500; x=1721672300;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+JdmbicsHA1eZpBDvD12TITVsyaXmn/yyPkv0C2f5fI=;
        b=UCoVvWl5bp/7cpLg6hNIhrIlbnzYn0ge8TFbMOJ2SV1Qci7+9QHY662+xEQIbu9uXI
         Yr/J2Mi6l5gQr7B261itG5KUaGOOPo4R6jHElj0aewEYf/Z/dXeOFj9asNaB+zN1jigr
         ABfuxpsmLOHDuW6A3TV7w8gv5DbWbUaTXl3BxqyGsKWnl/QOOx1DXGDAI3hjR2rbHKFV
         YBHS99wfzkKVO1hi+AnnYJAqNpby2X8Oud58ShhDimTHJlNXDskSiSES5sBlpZTNqzA+
         WiiDIpK+KtN3q8HKYcRAszp84I/UlX4z9P1dhV+EGgZzdcrIj1yKu26ItBlrmNBR5fqZ
         zStw==
X-Forwarded-Encrypted: i=1; AJvYcCU78WE2eLFsK0tGXKIjnW8EX71DS5e06P9NGBGhvOwTUVl+8R2aKkYLZA6VjXCnqnf2Uclmb34W3haINen6bH6Hnnqgq5JE
X-Gm-Message-State: AOJu0Yzo48kljdVKH/GbiM5w6ykC7FAs9a5pDtb+pG2lA1/LaiGK0b1G
	BuzdcJCJD+OJ9UGC6/ybKkqoJahxojUiUkyaoHNIZ3FcL1RJHyso
X-Google-Smtp-Source: AGHT+IEUC82LAgEdAUXep1GXNhv8zoutAtzgDq12Vz/xpe1ZmMc5FjkvUwLzODXPpqr010IfIl498Q==
X-Received: by 2002:a05:620a:3187:b0:79d:7ae0:ffd2 with SMTP id af79cd13be357-7a179fb23b0mr77078685a.49.1721067500357;
        Mon, 15 Jul 2024 11:18:20 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a160bbe6c6sm222572585a.39.2024.07.15.11.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 11:18:19 -0700 (PDT)
Date: Mon, 15 Jul 2024 14:18:19 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, 
 davem@davemloft.net, 
 kuba@kernel.org, 
 pabeni@redhat.com, 
 edumazet@google.com, 
 fw@strlen.de, 
 sdf@google.com, 
 daniel@iogearbox.net
Message-ID: <669567eb4caa8_2d2577294ab@willemb.c.googlers.com.notmuch>
In-Reply-To: <20240715141442.43775-1-pablo@netfilter.org>
References: <20240715141442.43775-1-pablo@netfilter.org>
Subject: Re: [PATCH net] net: flow_dissector: use DEBUG_NET_WARN_ON_ONCE
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> The following splat is easy to reproduce upstream as well as in -stable
> kernels. Florian Westphal provided the following commit:
> 
>   d1dab4f71d37 ("net: add and use __skb_get_hash_symmetric_net")
> 
> but this complementary fix has been also suggested by Willem de Bruijn
> and it can be easily backported to -stable kernel which consists in
> using DEBUG_NET_WARN_ON_ONCE instead to silence the following splat
> given __skb_get_hash() is used by the nftables tracing infrastructure to
> to identify packets in traces.
> 
> [69133.561393] ------------[ cut here ]------------
> [69133.561404] WARNING: CPU: 0 PID: 43576 at net/core/flow_dissector.c:1104 __skb_flow_dissect+0x134f/
> [...]
> [69133.561944] CPU: 0 PID: 43576 Comm: socat Not tainted 6.10.0-rc7+ #379
> [69133.561959] RIP: 0010:__skb_flow_dissect+0x134f/0x2ad0
> [69133.561970] Code: 83 f9 04 0f 84 b3 00 00 00 45 85 c9 0f 84 aa 00 00 00 41 83 f9 02 0f 84 81 fc ff
> ff 44 0f b7 b4 24 80 00 00 00 e9 8b f9 ff ff <0f> 0b e9 20 f3 ff ff 41 f6 c6 20 0f 84 e4 ef ff ff 48 8d 7b 12 e8
> [69133.561979] RSP: 0018:ffffc90000006fc0 EFLAGS: 00010246
> [69133.561988] RAX: 0000000000000000 RBX: ffffffff82f33e20 RCX: ffffffff81ab7e19
> [69133.561994] RDX: dffffc0000000000 RSI: ffffc90000007388 RDI: ffff888103a1b418
> [69133.562001] RBP: ffffc90000007310 R08: 0000000000000000 R09: 0000000000000000
> [69133.562007] R10: ffffc90000007388 R11: ffffffff810cface R12: ffff888103a1b400
> [69133.562013] R13: 0000000000000000 R14: ffffffff82f33e2a R15: ffffffff82f33e28
> [69133.562020] FS:  00007f40f7131740(0000) GS:ffff888390800000(0000) knlGS:0000000000000000
> [69133.562027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [69133.562033] CR2: 00007f40f7346ee0 CR3: 000000015d200001 CR4: 00000000001706f0
> [69133.562040] Call Trace:
> [69133.562044]  <IRQ>
> [69133.562049]  ? __warn+0x9f/0x1a0
> [ 1211.841384]  ? __skb_flow_dissect+0x107e/0x2860
> [...]
> [ 1211.841496]  ? bpf_flow_dissect+0x160/0x160
> [ 1211.841753]  __skb_get_hash+0x97/0x280
> [ 1211.841765]  ? __skb_get_hash_symmetric+0x230/0x230
> [ 1211.841776]  ? mod_find+0xbf/0xe0
> [ 1211.841786]  ? get_stack_info_noinstr+0x12/0xe0
> [ 1211.841798]  ? bpf_ksym_find+0x56/0xe0
> [ 1211.841807]  ? __rcu_read_unlock+0x2a/0x70
> [ 1211.841819]  nft_trace_init+0x1b9/0x1c0 [nf_tables]
> [ 1211.841895]  ? nft_trace_notify+0x830/0x830 [nf_tables]
> [ 1211.841964]  ? get_stack_info+0x2b/0x80
> [ 1211.841975]  ? nft_do_chain_arp+0x80/0x80 [nf_tables]
> [ 1211.842044]  nft_do_chain+0x79c/0x850 [nf_tables]
> 
> Fixes: 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>
