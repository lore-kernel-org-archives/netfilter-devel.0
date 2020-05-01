Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84DAC47253
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B4820731
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 17:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iat4dEmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgEARzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 13:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729612AbgEARzl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 13:55:41 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5F6C061A0C
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 10:55:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o10so8535327qtr.6
        for <netfilter-devel@vger.kernel.org>; Fri, 01 May 2020 10:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=N2UYIAQfzDmKZLPQsnq2cs1HPRw1W6dvCckXPQccNrM=;
        b=Iat4dEmLfL+p+wEvqdkxLy9vVBdB/2i6xZxr3z2M/LzwIovc/vt+PruuJPN6p6NoMV
         AUIqZQXzho0rRDOB+cpYoF9kLQ9ya+3drG6b4B8/2ibndqVUl3rqQ8BeoHdb9BS4ND2R
         7sT9Fw8Joz0Jey38Y6T0VLYM+ySdgQYmnA2O71ncsgavWuEepFpcZktRp2NrVarfDZLi
         HEc3uKifvdSOC/tXAj2BcXowVV4Enb9hEbWLW+6FPdMP4/37xR2AtocJ3+/TJSo+S+Jj
         D3HPs9GeX+4kPD5EHn5SRHmXRZ/uplaGg19dsWJZ6GcJjiW+jHWtyS24z50XRdCU1FlO
         yCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=N2UYIAQfzDmKZLPQsnq2cs1HPRw1W6dvCckXPQccNrM=;
        b=W3ej5DtgG1rQb2LZFje+c4EHu1UWb/IMUXBNgrmZC6ufK9Cs2q9U/+cEc5MrNrMKdS
         PFPfhL34hBuNarmpKXsu3cBgFI5bKDEAAdzh5ONhI8nOaJ1uO0O6cXLMnoneXZ/ydm/+
         3F2X6R6VLmL+gXINPBNVwhfA8sQaoN8TlWivDgSUdE5a5xD8bvG1cg+XGfnoXKdbiXTF
         JyDR2WduEAGIXiq04iP5AlogTuh/FZjuYgP8osVfBxGCHro+9cU1THOjo329CpH0CKT+
         po+vwwodt0Rdx//bNo35alYGrwaWoUR0XE1FH3Yke01f6UBW8KkEzJRfROLhH4A1x6OS
         94sg==
X-Gm-Message-State: AGi0PubYO8F+/qiL4oTZTjXLAEh8XcbHbJq8VZHtjr0dfjKo5u5OA2pp
        4zBITZudW0IBYKtTNI4q3HAEoLerDG4=
X-Google-Smtp-Source: APiQypK6zQInEQNa82f3ZmVlVSorlm0MmQDn6c5sar4iwLPBNsQziR9ScbF5lxNAjpsQWVfITsZRpA==
X-Received: by 2002:aed:2591:: with SMTP id x17mr4939859qtc.76.1588355740105;
        Fri, 01 May 2020 10:55:40 -0700 (PDT)
Received: from osboxes.zebraskunk.int (cpe-74-136-86-203.kya.res.rr.com. [74.136.86.203])
        by smtp.gmail.com with ESMTPSA id o94sm3091642qtd.34.2020.05.01.10.55.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 10:55:39 -0700 (PDT)
From:   Brett Mastbergen <brett.mastbergen@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] ct: Add support for the 'id' key
Date:   Fri,  1 May 2020 13:55:35 -0400
Message-Id: <20200501175535.4674-1-brett.mastbergen@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'id' key allows for matching on the id of the conntrack entry.

v2: Remove ct_id_type

Signed-off-by: Brett Mastbergen <brett.mastbergen@gmail.com>
---
 doc/payload-expression.txt | 5 ++++-
 src/ct.c                   | 2 ++
 src/parser_bison.y         | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 4bbf8d05..e6f108b1 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -638,7 +638,7 @@ zone id is tied to the given direction. +
 
 [verse]
 *ct* {*state* | *direction* | *status* | *mark* | *expiration* | *helper* | *label*}
-*ct* [*original* | *reply*] {*l3proto* | *protocol* | *bytes* | *packets* | *avgpkt* | *zone*}
+*ct* [*original* | *reply*] {*l3proto* | *protocol* | *bytes* | *packets* | *avgpkt* | *zone* | *id*}
 *ct* {*original* | *reply*} {*proto-src* | *proto-dst*}
 *ct* {*original* | *reply*} {*ip* | *ip6*} {*saddr* | *daddr*}
 
@@ -700,6 +700,9 @@ integer (16 bit)
 |count|
 count number of connections
 integer (32 bit)
+|id|
+Connection id
+ct_id
 |==========================================
 A description of conntrack-specific types listed above can be found sub-section CONNTRACK TYPES above.
 
diff --git a/src/ct.c b/src/ct.c
index db1dabd3..0842c838 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -301,6 +301,8 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_BIG_ENDIAN, 128),
 	[NFT_CT_SECMARK]	= CT_TEMPLATE("secmark", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
+	[NFT_CT_ID]		= CT_TEMPLATE("id", &integer_type,
+					      BYTEORDER_BIG_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b1e869d5..3cd0559b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4550,6 +4550,7 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
 			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
+			|	ID	 	{ $$ = NFT_CT_ID; }
 			|	ct_key_dir_optional
 			;
 
-- 
2.11.0

