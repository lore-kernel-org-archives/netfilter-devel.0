Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBD1C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978AC22CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KWh1eP/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfIBXcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44094 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mSISNai2GqNQP2gJLIEvO2gb5mq+2VH1PXpfQQTziiM=; b=KWh1eP/NIzlJB6wcGWtuZRGJjy
        1lj5M8PKq4IGUehzScL+IKamwmLVmSxNfDqqJzv/0+NVpqLXKRHdykLFD+LvZ2V6+3jvlmFa0d98r
        r9HYMeBmTcJVxAG7uCDbqqfYYDq+KNGBSY31MA7q4nqsrqgKOT8JO3xP+fI4ViJosvG8ABNQWWjzQ
        7Bu7+i6bDpmIWYY1Bu5QxGz394NDG1qciy1nLdm+SFMsb8hkPJfx+skIc0/rN75GzvB7zH8JRexL8
        CQUUVphUANEnpTDf1+6xvA3sj7/f4AdDHO/HYooiUap2lAdJUYX4mE7i+uIK2lNEgezHXNlK5LC5c
        ChpxTmIQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPS-0004la-Uw; Tue, 03 Sep 2019 00:06:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 27/30] netfilter: add NF_TPROXY config option.
Date:   Tue,  3 Sep 2019 00:06:47 +0100
Message-Id: <20190902230650.14621-28-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a hidden tristate option which is select by NF_TPROXY_IPV4 and
NF_TPROXY_IPV6.  It will be used to wrap nf_tproxy.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/ipv4/netfilter/Kconfig | 1 +
 net/ipv6/netfilter/Kconfig | 1 +
 net/netfilter/Kconfig      | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index f17b402111ce..50c02bd80ca7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -18,6 +18,7 @@ config NF_SOCKET_IPV4
 
 config NF_TPROXY_IPV4
 	tristate "IPv4 tproxy support"
+        select NF_TPROXY
 
 if NF_TABLES
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6120a7800975..273803f008f9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -14,6 +14,7 @@ config NF_SOCKET_IPV6
 
 config NF_TPROXY_IPV6
 	tristate "IPv6 tproxy support"
+        select NF_TPROXY
 
 if NF_TABLES
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 34ec7afec116..7118352c78c4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -439,6 +439,9 @@ config NETFILTER_SYNPROXY
 
 endif # NF_CONNTRACK
 
+config NF_TPROXY
+        tristate
+
 config NF_TABLES
 	select NETFILTER_NETLINK
 	tristate "Netfilter nf_tables support"
-- 
2.23.0.rc1

