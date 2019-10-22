Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7033FCA9EB7
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3603E20679
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MeVZfz/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44374 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731193AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bpAIAOoKyt9TArIYO0pao/9MpXlo6vYLY2uejujR4+o=; b=MeVZfz/KTIxfvOWlbPpPlex5hD
        RsFdtxo+PCzQTbLxXizjUJb2HdAtWEfCNflwXJbo8ZJL7RrRYzR60vTH8KsOvzp9NfJvmLToG9nOR
        /9EfdA3xEPT+FmcI/dyW6vbmYYMbtTREJ2fEuIJ6tnbqePELzMySnpdloki+EGacVxuDsK07V6HKT
        +OCjvgi2/DZaE2Lj68veGuzqjdHeuyfA/EYSaRa1hFIQRG17AloS/+L57S5EqmKuXPbJfGvybfVXP
        4nErOenAxVXnXJ6kQC6+KwqUn/If794AYXCYvM+TCIC7QaAEyh8YJmFVcAOrWmDzOLYLQQH1ys4Rk
        SdOyCicg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iN1F1-0002CC-C4; Tue, 22 Oct 2019 21:58:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 1/4] doc: add missing output flag documentation.
Date:   Tue, 22 Oct 2019 21:58:52 +0100
Message-Id: <20191022205855.22507-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191022205855.22507-1-jeremy@azazel.net>
References: <20191022205855.22507-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The documentation for NFT_CTX_OUTPUT_FLAG_NUMERIC_TIME and
NFT_CTX_OUTPUT_FLAG_NUMERIC_ALL is incomplete.  Add the missing bits.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/libnftables.adoc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 8ce1196fd47e..ce4a361b84cc 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -90,6 +90,10 @@ enum {
         NFT_CTX_OUTPUT_NUMERIC_PROTO  = (1 << 7),
         NFT_CTX_OUTPUT_NUMERIC_PRIO   = (1 << 8),
         NFT_CTX_OUTPUT_NUMERIC_SYMBOL = (1 << 9),
+        NFT_CTX_OUTPUT_NUMERIC_TIME   = (1 << 10),
+        NFT_CTX_OUTPUT_NUMERIC_ALL    = (NFT_CTX_OUTPUT_NUMERIC_PROTO |
+                                         NFT_CTX_OUTPUT_NUMERIC_PRIO  |
+                                         NFT_CTX_OUTPUT_NUMERIC_TIME),
         NFT_CTX_OUTPUT_TERSE          = (1 << 11),
 };
 ----
@@ -122,6 +126,8 @@ NFT_CTX_OUTPUT_NUMERIC_PRIO::
 	Display base chain priority numerically.
 NFT_CTX_OUTPUT_NUMERIC_SYMBOL::
 	Display expression datatype as numeric value.
+NFT_CTX_OUTPUT_NUMERIC_TIME::
+	Display time, day and hour values in numeric format.
 NFT_CTX_OUTPUT_NUMERIC_ALL::
 	Display all numerically.
 NFT_CTX_OUTPUT_TERSE::
-- 
2.23.0

