Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50C5172CF
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167405; cv=none; b=goawTjX3I4A8gjkumDxcg8TxOSnJF5rjKqm/MqjwZ6If0DcA3WMJFaGTrdvnAfu5FxrKP6F4Rxt3OlrtteFdL2DEvd3wdm3HYAZeL9WfPi4kpocQSS1TyXv78pdjCx/+k6/dLBj9ZPKwUuhBmr4Yb2yb1RTwZOCTAcUHPN0qeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167405; c=relaxed/simple;
	bh=yXD0FbpAvP/avBxNW7zc3y58V1tw4M5H2dYQC9Zor7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euQk14Jvw1lmsRFjkwNl+A6QKPI8u9dCBHSCCVf0B9y20+gRS1oXhmDEtNAs/pMgjNeUpHNKrzizidY/RG3MLS63Xin3EjBUjHIg5IJiFqyV4X9i/8pEHYHx3s5Ujv4B66oMj03FujBlMFUplbqFxGi/ZKtwV2u8EroYLNya/D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=pcd8YKC0; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="pcd8YKC0"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc147d86bebso149441a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792167397; x=1792772197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M5XsGVLiOuVyTll+6PjcGiV1QjXazvZ+AnpbM4Cni2M=;
        b=pcd8YKC09/C/BSSCTVncqSFPZhEQDLqmu7StpCr1Ukl2chG6ouJd9WIV/+uRuX4YZQ
         Sg4UsHNTTgIuFy2KCjpKmombMludAghkbCPeWIktN3xbLhM2sssfBsCWtP31vb2UqHli
         8tMCxoVh8VGjM0BmzDPeSDQVYH96Jlf5x8JGW4KvXtZhPRIzviI211kjADzEskFNSeyp
         P3XQI4A4n2PkpYQ5Xaz4g6+ZoeCJLS2fi9Tc4Ii7DnX5Mkbp0YV+4kZD/LUsAMr7GC3r
         r39fwGM2w+vU42NOoqO2yslPDKpYDrU4Fvk7pHmnXPBOj3ZAxSCTxB991HT0G1qm49+q
         5u0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792167397; x=1792772197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M5XsGVLiOuVyTll+6PjcGiV1QjXazvZ+AnpbM4Cni2M=;
        b=M6aNoddIuSgqR5AXlLnAARozTEXYv0g4AA5yrHdnGvMurObyDnn/Cgs26AC8HQnQUH
         PsnwFgGaC4BciOTGg0HFgssFOXI5iMzfeBegNDpjYf4YTR9J49B4s9mc/P+PXa3WAQF+
         f/wy9LrsMAaMYuay+sZKb7JmBy4u2PdKEj8IaJbLSdRId87qQnLCQAgRkctyNaSTO41J
         pGhUC5rVPMwCpW7+4Ef90+1sFWD48mXcwSrGE0u5oyg3pFi2FUrpxEtVXujMEhBbKEIt
         FaCwDjh/XkThkdu2qVPlc4UDz8kxbOCSa7QSyVN29mXg+nUlrbCSqldzRsvVdcNGtv9L
         B67Q==
X-Gm-Message-State: AFq9FYLpGOlFh0vc3da4K4m4+6iwyLk0RxvgKnyc+3Es7TYQDPge4Gj0
	NP+xPDiqXzhBBUWThgaOpOOUrRyyH34R7FseWlozK0I1ICeuUy2SlUPva5To8scVcngvpZjeMTt
	Clbq0Srvj
X-Gm-Gg: AYBFou0abpxF7OCp3WRfIjzgqwbHqgz30klPR0KVCuFYSuxRdLriK+oHY3b8YXnTYhK
	xhIqvMPZZOYmkfHJbpN/kPXnDGmstIEVtOS8AUsjDWpNJPl8xipv4OKuGcEOeL2rjNNNlDFCXv0
	LPODi70vOsYfCgE/ULYLsj1ISlwQ/O9awGuE55hhw4ON0YVHGWDo4b2+2NewJJXKDSP6wh3NP6Y
	W/jYadXClc/aBWAPDq0t2nTMKPhw659BAVp6PaBO8NbxeW3clsfAu5S+19eNMn1Io+1FdG9QUAk
	3op5dUk7UrsemsTHwgAk7j6B5p2+iTrlg9+akLTEYbV6zOh2/nFIVNLMZgDWY/UyyQJd4JS1cLf
	G7LU/r1V8Rzy60yA8UaL9fRmMqIo2K0a3OlMWk3PND4jDXwJWTKIpKPHtWgvB+JMb23SukHwkLB
	tMZFlM3Z24Ynl9F2/h01eQpr5L8BSEXOw6o6tDjUf04ADfsBjeunMtVsQwIle4H38mXs94ABsYj
	AaTtHTdodDQk/rh5jMUYXt11wsCUg==
X-Received: by 2002:a05:6a21:2d97:b0:3e1:51f7:1071 with SMTP id adf61e73a8af0-3e201ba71c9mr2636596637.3.1792167396592;
        Fri, 16 Oct 2026 09:16:36 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f579464besm1392540b3a.34.2026.10.16.09.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 09:16:35 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v9 1/1] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Fri, 16 Oct 2026 16:14:17 +0000
Message-ID: <c42d65368f39719fa9540d2c56979f9b537f937b.1792086737.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792086737.git.zihanx@nebusec.ai>
References: <cover.1792086737.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFQUEUE can suspend traversal of a duplicated packet while the task-local
duplication guard is set. The output call then returns and clears the guard
before a later verdict resumes hook traversal.

Save the guard in the queue entry and restore it while reinjection
continues hook traversal. Preserve and restore the verdict task's prior
state, including nested synchronous reinjection.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---

changes in v9:
  - narrow the series to the NFQUEUE reinjection guard fix; defer netdev
    duplication and TTL/hop-limit handling for separate discussion
  - preserve and restore the verdict task's prior duplication state, and
    warn only on unexpected state; test synchronous fail-open reinjection
  - v8 Link: https://lore.kernel.org/all/cover.1792048855.git.zihanx@nebusec.ai/
---
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         |  1 +
 net/netfilter/nfnetlink_queue.c  | 17 ++++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index fc3e81c07364..039622d48905 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,6 +23,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			in_nf_duplicate;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 73363ceedebe..44f182eba953 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -219,6 +219,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.skb_dev = skb->dev,
+		.in_nf_duplicate = current->in_nf_duplicate,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a3bc00280051..226e46e70cd8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -43,6 +43,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/net_debug.h>
 #include <net/netns/generic.h>
 
 #include <linux/atomic.h>
@@ -368,17 +369,26 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	unsigned int i;
 	int err;
 	u8 pf;
+	bool old_in_nf_duplicate;
+
+	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
+			    !entry->in_nf_duplicate,
+			    "%s called with unexpected duplication guard",
+			    __func__);
+	local_bh_disable();
+	old_in_nf_duplicate = current->in_nf_duplicate;
 
 	net = entry->state.net;
 	pf = entry->state.pf;
 
+	current->in_nf_duplicate = entry->in_nf_duplicate;
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
 	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
-		return;
+		goto out;
 	}
 
 	hook_entry = &hooks->hooks[i];
@@ -401,9 +411,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		local_bh_disable();
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
-		local_bh_enable();
 		break;
 	case NF_QUEUE:
 		err = nf_queue(skb, &entry->state, i, verdict);
@@ -417,6 +425,9 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate = old_in_nf_duplicate;
+	local_bh_enable();
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.43.0
