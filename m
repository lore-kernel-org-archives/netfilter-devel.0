Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE24C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBB62073F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 11:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfDOLoW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:44:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52411 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfDOLoW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 07:44:22 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hG022-0002Qe-Os; Mon, 15 Apr 2019 11:44:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [NETFILTER]: nf_conntrack_h323: fix spelling mistake "authenticaton" -> "authentication"
Date:   Mon, 15 Apr 2019 12:44:14 +0100
Message-Id: <20190415114414.24600-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The appears to be a spelling mistake in one of the entries in the
_SecurityCapabilities array. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_conntrack_h323_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
index d880f3523c1d..95a0b3d6b24d 100644
--- a/net/netfilter/nf_conntrack_h323_types.c
+++ b/net/netfilter/nf_conntrack_h323_types.c
@@ -1109,7 +1109,7 @@ static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
 	 _NonStandardParameter},
 	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
-	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,
+	{FNAME("authentication") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
 	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,
 	 _SecurityServiceMode},
-- 
2.20.1

