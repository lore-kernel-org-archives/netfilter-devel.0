Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795800034;
	b=1wKAMs2bFP73x4AOwAnzFhUshqPbO2Zop9LMGsBcETQsQ3zP7dV9E43RskfKEZcFhJ8a
	 9r3uceBJbXoX3FyRf5N2p9QKgIis01Ur+arE3euNU/a1PKGB56XHyAB3hz3QYaDPvHJkE
	 8WShrPP3zqPBt/vZ4GuqTTr/82u4USiWO4r257jJdtgcVjc1CzPebfxWpl8ZPQulOnCuM
	 tysfUJvLp3vGBnnG+QvOjLKuULAZyu3PqeoLKjuCeIpyeV/IS0LL6YxQuP282Dwd8dqF0
	 HHvdT9Piv1cs0+8IbqEBvC4r9ayJ07r1rBQklEvFVIMmmAtVFmc4jQZRqiTtF6MgyUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795800034;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=PG/5uCMCGDfimcyaOp1sPo3+8vLP+7N2c/96Q2ESu1M=;
	b=DHyrtd2pEYQ3rv2aqpj3VXcKs1RMQqQjUyrXhI0zVO9Fpb11FXhHbW9zzuJys6Y3KJw8
	 D4Dxw7ixzeWx1FrOpcjZUKlXL9fKSSiLuD1bdvF88FiWew1pBohV24R815oZtp4+KZXUG
	 W1xYEhkhuNUOrIOaT6KVvwGtEstG6PNr2ny1o1/opISrg1R++c85nPAqUWlmFaLnbt+M0
	 fGqp+0o6kvkTvCquU6r1mEtLuIqfeuvVB1f2HLXuHnSzXpJo7+OPeaN/Zp9b+SY1gXwqv
	 LUt1bPzG1VKRpO5+wTo2jGDznNiZSNPU3zuIls8KI/PPajAh8xly/c0/0cVxCaVQnIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V5ICeA4O;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PBUzWX2R;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V5ICeA4O;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PBUzWX2R;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C7D606A332;
	Fri, 27 Nov 2026 17:20:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4C7D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V5ICeA4O;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PBUzWX2R;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V5ICeA4O;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PBUzWX2R
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0AEC22217B;
	Fri, 27 Nov 2026 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795800032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PG/5uCMCGDfimcyaOp1sPo3+8vLP+7N2c/96Q2ESu1M=;
	b=V5ICeA4O+hsBSM+Ol+rLH1dWctu40hujySccewUHZVQP+aJKeDJyf+dFJ8N63iuxua6ZXG
	HPXp4+b+PLlRXUPpl1YQzjBOj0rRpC5mJc0MN5EwU9aVgLt4tLzvQn1a8+RDNRMJaPwrJ3
	qDqA6ylqCysBLowxsJtV5LZgBqemvpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795800032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PG/5uCMCGDfimcyaOp1sPo3+8vLP+7N2c/96Q2ESu1M=;
	b=PBUzWX2Rc+Li6MCNJS6yOurufiY2M7Gm4S9wy9Mtnw3kp4WZNIhmz60LVUqW7NYlM2E3yP
	m711LvfJs5qSXYAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795800032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PG/5uCMCGDfimcyaOp1sPo3+8vLP+7N2c/96Q2ESu1M=;
	b=V5ICeA4O+hsBSM+Ol+rLH1dWctu40hujySccewUHZVQP+aJKeDJyf+dFJ8N63iuxua6ZXG
	HPXp4+b+PLlRXUPpl1YQzjBOj0rRpC5mJc0MN5EwU9aVgLt4tLzvQn1a8+RDNRMJaPwrJ3
	qDqA6ylqCysBLowxsJtV5LZgBqemvpg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795800032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PG/5uCMCGDfimcyaOp1sPo3+8vLP+7N2c/96Q2ESu1M=;
	b=PBUzWX2Rc+Li6MCNJS6yOurufiY2M7Gm4S9wy9Mtnw3kp4WZNIhmz60LVUqW7NYlM2E3yP
	m711LvfJs5qSXYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34F1A13432;
	Fri, 27 Nov 2026 17:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Yb1MH67CWuMAwAAD6G6ig:T13
	(envelope-from <fmancera@suse.de>); Fri, 27 Nov 2026 17:20:31 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Willem de Bruijn <willemb@google.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next v4 12/16] netfilter: ipv4: guard ip_route_me_harder() with CONFIG_IPV4
Date: Fri, 27 Nov 2026 18:17:57 +0100
Message-ID: <20261127171824.27362-13-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261127171824.27362-1-fmancera@suse.de>
References: <20261127171824.27362-1-fmancera@suse.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -15.80
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
2.56.1

