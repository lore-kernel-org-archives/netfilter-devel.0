Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DF3C3795
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 21:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832740; cv=none; b=e0nhObatmOC8HfOK6qg7L1MGp3EaqdrPvWmf+90UCCVFZRtulBoQs19DE6D68OA81vs12YiIc+uptJcEO2sPy/peQlz2OauoBChD2xbf5O7BytjCxNCO6Ni7Y3sQsqKhLeQb3r7VL927m5Be5AWUqB53fqWd0okXTgiMLPVJmm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832740; c=relaxed/simple;
	bh=ZUpuFHls/T9Gh9Zh26PorcVLF+8xBBl6/e+hOLFg/Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/5HSj4gSKqQ1MUJSTTG41nRYMEjlBPSKsJvEp2IMbCMdCARZK6v7M3jttfv7O65N4+TjFOeLv9uNMRljtgaPFret+33Owe242qjL4hcL5L02LAUnoI/E6r0w3uoibRjDAK7mCagLecIR7cl8xc8G6h7dfqiTXiNY+IawbusSH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rOFin4Xi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mC3UCXO4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rOFin4Xi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mC3UCXO4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rOFin4Xi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mC3UCXO4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rOFin4Xi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mC3UCXO4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2034659A2;
	Tue, 26 May 2026 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZTWUPptDCMpMnnhXCUuFhf/TKaB0px0fG4Rv24pSkA=;
	b=rOFin4XiBKL5Ql4VQtfzA01M/SiJ4g0CY5YORvr0FLn32fW1kf/v3ZSPtXlRcZTXVDLKdK
	l9lNMUo46NlgEI0oK48fsv3Xi/vZKd2c9QwOxupR7SaMy6Lscwy2UBK6Q/VnPEZa+8pOfA
	NFsxYbbTw4x7ZUKBOWY0r9vEn3ansDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZTWUPptDCMpMnnhXCUuFhf/TKaB0px0fG4Rv24pSkA=;
	b=mC3UCXO4eaKPbDYcGMsM/us0DODXPxMzmTVoHqsx+6eDDjaMTZ3QHMHlnh9kdkQzY2GqEc
	kHs0krkwAJYmhrBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779832733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZTWUPptDCMpMnnhXCUuFhf/TKaB0px0fG4Rv24pSkA=;
	b=rOFin4XiBKL5Ql4VQtfzA01M/SiJ4g0CY5YORvr0FLn32fW1kf/v3ZSPtXlRcZTXVDLKdK
	l9lNMUo46NlgEI0oK48fsv3Xi/vZKd2c9QwOxupR7SaMy6Lscwy2UBK6Q/VnPEZa+8pOfA
	NFsxYbbTw4x7ZUKBOWY0r9vEn3ansDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779832733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TZTWUPptDCMpMnnhXCUuFhf/TKaB0px0fG4Rv24pSkA=;
	b=mC3UCXO4eaKPbDYcGMsM/us0DODXPxMzmTVoHqsx+6eDDjaMTZ3QHMHlnh9kdkQzY2GqEc
	kHs0krkwAJYmhrBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C5675A419;
	Tue, 26 May 2026 21:58:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gK+KE50XFmrTZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 26 May 2026 21:58:53 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 5/5 nf-next v4] netfilter: synproxy: add mutex to guard hook reference counting
Date: Tue, 26 May 2026 23:58:31 +0200
Message-ID: <20260526215831.6726-6-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260526215831.6726-1-fmancera@suse.de>
References: <20260526215831.6726-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_RATELIMIT(0.00)[to_ip_from(RLt5hdgqk6xitctmbg8wz1bcat)];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[]

As the synproxy infrastructure register netfilter hooks on-demand when a
user adds the first iptables target or nftables expression, if done
concurrently they can race each other.

Introduce a mutex to serialize the refcount control blocks access from
both frontends. While a per namespace mutex might be more efficient, it
is not needed for target/expression like SYNPROXY.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nf_synproxy_core.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 5413133a42fa..47fe218a112f 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -22,6 +22,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_synproxy.h>
 
+static DEFINE_MUTEX(synproxy_mutex);
+
 unsigned int synproxy_net_id;
 EXPORT_SYMBOL_GPL(synproxy_net_id);
 
@@ -767,26 +769,31 @@ static const struct nf_hook_ops ipv4_synproxy_ops[] = {
 
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref4 == 0) {
 		err = nf_register_net_hooks(net, ipv4_synproxy_ops,
 					    ARRAY_SIZE(ipv4_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref4++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
 
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref4--;
 	if (snet->hook_ref4 == 0)
 		nf_unregister_net_hooks(net, ipv4_synproxy_ops,
 					ARRAY_SIZE(ipv4_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_fini);
 
@@ -1193,27 +1200,32 @@ static const struct nf_hook_ops ipv6_synproxy_ops[] = {
 int
 nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref6 == 0) {
 		err = nf_register_net_hooks(net, ipv6_synproxy_ops,
 					    ARRAY_SIZE(ipv6_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref6++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
 void
 nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref6--;
 	if (snet->hook_ref6 == 0)
 		nf_unregister_net_hooks(net, ipv6_synproxy_ops,
 					ARRAY_SIZE(ipv6_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
 #endif /* CONFIG_IPV6 */
-- 
2.53.0

