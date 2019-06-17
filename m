Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD9EC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6766208C4
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DW7ivA70"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfFQQQV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:16:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41009 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfFQQQV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:16:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so10625137wrm.8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 09:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=sg8D3r+bFE2HrsTRyW6C5sNAoBZCpm3yvXque9vHqog=;
        b=DW7ivA70e7C2aZf4PZ559Lh0XI5jBOOzWoX4Lu79J9oTkuI4J0UHyqFO+TeFCGNF4b
         7AhyfPvKPOuNJ1RgUYZdi1JII/aP9WSkwSZiDwthGz5JElt3A/Vc0JHYyPuo/Faykq4U
         d8ObQqt2Uh5n5NH6F0v6XqpsbqGzyDplMl/ZH1w3WjTRxD7TDRilWChccxoK///IMbXv
         2lry9NYPgxYc38YWJ7y5c1BNlrc3bvR7P71EYFtRcJSPjQBd+AtxFHF0Kuboi/lCBUYH
         U7mu1UxfidMgIDKA7W0UdBwT9dd9OzqC3JanuyAxPYdqybSG2W3JGUy2VMNdoytFibeB
         I9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=sg8D3r+bFE2HrsTRyW6C5sNAoBZCpm3yvXque9vHqog=;
        b=L0Uvcymy6D0D75YE3aCDJKQ1wNAeG4IXpdYFRY0nqVQ9nf8roGMZ0JSVgUE7JSNDoa
         yRpxC2a7LKHbP4pOWYyGsSicjrQSMhBgJJaAqZBKq7WiixQW6NTWjzuxWJaudj4SkeNR
         t8SAIb/fNXDa2nr5P0QgcOMi96AAsACQjgegZ+PQ7wsOdKax55kqA33Dx1rPyBKWh5KY
         iXd9kLjm5ms04iaP3kw0J9OoXZiafkJnd+tncuZQjLhWvnY3RrnrplbfxnSvVaQBThDp
         flgWDK5q1FXGygFnpmxBp9dWXU1/qLpx/l3GIGW03ZxF83DU/X0FiPB0fRRwFJfe+Pqf
         V7Ag==
X-Gm-Message-State: APjAAAUogoVEUqFYTJJygR77UGItBTNKfYpQ5cbmHxfRQ8g4qpdbuHXp
        gII1YUQsmjXW+MF4h9NeNBg=
X-Google-Smtp-Source: APXvYqz6XfPTng8mymN/RsmhkF9uV92Zvqim0VIOIhqnDC2+do8RwQJ6jyW2WYAMM1vxaXXVhvj2sw==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr14383045wrr.71.1560788178917;
        Mon, 17 Jun 2019 09:16:18 -0700 (PDT)
Received: from nevthink ([46.6.7.159])
        by smtp.gmail.com with ESMTPSA id 128sm16668680wme.12.2019.06.17.09.16.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 09:16:18 -0700 (PDT)
From:   nevola <nevola@gmail.com>
X-Google-Original-From: nevola <laura.garcia@zevenet.com>
Date:   Mon, 17 Jun 2019 18:15:41 +0200
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: enable set expiration date for set elements
Message-ID: <20190617161541.ppjn6nf57mfkz77j@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, the expiration of every element in a set or map
is a read-only parameter generated at kernel side.

This change will permit to set a certain expiration date
per element that will be required, for example, during
stateful replication among several nodes.

This patch will enable the _expires_ input parameter in
the parser and propagate NFTNL_SET_ELEM_EXPIRATION in
order to send the configured value.

Signed-off-by: nevola <laura.garcia@zevenet.com>
---
 src/netlink.c      | 3 +++
 src/parser_bison.y | 5 +++++
 src/scanner.l      | 1 +
 3 files changed, 9 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index a6d81b4..40dc41a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -122,6 +122,9 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	if (elem->timeout)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
 				       elem->timeout);
+	if (elem->expiration)
+		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_EXPIRATION,
+				       elem->expiration);
 	if (elem->comment || expr->elem_flags) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1c0b60c..f732350 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -255,6 +255,7 @@ int nft_lex(void *, void *, void *);
 %token TIMEOUT			"timeout"
 %token GC_INTERVAL		"gc-interval"
 %token ELEMENTS			"elements"
+%token EXPIRES			"expires"
 
 %token POLICY			"policy"
 %token MEMORY			"memory"
@@ -3367,6 +3368,10 @@ set_elem_option		:	TIMEOUT			time_spec
 			{
 				$<expr>0->timeout = $2;
 			}
+			|	EXPIRES		time_spec
+			{
+				$<expr>0->expiration = $2;
+			}
 			|	comment_spec
 			{
 				$<expr>0->comment = $1;
diff --git a/src/scanner.l b/src/scanner.l
index d1f6e87..b46b25e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -302,6 +302,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "timeout"		{ return TIMEOUT; }
 "gc-interval"		{ return GC_INTERVAL; }
 "elements"		{ return ELEMENTS; }
+"expires"		{ return EXPIRES; }
 
 "policy"		{ return POLICY; }
 "size"			{ return SIZE; }
-- 
2.11.0

