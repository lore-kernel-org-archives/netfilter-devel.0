Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B07AC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F30A4205C9
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ty/4j8cR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfHNIB3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:01:29 -0400
Received: from kadath.azazel.net ([81.187.231.250]:48346 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNIB3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LV7AqxmZ4FSNfTZLYXKQVHMMyBbDJAvcQqEqNRhUNYw=; b=ty/4j8cRrgERrywyn/Jr5FWzPO
        SHYFZ/0+p0OORCv6219/KD2NPZaNT/0HpWUL/IbC972AzLqbFlv/wMvJw714phzYYghv9wEdHD0U1
        GrAOj9q9EDgP3n0yQWt2tY7yTFTsLX/+9HLZpE7L4ETxTJbF9E41sZ1FVcLbQE6qC+tbr9VcfTEuy
        eUlafGG4jRxA00j5zdm1apKwW+6Oz0eFS/0dwUa8+IJG3Wcn1BQHao9zSZDGd8QKab3zUSWWGulP7
        VEr1jiZkKFQ/BLwVCI5bH6hJeDH8yhPx3/H0t/rV5adlEgFzmrOfk1cDlMh7vtWD8ImZvSXbLD9lz
        x+5fY3Ww==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hxoDo-0007Df-GN; Wed, 14 Aug 2019 09:01:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH nf-next] netfilter: remove deprecation warnings from uapi headers.
Date:   Wed, 14 Aug 2019 09:01:28 +0100
Message-Id: <20190814080128.8015-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814074539.ort2lumte4gw3oix@salvia>
References: <20190814074539.ort2lumte4gw3oix@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are two netfilter userspace headers which contain deprecation
warnings.  While these headers are not used within the kernel, they are
compiled stand-alone for header-testing.

Pablo informs me that userspace iptables still refer to these headers,
and the intention was to use xt_LOG.h instead and remove these, but
userspace was never updated.

Remove the warnings.

Fixes: 2a475c409fe8 ("kbuild: remove all netfilter headers from header-test blacklist.")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter_ipv4/ipt_LOG.h  | 2 --
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ipt_LOG.h b/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
index 6dec14ba851b..b7cf2c669f40 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_LOG.h
@@ -2,8 +2,6 @@
 #ifndef _IPT_LOG_H
 #define _IPT_LOG_H
 
-#warning "Please update iptables, this file will be removed soon!"
-
 /* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
 #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
index 7553a434e4da..23e91a9c2583 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_LOG.h
@@ -2,8 +2,6 @@
 #ifndef _IP6T_LOG_H
 #define _IP6T_LOG_H
 
-#warning "Please update iptables, this file will be removed soon!"
-
 /* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
 #define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
-- 
2.20.1

