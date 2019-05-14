Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30677C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECFB520644
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="PFbVHqEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfENPZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 11:25:52 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39234 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfENPZw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 11:25:52 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 180441A3E6E
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 08:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557847552; bh=lU7cxMO/laf6a2IBHueRVgtsrv7feAxh2QjUbKgnomc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFbVHqEobDS05pjb2thMDj4Li7rkbw68zTCK0rIfyDCBfEv3a2JvDalUUlhjoEZOB
         +Ui8byiEs9s73qrGQFhMntpiN6oWYg4/wjesRYVM8srPu+22zgCDWxZ9zJfQqhrrJW
         BOHMdv8UsNapaXw9L8quGIjDHP//u54RB/5fkz84=
X-Riseup-User-ID: B4734669FD95CACEE89126104EC738B7C0110987096C8DACAB91706F2A65171D
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4E54B221BBC;
        Tue, 14 May 2019 08:25:51 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using nft input files
Date:   Tue, 14 May 2019 17:25:42 +0200
Message-Id: <20190514152542.23406-2-ffmancera@riseup.net>
In-Reply-To: <20190514152542.23406-1-ffmancera@riseup.net>
References: <20190514152542.23406-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in 'jump'
statements, e.g.

define dest = chainame

add rule ip filter input jump $dest

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/parser_bison.y | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 69b5773..42fd71f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
 			}
 			;
 
-chain_expr		:	identifier
+chain_expr		:	variable_expr
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       $1->sym->identifier);
+			}
+			|	identifier
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
 							 BYTEORDER_HOST_ENDIAN,
-- 
2.20.1

