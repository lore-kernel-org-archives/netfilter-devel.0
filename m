Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6584FB9AF;
	Wed, 30 Sep 2026 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776516; cv=none; b=A7+EcbFBxBVpWvNkXLzTf0BHg5X0R+QF/1atnMN4GYrtkl6WeOcmixRxhKTdfTZfY618fyn/FTl0OOAI6WTWhGe66lZv/dL0pbAP4tzrVCMV2HyVIMQ8KCZ5rICGBrtLNn1F+0ydl30eKjCqCGJOeaFNXgpXChjEyggPst5RC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776516; c=relaxed/simple;
	bh=C78ZJCDay44Y1mcIjKzi7uV4gfTSvPlWq7Nu7pl3vio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkEB5CKaBH3Oh1az/C+Vq/eBgsCMXzklG7371bEush9RTnhl+LPBoVacRSLQsSwEk1q/yXTgtHSkDHPlz6R8En23O+vekk/ubpKcDSNxUmb9eIVBRZIjsxiPUAN9cBf+ov9OwRsqfLwRx8i/vJu3aW77gMw/V7Vw5TCR8GiUA7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PoR6S9PN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zI84EbZe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MHO+Cm94; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w9TlBg29; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PoR6S9PN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zI84EbZe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MHO+Cm94";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w9TlBg29"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D3F721E6D;
	Wed, 30 Sep 2026 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790776489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=PoR6S9PN7ZCM41uuxv32lp6L06FVgLUNaNdu9NnqOrSP/O9egeYSvPJyVOfA73eRnS2M+b
	00m3Tn67CZK+3c2aF/EeAssuv0yBjcqnYv1QPgvKfbAhIBr9LXyEUz6EHCTDBeRo1oIdhD
	JoHVZktzR56IaOThAtWPmtnXjeaQi+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790776489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=zI84EbZeFhB2Co38LcW9KG2CDHrZxlThVH3rCh5Y8516tnfx5vzA5x/YhKU1qPVrf3A13k
	c6l8uPMEmpgZ+ACA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790776485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=MHO+Cm94vCS584WUzOWtKIKC9ic0jqKsXoH3coBPFzT0ZTbXgMoZSvfbbFjQ7yRlT8uVld
	FwxTZtlG75EYh53+b0a2J26mQnjkx8/TXDGJtlz9voPzKBqDDyTEJrnyj8nbrHYZ+M2c7k
	Ilx7u3+D/RQYdF/6YlcvitGEEy5jbV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790776485;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0mWjLFQLODU1IvdgCAApYjei1qDVLuiRY3G8VyvqOO4=;
	b=w9TlBg297zIjl45UDvq7rvLgE7+w1H7audNZH3UeVqGE0TpoB5nwc64v1MabgS1qkM+YzY
	WAtlODd7IyTBIGCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E25513722;
	Wed, 30 Sep 2026 13:54:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fJXpHGIUvWqUTwAAD6G6ig:T13
	(envelope-from <fmancera@suse.de>); Wed, 30 Sep 2026 13:54:44 +0000
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
Subject: [PATCH 12/16 net-next v3] netfilter: ipv4: guard ip_route_me_harder() with CONFIG_IPV4
Date: Wed, 30 Sep 2026 15:52:55 +0200
Message-ID: <20260930135334.4739-13-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260930135334.4739-1-fmancera@suse.de>
References: <20260930135334.4739-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.76 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.16)[-0.811];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLrr9ek4ud4f4qwi71m7motjzt)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.76
X-Spam-Level: 
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

