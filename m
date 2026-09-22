Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08139489FDB
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104767; cv=none; b=KVZrRgTth2oegvSkvZYgtZ3x1hSXd7Nh3Ew1EmRQn2sINB4WjZgjDQ6k5TFuhJHW4lBy9IjdZRBWCISf+Qqft6Eg+tAPyFsCm3RmJGd4Zg6F4cd3EQ768LiYWaqwjgMXZiuosH1FcS5QKMAyvr6lFmcgtcbxA11fuaqkkNwE1/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104767; c=relaxed/simple;
	bh=TxfxsaBQAnm+cK/lK1gGhJVPGQJA22+zykHM/6QBpzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kUDmTQaW+0weZGHKfgU4uHmVW2vdjkEn374VoeMgitOdia9Vx2XnAiNaufstXwwpNVHBEr7Ah2QbKXPGl/SsarVYbTwSXM6PJsTgXOkN4huQjH/iE4AAIxANn611dqs1ybMIFubIlHYj5ceYK04u6bhdfj2ofPfaQPEVewZhr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Dv1FapSh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WHy9aSQ5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CEYGwZlS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BJvHf7fA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Dv1FapSh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WHy9aSQ5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CEYGwZlS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BJvHf7fA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ADED821A9E;
	Tue, 22 Sep 2026 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790104759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eki/p2QcNk2PX3bPA94s21pj9KKWpjkZv1dKWbvhy+M=;
	b=Dv1FapShf5OxjEpbBUSbcwiE1E2yCJkIB2Mi3WFDJ3UB55kL2p+AHHLHxDpC5l/0y4ryeQ
	TX8gtixfKgZEf/CjSzAt3ihvI6lP9XJsao4PqI+xMcICsFMClqsAScJ6rTxIAVM71s9d0P
	peetCJHgpz32GQXJ1k1BtCEOH0CM1T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790104759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eki/p2QcNk2PX3bPA94s21pj9KKWpjkZv1dKWbvhy+M=;
	b=WHy9aSQ5K9Nobutok7RO3q219I2Rl6B4tiYtTomcc7xFkdRlg/2Y8JGvXwSuuDE1luRPgb
	2LRgwdBxkAFYjzCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790104755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eki/p2QcNk2PX3bPA94s21pj9KKWpjkZv1dKWbvhy+M=;
	b=CEYGwZlSIM/Q8Hm5i0gayUIrEVO4rT0jCHrX7mG0TzH0p+oDHvMpf9iPpFYMQBdajs8Gpv
	ZeXvPYFlAqNggI+tLKrpoSh6KeIYNu4Y4x63FOuFhXITUtdKqtuDFV20dmGMFtXfTo0dp6
	vm6ncGQMgXPVoK9Aj8EILgnKjFUJgm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790104755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eki/p2QcNk2PX3bPA94s21pj9KKWpjkZv1dKWbvhy+M=;
	b=BJvHf7fAnQKnXN57+JtK62yPCBT8Sc7WIpRkjq+8VjMPsg3aktfRGn8XJrxUZAklWqZg+e
	6cjnaR+Zi0mB8RDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07D1A13312;
	Tue, 22 Sep 2026 19:19:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qBKTMrLUsmrkbwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 22 Sep 2026 19:19:14 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	ast@kernel.org,
	lorenzo@kernel.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	VEGA <vega@nebusec.ai>
Subject: [PATCH nf] netfilter: bpf: reject invalid NAT manipulation types
Date: Tue, 22 Sep 2026 21:18:52 +0200
Message-ID: <20260922191852.5462-1-fmancera@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nebusec.ai:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

As bpf_ct_set_nat_info() is not validating the NAT manipulation type a
wrong value can be passed directly to nf_nat_setup_info(). This triggers
the WARN_ON() at nf_nat_setup_info() and if panic_on_warn isn't set,
then IPS_SRC_NAT_DONE is set without adding nat_bysource and conntrack
cleanup tries to unlink an uninitialized hlist node.

Fix this by checking that NAT manipulation type is correct before
calling nf_nat_setup_info(). In addition, if the WARN_ON is hit, return
NF_DROP instead of continuing with the processing to avoid similar
situations in the future.

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_nat_bpf.c  | 3 +++
 net/netfilter/nf_nat_core.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
index f9dd85ccea01..7572b58c448b 100644
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -39,6 +39,9 @@ __bpf_kfunc int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
 	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
 		return -EINVAL;
 
+	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
+		return -EINVAL;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index a4858c2b2d65..cc8e1e81006d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -767,8 +767,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
-		maniptype != NF_NAT_MANIP_DST);
+	if (WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
+		    maniptype != NF_NAT_MANIP_DST))
+		return NF_DROP;
 
 	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
 		return NF_DROP;
-- 
2.55.0

