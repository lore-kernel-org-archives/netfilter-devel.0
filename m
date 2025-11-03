Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD3F1922F5
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2025 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193783; cv=none; b=PeAWuIfDmkqSbLDlvFoge9b69mE0lmrHyA7By1V6zRlZnwnGOeAmzslhZ/FY+q+cygtTcgbYGXq4FKt5cF6ybqizckGOxwmDOLjOVZk4LAyCCVzLrjpF1cw8j1XgyLIBhcOlUUbmOigJfIfPCzDDufE7sBn3OYBIjBrQZ/N0pLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193783; c=relaxed/simple;
	bh=U2rH1HMVSRVbHbLwq/ViJ2Hanj1T/K2Tf0F7S9kIc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JhPSTm4QzCDbn/XC1tfneuE0k97A/iS8GVVIkI4kAg6XTUGY2BBUYPqjvjqceQCogTAcwFqZYg5Ge/Iqf0Vp6ncgjNAagArtlep/g6gaOxo/s2fC0ZUUVnPPFxUcWeMo5pohHqdn6cU6KMoGdqIFhpgR/NXdSIjfdDRAMxOLswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PzNcun7o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+ECJKHt6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PzNcun7o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+ECJKHt6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PzNcun7o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+ECJKHt6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PzNcun7o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+ECJKHt6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B72F21B30;
	Mon,  3 Nov 2025 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762193779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XkkVS4AfWseTttCLltuMfg69dl0R7NirnBu+ptqeA3k=;
	b=PzNcun7oI6BdPDFUy8TdaCldYE89qLd9mhamhpW5rCrn7ieL0xsew7PF0t1UnH9J1Q6N8o
	HJaLLyXuKUFsVtSeSrr3NQHiGTDPHOS92uYBbaYvahHPehQdqaNEolUabQtocytF7yCTmy
	itUoj/azeZlwU7MvQVJFBe1nf3Ld2Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762193779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XkkVS4AfWseTttCLltuMfg69dl0R7NirnBu+ptqeA3k=;
	b=+ECJKHt6KO61C9SV8UMeB71UrSDfeWVPmmJpQSwRwD1c8vvRJd+gb94Dl0YwTs/zI/Xp3X
	YNigI9KsbUH48PBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762193779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XkkVS4AfWseTttCLltuMfg69dl0R7NirnBu+ptqeA3k=;
	b=PzNcun7oI6BdPDFUy8TdaCldYE89qLd9mhamhpW5rCrn7ieL0xsew7PF0t1UnH9J1Q6N8o
	HJaLLyXuKUFsVtSeSrr3NQHiGTDPHOS92uYBbaYvahHPehQdqaNEolUabQtocytF7yCTmy
	itUoj/azeZlwU7MvQVJFBe1nf3Ld2Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762193779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XkkVS4AfWseTttCLltuMfg69dl0R7NirnBu+ptqeA3k=;
	b=+ECJKHt6KO61C9SV8UMeB71UrSDfeWVPmmJpQSwRwD1c8vvRJd+gb94Dl0YwTs/zI/Xp3X
	YNigI9KsbUH48PBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1C5C1364F;
	Mon,  3 Nov 2025 18:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JqYQMHLxCGnQPgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 03 Nov 2025 18:16:18 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft] rule: add missing documentation for cmd_obj enum
Date: Mon,  3 Nov 2025 19:16:08 +0100
Message-ID: <20251103181608.24564-1-fmancera@suse.de>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

In cmd_obj enum hooks, tunnel and tunnels elements documentation were
missing.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/rule.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index bcdc50ca..e8b3c037 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -674,6 +674,9 @@ enum cmd_ops {
  * @CMD_OBJ_SECMARKS:	multiple secmarks
  * @CMD_OBJ_SYNPROXY:	synproxy
  * @CMD_OBJ_SYNPROXYS:	multiple synproxys
+ * @CMD_OBJ_TUNNEL:	tunnel
+ * @CMD_OBJ_TUNNELS:	multiple tunnels
+ * @CMD_OBJ_HOOKS:	hooks, used only for dumping
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
-- 
2.51.0

