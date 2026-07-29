Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27183B19B2
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332950; cv=none; b=ZK/KMg7Hs4mN/oHziyGU6vYUNl7oQPINP1R1RxvzhJqlMrPOBqFNbY37jck5GwzINn+D2rYagRpLgzqBsQWx62h9aAFl8KUAdQDCXmRHXq6TexS0uXWAUMIxJKpp6RDL0vRURjJMPwvOuzSPRvjNeLw/6XEODv9gEg9lH88L2aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332950; c=relaxed/simple;
	bh=Pqt9NyKegLWTkHxOddHLz7StvU8G2POvX9oOJAjZU3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfyJFOivAgU25LlwIyYnc2k3zPqsw5YKO/pDbqmi07/Zvt7UmW4595Nvvwml5BC75UvBId5P9TDq+Zqh02Ky8SxibXY1CNeNQTlTziKxV/RbOl0Kmjmb3VA60Fdpj/V6fYROHTi0svwrrO0kEOsNAwnTTRw+LUQ0K5YQ4/MEa5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=EId4v66u; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="EId4v66u"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-848d21bbaffso1032223b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 06:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785332935; x=1785937735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D+1XXvkajr6+1Yk5LVU6qEFCRRQ2xlVvX/lKvRvqY8I=;
        b=EId4v66uTzRbPno6ZiIjrHOKnT9n++bUyB34BaOeuCBWxZDCIgeZZ5UiVlLmDa/UbQ
         dShW/YgLd25FIGnHMhOgrCzdWYe4JOUXc/S8hOa0NycQwCpQeY0Gcjo6yGc7GvBugO3b
         nDDnjQI3DezAGJ+g9LRnKUhJdEtEWBbY7wYHWyjfw6RfI7fHxJA9lbsCg5j3++y7ffcl
         87rdcJHZr7UeH4DqzXLwlgBJOgfYKvy5gIP5UgBARPTSFkCT3tzoheKp+5Wyw+zSDhIi
         qadDKiBQrodMr70kZlGAGcUyVdKe1qoybfdAWsQwGnROL5HfZ5enBf2xVlEgiV5dds82
         Jyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332935; x=1785937735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D+1XXvkajr6+1Yk5LVU6qEFCRRQ2xlVvX/lKvRvqY8I=;
        b=oUse3qWuch810w7YQlFJY0LKT0WTkcTPytPMurIbcF8qdTc3X1+GVOp/pdxP8qaRv+
         8Ad4/fLV0uFaU1A3B6CIbyPi8FeWbwfy6NZc4DB9YZFAzbMcsp9ASWJWu1mC9DEQ7oKi
         5OQkGX1OSsPNytY6v44a+re02ksYG25IR6L7+c3r5htfFxjn9gSgiIe7q6Nvp73WVPbz
         EebYaCrceXCQ1cgXWT2+HdQZ8oQKG2jexnYJVmrrXI+RwiJoXF3PtsBCxSA4yNzqPWGm
         p9nlZ897YWEDsMUOU2pUXgiE0lS81SpAYGL/avS13p5vQeqY806x22gEmo8GwESCO7EZ
         iw/A==
X-Gm-Message-State: AOJu0YzQqtBymwkVMU6iRM4Ejgwrn5qzJx/9MYPKju2Y6YKk1/LmfsMk
	lpJ9gJfdCbznEkZUohajOOdADUNkLO7eLRuKIaznMGzPFppW2ALGKwguYoWKvV7gxIiha5nMdTK
	UkeTJ4Wqu
X-Gm-Gg: AR+sD13CEKDwhvgjosG0XpIWEn8eMs0gmZf//gZqo7thDuRoz7r8WR3zI25uXGjg4Z2
	0bloEVDJrn1Fp+0UOkweUqAiZKQvq67AE1N24aiAkZ/urMAuzj4P4/Xo4jIUwATyGZz+2sYMQAU
	ZfaF5/Op+SnowjYfmyenKayL8Q6VhdEYpxhcMXE0wjBnk7kMeNPuZLo5F3EkdoQJOvBoOtm2D3C
	RdcUG1KJ500mVJ73KKFUYERHXf2NgdbB5WLXMSxwjfXEc0rb5WTImUbfXBCdTYRtZtSZ0u0OWGp
	xWcX1ERMGl0t+YYeWPk815VRFeqiLuOzgK83HNHbjz2wubd12V4PraGVkoih3G9Ejru0ciEtCaP
	KUkY9wlqHtOD4R939uKiVhxDi/+mqiPV2jid+pz1P+ct+7hfbb72s0ORFwsoqW3XI3PBLOa5QbK
	xEASf0hOael6/A0mQpw/5ysfxHCEafGdyHbImMJyCY5dxb8JRnEgLUeA/4w/qHIclmphdli+k=
X-Received: by 2002:a05:6a00:2e89:b0:845:da74:5d7c with SMTP id d2e1a72fcca58-84e93181143mr7635149b3a.32.1785332935009;
        Wed, 29 Jul 2026 06:48:55 -0700 (PDT)
Received: from localhost.localdomain ([115.192.250.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02ff637sm1425886b3a.39.2026.07.29.06.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 06:48:54 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	chamaken@gmail.com,
	vega@nebusec.ai,
	zihanx@nebusec.ai,
	stable@vger.kernel.org
Subject: [PATCH nf 1/1] netfilter: nf_conntrack_tcp: defer invalid logging until after unlock
Date: Wed, 29 Jul 2026 13:48:17 +0000
Message-ID: <b9b0022c68b6d0ac1a729f768466e3400a825a87.1785307981.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1785307980.git.zihanx@nebusec.ai>
References: <cover.1785307980.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_conntrack_tcp_packet() can log invalid packets while ct->lock is still
held. This happens both through tcp_in_window() -> nf_tcp_log_invalid()
and through the NFCT_TCP_INVALID path -> nf_tcp_handle_invalid().

If IPv4 invalid logging is bound to nfnetlink_log and the NFLLOG instance
has NFULNL_CFG_F_CONNTRACK enabled, the logging path re-enters conntrack
netlink glue and reaches tcp_to_nlattr(), which tries to take ct->lock
again. This results in recursive lock acquisition and can deadlock the
sender in queued_spin_lock_slowpath(), followed by stalls or panic.

Fix this by recording the minimal invalid-log context while ct->lock is
held and emitting the actual log records only after dropping the lock.
This keeps the existing invalid-log messages and still covers the timeout
lowering log from nf_tcp_handle_invalid(), but removes the lock recursion
from the logging path.

Fixes: a29a9a585b28 ("netfilter: nfnetlink_log: allow to attach conntrack")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 167 +++++++++++++++++++------
 1 file changed, 128 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ceeed3d7fe52..00f017d9997f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,37 +480,125 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 	}
 }
 
-__printf(6, 7)
-static enum nf_ct_tcp_action nf_tcp_log_invalid(const struct sk_buff *skb,
-						const struct nf_conn *ct,
-						const struct nf_hook_state *state,
-						const struct ip_ct_tcp_state *sender,
-						enum nf_ct_tcp_action ret,
-						const char *fmt, ...)
+enum nf_tcp_invalid_log_type {
+	NF_TCP_LOG_NONE,
+	NF_TCP_LOG_OVERSHOT,
+	NF_TCP_LOG_SEQ_OVER,
+	NF_TCP_LOG_ACK_OVER,
+	NF_TCP_LOG_SEQ_UNDER,
+	NF_TCP_LOG_ACK_UNDER,
+	NF_TCP_LOG_LOWER_TIMEOUT,
+};
+
+struct nf_tcp_invalid_log {
+	enum nf_tcp_invalid_log_type type;
+	u32 value;
+	u8 index;
+	u8 dir;
+	u8 last_index;
+};
+
+struct nf_tcp_invalid_logs {
+	/* At most one tcp_in_window() log plus one lower-timeout log. */
+	struct nf_tcp_invalid_log entries[2];
+	u8 num;
+};
+
+static void nf_tcp_queue_invalid_log(struct nf_tcp_invalid_logs *logs,
+				     enum nf_tcp_invalid_log_type type,
+				     u32 value, u8 index, u8 dir,
+				     u8 last_index)
+{
+	struct nf_tcp_invalid_log *log;
+
+	if (logs->num >= ARRAY_SIZE(logs->entries))
+		return;
+
+	log = &logs->entries[logs->num++];
+	log->type = type;
+	log->value = value;
+	log->index = index;
+	log->dir = dir;
+	log->last_index = last_index;
+}
+
+static enum nf_ct_tcp_action
+nf_tcp_log_invalid(const struct nf_conn *ct,
+		   const struct ip_ct_tcp_state *sender,
+		   struct nf_tcp_invalid_logs *logs,
+		   enum nf_ct_tcp_action ret,
+		   enum nf_tcp_invalid_log_type type,
+		   u32 value)
 {
 	const struct nf_tcp_net *tn = nf_tcp_pernet(nf_ct_net(ct));
-	struct va_format vaf;
-	va_list args;
 	bool be_liberal;
 
 	be_liberal = sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL || tn->tcp_be_liberal;
 	if (be_liberal)
 		return NFCT_TCP_ACCEPT;
 
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-	nf_ct_l4proto_log_invalid(skb, ct, state, "%pV", &vaf);
-	va_end(args);
-
+	nf_tcp_queue_invalid_log(logs, type, value, 0, 0, 0);
 	return ret;
 }
 
+static void nf_tcp_emit_invalid_log(const struct sk_buff *skb,
+				    const struct nf_conn *ct,
+				    const struct nf_hook_state *state,
+				    const struct nf_tcp_invalid_log *log)
+{
+	switch (log->type) {
+	case NF_TCP_LOG_OVERSHOT:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "%u bytes more than expected",
+					  log->value);
+		break;
+	case NF_TCP_LOG_SEQ_OVER:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "SEQ is over upper bound %u (over the window of the receiver)",
+					  log->value);
+		break;
+	case NF_TCP_LOG_ACK_OVER:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "ACK is over upper bound %u (ACKed data not seen yet)",
+					  log->value);
+		break;
+	case NF_TCP_LOG_SEQ_UNDER:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "SEQ is under lower bound %u (already ACKed data retransmitted)",
+					  log->value);
+		break;
+	case NF_TCP_LOG_ACK_UNDER:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "ignored ACK under lower bound %u (possible overly delayed)",
+					  log->value);
+		break;
+	case NF_TCP_LOG_LOWER_TIMEOUT:
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
+					  log->index, log->dir,
+					  log->last_index, log->value);
+		break;
+	case NF_TCP_LOG_NONE:
+		break;
+	}
+}
+
+static void nf_tcp_emit_invalid_logs(const struct sk_buff *skb,
+				     const struct nf_conn *ct,
+				     const struct nf_hook_state *state,
+				     const struct nf_tcp_invalid_logs *logs)
+{
+	u8 i;
+
+	for (i = 0; i < logs->num; i++)
+		nf_tcp_emit_invalid_log(skb, ct, state, &logs->entries[i]);
+}
+
 static enum nf_ct_tcp_action
 tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	      unsigned int index, const struct sk_buff *skb,
 	      unsigned int dataoff, const struct tcphdr *tcph,
-	      const struct nf_hook_state *hook_state)
+	      struct nf_tcp_invalid_logs *logs)
 {
 	struct ip_ct_tcp *state = &ct->proto.tcp;
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
@@ -640,31 +728,29 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			sender->td_end = end;
 			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 
-			return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-						  "%u bytes more than expected", overshot);
+			return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_IGNORE,
+					  NF_TCP_LOG_OVERSHOT, overshot);
 		}
 
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
-					  "SEQ is over upper bound %u (over the window of the receiver)",
-					  sender->td_maxend + 1);
+		return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_INVALID,
+				  NF_TCP_LOG_SEQ_OVER, sender->td_maxend + 1);
 	}
 
 	if (!before(sack, receiver->td_end + 1))
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
-					  "ACK is over upper bound %u (ACKed data not seen yet)",
-					  receiver->td_end + 1);
+		return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_INVALID,
+				  NF_TCP_LOG_ACK_OVER, receiver->td_end + 1);
 
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 	if (!in_recv_win)
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-					  "SEQ is under lower bound %u (already ACKed data retransmitted)",
-					  sender->td_end - receiver->td_maxwin - 1);
+		return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_IGNORE,
+				  NF_TCP_LOG_SEQ_UNDER,
+				  sender->td_end - receiver->td_maxwin - 1);
 	if (!after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1))
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-					  "ignored ACK under lower bound %u (possible overly delayed)",
-					  receiver->td_end - MAXACKWINDOW(sender) - 1);
+		return nf_tcp_log_invalid(ct, sender, logs, NFCT_TCP_IGNORE,
+				  NF_TCP_LOG_ACK_UNDER,
+				  receiver->td_end - MAXACKWINDOW(sender) - 1);
 
 	/* Take into account window scaling (RFC 1323). */
 	if (!tcph->syn)
@@ -720,10 +806,9 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 }
 
 static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
-					 enum ip_conntrack_dir dir,
-					 int index,
-					 const struct sk_buff *skb,
-					 const struct nf_hook_state *hook_state)
+				 enum ip_conntrack_dir dir,
+				 int index,
+				 struct nf_tcp_invalid_logs *logs)
 {
 	const unsigned int *timeouts;
 	const struct nf_tcp_net *tn;
@@ -764,9 +849,10 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 
 		timeout = READ_ONCE(timeouts[TCP_CONNTRACK_UNACK]);
 		if (expires > timeout) {
-			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
-					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
-					  index, dir, ct->proto.tcp.last_index, timeout);
+			nf_tcp_queue_invalid_log(logs,
+						 NF_TCP_LOG_LOWER_TIMEOUT,
+						 timeout, index, dir,
+						 ct->proto.tcp.last_index);
 
 			WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
 		}
@@ -971,6 +1057,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
 	enum nf_ct_tcp_action res;
+	struct nf_tcp_invalid_logs logs = {};
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -1252,14 +1339,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	}
 
 	res = tcp_in_window(ct, dir, index,
-			    skb, dataoff, th, state);
+			    skb, dataoff, th, &logs);
 	switch (res) {
 	case NFCT_TCP_IGNORE:
 		spin_unlock_bh(&ct->lock);
+		nf_tcp_emit_invalid_logs(skb, ct, state, &logs);
 		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
-		nf_tcp_handle_invalid(ct, dir, index, skb, state);
+		nf_tcp_handle_invalid(ct, dir, index, &logs);
 		spin_unlock_bh(&ct->lock);
+		nf_tcp_emit_invalid_logs(skb, ct, state, &logs);
 		return -NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
 		break;
-- 
2.43.0

