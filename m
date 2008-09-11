From: Jan Engelhardt <jengelh@medozas.de>
Subject: 06/11 [NETFILTER]: ebt_among: obtain match size through different
 means
Date: Wed, 10 Sep 2008 22:45:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809102245250.8838@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41557 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYIKCpe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:45:34 -0400
In-Reply-To: <alpine.LNX.1.10.0809102242180.8838@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit bf2819b12227becf56bee62047bace59931505c8
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Sep 11 02:27:31 2008 -0400

[NETFILTER]: ebt_among: obtain match size through different means

The function signatures will be changed to match those of Xtables, and
the datalen argument will be gone. ebt_among unfortunately relies on
it, so we need to obtain it somehow.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebt_among.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 568c890..88b5c91 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -178,6 +178,8 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 		const struct ebt_entry *e, void *data,
 		unsigned int datalen)
 {
+	const struct ebt_entry_match *em =
+		container_of(data, const struct ebt_entry_match, data);
 	const struct ebt_among_info *info = data;
 	int expected_length = sizeof(struct ebt_among_info);
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
@@ -188,11 +190,11 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 	expected_length += ebt_mac_wormhash_size(wh_dst);
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
-	if (datalen != EBT_ALIGN(expected_length)) {
+	if (em->match_size != EBT_ALIGN(expected_length)) {
 		printk(KERN_WARNING
 		       "ebtables: among: wrong size: %d "
 		       "against expected %d, rounded to %Zd\n",
-		       datalen, expected_length,
+		       em->match_size, expected_length,
 		       EBT_ALIGN(expected_length));
 		return false;
 	}
