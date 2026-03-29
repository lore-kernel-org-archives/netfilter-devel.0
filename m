Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F573822B4
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774803049; cv=none; b=eY3XRevEZYarEsmn+/MxJWLaz2kLbHr4uX67LFnxHjzglQJnSzxXb2/I8WlYfR041XSsasBQYZtSSUCmt4Zuj4PmWySE833z6pi+BPjv/sZjUOW8/1wstpeEngkuCw80RiRn38yWq410S6Pgc34QGDV/licnWS2cOJbBiPHUPu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774803049; c=relaxed/simple;
	bh=B8Wh+OKhBzmwRsiBIJtM2UgSuJEeudpnLpYyPMFLMFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GVxyEuC0hetKbKEZyIA63CJhUrkdO0YGZgjb/Hwu2jtBvSdBxvht/0cIoh6kkk+tiMfB0Nhqp5k8EjerPR0KEqGZ+YId4R7j6cFfxIMzRpBAm4Qa52gQx0uaa1kFZxi3x/guj79gNYWjUBqVao/W+iEocOy8k/UzF8FVbxNzl0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RLnAJ29P; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RLnAJ29P"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82a07738118so2066789b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 09:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774803043; x=1775407843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DPnBm+ae0zOwy+ktvv0TAbSToo1fEQfvYGqtSpxCLrQ=;
        b=RLnAJ29PfdpYVP/XF0P++SG4GuVZBJNYRiUL87iLUVtlA0ChcSKCVZqfYtiuDtnGEh
         Jfgk2+ExJ4Hj4LzvXqSP1Hc6OqoNZAKe1lyShyDcFwDs7lyLtuYn0Z/Pfd8Ph9xBH3lJ
         g2w8dbxlLIFpn4K6lwIjliBnQ/2A7LZz8HWtFoBbyf7QzXqvcERW/x1eQ+8lyCpui+0H
         P9owGmY2tgDWgcFP29C2NQHt1tfLNpON9Oet4a9I8D3SAhPYy1JsPJQ3KpJ7LtsofYpU
         m1/hs7UW5sksgoXU31jzxAQiiWJUvpLbOcQV4CBLSCyfgUWFtkYnSc8u2gJPE+CU+9Tq
         QsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774803043; x=1775407843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DPnBm+ae0zOwy+ktvv0TAbSToo1fEQfvYGqtSpxCLrQ=;
        b=qGZhaxzEXEKkPEG9sqT8Q8XR7f48iGgom3DQkOVToPdfB6bWKunJLS/qVWuafhA3Hz
         tb5habbItjskr5BTknDzc1kb9Pz43wyKGnJT23EoBAjVS1ICv4gEGNnrSLgN8p8Lc+M7
         cj2v0zAaX2q1oSmZDa+Wxu/zP6Re5QXtWEFCpp+1dncSAcqVK5BhJ/E6uyOG2NIFE3WE
         kEmZc6oLX3AZGbVrTb4GN+lFetff84QVMlBXiPVDBOmaPCxfOBR8EqN77OTX7ASEolmw
         xL6tucJkurw6bWUW0oXKWqYQvR+VCRdhXkgEi76PRRicFISecYapzZ0JPPacXeMGCDbf
         Sv+A==
X-Forwarded-Encrypted: i=1; AJvYcCWmKCFEbCBWXE2SERyF8ze7LQeJr7i251zbOSRxMeyM+mTmIF5m0qTuxsoKMsErR+yMFYZFg6YhJfBsyyUk9t0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe45ttsHkptBEtUADsuDVHYSrj6YTwwJZK2MXNEUu31NrjB8SO
	huI6uaAvgyWnYyHRZ9Rd3J34/rzLDk6dhofCLPUBsrw2AawfBrVM0QQk
X-Gm-Gg: ATEYQzxYMcpeprG2Yo+MLS8XV1HIQG9LiFPR8CyGe+D3CrNjm9MjEkfowt6+kO+2ehZ
	RWiuZBCI2yi/b8g/TlqhCqTxhDz25AXP8D4wdNbsJVZ6zEHCpfoU9vm/p4uCqkHNhC5Qt2viy9/
	aihmtwhgmpdP3l5YoJIhXO5H0j66deYx4JNq/IdxYJ81LafW17ZabzgDR+XvzhKFimIQ1Ts0jo0
	UBwjDJEc/CJo/pr60b1dPcLrAG88X+M+K3H1Oadn/WL91/2gMi89UFMUxHI5K2CV6RZ45X2s8yq
	/mCqvOm60EPUpl/ESiDemFKtwvhvkS83rUPA34rbFwrrMBbo6XGKf/JMjcgSvA/aWDWJ8LQvHsh
	nI5q9jXC/OoxrCCMncITcGHOQHwmg0IgtzPUlZn57rSAoDel/Y1QycSnRL4npGTIY8aN3JhT9io
	asbl3ORrNRXWvaM2eQyeOlKIPT9A50r6RkalH11XRSUNqtvA==
X-Received: by 2002:a05:6a00:2d9c:b0:829:862d:6b46 with SMTP id d2e1a72fcca58-82c95e58edcmr8610359b3a.6.1774803043470;
        Sun, 29 Mar 2026 09:50:43 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8498489sm4708920b3a.27.2026.03.29.09.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 09:50:43 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_helper: pass helper to expect cleanup
Date: Mon, 30 Mar 2026 00:50:36 +0800
Message-ID: <20260329165036.240932-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_conntrack_helper_unregister() calls nf_ct_expect_iterate_destroy()
to remove expectations belonging to the helper being unregistered.
However, it passes NULL instead of the helper pointer as the data
argument, so expect_iter_me() never matches any expectation and all
of them survive the cleanup.

After unregister returns, nfnl_cthelper_del() frees the helper
object immediately.  Subsequent expectation dumps or packet-driven
init_conntrack() calls then dereference the freed exp->helper,
causing a use-after-free.

Pass the actual helper pointer so expectations referencing it are
properly destroyed before the helper object is freed.

  BUG: KASAN: slab-use-after-free in string+0x38f/0x430
  Read of size 1 at addr ffff888003b14d20 by task poc/103
  Call Trace:
   string+0x38f/0x430
   vsnprintf+0x3cc/0x1170
   seq_printf+0x17a/0x240
   exp_seq_show+0x2e5/0x560
   seq_read_iter+0x419/0x1280
   proc_reg_read+0x1ac/0x270
   vfs_read+0x179/0x930
   ksys_read+0xef/0x1c0
  Freed by task 103:
  The buggy address is located 32 bytes inside of
   freed 192-byte region [ffff888003b14d00, ffff888003b14dc0)

Fixes: ac7b84839003 ("netfilter: expect: add and use nf_ct_expect_iterate helpers")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---
 net/netfilter/nf_conntrack_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 1b330ba6613b..a715304a53d8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -415,7 +415,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
+	nf_ct_expect_iterate_destroy(expect_iter_me, me);
 	nf_ct_iterate_destroy(unhelp, me);
 
 	/* nf_ct_iterate_destroy() does an unconditional synchronize_rcu() as
-- 
2.43.0

