From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: arpt_mangle: fix return values of checkentry
Date: Tue, 01 Feb 2011 13:05:26 +0100
Message-ID: <20110201120526.3427.83323.stgit@decadence>
References: <20110201120116.3427.96097.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57623 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1BAMFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:05:30 -0500
In-Reply-To: <20110201120116.3427.96097.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In 135367b "netfilter: xtables: change xt_target.checkentry return type",
the type returned by checkentry was changed from boolean to int, but the
return values where not adjusted.

# arptables -I INPUT -i eth1 --h-length 6 --destination-mac 01:00:5e:00:01:01 -j mangle --mangle-mac-d 00:18:71:68:f2:34
arptables: Input/output error

This broke arptables with the mangle target since it returns true
under success, which is interpreted by xtables as >0, thus
returning EIO.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arpt_mangle.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index b8ddcc4..a5e52a9 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -60,12 +60,12 @@ static int checkentry(const struct xt_tgchk_param *par)
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
-		return false;
+		return -EINVAL;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
 	   mangle->target != XT_CONTINUE)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target arpt_mangle_reg __read_mostly = {

