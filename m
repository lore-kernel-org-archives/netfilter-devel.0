Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D31027A900
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 12:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761569877; cv=none; b=cEiK/FPgL4aFoyRTVMzTzhQ0zxbpljWy7HhTFD5oG7MVUiNJtDrgdkDpAJ/FMlUHzL1o6b1qVVzWMdezVaVQw2RizP+bAtzpHcyiFjAH6qhKu36qLdX30WhZZky2rYLIblD2VC9IITZJ1zTt49kugfjXaBaAcVC1egQEBDmtjGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761569877; c=relaxed/simple;
	bh=loL+gqnV3yWgXd1alhWzFOheUtc2r2TQ9XqDolwYTB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UH8792teX91YhBtT6gSkdN094743NU2wTJgElepwI8PFUt34xbxl6Uk32ysYCKg43uYX8S92P3Yh+PCW/yTaLwfj1BZR6pmLbNJWCuPvTeDqG+wBICJ/t1ksaux/qbLKOj5o3WeNCvgq76ZjstYO8RaLZ/Y9tWJQxxYkitIAZjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GLt4mf1d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIdNedB9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GLt4mf1d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIdNedB9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GLt4mf1d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIdNedB9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GLt4mf1d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIdNedB9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7109E21A31;
	Mon, 27 Oct 2025 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761569873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/IdGG1JL8YO3qIsNree4dP9YQFStnXMjr5R5aMOo734=;
	b=GLt4mf1d11/JidpE63qAGD8DLDICEcfzikIr4AlrdlCGcngBK0bENW8moBXou8GuZqQDt5
	Oz4+uriAl3QLgNpIN6eGxDOUYu1R0spEOeom6hgTo7GGCyCiZxWx4l5I5hubljUwnuRdYU
	CBjh3Nr6fWSRqKhY+ohi+cXBJmHOnUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761569873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/IdGG1JL8YO3qIsNree4dP9YQFStnXMjr5R5aMOo734=;
	b=BIdNedB9lp68mzoecHHcUmOEikFzYgG9JLJYBac1xc9fx1LhjOjkN12BSBcy4ZDd4KgjiC
	AF6P22E/t22Uo2DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GLt4mf1d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BIdNedB9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761569873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/IdGG1JL8YO3qIsNree4dP9YQFStnXMjr5R5aMOo734=;
	b=GLt4mf1d11/JidpE63qAGD8DLDICEcfzikIr4AlrdlCGcngBK0bENW8moBXou8GuZqQDt5
	Oz4+uriAl3QLgNpIN6eGxDOUYu1R0spEOeom6hgTo7GGCyCiZxWx4l5I5hubljUwnuRdYU
	CBjh3Nr6fWSRqKhY+ohi+cXBJmHOnUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761569873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/IdGG1JL8YO3qIsNree4dP9YQFStnXMjr5R5aMOo734=;
	b=BIdNedB9lp68mzoecHHcUmOEikFzYgG9JLJYBac1xc9fx1LhjOjkN12BSBcy4ZDd4KgjiC
	AF6P22E/t22Uo2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2068313693;
	Mon, 27 Oct 2025 12:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UR/cBFFs/2gvMgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Oct 2025 12:57:53 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	louis.t42@caramail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of a connection
Date: Mon, 27 Oct 2025 13:57:30 +0100
Message-ID: <20251027125730.3864-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 7109E21A31
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[netfilter.org,caramail.com,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_ENVRCPT(0.00)[caramail.com]
X-Spam-Score: -3.01

Connlimit expression can be used for all kind of packets and not only
for packets with connection state new. See this ruleset as example:

table ip filter {
        chain input {
                type filter hook input priority filter; policy accept;
                tcp dport 22 ct count over 4 counter
        }
}

Currently, if the connection count goes over the limit the counter will
count the packets. When a connection is closed, the connection count
won't decrement as it should because it is only updated for new
connections due to an optimization on __nf_conncount_add() that prevents
updating the list if the connection is duplicated.

In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
unnecessary GC") there can be situations where a duplicated connection
is added to the list. This is caused by two packets from the same
connection being processed during the same jiffy.

To solve these problems, check whether this is a new connection and only
add the connection to the list if that is the case during connlimit
evaluation. Otherwise run a GC to update the count. This doesn't yield a
performance degradation.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_connlimit.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index fc35a11cdca2..19c8b5377e35 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -43,9 +43,15 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 		return;
 	}
 
-	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
-		regs->verdict.code = NF_DROP;
-		return;
+	if (ctinfo == IP_CT_NEW) {
+		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
+			regs->verdict.code = NF_DROP;
+			return;
+		}
+	} else {
+		local_bh_disable();
+		nf_conncount_gc_list(nft_net(pkt), priv->list);
+		local_bh_enable();
 	}
 
 	count = READ_ONCE(priv->list->count);
-- 
2.51.0

