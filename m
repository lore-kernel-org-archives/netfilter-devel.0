Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6805CC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 15:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1938264EC0
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 15:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSPMj convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 10:12:39 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:28122 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhBSPMd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 10:12:33 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-kvJ3O5JQO7axUQgLigr2Yw-1; Fri, 19 Feb 2021 10:11:30 -0500
X-MC-Unique: kvJ3O5JQO7axUQgLigr2Yw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F62E18449E2;
        Fri, 19 Feb 2021 15:11:29 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-120-99.rdu2.redhat.com [10.10.120.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F7946085D;
        Fri, 19 Feb 2021 15:11:28 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] json: init parser state for every new buffer/file
Date:   Fri, 19 Feb 2021 10:11:26 -0500
Message-Id: <20210219151126.3544581-1-eric@garver.life>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric@garver.life
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise invalid error states cause subsequent json parsing to fail
when it should not.

Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 2d132caf529c..ddbf9d9c027b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3893,6 +3893,7 @@ int nft_parse_json_buffer(struct nft_ctx *nft, const char *buf,
 	};
 	int ret;
 
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->json_root = json_loads(buf, 0, NULL);
 	if (!nft->json_root)
 		return -EINVAL;
@@ -3921,6 +3922,7 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	json_error_t err;
 	int ret;
 
+	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->json_root = json_load_file(filename, 0, &err);
 	if (!nft->json_root)
 		return -EINVAL;
-- 
2.29.2

