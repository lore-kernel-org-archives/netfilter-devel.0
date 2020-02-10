Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34333C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 12:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178E32051A
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 12:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBJMsc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 07:48:32 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58980 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgBJMsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 07:48:31 -0500
Received: from localhost ([::1]:43838 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j18UI-0003zv-8x; Mon, 10 Feb 2020 13:48:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2] xtables-translate: Fix for interface name corner-cases
Date:   Mon, 10 Feb 2020 13:48:28 +0100
Message-Id: <20200210124828.32400-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are two special situations xlate_ifname() didn't cover for:

* Interface name containing '*': This went unchanged, creating a command
  nft wouldn't accept. Instead translate into '\*' which doesn't change
  semantics.

* Interface name being '+': Can't translate into nft wildcard character
  as nft doesn't accept asterisk-only interface names. Instead decide
  what to do based on 'invert' value: Skip match creation if false,
  match against an invalid interface name if true.

Also add a test to make sure future changes to this behaviour are
noticed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Escape asterisks mid-string as well and extend tests accordingly.
---
 extensions/generic.txlate    | 12 ++++++++++++
 iptables/xtables-translate.c | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index b38fbd1fe113b..c92d082abea78 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -18,3 +18,15 @@ nft add rule bridge filter FORWARD iifname != "iname" meta ibrname "ilogname" oi
 
 ebtables-translate -I INPUT -p ip -d 1:2:3:4:5:6/ff:ff:ff:ff:00:00
 nft insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:00 and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter
+
+# asterisk is not special in iptables and it is even a valid interface name
+iptables-translate -A FORWARD -i '*' -o 'eth*foo'
+nft add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter
+
+# skip for always matching interface names
+iptables-translate -A FORWARD -i '+'
+nft add rule ip filter FORWARD counter
+
+# match against invalid interface name to simulate never matching rule
+iptables-translate -A FORWARD ! -i '+'
+nft add rule ip filter FORWARD iifname "INVAL/D" counter
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 77a186b905d73..c4e177c0d63ba 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -32,15 +32,38 @@
 void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 		  bool invert)
 {
-	int ifaclen = strlen(ifname);
-	char iface[IFNAMSIZ];
+	int ifaclen = strlen(ifname), i, j;
+	char iface[IFNAMSIZ * 2];
 
 	if (ifaclen < 1 || ifaclen >= IFNAMSIZ)
 		return;
 
-	strcpy(iface, ifname);
-	if (iface[ifaclen - 1] == '+')
-		iface[ifaclen - 1] = '*';
+	for (i = 0, j = 0; i < ifaclen + 1; i++, j++) {
+		switch (ifname[i]) {
+		case '+':
+			iface[j] = '*';
+			break;
+		case '*':
+			iface[j++] = '\\';
+			/* fall through */
+		default:
+			iface[j] = ifname[i];
+			break;
+		}
+	}
+
+	if (ifaclen == 1 && ifname[0] == '+') {
+		/* Nftables does not support wildcard only string. Workaround
+		 * is easy, given that this will match always or never
+		 * depending on 'invert' value. To match always, simply don't
+		 * generate an expression. To match never, use an invalid
+		 * interface name (kernel doesn't accept '/' in names) to match
+		 * against. */
+		if (!invert)
+			return;
+		strcpy(iface, "INVAL/D");
+		invert = false;
+	}
 
 	xt_xlate_add(xl, "%s %s\"%s\" ", nftmeta, invert ? "!= " : "", iface);
 }
-- 
2.24.1

