From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: add dup statement for netdev
Date: Wed, 20 Jan 2016 14:44:16 +0100
Message-ID: <1453297457-11357-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58619 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbcATNo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 08:44:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1DA672EFEC6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F5D6DA85D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE595DA861
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:22 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch contains the missing chunk to add support for the netdev
family. Part of the support slipped through in the original patch to
add the dup statement for IPv4 and IPv6.

 # nft add table netdev filter
 # nft add chain netdev filter ingress { type filter hook ingress device eth0 priority 0\; }
 # nft add rule netdev filter ingress dup to dummy0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c             | 15 +++++++++++++++
 tests/py/any/dup.t         |  7 +++++++
 tests/py/any/dup.t.payload | 14 ++++++++++++++
 3 files changed, 36 insertions(+)
 create mode 100644 tests/py/any/dup.t
 create mode 100644 tests/py/any/dup.t.payload

diff --git a/src/evaluate.c b/src/evaluate.c
index 6277f14..ce132e3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1864,6 +1864,21 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 				return err;
 		}
 		break;
+	case NFPROTO_NETDEV:
+		if (stmt->dup.to == NULL)
+			return stmt_error(ctx, stmt,
+					  "missing destination interface");
+		if (stmt->dup.dev != NULL)
+			return stmt_error(ctx, stmt, "cannot specify device");
+
+		err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
+					sizeof(uint32_t) * BITS_PER_BYTE,
+					&stmt->dup.to);
+		if (err < 0)
+			return err;
+		break;
+	default:
+		return stmt_error(ctx, stmt, "unsupported family");
 	}
 	return 0;
 }
diff --git a/tests/py/any/dup.t b/tests/py/any/dup.t
new file mode 100644
index 0000000..7df24a1
--- /dev/null
+++ b/tests/py/any/dup.t
@@ -0,0 +1,7 @@
+:ingress;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;ingress
+
+dup to lo;ok
+dup to mark map { 0x00000001 : lo, 0x00000002 : lo};ok
+
diff --git a/tests/py/any/dup.t.payload b/tests/py/any/dup.t.payload
new file mode 100644
index 0000000..206a9ec
--- /dev/null
+++ b/tests/py/any/dup.t.payload
@@ -0,0 +1,14 @@
+# dup to lo
+netdev test-netdev ingress 
+  [ immediate reg 1 0x00000001 ]
+  [ dup sreg_dev 1 ]
+
+# dup to mark map { 0x00000001 : lo, 0x00000002 : lo}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+netdev test-netdev ingress 
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ dup sreg_dev 1 ]
+
-- 
2.1.4

