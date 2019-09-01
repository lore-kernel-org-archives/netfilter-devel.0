Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB857C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7518B22CE9
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="RQHUXZ2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfIAUvb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:51:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53356 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbfIAUva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 16:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bxVsTvPhTtdf0UxIqpFlRJcg2jHNab4wz0vLxDYsWek=; b=RQHUXZ2twRhdXPHdP5rmVkQM7x
        khzLUKxBdP3rCz+zxUeGO9+O6Sa91uJFHEcLW+h9FHZ68SLBk5nWIBpzuPZs3MSZfFfdghBKv7dvG
        lWMivTSa9fumzBLfw9FChmR3YI7U/ELUUcC5YeE6q/leDnYkK/omPnaFYs2cwEcelzHwfecvtw0oV
        g6tf2dV+ilWQ2Wx1HiAxKWeFF14YIiQIMkYbscXClEE0M9sAwLBXeMjZbKikjuQX7T5LuKXaAU3EQ
        gULsFFJZAwflKhkMwT1gN5nA32MfFGzO/dWIIaZcMTy/q0jLL0nZxnR1QOvN8yF0uBgd7rA776lmI
        9XGV1VbQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Wop-0002Uf-CD; Sun, 01 Sep 2019 21:51:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 08/29] netfilter: remove unused function declarations.
Date:   Sun,  1 Sep 2019 21:51:04 +0100
Message-Id: <20190901205126.6935-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
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

