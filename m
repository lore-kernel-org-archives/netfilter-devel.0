From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] netfilter: conntrack: remove leftover binary sysctl define
Date: Wed,  1 Jun 2016 14:03:19 +0200
Message-ID: <1464782604-19346-3-git-send-email-pablo@netfilter.org>
References: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52870 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757760AbcFAMDi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 08:03:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DDBAE11D9BD7
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CB6CA2310B4
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 61D942310A8
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 14:03:31 +0200 (CEST)
In-Reply-To: <1464782604-19346-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Users got removed in f8572d8f2a2ba ("sysctl net: Remove unused binary
sysctl code").

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0f1a45b..2933db3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -489,8 +489,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	{ }
 };
 
-#define NET_NF_CONNTRACK_MAX 2089
-
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-- 
2.1.4

