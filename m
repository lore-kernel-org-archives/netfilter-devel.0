Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857A3C33CB7
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AEA5206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8H/5yQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgA3AQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:16:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726671AbgA3AQs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOqzfSUM4RfxJr4chadpSgROg22XpftxbSWKLoqt+D0=;
        b=Y8H/5yQ+n2jvnGGSMgX7y15Z6sSO2iekZuEvgPzU+hibMxtoSz9Q7BhRsYYtLllOi3SklM
        B2MxukO43Xxt8gFMjhgBsU0zc0fmtuEe+C4JhvyMvYhL0N0bVbr93fms4A6zA2M4TIiDaU
        OLfEIQW9/fuxPOqIBI8AWPDNw1Dthxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-uWEvJQAzN4ilZjuOATiljA-1; Wed, 29 Jan 2020 19:16:43 -0500
X-MC-Unique: uWEvJQAzN4ilZjuOATiljA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE67A13E1;
        Thu, 30 Jan 2020 00:16:41 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DC9919486;
        Thu, 30 Jan 2020 00:16:38 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v4 1/3] include: resync nf_tables.h cache copy
Date:   Thu, 30 Jan 2020 01:16:32 +0100
Message-Id: <e38a9262f994f2273160ec11feb69e4bb74f3aa4.1580342940.git.sbrivio@redhat.com>
In-Reply-To: <cover.1580342940.git.sbrivio@redhat.com>
References: <cover.1580342940.git.sbrivio@redhat.com>
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

