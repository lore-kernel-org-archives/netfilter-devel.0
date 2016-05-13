From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: remove leftover binary sysctl define
Date: Fri, 13 May 2016 22:48:51 +0200
Message-ID: <1463172531-15429-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43331 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932254AbcEMUsd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 16:48:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Users got removed in f8572d8f2a2ba ("sysctl net: Remove unused binary
sysctl code").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f87e84e..c026c47 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -487,8 +487,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	{ }
 };
 
-#define NET_NF_CONNTRACK_MAX 2089
-
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-- 
2.7.3

