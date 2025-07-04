Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003C34CF5
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 11:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751629207; cv=none; b=El8xXT+slQbEkMO2kXaAskXi6nMvLhIdzEKo/PbnDqIFh9c2FYWq8z3IdDDq8k8juR6A1O9+kIsaAlfLxQDyehlVZBGzqc71XQ4epAimNgbAAfr3vtUsnWg9YEKXy6ueX7zlOnmPvlQ0OEDBiptUYtRWF/u3QFIkVjWay6D5X3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751629207; c=relaxed/simple;
	bh=/i6prCxpLmL+ZvU4a5/M63dBkOo+kEqJenVucxiJ9Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4mbHSvE3kNtkiVsEEwds7+FdYL8KZLkKZc9rISif9WML4dZVk/tDqyjVbXwfso9vuwrC8Xt6d6AUbfX3MpJgT2ldWcp3SY0W37iwbpGZyqlWkxXc7hDXGja+7/W7IY+6NLh7OHLEcBVlmYacg5RnTRHsRRPQxr/VfMss474mbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoj7S/4W; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoj7S/4W"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-23c703c471dso17927655ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 04:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751629205; x=1752234005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VlYav2b6k8z0Ng/9xdvLPcQJQdMlzmEiQswWGhL3r8U=;
        b=hoj7S/4WqN6Q1N/attcgtxJMeDEuBdrL0R2gMQjEe4oOMfVuuClhfAGZWkSn7Xk7fk
         ifOF3N+MPUOi+QGXEwZY+eVng/yBE+Nor28wH23YxzsnLU6vudkT4GwS5tH2SW22jJl0
         rSLLsYpCE3yg/pmcKrCV635/z/YGMcXKUYWjRYyN/sy8/p5x71eifqT/8pGRMTw3r18C
         jJ8H4b95okRa+yNRfm0nf2uAWiErCofTmsVYKeuDtl4oEp8RuGSdMJngBMM2kErLqVam
         60BB3ZAgT45Ys/mMfyCtB2JFB5Gbb99m74noTxkua8G3YEJOedBGsLKgM7JCtUlsrkG1
         WfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751629205; x=1752234005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlYav2b6k8z0Ng/9xdvLPcQJQdMlzmEiQswWGhL3r8U=;
        b=b2SW5ZK8zmAD0v5kMj7a/+xOBPbq3zv+22U9/QHVAS4bCyo/w8wFpNt8UM5R5jFof9
         RFvXjRWTzopic4CG63gwH3RFWINbZYQFtJXRFkyOg0P0CtyqGqW+jGTtE5mOpFciOHIQ
         m6elggxV4kJikInX48G3BaT1kKGK7HXzWMJBQBDI9uj6IKmjtpZHh/GT536sBIo5hYDU
         OaL5kVgOk+HQCvyU9XCuQf+WMO7x8IZqhWXMztLHy1vfwQwJ2Nyebj1dQARcybp0o9Zm
         ztIcDWoy9/20HF1yoxNB532+n+53ECShtAuP55kQaf6D7R7uV84LASfdYxXhDjUP+HV7
         b/Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXXTVb5j8FIjQJ3yN/CoDwc7MaZ6ZsT8p+I9mbSdjXbzrvT7Bylfm3htqGmnBFjCJU12DQDWUK8q+s+rym6ryA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeT7X5WGsDgvsf/SDmpcFMryRUiwOV39y8LFl3kj2Qa7EiYBWG
	A0HfsZO+xtSHLkLFhPs7SW7h2YgioVRhMsKobswxnTPRXRcWXOGDVL3+
X-Gm-Gg: ASbGncv6no4ycLB9zcYyOOimacGxz34PFnu+TDbLWnzCmc1mJzkpboOqNUxGHYosPj8
	0wmq159wXH8hKmcRnW6uViGUW7c7zVQMFmawYSURYs5kryUpX4Oa8DhVCR/R06Gj9invxwRA6nT
	Nj/kJf0ONlOLQZLd6nNHuvdz0Z9Ws24t53XvCAoQ/KUmKcWNIoWxIU7cj2Mfh67RihyHdWmr7rg
	YEBUsyrK6qi++BrRI564aF4xekxy7pnd2JEdwsV77p9BglHPBPWZe4VskQTpSBVZVQWB7iIBZlq
	WveYc+Kxujek7rKiwLMQIB0wS5J/ahzGpIGT0Befir2nW4lGeisPuxVpcsrvMEbgAA==
X-Google-Smtp-Source: AGHT+IGmJtymSMpTRWQX6BZpNTLvJPcThe1QjweDPr4/IRD0vOwXwww0dT3agavNqNBUg3ubkXILnw==
X-Received: by 2002:a17:902:d2c5:b0:236:15b7:62e3 with SMTP id d9443c01a7336-23c858ac240mr36039845ad.9.1751629204829;
        Fri, 04 Jul 2025 04:40:04 -0700 (PDT)
Received: from localhost.localdomain ([103.114.158.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c8455e74fsm19585365ad.99.2025.07.04.04.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 04:40:04 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Subject: [PATCH nft 1/3] src: make the mss and wscale fields optional for synproxy object
Date: Fri,  4 Jul 2025 11:39:45 +0000
Message-ID: <20250704113947.676-2-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mss and wscale fields is optional for synproxy statement, this patch
to make the same behavior for synproxy object, and also makes the
timestamp and sack-perm flags no longer order-sensitive.

Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
---
 src/json.c         |  9 ++++---
 src/parser_bison.y | 63 +++++++++++++++-------------------------------
 src/parser_json.c  | 26 ++++++++++++-------
 3 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/src/json.c b/src/json.c
index f0430776851c..15ddc4dab790 100644
--- a/src/json.c
+++ b/src/json.c
@@ -469,10 +469,11 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_SYNPROXY:
-		tmp = nft_json_pack("{s:i, s:i}",
-				    "mss", obj->synproxy.mss,
-				    "wscale", obj->synproxy.wscale);
-
+		tmp = json_object();
+		if (obj->synproxy.flags & NF_SYNPROXY_OPT_MSS)
+			json_object_set_new(tmp, "mss", json_integer(obj->synproxy.mss));
+		if (obj->synproxy.flags & NF_SYNPROXY_OPT_WSCALE)
+			json_object_set_new(tmp, "wscale", json_integer(obj->synproxy.wscale));
 		flags = json_array();
 		if (obj->synproxy.flags & NF_SYNPROXY_OPT_TIMESTAMP)
 			json_array_append_new(flags, json_string("timestamp"));
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f9cc909836bc..45f2cb4a11f2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -964,8 +964,6 @@ int nft_lex(void *, void *, void *);
 %destructor { free_const($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
 
-%type <val>			synproxy_ts	synproxy_sack
-
 %type <expr>			tcp_hdr_expr
 %destructor { expr_free($$); }	tcp_hdr_expr
 %type <val>			tcp_hdr_field
@@ -2662,7 +2660,7 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|	synproxy_block	common_block
 			|	synproxy_block	stmt_separator
-			|	synproxy_block	synproxy_config
+			|	synproxy_block	synproxy_config_arg
 			{
 				$$ = $1;
 			}
@@ -3807,58 +3805,37 @@ synproxy_arg		:	MSS	NUM
 			}
 			;
 
-synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
+synproxy_config		:	synproxy_config_arg
 			{
-				struct synproxy *synproxy;
-				uint32_t flags = 0;
-
-				synproxy = &$<obj>0->synproxy;
-				synproxy->mss = $2;
-				flags |= NF_SYNPROXY_OPT_MSS;
-				synproxy->wscale = $4;
-				flags |= NF_SYNPROXY_OPT_WSCALE;
-				if ($5)
-					flags |= $5;
-				if ($6)
-					flags |= $6;
-				synproxy->flags = flags;
-			}
-			|	MSS	NUM	stmt_separator	WSCALE	NUM	stmt_separator	synproxy_ts	synproxy_sack
-			{
-				struct synproxy *synproxy;
-				uint32_t flags = 0;
-
-				synproxy = &$<obj>0->synproxy;
-				synproxy->mss = $2;
-				flags |= NF_SYNPROXY_OPT_MSS;
-				synproxy->wscale = $5;
-				flags |= NF_SYNPROXY_OPT_WSCALE;
-				if ($7)
-					flags |= $7;
-				if ($8)
-					flags |= $8;
-				synproxy->flags = flags;
+				$<obj>$	= $<obj>0;
 			}
+			|	synproxy_config	synproxy_config_arg
 			;
 
-synproxy_obj		:	/* empty */
+synproxy_config_arg	:	MSS	NUM
 			{
-				$$ = obj_alloc(&@$);
-				$$->type = NFT_OBJECT_SYNPROXY;
+				$<obj>0->synproxy.mss = $2;
+				$<obj>0->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
+			}
+			|	WSCALE	NUM
+			{
+				$<obj>0->synproxy.wscale = $2;
+				$<obj>0->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
 			}
-			;
-
-synproxy_ts		:	/* empty */	{ $$ = 0; }
 			|	TIMESTAMP
 			{
-				$$ = NF_SYNPROXY_OPT_TIMESTAMP;
+				$<obj>0->synproxy.flags |= NF_SYNPROXY_OPT_TIMESTAMP;
+			}
+			|	SACK_PERM
+			{
+				$<obj>0->synproxy.flags |= NF_SYNPROXY_OPT_SACK_PERM;
 			}
 			;
 
-synproxy_sack		:	/* empty */	{ $$ = 0; }
-			|	SACK_PERM
+synproxy_obj		:	/* empty */
 			{
-				$$ = NF_SYNPROXY_OPT_SACK_PERM;
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_SYNPROXY;
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 08657f2849a5..dc1431e1711c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3493,7 +3493,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 {
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
 	uint32_t l3proto = NFPROTO_UNSPEC;
-	int inv = 0, flags = 0, i, j;
+	int inv = 0, flags = 0, i;
 	struct handle h = { 0 };
 	struct obj *obj;
 
@@ -3667,14 +3667,22 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		break;
 	case CMD_OBJ_SYNPROXY:
 		obj->type = NFT_OBJECT_SYNPROXY;
-		if (json_unpack_err(ctx, root, "{s:i, s:i}",
-				    "mss", &i, "wscale", &j))
-			goto err_free_obj;
-
-		obj->synproxy.mss = i;
-		obj->synproxy.wscale = j;
-		obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
-		obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
+		if (!json_unpack(root, "{s:i}", "mss", &i)) {
+			if (i < 0) {
+				json_error(ctx, "Invalid synproxy mss value '%d'", i);
+				goto err_free_obj;
+			}
+			obj->synproxy.mss = i;
+			obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
+		}
+		if (!json_unpack(root, "{s:i}", "wscale", &i)) {
+			if (i < 0) {
+				json_error(ctx, "Invalid synproxy wscale value '%d'", i);
+				goto err_free_obj;
+			}
+			obj->synproxy.wscale = i;
+			obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
+		}
 		flags = parse_flags_array(ctx, root, "flags",
 					  json_parse_synproxy_flag);
 		if (flags < 0)
-- 
2.43.0

