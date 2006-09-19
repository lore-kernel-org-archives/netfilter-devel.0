From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] xt_policy: remove dups in .family
Date: Tue, 19 Sep 2006 05:06:19 +0400
Message-ID: <20060919010619.GB5273@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: netdev@vger.kernel.org
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

sparse "defined twice" warning

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/xt_policy.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -171,7 +171,6 @@ static struct xt_match policy_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
 	.checkentry 	= checkentry,
-	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -181,7 +180,6 @@ static struct xt_match policy6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
 	.checkentry	= checkentry,
-	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 

