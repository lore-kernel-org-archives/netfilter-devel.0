Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6EA1A0BCD
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148389; cv=none; b=KUltspqGph7ku4Qm/MC/f9hQY9rcnFEMgFXWLFL3Gf0li/2zxlHqcLqzImpNsHxDWL0H9IGflXeE0TM/y//8DiSzspfMQytwUjBcAwPFoNmVQCt1xgK9NDFvjYE4BhPv+Grr9iryOpqEym0AMvvKXKXlILIGKZCKEbxjU0nZ7VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148389; c=relaxed/simple;
	bh=i1ARZ+re90HSn30lyTXTULOEXH7voJp26sFBUVcwzpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lCbRHjbiqZT6RYi7G2kZtc4KqzZyvGRaXDkIzIv6V7ZE/e/wDT7W1/x+2oYEn+OlGEmTWerD7zWejciGS7azhcnCbTRf7Gc6S6vrvgSDU/8ZcwsbPbIMFA3bNg2l1vrQGiv2j0YyAXBFa2RC+LxJ0EM/xwUeBOJnUxTypCjdrjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ar9ggQuf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ar9ggQuf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726148386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BTH+AODJkqHG7R5DYChnEPKMyLn9r72dJ5ZX/ZhC1es=;
	b=ar9ggQufx5TLNIFvYe4lM4ekzUlrurAXFUdWTH9Pw4Tvzrp1woagjIc18Z2eDEV5jIkcBO
	EYc24Xf1jwAAMKF/Qht/beGeYXPcKG+cQ1q1g37IcH/MxnwVDqJyQ2g+w6tUngMdnlqaqy
	Iiz+UQdLR/shOBdeVWIwjlqb8dm97Ag=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-52GsoeWiO8eu3EAihx5bJw-1; Thu, 12 Sep 2024 09:39:45 -0400
X-MC-Unique: 52GsoeWiO8eu3EAihx5bJw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374c44e58a9so556685f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 06:39:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726148384; x=1726753184;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTH+AODJkqHG7R5DYChnEPKMyLn9r72dJ5ZX/ZhC1es=;
        b=gOgi/+hFO62BTC2x6tmGCN+Yf8UXsnBJYiXRGQnDiaMujx9tTv94H6yEjUU2VlC+a4
         nDhw/mhLZptE+wWXTsaCnTVJVCh6Zi322ZlyF18ArfKaK/v1LDMF4/pFJ6+oEFC6DB5J
         VXLyaW41P4dj0d+a9Y2Rozec/bKUlDds/Vz9NbnEsJih/o7LwwvwAJGuMbjjGDlVduwe
         DG1ZtA27RmnAXh9ZqwNUURvWdnwFEP5ielNXzwHBMbuJE4xSgxHJgxSuFt7FH3CiivKG
         qzasVMSwFVDD2XlouR7od+dru9EJQXzX1ntSJZbihaJxMSMiz3An6WCGIh0O1ax0X8og
         k2hA==
X-Gm-Message-State: AOJu0Yw9kgsmpxy4bT839wSzpAYdPN6G/zJspdEPsu3C0z4MoET3hNjK
	Vxigry/QnMa+sioqx0NRGP7EkFZtiLAghJ3eM1+EZTWwT2PfXL4UVRqPt/OxSokmVYx9W6zYvkR
	mf7wpaTluwuVMTaqLVHwjKNiKCsxhKysljCUMFlRA4VNkjQpnr54qLybb86oWhM9yWg==
X-Received: by 2002:a5d:46c9:0:b0:374:ba70:5525 with SMTP id ffacd0b85a97d-378c2cd5fcbmr1638667f8f.12.1726148383686;
        Thu, 12 Sep 2024 06:39:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUjmTSGzhw8s4cfrm1qCW28phQwHzz8FqoQqDd+C6ko3W2FFzGaPN4thvSWnAMSZKD6bzfJQ==
X-Received: by 2002:a5d:46c9:0:b0:374:ba70:5525 with SMTP id ffacd0b85a97d-378c2cd5fcbmr1638639f8f.12.1726148383124;
        Thu, 12 Sep 2024 06:39:43 -0700 (PDT)
Received: from [10.1.33.218] ([62.218.203.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb32b0csm173663975e9.18.2024.09.12.06.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 06:39:42 -0700 (PDT)
Message-ID: <a3f1ee16-f29d-43c4-b272-64da00026359@redhat.com>
Date: Thu, 12 Sep 2024 15:39:39 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: netfilter: move nf flowtable bpf initialization
 in nf_flow_table_module_init()
To: Lorenzo Bianconi <lorenzo@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20240911-nf-flowtable-bpf-modprob-fix-v1-1-f9fc075aafc3@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20240911-nf-flowtable-bpf-modprob-fix-v1-1-f9fc075aafc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 17:37, Lorenzo Bianconi wrote:
> Move nf flowtable bpf initialization in nf_flow_table module load
> routine since nf_flow_table_bpf is part of nf_flow_table module and not
> nf_flow_table_inet one. This patch allows to avoid the following kernel
> warning running the reproducer below:
> 
> $modprobe nf_flow_table_inet
> $rmmod nf_flow_table_inet
> $modprobe nf_flow_table_inet
> modprobe: ERROR: could not insert 'nf_flow_table_inet': Invalid argument
> 
> [  184.081501] ------------[ cut here ]------------
> [  184.081527] WARNING: CPU: 0 PID: 1362 at kernel/bpf/btf.c:8206 btf_populate_kfunc_set+0x23c/0x330
> [  184.081550] CPU: 0 UID: 0 PID: 1362 Comm: modprobe Kdump: loaded Not tainted 6.11.0-0.rc5.22.el10.x86_64 #1
> [  184.081553] Hardware name: Red Hat OpenStack Compute, BIOS 1.14.0-1.module+el8.4.0+8855+a9e237a9 04/01/2014
> [  184.081554] RIP: 0010:btf_populate_kfunc_set+0x23c/0x330
> [  184.081558] RSP: 0018:ff22cfb38071fc90 EFLAGS: 00010202
> [  184.081559] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
> [  184.081560] RDX: 000000000000006e RSI: ffffffff95c00000 RDI: ff13805543436350
> [  184.081561] RBP: ffffffffc0e22180 R08: ff13805543410808 R09: 000000000001ec00
> [  184.081562] R10: ff13805541c8113c R11: 0000000000000010 R12: ff13805541b83c00
> [  184.081563] R13: ff13805543410800 R14: 0000000000000001 R15: ffffffffc0e2259a
> [  184.081564] FS:  00007fa436c46740(0000) GS:ff1380557ba00000(0000) knlGS:0000000000000000
> [  184.081569] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  184.081570] CR2: 000055e7b3187000 CR3: 0000000100c48003 CR4: 0000000000771ef0
> [  184.081571] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  184.081572] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  184.081572] PKRU: 55555554
> [  184.081574] Call Trace:
> [  184.081575]  <TASK>
> [  184.081578]  ? show_trace_log_lvl+0x1b0/0x2f0
> [  184.081580]  ? show_trace_log_lvl+0x1b0/0x2f0
> [  184.081582]  ? __register_btf_kfunc_id_set+0x199/0x200
> [  184.081585]  ? btf_populate_kfunc_set+0x23c/0x330
> [  184.081586]  ? __warn.cold+0x93/0xed
> [  184.081590]  ? btf_populate_kfunc_set+0x23c/0x330
> [  184.081592]  ? report_bug+0xff/0x140
> [  184.081594]  ? handle_bug+0x3a/0x70
> [  184.081596]  ? exc_invalid_op+0x17/0x70
> [  184.081597]  ? asm_exc_invalid_op+0x1a/0x20
> [  184.081601]  ? btf_populate_kfunc_set+0x23c/0x330
> [  184.081602]  __register_btf_kfunc_id_set+0x199/0x200
> [  184.081605]  ? __pfx_nf_flow_inet_module_init+0x10/0x10 [nf_flow_table_inet]
> [  184.081607]  do_one_initcall+0x58/0x300
> [  184.081611]  do_init_module+0x60/0x230
> [  184.081614]  __do_sys_init_module+0x17a/0x1b0
> [  184.081617]  do_syscall_64+0x7d/0x160
> [  184.081620]  ? __count_memcg_events+0x58/0xf0
> [  184.081623]  ? handle_mm_fault+0x234/0x350
> [  184.081626]  ? do_user_addr_fault+0x347/0x640
> [  184.081630]  ? clear_bhb_loop+0x25/0x80
> [  184.081633]  ? clear_bhb_loop+0x25/0x80
> [  184.081634]  ? clear_bhb_loop+0x25/0x80
> [  184.081637]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  184.081639] RIP: 0033:0x7fa43652e4ce
> [  184.081647] RSP: 002b:00007ffe8213be18 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
> [  184.081649] RAX: ffffffffffffffda RBX: 000055e7b3176c20 RCX: 00007fa43652e4ce
> [  184.081650] RDX: 000055e7737fde79 RSI: 0000000000003990 RDI: 000055e7b3185380
> [  184.081651] RBP: 000055e7737fde79 R08: 0000000000000007 R09: 000055e7b3179bd0
> [  184.081651] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000040000
> [  184.081652] R13: 000055e7b3176fa0 R14: 0000000000000000 R15: 000055e7b3179b80
> 
> Fixes: 391bb6594fd3 ("netfilter: Add bpf_xdp_flow_lookup kfunc")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

The reported CI failures looks like an independent flake.

Since already acked by the relevant parties, accepting this a little 
lower the 24H grace period to land into todays PR.

Cheers,

/P

