Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1E42264AD;
	Wed, 20 Aug 2025 18:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714750; cv=none; b=HJD8GAahx/ub0PXeNoDWqLogRRiyi47amfkiF2JY1R2sM1C0OvZskJYED/Cy27c2zJvj7ILUSpwgSJnmI4Tp23w/8grUUVoMcZPQ/NHgphntQ3VGafZkOL9Rn+NXdDsn5fz6UCXlps1SBTdeKQWdJx4gb/jOWb3gH1KkSYEkxt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714750; c=relaxed/simple;
	bh=N0brFEjmV5HpqXBqyEnxOeY+pEFbh8j9U/hGm8iHTyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kR5kNM3h/idlIjUBl1jIPKYLgz+DgDL5VOvapEbM07gy0x6vy3IE7rPdp4e8k5HgVvks3h0TOycL/35TXyQ6YF4OT5p/j9Lxubk3p8pFutHa8XLvAbCioOU+ZcwiuR0DC9uLHW87sm5hykkOyc7oisnUYeOdY//1us2wEhVL5eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCAhTKk3; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCAhTKk3"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b47052620a6so945859a12.1;
        Wed, 20 Aug 2025 11:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755714748; x=1756319548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmEnbWGH6d2qMd0eS7UHYZCRJon0mb65bOhHQMgQiB4=;
        b=OCAhTKk306zpUlvaG4Y5w5ZSyXpgKmxgNce1NU18roQLRksaQ9dwIrNFPjM8W78Cxb
         5h4IAWJ8g4wgu+y3l4YT7k0W+Q7HT+SEIhsN/z5SBpNCOttJFuhfw2LsnSJt3yu8lGHD
         Z+xXYdx9YtUzIZT+Y2LdKLlTY+QMP9521TJBpYcR0Rq1V1qz8LONGScfbifzKow126w3
         dTcgynIlQ4yYEtQF/U/NC53nO9CPsQna4PEXJLC7kCh176ofXIl+LOrXznojOYCtLLkT
         7FXmz8k5whb5THELVofTYPTn9VQx5x3//dZna1Q9wxpwaYxRwgt2NOqiztH5jjp0Dz5l
         Fipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714748; x=1756319548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmEnbWGH6d2qMd0eS7UHYZCRJon0mb65bOhHQMgQiB4=;
        b=GvOpY7wHUsWttYKwWvQ7LogeaAzUaMrbQ6U5I6RcTsMergdmaol+GifPqsmB3923RQ
         FHu6Ouc1trn3QMKGPbrV9vyQYvxAsEq7neGbQ6y/QIUltrGcGmHtwX79rz9TUHJFKtAs
         6qMkp2+VO64cHNh1OIiFTaITjQ9lIrFu2y7ThgjlJcujhPq6/+yf/YE9+wa5fH/851Jo
         sBV0AuZ/SakfxF5EqFpzVk/0Ay6efYIJe43lijzG4JnZ+ARb0OL5HiSSvlZ8cwHUqGGn
         O5k3SL5LLwrIV5tq+2b81NZrYWYIE47+bx3GmyvnzSiA8RMzdvN7eV3FacpTibp6UFFr
         zWnA==
X-Forwarded-Encrypted: i=1; AJvYcCWI7bnKNqs5gApMP2G80Oa6yDzluGVWfMdqYl9g1X1R2XWRa4yXbjxnerCu0DGj8c6Op1xZoNI=@vger.kernel.org, AJvYcCX8qgsRBQZRLqLzeTbZeI4Z0ijSZDPJfK6eEyjcEQzwdwI6Eu+r2gnwPPbpNn3acKNLw7M/UpNBm3NYYareTZgy@vger.kernel.org
X-Gm-Message-State: AOJu0YxfjdOwC/vihi8Cp8cf2s+OFz8IrMDcKe+t1VwTqCtpI5DMJwKG
	PqmlHVQ0J7hYdGnbixBrDfB8a0j9f+BNAgUWawml6i25IlI4U2PNmW5WIX02mw==
X-Gm-Gg: ASbGncvDAWe+jdxTW+ECElP6aKR/m/5QizIN/HDJxVwkNg3c7V+OerKso/1NqRCdgfS
	s4HVMgQ0fVKsmIxp4uS80lESqe6sO32xhMwTWx2WXYtBeDWJmMinLBXbU6gp5EFlgzet6D98Y7h
	NVdcMsUEmIN1JFeHui2gurOdW/RM52cKACuYSeMFPbo/otvViHwT32kdWq/24z/D02rtPaG3L5C
	etiwaMLM9voQp2KW7RESMMYZT0iWm+h2atX+pMPF3+nzbglrEe4/vWrF9L7NFcvtIfbZ0yASa7K
	hTIdUcx2+6/HnllGpjZnOZcTpTNFGXP3afeeBD/b4xJVtJcuJ1qopS8kWQwJ0AIdBaggURgCsWn
	mPaUctUN93Brs2LEuy1afn27MVaVJsuo6e9lq2k5WCQrR
X-Google-Smtp-Source: AGHT+IG8zD7RJ2o7j/Sa4FOteUC4DAO5ZMd5L28sqouNr6QL48Ety7ONA7sq4eLY/a31wuOmOOdpbA==
X-Received: by 2002:a17:903:3c4b:b0:240:20a8:cc22 with SMTP id d9443c01a7336-245fc7af005mr6717625ad.4.1755714747869;
        Wed, 20 Aug 2025 11:32:27 -0700 (PDT)
Received: from VAN-928222-PC2.fortinet-us.com ([173.214.130.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed4e9fe7sm32968055ad.112.2025.08.20.11.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:32:27 -0700 (PDT)
From: Qingjie Xing <xqjcool@gmail.com>
To: fw@strlen.de
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	xqjcool@gmail.com
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing templates
Date: Wed, 20 Aug 2025 11:32:25 -0700
Message-Id: <20250820183225.2707430-1-xqjcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aKUVqxJVrGgRJZA4@strlen.de>
References: <aKUVqxJVrGgRJZA4@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I added a panic() in nf_ct_expect_insert(). After reproducing, the crash dump 
(via crash) shows the nf_conntrack involved is a template (used as the master), 
and the expectation insertion was triggered by a TFTP packet.

The detailed information is as follows:
---------------------------------------------------
crash> sys
      KERNEL: vmlinux  [TAINTED]
    DUMPFILE: coredump-2025-08-15-00_40-8.0.0-B3  [PARTIAL DUMP]
        CPUS: 64
        DATE: Thu Aug 14 17:40:23 PDT 2025
      UPTIME: 00:01:36
LOAD AVERAGE: 4.39, 1.37, 0.48
       TASKS: 1115
    NODENAME: MYNODE
     RELEASE: 6.1
     VERSION: #15 SMP Thu Aug 14 17:02:44 PDT 2025
     MACHINE: x86_64  (2800 Mhz)
      MEMORY: 382.7 GB
       PANIC: "Kernel panic - not syncing: [nf_ct_expect_insert:417] exp:ffff88822ed78008 master:ffff888136fcd000 ext:ffff8881087bf500 jiffies:4294761886 timeout:300 expires:4295061886"
crash> bt
PID: 8605     TASK: ffff888139140040  CPU: 4    COMMAND: "cli"
 #0 [ffffc9001762b7f8] machine_kexec at ffffffff80279d53
 #1 [ffffc9001762b878] __crash_kexec at ffffffff8038b7b7
 #2 [ffffc9001762b948] panic at ffffffff802973e0
 #3 [ffffc9001762b9c8] nf_ct_expect_related_report at ffffffff80ee7b27
 #4 [ffffc9001762ba40] tftp_help at ffffffff80f001ea
 #5 [ffffc9001762ba98] nf_confirm at ffffffff80eeaa77
 #6 [ffffc9001762bac8] ipv4_confirm at ffffffff80eeafa9
 #7 [ffffc9001762baf8] nf_hook_slow at ffffffff80ed24db
 #8 [ffffc9001762bb40] ip_output at ffffffff80fe85a5
 #9 [ffffc9001762bbc8] udp_send_skb at ffffffff81033372
#10 [ffffc9001762bc18] udp_sendmsg at ffffffff81032cb2
#11 [ffffc9001762bd90] inet_sendmsg at ffffffff810488a1
#12 [ffffc9001762bdb8] __sys_sendto at ffffffff80dcdda7
#13 [ffffc9001762bf08] __x64_sys_sendto at ffffffff80dcde46
#14 [ffffc9001762bf18] do_syscall_64 at ffffffff811eab09
#15 [ffffc9001762bf50] entry_SYSCALL_64_after_hwframe at ffffffff812000dc
    RIP: 00007fde06cdb8f3  RSP: 00007ffc80d56358  RFLAGS: 00000202
    RAX: ffffffffffffffda  RBX: 000055eb6f07fc03  RCX: 00007fde06cdb8f3
    RDX: 000000000000001d  RSI: 00007fde047666c0  RDI: 0000000000000007
    RBP: 000055eb6fc941c3   R8: 00007fde047665a0   R9: 0000000000000010
    R10: 0000000000000000  R11: 0000000000000202  R12: 0000000000000000
    R13: 000000000000000b  R14: 00007fde030f4908  R15: 0000000000000006
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b
crash> nf_conn.status -x ffff888136fcd000     
  status = 0x808,
----------------------------------------------------
