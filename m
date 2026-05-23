Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E93403E6
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565706; cv=none; b=pPU2Y6OR7+wA4jBWvtpgXjPYtC7GdzvNbd8RqAThwxVyC/d2ebpt+Erllbj5gw3ZumasB8AMP4z60CSTRpa/beN57gk3W0J4H2ZO0oNqQT742lHTTjB/rzp15TQbHmThSpxhfzIWv/qTBGk2up5sLnQdj1cLteMWzG6Xn403pHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565706; c=relaxed/simple;
	bh=rXkMdfolOS9eaZibezW42eajj1kLWX3GWTkpL+MjvtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MebnmE/WTXTi/2iBsi4lcLnTapD7uGgBqsw5Q5ZywKxjpCQbmj5R+Dmz7z7HAmKOw6TNTepnUcjU03xzExmikQFlSCEz2tnsb8Bt25wnVgDVEruDlGR1/iFtub8UvtH4jjVohYV+1BWxWlRLB1ij6fpS7bHHykL9aBd1O7f/2/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e6rKEQuA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4J8Bw8N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e6rKEQuA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4J8Bw8N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e6rKEQuA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E4J8Bw8N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e6rKEQuA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E4J8Bw8N"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F3E063FEA;
	Sat, 23 May 2026 19:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yx89mf0Zmg1pvV1DJdN8WyTHaAbQIOE3XTW9JK3xuMw=;
	b=e6rKEQuA4VgjusyGqGCmTjvmNXSBmUUG1xbqNnsTXgi2FPUmFDcaJfv/dJlxbElF/aUpxo
	pCsXn5QareDrWUktR79y68TQoSGQhfKlwIMXWzVuT/soqYZZh2q8+Kc/p9Gk7x1iAP8b6U
	V2rXpc1mBEjIVagZSs466ZYvMa64NAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yx89mf0Zmg1pvV1DJdN8WyTHaAbQIOE3XTW9JK3xuMw=;
	b=E4J8Bw8NUZ5jZdQW5wenRWBaqJZcR/lEXsUcQ/h92XpER4i+bJeWAP/7if6KqWZ7mmwdav
	KJEU2EZ0qMO3QuCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e6rKEQuA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E4J8Bw8N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yx89mf0Zmg1pvV1DJdN8WyTHaAbQIOE3XTW9JK3xuMw=;
	b=e6rKEQuA4VgjusyGqGCmTjvmNXSBmUUG1xbqNnsTXgi2FPUmFDcaJfv/dJlxbElF/aUpxo
	pCsXn5QareDrWUktR79y68TQoSGQhfKlwIMXWzVuT/soqYZZh2q8+Kc/p9Gk7x1iAP8b6U
	V2rXpc1mBEjIVagZSs466ZYvMa64NAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yx89mf0Zmg1pvV1DJdN8WyTHaAbQIOE3XTW9JK3xuMw=;
	b=E4J8Bw8NUZ5jZdQW5wenRWBaqJZcR/lEXsUcQ/h92XpER4i+bJeWAP/7if6KqWZ7mmwdav
	KJEU2EZ0qMO3QuCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0373C593A8;
	Sat, 23 May 2026 19:48:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2OBJOYUEEmodWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 23 May 2026 19:48:21 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/3 nf-next] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
Date: Sat, 23 May 2026 21:47:44 +0200
Message-ID: <20260523194743.5888-5-fmancera@suse.de>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 6F3E063FEA
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

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
index 49ce18f9c8ef..a49124e8e552 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -190,7 +190,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 {
 	unsigned int optoff, optend;
 	bool tstamp_seen = false;
-	__be32 *ptr, old;
+	u32 new, old;
 
 	if (synproxy->tsoff == 0)
 		return true;
@@ -220,18 +220,17 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				if (tstamp_seen)
 					return false;
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
 				/* continue parsing options in case there is a
 				 * duplicated tstamp, drop the packet
 				 */
-- 
2.53.0

