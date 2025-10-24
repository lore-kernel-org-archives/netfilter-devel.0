Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57152DA765
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321304; cv=none; b=TdY5HCxhFElaIB691THkd7YbfMFcdccLtdYcTg+06aZSrRMb4euVzhlAB36B6ow6w6/tXwuLm1hWrJPr73c7Zh1VHkaYb1PjrvTF0Vz5rGhstCwi0OWYPoyvuAkAfSYka2jK+HQYx4SIvI5eKu+alLonbNdLmsvtCVdR59BwnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321304; c=relaxed/simple;
	bh=OCQvhU3Xwt9q1pVkyH59q85z8DelD7/dxyX16GTz00s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lYvJ4s6gmHbc5SmxJLG/auh8hKUbU7R7o0lNh0Q/1nwCGK8zJs9xPt/O5vOHuAhW/w956FklPloxjUkKUEGMdzMDEsus8rH9NV7JTTNs1aVpX/NiwqUtF/en0GKEUwfdiceZLh1qw2rcqFs348eHdpPBYp6588YzTNAFNwOq8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IcynUEfE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eeSCMGos; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IS2tH2wG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aObvPcLt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IcynUEfE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eeSCMGos";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IS2tH2wG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aObvPcLt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4B6521196;
	Fri, 24 Oct 2025 15:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnWPYiVY0mExva1RjF0fsFZvPRGZr/nR0JQWXvQImw0=;
	b=IcynUEfEGjtEaozu73CYsFUNBe02SJXtD9Vh3qUmKzOYAi7XdKySvpugvIQ9gNRhRU2Jlh
	3crzEcplM+LUhuWVZivzMQXnT4Zda2quibJq/Bhbmh8pH6G3Etr4z3PZE2q3NqfcQDTk/u
	9DRmYU9FvzBdWs4eaDykxkMRxWxZAOU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnWPYiVY0mExva1RjF0fsFZvPRGZr/nR0JQWXvQImw0=;
	b=eeSCMGosdJYvSGcONcNL9Hcv/4boCx578Ds8K2ber4S8a6SM/l+TBiGRT7cMAxPHZNbu5/
	L2qzmWarH29kLTBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761321299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnWPYiVY0mExva1RjF0fsFZvPRGZr/nR0JQWXvQImw0=;
	b=IS2tH2wG6Nehw2oRZrLaSAQGERfyIXJM2NkiAsnQSDZK15Hmb0+0Gg4OYlzywxo0fyxfOB
	5o45fPGTh4uwyiNUg0zYLUDx5v4AE1I4Eydrg6NtrZbEWc8qimcHMUaVgnAKv0lOMxL42U
	YOmPhXo8bJ08ghF9W9VBoywjEUo1xZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761321299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnWPYiVY0mExva1RjF0fsFZvPRGZr/nR0JQWXvQImw0=;
	b=aObvPcLtvox+5L/P4faJ8naG89jM1yI32TpbA345nGqDEqQVe2EaaIQ8NzwG4JNJLJOMVx
	d5R2F4yh87wbZNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8629F132C2;
	Fri, 24 Oct 2025 15:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BuTHHVOh+2joFgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 24 Oct 2025 15:54:59 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf v2] netfilter: nft_connlimit: fix possible data race on connection count
Date: Fri, 24 Oct 2025 17:54:39 +0200
Message-ID: <20251024155439.3658-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80

nft_connlimit_eval() reads priv->list->count to check if the connection
limit has been exceeded. This value is being read without a lock and can
be modified by a different process. Use READ_ONCE() for correctness.

Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: adjusted commit message to reflect what is actually fixing
---
 net/netfilter/nft_connlimit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 92b984fa8175..fc35a11cdca2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -48,7 +48,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	count = priv->list->count;
+	count = READ_ONCE(priv->list->count);
 
 	if ((count > priv->limit) ^ priv->invert) {
 		regs->verdict.code = NFT_BREAK;
-- 
2.51.0

