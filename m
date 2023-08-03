Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485BAEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 15:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbjHCPCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 11:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjHCPCo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 11:02:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BA010B
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 08:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oKeoGeWjtkIVYJENunHKjxg7wfRjT2jVKwtIznSUT4s=; b=MGaMMQGYekMb9s1FnQF4LvXk7g
        gjX4/nPP4XQyp5xUasXBS3hpNsw4RsMVpAxrO6wN5rRpNhT1zUqeAOQhibPVucG6trxjKm5ioQM43
        kg1oNL+Uq1AcIRttMMh8E6yShi4G2RS+XSRAUaDRkkIPhx/C1pkpSE42PegPw1sKXwDuom+5gI45R
        9c72gKBPhGw0X5gcG8tY6cyM1I7nE9Exl0AQ9Ut8RVHUnQLUQhuzBcgxUjDUlopn7KRDMt93ApluC
        /SHNIuRRrvEr5jkrxe8Xp7x0scM735mhOOj6Ml7bR0U91HWaCVemkM5qc6RmgUffloB4FbJBwor1O
        Z6feuxFQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qRZqb-0006Ou-86
        for netfilter-devel@vger.kernel.org; Thu, 03 Aug 2023 17:02:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: libip6t_icmp: Add names for mld-listener types
Date:   Thu,  3 Aug 2023 17:02:32 +0200
Message-Id: <20230803150232.30741-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add the three names (plus one alias) just as in nftables.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1250
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_icmp6.t | 4 ++++
 extensions/libxt_icmp.h    | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/extensions/libip6t_icmp6.t b/extensions/libip6t_icmp6.t
index 028cfc16ede24..b9a4dcd3abc77 100644
--- a/extensions/libip6t_icmp6.t
+++ b/extensions/libip6t_icmp6.t
@@ -4,3 +4,7 @@
 -p ipv6-icmp -m icmp6 --icmpv6-type 2;=;OK
 # cannot use option twice:
 -p ipv6-icmp -m icmp6 --icmpv6-type no-route --icmpv6-type packet-too-big;;FAIL
+-p ipv6-icmp -m icmp6 --icmpv6-type mld-listener-query;-p ipv6-icmp -m icmp6 --icmpv6-type 130;OK
+-p ipv6-icmp -m icmp6 --icmpv6-type mld-listener-report;-p ipv6-icmp -m icmp6 --icmpv6-type 131;OK
+-p ipv6-icmp -m icmp6 --icmpv6-type mld-listener-done;-p ipv6-icmp -m icmp6 --icmpv6-type 132;OK
+-p ipv6-icmp -m icmp6 --icmpv6-type mld-listener-reduction;-p ipv6-icmp -m icmp6 --icmpv6-type 132;OK
diff --git a/extensions/libxt_icmp.h b/extensions/libxt_icmp.h
index a763e50c1de32..7a45b4bd2ec6d 100644
--- a/extensions/libxt_icmp.h
+++ b/extensions/libxt_icmp.h
@@ -83,6 +83,13 @@ static const struct xt_icmp_names {
 	{ "echo-reply", 129, 0, 0xFF },
 	/* Alias */ { "pong", 129, 0, 0xFF },
 
+	{ "mld-listener-query", 130, 0, 0xFF },
+
+	{ "mld-listener-report", 131, 0, 0xFF },
+
+	{ "mld-listener-done", 132, 0, 0xFF },
+	/* Alias */ { "mld-listener-reduction", 132, 0, 0xFF },
+
 	{ "router-solicitation", 133, 0, 0xFF },
 
 	{ "router-advertisement", 134, 0, 0xFF },
-- 
2.40.0

