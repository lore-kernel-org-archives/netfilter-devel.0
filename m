Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EA0C35240
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F010F206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTJsEuI2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgA3ARJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:17:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgA3ARJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOqzfSUM4RfxJr4chadpSgROg22XpftxbSWKLoqt+D0=;
        b=KTJsEuI2pobTBvQBtTF5GOi786KlrXIzQN5z1WFcb1nr3dr9uE6kCMbFxNDi0Lknffgzkm
        VbsmcvWgF0E786Cj+PsC7V4Pyh2tPEp2VcwUCcU832tiPrVdamwdamUZVWfRpYKoptxwao
        gGnldWhNnqXvNz7T4/LL8OobKhxAfQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-Mm65mN44Og2Es3kkNhPIUw-1; Wed, 29 Jan 2020 19:17:06 -0500
X-MC-Unique: Mm65mN44Og2Es3kkNhPIUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 550DD13E1;
        Thu, 30 Jan 2020 00:17:05 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA86219486;
        Thu, 30 Jan 2020 00:17:02 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v4 1/4] include: resync nf_tables.h cache copy
Date:   Thu, 30 Jan 2020 01:16:55 +0100
Message-Id: <4783c22e0cd95bfac0b15a924cf9452b84cf71df.1580342294.git.sbrivio@redhat.com>
In-Reply-To: <cover.1580342294.git.sbrivio@redhat.com>
References: <cover.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get this header in sync with nf-next as of merge commit
b3a608222336 (5.6-rc1-ish).

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: New patch

 include/linux/netfilter/nf_tables.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilte=
r/nf_tables.h
index 261864736b26..065218a20bb7 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
=20
 #define NFT_REG_SIZE	16
 #define NFT_REG32_SIZE	4
+#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
=20
 /**
  * enum nft_verdicts - nf_tables internal verdicts
@@ -301,14 +302,28 @@ enum nft_set_policies {
  * enum nft_set_desc_attributes - set element description
  *
  * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ * @NFTA_SET_DESC_CONCAT: description of field concatenation (NLA_NESTED=
)
  */
 enum nft_set_desc_attributes {
 	NFTA_SET_DESC_UNSPEC,
 	NFTA_SET_DESC_SIZE,
+	NFTA_SET_DESC_CONCAT,
 	__NFTA_SET_DESC_MAX
 };
 #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
=20
+/**
+ * enum nft_set_field_attributes - attributes of concatenated fields
+ *
+ * @NFTA_SET_FIELD_LEN: length of single field, in bits (NLA_U32)
+ */
+enum nft_set_field_attributes {
+	NFTA_SET_FIELD_UNSPEC,
+	NFTA_SET_FIELD_LEN,
+	__NFTA_SET_FIELD_MAX
+};
+#define NFTA_SET_FIELD_MAX	(__NFTA_SET_FIELD_MAX - 1)
+
 /**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
@@ -370,6 +385,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
+ * @NFTA_SET_ELEM_KEY_END: closing key value (NLA_NESTED: nft_data)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -382,6 +398,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_EXPR,
 	NFTA_SET_ELEM_PAD,
 	NFTA_SET_ELEM_OBJREF,
+	NFTA_SET_ELEM_KEY_END,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
--=20
2.24.1

