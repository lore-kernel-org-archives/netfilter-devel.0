Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CB6C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D9922CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="o4+1e7aU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfIBXcP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:15 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43984 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V8HKsNI81lfsNthou4GPDYqf5yyziLrMxmteLfuwjm0=; b=o4+1e7aUXmnafLL7Wgs5vP9X4N
        P9tPEdaGfvCPp9Ec1ahKdqRA5jsjJQTQAbQb43+Xf6ioihcwauDqP6rc9UuhHB4Q5zBXa2vDyGmS/
        gse5jOZiiEY/RJYac4S+XWsJ0GfDyb7yAzaO482mAwMKTzq1GlWR5+L+DF/FoxM1zwLO/bPkN7Cop
        ZUdfnTZUlvX9TY5Qt7/RM/+Muma0k7L7JRV94cFmChgQumqa5YjgeQMGB1hQL+jwcPNxcxamxt46N
        WvNRQpEmuWdM0b6T2RF0aRxRoUU93rlWrlJTC1qSk6ns1l2yLEu1OL35TP26ATsEMn7rvQzHpJr9U
        xjwVwc9g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPT-0004la-72; Tue, 03 Sep 2019 00:06:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 29/30] netfilter: add IP_SET_HASH config option.
Date:   Tue,  3 Sep 2019 00:06:49 +0100
Message-Id: <20190902230650.14621-30-jeremy@azazel.net>
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

Add a hidden tristate option which is selected by all the IP_SET_HASH_*
options.  It will be used to wrap ip_set_hash.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/ipset/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
index 8a5498a86df0..56b95e859043 100644
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -58,9 +58,13 @@ config IP_SET_BITMAP_PORT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_SET_HASH
+	tristate
+
 config IP_SET_HASH_IP
 	tristate "hash:ip set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip set type support, by which one
 	  can store arbitrary IPv4 or IPv6 addresses (or network addresses)
@@ -71,6 +75,7 @@ config IP_SET_HASH_IP
 config IP_SET_HASH_IPMARK
 	tristate "hash:ip,mark set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip,mark set type support, by which one
 	  can store IPv4/IPv6 address and mark pairs.
@@ -80,6 +85,7 @@ config IP_SET_HASH_IPMARK
 config IP_SET_HASH_IPPORT
 	tristate "hash:ip,port set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip,port set type support, by which one
 	  can store IPv4/IPv6 address and protocol/port pairs.
@@ -89,6 +95,7 @@ config IP_SET_HASH_IPPORT
 config IP_SET_HASH_IPPORTIP
 	tristate "hash:ip,port,ip set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip,port,ip set type support, by which
 	  one can store IPv4/IPv6 address, protocol/port, and IPv4/IPv6
@@ -99,6 +106,7 @@ config IP_SET_HASH_IPPORTIP
 config IP_SET_HASH_IPPORTNET
 	tristate "hash:ip,port,net set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip,port,net set type support, by which
 	  one can store IPv4/IPv6 address, protocol/port, and IPv4/IPv6
@@ -109,6 +117,7 @@ config IP_SET_HASH_IPPORTNET
 config IP_SET_HASH_IPMAC
 	tristate "hash:ip,mac set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:ip,mac set type support, by which
 	  one can store IPv4/IPv6 address and MAC (ethernet address) pairs in a set.
@@ -118,6 +127,7 @@ config IP_SET_HASH_IPMAC
 config IP_SET_HASH_MAC
 	tristate "hash:mac set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:mac set type support, by which
 	  one can store MAC (ethernet address) elements in a set.
@@ -127,6 +137,7 @@ config IP_SET_HASH_MAC
 config IP_SET_HASH_NETPORTNET
 	tristate "hash:net,port,net set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:net,port,net set type support, by which
 	  one can store two IPv4/IPv6 subnets, and a protocol/port in a set.
@@ -136,6 +147,7 @@ config IP_SET_HASH_NETPORTNET
 config IP_SET_HASH_NET
 	tristate "hash:net set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:net set type support, by which
 	  one can store IPv4/IPv6 network address/prefix elements in a set.
@@ -145,6 +157,7 @@ config IP_SET_HASH_NET
 config IP_SET_HASH_NETNET
 	tristate "hash:net,net set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:net,net  set type support, by which
 	  one can store IPv4/IPv6 network address/prefix pairs in a set.
@@ -154,6 +167,7 @@ config IP_SET_HASH_NETNET
 config IP_SET_HASH_NETPORT
 	tristate "hash:net,port set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:net,port set type support, by which
 	  one can store IPv4/IPv6 network address/prefix and
@@ -164,6 +178,7 @@ config IP_SET_HASH_NETPORT
 config IP_SET_HASH_NETIFACE
 	tristate "hash:net,iface set support"
 	depends on IP_SET
+	select IP_SET_HASH
 	help
 	  This option adds the hash:net,iface set type support, by which
 	  one can store IPv4/IPv6 network address/prefix and
-- 
2.23.0.rc1

