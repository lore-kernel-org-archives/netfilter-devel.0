Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056D5C6FD19
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCEKaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCEKaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:06 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE43D516
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I2y2kXH9wqfiEMhgsOeDtlMf0mhKkBWcNIvCWpO4gRI=; b=n2RPMNfNWjoWNdJlvIPRz4F26h
        WUY+qceu20EuJeN9MTSjVbCOnsl/D1TV1hetTRixOPh6bX5u3gzFOjQRAipH23mDYJH2Ef5V0ut66
        udTSeO9SnB6ySpTpGoL7sMLuUzTCPFlSbqrv4qAcssqfZsRD+IWPTaQkoTeMjAG3PXqCST0WRX9wr
        NkgyOKXMuQOrolRns1cEIv+w4I58UpclxKxOFIdIyY3RT1www+qnMklrb9cn2XaLkL6jw3u0jeFBC
        alvRuN4DSXLlg4+OJOXiDIs+iS2XOqDCN2l3A3dTy4duBkPHqu2PtPDJ0m+3qajKIikZ43g5TtyO2
        UkpYjnbw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcv-00DzC0-Sw
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:02 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 7/8] doc: add shifted port-ranges to nat statements
Date:   Sun,  5 Mar 2023 10:14:17 +0000
Message-Id: <20230305101418.2233910-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the description of ports to cover ranges and shifted ranges, and
add an example of the latter.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index b2794bcd6821..3dd3b98b6cb1 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -362,7 +362,7 @@ ____
 *redirect* [*to :*'PORT_SPEC'] ['FLAGS']
 
 'ADDR_SPEC' := 'address' | 'address' *-* 'address'
-'PORT_SPEC' := 'port' | 'port' *-* 'port'
+'PORT_SPEC' := 'port' | 'port' *-* 'port' | 'port' *-* 'port' */* 'port'
 
 'FLAGS'  := 'FLAG' [*,* 'FLAGS']
 'FLAG'  := *persistent* | *random* | *fully-random*
@@ -405,7 +405,10 @@ You may specify a mapping to relate a list of tuples composed of arbitrary
 expression key with address value. |
 ipv4_addr, ipv6_addr, e.g. abcd::1234, or you can use a mapping, e.g. meta mark map { 10 : 192.168.1.2, 20 : 192.168.1.3 }
 |port|
-Specifies that the source/destination port of the packet should be modified. |
+Specifies that the source/destination port of the packet should be modified.  If
+a range is given, the new port will be chosen from within that range.  If a base
+offset is also given, the offset of the new port in the range will match the
+offset of the old port from the specified base.|
 port number (16 bit)
 |===============================
 
@@ -437,6 +440,10 @@ add rule nat postrouting oif eth0 snat to 1.2.3.4
 # redirect all traffic entering via eth0 to destination address 192.168.1.120
 add rule nat prerouting iif eth0 dnat to 192.168.1.120
 
+# redirect all traffic for address 10.0.0.1 and ports 2000-3000 to destination
+# address 10.10.0.1 and the port at the matching offset in 12000-13000
+add rule nat prerouting ip daddr 10.0.0.1 tcp dport 2000-3000 dnat to 10.10.0.1:12000-13000/2000
+
 # translate source addresses of all packets leaving via eth0 to whatever
 # locally generated packets would use as source to reach the same destination
 add rule nat postrouting oif eth0 masquerade
-- 
2.39.2

