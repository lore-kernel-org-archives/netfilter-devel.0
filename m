Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710615;
	b=x56ih/qKp6tLJDgcIvgdKI0nEiX6ekcERSfcZJyfSSYxtuBvYHn/2BNVFC2cEz+2xfTc
	 xZjgK2sPzElcBo8xUxnWzTR924Fb7l2d+0CK3DW4BgcYyd4Fb58iU6QzJs6dmRFwrylQ+
	 irCUgijtZCRq0Hk5hvryqu465TKOiQtbFUwpel65+ernFP7zg6XbNiADorHpMXVmc+OJK
	 MAIsewqEKTwqcvcjz5HskfyfKbDjxWSa+Sh+Vs25Zh/zv5a7lJwmBrL38cRnjtfI932r4
	 qCwVyjhzrH/eIIQrjmtY9bGB4pGbe3ufgk+M+QpoHAQz+nV+ShBo0p2XuxgKOYQgELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710615;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=pYCePbvEnTHjsHRTufO/LSAFlixOoLY95UxN+S3ig6M=;
	b=RWMfYH5EJ4a2jydukpdmPPYpVCpdIpmFFpAxs8OsGU0oVgX4PxlZIcteyz3jm3hZx1JW
	 7w2H+w0x1cAmCQUoiNAOt2uW90tmVqU7f5yiBE77tnWysa9qDYCaxVs5Dw1B+fPYrGp/j
	 QY/2Pdx6oCvBPXInB3jrjRzOdOFcoWUlMNcvx8gI4QIPz9EU4r1HPfPjUOTJk2zBObtId
	 RMD+kq/MZRz276ImE++gqwjYYFAY1cah61nIE+/dR2sVpBsG2W3UlgzAtga1Mjhp6bEeC
	 312eyBzHh6ml0aqaIrPEB+nA3UlUMAwQDjVdKpMXlzcHfL1OLR3xtH1UpnQor3FOG3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wwlPuJy3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=R3LSc+Cc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sfn3yCqE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1Szl7ZhH;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9932606A326
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 12:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9932606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wwlPuJy3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=R3LSc+Cc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sfn3yCqE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1Szl7ZhH
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE15421BE0;
	Tue,  3 Nov 2026 12:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793710613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pYCePbvEnTHjsHRTufO/LSAFlixOoLY95UxN+S3ig6M=;
	b=wwlPuJy3uep3rBDu9eunmzMflKwEqCMfn7XfZPvrMp5WY8Pax35PGwko2nTRZgXBc3w3D7
	s1D46SoZSp7hUr8UyLr7RIZRJoI5zfBDNWCdnz0DBt2S9zK8bZ5kRVbeFCgB7YZrivLZcx
	1etNra4BWJ3zyR79iVqbVO3GEBp3q4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793710613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pYCePbvEnTHjsHRTufO/LSAFlixOoLY95UxN+S3ig6M=;
	b=R3LSc+CcsB0t1B7/tfKcdJXQSrlBiB+4KNN9BXMe2P+k564xZpEOBngMj6mQsIxxnPeE0r
	nEUYWVknZfJF/uBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793710612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pYCePbvEnTHjsHRTufO/LSAFlixOoLY95UxN+S3ig6M=;
	b=sfn3yCqEuY70iQQTFLcnavPaicluAh+RqfjL7Db1J4ZukxO1dRrCydJ1yD1v1icWIfd5/3
	DstlZgS1Ftxv2P+WsCF1ggYTszkn0JGLGAlhpp6/Qsh/h0YX03P0Dw7fCshEljEjz9SnSl
	hbiMxWPvB+kcNx+6IM7xaaSxhmT80XQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793710612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pYCePbvEnTHjsHRTufO/LSAFlixOoLY95UxN+S3ig6M=;
	b=1Szl7ZhHKfTRpx8IA1nlMAiRXjboTNY6mczwDOIVC38uzdktVlBJnY0ksqEdjwmrPMtjex
	o9cAQE9CCx/PHADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56B7B1352B;
	Tue,  3 Nov 2026 12:56:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B3qQAxTa6WpBHwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 03 Nov 2026 12:56:52 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: synproxy: prevent unbounded recursion in transmit path
Date: Tue,  3 Nov 2026 13:56:38 +0100
Message-ID: <20261103125638.4667-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Packets generated at synproxy_send_tcp() and synproxy_send_tcp_ipv6()
are handled by ip_local_out() and ip6_local_out) which traverse
LOCAL_OUT and POST_ROUTING. As SYNPROXY hooks are registered on
POST_ROUTING, a payload mangling rule at OUTPUT with priority raw can
rewrite the generated ACK to SYN|ACK before conntrack sees it.

This leaves the conntrack state in SYN_RECV state and synproxy sends two
more ACKs repeating the cycle until the IRQ stack guard page is hit:

  BUG: IRQ stack guard page was hit
  Oops: stack guard page: 0000 [#1] SMP NOPTI
   synproxy_send_tcp
   ipv4_synproxy_hook
   nf_hook_slow
   ip_output
   ipv4_synproxy_hook
   ...

Fix this by applying the per-CPU xmit recursion limit. Note that this
cannot be triggered with iptables as it is not possible to modify the
TCP flags from raw priority.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 401ce5a13f3f..9dd681596c70 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -21,6 +21,7 @@
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_synproxy.h>
+#include <net/netfilter/nf_recursion.h>
 
 static DEFINE_MUTEX(synproxy_mutex);
 
@@ -439,7 +440,16 @@ synproxy_send_tcp(struct net *net,
 		nf_conntrack_get(nfct);
 	}
 
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
+		goto free_nskb;
+	}
+
+	nf_dev_xmit_recursion_inc();
 	ip_local_out(net, nskb->sk, nskb);
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 	return;
 
 free_nskb:
@@ -858,7 +868,16 @@ synproxy_send_tcp_ipv6(struct net *net,
 		nf_conntrack_get(nfct);
 	}
 
+	local_bh_disable();
+	if (nf_dev_xmit_recursion()) {
+		local_bh_enable();
+		goto free_nskb;
+	}
+
+	nf_dev_xmit_recursion_inc();
 	ip6_local_out(net, nskb->sk, nskb);
+	nf_dev_xmit_recursion_dec();
+	local_bh_enable();
 	return;
 
 free_nskb:
-- 
2.56.0

