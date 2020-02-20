Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8FAC11D0C
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 17:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F22E20801
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 17:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBTRMx convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:12:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728619AbgBTRMx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 12:12:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-wBzZcWijP4GliM_TPvrhyw-1; Thu, 20 Feb 2020 12:12:45 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83121B7481B;
        Thu, 20 Feb 2020 17:12:44 +0000 (UTC)
Received: from egarver.redhat.com (ovpn-121-46.rdu2.redhat.com [10.10.121.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17EC35C28E;
        Thu, 20 Feb 2020 17:12:43 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH 1/2] parser_json: fix parsing prefix inside concat
Date:   Thu, 20 Feb 2020 12:12:41 -0500
Message-Id: <20200220171242.15240-1-eric@garver.life>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: wBzZcWijP4GliM_TPvrhyw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Found while testing set intervals + concatenations. Thanks to Stefano
Brivio for pointing me to the fix.

Signed-off-by: Eric Garver <eric@garver.life>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 85082ccee7ef..77abca032902 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1058,7 +1058,7 @@ static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
 	}
 
 	json_array_foreach(root, index, value) {
-		tmp = json_parse_primary_expr(ctx, value);
+		tmp = json_parse_rhs_expr(ctx, value);
 		if (!tmp) {
 			json_error(ctx, "Parsing expr at index %zd failed.", index);
 			expr_free(expr);
-- 
2.23.0

