Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37123C001B0
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jun 2023 06:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjFWGLK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jun 2023 02:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjFWGLJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2023 02:11:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FE710DB;
        Thu, 22 Jun 2023 23:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=5UQOnj+EL/9oIsTofJlpcZai9GCdVN+roMEwh7clpOc=; b=2AChkdxEO1FmOtqF0sWRc4j9MO
        8GT74VDCFNlhXzXQCK1frQWvEAOFCjJGUXMc5qGBkgWTM99B6qHQ9W+AFUnCpexGesAjycvyfdDFw
        izi0sgqfE7VxNPwFAZWn0fW9H4dVpM5L+zLNjjQRlxL2B/2rWO41iKW82SXxZ5Bkm2sIbrFgHAotO
        jUxPARZ2NyrruHpit44KZmKGH0n0wfL28Q3IcDpQ+Ll9GQw/LLry4dorttsRRfUg6zkzX7Y0QKksd
        NsjIOraeG4y5w+aYV1aPrnXlBG6ZSFCONBJfVIGbbEAX0HJ6hq/8mXjTj/Ez4BWePuuVfGAhssz7n
        nCmDNd9Q==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qCa0c-002fRx-1u;
        Fri, 23 Jun 2023 06:11:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] linux/netfilter.h: fix kernel-doc warnings
Date:   Thu, 22 Jun 2023 23:11:01 -0700
Message-ID: <20230623061101.32513-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

kernel-doc does not support DECLARE_PER_CPU(), so don't mark it with
kernel-doc notation.

One comment block is not kernel-doc notation, so just use
"/*" to begin the comment.

Quietens these warnings:

netfilter.h:493: warning: Function parameter or member 'bool' not described in 'DECLARE_PER_CPU'
netfilter.h:493: warning: Function parameter or member 'nf_skb_duplicated' not described in 'DECLARE_PER_CPU'
netfilter.h:493: warning: expecting prototype for nf_skb_duplicated(). Prototype was for DECLARE_PER_CPU() instead
netfilter.h:496: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Contains bitmask of ctnetlink event subscribers, if any.

Fixes: e7c8899f3e6f ("netfilter: move tee_active to core")
Fixes: fdf6491193e4 ("netfilter: ctnetlink: make event listener tracking global")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/netfilter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -- a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -481,7 +481,7 @@ struct nfnl_ct_hook {
 };
 extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
-/**
+/*
  * nf_skb_duplicated - TEE target has sent a packet
  *
  * When a xtables target sends a packet, the OUTPUT and POSTROUTING
@@ -492,7 +492,7 @@ extern const struct nfnl_ct_hook __rcu *
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
-/**
+/*
  * Contains bitmask of ctnetlink event subscribers, if any.
  * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
  */
