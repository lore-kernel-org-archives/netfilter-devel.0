Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF2023D281
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762390612; cv=none; b=CwJXObt8scokyhCO7okKvD9yS2EvOrrE4QKtvy6OR+rDE4ik3XRFvqGzeSoL2DRhjh7/xz2+8UaZ0XMHi/JuWVQ4kes6OWmMn9rfsLSqSQn1AvE+5LdkdUEGBu69v7TVCvtWqMid5YskabX4A2MTitnX2XHvuWD+0UC5Qjg022k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762390612; c=relaxed/simple;
	bh=qNBsPG1WMdnpNVMNETSwQCTjrBVV7oPaq2/OHtga6M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICznIR8OhD6Zm0fdp54fAYYxDyjbUeMkhC9T/1OCs5bNimy4u6wcLkN56wNdg/kNdUbLu9MbNx165j9mnZgdEQ9t3lRgg9k6Go4umBPmXsgzvcdXrU4x8iJuwSFGxuYqaRMFHpE9zikGWBx8AUdHcFjq3qKlBjnvjN3ZTZ68wSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QQDjSPD9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=shhNWNx8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QQDjSPD9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=shhNWNx8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QQDjSPD9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="shhNWNx8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QQDjSPD9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="shhNWNx8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 56A89211C8;
	Thu,  6 Nov 2025 00:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762390602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnbLnJjJCDUVDR6lfzw9D9bHo7UgIsp5wR5jzg6+g/0=;
	b=QQDjSPD9eQiMtE7STEYnzRBx3wOBKhIYPnhu65NfC4RRz5yzf1hA5r21KVOo3QbEb9CoDX
	BIA6VHxsoq0bByCZkQdWzSCItOIkgyRZ0ZLhMf1kbUbnx3JCgbwB2w3oMhyA1Ywihs8dUG
	DBrOzFZGImy/opOsnO5TzGIfK1F0HqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762390602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnbLnJjJCDUVDR6lfzw9D9bHo7UgIsp5wR5jzg6+g/0=;
	b=shhNWNx8VnNIxwmRCY3s6etn6/gQNPkRWfSXm+DlmLQd6a6oXz1f9LH0DR1npzPZk8iLxN
	vRMHBdFsuHvZgADA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762390602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnbLnJjJCDUVDR6lfzw9D9bHo7UgIsp5wR5jzg6+g/0=;
	b=QQDjSPD9eQiMtE7STEYnzRBx3wOBKhIYPnhu65NfC4RRz5yzf1hA5r21KVOo3QbEb9CoDX
	BIA6VHxsoq0bByCZkQdWzSCItOIkgyRZ0ZLhMf1kbUbnx3JCgbwB2w3oMhyA1Ywihs8dUG
	DBrOzFZGImy/opOsnO5TzGIfK1F0HqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762390602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnbLnJjJCDUVDR6lfzw9D9bHo7UgIsp5wR5jzg6+g/0=;
	b=shhNWNx8VnNIxwmRCY3s6etn6/gQNPkRWfSXm+DlmLQd6a6oXz1f9LH0DR1npzPZk8iLxN
	vRMHBdFsuHvZgADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC28C132DD;
	Thu,  6 Nov 2025 00:56:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iHwlK0nyC2mNLAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Nov 2025 00:56:41 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	dev@openvswitch.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/3 nf-next] netfilter: nft_connlimit: update connection list if add was skipped
Date: Thu,  6 Nov 2025 01:55:57 +0100
Message-ID: <20251106005557.3849-4-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251106005557.3849-1-fmancera@suse.de>
References: <20251106005557.3849-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

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

To solve this problem, check whether the connection was skipped and if
so, update the list. This fix isn't necessary on xt_connlimit as the new
nf_conncount API updates the list when the add is skipped inside
nf_conncount_count().

Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/netfilter/nft_connlimit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 3c1d9ae37bec..4cec228e82e2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -49,7 +49,14 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	err = nf_conncount_add(ct, priv->list);
 	if (err) {
-		if (err != -EINVAL) {
+		if (err == -EINVAL) {
+			/* Call gc to update the list count if any connection has
+			 * been closed already. This is useful to softlimit
+			 * connections like limiting bandwidth based on a number
+			 * of open connections.
+			 */
+			nf_conncount_gc_list(nf_ct_net(ct), priv->list);
+		} else {
 			regs->verdict.code = NF_DROP;
 			return;
 		}
-- 
2.51.0

