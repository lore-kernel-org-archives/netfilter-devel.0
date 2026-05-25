Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1728382369
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 12:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713106; cv=none; b=EK0y66BO8OGmVHD24fxvfOwCTgqwvycMOwGZk7gblBfbRvbqkYv4zKnkuI5Bat7onDhpiJn5XSBOBTa+QQTinYrz8QNEHKkp0eGzVgovhvnbW4jJa/vRuv3Y95BGC7/dQLhFIc1wQcAdVbJjCfrmteUwYyU5X3c6WRO/zPvGYao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713106; c=relaxed/simple;
	bh=rtD48gbCesQ/D7jcQPUyMafQfuCFKt72YgVmVuRvES4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5W2k/PuPHttivpP6p7/MqLmaN1QPKiOSaKZ1vUyYl1k5p08FNmpKv5HLD0lfGtkfR8dN/w2iMbA+nh2ceVu/3DjlYmo+QUBOc7C1RdL+TYOezCfQy5Gr9pbkeuoOVNYNnbkbRqp6jx1H21f1qXVqStmsv8sBwiR9nXMvVwM+7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g3Iv1NTB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GBT9O8r1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g3Iv1NTB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GBT9O8r1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g3Iv1NTB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GBT9O8r1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g3Iv1NTB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GBT9O8r1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57BD864D0F;
	Mon, 25 May 2026 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779713099; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=op7nQwijrYYCzmB+0P/hcOLxlnk6XWNNUH4WLqYiKeo=;
	b=g3Iv1NTBFhh5w02OjRjQBRMEGoWhGTepmrh6FwdRGPeqD9OnfsnbpmdOnUKNArDWCekQhZ
	Jhsp3+PSfPc6M/5uzUqgYcuRzFXYuqHADtI9igYc/KN+GUpJQyqSvCi3AhAkCfR8solEwF
	lmgX3v5Q5+nokxZ7QS6YYrGRGfFwq6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779713099;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=op7nQwijrYYCzmB+0P/hcOLxlnk6XWNNUH4WLqYiKeo=;
	b=GBT9O8r15jLFGvGIqlv3sTMF5R0D59dK085sqn8tMOJFKRw9b94oxqWm2c29iBSwWDwG1g
	V68CS1tnddxgdACw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779713099; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=op7nQwijrYYCzmB+0P/hcOLxlnk6XWNNUH4WLqYiKeo=;
	b=g3Iv1NTBFhh5w02OjRjQBRMEGoWhGTepmrh6FwdRGPeqD9OnfsnbpmdOnUKNArDWCekQhZ
	Jhsp3+PSfPc6M/5uzUqgYcuRzFXYuqHADtI9igYc/KN+GUpJQyqSvCi3AhAkCfR8solEwF
	lmgX3v5Q5+nokxZ7QS6YYrGRGfFwq6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779713099;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=op7nQwijrYYCzmB+0P/hcOLxlnk6XWNNUH4WLqYiKeo=;
	b=GBT9O8r15jLFGvGIqlv3sTMF5R0D59dK085sqn8tMOJFKRw9b94oxqWm2c29iBSwWDwG1g
	V68CS1tnddxgdACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E43D059C50;
	Mon, 25 May 2026 12:44:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SB61NEpEFGq1SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 25 May 2026 12:44:58 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/4 nf v2] netfilter: synproxy: adjust duplicate timestamp options
Date: Mon, 25 May 2026 14:44:48 +0200
Message-ID: <20260525124450.6043-3-fmancera@suse.de>
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
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index e523b64bf839..6bd63f5ab75d 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -229,7 +229,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0

