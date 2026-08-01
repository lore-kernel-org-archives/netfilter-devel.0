Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0616F35C1B1
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2026 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785594479; cv=none; b=rxY0dsrXFdPq9eXuOkzMbibXDCnNqqFVfK0EqmhOQWaxeLDxoBOOqhpFvhrKSkfuxKMtGDRJjReUDnN//kQGg0dFl5PBSMfnECCbMtNcRPdzs6Bf/pSz+4aKNGtjcKCH2bA/rHE0zCth/uvuwHHBNjdEqYvbD8nTpncoeOKsI7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785594479; c=relaxed/simple;
	bh=1Y4Z+wxcZz44SFcRSjBPXjGmzGh0//kTdxe3WRASvVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzGyI6ZyBStI1JXfaNeUxFyyiuH2lFJ7TgVHCxAns38CNnU2YHPfgdyB62jGMO4n+LbgXt7D6hMySHNc91icBv0sdPnDqrFJoM+8op9GfJhkPq7f0AAaopGZKOLqOVScqb+kTaK1ehL9DwTy+Q6+hOXaRrcZ6ZNzvJosbEyp9jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=bEVoSzi6; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="bEVoSzi6"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848595b338cso2513154b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2026 07:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785594476; x=1786199276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXCJlNdszvqV9bqct3ijEsKPGLa4lcivhEkKV7SeMtU=;
        b=bEVoSzi6sHeekS6hc6+kxKxvJuBSgZe7blnXbupfv+YTtxBlVne43jnsmiZLM/TGdr
         xhM4VXN+TOQcsp2R149i2vDzvjBRc2ltD4iD5WevT9xtVKCgXGJBSOGrxpb0CBnOkoRM
         NYedIy9MKk6upyWP7FG+i82oGP8zw5TZX5TLpkTWdh1k/EROHFJFtmtjYYlaNrGqL1fA
         t+jBzoomJ5vUHveu+vH32Jojba/XHqG03qq/84WHEcTpWghkHYnKfVNjbYaPfcpxthsD
         J08bUgO/TCJ/eHVAWsvAJ5rPqd2/8yefM0nxp5Y1WWxI2JQ65wl+5aL8QoVw9SXWHea7
         RkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785594476; x=1786199276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXCJlNdszvqV9bqct3ijEsKPGLa4lcivhEkKV7SeMtU=;
        b=cN1y3DPnc1Kfmk+4mX/C3m5eRCRU0BQmkPV8smphtTyJ8lokwFf9L7wuwp6S9YJSQi
         X/Ev2j3c2H++OoUTpGBBwVBWNu8vxbXRqhpFArMGhHrBLwXshRQIpAmH8OsNxDhpNcUA
         Z33FgDXeCuFVk0D4WSkdkbuDSNQR2crCfLSCX9ocnqf+kn1gYvhWkfIGi//eCh7AifUA
         YdZ4CCZAf9qrfl2m01nd1jWDUsrpFzbAws2oL0HmD2/10ABGR/THmE+zQB1J5VHRNiB0
         EcUVlfFHQx61k6AL5/+G0PPputtz6K1SLW8AYqcwGSJ1nL82MsTQu+GvT06pDsl6AAt7
         jqQQ==
X-Gm-Message-State: AOJu0YyxsXVDn3E9Q+VeRmTyKO9QS2mnMMC1QBnaiZfNvbr6iixtxncj
	yla19iFvAj0pVn8ieO2vXcp/AP4ahgk678P0HizgwSCmYnbRkm/eKOIUZT3JTeeia6aiS22ZwlC
	h4S0A8c3HWgM=
X-Gm-Gg: AR+sD11p+5OfoIA4cNP1w/BtGdzYrg9Z3cw0LkwKyVxC/nhjrB2P+G1GSiVlABJFMM9
	/cvgtV26ag+s7k40oiaLXWbG0Jpk3ZQrUvKpmYgqWiDmaA99logHEbKplgzYWMYJsWt3HTXhOld
	7etewJQgoVl4NzlkqasBxCovrEURFgjb6ar4aGtaZvwl+1AZycP4CwPrYPMk4MHPs0vA/j3LyIh
	vEkQOG/BRQEbd9Lbs+Pj7wgSfRsZivASC7aKr243opJRuShrQznGZ+YBpNhA66KuW5h3CP1Hi6E
	F333o2l6EGvhx/owD16x9uPZ/E5ieJRQu1HMunh7sQuTmwD4NiurXMqoKkdbKfwufBut2JxSqII
	3RpCvPZuK5Gz8tOSUuEGp/F8IdWoB2Or55i1RcNT1rFlisv1TXf49xpA5fCH/T/nVGOFdsLuvgm
	8sR5wjMxXETJjUPTW9J9igadVfowE5SjzuR2Av1bMbV0Pa2E2BHPQ6P2wc11NKOWTc/BAsuw==
X-Received: by 2002:a05:6a00:2294:b0:848:4c0c:59b4 with SMTP id d2e1a72fcca58-84ee48eb9b4mr3187498b3a.64.1785594475606;
        Sat, 01 Aug 2026 07:27:55 -0700 (PDT)
Received: from localhost.localdomain ([115.192.251.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe57bccsm1743184b3a.20.2026.08.01.07.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 07:27:55 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	vega@nebusec.ai,
	zihanx@nebusec.ai
Subject: [PATCH nf v4 1/1] netfilter: nf_conntrack: defer invalid log until after unlock
Date: Sat,  1 Aug 2026 14:27:17 +0000
Message-ID: <20260801142749.3402-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1785584660.git.zihanx@nebusec.ai>
References: <cover.1785584660.git.zihanx@nebusec.ai>
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
changes in v4:
  - Make the lockdep assertion unconditional by placing it before the sysctl check.
  - v3 Link: https://lore.kernel.org/all/cover.1785497202.git.zihanx@nebusec.ai/
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
index ad96896516b6..7a40e4e0e33e 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -79,6 +79,12 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 	struct net *net;
 	va_list args;
 
+	/* nfnetlink_log may re-enter conntrack attribute dumping and try to
+	 * take ct->lock again via helpers such as tcp_to_nlattr(), so invalid
+	 * conntrack logs must only be emitted after dropping ct->lock.
+	 */
+	lockdep_assert_not_held(&ct->lock);
+
 	net = nf_ct_net(ct);
 	if (likely(net->ct.sysctl_log_invalid == 0))
 		return;
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

