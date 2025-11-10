Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C172FD678
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789424; cv=none; b=WGQvAGLGhFBAVDSWi4uv1gt8DGs5Tf35B3hqsNyK/dP0wL4H4NjpbkmkYmQNIGgK31yIo4A+66/dty3CIO44FrbKMBN/7DHgSFMCcF/T6CGa4mey/SL8/SLNd/Jr8Qqmmw4srhonrCs51e0BdqmQT+VILa7/cbSFv2AZe5XJ2Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789424; c=relaxed/simple;
	bh=QLJKi0vlHvcPu/12gYvTXELFrPDP2230cttVZlOo7nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P41igM/f6zVPCcXlQdXCMJO3qSDIyJ+Fhq7IMsdwz7ZU42siuzzHh8UV9FQhslgNvX3v8BLdlj+T0e+SRRep35eE94RzwHrcXXIjgbFZf5HOTFqxRi0qbkdy/kWXzzAQox0x94k5PygJ7tOLc90wr914x5oNhR+kKQ0RaW3a+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZxqJGXHN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gloXsMkJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZxqJGXHN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gloXsMkJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZxqJGXHN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gloXsMkJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZxqJGXHN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gloXsMkJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A57191F44E;
	Mon, 10 Nov 2025 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gz9T2Z8IA/FPV6HK0LfEs9zDSyTaH7d8ZTVxgrndJ6Q=;
	b=ZxqJGXHNwv1rYlA0ZGHGl9MWZiUwPMpjr+IK67qBPOrCwWQsnpJcv5i5B8K+Tqpt7UYctq
	5F8fIJLwiYUdjS9p3NPz7PlmjLSybD63GRhDtwu5YizECwP7O/GINvYjChWMEuPiXtn+dq
	E92LeBpczRLWoT+oLy5jlDxfK1gJl+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gz9T2Z8IA/FPV6HK0LfEs9zDSyTaH7d8ZTVxgrndJ6Q=;
	b=gloXsMkJrLyZZUbe4sU7gUAbQzIuK2l+XaLtsIWVIohGOUVAK+GLw8toSh0pVEL6cnmWxc
	Zuh2RXd19gMvsKAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gz9T2Z8IA/FPV6HK0LfEs9zDSyTaH7d8ZTVxgrndJ6Q=;
	b=ZxqJGXHNwv1rYlA0ZGHGl9MWZiUwPMpjr+IK67qBPOrCwWQsnpJcv5i5B8K+Tqpt7UYctq
	5F8fIJLwiYUdjS9p3NPz7PlmjLSybD63GRhDtwu5YizECwP7O/GINvYjChWMEuPiXtn+dq
	E92LeBpczRLWoT+oLy5jlDxfK1gJl+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gz9T2Z8IA/FPV6HK0LfEs9zDSyTaH7d8ZTVxgrndJ6Q=;
	b=gloXsMkJrLyZZUbe4sU7gUAbQzIuK2l+XaLtsIWVIohGOUVAK+GLw8toSh0pVEL6cnmWxc
	Zuh2RXd19gMvsKAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2184714480;
	Mon, 10 Nov 2025 15:43:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uB1cBSsIEmkWWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 15:43:39 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	aconole@redhat.com,
	echaudro@redhat.com,
	i.maximets@ovn.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/4 nf-next v2] netfilter: nft_connlimit: update connection list if add was skipped
Date: Mon, 10 Nov 2025 16:42:49 +0100
Message-ID: <20251110154249.3586-5-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110154249.3586-1-fmancera@suse.de>
References: <20251110154249.3586-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLt5hdgqk6xitctmbg8wz1bcat)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
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
v2: no changes done
---
 net/netfilter/nft_connlimit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index ecb65da113d6..9e029397387a 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -37,7 +37,14 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
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
 			if (refcounted)
 				nf_ct_put(ct);
 			regs->verdict.code = NF_DROP;
-- 
2.51.0

