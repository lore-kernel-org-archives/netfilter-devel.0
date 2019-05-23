Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D152C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1D220863
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k73cPQJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfEWN3Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:29:25 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51686 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbfEWN3Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:29:24 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so9687155itl.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 06:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9rh+VGZJpi4a6z2GXbeZge7rPQByt4+TPIyDI4ETroA=;
        b=k73cPQJgbob7pJD+ay8llIQwXsIZNiKx0hsH3IaZqD5sYmPSvzH/qtP5rGq/RzShfU
         R5hozoyciDnc4JYx04y1CsPPqZoASo6VTtuZMOrcBIrwuOwdJBLf1eTfPZUQF260zeY0
         +c7WOEEFW5b9vrEqxl03Pw0YcJPgnD5q87KuHbWzUW3UpDgctTtwWrDFQgAXuCIgoxCZ
         DqdwcU3VTlWdziuo00pF0F6wbjlOMAZSJK6Z4yiUm6xqV07F1FXhmlXrEy+mvYSw5gPL
         Ya9HfwErWDFEke+YCkLFGwujvVKZdQIlHTg5lvkgUMKaWp6zMmQrebzV+hJTFLeY20Xs
         sbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9rh+VGZJpi4a6z2GXbeZge7rPQByt4+TPIyDI4ETroA=;
        b=Uv7osPWLBQI4u/lKNylIMD26zjuwvki4+ZhMjGh1r6o2Lelg3D3hHQHuFwRjjdTFXc
         +9Oe5E1ZUpp1DwGjpwiVzCyHbrOJs33PKrvjNaRciRHyAUsrSneMT5Q21Bby+l6wgQ/Q
         rbd2SWhvT4MwXBvkbLB/Rpmrkf6lDPjfHve3x6cnY+YmGL3YNVvGxRHqK/D5JfG2spSb
         qLQ51fFENwB8bOMS1tCGnwjoFObE8gyZL4t8+B7uWhLDmu+lF9Be0thvtXnre/Xx9IW7
         bmhA/2apKKkbR7T4u7ySnFVgFWv2ZXmTCzK2+fha98YFIDLQqJqukrNccvkMVYd/9Ofs
         kbwg==
X-Gm-Message-State: APjAAAVNceH4HS7mz0EuOLWJXArQSXR9r/UU/NYMwy8YWRAXodoqfvml
        bP3YcvNDImgGrTqG/c1Ss9UyhkA=
X-Google-Smtp-Source: APXvYqxy9Dock3fwUkVFN92OcCreXUTxtLySqHACvaO44llb46ymtYNnrkZ/6q3/blbPeccXKeWJ2Q==
X-Received: by 2002:a02:7690:: with SMTP id z138mr27590270jab.85.1558618163929;
        Thu, 23 May 2019 06:29:23 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id l13sm4088962iti.6.2019.05.23.06.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:29:23 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH libnftnl] src: libnftnl: add support for matching IPv4 options
Date:   Thu, 23 May 2019 05:41:13 -0400
Message-Id: <20190523094113.3810-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the libnftnl change for the overall changes with this
description:
Add capability to have rules matching IPv4 options. This is developed
mainly to support dropping of IP packets with loose and/or strict source
route route options. Nevertheless, the implementation include others and
ability to get specific fields in the option.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/exthdr.c                   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fd38cdc..a5e9bf3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -729,10 +729,12 @@ enum nft_exthdr_flags {
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
+ * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
+	NFT_EXTHDR_OP_IPV4,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index bef453e..e5f714b 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -200,6 +200,9 @@ static const char *op2str(uint8_t op)
 	case NFT_EXTHDR_OP_TCPOPT:
 		return " tcpopt";
 	case NFT_EXTHDR_OP_IPV6:
+		return " ipv6";
+	case NFT_EXTHDR_OP_IPV4:
+		return " ipv4";
 	default:
 		return "";
 	}
@@ -209,6 +212,8 @@ static inline int str2exthdr_op(const char* str)
 {
 	if (!strcmp(str, "tcpopt"))
 		return NFT_EXTHDR_OP_TCPOPT;
+	if (!strcmp(str, "ipv4"))
+		return NFT_EXTHDR_OP_IPV4;
 
 	/* if str == "ipv6" or anything else */
 	return NFT_EXTHDR_OP_IPV6;
-- 
2.17.1

