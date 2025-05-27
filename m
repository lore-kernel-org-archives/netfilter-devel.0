Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD402882B4
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748374504; cv=none; b=gE13POjZBrN6BIJ/VFGj+mghKeDM0TaffAflseIZ27NCbALrgOKT0jkZH5QnAxkS3U3cxM5tr8jy6s4OeQ1A3Kt3Wrk6t2NrQb58NdHYTmgngfPW1o8f9K7VdE4g7jxjsGDyD1ZHb/uQ9VabxzDe7XTclz3QwiFYXOlAq0BZH/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748374504; c=relaxed/simple;
	bh=2oUU6SMV/nd/SUnQb4Ycxb+kK9cD4WpD5V5Gp+7Dvyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Id2Oi9git6EWoHlIKW+puLPycfB6jtLfIAv2vrqliysWwq/oTfPBF/u3cVES14ybfBEZXHQ7l5sIVdqOhlcJHsvU8DDjbNwsBwLKFlh/PM1amJsDp1jP6pj62g3qSK0626YtURBXBIhNPJxxKf7CzJuQvSR7H2PxPzrUpxThsVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eJV2Xh/3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3bS8frbj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eJV2Xh/3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3bS8frbj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eJV2Xh/3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3bS8frbj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eJV2Xh/3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3bS8frbj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AAAC1F399;
	Tue, 27 May 2025 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748374500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xgP/nIsAIQI6ysMq13wgW4zpooNqol7Gjxreb7JnsSU=;
	b=eJV2Xh/3ZDnlByxDEyJnL44tRNMVe15dLv+i/j7h3uLLOXD+4AUlADFWOERolUqSgscVmC
	BC+64UyfstydAPoL6VVr8l3uHzWaecKZhScoDrWG0/krf66aQ6TzxsTMG9VPWBki5lQPAj
	r65NIb3i+7FJ1Uyr3NRbD6aJI01kQlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748374500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xgP/nIsAIQI6ysMq13wgW4zpooNqol7Gjxreb7JnsSU=;
	b=3bS8frbjGpd86UOH7Wjr1cXFr6AhMmJQ3a09HkPefFYC4WxQrx6Uf139L/tLSi0eBHQ9TF
	Kdw2wj5otHXjSCCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748374500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xgP/nIsAIQI6ysMq13wgW4zpooNqol7Gjxreb7JnsSU=;
	b=eJV2Xh/3ZDnlByxDEyJnL44tRNMVe15dLv+i/j7h3uLLOXD+4AUlADFWOERolUqSgscVmC
	BC+64UyfstydAPoL6VVr8l3uHzWaecKZhScoDrWG0/krf66aQ6TzxsTMG9VPWBki5lQPAj
	r65NIb3i+7FJ1Uyr3NRbD6aJI01kQlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748374500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xgP/nIsAIQI6ysMq13wgW4zpooNqol7Gjxreb7JnsSU=;
	b=3bS8frbjGpd86UOH7Wjr1cXFr6AhMmJQ3a09HkPefFYC4WxQrx6Uf139L/tLSi0eBHQ9TF
	Kdw2wj5otHXjSCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 009AD1388B;
	Tue, 27 May 2025 19:34:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8QysOOMTNmg8FQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:34:59 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 libnftnl v2] src: use uint64_t for flags fields
Date: Tue, 27 May 2025 21:34:19 +0200
Message-ID: <20250527193420.9860-1-fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The flags for the object tunnel already reach out 31, therefore, in
order to be able to extend the flags field must be uint64_t. Otherwise,
we will shift by more of the type size.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/obj.h   |  2 +-
 include/rule.h  |  2 +-
 include/set.h   |  2 +-
 include/utils.h |  2 +-
 src/chain.c     |  2 +-
 src/flowtable.c |  2 +-
 src/object.c    | 10 +++++-----
 src/table.c     |  2 +-
 src/utils.c     |  2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/obj.h b/include/obj.h
index d217737..fc78e2a 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -19,7 +19,7 @@ struct nftnl_obj {
 	uint32_t		family;
 	uint32_t		use;
 
-	uint32_t		flags;
+	uint64_t		flags;
 	uint64_t		handle;
 
 	struct {
diff --git a/include/rule.h b/include/rule.h
index 036c722..6432786 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -4,7 +4,7 @@
 struct nftnl_rule {
 	struct list_head head;
 
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	family;
 	const char	*table;
 	const char	*chain;
diff --git a/include/set.h b/include/set.h
index 55018b6..179f6ad 100644
--- a/include/set.h
+++ b/include/set.h
@@ -30,7 +30,7 @@ struct nftnl_set {
 	} desc;
 	struct list_head	element_list;
 
-	uint32_t		flags;
+	uint64_t		flags;
 	uint32_t		gc_interval;
 	uint64_t		timeout;
 	struct list_head	expr_list;
diff --git a/include/utils.h b/include/utils.h
index eed6127..5da2ddb 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -79,7 +79,7 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 			  	     uint32_t cmd, uint32_t type,
 				     uint32_t flags));
 
-int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+int nftnl_set_str_attr(const char **dptr, uint64_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
 #endif
diff --git a/src/chain.c b/src/chain.c
index 895108c..a9e18dc 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -43,7 +43,7 @@ struct nftnl_chain {
 	uint64_t	packets;
 	uint64_t	bytes;
 	uint64_t	handle;
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	chain_id;
 
 	struct {
diff --git a/src/flowtable.c b/src/flowtable.c
index fbbe0a8..c52ba0e 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -29,7 +29,7 @@ struct nftnl_flowtable {
 	struct nftnl_str_array	dev_array;
 	uint32_t		ft_flags;
 	uint32_t		use;
-	uint32_t		flags;
+	uint64_t		flags;
 	uint64_t		handle;
 };
 
diff --git a/src/object.c b/src/object.c
index bfcceb9..f307815 100644
--- a/src/object.c
+++ b/src/object.c
@@ -62,13 +62,13 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 EXPORT_SYMBOL(nftnl_obj_is_set);
 bool nftnl_obj_is_set(const struct nftnl_obj *obj, uint16_t attr)
 {
-	return obj->flags & (1 << attr);
+	return obj->flags & (1ULL << attr);
 }
 
 EXPORT_SYMBOL(nftnl_obj_unset);
 void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 {
-	if (!(obj->flags & (1 << attr)))
+	if (!(obj->flags & (1ULL << attr)))
 		return;
 
 	switch (attr) {
@@ -90,7 +90,7 @@ void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 		break;
 	}
 
-	obj->flags &= ~(1 << attr);
+	obj->flags &= ~(1ULL << attr);
 }
 
 static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
@@ -153,7 +153,7 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		if (obj->ops->set(obj, attr, data, data_len) < 0)
 			return -1;
 	}
-	obj->flags |= (1 << attr);
+	obj->flags |= (1ULL << attr);
 	return 0;
 }
 
@@ -197,7 +197,7 @@ EXPORT_SYMBOL(nftnl_obj_get_data);
 const void *nftnl_obj_get_data(const struct nftnl_obj *obj, uint16_t attr,
 			       uint32_t *data_len)
 {
-	if (!(obj->flags & (1 << attr)))
+	if (!(obj->flags & (1ULL << attr)))
 		return NULL;
 
 	switch(attr) {
diff --git a/src/table.c b/src/table.c
index 9870dca..e183e2e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -29,7 +29,7 @@ struct nftnl_table {
 	uint32_t	table_flags;
 	uint64_t 	handle;
 	uint32_t	use;
-	uint32_t	flags;
+	uint64_t	flags;
 	uint32_t	owner;
 	struct {
 		void		*data;
diff --git a/src/utils.c b/src/utils.c
index 5f2c5bf..7942d67 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -133,7 +133,7 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason)
        exit(EXIT_FAILURE);
 }
 
-int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
+int nftnl_set_str_attr(const char **dptr, uint64_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len)
 {
 	if (*flags & (1 << attr))
-- 
2.49.0

