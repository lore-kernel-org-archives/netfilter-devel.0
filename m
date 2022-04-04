Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A7DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbiDDMQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbiDDMQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624EF11C26
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JP6lNGFOZbVbXTqkSCWL4ptQII2vvvUq+rBve6AS/Kg=; b=HewKrAB7cFddoMHQuWda7nKuSw
        FZPi/DBrdFaXH1UAxWyxL25MwZE813jRj5aIpM4EDAQGEHF3/I4OzNFXSFUzd+mV96KD3P7Je6Hmc
        W8iuzfPzaxjJj7LS26DVi1Tp7HsRwv1BgI7FM0iNvwkffrc/96D3LRDTNlwygu34LqGEBoVIprAqa
        kz3HdChu5brDjOcV1rrXWXJKUuIxyntXIA9X3f7LCcknA+Bw5FjvAdQmCBoXmsqQ2BD3bhYk86KWw
        Gc4bqXf/LIua0JZUMytEXKtXJnIs0lu607IWDv9C3T1k7qthZgd7mVvYa3pM1EtdAUAGHwyXRDO19
        6wloQi4w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-Gy; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 01/32] examples: add .gitignore file
Date:   Mon,  4 Apr 2022 13:13:39 +0100
Message-Id: <20220404121410.188509-2-jeremy@azazel.net>
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

---
 examples/.gitignore | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 examples/.gitignore

diff --git a/examples/.gitignore b/examples/.gitignore
new file mode 100644
index 000000000000..7b1a583c687e
--- /dev/null
+++ b/examples/.gitignore
@@ -0,0 +1,5 @@
+/.deps/
+/.libs/
+/nft-buffer
+/nft-json-file
+/*.o
-- 
2.35.1

