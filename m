Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F99C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbiDDMQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbiDDMQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A508A1274C
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7iiQsiwP3r4zoeBv59oo76JG8oH1bE670EjBKVgThN8=; b=piHon2lDLLOs4NJilqopicdVAI
        Ch2bU9awHnsJNToq7Z6owkVnEmOy6o9JaCKFgq1XgNHfHTLojXa3DcQm8mlK8/rk+pypa1D2HktPf
        FmH4ZLGTajR7S7gvpkoNXyqU456BKIXCrJWIaSJft4MPaoIit4BviASVNkls8xR/XvXNr1D9Kok0/
        gg41mxQK0KV99ed11rdH7WMpV9u/TD1A0w+nJcYXFcJHKCDkvyGXz+UU8SjwkQ3nHuuW04SOM26uI
        danTaLMueDjuIIklzCpJKwoVurZUNf1nNdY8D2EkGKKZPev23fJt8PVOOqe168UGtgPkQZHvvj5O3
        CreWtyrg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-L2; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 02/32] include: add missing `#include`
Date:   Mon,  4 Apr 2022 13:13:40 +0100
Message-Id: <20220404121410.188509-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

datatype.h uses bool and so should include <stdbool.h>.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/datatype.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/datatype.h b/include/datatype.h
index f5bb9dc4d937..0b90a33e4e64 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -1,6 +1,7 @@
 #ifndef NFTABLES_DATATYPE_H
 #define NFTABLES_DATATYPE_H
 
+#include <stdbool.h>
 #include <json.h>
 
 /**
-- 
2.35.1

