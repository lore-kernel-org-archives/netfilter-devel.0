Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B086FC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 843A9206BB
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="g6iziEko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfIML44 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:56:56 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58442 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfIML4z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:56:55 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 7547B1A0C73
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 04:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1568375815; bh=Jri8nWH/AROpLE5ZKMJmxwgRC1vEeh3Xt61/1Ucepi0=;
        h=From:To:Cc:Subject:Date:From;
        b=g6iziEkosjs6OCQpv91P9OKHmbPc6QZ/nknKGo0YfiD5JJ4ZdEcjPJ+u7dv7sASUM
         G/9hndn5EUSXf2Q/RHkElwGzDFF6qEGI99NZsA514WXfW0SdJKC9IK0EQ5V+vzw4KB
         Cnsp0tBvDpxyHKGEPH5G4me+MsOcaM2SDoSXqS6A=
X-Riseup-User-ID: 3453DF6B889FE5727E88D8274B670FB77782C29CB6B3D4F55C43B225571BE124
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 97834223A0D;
        Fri, 13 Sep 2019 04:56:54 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: fix type mismatch on "ct expect" json exporting
Date:   Fri, 13 Sep 2019 13:56:59 +0200
Message-Id: <20190913115658.10330-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The size field in ct_expect struct should be parsed as json integer and not as
a string. Also, l3proto field is parsed as string and not as an integer. That
was causing a segmentation fault when exporting "ct expect" objects as json.

Fixes: 1dd08fcfa07a ("src: add ct expectations support")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/json.c b/src/json.c
index 55ce053..7aa4b69 100644
--- a/src/json.c
+++ b/src/json.c
@@ -333,7 +333,7 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_CT_EXPECT:
-		tmp = json_pack("{s:o, s:I, s:I, s:s, s:I}",
+		tmp = json_pack("{s:o, s:I, s:I, s:I, s:s}",
 				"protocol",
 				proto_name_json(obj->ct_expect.l4proto),
 				"dport", obj->ct_expect.dport,
-- 
2.20.1

