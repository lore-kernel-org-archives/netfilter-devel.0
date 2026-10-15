Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A771C695
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 07:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050317; cv=none; b=Am5Bw48BlzYubJU+apjittbjRfx6fvHL297VbK9/g+Bf6MRVtmQe5xQT9Yg2zz3ql8Lg79JKbXV6wbEfgxaEg4v/KqOUW/1tBaMeoh9DPDt9H18d/2177/aAg0PIY8d1L0TUkwkbN+52wB+Tz+B+fA72JmZmDDue4522SgtFIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050317; c=relaxed/simple;
	bh=yLyNM8HfGsASCEH5EQcPoGP7A0J7/o+NpVZh3itxuhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX9K3e/xb2eFY01aXz3+X0hGsADFOs+SGc6G7/+Rop3ao+OE+k+vMBqrypyjINXc/KYcdw1YbhXKUKSqlr5O5asnDiycuKpprSZDYUwPLnBKpwEC5K4elbe3WbKJpXGHq+vIIw3MaGt88012wbjUNlUzPrgD/eaNYqzfB7iReNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=nxgdiQrY; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="nxgdiQrY"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc751eddf25so3033965a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 00:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792050310; x=1792655110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s18ZSAeaTj3uFCQOPUAhE8p5i1eeNicCpcv0Dn1C87s=;
        b=nxgdiQrYBUhG4D4ivNCaDPGQEOqe9lOIBwqIXq39ZKbQwGqCjUgEzw0UYJxsn1h1we
         XSn52ZZnykmrE+4QaH9RwlKmjYufprDnDLvqf+vmZdwwfo4cZTxmcpsAQrkydikZqhjU
         4Q9ca/u5PmVYkQXYGAZgbo91nkJbTaEDglIVA0DZQEegyYNXHU5W3I5Qdcat2K7Ahr+s
         /QvSTH53FG/KRu/H4FSf7e72xO+PlakMbdlyHkKSxDxFOEJ4aN6FRGGA/LhvjggVnMAq
         HXQEfcEIfXYL2DR4LhME+ZSsKOW1NpY0kHew/h9AlRm+BXnrjE7qu3J9tnirRASdThXY
         prKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050310; x=1792655110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s18ZSAeaTj3uFCQOPUAhE8p5i1eeNicCpcv0Dn1C87s=;
        b=YFMEv6sDAIvUDc3ZkRqYR5pwNoSeap/Sai7UbYsSs9Y5Hip0iPDbLTJp363azyXcN9
         +fYKeghdlVXQBmeV1v2dd0KY23I+wev4Rya4CEuoUVQ6T/DfhcgBhp+C3lnVKk8itOLU
         PhLuoQdtVIcq6LHHxTIdKFReeQT+14voDvfMr+qIMJKXaJxgLShdHF6fvpORCNkBN1No
         mcgROyLtV1M8KyLrqKehSpR9J+Mbw9d0QBB44mINKpZ7Ifhk7igM2CS+xEUqjIJqa4QT
         4dOeL0jKn9PuFr+8mV3OUbH/QBll6FPWACUeYUNzRTuP/RqzAUSwRW9qGPoTGyaq31eI
         7SuQ==
X-Gm-Message-State: AFq9FYI6j38vruilBmeAMhGYepIHl8TQ6jyYFg/z5Fr7Cbbpf63apl4L
	mD0oC2sSjCse5R0VU2pQFGBPMBBgykH4p9edMcIMcbyVU1RN9P/GDBrGyOfwtnP7s8G9uyuu5Qd
	AX0yoyG/sGtc=
X-Gm-Gg: AYBFou0C8OmB4g3CGC4jqmjPIn1mp0LjQ2G/6jZq2nEd8Mp05p39Ix3lEqxbM2hq4Z+
	tR6dwCW+eUsuQwqSht4IxO/ZYUJTmBr/aQhQFcAWFUKrPQrqIX/VEr1f0/sQO557ueeuR0X7SKR
	/XHqNPkB0Gtf4kidShKE6dphlVv1GkYMw6oxxCqW9gfhzSHMF8DDe2B8STkt2yQjglPiCIZkeep
	4BfwvtYmk01xBgzUX61756OVBAf0d0wnMWsO2jLcnbCf8Y5ZEXezMKr/wfAAMQm7xFYUVvTS9zz
	nAtOqW7b4joh5/212n9rLy3MwOSj+AaQr5n/sEqxvsVoen/1XpHfUyllaa36XPr0GG+937QoeUd
	X0OtHXGhIsI51Dvy+joSk802UYx+FYO0/GT6vy2uSIyzjFBt84PISLWmna8dMzGulY0agteRJhB
	Lnl1a8Kjp8tpRDjrbOwiN7WTyuKh1vA3r2KLkf7eqS7W8U0i0VRQwlSL4r9L6CsxL1h4XolllWj
	rbE+xvB+CqOrwMIcUsZR4Y1Pew2iQ==
X-Received: by 2002:a17:90b:4d85:b0:3a4:c946:9f4e with SMTP id 98e67ed59e1d1-3ab3acdc386mr14478029a91.58.1792050309820;
        Thu, 15 Oct 2026 00:45:09 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac93849da5sm1636831a91.4.2026.10.15.00.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:45:08 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org,
	bpf@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	andrew+netdev@lunn.ch,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	aleksander.lobakin@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	willemb@google.com,
	alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com,
	imv4bel@gmail.com,
	shiming.cheng@mediatek.com,
	sd@queasysnail.net,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v8 1/3] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Thu, 15 Oct 2026 07:43:07 +0000
Message-ID: <1eca65f844ea4eaefa9ea4a852f1db27aacc10b9.1792048855.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792048855.git.zihanx@nebusec.ai>
References: <cover.1792048855.git.zihanx@nebusec.ai>
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

Save the guard in the queue entry and restore it while reinjection continues
hook traversal. Preserve and restore the verdict task's prior state, including
nested synchronous reinjection.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         |  1 +
 net/netfilter/nfnetlink_queue.c  | 15 ++++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

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
index a3bc00280051..9a8f55498fd5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -43,6 +43,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/net_debug.h>
 #include <net/netns/generic.h>
 
 #include <linux/atomic.h>
@@ -368,17 +369,24 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	unsigned int i;
 	int err;
 	u8 pf;
+	bool old_in_nf_duplicate;
+
+	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate,
+			    "%s called with duplication guard set", __func__);
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
@@ -401,9 +409,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		local_bh_disable();
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
-		local_bh_enable();
 		break;
 	case NF_QUEUE:
 		err = nf_queue(skb, &entry->state, i, verdict);
@@ -417,6 +423,9 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate = old_in_nf_duplicate;
+	local_bh_enable();
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.43.0

