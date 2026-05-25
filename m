Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC3382F12
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713111; cv=none; b=nexp7OPxh85YJnGx15zF1W564tVT6pb+itFWTVVXGqg24KHQW6oY8WiVIr41rQvXQtAslk7bHHc7sWQrQZkHv/l8DT23kxRuHJ9EJVyizDhr9Mj6JGpVzcMZyCdaBblEaUW7/9OGl7GEGKc4rBjHaO8ZNND1x/nMxKKsdXiukTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713111; c=relaxed/simple;
	bh=Ui7//IE7iXs+Qx+eIuOY4eoYvWwxTXBiQ6sGGCzqxCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sn0PbxD6x/pD8EN6WyzNMxT8J3bIUNa/6bpLwlqqonciCFRrMK1IfhQEIrwdafqLN3oTYMmmiT4Hd1GYn3KuxK4AxxqwsvdaAOypgpxv08e5Pu1omgy5RWi3f2qbvz1GYRmLqg1efRRdbZvlxxEQdqCZ308uPrzn5RI9VCDvgxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 35259758C7;
	Mon, 25 May 2026 12:45:02 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1FC759C50;
	Mon, 25 May 2026 12:45:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4LhYLE1EFGq1SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 12:45:01 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/4 nf v2] netfilter: synproxy: fix possible write to stale pointer
Date: Mon, 25 May 2026 14:44:50 +0200
Message-ID: <20260525124450.6043-5-fmancera@suse.de>
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
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 35259758C7
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

skb_ensure_writable() is called to guarantee that the TCP options area
can be safely modified when adjusting the timestamp. As it expands or
linearize the skb head it might reallocate the data buffer.

This makes the th pointer passed by the caller stale. The following
writes to the TCP header might be done to a stale pointer.

Recalculating the th pointer after skb_ensure_writable() prevents this
issue from happening.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 5413133a42fa..84d36d4367a6 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -199,6 +199,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 
 	if (skb_ensure_writable(skb, optend))
 		return false;
+	th = (struct tcphdr *)(skb->data + protoff);
 
 	while (optoff < optend) {
 		unsigned char *op = skb->data + optoff;
-- 
2.53.0

