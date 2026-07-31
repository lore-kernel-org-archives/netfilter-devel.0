Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48F2EB84E
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505519; cv=none; b=cwZumMGCG7ICHkHB2F5rAT0OCEkVuVp8SEPviEin9cuWFEm4xmSyoeJx6LQ4/4exOjjRxk0InjzmzIaZPtDpKueP1HzIVtHYOGJxZffmlGGx+HZVaX114uXBu4rMGIjuJoK9meoE6kHGNtheQCdyi2RlrnUlGezIAiIBi0w4qOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505519; c=relaxed/simple;
	bh=wcvuo7jobVRnuZikkHUxpAj20uJfW6k2v0+OPfZHULs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZombCtmrsGiH5emqLrpDn3KLq5hErZzoAIkR/hmGBHE54XYQmRNfOOEjmI54ma6yafXvCc0chw54MhVk42uelxEvsCEF6vvpmsoxw8Un0zrNa+hrH4IZwV2H/fKg+G3cTbGgOiFN6WjKjoFYZwpbyhSqcKGAcL9GRqQhssHBKNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=SjPZog7v; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="SjPZog7v"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so1235361b3a.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 06:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785505517; x=1786110317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wE6O1I0Qq5sVQi2ZdHd9ToEkv1X3Gqln5+kwt1LugnY=;
        b=SjPZog7vAOZk0XHA1cgaRWyNNq7WcVDtySS5tBcWOK+h35sKEJUD1j6Fwc4zCPCEMT
         OLtjQZZjn+/mEzh0YmTbAYbLslhKycGj2R6LitKodlL1GNsynQwdER2W2vNskiIX5Dy3
         nMwhHMcbcDSHcXnHj17O2FGlE33CweoeO4rTEMEJLzCo/iLsrosOqQ2ApZlGy7JRLQq7
         HM/xx7CC1TCIP34n0aoimrtEJO2+KoimO3ARg9oJEiJdn1xzv1NtvPmqgpFNI+o539tp
         ISZx8MbG6up/sH97/MRsMn1fjx/B/xi8Y8FWwiFeLnPSjC11Fh32CvRXatEA6tZhv9Bn
         dEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785505517; x=1786110317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wE6O1I0Qq5sVQi2ZdHd9ToEkv1X3Gqln5+kwt1LugnY=;
        b=nPJjSrC6Bdz6WO9bJH8+LCV3EDOIsRycAh8y6Cpu4cFiuj9ai1pl40sOqm6/ZAtjNw
         DRbEZ4RqfIKE9d8tTFXYLTJdTogMW37EqA10sJwM51T58C2a7bXp4rAs3C5Gz34Pgc4F
         9gKDy0yIXLNCUSYObnDOAp4px1Z+od+GAkCPkpfVecyTPedcNNH9kYzCOJ1cZOHdcd69
         JXAoqUOLCpicYh1t0CohUMRwEro5r4AvfY6W9tOelToaK3sQx8qNgP6kordG46muVQKi
         /pnTGy0voYGwOaYKzueCnqceaiebDjSrmtydBduLAo0v1GhUFCZkwaQUmSUoc9c251Ew
         X7ng==
X-Gm-Message-State: AOJu0YzY+l4TGKVcrS66ViRAY5mFQwnqZMH8I481XvyIa4aZ02/QxzLS
	KlLoPVk7XZG2VkQxmLJsLmdM+I3wv2+7+VcyjK1ZhjGN7XtRipzEnRP9Vt6JnFIQxuNxgBACaO7
	InV5nRNu3
X-Gm-Gg: AR+sD11s1xPxMbBKGxHA52r85nSR85r1fLem4UjGsxqIa4uDVRGEV/14klNwV7aVjvT
	FIYO/NP6BK8NHi0JB+iSsUWcnq6LAonHRLPa0NVv+tP+GksH5lkCiqQ2kdQVq4jPnUAuNMQbYkS
	EP0SesOynfDiRwDgZAAUvjZ+tL4Wf1CA1dzd8im2BV/GgqQkr4wusf19ftOakXM4o3userIdpSX
	i5cOAT0uId/7g7T9getdsuhzNxTPoAqJ2m4F5ii3yvIi+yMdEvtu3SS4KSvCfNQ0ulrSEgNGORX
	5jLayzGtqb93AJKIoB2LrgqW5h/6BU14+58kWNUpMMsc90PRupXygpUOMYP7s+EtY7I18Da5zDr
	U5KusvnYxE4m/Q9ec8PcplqijSQMiIr2aqmeQj7bey6h8rHQiI0TRselX6YKx7IFv4J1KmoIXMg
	CRnrNIesUmLTjLpdLgTGC4HKvNDMtAV9gJ3YiX94BoOIqJasNwbjQ02cplnZ3+kHa7iRWoYSe3P
	GdTqDCxeA==
X-Received: by 2002:a05:6a00:1ca6:b0:842:708f:39be with SMTP id d2e1a72fcca58-84ed6d9b4a8mr1926849b3a.5.1785505517384;
        Fri, 31 Jul 2026 06:45:17 -0700 (PDT)
Received: from localhost.localdomain ([115.192.250.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbd31585sm493836b3a.3.2026.07.31.06.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 06:45:16 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	vega@nebusec.ai,
	zihanx@nebusec.ai
Subject: [PATCH nf v3 1/1] netfilter: nf_conntrack: defer invalid log until after unlock
Date: Fri, 31 Jul 2026 13:44:39 +0000
Message-ID: <d60e62141f53ce698745909398f94be9af8f0a93.1785497202.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1785497202.git.zihanx@nebusec.ai>
References: <cover.1785497202.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TCP and SCTP conntrack paths can emit invalid-packet logs while ct->lock
is still held.

When invalid logging is routed to nfnetlink_log and conntrack export is
enabled, the log path can re-enter conntrack netlink glue and dump the
same conntrack again. Protocol attribute dumping may take ct->lock, so
logging while holding that lock can deadlock.

Defer the TCP invalid logs by storing only the minimal log context while
ct->lock is held and emitting the log after unlocking. Also make the TCP
timeout-lowering invalid path return whether a log is needed, then emit
that log after unlocking.

Do the same for the SCTP invalid state-transition log that can be reached
while ct->lock is held.

Add a lockdep assertion to nf_ct_l4proto_log_invalid() so future callers
that log invalid conntracks while holding ct->lock are caught outside TCP
and SCTP as well.

Fixes: 628d694344a0 ("netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst")
Fixes: d9a6f0d0df18 ("netfilter: conntrack: prepare tcp_in_window for ternary return value")
Fixes: f71cb8f45d09 ("netfilter: conntrack: sctp: use nf log infrastructure for invalid packets")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
changes in v3:
  - Squash the previous two TCP patches into one patch as requested.
  - Include the SCTP invalid state-transition log in the same logical fix.
  - Move the lockdep assertion and recursion comment into nf_ct_l4proto_log_invalid().
  - Adjust the TCP local declaration order per review.
  - Use the broader nf_conntrack subject suggested by Pablo.
  - Correct the Fixes: set to the first held-lock invalid-log call sites.
  - Keep Florian Westphal's Reviewed-by.
  - v2 Link: https://lore.kernel.org/all/cover.1785348197.git.zihanx@nebusec.ai/
changes in v2:
  - Split the TCP timeout-lowering and tcp_in_window() handling for review.
  - Switch the reproducer documentation to the packetdrill wrapper flow.
  - Keep the decoded crash log and real reproduction artifacts in the cover letter.
  - v1 Link: https://lore.kernel.org/all/cover.1785307980.git.zihanx@nebusec.ai/
---
 net/netfilter/nf_conntrack_proto.c      |   6 ++
 net/netfilter/nf_conntrack_proto_sctp.c |  12 ++-
 net/netfilter/nf_conntrack_proto_tcp.c  | 132 ++++++++++++++++--------
 3 files changed, 102 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index ad96896516b6..9439596f34e6 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -83,6 +83,12 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 	if (likely(net->ct.sysctl_log_invalid == 0))
 		return;
 
+	/* nfnetlink_log may re-enter conntrack attribute dumping and try to
+	 * take ct->lock again via helpers such as tcp_to_nlattr(), so invalid
+	 * conntrack logs must only be emitted after dropping ct->lock.
+	 */
+	lockdep_assert_not_held(&ct->lock);
+
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7e10fa65cbdd..dd90f1df9d55 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -339,7 +339,9 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	u_int32_t offset, count;
 	unsigned int *timeouts;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
+	bool log_invalid = false;
 	bool ignore = false;
+	u8 invalid_type = 0;
 
 	if (sctp_error(skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -451,10 +453,8 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 		/* Invalid */
 		if (new_state == SCTP_CONNTRACK_MAX) {
-			nf_ct_l4proto_log_invalid(skb, ct, state,
-						  "Invalid, old_state %d, dir %d, type %d",
-						  old_state, dir, sch->type);
-
+			log_invalid = true;
+			invalid_type = sch->type;
 			goto out_unlock;
 		}
 
@@ -529,6 +529,10 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 out_unlock:
 	spin_unlock_bh(&ct->lock);
+	if (log_invalid)
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "Invalid, old_state %d, dir %d, type %d",
+					  old_state, dir, invalid_type);
 out:
 	return -NF_ACCEPT;
 }
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ceeed3d7fe52..93272aafd289 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,37 +480,81 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
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
+};
+
+struct nf_tcp_invalid_log {
+	enum nf_tcp_invalid_log_type type;
+	u32 value;
+};
+
+static enum nf_ct_tcp_action
+nf_tcp_store_invalid(const struct nf_conn *ct,
+		     const struct ip_ct_tcp_state *sender,
+		     struct nf_tcp_invalid_log *log,
+		     enum nf_ct_tcp_action ret,
+		     enum nf_tcp_invalid_log_type type,
+		     u32 value)
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
+	log->type = type;
+	log->value = value;
 	return ret;
 }
 
+static void nf_tcp_log_invalid(const struct sk_buff *skb,
+			       const struct nf_conn *ct,
+			       const struct nf_hook_state *state,
+			       const struct nf_tcp_invalid_log *log)
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
+	case NF_TCP_LOG_NONE:
+		break;
+	}
+}
+
 static enum nf_ct_tcp_action
 tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	      unsigned int index, const struct sk_buff *skb,
 	      unsigned int dataoff, const struct tcphdr *tcph,
-	      const struct nf_hook_state *hook_state)
+	      struct nf_tcp_invalid_log *log)
 {
 	struct ip_ct_tcp *state = &ct->proto.tcp;
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
@@ -640,31 +684,29 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			sender->td_end = end;
 			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 
-			return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-						  "%u bytes more than expected", overshot);
+			return nf_tcp_store_invalid(ct, sender, log, NFCT_TCP_IGNORE,
+				   NF_TCP_LOG_OVERSHOT, overshot);
 		}
 
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
-					  "SEQ is over upper bound %u (over the window of the receiver)",
-					  sender->td_maxend + 1);
+		return nf_tcp_store_invalid(ct, sender, log, NFCT_TCP_INVALID,
+				   NF_TCP_LOG_SEQ_OVER, sender->td_maxend + 1);
 	}
 
 	if (!before(sack, receiver->td_end + 1))
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
-					  "ACK is over upper bound %u (ACKed data not seen yet)",
-					  receiver->td_end + 1);
+		return nf_tcp_store_invalid(ct, sender, log, NFCT_TCP_INVALID,
+					   NF_TCP_LOG_ACK_OVER, receiver->td_end + 1);
 
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 	if (!in_recv_win)
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-					  "SEQ is under lower bound %u (already ACKed data retransmitted)",
-					  sender->td_end - receiver->td_maxwin - 1);
+		return nf_tcp_store_invalid(ct, sender, log, NFCT_TCP_IGNORE,
+					   NF_TCP_LOG_SEQ_UNDER,
+					   sender->td_end - receiver->td_maxwin - 1);
 	if (!after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1))
-		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
-					  "ignored ACK under lower bound %u (possible overly delayed)",
-					  receiver->td_end - MAXACKWINDOW(sender) - 1);
+		return nf_tcp_store_invalid(ct, sender, log, NFCT_TCP_IGNORE,
+					   NF_TCP_LOG_ACK_UNDER,
+					   receiver->td_end - MAXACKWINDOW(sender) - 1);
 
 	/* Take into account window scaling (RFC 1323). */
 	if (!tcph->syn)
@@ -719,11 +761,8 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	return NFCT_TCP_ACCEPT;
 }
 
-static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
-					 enum ip_conntrack_dir dir,
-					 int index,
-					 const struct sk_buff *skb,
-					 const struct nf_hook_state *hook_state)
+static bool __cold
+nf_tcp_handle_invalid(struct nf_conn *ct, enum ip_conntrack_dir dir, int index)
 {
 	const unsigned int *timeouts;
 	const struct nf_tcp_net *tn;
@@ -732,7 +771,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status) ||
 	    test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
-		return;
+		return false;
 
 	/* We don't want to have connections hanging around in ESTABLISHED
 	 * state for long time 'just because' conntrack deemed a FIN/RST
@@ -747,7 +786,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 	case TCP_FIN_SET:
 		break;
 	default:
-		return;
+		return false;
 	}
 
 	if (ct->proto.tcp.last_dir != dir &&
@@ -755,7 +794,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 	     ct->proto.tcp.last_index == TCP_RST_SET)) {
 		expires = nf_ct_expires(ct);
 		if (expires < 120 * HZ)
-			return;
+			return false;
 
 		tn = nf_tcp_pernet(nf_ct_net(ct));
 		timeouts = nf_ct_timeout_lookup(ct);
@@ -764,16 +803,15 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 
 		timeout = READ_ONCE(timeouts[TCP_CONNTRACK_UNACK]);
 		if (expires > timeout) {
-			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
-					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
-					  index, dir, ct->proto.tcp.last_index, timeout);
-
 			WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+			return true;
 		}
 	} else {
 		ct->proto.tcp.last_index = index;
 		ct->proto.tcp.last_dir = dir;
 	}
+
+	return false;
 }
 
 /* table of valid flag combinations - PUSH, ECE and CWR are always valid */
@@ -970,7 +1008,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
+	bool lowered_timeout = false;
 	enum nf_ct_tcp_action res;
+	struct nf_tcp_invalid_log log = {};
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -1252,14 +1292,18 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	}
 
 	res = tcp_in_window(ct, dir, index,
-			    skb, dataoff, th, state);
+			    skb, dataoff, th, &log);
 	switch (res) {
 	case NFCT_TCP_IGNORE:
 		spin_unlock_bh(&ct->lock);
+		nf_tcp_log_invalid(skb, ct, state, &log);
 		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
-		nf_tcp_handle_invalid(ct, dir, index, skb, state);
+		lowered_timeout = nf_tcp_handle_invalid(ct, dir, index);
 		spin_unlock_bh(&ct->lock);
+		nf_tcp_log_invalid(skb, ct, state, &log);
+		if (lowered_timeout)
+			nf_ct_l4proto_log_invalid(skb, ct, state, "lowered timeout to UNACK");
 		return -NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
 		break;
-- 
2.43.0

