Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE293C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE7D6222DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKRVtg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:49:36 -0500
Received: from correo.us.es ([193.147.175.20]:45720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbfKRVtf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F83FEB498
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 539FEA7EE4
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47AC6A7EC5; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3753221FE5;
        Mon, 18 Nov 2019 22:49:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0739542EE38F;
        Mon, 18 Nov 2019 22:49:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/18] netfilter: nft_meta: use 64-bit time arithmetic
Date:   Mon, 18 Nov 2019 22:49:04 +0100
Message-Id: <20191118214914.142794-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

On 32-bit architectures, get_seconds() returns an unsigned 32-bit
time value, which also matches the type used in the nft_meta
code. This will not overflow in year 2038 as a time_t would, but
it still suffers from the overflow problem later on in year 2106.

Change this instance to use the time64_t type consistently
and avoid the deprecated get_seconds().

The nft_meta_weekday() calculation potentially gets a little slower
on 32-bit architectures, but now it has the same behavior as on
64-bit architectures and does not overflow.

Fixes: 63d10e12b00d ("netfilter: nft_meta: support for time matching")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fd21f436347..8fbea031bd4a 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -33,19 +33,19 @@
 
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
-static u8 nft_meta_weekday(unsigned long secs)
+static u8 nft_meta_weekday(time64_t secs)
 {
 	unsigned int dse;
 	u8 wday;
 
 	secs -= NFT_META_SECS_PER_MINUTE * sys_tz.tz_minuteswest;
-	dse = secs / NFT_META_SECS_PER_DAY;
+	dse = div_u64(secs, NFT_META_SECS_PER_DAY);
 	wday = (4 + dse) % NFT_META_DAYS_PER_WEEK;
 
 	return wday;
 }
 
-static u32 nft_meta_hour(unsigned long secs)
+static u32 nft_meta_hour(time64_t secs)
 {
 	struct tm tm;
 
@@ -250,10 +250,10 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store64(dest, ktime_get_real_ns());
 		break;
 	case NFT_META_TIME_DAY:
-		nft_reg_store8(dest, nft_meta_weekday(get_seconds()));
+		nft_reg_store8(dest, nft_meta_weekday(ktime_get_real_seconds()));
 		break;
 	case NFT_META_TIME_HOUR:
-		*dest = nft_meta_hour(get_seconds());
+		*dest = nft_meta_hour(ktime_get_real_seconds());
 		break;
 	default:
 		WARN_ON(1);
-- 
2.11.0

