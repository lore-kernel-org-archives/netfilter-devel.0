Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97CFC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89539206BA
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="WvcDWdEp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfCKPPG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:15:06 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50624 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727216AbfCKPPG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:15:06 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 678701A5EB5
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 08:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552317305; bh=lcCEIVR8KU/sJEGcf9nuMIXsay450k8dwz4LpOvcKjA=;
        h=From:To:Cc:Subject:Date:From;
        b=WvcDWdEpXhPBz1QxkST+hSJu3F4eKoctNuWdnzDzI9qlLfU5rvkVtYPxjTBJyx0HJ
         WqPsGBLpckkE/6rtaUXYaadEMNWc8MYsQ6Mz4AdnLyYFi0uCcD+CvP6G69Dj6oexty
         aufj5dTPEapjdCeCyqBRjvWLDD2tkp+ZouFEah2s=
X-Riseup-User-ID: 558392604D802AD3800A09B6A9F2C856EC690ABAF90F7539EB8BECDFB7388907
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 846941202A8;
        Mon, 11 Mar 2019 08:15:04 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH libnftnl v2] expr: osf: add version option support
Date:   Mon, 11 Mar 2019 16:14:56 +0100
Message-Id: <20190311151456.17845-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: flags type is now uint32_t
---
 include/libnftnl/expr.h             |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/osf.c                      | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 3d99d24..b2f8d75 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -280,6 +280,7 @@ enum {
 enum {
 	NFTNL_EXPR_OSF_DREG	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_OSF_TTL,
+	NFTNL_EXPR_OSF_FLAGS,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ac6de5e..fd38cdc 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -940,11 +940,13 @@ enum nft_socket_keys {
  *
  * @NFTA_OSF_DREG: destination register (NLA_U32)
  * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
  */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
 	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
 	__NFTA_OSF_MAX,
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
diff --git a/src/expr/osf.c b/src/expr/osf.c
index 52da21f..98d0df9 100644
--- a/src/expr/osf.c
+++ b/src/expr/osf.c
@@ -15,6 +15,7 @@
 struct nftnl_expr_osf {
 	enum nft_registers	dreg;
 	uint8_t			ttl;
+	uint32_t		flags;
 };
 
 static int nftnl_expr_osf_set(struct nftnl_expr *e, uint16_t type,
@@ -29,6 +30,9 @@ static int nftnl_expr_osf_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_OSF_TTL:
 		memcpy(&osf->ttl, data, sizeof(osf->ttl));
 		break;
+	case NFTNL_EXPR_OSF_FLAGS:
+		memcpy(&osf->flags, data, sizeof(osf->flags));
+		break;
 	}
 	return 0;
 }
@@ -46,6 +50,9 @@ nftnl_expr_osf_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_OSF_TTL:
 		*data_len = sizeof(osf->ttl);
 		return &osf->ttl;
+	case NFTNL_EXPR_OSF_FLAGS:
+		*data_len = sizeof(osf->flags);
+		return &osf->flags;
 	}
 	return NULL;
 }
@@ -60,6 +67,7 @@ static int nftnl_expr_osf_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTNL_EXPR_OSF_DREG:
+	case NFTNL_EXPR_OSF_FLAGS:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
@@ -68,6 +76,7 @@ static int nftnl_expr_osf_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
 			abi_breakage();
 		break;
+
 	}
 
 	tb[type] = attr;
@@ -83,6 +92,9 @@ nftnl_expr_osf_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTNL_EXPR_OSF_DREG, htonl(osf->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_OSF_TTL))
 		mnl_attr_put_u8(nlh, NFTNL_EXPR_OSF_TTL, osf->ttl);
+	if (e->flags & (1 << NFTNL_EXPR_OSF_FLAGS))
+		if (osf->flags)
+			mnl_attr_put_u32(nlh, NFTNL_EXPR_OSF_FLAGS, htonl(osf->flags));
 }
 
 static int
@@ -104,6 +116,11 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
 		e->flags |= (1 << NFTNL_EXPR_OSF_TTL);
 	}
 
+	if (tb[NFTA_OSF_FLAGS]) {
+		osf->flags = ntohl(mnl_attr_get_u32(tb[NFTA_OSF_FLAGS]));
+		e->flags |= (1 << NFTNL_EXPR_OSF_FLAGS);
+	}
+
 	return 0;
 }
 
-- 
2.20.1

