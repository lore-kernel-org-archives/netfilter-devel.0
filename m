Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C783859D3;
	Tue,  6 Oct 2026 20:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319724; cv=none; b=nA+oMNy6W2aFKjUi5LtwGaJ4ngIXAy3YKlaR1k0WdOkh8HQJ/eboKDSAZ8udKJoL0ri/0OsPAx9IqKOuxgzQAeqIsPf3BuG+Hox474qpi478azdT9Pnrr8+Njkjs4z/XpqujbM9eF5DQXAA8skD9I4r7HEq926GazJnBLWSoif8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319724; c=relaxed/simple;
	bh=tB0qHnJJHa9piPfqzJkvOTKvaRYSaeMyRFhMHIMkdFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pBiDGS38dVxcml0PkwNsqHCCcf4uaQqJ92KEY/boYU9Sb3xJVgcVrmj+jqodbCRn0WCS+uv2KOUA5wOVAQVILp7ck8elXXR26GyLtWAe0NjtfBEKV/1EBsEzIYClcRkd+KYloHVv7HVSsncugijcuLGJtTvP5vZ9FAajyOLFJJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VgCakNKt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F/9U/Q/6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cf3hZmoX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P3gQ93te; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VgCakNKt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F/9U/Q/6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cf3hZmoX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P3gQ93te"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0613C21F72;
	Tue,  6 Oct 2026 20:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cWm1QfHzzykaWrbfkyEzggECciRPa7kq9IHoGlt8wHI=;
	b=VgCakNKtFP1A4e+W9P2v6GEUIwfkV7xAfnX7kV3mq0zR2PheXK82mphQETy1l86QNICKfX
	RNazyUpUjjhOenNg0U6TbACsU8w4hYWwK9xI8DTaV2wc+Zisgqce+iIsp2ep+ynoSjAhUO
	I3Uhcdx2kYFtdzWLuqd8vlmc0qqk4rc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cWm1QfHzzykaWrbfkyEzggECciRPa7kq9IHoGlt8wHI=;
	b=F/9U/Q/6Qe3Iimo8bmsh7IYVnSyUO3Dn09oFpVfnFBTSsClenM3afDbGZ/sPjqT7uBbyuI
	HdIhMEZf/qH4LsDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cf3hZmoX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P3gQ93te
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cWm1QfHzzykaWrbfkyEzggECciRPa7kq9IHoGlt8wHI=;
	b=Cf3hZmoX9BELsUBFa0geK9LBZ+qZgYTXjtLYyaCk/gWuD+wFx0iM8NIuT+jj43pc1sZQkG
	WWKpPIiAfZkjpVzylFiFiPiHmaOvJBqlgFhSkPUZM5t55KB8+MrrcNEaCNKohQMPw6gp/W
	qi3NxXhMrUtYEvxhD46+myEbS3UrIdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cWm1QfHzzykaWrbfkyEzggECciRPa7kq9IHoGlt8wHI=;
	b=P3gQ93te75hxqBhXBSAEIG3B5H7xURP/+5cGJu5ECo0ReX2oN4mCCdxM8DnP68roPxb8TE
	QFKY8xHrc2jJ8cCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60BA4137AC;
	Tue,  6 Oct 2026 20:48:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QZJsDKBexWonPwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 06 Oct 2026 20:48:32 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	matttbe@kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft v2] doc: add MPTCP subtypes documentation to man page
Date: Tue,  6 Oct 2026 22:48:03 +0200
Message-ID: <20261006204803.11155-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0613C21F72
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:email,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

In addition, document the limitation when there are multiple MPTCP
options.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: added valid MPTCP situations suggested by Matthieu
---
 doc/payload-expression.txt | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index ceccfdaa..53e92905 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -805,6 +805,32 @@ TCP option matching also supports raw expression syntax to access arbitrary opti
 [verse]
 *tcp option* *@*'number'*,*'offset'*,*'length'
 
+.MPTCP subtypes
+[options="header"]
+|============================
+|Keyword| Description
+|mp-capable|
+Multipath capable
+|mp-join|
+Join connection
+|dss|
+Data sequence signal
+|add-addr|
+Add address
+|remove-addr|
+Remove address
+|mp-prio|
+Change subflow priority
+|mp-fail|
+Fallback to single-path TCP
+|mp-fastclose|
+Fast close
+|mp-tcprst|
+Subflow reset
+|============================
+
+Data types can be queried with 'nft describe tcp option mptcp subtype'.
+
 .IP Options
 [options="header"]
 |==================
@@ -833,6 +859,21 @@ filter input tcp option sack-perm exists counter
 filter input tcp option maxseg size lt 536
 --------------------
 
+.matching MPTCP suboptions
+--------------------
+filter input tcp option mptcp subtype mp-join drop
+--------------------
+
+[NOTE]
+====================
+Netfilter currently evaluates only the first MPTCP option found in the TCP
+header. If a packet contains multiple MPTCP options, a rule attempting to match
+the second option will never match. Having multiple MPTCP options in the same
+packet is valid, e.g the Linux MPTCP stack inserts 'remove-addr', 'mp-prio' and
+'mp-fail' after an MPTCP 'dss' option; 'mp-tcprst' can also be inserted after
+an 'mp-fastclose'.
+====================
+
 .matching IPv6 exthdr
 ---------------------
 ip6 filter input frag more-fragments 1 counter
-- 
2.55.0

