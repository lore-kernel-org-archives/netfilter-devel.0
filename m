Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43609C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384599AbiEFLpZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391458AbiEFLpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:45:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B2462BF7
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tBlDyk91OTCRJqJw/CXPgzqIu9M1yUQqHvYynwPeO94=; b=mhPZnvmPpQP9eL0Yw3zqvSxZlK
        et+SOnkXm7GXEiSgyVP/apzFoSWTn8DSMog/ISI9oHrrqHKQqPCsLSNgka8vlUYX9ABIQEp6YQ0VZ
        qiX2J97A34f5VOwFU9gW5r6C9awMw5Vl5dWgQAQ2SxPs042Ng1KzfAHxrN9EVNuQQJVjQ0BWqHSUI
        020WnkK89U2kl4jropjI91NrrA8b44A9e+5cbXRVqtSiHwBvFZ+OIOo1Jgt+gP95c37xvs9xFJVwF
        v0a7WM96CQPufTSfBxTaf4b6YfpqC001cd+kmI9MtRKvbyoSUtE1SYStB6BKf17k+oI2kVD5PHz3x
        Zn8co9MQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwL6-0005r4-3l; Fri, 06 May 2022 13:41:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] libxtables: Revert change to struct xtables_pprot
Date:   Fri,  6 May 2022 13:41:04 +0200
Message-Id: <20220506114104.7344-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506114104.7344-1-phil@nwl.cc>
References: <20220506114104.7344-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While protocol values may exceed eight bits, the data structure is
indeed used only to store the static list of name/value pairs for faster
lookups. None of those has such a value and if one is added in future,
the compiler will complain about it.

So restore the old field type to retain binary compatibility.

Fixes: 556f704458cdb ("Use proto_to_name() from xshared in more places")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xtables.h b/include/xtables.h
index 8c1065bc7e010..c2694b7b28886 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -395,7 +395,7 @@ struct xtables_rule_match {
  */
 struct xtables_pprot {
 	const char *name;
-	uint16_t num;
+	uint8_t num;
 };
 
 enum xtables_tryload {
-- 
2.34.1

