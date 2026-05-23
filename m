Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BD133C194
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565703; cv=none; b=TVL73TqtEsDy2UaDvWy+ZifkHDE343OQ0rJtE94B2TmmLWB2QdqczM161CaUF49I4wERC9aqEsHqPEWGxutVfe0A3C6xLCZmnggUmCBdU0bTG/x0X4ASuapt0xq7KmuWYGnzysNIyExnAIjeJjavY+WlITyTx6xffiv/7JSBnWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565703; c=relaxed/simple;
	bh=0O5jryuIdn8/H7Cfc4RPmwSmvDY8pGVNRNDqZcbuWAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncutv7GMRxm+/TAe03psMn8j7jLAAL5By4h94uGlp77P5cK2TaWJp6uphiPEuqEtP4fHnhub88n75enmTvPW6CEWXehjJrFNISEBnWbB7f7BL1Bg2kioCIQbx+oVZOBTJZ+pEA0/rEUZivxYizwfaiZGg3ZymY5h+HSdGIiU2k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NLnjqdjW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c70OisW4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ihTrcMD5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GJlh+SXF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NLnjqdjW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c70OisW4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ihTrcMD5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GJlh+SXF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E875366FE4;
	Sat, 23 May 2026 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiB0S8o6qMSUDkFApT43yh1eoN9f+wmIw5bdGzPcZy4=;
	b=NLnjqdjWejmzx2f5OFfbWnJGlwsjZSh69LqIZyPmm3iTBR3NziSMMtGHEjTkfpnkssmUOw
	+yuxBU9yTnmNiFOvej2vJ/O8SI7AII4GtQS56gAzoRSVDfYiCsifBRFPCAthWLS9r1aXFP
	+Z4M9F+RUxtMAoNd8BUAm9C6MclHh3U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiB0S8o6qMSUDkFApT43yh1eoN9f+wmIw5bdGzPcZy4=;
	b=c70OisW4fU1jgBrVbwvgVu0aKkV/Ztnw0AIg4qcTfQeeiPFHwFMSFswez5Jn/TwreywGlx
	h7BX4nnHz+kGZeCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiB0S8o6qMSUDkFApT43yh1eoN9f+wmIw5bdGzPcZy4=;
	b=ihTrcMD5sZI1VKyaLLazc7fWXgUVxeSDYabHIcI6MYnYPCBI9H6a4RICSiIETdUiy/gxWb
	JADyDz78zmFMjADr75ctBvfkcVWZMhQs/VGZekw9CDho8d0fPfKb7M5sbCCAwMyzj/lISq
	Z6wp0EQvrfdQy2zDZZt5fq9lTbs1yng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiB0S8o6qMSUDkFApT43yh1eoN9f+wmIw5bdGzPcZy4=;
	b=GJlh+SXFroJOUA3IBDullASanLe++mIURZpmQdxvj5y3demxEe4nbKLs6ieyr4HbuA5wo8
	8qMRMLdpV3OpSOCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D609593A8;
	Sat, 23 May 2026 19:48:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wHl9G4MEEmodWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 23 May 2026 19:48:19 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/3 nf-next] netfilter: synproxy: drop packets if timestamp adjustment fails
Date: Sat, 23 May 2026 21:47:42 +0200
Message-ID: <20260523194743.5888-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260523194743.5888-2-fmancera@suse.de>
References: <20260523194743.5888-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

If a packet was malformed or if skb_ensure_writable() failed, the
synproxy_tstamp_adjust() function returned 0 indicating an error but it
was ignored on the callers.

Make the function return a boolean instead to clarify the result and
drop the packet if synproxy_tstamp_adjust() failed.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 57f57e2fc80a..51a3dd48995b 100644
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
+				return false;
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
+		return NF_DROP;
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv4_synproxy_hook);
@@ -1168,7 +1170,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP;
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv6_synproxy_hook);
-- 
2.53.0

