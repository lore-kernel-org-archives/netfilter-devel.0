Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406C43B492
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419786; cv=none; b=uZyCx9aAVExAdruPs7jrS3taxNkPdgBl29Kr47bI1sO18xLNw9l/ACZw44WR5U68eFsR14pOKBi92qdX50DMbkiYKZiAIjaLEmZCIIj3i/MQMgvW+UGvknNnEm62Xkwr20eW7Box3e+40ztYSoSm3aX7CNbBWYEEyET9KAMV0+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419786; c=relaxed/simple;
	bh=/RgzJzMkBYDPKjVaTao/aTQHqE6FwYxLY8QPTP1sRqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNAk9Hy5fU23wiuwukXgB9AdNXVfi7sOEw7uVoy9uKoF1FJirz/OylpMwnQExuFxsQFqy8AE9Q/XsLHXxO4bTKSxJd8Alwm6ksD6E7lyeTFkoYz4lKSCXkgRxnXqwuDiER4hZWFYrt3CYS06emxqw9LK2vFVpDjFNDoCb2RJsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=J2Ye/ls7; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="J2Ye/ls7"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccbff2e6a7so10943125ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785419784; x=1786024584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g4UgEAPWiFQvj83uSKPLHHyFuVn87DefEO+podN7OKQ=;
        b=J2Ye/ls76wzXS7rMt9ao+F9HdFqNHl4AZtTnwwzWB28JDtM0sm8GM1HjOqhl6SZV8n
         dc5i3UdP2WNrQEBhT6h3ZZvMFUJJe9ch5toB8h0c/qasrT/0k88o9l2FMmjN92rF6wCG
         +RYgT+RyP0iTLclIYb02oSZgJ4oqgQMgvZW99maCjjKGf/U2JfL4BHSnxgPTVL7YCbW+
         b51HKq3sjdvd1Rccd/2cT1gyGnABE6//bBqHnpeioU2fCaNCZjgiCTIX88g5lcojx39U
         H1qBlNa7MxQ61EXfRWB9wkm+bxpoNwFASqLQhCw4/kZlpX5Q98x/jgsth2pPJbeveWoj
         2G/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419784; x=1786024584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g4UgEAPWiFQvj83uSKPLHHyFuVn87DefEO+podN7OKQ=;
        b=XdaK4gKDfBkhyZpsvmiYoewArwK60EulOaA9+zLOkCGKRbvPAA1UhYzpSebbcnwY2x
         eVjqv7uy2J3D+iHK8a0yPbd3WmCmFTwDvO1CJH3N6cwij2oVLp2nHmsYqqWFMDgAoQi1
         91A/JqaTETy7nOjtB1UN/TmU4s2Hm+9ogiNnmKMghLq8c/Fr9OdmIkMbIQ4LiMDOvZ7z
         sI5A67wDgqd0JdC+PiYlDst30L9ObpddPvv3b0Iw9NebV8SxPON+5144yjHRhiDHZAH2
         uSlvRPswLtFMoHFZ7Y8OVu7KpJJTMYtk1zSFSbWDuU+eqaLQPWBaafIEYz/qckiXjk6V
         KWSw==
X-Gm-Message-State: AOJu0YwV1QFtXUu3XfVt1PywOczFMMT/LLQS3ZgxyvxwzG2ByihdVjUU
	cbfmzPNvmXf7k/fJ+732NWM1WsVzl3d4DAuj6PiqBbq4RixaOHV9SocNuQ9WglhknenDxtJBGOp
	ixGaXJLLCQ1A=
X-Gm-Gg: AR+sD13ICLhi2HnCToss/PBkrsOu4jbe1Ps4zLKUAPWvHGowZmZmuTS2rkV3i+kcIls
	G+dI5VUjhNfkIJuaAiLjr7Byl/D70nvkBTsdHEHOst4U2fo4JttBJVNgQYyOt+i3o+kfbT7ueQc
	QuZbTdUTXyEUWdI/0I/GHCxv8UybpfNg1OqIBCiU6fPBFSntI2pxRIYHe40U70EyyrcsfcsGC/i
	2HyWOOD0i7UPEQ4nnvlyenklvhjjbm9d6NmUgqQFm/MAE1RfjO55byvBV8yvI++yMhnpOMqGDYg
	PZXTBw9dFAo4N1gRWkfhNkc7f/TDy1LEa21wQvcFKkUR+hSVnMFXk3H35lFpciJ0Ikec/zibx7k
	diUO4PiUABapi0pEinNNCWbUJoAaw3tycI8DmQMAoDqGL69G/wj/EoKemMD+FIJ4ZrnAv/+78IS
	4EDqk+mzB1XJgBUpS8cKhcoZdtjIKUCoXnk7Is690W4ybUq6Gq7fGO0K4lIgqrKJPDAIbq9k4=
X-Received: by 2002:a17:902:f54b:b0:2cf:477f:57c5 with SMTP id d9443c01a7336-2d035beddabmr25384705ad.1.1785419784324;
        Thu, 30 Jul 2026 06:56:24 -0700 (PDT)
Received: from localhost.localdomain ([115.192.250.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c8b9aasm27398055ad.50.2026.07.30.06.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:56:23 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	avagin@gmail.com,
	vega@nebusec.ai,
	zihanx@nebusec.ai
Subject: [PATCH nf v2 2/2] netfilter: nf_conntrack_tcp: defer tcp_in_window invalid logging until after unlock
Date: Thu, 30 Jul 2026 13:55:44 +0000
Message-ID: <27612fbff3730c5d63a0e3fb0f51aeeed77ed5d7.1785348197.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1785348197.git.zihanx@nebusec.ai>
References: <cover.1785348197.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcp_in_window() can emit several invalid-packet logs while ct->lock is
still held.  If invalid logging is routed to nfnetlink_log with
conntrack export enabled, this can re-enter conntrack netlink glue and
recurse into tcp_to_nlattr() on the same conntrack.

Fix this by storing only the minimal invalid-log context for the
remaining tcp_in_window() cases and emitting the actual log after
releasing ct->lock.  Rename the helper to reflect that it now records
context instead of logging immediately, and add an explicit lockdep
assertion plus comment to document that invalid TCP logs must not be
emitted while ct->lock is held.

Fixes: d48668052b26 ("netfilter: fix nf_l4proto_log_invalid to log invalid packets")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Keep only the tcp_in_window() invalid logging cases in this patch.
  - Rename the helper to reflect that it stores invalid-log context.
  - Add a lockdep assertion and comment documenting that invalid logs must not be emitted under ct->lock.
  - v1 Link: https://lore.kernel.org/all/cover.1785307980.git.zihanx@nebusec.ai/
---
 net/netfilter/nf_conntrack_proto_tcp.c | 113 ++++++++++++++++++-------
 1 file changed, 82 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ef31dcaffd19..e5875b7528fe 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,37 +480,87 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
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
+	/* nfnetlink_log may re-enter conntrack attribute dumping and try to
+	 * take ct->lock again via tcp_to_nlattr(), so invalid TCP logs must
+	 * only be emitted after dropping ct->lock.
+	 */
+	lockdep_assert_not_held(&ct->lock);
+
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
@@ -640,31 +690,29 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
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
@@ -967,6 +1015,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
 	enum nf_ct_tcp_action res;
+	struct nf_tcp_invalid_log log = {};
 	bool lowered_timeout = false;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
@@ -1249,14 +1298,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
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
 		lowered_timeout = nf_tcp_handle_invalid(ct, dir, index);
 		spin_unlock_bh(&ct->lock);
+		nf_tcp_log_invalid(skb, ct, state, &log);
 		if (lowered_timeout)
 			nf_ct_l4proto_log_invalid(skb, ct, state, "lowered timeout to UNACK");
 		return -NF_ACCEPT;
-- 
2.43.0

