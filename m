Received: from mail-dl2-f41.google.com (mail-dl2-f41.google.com [74.125.229.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A3B41837D
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526778; cv=none; b=tJ/gOFf2IfSt6i1ZENzpJHEvWrhkaiPGAnzXwoKAvIEIAEUyecosWCjefsICqdvOPua7qaQpr34FKe5mJ5WFmRuuW8k8nVkt8+xOJ0gYQwWJd6qpLhSQu3dh97DzU4wh3svwSXmLCmsYSG21eOsg9mg0+w0D4HALk8MqyH1ZTQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526778; c=relaxed/simple;
	bh=nQuhN2l7+/6WRWmQIpvcYbsN03imFt1LfNjrv01xrR4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7LH+93QVbE2BsRP+mbksMbEvHOOzF3umfUW2vtzCXR6ST3ROlWx1ktRlPrHhXaj7CjYktQcvnGGgpYmx6i+pivALF0lYWJajGm4yW2yZT+NfNB+lkbsOqFZi2sgTs2CXKdhaRd+XR9jEF3G6o7DjsWrQdTgNz/6OUl6XknrOS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmZ0/UBP; arc=none smtp.client-ip=74.125.229.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmZ0/UBP"
Received: by mail-dl2-f41.google.com with SMTP id a92af1059eb24-148bc4a87eeso20773c88.2
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 09:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790526776; x=1791131576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WKnlC/CJp+36djLN5FPwvtqOnvSWX1NbVkCP871yhGA=;
        b=KmZ0/UBPgAE8KKPhbqS1Dt9jwO0uIEh8qXNoLYzh0JMZtKqoZPqBy6+rceZZzasV+K
         BYMZZzkL2XLxtH+XnzL8I94SXvaMp1+tWUWtkBrnU5tydjhOuQNj8hfV2kgH0FyZ2cvY
         nkC7t7x99cwXpySiZVnH15yof8NtgkyQ7Ex18x9MOzNpgpDPwTO3v+F3914YqA22ZzAV
         P9ZePPDkK+XD0GOMxG0/Y3R/WNAtSM/JdylSxRGwT3PDV9+m6sZapBkboRrtbLg2cTaN
         3WPAZouVVz/Epf2Vuhc+pKzGXsvTQ8MO8ZZYtIanEJ03Zde7GGIK/XfXtCjZ5Cy5JSrI
         lcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790526776; x=1791131576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WKnlC/CJp+36djLN5FPwvtqOnvSWX1NbVkCP871yhGA=;
        b=RX/pnUKVKcl0Sh5YxHxmXZpV9pFx6f+/Je0KEbdYNCche5OL9G0oQeMX+T7/7SW6BQ
         auNMeZM4O1bNK8L80LF3ITxuDp4WbKbxlzJSdbOyvHADIvEJn2NQ4UuJhAqdz8t+r4BF
         ITaMm6heR7qgvzdmI82g1/gO23afG3S0UqRNGOW52Nsw4V1DP3BsmL7ipPtO9QCmHxt6
         gWnhPxXsN43BBm9kx2uAGtNMJIieAmGz1efeZj1sWzZ7IY1i1sgOtBWOOmtcK1RmrGX8
         OGvnLEyB1dAT20kc5jPOUJ/7j9iGXIVmex3WVLM16qwgT64Tg5Yp85yKT/eJGeUteecX
         ++ug==
X-Gm-Message-State: AFuF++mRbIAsO90P/JumM7o4pqGPAK6KhPwklGiwUr9fSS4FnwvmNV1s
	L63DUW1SXrTR+MooZIwOlO6EyhDtoo3k7mChxWrVP4s5oL/4+LQTWHw9
X-Gm-Gg: AYBFou2XFsCne7qJ1Rp6BpqHUbMzgsf8QoRA+NcaJYOxHO//MLiTE2F5rrzdEFH8Dqz
	WyZDc8zh36VNa+lsc069eab1WbVPlq3fuaVUiQYS+sp+FHFT9VKot1pnfkp3tT+dLp3xAqfEybZ
	lpO5mPRdq97LPuAzSajfDiV5hSsKfSEiEOYjtIb5PpGtAz+Ws7BrgQ8slDENMwkdekNkv9REjf6
	bMQ+lKPV60UpdJcBJwNwxvUC9+wW8Kiy2Mgs0YTPDe+L+VAB8NdGp+ue7CcQs662Pmh3tRklXxe
	NE1wtwiGGiap2V3e7+HLtcsl+gdoZxLMLelofOuW37LE3yAyHP7v7Cf0thKl678lVjcNKiIWc4I
	zbnbueTkgxjFgmYQRDlAxGbhEKUZ5cMxgb3tk5UKmyetWtpHU7mNMgILiuZbBGREnsg5LGVZ9RO
	Guwt5xoge1r5ybptfOMIkbravAXUsIr3DRTmdMvCZlPXraRWXq0VzvnIpSnfnkxye2luUnBJ80m
	OtFfAQSv3+TiBe8IsJFl+4NE/PfnYB2lO5GNymS6R+FCBvFr4bEC8RfIp0bxlHX4ukxRATMoX6a
	4voQ
X-Received: by 2002:a05:7022:ea8a:b0:146:ffa9:2117 with SMTP id a92af1059eb24-146ffa92165mr9118845c88.1.1790526775739;
        Sun, 27 Sep 2026 09:32:55 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145acd3d8eesm18140836c88.8.2026.09.27.09.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 09:32:55 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] netfilter: flowtable: flush delete work after final GC
Date: Mon, 28 Sep 2026 00:32:48 +0800
Message-ID: <20260927163248.1002656-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_table_free() can return while delete work still holds a pointer to
the flowtable. Its caller can then free the flowtable before the worker
accesses it, causing a use-after-free.

nf_flow_offload_del() sets NF_FLOW_HW_DYING only after allocating the work
item. If this GFP_ATOMIC allocation fails during the first teardown GC
pass, the flow remains eligible for deletion in the final GC pass inside
nf_flow_table_offload_flush_cleanup(). That pass runs after the delete
workqueue has been flushed, so a successful retry queues work which is
not waited for:

  teardown worker                         delete worker
  first GC: work allocation fails
    NF_FLOW_HW_DYING remains clear
  flush delete workqueue
  final GC: allocation succeeds
    queue FLOW_CLS_DESTROY work
  destroy rhashtable
  free flowtable
                                          access offload->flowtable

Flush the delete workqueue again after the final GC to complete this work
before the flowtable can be freed. All flows have already been marked for
teardown, so this GC pass only queues delete work, and the delete worker
does not queue further offload work.

KASAN reported:

  BUG: KASAN: slab-use-after-free in flow_offload_work_handler+0xbe8/0xe30
  Read of size 8 at addr ffff888109c9fd98 by task kworker/u16:3/397
  Workqueue: nf_ft_offload_del flow_offload_work_handler
  Call Trace:
   flow_offload_work_handler+0xbe8/0xe30
   process_one_work+0x63a/0x1070
   worker_thread+0x45b/0xd10
  Allocated by task 87:
   nf_tables_newflowtable+0x5d0/0x22f0
   nfnetlink_rcv_batch+0x1396/0x1d00
  Freed by task 11:
   kfree+0x131/0x3c0
   nf_tables_trans_destroy_work+0xb26/0xeb0
   process_one_work+0x63a/0x1070
  Last potentially related work creation:
   __queue_work+0x68e/0x1030
   flow_offload_del+0x74c/0xad0
   nf_flow_offload_gc_step+0x264/0x8e0
   nf_flow_table_gc_run+0xcd/0x150
   nf_flow_table_offload_flush_cleanup+0x5c/0x70
   nf_flow_table_free+0x280/0x350
   nf_tables_flowtable_destroy+0x71/0x270

Fixes: c921ffe85333 ("netfilter: flowtable: Fix flushing of offloaded flows on free")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6-Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v2:
- Rebase onto current mainline; the independently revalidated one-line fix
  is unchanged from v1.

v1: https://lore.kernel.org/r/20260824115829.205118-1-nicoyip.dev@gmail.com/

 net/netfilter/nf_flow_table_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6757fd89c1f1..728220ba3882 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1172,6 +1172,7 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
 	if (nf_flowtable_hw_offload(flowtable)) {
 		flush_workqueue(nf_flow_offload_del_wq);
 		nf_flow_table_gc_run(flowtable);
+		flush_workqueue(nf_flow_offload_del_wq);
 	}
 }
 
-- 
2.43.0
