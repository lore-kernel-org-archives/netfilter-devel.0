Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544E33C50D
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 21:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832738; cv=none; b=ufEoqXHRWzVKybd2fN/FYMywz/1DzA3boHuOJLrF+9mcl/aLU3v9RNKua0Smpt9gCDvttVC1cUCtQVCOs7RGqoMX6DfbL9mOHt85yr8oC1wgWZe9az4M/xU+ew0FgbDgO7HNehgpdIoohWih+J3yjyoKU/lo1kCi1zrgDGkRwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832738; c=relaxed/simple;
	bh=Bryy3ZyrgC1K7ij573ki4EcK/jMYifjouU3w8lBvtMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcJ1WHj4lMHA8Ok8nWQn98q0+CJobivA+zWIAXPe8gLe+RtXGWm9aU6m6wKU+cQdeBDfaHWbG5YqAceJSojZmd+VtakYJjAvSsvAQICImjHulynFvMLUHHeQ17W9/NrhTzNOP6gyxLYRMnol0zMfWrnw32VGoUpb5kMRGoFHmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FnkeA+vu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9MRfStYg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FnkeA+vu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9MRfStYg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FnkeA+vu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9MRfStYg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FnkeA+vu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9MRfStYg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 473D766EA5;
	Tue, 26 May 2026 21:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQhNbZHlargoGxyJuDv/Vw5A8SE1kGSIDzHBFJKHtxM=;
	b=FnkeA+vu+sdpFVC7EPQCI7nabanpWW6YovLZxfU/hLjydXVOY36/+tJm86nn8QDC+uFXBc
	Wyb4xeH6Dsj2QnuAUuxAAqe/bOks93iJ4IESu/NehI+EA+eOV6qCJsjAd7EWayn7sYPzHD
	qh9eZFchHEHAlLQCNhpI/IF+Z9AWx4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQhNbZHlargoGxyJuDv/Vw5A8SE1kGSIDzHBFJKHtxM=;
	b=9MRfStYg2+eOkyzTKgf09Xw8XMRhtWos320JUZTBRe5uHxrPa0//tu/LWfwwHcog2t0lH3
	o3rPWBc7KRdZ7TBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQhNbZHlargoGxyJuDv/Vw5A8SE1kGSIDzHBFJKHtxM=;
	b=FnkeA+vu+sdpFVC7EPQCI7nabanpWW6YovLZxfU/hLjydXVOY36/+tJm86nn8QDC+uFXBc
	Wyb4xeH6Dsj2QnuAUuxAAqe/bOks93iJ4IESu/NehI+EA+eOV6qCJsjAd7EWayn7sYPzHD
	qh9eZFchHEHAlLQCNhpI/IF+Z9AWx4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQhNbZHlargoGxyJuDv/Vw5A8SE1kGSIDzHBFJKHtxM=;
	b=9MRfStYg2+eOkyzTKgf09Xw8XMRhtWos320JUZTBRe5uHxrPa0//tu/LWfwwHcog2t0lH3
	o3rPWBc7KRdZ7TBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D62CE5A419;
	Tue, 26 May 2026 21:58:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qGFRMZoXFmrTZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 21:58:50 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/5 nf-next v4] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
Date: Tue, 26 May 2026 23:58:29 +0200
Message-ID: <20260526215831.6726-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260526215831.6726-1-fmancera@suse.de>
References: <20260526215831.6726-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -6.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_TLS_ALL(0.00)[]

Use get_unaligned_be32() and put_unaligned_be32() to safely read and
write the timestamp fields. This prevents performance degradation due to
unaligned memory access or even a crash on strict alignment
architectures.

This follows the implementation of timestamp parsing in the networking
stack at tcp_parse_options() and synproxy_parse_options().

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6bd63f5ab75d..5413133a42fa 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -189,7 +189,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       const struct nf_conn_synproxy *synproxy)
 {
 	unsigned int optoff, optend;
-	__be32 *ptr, old;
+	u32 new, old;
 
 	if (synproxy->tsoff == 0)
 		return true;
@@ -217,18 +217,17 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-					ptr = (__be32 *)&op[2];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) -
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[2]);
+					new = old - synproxy->tsoff;
+					put_unaligned_be32(new, &op[2]);
 				} else {
-					ptr = (__be32 *)&op[6];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) +
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[6]);
+					new = old + synproxy->tsoff;
+					put_unaligned_be32(new, &op[6]);
 				}
 				inet_proto_csum_replace4(&th->check, skb,
-							 old, *ptr, false);
+							 cpu_to_be32(old),
+							 cpu_to_be32(new), false);
 			}
 			optoff += op[1];
 		}
-- 
2.53.0

