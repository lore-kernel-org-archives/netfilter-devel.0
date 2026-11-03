Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725063;
	b=00so9eBRMUYMnrHwugVsdHImO81jdgF2+zq76KfAzJ7HXoI1Am3Orr/if8NBTt6ptZG+
	 5xzuMPGwwqcSNBhvrlrttHxeXZU5D1nRuRF+WP0JTY+vcWxLAUMFzz0i5gxTHPLbGW7vQ
	 WJChnxm9SsZgXYvK18oK7MsTC/NEFX/tqgzBIB6ruAIqHFvtNDyZAmQuNmLL+jEBsOfYJ
	 w+0MnPUOOR9B439+F2RVpEgTwn4wvtlKWuz4WImeocNGl2+JDq2OBmSo7c+uRGaTVPwnc
	 baG9h65vP86okLtCKg6c51DvhOLPNPcTYGoQQD1zupUIbWSg+/etq3RFcAXDQurn3Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725063;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=0Drh0s7tUYVx2dTOots86+vsH2/DyU0gfHTWsvVuFRw=;
	b=i/KX5+9Dd/grpVamdljcEmeuzo7ghabLvMkQYAF4gSENhcw6HAwckztjsp3buPGKCUz3
	 iIWxaIgQMwrH8QmrRwNuov3r1LJ2A60TRXjsqzCxFTmBvzpUXLcY4P9OQuSpE+FRvnBZq
	 LHOQ3K8/5kHSL0vpX6sJvBiTXKXtlyfuZCbZSkemgiTQE/QLNS+OEPg+Bl37xOVfzucNe
	 KBWsTm1ylv8jBjmcPyibJgHpfGoa7GT0cwCEBAkroyFqhmUk+O6jUNW0MHgjWl6mPNdAV
	 Od9Fn9dtAaJF1jf/zzjEkk1G/nZCvNB3aei0wSX0hMXDW10V27d1arXOUT4cbrzPXtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GKA8aJ1M;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LrXITRWE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1J9WnPEl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VGt+qIz7;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E03606A328
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 16:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49E03606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GKA8aJ1M;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LrXITRWE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1J9WnPEl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VGt+qIz7
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 184161FB9E;
	Tue,  3 Nov 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793725059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0Drh0s7tUYVx2dTOots86+vsH2/DyU0gfHTWsvVuFRw=;
	b=GKA8aJ1MjrXAEpjFi81FEWo4zd/ggAEELdyU5/s5EsKd/gm7BCc3/YxfwlRC30/X3P25Cs
	dP+k5sEZzP82tAijSFgsFY8OlM1UFO0/XddJNehwiALCmIjShrO0eoI3y9YuRM0gGhOIjm
	LuiU/2bMVMKs9zEWMjP0af4jDIVGG2s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793725059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0Drh0s7tUYVx2dTOots86+vsH2/DyU0gfHTWsvVuFRw=;
	b=LrXITRWEWpmmXl2N6VsQUFS760xdeHemWeKfw2rNCH073gK4NqrBnXt/NiOPk+DayCTE9h
	dvBL5hdEb8tIgYCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793725058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0Drh0s7tUYVx2dTOots86+vsH2/DyU0gfHTWsvVuFRw=;
	b=1J9WnPElh6cSZwUWF886CGwXvqtRWLomDpo2ks+kHtpCY9uc9a5w38i4H12HAChsOO3Urj
	YI+3iliL48FoaVbJwrMplHoq4kl+9BswlhZTd49wcD3mY5B1TOAJEdVsJgmZbsm09zwLXz
	wPi1/UABRmc5WwF2Ra8OI9yPjFQQ9xM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793725058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0Drh0s7tUYVx2dTOots86+vsH2/DyU0gfHTWsvVuFRw=;
	b=VGt+qIz7od+5Biu1qIxHECVxrt0Y+Rh3tEAZJFmoNRnAHi6PquAJ+voEARNUIdsMKjBFpM
	Uq41jcv4shc8LwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 759C31350A;
	Tue,  3 Nov 2026 16:57:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4uOMD4ES6mrhIAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 03 Nov 2026 16:57:37 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	VEGA <vega@nebusec.ai>
Subject: [PATCH nf v2] netfilter: nfnetlink_queue: keep socket ownership when expanding skb
Date: Tue,  3 Nov 2026 17:57:26 +0100
Message-ID: <20261103165726.6170-1-fmancera@suse.de>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
grows a packet beyond its tailroom. skb_copy_expand() does not copy
skb->sk, so the replacement is unowned and freeing the original drops
its socket memory charge.

The expanded packet is no longer associated with the process that sent
it. Therefore xt_owner or xt_cgroup and other socket based matches in
later rules no longer matches and a later NFQUEUE reports no uid/gid. In
addition, the expanded packet's memory is not counted towards the
sender's SO_SNDBUF limit, so the sender can keep producing them while
they sit in a queue.

skb_copy_expand() was introduced to avoid the SKB_LINEAR_ASSERT in
skb_put() on non-linear skbs. Address that directly instead, linearize
the skb, then grow its head in place with pskb_expand_head(), which
preserves the socket association. While linearize + pskb_expand_head is
expensive, this is a really slow-path, so this should not be a problem.

Please note that the additional head space is not added to skb->truesize
nor to sk_wmem_alloc, so the socket is charged only for the size the skb
had when it was sent. Fixing that would require wmem adjustments that
depend on the skb destructor type, which is not worth the complexity
here as expanding payload requires CAP_NET_ADMIN and is rare for locally
generated packets.

Fixes: e2b58a67b91d ("[NETFILTER]: {ip,ip6,nfnetlink}_queue: fix SKB_LINEAR_ASSERT when mangling packet data")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Note: Florian this is my best attempt to fix the socket ownership issue
and almost the memory issue completely. If you think a complete fix is
necessary I would de-prioritize this as it isn't worth it. Anyway, for
the ownership this should be enough.
---
 net/netfilter/nfnetlink_queue.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7d..1c9fd5f70694 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1435,8 +1435,6 @@ static bool nfqnl_validate_write(const void *data, unsigned int data_len,
 static int
 nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
-	struct sk_buff *nskb;
-
 	if (e->state.net->user_ns != &init_user_ns)
 		return -EPERM;
 
@@ -1454,14 +1452,11 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 	} else if (diff > 0) {
 		if (data_len > 0xFFFF)
 			return -EINVAL;
-		if (diff > skb_tailroom(e->skb)) {
-			nskb = skb_copy_expand(e->skb, skb_headroom(e->skb),
-					       diff, GFP_ATOMIC);
-			if (!nskb)
-				return -ENOMEM;
-			kfree_skb(e->skb);
-			e->skb = nskb;
-		}
+		if (skb_linearize(e->skb))
+			return -ENOMEM;
+		if (diff > skb_tailroom(e->skb) &&
+		    pskb_expand_head(e->skb, 0, diff - skb_tailroom(e->skb), GFP_ATOMIC))
+			return -ENOMEM;
 		skb_put(e->skb, diff);
 	}
 	if (skb_ensure_writable(e->skb, data_len))
-- 
2.56.0

