Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F39B3644C2
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 12:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887929; cv=none; b=PXBHZrOT109tiF3rwLqtMtOZ+OhGY7raWaduPc+ROMzHkxK8/nO+5UyPLGgQzspc8R9wtO0WYF0DB7vQYMPiqXzSSNuOi3tFdM2Ff9ODONACBGQDh1hL+ERXvzxjmeX+7Knejci/Ld5uS/s3fKuxUO7uWlbisPkQtDcbgKkgipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887929; c=relaxed/simple;
	bh=+6ujtzMW3BN8eFzPZ1JoEANRFIQTHKkdZ+98Japkhiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Av7v1xDWiLHzPpyjgeFhj7RhrQHpjYKONfJZshmnr8pWZCrJ+9WeOawZa8F8nmSArMUu/MPq9yYlm7DZUhFrUhRKD9hUfuFVs2BMrTQGzWwERT+yBCDLexIEO2YB6vEWM7ckKKhnQg2snEIDIQCEyDxjlIza191fYLpXz7p7r/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qDV/WPN4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XeWe3RJX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z3xaQav9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BJSfpNL6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qDV/WPN4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XeWe3RJX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z3xaQav9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BJSfpNL6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 11D135BCD2;
	Tue, 16 Dec 2025 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765887920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKoM6c74STXvs82tmBP9NdhCSkJSeDEeGFU9+xp3Z/w=;
	b=qDV/WPN42a+E7fQnmx1oEMVbnvqrMv5hxkxEHJpyz6ZygghIkl5p4StsZIspci59gE34h5
	XqUp+f4nyjGykdkOasj3e6D2d0Lhqi5vhses6U6UjdKSVvtu65HIrUkMMs9grav/YDUmbP
	56OyJUnMDYnfeGq5JNjK1U+gzbEITTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765887920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKoM6c74STXvs82tmBP9NdhCSkJSeDEeGFU9+xp3Z/w=;
	b=XeWe3RJXlSkyxriHXwdowZxDEiBERxplscNGikpXzPdeAk/1SDv2CW4L9PEkdDGNswRwt+
	sdPIPzRL3hD9b1CQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z3xaQav9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BJSfpNL6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765887919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKoM6c74STXvs82tmBP9NdhCSkJSeDEeGFU9+xp3Z/w=;
	b=Z3xaQav9zi6JvQSp+cYdIt1gMvIdnBuiS2mNXL2PI55oLYLHivcRfMahsNp/tJ/KFSU/zF
	CXFyTx0/PECeWdDulW4nRmM1ZotgoAmncXekzCBcfkG/vj9FCAcg8Y+51ZPYu8E0C1jovy
	2KNEHZm2pgiStDLD2fNSBTK097t23Zk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765887919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UKoM6c74STXvs82tmBP9NdhCSkJSeDEeGFU9+xp3Z/w=;
	b=BJSfpNL6naRi+5GNACsfqIh1rbR/RdlIm+w5cKnoMkQtSzHkyvGcB7E4p45Yl9cG8jDWXN
	POYiqUbYqbBtD6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B96EB3EA63;
	Tue, 16 Dec 2025 12:25:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iSZNKq5PQWkpWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 16 Dec 2025 12:25:18 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Subject: [PATCH nf] netfilter: nf_conncount: increase connection clean up limit to 64
Date: Tue, 16 Dec 2025 13:24:49 +0100
Message-ID: <20251216122449.30116-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 11D135BCD2
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

After the optimization to only perform one GC per jiffy, a new problem
was introduced. If more than 8 new connections are tracked per jiffy the
list won't be cleaned up fast enough possibly reaching the limit
wrongly.

In order to prevent this issue, increase the clean up limit to 64
connections so it is easier for conncount to keep up with the new
connections tracked per jiffy rate.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Reported-by: Aleksandra Rukomoinikova <ARukomoinikova@k2.cloud>
Closes: https://lore.kernel.org/netfilter/b2064e7b-0776-4e14-adb6-c68080987471@k2.cloud/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_conncount.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3654f1e8976c..ec134729856f 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -34,8 +34,9 @@
 
 #define CONNCOUNT_SLOTS		256U
 
-#define CONNCOUNT_GC_MAX_NODES	8
-#define MAX_KEYLEN		5
+#define CONNCOUNT_GC_MAX_NODES		8
+#define CONNCOUNT_GC_MAX_COLLECT	64
+#define MAX_KEYLEN			5
 
 /* we will save the tuples of all connections we care about */
 struct nf_conncount_tuple {
@@ -187,7 +188,7 @@ static int __nf_conncount_add(struct net *net,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
-		if (collect > CONNCOUNT_GC_MAX_NODES)
+		if (collect > CONNCOUNT_GC_MAX_COLLECT)
 			break;
 
 		found = find_or_evict(net, list, conn);
@@ -316,7 +317,7 @@ static bool __nf_conncount_gc_list(struct net *net,
 		}
 
 		nf_ct_put(found_ct);
-		if (collected > CONNCOUNT_GC_MAX_NODES)
+		if (collected > CONNCOUNT_GC_MAX_COLLECT)
 			break;
 	}
 
-- 
2.51.1

