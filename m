Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B300502D4F
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 22:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030350; cv=none; b=AZuzfaaFpf6DO5XQJCnhbdULBxBY1/7DETrNy6wksnn2C/XMN0RjN7LaTJoQWrYyfo89mmhCLIX+Oeuqe6mTNbtrOVoXCsu+ZKLz79Mrg4qDh+jrbqqte8jYndFPdUyamUCtBb1J9l1GrCDX1XdhLHBXXXljL9Z8zU4AWPSLRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030350; c=relaxed/simple;
	bh=FBeWEYQ1XPzkiNMi2F+iDoJJkwMASWnIsxtoL0cg1Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LqzOXC8+TFK547jk0UrgF0RZWWTrKQDYWgtsw8GWK6S8UakZYXt855uxPZHAR5PlNhnpIghMEpLU36poLxxiwnmXuMKZvyLO/yNw5gdb3BVW4FhewfTTwZ1usuFiAL+Zh/4WqFVzqVD8ojjXN5CoGWfSi8hMu51UIGYoN2pBa7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bXbOx2S5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P4encMdV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cD9gjta9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LsNrDlNx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bXbOx2S5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P4encMdV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cD9gjta9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LsNrDlNx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E18191FF09;
	Mon, 21 Sep 2026 22:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790029808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U+FMsSjv6BVB/oCdg5kxZWN92XVCK73VzkTfwY7ve0U=;
	b=bXbOx2S5MJGJAY9atRrEC+wTUQhnEPRqOy6dlSSZUnuWeiHC3oaPUn1S/6Yc+h9V1QsW8H
	GSuj1+PqRD5OyjC0CQX0+9blo4L1tR21gOdliWebTOU0ILLkwL7sz1AcvvMLLotPQ5deqX
	urdyrF4SXRMk4STm2JIy4TAibck6ZZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790029808;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U+FMsSjv6BVB/oCdg5kxZWN92XVCK73VzkTfwY7ve0U=;
	b=P4encMdVyyroNedr4NJOj55ug/VCxWBUqC00dWoh0uWw402N1N89+JFJ1kPGrGJgcwUje7
	RPzSB4XCCSN632CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cD9gjta9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LsNrDlNx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790029803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U+FMsSjv6BVB/oCdg5kxZWN92XVCK73VzkTfwY7ve0U=;
	b=cD9gjta9SPQCcIF2XFDBu1RYT+1qJiD0H0gEI0xkyh7F4EFRrxBk1HNz51DXTVqDcXBx8L
	bIljtQsi2lpmxBKqs62Ah4JHDbaUdoaR6JM9sXxT2JOkwm1KQvfaBnweHfFHAScMp/eWCW
	S4dUXWUCaDO8o4pU2bYb7APFhvUkNok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790029803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=U+FMsSjv6BVB/oCdg5kxZWN92XVCK73VzkTfwY7ve0U=;
	b=LsNrDlNx+djXVreCqOG/sq76bd7GbVXldDTqRXO8Z80JM8Tpf8ytRmOQgRpy0iZu6nXXHd
	3J4n/lfWeMmiNICg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B3F81368D;
	Mon, 21 Sep 2026 22:30:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id foFsB+uvsWpSMQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 21 Sep 2026 22:30:03 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	eric@regit.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: [PATCH nf] netfilter: nft_reject: prevent unbounded recursion in output hooks
Date: Tue, 22 Sep 2026 00:29:25 +0200
Message-ID: <20260921222925.3874-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E18191FF09
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,regit.org,suse.de,gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -3.01

nftables payload-mangling rules can rewrite packet contents (such as TCP
flags) before they are evaluated by reject targets. This defeats the
content-based loop guards, allowing unbounded hook recursion that leads
to kernel stack exhaustion and panics.

Fix this by extracting the per-CPU xmit recursion limit previously used
by the netdev duplication/forwarding paths into a shared header, and
apply it to the inet and inet6 reject transmit functions. It disables BH
while transmitting the skb to address a possible migration to different
CPU leading to imbalanced decrementation of the recursion counters.

Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
enabled does not require this recursion guard. In that scenario, the
generated reset packet is transmitted directly at Layer 2. Because the
packet egresses from a different hook, it cannot synchronously loop.

Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260921061320.543-1-junzheyu1@gmail.com/
Fixes: bee11dc78fc8 ("netfilter: nft_reject: support for IPv6 and TCP reset")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_dup_netdev.h | 35 ----------------------
 include/net/netfilter/nf_recursion.h  | 42 +++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c   | 12 ++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c   | 13 +++++++++
 net/netfilter/nf_dup_netdev.c         |  1 +
 net/netfilter/nft_fwd_netdev.c        |  1 +
 6 files changed, 69 insertions(+), 35 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index f6b05bd80c3f..a39411264614 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -9,41 +9,6 @@
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
-			NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-static inline bool nf_dev_xmit_recursion(void)
-{
-	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
-}
-
-static inline void nf_dev_xmit_recursion_inc(void)
-{
-	current->net_xmit.nf_dup_skb_recursion++;
-}
-
-static inline void nf_dev_xmit_recursion_dec(void)
-{
-	current->net_xmit.nf_dup_skb_recursion--;
-}
-#endif
-
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/include/net/netfilter/nf_recursion.h b/include/net/netfilter/nf_recursion.h
new file mode 100644
index 000000000000..3e91b78e21b3
--- /dev/null
+++ b/include/net/netfilter/nf_recursion.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_RECURSION_H_
+#define _NF_RECURSION_H_
+
+#include <linux/netdevice.h>
+
+#define NF_RECURSION_LIMIT	2
+
+#ifndef CONFIG_PREEMPT_RT
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(__this_cpu_read(softnet_data.xmit.nf_dup_skb_recursion) >
+			NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	__this_cpu_inc(softnet_data.xmit.nf_dup_skb_recursion);
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	__this_cpu_dec(softnet_data.xmit.nf_dup_skb_recursion);
+}
+#else
+static inline bool nf_dev_xmit_recursion(void)
+{
+	return unlikely(current->net_xmit.nf_dup_skb_recursion > NF_RECURSION_LIMIT);
+}
+
+static inline void nf_dev_xmit_recursion_inc(void)
+{
+	current->net_xmit.nf_dup_skb_recursion++;
+}
+
+static inline void nf_dev_xmit_recursion_dec(void)
+{
+	current->net_xmit.nf_dup_skb_recursion--;
+}
+#endif
+
+#endif /* _NF_RECURSION_H_ */
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 59ec465a9df9..3f227a094312 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -10,6 +10,7 @@
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
 
@@ -336,7 +337,18 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			goto free_nskb;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip_local_out(net, nskb->sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 
 	return;
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 07cdaa10da0d..f69ddfe72030 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -10,6 +10,7 @@
 #include <net/ip6_checksum.h>
 #include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
+#include <net/netfilter/nf_recursion.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 
@@ -409,7 +410,19 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		dev_queue_xmit(nskb);
 	} else
 #endif
+	{
+		local_bh_disable();
+		if (nf_dev_xmit_recursion()) {
+			local_bh_enable();
+			kfree_skb(nskb);
+			return;
+		}
+
+		nf_dev_xmit_recursion_inc();
 		ip6_local_out(net, sk, nskb);
+		nf_dev_xmit_recursion_dec();
+		local_bh_enable();
+	}
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29bed6..918716629c15 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -12,6 +12,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a48c2f765bba..7447da931a95 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/netfilter/nf_recursion.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
 
-- 
2.55.0

