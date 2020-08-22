Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8734C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C5D208E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8tfHkpV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgHVGWM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 02:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHVGWK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 02:22:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5E3C061573
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:10 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p14so3732077wmg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c9khskjh7y7AiyFoGhZc7/IVKNk7RMzM8gclxVD6UJQ=;
        b=m8tfHkpV79M9R+WPcZpgz1is/ziV5OhKesA38NkPOqrcYNHMLH+P+byAl+UFNewVf6
         4TMxA8gEKWQd0Edd2lLR5Y5BAKIcT45nXI+W640Nv48p09RyxvNb7P3KLkg14UhOyCNM
         tR0PIsztvQzxTrfsyyMLtp7CBM3IW1foE01xeyd6SLXVaDHrF4xEZPMGdPILLQvr9nr7
         IyvFLCf/bvLlyxNgMuRJl1xbZ96/2f6Hjrdl94LW/8zi/dMfgbJk/7jfpChCPv29fJyX
         i3f67MbaLMlA9UU+R/OnduFGAUh8UJmu5vk74NP/cf3J8G0X3QbA2fg7dJFgedrfib4Q
         U0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c9khskjh7y7AiyFoGhZc7/IVKNk7RMzM8gclxVD6UJQ=;
        b=HyVz6sAT6PgzjPBSXz9nLkTgGCg8CHZAkRvrZUGqMhnqXV+NL++rMXvdDqQgbp2maO
         fn9J/teffW3AYnpkesXG1CPcEOxYdS5NzWuW9mqPy+nlrmeKu14XXKOPWExWn69OYOia
         LfNdOlLmhLKHK8Nr4ZeJxGrLeLqEIqnaTjwUaViO0n3tDbOJPHACqLPNHX/KYqd5w1hK
         UmXQg3gcYpsvc0HyynZWHgUZjYoCut9yafflDKMZllmxtgvLfN5XQPUlC3TPVrf1ittF
         ZayUW+4WmSfSzvp/+mHQYhGl8h3M2ei46JKad6+iL6CpTlApMA8mXErk5EB2kQ6N0Ax4
         Rs9A==
X-Gm-Message-State: AOAM533fmbQdCptKzKB7YzSxWISyJeE/0NTVfT/c7oCtaau1HP/Ske0k
        vTEgljYE5aQlKwemV/UIO+YXJ/MxdF611g==
X-Google-Smtp-Source: ABdhPJzd6Xkw421MAmVgAMfNblL4YdHRoyye/DIxjlcvrI2pADAl4XI/bizRVHXX0Gvgc10FgA/DOQ==
X-Received: by 2002:a05:600c:2302:: with SMTP id 2mr7192976wmo.151.1598077328506;
        Fri, 21 Aug 2020 23:22:08 -0700 (PDT)
Received: from localhost.localdomain (BC2467A7.dsl.pool.telekom.hu. [188.36.103.167])
        by smtp.gmail.com with ESMTPSA id h5sm7016321wrt.31.2020.08.21.23.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 23:22:07 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables 1/4] socket: add support for "wildcard" key
Date:   Sat, 22 Aug 2020 08:22:00 +0200
Message-Id: <20200822062203.3617-2-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822062203.3617-1-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
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
 src/evaluate.c     | 5 ++++-
 src/parser_bison.y | 2 ++
 src/parser_json.c  | 2 ++
 src/scanner.l      | 1 +
 src/socket.c       | 6 ++++++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b64ed3c0..28dade8a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1999,8 +1999,11 @@ static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 static int expr_evaluate_socket(struct eval_ctx *ctx, struct expr **expr)
 {
 	int maxval = 0;
+	
+	enum nft_socket_keys key = (*expr)->socket.key;
 
-	if((*expr)->socket.key == NFT_SOCKET_TRANSPARENT)
+	if (key == NFT_SOCKET_TRANSPARENT ||
+	    key == NFT_SOCKET_WILDCARD)
 		maxval = 1;
 	__expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->byteorder,
 			   (*expr)->len, maxval);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d4e99417..fff941e5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -213,6 +213,7 @@ int nft_lex(void *, void *, void *);
 
 %token SOCKET			"socket"
 %token TRANSPARENT		"transparent"
+%token WILDCARD			"wildcard"
 
 %token TPROXY			"tproxy"
 
@@ -4591,6 +4592,7 @@ socket_expr		:	SOCKET	socket_key
 
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
index 45699c85..90b36615 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -268,6 +268,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "socket"		{ return SOCKET; }
 "transparent"		{ return TRANSPARENT;}
+"wildcard"		{ return WILDCARD;}
 
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

