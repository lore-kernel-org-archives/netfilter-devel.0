Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960A6C433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7563720738
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7xiS1K1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgH2HET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 03:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgH2HER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 03:04:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DFBC061236
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so1130591wrm.2
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BSAZVtOYgQmKD3pMobC2+Pq9o7QM4rIquxYlov49dr4=;
        b=g7xiS1K19vqmPEQ46bKt80CNvSyikvXxFJBDwFRYFTHcRtpbcXSSphicl5/hAudaf0
         KLg9YeibkJCdk4DICINvxkhwKpmZVwVYlP3Z6rm/vVZEdoV6uvzLCcKtadX2+qslWzLb
         JicDVGajDrWlkj0JOq23yBex44X0K/QpJYJSDyKpAFxGrterXI9+MLannT0eOQLcdBMr
         54HgA3c+E0E750E48V0VRxyoO2s6RI4jbdr9VCB872a73pNDFPf9gksUf4joLS+hXxW7
         CEmMoSlbsTfoffkUISyV8yqMCmNn0jj6qQetyHtNw1sdYWCPjzh3qx6aIEh06K6eCSgH
         DY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BSAZVtOYgQmKD3pMobC2+Pq9o7QM4rIquxYlov49dr4=;
        b=cx8Y1ahG8SH4jajOZP6u0L2hCu7bBaC4PmrgJTh7EOqx2Jn9qIJzv46SHCvBcVbTRQ
         /OY7n66Y4SzRcZ+t7vho4mUezjayHOkmxABoR3rRlS4C9sqfyuB94gYArh4DiSgHbBnc
         gP6DuWbj2I3kWegVbP4SO0epRTGXX8vEJ6oYAc1Axq0ro+D9tDDIKcF/UPZO19xqkcHW
         IErBDBm7nKSXUpQwjY0DOX2LpkPj0Wt6lG5ZBxfTVt/ZGsWlsc38RYrjBHW8s0eQA5lW
         9KP06P45Nk3DIrIFJEM9HtmrMM3RUhl82vcYLsnArJSEyULxE7w+Dm8DgA26tZSi1UIu
         SEvQ==
X-Gm-Message-State: AOAM532mF4SsTXeW6QVwjQZVMbVdik2Eqp+gitYR0uxD9ixahVTRoUMO
        CJN5RoLUlEGKsJhD57K652cFFMsQxU+p0g==
X-Google-Smtp-Source: ABdhPJwLqdThuBgSYKp5jWJI8Ypy8K3XWR8hsV3mpWp18kTOjbMhfL53yjRDtr1Ww9NcpMe4gmUrOA==
X-Received: by 2002:adf:a48d:: with SMTP id g13mr2306801wrb.212.1598684655594;
        Sat, 29 Aug 2020 00:04:15 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id f2sm2489756wrj.54.2020.08.29.00.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 00:04:14 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables v2 1/5] socket: add support for "wildcard" key
Date:   Sat, 29 Aug 2020 09:04:01 +0200
Message-Id: <20200829070405.23636-2-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829070405.23636-1-bazsi77@gmail.com>
References: <20200829070405.23636-1-bazsi77@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables had a "-m socket --transparent" which didn't match sockets that are
bound to all addresses (e.g.  0.0.0.0 for ipv4, and ::0 for ipv6).  It was
possible to override this behavior by using --nowildcard, in which case it
did match zero bound sockets as well.

The issue is that nftables never included the wildcard check, so in effect
it behaved like "iptables -m socket --transparent --nowildcard" with no
means to exclude wildcarded listeners.

This is a problem as a user-space process that binds to 0.0.0.0:<port> that
enables IP_TRANSPARENT would effectively intercept traffic going in _any_
direction on the specific port, whereas in most cases, transparent proxies
would only need this for one specific address.

The solution is to add "socket wildcard" key to the nft_socket module, which
makes it possible to match on the wildcardness of a socket from
one's ruleset.

This is how to use it:

table inet haproxy {
	chain prerouting {
        	type filter hook prerouting priority -150; policy accept;
		socket transparent 1 socket wildcard 0 mark set 0x00000001
	}
}

This patch effectively depends on its counterpart in the kernel.

Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/evaluate.c                      | 4 +++-
 src/parser_bison.y                  | 2 ++
 src/parser_json.c                   | 2 ++
 src/scanner.l                       | 1 +
 src/socket.c                        | 6 ++++++
 6 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1341b52f..10be073a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -996,10 +996,12 @@ enum nft_socket_attributes {
  *
  * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
  * @NFT_SOCKET_MARK: Value of the socket mark
+ * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
+	NFT_SOCKET_WILDCARD,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 320a464f..e1992e2a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1999,8 +1999,10 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 static int expr_evaluate_socket(struct eval_ctx *ctx, struct expr **expr)
 {
 	int maxval = 0;
+	enum nft_socket_keys key = (*expr)->socket.key;
 
-	if((*expr)->socket.key == NFT_SOCKET_TRANSPARENT)
+	if (key == NFT_SOCKET_TRANSPARENT ||
+	    key == NFT_SOCKET_WILDCARD)
 		maxval = 1;
 	__expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->byteorder,
 			   (*expr)->len, maxval);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 95adc48f..d938f566 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -213,6 +213,7 @@ int nft_lex(void *, void *, void *);
 
 %token SOCKET			"socket"
 %token TRANSPARENT		"transparent"
+%token WILDCARD			"wildcard"
 
 %token TPROXY			"tproxy"
 
@@ -4595,6 +4596,7 @@ socket_expr		:	SOCKET	socket_key
 
 socket_key 		: 	TRANSPARENT	{ $$ = NFT_SOCKET_TRANSPARENT; }
 			|	MARK		{ $$ = NFT_SOCKET_MARK; }
+			|	WILDCARD	{ $$ = NFT_SOCKET_WILDCARD; }
 			;
 
 offset_opt		:	/* empty */	{ $$ = 0; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 59347168..ac89166e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -427,6 +427,8 @@ static struct expr *json_parse_socket_expr(struct json_ctx *ctx,
 		keyval = NFT_SOCKET_TRANSPARENT;
 	else if (!strcmp(key, "mark"))
 		keyval = NFT_SOCKET_MARK;
+	else if (!strcmp(key, "wildcard"))
+		keyval = NFT_SOCKET_WILDCARD;
 
 	if (keyval == -1) {
 		json_error(ctx, "Invalid socket key value.");
diff --git a/src/scanner.l b/src/scanner.l
index 45699c85..9e6464f9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -268,6 +268,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "socket"		{ return SOCKET; }
 "transparent"		{ return TRANSPARENT;}
+"wildcard"		{ return WILDCARD; }
 
 "tproxy"		{ return TPROXY; }
 
diff --git a/src/socket.c b/src/socket.c
index d78a163a..673e5d0f 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -26,6 +26,12 @@ const struct socket_template socket_templates[] = {
 		.len		= 4 * BITS_PER_BYTE,
 		.byteorder	= BYTEORDER_HOST_ENDIAN,
 	},
+	[NFT_SOCKET_WILDCARD] = {
+		.token		= "wildcard",
+		.dtype		= &integer_type,
+		.len		= BITS_PER_BYTE,
+		.byteorder	= BYTEORDER_HOST_ENDIAN,
+	},
 };
 
 static void socket_expr_print(const struct expr *expr, struct output_ctx *octx)
-- 
2.17.1

