From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER try 2]: xt_helper: Do not bypass RCU
Date: Thu, 10 Jan 2008 17:34:32 +0100
Message-ID: <47864918.9080001@trash.net>
References: <47863DA5.6020003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040002090706000002020803"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58774 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbYAJQi5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:38:57 -0500
In-Reply-To: <47863DA5.6020003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040002090706000002020803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------040002090706000002020803
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: xt_helper: Do not bypass RCU

Use the @helper variable that was just obtained.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 30d0a14997210d0c2cbaea594eb1283d773dfca5
tree 5270a79c2e2bfd679b96edba59c6b7ef84e59bdb
parent 7bd5c38839308e24911fffa749b3e53391c7de14
author Jan Engelhardt <jengelh@computergmbh.de> Wed, 02 Jan 2008 21:29:12 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 10 Jan 2008 16:44:14 +0100

 net/netfilter/xt_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 0a1f4c6..d842c4a 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -56,8 +56,8 @@ match(const struct sk_buff *skb,
 	if (info->name[0] == '\0')
 		ret = !ret;
 	else
-		ret ^= !strncmp(master_help->helper->name, info->name,
-				strlen(master_help->helper->name));
+		ret ^= !strncmp(helper->name, info->name,
+				strlen(helper->name));
 	return ret;
 }
 

--------------040002090706000002020803--
