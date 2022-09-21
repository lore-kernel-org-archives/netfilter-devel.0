Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE1C6FA8B
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 07:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIUHin (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 03:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiIUHim (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 03:38:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66C583F06;
        Wed, 21 Sep 2022 00:38:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oauJc-0005QQ-1x; Wed, 21 Sep 2022 09:38:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/5] netfilter: conntrack: remove nf_conntrack_helper documentation
Date:   Wed, 21 Sep 2022 09:38:21 +0200
Message-Id: <20220921073825.4658-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921073825.4658-1-fw@strlen.de>
References: <20220921073825.4658-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This toggle has been already remove by b118509076b3 ("netfilter: remove
nf_conntrack_helper sysctl and modparam toggles").

Remove the documentation entry for this toggle too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 834945ebc4cd..1120d71f28d7 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -70,15 +70,6 @@ nf_conntrack_generic_timeout - INTEGER (seconds)
 	Default for generic timeout.  This refers to layer 4 unknown/unsupported
 	protocols.
 
-nf_conntrack_helper - BOOLEAN
-	- 0 - disabled (default)
-	- not 0 - enabled
-
-	Enable automatic conntrack helper assignment.
-	If disabled it is required to set up iptables rules to assign
-	helpers to connections.  See the CT target description in the
-	iptables-extensions(8) man page for further information.
-
 nf_conntrack_icmp_timeout - INTEGER (seconds)
 	default 30
 
-- 
2.35.1

