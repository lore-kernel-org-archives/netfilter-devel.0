Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C521B9DA;
	Tue, 19 Aug 2025 23:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645861; cv=none; b=JC73nh/uMy5ycTQKJ44H5iE5z56j9vN0p5WnzEuj4ZhmcOl+CkQ+v938IklFp1X2tKB5pn4USOprbszSyHOWO4671vzS2tvOts7tq1P/5CeFJ5p6aISXjiQlvba2SRm9TNIydr1uLzMa1CnEy1vtd5Vq+AGEd3n/N6R470TjzKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645861; c=relaxed/simple;
	bh=/TKN4m04UU/ZQ0owKaypwRO48rADmn+PXF3RFHUOhi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UotQxm0WXPzrhdn6yeCm/902pzBVuBv7a9PnML8cxq4O0KcQdGIeXcAp2jr5vp1bQ8NRHB4YyGI877AqP5W7UJYctq+jPfOo96BYFOfG2momcLeGnh2JINAm/0eaLdyyb37RASz2h6XAQs2rO5TPff7BnmXGajQK6mSmO1+T3I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lqXYLQYh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqXYLQYh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so3527952b3a.0;
        Tue, 19 Aug 2025 16:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755645859; x=1756250659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXsZkymfZg5n/r8Mb5dnukqbEfjwpxtF4j7Sbq0WEC8=;
        b=lqXYLQYhsaGfZ8t0gl87cEVy5+Yf/iTTcPwSVGwXhHkthntMWa+fYQ0K8DLbguj4u4
         hrubZCSy3kA4I6a3SPOh4Sk1674e94Nz0N7QIYqSVLPEBKN4JZ3xlF7QPsi5sLCeOX9k
         g2egghJ4wyAOrmbBt8GMmP+Sg1esdN51zM0hD8JV48EyHHJ9gNP+jNDrachPXJqwqXhi
         wzZuq9KqLRTNdwHnTFsirNTpTH7ncP4LwwxQi1YMMjAkaJW5c573+yiB5SJZZLYMZX9x
         2x1GEDpK2W1ccoXFJhCwCHXNwkBexNmVT3xuqp7aHm6XFtRLeoGAOvFna9QkDFS6zfSF
         lFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645859; x=1756250659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXsZkymfZg5n/r8Mb5dnukqbEfjwpxtF4j7Sbq0WEC8=;
        b=LUXUN7icdf2iYCAjDC4bzL2I+lgltx0D/voBGvBODi4ZHGkWQNFjg/LsSa2msRqIC3
         U/bYf1kLC7C1V2p86ur12APZBFTk+pxu01Ew6mw7oc74ZB4/GwBMkXw0phwe6p2M7ElN
         mTZ+X9VKzeBEZ7QSapH1sg3hYkbXw/SeL/Gv6qiPvt9LhYkujP0rlnEQ0LFRtG6MXQLL
         pMBt0E85ixP7ByDLmIXNxLlTg4gMnthGOnoBqJtG43OPexrcOYf0JfouUZ/iatwtDTcp
         OBrMkeKmnYrwo7dghHQgmJoNW3Vt2E1AmL1IXBiY6QcHJpDfgBkxLe1iX1jmJD39Xckk
         WTYg==
X-Forwarded-Encrypted: i=1; AJvYcCU07Q4TeLHK63tKfttmzBQ0Aiz9tWRyQ9/e46TJnbsO6HXASlphsZK+uw1Fn508E8LFa9pUm20=@vger.kernel.org, AJvYcCUWQcPd5E2hPHnclB/Wx0Ta6N7X3DGPfaxsFonvLBjyTUY+V2NFMd56jn9sAmT6i8wGdIScZNf2QIflS/Ejrps0@vger.kernel.org
X-Gm-Message-State: AOJu0YyG52L6hdATgUH6hbCGeKoD/qZcYaVb4+U9XrvnFAxe4ebKw9xY
	zARJJjmNRJO/eyP91oGH+//adhFVHqk2fjiFBsDlsC8RbdvoM17l3qQN
X-Gm-Gg: ASbGncvPedc5CTmQQPgh0rUVw1b1eej2g1SEIqJe82CrqjaOGcwD/EfQTNCrMfYRv/H
	OXKZr4EUEjPMGQJJ4e1HSD439ZYEVlhXEhNjumFEmdrBZiOF+n8yIgUl0SZWw7/1EcQqbytfi3x
	d2//b9He/1Nn+FZiSLmHoejrv3h1ZnbUOW3x4UnqEDFjIZJ3ZTjRzF8WL6lvg24WCLzwhuVgLCK
	S56rezma+LB9LAbEaH0kW6LAYau57X79XZb4HMV7XNqHwXmTJ0e99NoW9CozvunqlLElH9lL96A
	tWX+b3AFzDHpWXMTZ5aQUQIHvQ4mfxCE0lX9mh0rnESHrRYVawjeqR16fkMsQvJz5ht5ThR9krO
	aOmkpq9u29LHzoViVrIMZgzhYD2hwz8pX/OIkqLUVauag
X-Google-Smtp-Source: AGHT+IFjJLDqlm0W3bq1YAgCjGHK+vqinZzLZigJLHtUDJ+t23i1m589jTiENTtqss+LbbqbRIRb7A==
X-Received: by 2002:a05:6a00:856:b0:76e:885a:c337 with SMTP id d2e1a72fcca58-76e8de39979mr1103746b3a.29.1755645859196;
        Tue, 19 Aug 2025 16:24:19 -0700 (PDT)
Received: from VAN-928222-PC2.fortinet-us.com ([173.214.130.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e894bc4d2sm1467500b3a.67.2025.08.19.16.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 16:24:18 -0700 (PDT)
From: Qingjie Xing <xqjcool@gmail.com>
To: fw@strlen.de
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	xqjcool@gmail.com
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing templates
Date: Tue, 19 Aug 2025 16:24:17 -0700
Message-Id: <20250819232417.2337655-1-xqjcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aKTCFTQy1dVo-Ucy@strlen.de>
References: <aKTCFTQy1dVo-Ucy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With an iptables-configured TFTP helper in place, a UDP packet 
(10.65.41.36:1069 → 10.65.36.2:69, TFTP RRQ) triggered creation of an expectation.
Later, iptables changes removed the rule’s per-rule template nf_conn. 
When the expectation’s timer expired, nf_ct_unlink_expect_report() 
ran and dereferenced the freed master, causing a crash.

The detailed system logs are as follows:
--------------------------------------------------------------------------------
//create
[ 1978.316487] nf_conntrack: [nf_ct_tmpl_alloc:580] nf_conn:ffff8881391e3800 ext:0

//insert
[ 2131.989389] [nf_ct_expect_insert:417] exp:ffff88823aac8008 master:ffff8881391e3800 ext:ffff888286a3c500 jiffies:4296796140 timeout:300 expires:4297096140
[ 2140.352649] nf_conntrack: [nf_ct_tmpl_alloc:580] nf_conn:ffff88813ae58e00 ext:0
[ 2140.352657] nf_conntrack: [nf_ct_tmpl_alloc:580] nf_conn:ffff88813ae59a00 ext:0
[ 2140.352661] nf_conntrack: [nf_ct_tmpl_alloc:580] nf_conn:ffff88813ae5d600 ext:0
[ 2140.352664] nf_conntrack: [nf_ct_tmpl_alloc:580] nf_conn:ffff88813ae58800 ext:0
[ 2140.352735] nf_conntrack: [nf_ct_tmpl_free:594] nf_conn:ffff8881391e3200 ext:6b6b6b6b6b6b6b6b
[ 2140.352738] CPU: 0 PID: 4691 Comm: netd Kdump: loaded Tainted: G        W  O       6.1 #16
[ 2140.352740] Hardware name: Supermicro SYS-2049P-TN8R-FI005/X11QPL, BIOS 3.3 02/19/2020
[ 2140.352741] Call Trace:
[ 2140.352742]  <TASK>
[ 2140.352743]  nf_ct_tmpl_free+0x4f/0x60
[ 2140.352749]  nf_ct_destroy+0xce/0x290
[ 2140.352752]  xt_ct_tg_destroy+0x78/0xc0
[ 2140.352756]  xt_ct_tg_destroy_v1+0x12/0x20
[ 2140.352758]  cleanup_entry+0x115/0x1b0
[ 2140.352761]  __do_replace+0x3ab/0x530
[ 2140.352763]  ? do_ipt_set_ctl+0x5ef/0x6c0
[ 2140.352765]  do_ipt_set_ctl+0x5ef/0x6c0
[ 2140.352767]  nf_setsockopt+0x1a8/0x2e0
[ 2140.352769]  raw_setsockopt+0x7b/0x120
[ 2140.352771]  sock_common_setsockopt+0x18/0x30
[ 2140.352773]  __sys_setsockopt+0xb9/0x130
[ 2140.352775]  __x64_sys_setsockopt+0x21/0x30
[ 2140.352777]  do_syscall_64+0x49/0xa0
[ 2140.352780]  ? irqentry_exit+0x12/0x40
[ 2140.352782]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[ 2140.352785] RIP: 0033:0x7f621d3f49aa
[ 2140.352787] Code: ff ff ff c3 0f 1f 40 00 48 8b 15 69 b4 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 39 b4 0c 00 f7

//free
[ 2140.352889] nf_conntrack: [nf_ct_tmpl_free:594] nf_conn:ffff8881391e3800 ext:6b6b6b6b6b6b6b6b
[ 2140.352891] CPU: 0 PID: 4691 Comm: netd Kdump: loaded Tainted: G        W  O       6.1 #16
[ 2140.352892] Hardware name: Supermicro SYS-2049P-TN8R-FI005/X11QPL, BIOS 3.3 02/19/2020
[ 2140.352893] Call Trace:
[ 2140.352893]  <TASK>
[ 2140.352894]  nf_ct_tmpl_free+0x4f/0x60
[ 2140.352896]  nf_ct_destroy+0xce/0x290
[ 2140.352898]  xt_ct_tg_destroy+0x78/0xc0
[ 2140.352900]  xt_ct_tg_destroy_v1+0x12/0x20
[ 2140.352902]  cleanup_entry+0x115/0x1b0
[ 2140.352904]  __do_replace+0x3ab/0x530
[ 2140.352906]  ? do_ipt_set_ctl+0x5ef/0x6c0
[ 2140.352907]  do_ipt_set_ctl+0x5ef/0x6c0
[ 2140.352909]  nf_setsockopt+0x1a8/0x2e0
[ 2140.352911]  raw_setsockopt+0x7b/0x120
[ 2140.352912]  sock_common_setsockopt+0x18/0x30
[ 2140.352913]  __sys_setsockopt+0xb9/0x130
[ 2140.352915]  __x64_sys_setsockopt+0x21/0x30
[ 2140.352917]  do_syscall_64+0x49/0xa0
[ 2140.352919]  ? irqentry_exit+0x12/0x40
[ 2140.352920]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[ 2140.352923] RIP: 0033:0x7f621d3f49aa
[ 2140.352924] Code: ff ff ff c3 0f 1f 40 00 48 8b 15 69 b4 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 39 b4 0c 00 f7


//expectation timeout
[ 2433.066066] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP NOPTI
[ 2433.187797] CPU: 10 PID: 66 Comm: ksoftirqd/10 Kdump: loaded Tainted: G        W  O       6.1 #16
[ 2433.293977] Hardware name: Supermicro SYS-2049P-TN8R-FI005/X11QPL, BIOS 3.3 02/19/2020
[ 2433.306651] nf_conntrack: [__nf_conntrack_alloc:1729] nf_conn:ffff8882a9268440 jiffies:4297097457
[ 2433.388722] RIP: 0010:nf_ct_unlink_expect_report+0x2d/0x1f0
[ 2433.388730] Code: 00 00 55 48 89 e5 41 56 53 48 83 ec 18 65 48 8b 04 25 28 00 00 00 48 89 45 e8 48 8b 4f 70 4c 8b 81 e8 00 00 00 4d 85 c0 74 39 <41> 0f b7 00 48 85 c0 74 30 41 83 78 1c 00 75 11 4c 01 c0 48 8b 99
[ 2433.388732] RSP: 0018:ffffc9000ce0fce0 EFLAGS: 00010202
[ 2433.848812] RAX: a79bfdc906a58200 RBX: ffff88823aac8088 RCX: ffff8881391e3800
[ 2433.934200] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88823aac8008
[ 2434.019584] RBP: ffffc9000ce0fd08 R08: 6b6b6b6b6b6b6b6b R09: 0000000000000000
[ 2434.104964] R10: ffff8897e0f1cc00 R11: ffffffff80ee7e00 R12: ffffffff80ee7e00
[ 2434.190349] R13: 0000000000000000 R14: ffff88823aac8008 R15: ffff88823aac8088
[ 2434.275728] FS:  0000000000000000(0000) GS:ffff8897e0f00000(0000) knlGS:0000000000000000
[ 2434.372555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2434.441296] CR2: 00007f980bc97000 CR3: 0000000107734003 CR4: 00000000007706e0
[ 2434.526684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2434.612066] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2434.697449] PKRU: 55555554
[ 2434.729791] Call Trace:
[ 2434.759017]  <TASK>
[ 2434.784079]  ? __die_body+0x82/0x130
[ 2434.826826]  ? die_addr+0xaa/0xe0
[ 2434.866446]  ? exc_general_protection+0x13a/0x1e0
[ 2434.922711]  ? asm_exc_general_protection+0x27/0x30
[ 2434.981054]  ? nf_ct_expect_dst_hash+0x120/0x120
[ 2435.036276]  ? nf_ct_expect_dst_hash+0x120/0x120
[ 2435.091503]  ? nf_ct_unlink_expect_report+0x2d/0x1f0
[ 2435.150885]  nf_ct_expectation_timed_out+0x2b/0x90
[ 2435.208189]  ? nf_ct_expect_dst_hash+0x120/0x120
[ 2435.263415]  call_timer_fn+0x2f/0x110
[ 2435.307195]  run_timer_softirq+0x616/0x700
[ 2435.356179]  ? newidle_balance+0x299/0x320
[ 2435.405166]  __do_softirq+0xdc/0x2ab
[ 2435.447904]  run_ksoftirqd+0x1c/0x30
[ 2435.490649]  smpboot_thread_fn+0xe8/0x1b0
[ 2435.538595]  kthread+0x269/0x2a0
[ 2435.577179]  ? __smpboot_create_thread+0x220/0x220
[ 2435.634479]  ? kthreadd+0x380/0x380
[ 2435.676187]  ret_from_fork+0x1f/0x30
[ 2435.718930]  </TASK>
-------------------------------------------------------------------------------

