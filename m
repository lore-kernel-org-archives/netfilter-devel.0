Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00052D2BE
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 14:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691296; cv=none; b=N8j5JVEnpsFS58p3II6cm+1I26HLvPnsvwrAKzyo22zTJt5OVoRhcBKzvPRAr8AQnqS1rsw91FKCwA2hzRKCADJF/mhqI2it4h6m6ndGlX/BD5rWcYY5ROSi+FgA2XwmD4iaLTBn7/lJ7Mwm2eaJJbF3R2wfH7gkjerC6eUOTc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691296; c=relaxed/simple;
	bh=oQMqtCVO963LYO6GxnlEYa5pBPRzhOSPTolBTjDzObs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XkTDLrX22+T0dCVNymIFnrMSv15ARFor4FXW+FN7ssO0bD+zHI+SZSb3EAKFNopvRgMHDIO7/OfzrbqZ8Dnf7BQ0aSENHf3D8MwzV72Pgb0IAIl2X3xkZ0zZryokviEx593amIL0qS9Q33PWGmSRfDxKcxjzLMJBT1GcDZXK1AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KaMxLnSO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=byn9yehA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j33fTn4+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Cj2/fFaD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KaMxLnSO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="byn9yehA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j33fTn4+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Cj2/fFaD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4D16A21BF1;
	Tue, 29 Sep 2026 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790691286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B2QfYXi/jebmAkFuYfyaa/Yo7bTswCT6tU+KrK/Ga8k=;
	b=KaMxLnSOKkv+XMUK3k3fbLwI2M0oXHGt3qFlyQOyAjk8ifkDhoAs9E3wKXmLIh4mq4lWLd
	PFDrBFKcK6eMww01I+JaxQuHKGLmWo9DZ1tCLCObfYVNsZN2X6x/Eoq+o+lWrHwsxvUXkH
	IgRaKqKDyjxdUHJ6K7pwJeQ2q7XL8zk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790691286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B2QfYXi/jebmAkFuYfyaa/Yo7bTswCT6tU+KrK/Ga8k=;
	b=byn9yehADBITBNgK9pGUj2L9/0yh75qPVmvdCWjPa1WqYPPbojNT9C++fEE+nwEvVEl7Dz
	whb8UWZfoYETriCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790691282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B2QfYXi/jebmAkFuYfyaa/Yo7bTswCT6tU+KrK/Ga8k=;
	b=j33fTn4+acy64Us1STCokmEdCMHVcmhIweYriOusdPOzdzFkVgpDsux+kuxO/CiWejADhk
	Lte88KqTdVon6zHiQ79jqx/sle24B4awIEGRSyRYkC03D0b+CsiPLgAPx+Rtei5wABG70M
	//boxedlfkDu82AKgss1Mso8+D0ZPuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790691282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B2QfYXi/jebmAkFuYfyaa/Yo7bTswCT6tU+KrK/Ga8k=;
	b=Cj2/fFaDv6hna+txL+FV/GSmKNNIm3wZEY9dcSDJb5NEb011n/c8qFk88piaqeL/yvutGy
	XTcSubmV0UGXzHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D63C9133F1;
	Tue, 29 Sep 2026 14:14:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BQxwKNHHu2ofTwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 29 Sep 2026 14:14:41 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	matttbe@kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft] doc: add MPTCP subtypes documentation to man page
Date: Tue, 29 Sep 2026 16:14:25 +0200
Message-ID: <20260929141425.4852-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

In addition, document the limitation when there are multiple MPTCP
options.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 doc/payload-expression.txt | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index ceccfdaa..f1de0956 100644
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
@@ -833,6 +859,18 @@ filter input tcp option sack-perm exists counter
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
+the second option will never match.
+====================
+
 .matching IPv6 exthdr
 ---------------------
 ip6 filter input frag more-fragments 1 counter
-- 
2.55.0

