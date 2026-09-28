Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACE04F7CBF;
	Mon, 28 Sep 2026 19:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623948; cv=none; b=UFHaM0A2XDRbvkwz3fgreII3KL5cRpGrJzzL8pKJMgfVyhpxxP0iA3cxjSsJS7b45lXw1L9yRzz5ByEpZLGZ5SyX7xScUShwPjfvRJnTD1PqO4F+FKTy/US4IbJPeMM1eMzpYJfjEuyxa9z2Bnzm9mks2cW9JblvtPZlUn0ytCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623948; c=relaxed/simple;
	bh=C78ZJCDay44Y1mcIjKzi7uV4gfTSvPlWq7Nu7pl3vio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O046D8ayvzCH2I+QRyS3CTcx9A+TDVUsjcAfWtP6/BOOhkq91pVgF9YNHbhnz02NX06VYKWnUj4B+Lu1s3h4qNzVTbJCXAeoolej/GJtkLIcMCDcdIBmVYYXd13KRtBIqVFVahUzhpthDFFvwdHw0GrSe88X7FOH4t+HaZjiJug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xGxDWWUw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BJY8qN+b; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VH6Go3uQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZPTWIi5Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xGxDWWUw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BJY8qN+b";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VH6Go3uQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZPTWIi5Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B19AB21BA3;
	Mon, 28 Sep 2026 19:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790623940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=xGxDWWUwPjiyrHOxrEj+O6ezAyJkB2XoOzDhY9pStbJrx8Tn24Vd0X2GG7KrGw/v0vVUQz
	PwBDCLZ+i/QfOXy0oVfaFrMqiSCCcZ3aZRN7dfNhrujHanoZqyrDZOp1mCylesDTvcE3sZ
	Kczd5XnuMK/MvSQQljTZqAvBx0KxylE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790623940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=BJY8qN+bJIFgX0L3JxZNMfgN2QEWZ/GIvZsZg4eNIKAXEo/Kelz5u/YZCpsox01cMU0HSk
	Ng/9rZFx4yMc6NAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790623936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=VH6Go3uQQLxPDyUnphRPuLijLajOwy3Mgfccph8wVb/+6vtxz3aUWPyFh3OTAOy1oAfRQm
	OKrc8+3njE6VdWT9BT/RcyPbiLBE+8+MpX7RV1AppDCMjZLw1v9tdTuO4GyWRMLTxYFG9S
	S295khVs/485qzc9rDiTMk1jDKSKke8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790623936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=ZPTWIi5ZvBu8BXpRxbkqgMaB5n6L6JI2VJYFiUwlmpRLz40WwWMhxurOsLQGXCbYuLHiXS
	ptiIPMGMGSLT0IDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C66CD13515;
	Mon, 28 Sep 2026 19:32:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4RBiFn3AumpWOAAAD6G6ig:T13
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 19:32:15 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: horms@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	davem@davemloft.net,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/16 net-next v2] netfilter: ipv4: guard ip_route_me_harder() with CONFIG_IPV4
Date: Mon, 28 Sep 2026 21:30:08 +0200
Message-ID: <20260928193046.6698-13-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260928193046.6698-1-fmancera@suse.de>
References: <20260928193046.6698-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RLrr9ek4ud4f4qwi71m7motjzt)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

To enable compiling the network stack without IPv4, IPv4 specific packet
rerouting logic inside netfilter must be bypassed. Therefore, guard
ip_route_me_harder() with IS_ENABLED(CONFIG_IPV4) so it returns
-EPROTONOSUPPORT when IPv4 is disabled.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/ipv4/netfilter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index ce9e1bfa4259..f2d9e0110b77 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -30,6 +30,9 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 
+	if (!IS_ENABLED(CONFIG_IPV4))
+		return -EPROTONOSUPPORT;
+
 	sk = sk_to_full_sk(sk);
 	flags = sk ? inet_sk_flowi_flags(sk) : 0;
 
-- 
2.55.0

