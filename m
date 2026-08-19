Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A55E44BCA8
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2026 10:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135069; cv=none; b=LVO1YYnXhXRUjBjMhw8WnyUmCk4opXicrz5mGq0+ucEDBGM1QpN0oUvl0Z4vReAeZz8hNTlFxFiHQoLSDNmAklaDmCTA27YpA6+vCqs6RKy3ya1ycDE65Pjyol4puHBbIZnMvF9a1ai7lJdmfzQ02k2YIGeDFWr9MkGc5nuJNgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135069; c=relaxed/simple;
	bh=0QvOEI4rT1e8NmSdGfTudXhA9ujJQ1xeygG8+B6ZdiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P5t/hRPIXyk4S0CBQ5KTVM48zqqw06TDd7VwLa4gm3Gr38MSCxH5SklPsx5wqynOB783tSj3XWY2ZBkizO4wvYa2UWtEYRy4rlF0UbCv068gFcXpVLWzi116h8OjiWB3fh0e5XsjFrM/KvZYAEQWQctvlsVmKoXbXKoTE1972nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RCzX1CsM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nXzM137D; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1OJ7gCp9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yxhzaDRc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RCzX1CsM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nXzM137D";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1OJ7gCp9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yxhzaDRc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 13E603E54;
	Wed, 19 Aug 2026 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787135062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4P/NFplZIvWQU1IizQEb+TQi8IAgJcovoDcvTpBIzI=;
	b=RCzX1CsM2VjuU24diCu1XoHd11IIIjshF6BMij+ecpxFTAxzUDwJ27HXfgxyR0ZiOwjiTJ
	FrKXDejRvOHvzgwfx/wyODfcjcpde9h1AVQmSjfcu7WRDJabh6XPmdODZaPetqly5uedhZ
	9ROGaVRnqKV4HjVny07XkE13AS3pH30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787135062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4P/NFplZIvWQU1IizQEb+TQi8IAgJcovoDcvTpBIzI=;
	b=nXzM137Dh4S1N/xrv4TueiAkn5NS8WJ9Xju0hNh5gA5taI+6zvgWoPl5RMoAjx/2NBrRIj
	WrUJGZytRdiM3/CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787135058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4P/NFplZIvWQU1IizQEb+TQi8IAgJcovoDcvTpBIzI=;
	b=1OJ7gCp9XmCUCh8o6gYa90NiToCxJbCKAC7VzAJvKn+CEdwlEyGmCvUQG2r/YtxsDyn0+s
	vY3vdK37P4AS07K993sVgmNGJzn0iUdmsE4F0UHt/SYI+zAWOtp+9RfS88sRZQlod938nz
	tqYVneb9Q6Y5QLnylzq+qdRU3qCw4ME=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787135058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4P/NFplZIvWQU1IizQEb+TQi8IAgJcovoDcvTpBIzI=;
	b=yxhzaDRcr7VURfgs2BpozxyKwsYt070wd9W1Gt6S8epklloiVsrXYgKcJkCw0h9Rf4rdc4
	dg7Ls+7m66lPKoDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A841C362E;
	Wed, 19 Aug 2026 10:24:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a35JJlGEhWraEgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 19 Aug 2026 10:24:17 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 nf-next] netfilter: seqadj: do not take ct lock if seqadj is NULL
Date: Wed, 19 Aug 2026 12:24:07 +0200
Message-ID: <20260819102408.3223-1-fmancera@suse.de>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

This is a small optimization, only take ct lock if seqadj is present. In
the unlikely case seqadj isn't present we can return immediately. This
is consistent with the behavior of other functions that checks seqadj.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_conntrack_seqadj.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 220216a4edc5..d75e8dafb189 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -10,20 +10,19 @@
 int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		      s32 off)
 {
+	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	struct nf_conn_seqadj *seqadj;
 	struct nf_ct_seqadj *this_way;
 
 	if (off == 0)
 		return 0;
 
-	spin_lock_bh(&ct->lock);
-	seqadj = nfct_seqadj(ct);
-	if (!seqadj) {
-		spin_unlock_bh(&ct->lock);
+	if (unlikely(!seqadj))
 		return 0;
-	}
+
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
+
+	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
-- 
2.55.0

