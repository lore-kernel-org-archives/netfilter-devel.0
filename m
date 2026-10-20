Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500574;
	b=g3cSAKjofCcq5vzEc2sbpxmzzgHuMygeHAu6WIuNAMQ5Ea45Q/CeGfouKyfXCTFaTAXJ
	 znKdsaTp8MYX4DHANlotUoxftkZKOvv9hTcr5O+aOLl1SbLCIvFKFAm2Zoqo29Z4MW+Xa
	 jjcbVBoU9elNn/gjd7VW7ZCp9N/DZpjsIf3uriZXT12cDCsJRMoSDFLIt9J8tU3JyPnGH
	 kbX+x9RYJEGrMHUSOHUqTBZlXD9Pf4FCypOagbZaCfgprj1okuoRxIJ8W3niu9liWz3E9
	 k07FgTYh6RwsDHbJmua3TfNfBsSH31KlauT2TR56mP8evft2RvwmmFJtpJoGw7HxRlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500574;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lA775VVasYi2k2A/R6U+1K4h7dJPj6xtkG6MNBYxyTw=;
	b=X4rf0qSFt6Fk8qIGnfcuuks1b4ugaITR58R3AZA6G/J8LquXjqZ92ZSwaSqyo7q7FNZF
	 tWcI9N6kX63Ho4+the9K4S5E5lkMvT25UmsNsXHFDRS+DWxqWdDMsGo43hAV22Pa03WQS
	 UqI1CHWGd9GIQLQHYkwKRO2PLGBXBE+h5cOgTLod8SEk1Kp8E9Jabbc+0dEwal7yOsCqg
	 FInuNY/39sQO0bU6Dk6z11gDLTC1ni0T9vhw5kt9FdLC2j+5kmOo0TZ2UAQK8FlBpfsh3
	 kPfsZM80X7HD0hPTR3Vg48BiEEgsUN+tK3ql5qkdrJV638WiAn5S+Cww9LsQaF5zQwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB148606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 12:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB148606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2BCFD6088C; Tue, 20 Oct 2026 14:49:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: add misspell hint for ct timeout policy names
Date: Tue, 20 Oct 2026 14:49:20 +0200
Message-ID: <20261020124925.17318-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
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

before:
Error: invalid state for this protocol
add ct timeout t foo { protocol tcp; policy = { estblshed : 2 }; }
                                                ^^^^^^^^^
after:
Error: invalid state 'estblshed' for this protocol; did you mean 'established'?
add ct timeout t foo { protocol tcp; policy = { estblshed : 2 }; }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h |  1 +
 src/evaluate.c | 19 +++++++++++++++++--
 src/rule.c     | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 7b7b7eb1012d..09fd045c7385 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -882,5 +882,6 @@ struct timeout_protocol {
 
 extern struct timeout_protocol timeout_protocol[UINT8_MAX + 1];
 extern int timeout_str2num(uint16_t l4proto, struct timeout_state *ts);
+extern const char *timeout_lookup_fuzzy(uint16_t l4proto, const char *name);
 
 #endif /* NFTABLES_RULE_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 01b4afbbb10d..f424b987f8f8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5826,6 +5826,21 @@ static int ct_expect_evaluate(struct eval_ctx *ctx, struct obj *obj)
 	return 0;
 }
 
+static int timeout_not_found(struct eval_ctx *ctx, const struct location *loc,
+			     uint16_t l4proto, const char *state_name)
+{
+	const char *suggestion;
+
+	suggestion = timeout_lookup_fuzzy(l4proto, state_name);
+	if (suggestion == NULL)
+		return cmd_error(ctx, loc, "invalid state '%s' for this protocol",
+				 state_name);
+
+	return cmd_error(ctx, loc,
+			 "invalid state '%s' for this protocol; did you mean '%s'?",
+			 state_name, suggestion);
+}
+
 static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	struct ct_timeout *ct = &obj->ct_timeout;
@@ -5837,8 +5852,8 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 	list_for_each_entry_safe(ts, next, &ct->timeout_list, head) {
 		if (timeout_str2num(ct->l4proto, ts) < 0)
-			return __stmt_binary_error(ctx, &ts->location, NULL,
-						   "invalid state for this protocol");
+			return timeout_not_found(ctx, &ts->location,
+						 ct->l4proto, ts->timeout_str);
 
 		ct->timeout[ts->timeout_index] = ts->timeout_value;
 		list_del(&ts->head);
diff --git a/src/rule.c b/src/rule.c
index 552c17df05f8..d232582b6080 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -89,6 +89,25 @@ struct timeout_protocol timeout_protocol[UINT8_MAX + 1] = {
 	},
 };
 
+const char *timeout_lookup_fuzzy(uint16_t l4proto, const char *name)
+{
+	struct string_misspell_state st;
+	unsigned int i;
+
+	if (!name)
+		return NULL;
+
+	string_misspell_init(&st);
+
+	for (i = 0; i < timeout_protocol[l4proto].array_size; i++)
+		string_misspell_update(timeout_protocol[l4proto].state_to_name[i],
+				       name,
+				       (void *)timeout_protocol[l4proto].state_to_name[i],
+				       &st);
+
+	return st.obj;
+}
+
 int timeout_str2num(uint16_t l4proto, struct timeout_state *ts)
 {
 	unsigned int i;
-- 
2.55.0

