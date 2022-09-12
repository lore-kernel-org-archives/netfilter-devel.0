Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258ABECAAA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiILKxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiILKxq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 06:53:46 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915A831345
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 03:53:43 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MR3P250SSz9t1g
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662980022; bh=iGuw5BG89uYPSMq1lZxQ4/woWPUweQD6eJ+f3qVh2mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL5y5wdfs5jaBkcKr70ThF+orYld1CHzx1xNFU05gVugYvwUBQP+DK6lMM4ozhJxs
         o22/O0M6GQQvqckmIpXt4sxh7KiMyT8A8sQOq40CNxqgv2Z1JLKQgJc3irNY1JjJKx
         hA2gRgQ812Xv5zsDpiTHR8J9mKNpEWvFIn47KiIo=
X-Riseup-User-ID: A6CBD90E6AF604F1710D29732CBB78001BBBAD624C4F39C2E019D048A6A368F8
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MR3P16KYkz1xwy;
        Mon, 12 Sep 2022 10:53:41 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 3/3 nft] doc: add nft_ctx_add_var() and nft_ctx_clear_vars() docs
Date:   Mon, 12 Sep 2022 12:52:25 +0200
Message-Id: <20220912105225.79025-3-ffmancera@riseup.net>
In-Reply-To: <20220912105225.79025-1-ffmancera@riseup.net>
References: <20220912105225.79025-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing documentation for nft_ctx_add_var() and nft_ctx_clear_vars()
functions.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 doc/libnftables.adoc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 3abb9595..550012b4 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -37,6 +37,9 @@ const char *nft_ctx_get_error_buffer(struct nft_ctx* '\*ctx'*);
 int nft_ctx_add_include_path(struct nft_ctx* '\*ctx'*, const char* '\*path'*);
 void nft_ctx_clear_include_paths(struct nft_ctx* '\*ctx'*);
 
+int nft_ctx_add_var(struct nft_ctx* '\*ctx'*, const char* '\*var'*);
+void nft_ctx_clear_vars(struct nft_ctx '\*ctx'*);
+
 int nft_run_cmd_from_buffer(struct nft_ctx* '\*nft'*, const char* '\*buf'*);
 int nft_run_cmd_from_filename(struct nft_ctx* '\*nft'*,
 			      const char* '\*filename'*);*
@@ -206,6 +209,14 @@ The function returns zero on success or non-zero if memory allocation failed.
 
 The *nft_ctx_clear_include_paths*() function removes all include paths, even the built-in default one.
 
+=== nft_ctx_add_var() and nft_ctx_clear_vars()
+The *define* command in nftables ruleset allows to define variables.
+
+The *nft_ctx_add_var*() function extends the list of variables in 'ctx'. The variable must be given in the format 'key=value'.
+The function returns zero on success or non-zero if the variable is malformed.
+
+The *nft_ctx_clear_vars*() function removes all variables.
+
 === nft_run_cmd_from_buffer() and nft_run_cmd_from_filename()
 These functions perform the actual work of parsing user input into nftables commands and executing them.
 
-- 
2.30.2

