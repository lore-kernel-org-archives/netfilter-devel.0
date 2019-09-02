Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA7AC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05185216C8
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="lBbUbaAG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfIBXG4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:56 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43566 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfIBXGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bxVsTvPhTtdf0UxIqpFlRJcg2jHNab4wz0vLxDYsWek=; b=lBbUbaAGGNGwkXobUA6AqqeRik
        i8IZLof7HfkerkPPlc9MTBs03G9/HZu0cVy95Lf36zRswHIgGgh0hDuhgHx/qXeiZDtkQLdNHdRTU
        j71ZXDjMdy7uy8qOgyc1JiiQcgTiuDQv47eYPgCAFkdEyD5Bs59vyIrtac/evEQTlmwzFxtcdu4mK
        XoYyasH6DTTmAeiTtgZ8V13emYolMXZjI7rGs2p2wUx8g8H3eoCi+tP95b9ozXQsE+QminSj9budc
        OHr5oV3QGyc5LDgRRd/dclAtKyH4qchpX96Cei+Ch7b6LdQtYYXeZfcjNXd+TV4fz0LMMX6j0huK5
        ZMxChyxQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPP-0004la-P0; Tue, 03 Sep 2019 00:06:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 08/30] netfilter: remove unused function declarations.
Date:   Tue,  3 Sep 2019 00:06:28 +0100
Message-Id: <20190902230650.14621-9-jeremy@azazel.net>
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
2.23.0.rc1

