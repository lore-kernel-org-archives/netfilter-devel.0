From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool - PATCH] include: Add proper nfnetlink header to fix compilation error
Date: Mon, 30 Sep 2013 12:22:42 +0300
Message-ID: <1380532962-27411-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab3I3JWs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:22:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46ixes:
src/mnl.c: In function =E2=80=98mnl_batch_put=E2=80=99:
src/mnl.c:117:16: error: =E2=80=98NFNL_SUBSYS_NFTABLES=E2=80=99 undecla=
red (first use in
this function)
src/mnl.c:117:16: note: each undeclared identifier is reported only onc=
e
for each function it appears in
src/mnl.c: In function =E2=80=98mnl_batch_begin=E2=80=99:
src/mnl.c:125:16: error: =E2=80=98NFNL_MSG_BATCH_BEGIN=E2=80=99 undecla=
red (first use in
this function)
src/mnl.c: In function =E2=80=98mnl_batch_end=E2=80=99:
src/mnl.c:130:16: error: =E2=80=98NFNL_MSG_BATCH_END=E2=80=99 undeclare=
d (first use in
this function)

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nfnetlink.h | 64 +++++++++++++++++++++++++++++=
++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 include/linux/netfilter/nfnetlink.h

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfil=
ter/nfnetlink.h
new file mode 100644
index 0000000..06eea26
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink.h
@@ -0,0 +1,64 @@
+#ifndef _NFNETLINK_H
+#define _NFNETLINK_H
+#include <linux/types.h>
+#include <linux/netfilter/nfnetlink_compat.h>
+
+enum nfnetlink_groups {
+	NFNLGRP_NONE,
+#define NFNLGRP_NONE			NFNLGRP_NONE
+	NFNLGRP_CONNTRACK_NEW,
+#define NFNLGRP_CONNTRACK_NEW		NFNLGRP_CONNTRACK_NEW
+	NFNLGRP_CONNTRACK_UPDATE,
+#define NFNLGRP_CONNTRACK_UPDATE	NFNLGRP_CONNTRACK_UPDATE
+	NFNLGRP_CONNTRACK_DESTROY,
+#define NFNLGRP_CONNTRACK_DESTROY	NFNLGRP_CONNTRACK_DESTROY
+	NFNLGRP_CONNTRACK_EXP_NEW,
+#define	NFNLGRP_CONNTRACK_EXP_NEW	NFNLGRP_CONNTRACK_EXP_NEW
+	NFNLGRP_CONNTRACK_EXP_UPDATE,
+#define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
+	NFNLGRP_CONNTRACK_EXP_DESTROY,
+#define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_NFTABLES,
+#define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+	__NFNLGRP_MAX,
+};
+#define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
+
+/* General form of address family dependent message.
+ */
+struct nfgenmsg {
+	__u8  nfgen_family;		/* AF_xxx */
+	__u8  version;		/* nfnetlink version */
+	__be16    res_id;		/* resource id */
+};
+
+#define NFNETLINK_V0	0
+
+/* netfilter netlink message types are split in two pieces:
+ * 8 bit subsystem, 8bit operation.
+ */
+
+#define NFNL_SUBSYS_ID(x)	((x & 0xff00) >> 8)
+#define NFNL_MSG_TYPE(x)	(x & 0x00ff)
+
+/* No enum here, otherwise __stringify() trick of MODULE_ALIAS_NFNL_SU=
BSYS()
+ * won't work anymore */
+#define NFNL_SUBSYS_NONE 		0
+#define NFNL_SUBSYS_CTNETLINK		1
+#define NFNL_SUBSYS_CTNETLINK_EXP	2
+#define NFNL_SUBSYS_QUEUE		3
+#define NFNL_SUBSYS_ULOG		4
+#define NFNL_SUBSYS_OSF			5
+#define NFNL_SUBSYS_IPSET		6
+#define NFNL_SUBSYS_ACCT		7
+#define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
+#define NFNL_SUBSYS_CTHELPER		9
+#define NFNL_SUBSYS_NFTABLES		10
+#define NFNL_SUBSYS_NFT_COMPAT		11
+#define NFNL_SUBSYS_COUNT		12
+
+/* Reserved control nfnetlink messages */
+#define NFNL_MSG_BATCH_BEGIN		NLMSG_MIN_TYPE
+#define NFNL_MSG_BATCH_END		NLMSG_MIN_TYPE+1
+
+#endif /* _NFNETLINK_H */
--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
