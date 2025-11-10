Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0919C1487F6
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789408; cv=none; b=r0dhiXoG3ndqn4FfGa8RvPah7mpMToV7ED4Gs2H82+tyy5x8B4v+AfX/O2EIhF44A4VWVEkKzKENoJEhFdUt8Amvg/vFeeZ75go4mxtFEliYL0wmKPXXH2z22ZMcHzwa4XFKR6ox6b/gavNNpUfMujESc33cfYZnlzt3BkELq44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789408; c=relaxed/simple;
	bh=lSSI01bRA3dJRtjfpX7FHuxe1TgWAvUyQhs1w1/ruX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN2RESO8qonTVINeJUvGuuoxc2ahy5E6toxN8BuPSzpd3TNgUzx2tdD3uC+S/zudwnB9gntjdI/iTBREXRWFCemrEqBHTRMJVPQs1ra8+pZIUMbltt6fsq5Hfb5FrC5sNje7cvnoNfQallT7MGnfM5HweSN3VjvtAWG3QSFTAlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ixGHsHzw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZyDWJr95; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ixGHsHzw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZyDWJr95; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ixGHsHzw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZyDWJr95";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ixGHsHzw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZyDWJr95"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3063F2213C;
	Mon, 10 Nov 2025 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qk1f5ZLmhgM4QBGV0PY9gA+OndO4nLdNAuoECHDOVWQ=;
	b=ixGHsHzwQuKor749kJQbF1Ra5aAwovTpf4fH4ZMBB0Fu4ZSZ17SEQcS4UfFlCarcvOR9zk
	woKpHyPdUCWz5aHhNr9b4gh46TYsR1o4J2kYvldEww5ifk7WUZzAK+tvh3NNr63T885IdX
	Ufx4sE+hj0+fZpcQS0an5mUzrTzgFao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qk1f5ZLmhgM4QBGV0PY9gA+OndO4nLdNAuoECHDOVWQ=;
	b=ZyDWJr95ZJD3o/nsjHcFLxPuAgMMdsCR56R+oyY7J6Sj2xEkCIhd7wID7TVfz0L46Xgpok
	L6MLSy6xyCpbsOAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762789405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qk1f5ZLmhgM4QBGV0PY9gA+OndO4nLdNAuoECHDOVWQ=;
	b=ixGHsHzwQuKor749kJQbF1Ra5aAwovTpf4fH4ZMBB0Fu4ZSZ17SEQcS4UfFlCarcvOR9zk
	woKpHyPdUCWz5aHhNr9b4gh46TYsR1o4J2kYvldEww5ifk7WUZzAK+tvh3NNr63T885IdX
	Ufx4sE+hj0+fZpcQS0an5mUzrTzgFao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762789405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qk1f5ZLmhgM4QBGV0PY9gA+OndO4nLdNAuoECHDOVWQ=;
	b=ZyDWJr95ZJD3o/nsjHcFLxPuAgMMdsCR56R+oyY7J6Sj2xEkCIhd7wID7TVfz0L46Xgpok
	L6MLSy6xyCpbsOAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1FB114480;
	Mon, 10 Nov 2025 15:43:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gPu+JBwIEmkWWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 15:43:24 +0000
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
Subject: [PATCH 1/4 nf-next v2] netfilter: conntrack: add nf_ct_get_or_find() helper
Date: Mon, 10 Nov 2025 16:42:46 +0100
Message-ID: <20251110154249.3586-2-fmancera@suse.de>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

Introduce a helper function which tries to get a ct, if it is a
template, then the tuple pointer from the skb and perform a lookup to
find the actual ct.

A refcounted bool parameter must be passed in order to know if the
caller need to call nf_ct_put() after it is done using the ct.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: added this commit to the series
---
 include/net/netfilter/nf_conntrack.h |  3 +++
 net/netfilter/nf_conntrack_core.c    | 35 ++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index aa0a7c82199e..5a0dd5715122 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -201,6 +201,9 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num, struct net *net,
 		       struct nf_conntrack_tuple *tuple);
 
+struct nf_conn *nf_ct_get_or_find(struct net *net, const struct sk_buff *skb,
+				  u16 l3num, bool *refcounted);
+
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  u32 extra_jiffies, unsigned int bytes);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0b95f226f211..3ef152a378cc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -428,6 +428,41 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_tuplepr);
 
+struct nf_conn *
+nf_ct_get_or_find(struct net *net, const struct sk_buff *skb, u16 l3num,
+		  bool *refcounted)
+{
+	const struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct))
+		return ct;
+
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), l3num, net, &tuple))
+		return NULL;
+
+	if (ct)
+		zone = nf_ct_zone(ct);
+	else
+		zone = &nf_ct_zone_dflt;
+
+	h = nf_conntrack_find_get(net, zone, &tuple);
+	if (!h)
+		return NULL;
+
+	ct = nf_ct_tuplehash_to_ctrack(h);
+
+	/* refcount increased, nf_ct_put() is needed after done with it */
+	*refcounted = true;
+
+	return ct;
+}
+EXPORT_SYMBOL_GPL(nf_ct_get_or_find);
+
 bool
 nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 		   const struct nf_conntrack_tuple *orig)
-- 
2.51.0

