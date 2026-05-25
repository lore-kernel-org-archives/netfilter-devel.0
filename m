Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E94382369
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 12:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713100; cv=none; b=CppksXZWJDONzlPljeya4E0+u8Lk5ahWlg0bXcEi8Xe9TWlc6wxXnI42H8b0vaMq2nMQ1+dtHAfVPJKu/e5ZJ0OQaErKeOPTa2AqazF06/8zqf2qtMH1Vvf4fU/AIkK+20EyF5yp6pM95iHytnYa3LSYJ9YedBL9xNV2pJzZ8Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713100; c=relaxed/simple;
	bh=tHkoFjUzxmDOH9yR0yD7JW1ujTU7N8Ymb77IcancDG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO6MQtGBt0H9DiSChC62y/2Ra3FmyqYYEk0w1C1ZdI7OL2+mAAKwkg2Yb6+V0+XebSpSdGgz7Wlt2iHP5gOehBpeQH4pZI06hgudkKq6p3x9nK5DjFBtchZdSUzjpufnNhOyUNLcwiOWtAhmHCPhTtCh58H3YKKG2NFX76F2bP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB98764D07;
	Mon, 25 May 2026 12:44:57 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 543ED59C50;
	Mon, 25 May 2026 12:44:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2GuREUlEFGq1SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 12:44:57 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/4 nf v2] netfilter: synproxy: drop packets if timestamp adjustment fails
Date: Mon, 25 May 2026 14:44:47 +0200
Message-ID: <20260525124450.6043-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525124450.6043-1-fmancera@suse.de>
References: <20260525124450.6043-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: BB98764D07
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO

If a packet was malformed or if skb_ensure_writable() failed, the
synproxy_tstamp_adjust() function returned 0 indicating an error but it
was ignored on the callers.

Make the function return a boolean instead to clarify the result and
drop the packet if synproxy_tstamp_adjust() failed due to ENOMEM from
skb_ensure_writable(). In addition, if there are malformed options, skip
the tstamp update but do not drop the packet as that should be done by
the policy directly.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 57f57e2fc80a..e523b64bf839 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -182,7 +182,7 @@ synproxy_check_timestamp_cookie(struct synproxy_options *opts)
 	opts->options |= opts->tsecr & (1 << 5) ? NF_SYNPROXY_OPT_ECN : 0;
 }
 
-static unsigned int
+static bool
 synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       struct tcphdr *th, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
@@ -192,20 +192,20 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	__be32 *ptr, old;
 
 	if (synproxy->tsoff == 0)
-		return 1;
+		return true;
 
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + th->doff * 4;
 
 	if (skb_ensure_writable(skb, optend))
-		return 0;
+		return false;
 
 	while (optoff < optend) {
 		unsigned char *op = skb->data + optoff;
 
 		switch (op[0]) {
 		case TCPOPT_EOL:
-			return 1;
+			return true;
 		case TCPOPT_NOP:
 			optoff++;
 			continue;
@@ -213,7 +213,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (optoff + 1 == optend ||
 			    optoff + op[1] > optend ||
 			    op[1] < 2)
-				return 0;
+				return true;
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
@@ -229,12 +229,12 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return 1;
+				return true;
 			}
 			optoff += op[1];
 		}
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -745,7 +745,9 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv4_synproxy_hook);
@@ -1168,7 +1170,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv6_synproxy_hook);
-- 
2.53.0

