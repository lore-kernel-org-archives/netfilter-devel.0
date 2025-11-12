Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D936F3148B5
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947912; cv=none; b=U/s1IEldrqYmIN06iC47fMBT04NwR9N5Rz67mAdKhkA6k8qpcJDq33j9qOyWYAlSmB65Tnje4L/xmZ+Ljc7QN7hYlOGda6cWmpRoq3nOW9njslgXc09c3rtu/V1TdLeJ5aEQcfV7tn0kJDKLwUHaafwqgjQvQNLMELT3YYmeKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947912; c=relaxed/simple;
	bh=c/pnxcW952hI+iOdKLDDPWcirAUj5+uvSC6ALQ6lJv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdGXS5epkX/k84aqGutFV+bGx2zTLimcIXj585aVrlzFXzk2o9RAYqONsLOgQ0Z1S+tLJoNGc5WgLY4S3LBwEHbnj2g/udohqRPWMrUQ//eMuK+bd6dp2Bkgrc58GIqN/qvlRbwzMt7iQ4C35bP7hBaUKtkMvM7q6NQpiM8WLUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZYS/IcGb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T0VS5i6t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OdtjkJsL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r9Npk14x; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZYS/IcGb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T0VS5i6t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OdtjkJsL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r9Npk14x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED3F61F44F;
	Wed, 12 Nov 2025 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8zzJv4MSHMPPUb5UKWhPV4oxRGzGJJvU0aqalX1DKM=;
	b=ZYS/IcGbi3H8nJ4zZLwuuK7rTUBmky09DauDn8giOKuLuYYboNqhQWcI2rN+CEcflqfrlc
	OzR5dhHuOF00dksRVlzNBApYxmz0DoD06MA43ETfZ3nv01jfKFMlADO6RZsjehfIWlj5wM
	P1Q8y+oAxavwRMHWJlziaHdtdhnT5bo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8zzJv4MSHMPPUb5UKWhPV4oxRGzGJJvU0aqalX1DKM=;
	b=T0VS5i6tVrTyFR8Z32Ipk80U9b0jhOu5SN+yyWgq24J0Mjf1C0DUpLqps53ffnAtvmpO0N
	yvv5tC+wKIhT6rCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762947908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8zzJv4MSHMPPUb5UKWhPV4oxRGzGJJvU0aqalX1DKM=;
	b=OdtjkJsLeorA/CEZv0z9BPJkwfzXxQODaf2Y5sTK71rI24pHcpwWxKq8e5VSbEq/QDnky8
	zWktsddqz2gS5eaGH9PkcFJ3zGloBhLGsap+P6K9cv5bTfXlhFszzTHjLKE45ul6A/Ulty
	RG4t4QaoSNrk42BktHsyiw7oSjIUVNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762947908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8zzJv4MSHMPPUb5UKWhPV4oxRGzGJJvU0aqalX1DKM=;
	b=r9Npk14x4zI1nRED0gVnlLPRYbTAVsiAJj94enu15eLyLBc+RiQQTII2nGXo3Cl/jRlxB/
	M7vueO4zbAtv6WCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 610803EA61;
	Wed, 12 Nov 2025 11:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eBm5FERzFGmvCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 12 Nov 2025 11:45:08 +0000
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
Subject: [PATCH 1/6 nf-next v3] netfilter: nf_conncount: introduce new nf_conncount_count_skb() API
Date: Wed, 12 Nov 2025 12:43:47 +0100
Message-ID: <20251112114351.3273-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251112114351.3273-2-fmancera@suse.de>
References: <20251112114351.3273-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80

This API allows the caller to pass directly an sk_buff struct. It
fetches the tuple and zone and the corresponding ct from it and performs
a count_tree() operation.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_conntrack_count.h |  6 +++
 net/netfilter/nf_conncount.c               | 48 ++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 1b58b5b91ff6..706b5a82386e 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -24,6 +24,12 @@ unsigned int nf_conncount_count(struct net *net,
 				const struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_zone *zone);
 
+unsigned int nf_conncount_count_skb(struct net *net,
+				    const struct sk_buff *skb,
+				    u16 l3num,
+				    struct nf_conncount_data *data,
+				    const u32 *key);
+
 int nf_conncount_add(struct net *net, struct nf_conncount_list *list,
 		     const struct nf_conntrack_tuple *tuple,
 		     const struct nf_conntrack_zone *zone);
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 913ede2f57f9..cf5ed5c6bfba 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -524,6 +524,54 @@ unsigned int nf_conncount_count(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_conncount_count);
 
+/* Count and return number of conntrack entries in 'net' with particular 'key'.
+ * If 'skb' is not null, insert the corresponding tuple into the accounting
+ * data structure. Call with RCU read lock.
+ */
+unsigned int nf_conncount_count_skb(struct net *net,
+				    const struct sk_buff *skb,
+				    u16 l3num,
+				    struct nf_conncount_data *data,
+				    const u32 *key)
+{
+	const struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_info ctinfo;
+	unsigned int connections;
+	struct nf_conn *ct;
+
+	if (!skb)
+		return count_tree(net, data, key, NULL, NULL);
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct))
+		return count_tree(net, data, key,
+				  &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				  nf_ct_zone(ct));
+
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), l3num, net, &tuple))
+		return 0;
+
+	if (ct)
+		zone = nf_ct_zone(ct);
+	else
+		zone = &nf_ct_zone_dflt;
+
+	h = nf_conntrack_find_get(net, zone, &tuple);
+	if (!h)
+		return count_tree(net, data, key, &tuple, zone);
+
+	ct = nf_ct_tuplehash_to_ctrack(h);
+	connections = count_tree(net, data, key,
+				 &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				 zone);
+	nf_ct_put(ct);
+
+	return connections;
+}
+EXPORT_SYMBOL_GPL(nf_conncount_count_skb);
+
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
 	struct nf_conncount_data *data;
-- 
2.51.0

