Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D185233E355
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779565700; cv=none; b=avy9t3BNzc8Q83IRt6/Zr/QfyVNB4dHy4fZV40QhxEIAZLD1JiiVFr5aw2gxUApNkM2kzdGTGFSjxoT5b9K/ULenM5StBzJs1B+f1mxlgor9xN8T2vLJbHi2mKxKJaG5wuMi/jgA9czoadkMkd18tBFw4Nd2vssIGWgc66V2PV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779565700; c=relaxed/simple;
	bh=j+uHFCzyxO9wPDx4ZPxmnyyddCYEokJ8P3ybQf+woEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r0uBrX+7p0b/LVC6LQgInGnDLahX4Xbfyl0NlN9uplBd/eXyIBW/VaO+V9ca8TtCnFwXx9KtMMq3B7G33OY3/6ZW57JeTHtDRGf84a548WdzEOptVbCiPrN5DmFBaaAGUXTFLAbfmO5V0nmHKN2lXLGkBibATrZHjpU8LIoAm1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gWu+TiKB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qd2EiRAS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gWu+TiKB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qd2EiRAS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gWu+TiKB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qd2EiRAS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gWu+TiKB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qd2EiRAS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDA986BAE4;
	Sat, 23 May 2026 19:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SnfQ17bd4JpzK0jLR1WpKHAID2fvow3U96s0QGeaiww=;
	b=gWu+TiKBPI8PwWzn3PRkfwZZc5w/79T3m0sdatGDGtGCl4hcpEnAlsaBsG1wI6tLBhCCfk
	wzlPZaN+gaL7ywoGZIA0Zcn+fy19KY0aqdm5CiZ35AifF1/gzBsUjPhlHDMNhLoFLvrf/N
	GytanmNb91/aDgAqFGE8owWXu3shSRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SnfQ17bd4JpzK0jLR1WpKHAID2fvow3U96s0QGeaiww=;
	b=qd2EiRASGjVEvFB7iIddfjWGQpRXZ5p50xHBBbbGbdK8hsjuE7p6cE511U8gwM8gMRvC1a
	vLfAx7Q/DLl43lCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gWu+TiKB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qd2EiRAS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779565697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SnfQ17bd4JpzK0jLR1WpKHAID2fvow3U96s0QGeaiww=;
	b=gWu+TiKBPI8PwWzn3PRkfwZZc5w/79T3m0sdatGDGtGCl4hcpEnAlsaBsG1wI6tLBhCCfk
	wzlPZaN+gaL7ywoGZIA0Zcn+fy19KY0aqdm5CiZ35AifF1/gzBsUjPhlHDMNhLoFLvrf/N
	GytanmNb91/aDgAqFGE8owWXu3shSRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779565697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SnfQ17bd4JpzK0jLR1WpKHAID2fvow3U96s0QGeaiww=;
	b=qd2EiRASGjVEvFB7iIddfjWGQpRXZ5p50xHBBbbGbdK8hsjuE7p6cE511U8gwM8gMRvC1a
	vLfAx7Q/DLl43lCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 728EA593A8;
	Sat, 23 May 2026 19:48:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z5dxGIAEEmodWQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 23 May 2026 19:48:16 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/3 nf-next] netfilter: synproxy: timestamp adjustment fixes 
Date: Sat, 23 May 2026 21:47:41 +0200
Message-ID: <20260523194743.5888-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: EDA986BAE4
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

This series fixes several long standing issues during synproxy timestamp
adjustment. From ignored error handling to unaligned memory access. Most
of this are not issues impacting real setups as they would have been
reported before.

I targeted nf-next tree as they are fixes for correctness.

Fernando Fernandez Mancera (3):
  netfilter: synproxy: drop packets if timestamp adjustment fails
  netfilter: synproxy: drop packets with duplicated timestamp options
  netfilter: synproxy: fix unaligned memory access in timestamp
    adjustment

 net/netfilter/nf_synproxy_core.c | 47 +++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 19 deletions(-)

-- 
2.53.0

