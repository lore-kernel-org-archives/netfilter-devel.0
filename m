Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4D0C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3014B206E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCTKCIoy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfFTLzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 07:55:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45234 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfFTLzd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 07:55:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so1296560plb.12
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 04:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M33SKwKpfBnDABV63w4OO4MYwMLAAO4cPQ6Izejnt/4=;
        b=vCTKCIoytOslr1G9T7bpmNAzCc/94N5MKGNgQgJBs8V4keGVPBvltBnWD5+D9LzxVl
         CbOr/P9KXTeZlLDrf7rFkNlqPij5YLYMKGXwP2EEuZrex4GhUW26zAvoLG7wKCzoJJT/
         xS/4IRfB/UzaQzylr3BcYYpUK8gEvR4UQVGfy6WeSfygFpjvOMwVfPAzJNHPijKzxVqL
         u4VAhY5fjtSAlJckUflcScya4GkLJwaUqzERlbPvw0j/3OvTiXtgge9ZFeQGSQSkDuXC
         QTfA/4JTna9X9ShJHb66IVACbSb+OErfMsJlvyWWnPv/9y0kVxwM0VGRltlBvvspPG0Q
         368A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M33SKwKpfBnDABV63w4OO4MYwMLAAO4cPQ6Izejnt/4=;
        b=jin37QWjxO9A8xBQnUhFEzKPSSiZxDALYGz5SYZLUPP8gM7mCHFF51vZV0Q0k4gUhl
         LrYuFUmryMQsvHCO4Dg9fVblhBibouR2kzFj1z4eXnMrFDfvdEC5xiRy7VcYtD4ihY9w
         gk3neZuozrBoS3KU1Pviy0/5wZADMpJmJ5rWLdnEqEEaw0yFCvJkzIL6fT120LP2klRI
         ZEmwLsTn6eU8zyVZs2WTy479G1Uu53FPKNwfZbg5i+2Ya6npgdTMiwHzpSUaCObGbqTb
         c/FPnC/nmP1FVrYgNlshA/qe/8rDyq8LHgbLCSE4rm2A3VcP+1+/1ec60H1+NqfZ9JQN
         5UTg==
X-Gm-Message-State: APjAAAVZOk7OWb6uPShRtpQ3ENCVEsdT+JsfpH9mic0J9ufVMaqBbTpP
        ymIMlNLwkA8AgzSCvjObo+zHV9i8Pg==
X-Google-Smtp-Source: APXvYqz2ZfuXPWKDBj2bZWf4M17bbJnypHxR54XsGKMFZ1hBR4QX3CIFfPLV7DzargS/GBXyMZJzEw==
X-Received: by 2002:a17:902:7c03:: with SMTP id x3mr100266332pll.242.1561031732587;
        Thu, 20 Jun 2019 04:55:32 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id u5sm19376869pgp.19.2019.06.20.04.55.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 04:55:31 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH libnftnl v2] src: libnftnl: add support for matching IPv4 options
Date:   Thu, 20 Jun 2019 07:54:29 -0400
Message-Id: <20190620115429.3678-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the libnftnl change for the overall changes with this
description:
Add capability to have rules matching IPv4 options. This is developed
mainly to support dropping of IP packets with loose and/or strict source
route route options.

v2: Remove statements about supporting other options to reflect what are
    supported in the kernel.
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

