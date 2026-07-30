Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC6243BDD1
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419780; cv=none; b=Uc1z96pa1vOrKL8II3QcECzaKja8SbVYmchy3bpFEgtuWfqp8l0Xf/B+7ZWD1H1p0SuYHxtTPkYEkMl2FArUE264GvRJQNidk/rDxiUlySw5vvVOS34JZe2N9diiSozqKiYulLgOi0AbuSq09EkJzJcbWNz4hJh3XnLrLLEUL7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419780; c=relaxed/simple;
	bh=rg5sMZ+QsbwyWHE+BdUNDdM1pyi2kf4trkXAWh3b1zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzbluY89f/z6BYnxoMr+84sXEvPcu3ze/H+hJUlowvvjxqdpeF/H30LeToUBs/3T9rlzxHNiLORAsDZ7E6OmzU3CSRZazuA3qEihjtw8K16onq9wTFT5aCf7jbUyqn9rSg5vqZ4ctZcGxmisQF9fxWzOCDQ6nhgoeFY5NKPR6lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=OeZNnMjP; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="OeZNnMjP"
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2cc80544c74so5983995ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785419778; x=1786024578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h7olep+BcstjZxtGRQQTtcvBvhP4Q1QEggNCUGb7V28=;
        b=OeZNnMjPTh/5jwlIFnOQ3bO/XQ5FE7FFh4mmpnaOjVtxLW9hZE1Yi0b1V/p0NtkLyI
         Vd3VrrZDAEBMQ3Y/n6Zb6+YcqoFZdYSPhG4vEW2Llv9L2w3dCnlPy6HYRL/JQ8Djn3DC
         DV53h9YJYjeycskTogRlZEAPGMc2c0ndTHet6r+VdpugiooP1e34HFuMsLN3MrKeEhxN
         n61z2O7VraS4Qdz/6KgkLIsd0AXhuDjV6oXLVSNOUkFwJDVJ4opLE4grvTrjF2I8GdAp
         OltyoeQ7DvJkTQafXLq4RC3e+AhtvNSDn7L6JiXh6NR0rAQ7dgpj1l96BUj8aQhqY/ns
         RMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419778; x=1786024578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h7olep+BcstjZxtGRQQTtcvBvhP4Q1QEggNCUGb7V28=;
        b=hZNeQgUcxdqg2cV9kHikznnQh/fNHlZx/XwKWPPuDpWTJhB3eds2WO2KGS7Ao9c+SD
         VIRxOx/6NiGklX3wTDi4CYqW2ev9mlnVsBnjwGLx38SJP3ndfLMQzmLNGkEh2SYvIKdL
         RHC5YbyJx+5PW1DxAXoN3LRQaitVIzLN3NFZfxAyK1ROVi1QpJJQ5F49QZGq0A6TuKiG
         irebCRPFZfQLGD+2Nb6pqJDZgb1RM9tlHmvhWUGsF9/hE7QTGfB7AH300Dubod6SYHjO
         Pwe2VznKbYhiWJiU4GZAxI9DY9ABVMQUmIkyykOaeOcXSmRzhfpZVceydrJIh9f+9H+B
         Vlqw==
X-Gm-Message-State: AOJu0Yy1BQBr6jgJhz4YMy9bcwCItMfBzveXybCj8NGSu/x19aIemy43
	UmShLgA9rl+mdJU8X+Y7BteGGhTf9mLEDTQ9zVZVZb7IoOT6LYcyHiJcyLT6tnLp7JYW4i1m96C
	AZ3nxJryswwY=
X-Gm-Gg: AR+sD121w0wAOVdJwx3feoKskWDP4HF1hdK/RM1QuqFdU35sUBWPYy469JBudWaJBoo
	WewxNW8CCyM29V2dhk6Ye7zElosE+Yc6kDo1BnNqZR3YCgX92tUFtXoP9V2wZWDtuze2hvLS1Rc
	ZJaA7ieJYnhZgjAUmRkoL24fIURCUgR2u1tY+LRlQNMqoGqkyBv9KalOdQ4NSX34iDCAziA81/J
	Ap+rjRG7I4F/uRh34qc8QkW3WZXJr+doCb+wQ4Fl9ARjERqT0pdKxjZp/fk9/mg5qqbO6okOUGA
	WX6sUA0s3Pl2KI9zlNDsD7W51aB48ZN6y8fUvNptNXlY8hmoTUg8xMBO9cBm7zAXe0cxK/Adzth
	rMZpYDbSD//jay1LJXLb7CyfhALY6+OI1Vcj6usOrVXQms2oF1IMTY8UPoNAivKheomG2R/9hD0
	qT+juPcXdKjosKC4cj47UxGLHP5YoNyTiMZzpxa22YtAMtKBuK6Lg/b2E8yUu828nEJ4PtMgM=
X-Received: by 2002:a17:903:3585:b0:2ca:6514:9201 with SMTP id d9443c01a7336-2d035baa232mr27870235ad.15.1785419778244;
        Thu, 30 Jul 2026 06:56:18 -0700 (PDT)
Received: from localhost.localdomain ([115.192.250.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c8b9aasm27398055ad.50.2026.07.30.06.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:56:17 -0700 (PDT)
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
Subject: [PATCH nf v2 1/2] netfilter: nf_conntrack_tcp: defer timeout-lowering invalid log until after unlock
Date: Thu, 30 Jul 2026 13:55:43 +0000
Message-ID: <e387bc8da39f47fe48fddb576125805273a9a48d.1785348197.git.zihanx@nebusec.ai>
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

nf_tcp_handle_invalid() can lower the timeout of an assured TCP
conntrack when an out-of-window FIN/RST is answered from the other
direction.  Today it also logs that event while ct->lock is still held.

If invalid logging is routed to nfnetlink_log and conntrack export is
enabled, the log path can re-enter conntrack netlink glue and recurse
into tcp_to_nlattr() on the same conntrack.  Move this timeout-lowering
log emission out from under ct->lock by making nf_tcp_handle_invalid()
return whether logging is needed, then emit the message after unlocking.

Keep the timeout update unchanged and simplify the log text so this path
does not need to stash extra state while the lock is held.

Fixes: 628d694344a0 ("netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Split the timeout-lowering log handling out of the larger invalid-log fix.
  - Make nf_tcp_handle_invalid() return a bool and log after unlocking.
  - Simplify the log text so no extra lock-held state needs to be stashed.
  - v1 Link: https://lore.kernel.org/all/cover.1785307980.git.zihanx@nebusec.ai/
---
 net/netfilter/nf_conntrack_proto_tcp.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ceeed3d7fe52..ef31dcaffd19 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -719,11 +719,8 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
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
@@ -732,7 +729,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status) ||
 	    test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
-		return;
+		return false;
 
 	/* We don't want to have connections hanging around in ESTABLISHED
 	 * state for long time 'just because' conntrack deemed a FIN/RST
@@ -747,7 +744,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 	case TCP_FIN_SET:
 		break;
 	default:
-		return;
+		return false;
 	}
 
 	if (ct->proto.tcp.last_dir != dir &&
@@ -755,7 +752,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 	     ct->proto.tcp.last_index == TCP_RST_SET)) {
 		expires = nf_ct_expires(ct);
 		if (expires < 120 * HZ)
-			return;
+			return false;
 
 		tn = nf_tcp_pernet(nf_ct_net(ct));
 		timeouts = nf_ct_timeout_lookup(ct);
@@ -764,16 +761,15 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 
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
@@ -971,6 +967,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
 	enum nf_ct_tcp_action res;
+	bool lowered_timeout = false;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -1258,8 +1255,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		spin_unlock_bh(&ct->lock);
 		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
-		nf_tcp_handle_invalid(ct, dir, index, skb, state);
+		lowered_timeout = nf_tcp_handle_invalid(ct, dir, index);
 		spin_unlock_bh(&ct->lock);
+		if (lowered_timeout)
+			nf_ct_l4proto_log_invalid(skb, ct, state, "lowered timeout to UNACK");
 		return -NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
 		break;
-- 
2.43.0

