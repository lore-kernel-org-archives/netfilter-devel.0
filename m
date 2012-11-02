From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 09/11] netfilter: xtables2: supply a revision number
Date: Fri,  2 Nov 2012 04:38:41 +0100
Message-ID: <1351827523-10629-10-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42672 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762711Ab2KBDkI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:08 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Userspace needs a way to identify, for example, kernels with too old an
interface, i.e. a kernel that might silently reject/ignore certain new
nlattrs.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    4 ++++
 net/netfilter/xt_nfnetlink.c                     |   15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 84133c7..44d6595 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -29,6 +29,8 @@ enum nfxt_msg_type {
  * %NFXTA_ERRNO:		system error code (%Exxx)
  * %NFXTA_XTERRNO:		NFXT-specific error code (cf. enum nfxt_errno)
  * %NFXTA_NEW_NAME:		new name of object
+ * %NFXTA_REVISION_MIN:		minimum API revision supported by xtnetlink
+ * %NFXTA_REVISION_MAX:		maximum API revision supported by xtnetlink
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -36,6 +38,8 @@ enum nfxt_attr_type {
 	NFXTA_ERRNO,
 	NFXTA_XTERRNO,
 	NFXTA_NEW_NAME,
+	NFXTA_REVISION_MIN,
+	NFXTA_REVISION_MAX,
 };
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index c53902e..4d4a076 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -75,6 +75,13 @@ static rwlock_t xtnetlink_transact_lock;
 static LIST_HEAD(xtnetlink_transact_list);
 
 /**
+ * The revision this xt_nfnetlink speaks. Think of it like max=CURRENT and
+ * min=(CURRENT-AGE) numbers used with libtool versioning.
+ */
+static const unsigned int xtnetlink_revision_max; /* = 0; */
+static const unsigned int xtnetlink_revision_min; /* = 0; */
+
+/**
  * Create a new transaction state.
  * @net:	network namespace of socket
  * @nladdr:	client address (NETLINK_CB(skb).portid)
@@ -362,6 +369,12 @@ xtnetlink_identify2(struct sk_buff *skb, struct netlink_callback *nl_cb)
 			return 0;
 		if (nla_put_string(skb, NFXTA_NAME, "Xtables2-xtnl/nfnl") != 0)
 			goto nla_put_failure;
+		if (nla_put_u32(skb, NFXTA_REVISION_MAX,
+		    xtnetlink_revision_max) != 0)
+			goto nla_put_failure;
+		if (nla_put_u32(skb, NFXTA_REVISION_MIN,
+		    xtnetlink_revision_min) != 0)
+			goto nla_put_failure;
 		++nl_cb->args[0];
 		break;
 	}
@@ -582,6 +595,8 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_ERRNO] = {.type = NLA_U32},
 	[NFXTA_XTERRNO] = {.type = NLA_U32},
 	[NFXTA_NEW_NAME] = {.type = NLA_NUL_STRING},
+	[NFXTA_REVISION_MIN] = {.type = NLA_U32},
+	[NFXTA_REVISION_MAX] = {.type = NLA_U32},
 };
 
 /*
-- 
1.7.10.4

