Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AE233FE09
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884002; cv=none; b=XrfXL9ks1sUJ3g45z29f/6Jxd0tkI5V26C/Ni4TQif9O8/FYJrvyLV+5KTuDvU7I7Ldx65dx8kWKwyMMEFaTag8IHaxgDobGKtgLcBymM9tyWwteAQCYjK3yTRXA/nZoPSRKvquUzns/M+1Qszr+cUSPzcH2wmRCrvI2N7pvEbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884002; c=relaxed/simple;
	bh=0y4Sq7gQPWppJ06VDRmLY4D/q5BTT+zyCdExn0GUwok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUnOx2u8jcqkw8RtZ5aM57AToPcoOyr3pxilFv1JdV8zGprr+wLLL7Yb4L2UUVyAKTSCRmB+dWYP4oXgK2iMPoLsrlAPOiUrg4MxCrGwT8qMz7rjaiVlugAxFaAZ9t3j3np/Ig3yGCuVcHADo7/IPRcmbPww29XmvJP/lE3KU9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JqB49kH/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lKfMEvWZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JqB49kH/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lKfMEvWZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JqB49kH/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lKfMEvWZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JqB49kH/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lKfMEvWZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8675B5BD10;
	Mon, 30 Mar 2026 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774883994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3hGhJiuCBz6o+x3MJeJh5zPPdNDrxDfsBG9wcKPG2U=;
	b=JqB49kH/CIl+OYudNq1k6a1q8zdb2RkNtt2xJe6sqWOUBfYCyf+OJv+vyHgCOn5ZXRAOD+
	DND5tidEKTNHRbOE/HdvBtHa/SHHGRMy41fh+ptoUe/1hrnHzgKxfvtjZ12v8KfbJcT3s2
	sPEMNL1zLAr8IlwB36jm4Cse0TFi0oA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774883994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3hGhJiuCBz6o+x3MJeJh5zPPdNDrxDfsBG9wcKPG2U=;
	b=lKfMEvWZqPcY7cMuPiff9V5wT4rcCIIf65bw0aJ/Rg117La2Hncm6m8bQ5c8nor1Xwvkc2
	LvecEj2tVUwNUGBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774883994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3hGhJiuCBz6o+x3MJeJh5zPPdNDrxDfsBG9wcKPG2U=;
	b=JqB49kH/CIl+OYudNq1k6a1q8zdb2RkNtt2xJe6sqWOUBfYCyf+OJv+vyHgCOn5ZXRAOD+
	DND5tidEKTNHRbOE/HdvBtHa/SHHGRMy41fh+ptoUe/1hrnHzgKxfvtjZ12v8KfbJcT3s2
	sPEMNL1zLAr8IlwB36jm4Cse0TFi0oA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774883994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/3hGhJiuCBz6o+x3MJeJh5zPPdNDrxDfsBG9wcKPG2U=;
	b=lKfMEvWZqPcY7cMuPiff9V5wT4rcCIIf65bw0aJ/Rg117La2Hncm6m8bQ5c8nor1Xwvkc2
	LvecEj2tVUwNUGBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F0644A0A2;
	Mon, 30 Mar 2026 15:19:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wOZ7AJqUymn8EQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 30 Mar 2026 15:19:54 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/2 nf-next] netfilter: conntrack: remove unused MAX_NF_CT_PROTO constant
Date: Mon, 30 Mar 2026 17:19:35 +0200
Message-ID: <20260330151935.5828-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330151935.5828-1-fmancera@suse.de>
References: <20260330151935.5828-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

This is a leftover from commit 4a60dc748d12 ("netfilter: conntrack:
remove nf_ct_l4proto_find_get") and it is unused.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 91f5254ad6fa..fde2427ceb8f 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -134,8 +134,6 @@ void nf_conntrack_icmpv6_init_net(struct net *net);
 /* Existing built-in generic protocol */
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
-#define MAX_NF_CT_PROTO IPPROTO_UDPLITE
-
 const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto);
 
 /* Generic netlink helpers */
-- 
2.53.0

