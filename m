Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB982C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8D56208C2
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="rY6e/eVr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbfIMINZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:13:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60600 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbfIMINY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2I4/46mfleS42WmYq2LwPDYUhYxLEACXnhd4/Wk6l48=; b=rY6e/eVrIOnHauZ0FIIveV1II2
        wRFHsrt0j1xUTfTEvdvbl8BIUegKp8ggHWdE/2rm1vdgyt/G2pXPsEMCHsf+Enuhcdak/0PYxoEz7
        mExU+bMkPBbteC9uvmMNxAN3M0oCnNVTdxWPVsa+D6SGnm3tnhIOlSRUXY71OgivYavNCUp0WShmd
        P5kh5VYo4kYOkSobssFifduq0T8YuYPuBUVvbjHoXCcuCkh7hw4n0CWMqjgjOnz1Hj3U5s0exRix2
        xZc1d9r7RnrKex5WW4HXu7H/uOs2yMIFU+zYRXgi/p25km3bmuQ2nXrF1mGq0Bdo2Qfk5X8pwNhlX
        ge7fjp/w==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghk-0005yL-3X; Fri, 13 Sep 2019 09:13:20 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 03/18] netfilter: remove unused function declarations.
Date:   Fri, 13 Sep 2019 09:13:03 +0100
Message-Id: <20190913081318.16071-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two headers include declarations of functions which are never defined.
Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter_ipv4/ip_tables.h  | 2 --
 include/linux/netfilter_ipv6/ip6_tables.h | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index f40a65481df4..0b0d43ad9ed9 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -23,8 +23,6 @@
 #include <linux/init.h>
 #include <uapi/linux/netfilter_ipv4/ip_tables.h>
 
-extern void ipt_init(void) __init;
-
 #if IS_ENABLED(CONFIG_NETFILTER)
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 53b7309613bf..666450c117bf 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -23,9 +23,8 @@
 #include <linux/init.h>
 #include <uapi/linux/netfilter_ipv6/ip6_tables.h>
 
-extern void ip6t_init(void) __init;
-
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
+
 #if IS_ENABLED(CONFIG_NETFILTER)
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
-- 
2.23.0

