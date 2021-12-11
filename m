Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BBFC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Dec 2021 18:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhLKSzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Dec 2021 13:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhLKSzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Dec 2021 13:55:32 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684A6C061751
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Dec 2021 10:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZzxdrkI52cbXbFsaJzGnmfKn9XKSHXHx6/V4orXgT8s=; b=mzljEljtn9Ijkjd+HP6t+IwLBO
        Nejd5GMoCgG3xvnNx8jrZDyejKdzjge6E6VpHnIUcZkY3EkJf7/d3tes3IkM4QEsq46D1KuAXJXsl
        nXBs+CtDAFqRF1hBjpjwxG7bH/ncp6XwJQpCd+qhdtdT3maVlPEa9fL0k6fav3gtBa9WqJgWXF8v1
        JKbd/Sy6Mshm2aAOtM/Zns0/wtKvWHZfwFIcIyaCXBgJ7kOtMnK3OvSur93uc+1NAYZG9004nsjWW
        OKra9K7SzZ8YPWc9oGA6TZxaptGWeRIEev3FVrGvQwxN2EVdK7WovnRdQFaLhOp7yatnNXObRPaOZ
        pMAoBpJQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mw7Ws-004cqg-0w
        for netfilter-devel@vger.kernel.org; Sat, 11 Dec 2021 18:55:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 1/3] proto: short-circuit loops over upper protocols
Date:   Sat, 11 Dec 2021 18:55:23 +0000
Message-Id: <20211211185525.20527-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211211185525.20527-1-jeremy@azazel.net>
References: <20211211185525.20527-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each `struct proto_desc` contains a fixed-size array of higher layer
protocols.  Only the first few are not NULL.  Therefore, we can stop
iterating over the array once we reach a NULL member.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/proto.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index fe58c83a9295..31a2f38065ad 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -59,7 +59,8 @@ proto_find_upper(const struct proto_desc *base, unsigned int num)
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(base->protocols); i++) {
+	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
+	     i++) {
 		if (base->protocols[i].num == num)
 			return base->protocols[i].desc;
 	}
@@ -77,7 +78,8 @@ int proto_find_num(const struct proto_desc *base,
 {
 	unsigned int i;
 
-	for (i = 0; i < array_size(base->protocols); i++) {
+	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
+	     i++) {
 		if (base->protocols[i].desc == desc)
 			return base->protocols[i].num;
 	}
@@ -105,7 +107,9 @@ int proto_dev_type(const struct proto_desc *desc, uint16_t *res)
 			*res = dev_proto_desc[i].type;
 			return 0;
 		}
-		for (j = 0; j < array_size(base->protocols); j++) {
+		for (j = 0; j < array_size(base->protocols) &&
+			     base->protocols[j].desc;
+		     j++) {
 			if (base->protocols[j].desc == desc) {
 				*res = dev_proto_desc[i].type;
 				return 0;
-- 
2.33.0

