Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CA228F5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776442903; cv=none; b=DOxxmz5ckZlQCrkZHfkkkyAMvZjKW9XbGH4AE+Fpus2yMOsbn6BQv7rZq7fkUgPn93rfPDbZNjQ9No1PTT+4pM+Tg9eIUTKwbcmbrdGqFM4ypr98ybld5u4qfYUF1U20OfvWaLX77y9XMNy+Cw4xJHafVbarNq65VQyApglhQMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776442903; c=relaxed/simple;
	bh=YnVEOQlSyYBs3gRu6/9WAzwZ9EduIos/joljLlqm60s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LFv8v8yAK+yyKMy2JXZrf1Ee/aStlw9rhf9zes+69JDNDO7Lj6EVVdalmqkdjQTjd90T7/95ILdap5CgfqbgcI4QCHvmE1xBGqZZs9RuR7V5agxjnU3IDAtMPXgx8Up/L24g1G8yzT3REeJPuZF8k28k6BfSbNKR0yqn0TNU/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bZLsYTiu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AtT73iFC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aPnIB5TQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=h2FY9A38; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bZLsYTiu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AtT73iFC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aPnIB5TQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="h2FY9A38"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE1FB6A9BE;
	Fri, 17 Apr 2026 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776442899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gHuz/jVQj6H7J+pM4dAvL3x3DF9RxxH8iIPsfYigp6g=;
	b=bZLsYTiufaMAu53oDgn2IcDWrHiN575NqxGVrPVxBypE0QWTrOgFsTZLGybUeCKH8EUX4Q
	ldi24BQlqhx547KgUm/RuqrXu4qqyFUOimpFbvcuy0cV/7mi+JIff4X5c0CsXWaLbutRvs
	bYYe3gpwYpCZL2WUHr4TZkdE7dQAr8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776442899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gHuz/jVQj6H7J+pM4dAvL3x3DF9RxxH8iIPsfYigp6g=;
	b=AtT73iFC9Iw3OKQw+J9pYsb2e/MNfG92ZtNPYj0J+xJRJmFllvdeLscXS5uIfzb26Y5lNe
	dNhAxCkXRNlYGtAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776442895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gHuz/jVQj6H7J+pM4dAvL3x3DF9RxxH8iIPsfYigp6g=;
	b=aPnIB5TQ9HzcKH6hw74yKxgXAhpprr+jlWI1q8z6mr1ku3yT10BGC058MI/nuSyAOmjkYw
	mtDKpgX+jQ2Wx27gAL7fybst6lyiFGQBuNdknwZKrVIdlPlGKXoOBj7XzZb/Ng8pEXxauk
	zJH6FcNpjDF1jnusD1xRX/jlGM9p3ds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776442895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gHuz/jVQj6H7J+pM4dAvL3x3DF9RxxH8iIPsfYigp6g=;
	b=h2FY9A38g+zNilqY3UGxwz/xHih1mbSVZzOdTLjJlZ8pb9o9uYlNj5CySy/w5VYsxIuC8g
	i+KO36Dkb2zkaUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43C53593AF;
	Fri, 17 Apr 2026 16:21:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NVDSDQ9e4mlAFQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 17 Apr 2026 16:21:35 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf] netfilter: nfnetlink_osf: fix out-of-bounds read on option matching
Date: Fri, 17 Apr 2026 18:20:56 +0200
Message-ID: <20260417162057.3732-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,strlen.de:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

In nf_osf_match(), the nf_osf_hdr_ctx structure is initialized once
and passed by reference to nf_osf_match_one() for each fingerprint
checked. During TCP option parsing, nf_osf_match_one() advances the
shared ctx->optp pointer.

If a fingerprint perfectly matches, the function returns early without
restoring ctx->optp to its initial state. If the user has configured
NF_OSF_LOGLEVEL_ALL, the loop continues to the next fingerprint.
However, because ctx->optp was not restored, the next call to
nf_osf_match_one() starts parsing from the end of the options buffer.
This causes subsequent matches to read garbage data and fail
immediately, making it impossible to log more than one match or logging
incorrect matches.

Instead of using a shared ctx->optp pointer, pass the context as a
constant pointer and use a local pointer (optp) for TCP option
traversal. This makes nf_osf_match_one() strictly stateless from the
caller's perspective, ensuring every fingerprint check starts at the
correct option offset.

Fixes: 1a6a0951fc00 ("netfilter: nfnetlink_osf: add missing fmatch check")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nfnetlink_osf.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231a92..f58267986453 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -64,9 +64,9 @@ struct nf_osf_hdr_ctx {
 static bool nf_osf_match_one(const struct sk_buff *skb,
 			     const struct nf_osf_user_finger *f,
 			     int ttl_check,
-			     struct nf_osf_hdr_ctx *ctx)
+			     const struct nf_osf_hdr_ctx *ctx)
 {
-	const __u8 *optpinit = ctx->optp;
+	const __u8 *optp = ctx->optp;
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
@@ -95,17 +95,17 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 	check_WSS = f->wss.wc;
 
 	for (optnum = 0; optnum < f->opt_num; ++optnum) {
-		if (f->opt[optnum].kind == *ctx->optp) {
+		if (f->opt[optnum].kind == *optp) {
 			__u32 len = f->opt[optnum].length;
-			const __u8 *optend = ctx->optp + len;
+			const __u8 *optend = optp + len;
 
 			fmatch = FMATCH_OK;
 
-			switch (*ctx->optp) {
+			switch (*optp) {
 			case OSFOPT_MSS:
-				mss = ctx->optp[3];
+				mss = optp[3];
 				mss <<= 8;
-				mss |= ctx->optp[2];
+				mss |= optp[2];
 
 				mss = ntohs((__force __be16)mss);
 				break;
@@ -113,7 +113,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 				break;
 			}
 
-			ctx->optp = optend;
+			optp = optend;
 		} else
 			fmatch = FMATCH_OPT_WRONG;
 
@@ -156,9 +156,6 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		}
 	}
 
-	if (fmatch != FMATCH_OK)
-		ctx->optp = optpinit;
-
 	return fmatch == FMATCH_OK;
 }
 
-- 
2.53.0

