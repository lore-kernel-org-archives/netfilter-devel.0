Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6CFC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 09:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DC3613B2
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 09:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243338AbhDMJE4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 05:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDMJEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 05:04:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22027C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2021 02:03:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id 12so15648236wrz.7
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2021 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=48/uFHH+w2QMtienCnpc00azrupgsgt3MfgPzgWD6VA=;
        b=rX8wbAHxb7nxWAH1XILStmcwqTYxVLMugqzQDdRm6mZgFO+pcGwvhggExF2lwlbth8
         DumTOJkabrZ9ScmA6fkhUHXXFSfLxEUY6UL/sQ4PmK5/znRNaHFXgzxYsL2UVqnj2w/n
         ZW/LuEr+S9MpB4v2fyh+ZQC7ZfPEh6ClrDDAx+dGGHBjN7Mcm/h1wVW1SoLicAkEyokq
         AZ3vkOq3Uh4VMIR/u3/JRhRLjJYUhtPdXfd+P/y2K/74BINAYPEnoL3TcLJoVHCPLRnm
         xwrfApr9xd9kXRcnHpwRiLjZPixfXfGlrOepFEG46MFiMOAMglo+8CIfY3GZyB0wayOm
         VuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=48/uFHH+w2QMtienCnpc00azrupgsgt3MfgPzgWD6VA=;
        b=ALYXPGKfln9MSdq3PSWh5nLxmaacDobfJCxl9snSArm/h8E9CCXHlW7lJ6KEJjbNWr
         UwVOFsl+twEGU5s6IpI6qBUcx9G0VsvQioGp456cjjj0Vx1Z33scGXXNP42Dp52Jvc8U
         z6lsvma7shQ9WCDO9AMJdNicUojFlUFxrN267DxZG3MZdsU9OPwG1PJc8TjBx+eYU7Tp
         g/Ou+2sxfzIgA5JmrYYo2Rtfj3bEr1VOvTqQOmZZ6DUhLmbG/bcrMTKxKvpg7m4yyFzy
         Ro9UIaNa5SmYdXleAnVAAvYIpgPfvEqbokkGoVQ5AhrAbCYs+PLsBwiX5NkLhNYbznv+
         KHSA==
X-Gm-Message-State: AOAM530Toghjtq7YhyUJwiHBUR2v1ejCq/1vJM2g3Dz/WBkUpCVAYXSs
        pJY3AM0EtmlNu9CbK39nWuQl6qwkUCNJeQ==
X-Google-Smtp-Source: ABdhPJxqPaWw8AG40x2eFJenrGHkBKdKQ1UpD1buR3c+Snqc4xN1pZSbdmG+0jDjN0cc8bBuC2/90w==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr10929833wru.276.1618304623937;
        Tue, 13 Apr 2021 02:03:43 -0700 (PDT)
Received: from nevthink ([149.34.62.251])
        by smtp.gmail.com with ESMTPSA id a8sm21525861wrh.91.2021.04.13.02.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:03:43 -0700 (PDT)
From:   nevola <nevola@gmail.com>
X-Google-Original-From: nevola <laura.garcia@zevenet.com>
Date:   Tue, 13 Apr 2021 11:03:41 +0200
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nft] parser: allow to load stateful ct connlimit elements in
 sets
Message-ID: <20210413090341.GA16617@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes a syntax error after loading a nft
dump with a set including stateful ct connlimit elements.

Having a nft dump as per below:

table ip nftlb {
	set connlimit-set {
		type ipv4_addr
		size 65535
		flags dynamic
		elements = { 84.245.120.167 ct count over 20 , 86.111.207.45 ct count over 20 ,
		             173.212.220.26 ct count over 20 , 200.153.13.235 ct count over 20  }
	}
}

The syntax error is shown when loading the ruleset.

root# nft -f connlimit.nft
connlimit.nft:15997:31-32: Error: syntax error, unexpected ct, expecting comma or '}'
		elements = { 84.245.120.167 ct count over 20 , 86.111.207.45 ct count over 20 ,
		                            ^^
connlimit.nft:16000:9-22: Error: syntax error, unexpected string
			     173.212.220.26 ct count over 20 , 200.153.13.235 ct count over 20  }
			     ^^^^^^^^^^^^^^

After applying this patch a kernel panic is raised running
nft_rhash_gc() although no packet reaches the set.

The following patch [0] should be used as well:

4d8f9065830e5 ("netfilter: nftables: clone set element expression template")

Note that the kernel patch will produce the emptying of the
connection tracking, so the restore of the conntrack states
should be considered.

[0]: https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=4d8f9065830e526c83199186c5f56a6514f457d2

Signed-off-by: nevola <laura.garcia@zevenet.com>
---
 src/parser_bison.y                             | 11 +++++++++++
 tests/shell/testcases/sets/0062set_connlimit_0 | 14 ++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0062set_connlimit_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index abe11781..c3514f18 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4191,6 +4191,17 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				$$->limit.type  = NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
                         }
+			|	CT	COUNT	NUM	close_scope_ct
+			{
+				$$ = connlimit_stmt_alloc(&@$);
+				$$->connlimit.count	= $3;
+			}
+			|	CT	COUNT	OVER	NUM	close_scope_ct
+			{
+				$$ = connlimit_stmt_alloc(&@$);
+				$$->connlimit.count = $4;
+				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
+			}
 			;
 
 set_elem_expr_option	:	TIMEOUT			time_spec
diff --git a/tests/shell/testcases/sets/0062set_connlimit_0 b/tests/shell/testcases/sets/0062set_connlimit_0
new file mode 100755
index 00000000..4f95f383
--- /dev/null
+++ b/tests/shell/testcases/sets/0062set_connlimit_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	set est-connlimit {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		elements = { 84.245.120.167 ct count over 20 }
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.20.1

