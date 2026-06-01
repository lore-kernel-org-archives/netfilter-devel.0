Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB7234D901
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342284; cv=none; b=L8sGRuYNbRFfKIALjCAUTP45b1ORhTv8tInmFMNr8wzLIvjcaS8oq3qSEUNpycys9lH98RgRZqh3w4x/er4dg7S3aUk2XaCXsLYrvDmiVYcCqPUCQLee1jBc2LM4cVmZ6MNgtjGNNO6/SkWlBM9ww4gxpEXlIrh4ZiN61h4oFAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342284; c=relaxed/simple;
	bh=VJrEMg1rCx6xqvxuXp+AFfirPCkFvSTkJ/LPShn4kQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y85jDLduxpwdgPiGM1moIGSA6Eg5UyxGkHntlVF96DiPfQajnpxGJqUW8L7S2hRl5nzZ5jXoBDACuXMAH2kr4CIpPCe6Hkj4w3jRDwmI/maz8DVZLGUgSrVREif6Tc7Fiy1YqpAZqnNfcMf1RrQC8wvVdEY2xRXqBB/rDtQxw3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uORnCY0h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kuMAoKVo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uORnCY0h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kuMAoKVo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uORnCY0h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kuMAoKVo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uORnCY0h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kuMAoKVo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8053768738;
	Mon,  1 Jun 2026 19:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1iJvDRo91ol/rovsTFJLJYDTXZCZGM5oS+uHUPHod8=;
	b=uORnCY0hGx6gHLs1xK6zu4USsCa/G11FBaa1KFDMa7YXYxpj879R6uDsKEI5W3nh6yO/e7
	fcJlpb8v7yjaTagoyQUXS7Lb/FAcYKy65F5q1TfeEN2BSSsirUNIhcZ4ohu4cebqa5a1sG
	U+I+kmbIFNIfLwGHEUWMU7SvRtdK/F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1iJvDRo91ol/rovsTFJLJYDTXZCZGM5oS+uHUPHod8=;
	b=kuMAoKVonSWO3DN34zFhT7rFPt/TkfQj6aECxRm8WVn0CrK0qKZKmyj3Zmhy6piDNp4rkN
	eUlW3nRF2lzSmkDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uORnCY0h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kuMAoKVo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1iJvDRo91ol/rovsTFJLJYDTXZCZGM5oS+uHUPHod8=;
	b=uORnCY0hGx6gHLs1xK6zu4USsCa/G11FBaa1KFDMa7YXYxpj879R6uDsKEI5W3nh6yO/e7
	fcJlpb8v7yjaTagoyQUXS7Lb/FAcYKy65F5q1TfeEN2BSSsirUNIhcZ4ohu4cebqa5a1sG
	U+I+kmbIFNIfLwGHEUWMU7SvRtdK/F4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w1iJvDRo91ol/rovsTFJLJYDTXZCZGM5oS+uHUPHod8=;
	b=kuMAoKVonSWO3DN34zFhT7rFPt/TkfQj6aECxRm8WVn0CrK0qKZKmyj3Zmhy6piDNp4rkN
	eUlW3nRF2lzSmkDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21792779A7;
	Mon,  1 Jun 2026 19:31:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IGVwBfjdHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:04 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/9 nf-next] netfilter: nfnetlink: use DEBUG_NET_WARN_ON_ONCE for attribute validation
Date: Mon,  1 Jun 2026 21:30:43 +0200
Message-ID: <20260601193049.8131-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601193049.8131-1-fmancera@suse.de>
References: <20260601193049.8131-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8053768738
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Replace WARN_ON and WARN_ONCE with DEBUG_NET_WARN_ON_ONCE in the
nfnetlink and cttimeout interfaces. These validation failures are
already handled by returning -EINVAL to userspace.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nfnetlink.c           | 4 +++-
 net/netfilter/nfnetlink_cttimeout.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 47f3ed441f64..8c4c8bfedd64 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -117,8 +117,10 @@ int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 
 	/* Sanity-check attr_count size to avoid stack buffer overflow. */
 	for (cb_id = 0; cb_id < n->cb_count; cb_id++)
-		if (WARN_ON(n->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT))
+		if (unlikely(n->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT)) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			return -EINVAL;
+		}
 
 	nfnl_lock(n->subsys_id);
 	if (table[n->subsys_id].subsys) {
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index dca6826af7de..c33558a02e8e 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -476,7 +476,8 @@ static int cttimeout_default_get(struct sk_buff *skb,
 		timeouts = &nf_generic_pernet(info->net)->timeout;
 		break;
 	default:
-		WARN_ONCE(1, "Missing timeouts for proto %d", l4proto->l4proto);
+		pr_warn_once("Missing timeouts for proto %d\n", l4proto->l4proto);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 
-- 
2.54.0

