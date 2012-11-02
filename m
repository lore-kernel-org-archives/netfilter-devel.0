From: Jan Engelhardt <jengelh@inai.de>
Subject: =?UTF-8?q?=5BPATCH=2002/11=5D=20netfilter=3A=20xtables2=3A=20initial=20Netlink=20interface?=
Date: Fri,  2 Nov 2012 04:38:34 +0100
Message-ID: <1351827523-10629-3-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42665 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762533Ab2KBDkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:06 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This populates xt_nfnetlink.c with support for NFXTM_IDENTIFY. Right
now that just returns a freeform string but eventually shall dump all
the match and target modules' info.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter/Kbuild              |    1 +
 include/uapi/linux/netfilter/nfnetlink.h         |    3 +-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   27 ++++
 net/netfilter/Makefile                           |    3 +-
 net/netfilter/xt_core.c                          |   14 +-
 net/netfilter/xt_nfnetlink.c                     |  156 ++++++++++++++=
++++++++
 net/netfilter/xt_nfnetlink.h                     |    7 +
 7 files changed, 208 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nfnetlink_xtables.h
 create mode 100644 net/netfilter/xt_nfnetlink.c
 create mode 100644 net/netfilter/xt_nfnetlink.h

diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/n=
etfilter/Kbuild
index 08f555f..edd789c 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -14,6 +14,7 @@ header-y +=3D nfnetlink_cthelper.h
 header-y +=3D nfnetlink_cttimeout.h
 header-y +=3D nfnetlink_log.h
 header-y +=3D nfnetlink_queue.h
+header-y +=3D nfnetlink_xtables.h
 header-y +=3D x_tables.h
 header-y +=3D xt_AUDIT.h
 header-y +=3D xt_CHECKSUM.h
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/li=
nux/netfilter/nfnetlink.h
index 4a4efaf..d5c3f68 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -51,6 +51,7 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ACCT		7
 #define NFNL_SUBSYS_CTNETLINK_TIMEOUT	8
 #define NFNL_SUBSYS_CTHELPER		9
-#define NFNL_SUBSYS_COUNT		10
+#define NFNL_SUBSYS_XTABLES		10
+#define NFNL_SUBSYS_COUNT		11
=20
 #endif /* _UAPI_NFNETLINK_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include=
/uapi/linux/netfilter/nfnetlink_xtables.h
new file mode 100644
index 0000000..a548394
--- /dev/null
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -0,0 +1,27 @@
+#ifndef _LINUX_NFNETLINK_XTABLES_H
+#define _LINUX_NFNETLINK_XTABLES_H 1
+
+/**
+ * %NFXTM_IDENTIFY:	multifunction debug command to inquire about xt2
+ * 			properties (e.g. match size)
+ */
+enum nfxt_msg_type {
+	NFXTM_IDENTIFY =3D 1,
+};
+
+/**
+ * %NFXTA_NAME:			name of the object being operated on
+ */
+enum nfxt_attr_type {
+	NFXTA_UNSPEC =3D 0,
+	NFXTA_NAME,
+};
+
+/**
+ * %NFXTE_SUCCESS:		the operation completed successfully
+ */
+enum nfxt_errno {
+	NFXTE_SUCCESS =3D 0,
+};
+
+#endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 00eab5c..cf716f4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -65,7 +65,8 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
-obj-$(CONFIG_NETFILTER_XTABLES2) +=3D xt_core.o
+obj-$(CONFIG_NETFILTER_XTABLES2) +=3D xtables2.o
+xtables2-y :=3D xt_core.o xt_nfnetlink.o
=20
 # combos
 obj-$(CONFIG_NETFILTER_XT_MARK) +=3D xt_mark.o
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 89dd0a0..24c418b 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -15,6 +15,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/xt_core.h>
+#include "xt_nfnetlink.h"
=20
 MODULE_DESCRIPTION("Netfilter Xtables2 packet filtering");
 MODULE_AUTHOR("Jan Engelhardt");
@@ -72,12 +73,23 @@ static struct pernet_operations xtables2_pernet_ops=
 =3D {
=20
 static int __init xtables2_init(void)
 {
+	int ret;
+
 	pr_info("Xtables2, (C) 2009-2012, J.Engelhardt\n");
-	return register_pernet_subsys(&xtables2_pernet_ops);
+	ret =3D register_pernet_subsys(&xtables2_pernet_ops);
+	if (ret < 0)
+		return ret;
+	ret =3D xtnetlink_init();
+	if (ret < 0) {
+		unregister_pernet_subsys(&xtables2_pernet_ops);
+		return ret;
+	}
+	return 0;
 }
=20
 static void __exit xtables2_exit(void)
 {
+	xtnetlink_exit();
 	unregister_pernet_subsys(&xtables2_pernet_ops);
 }
=20
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.=
c
new file mode 100644
index 0000000..8a58bb8
--- /dev/null
+++ b/net/netfilter/xt_nfnetlink.c
@@ -0,0 +1,156 @@
+/*
+ *	Xtables2 nfnetlink interface
+ *	Copyright =C2=A9 Jan Engelhardt, 2010-2012
+ *
+ *	This program is free software: you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
+ *	the Free Software Foundation, either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_xtables.h>
+#include <net/netlink.h>
+#include <net/netfilter/xt_core.h>
+#include "xt_nfnetlink.h"
+
+#define MAKE_TAGGED_TYPE(x) ((x) | (NFNL_SUBSYS_XTABLES << 8))
+
+/**
+ * Something to keep all the pointers that NL gives us in one place.
+ * You need quite a lot of variables to construct and send out a packe=
t...
+ */
+struct xtnetlink_pktref {
+	union {
+		struct sk_buff *skb;
+		const struct sk_buff *c_skb;
+	};
+	union {
+		struct nlmsghdr *msg;
+		const struct nlmsghdr *c_msg;
+	};
+	struct sock *sock;
+};
+
+/**
+ * @skb:	outgoing skb
+ * @old:	pointers to the original incoming skb/nl headers
+ * @flags:	extra flags to set in nlmsg
+ *
+ * Fill an skb (for outgoing direction) with NL and NFNL headers, usin=
g data
+ * from the original skb for initialization.
+ */
+static struct nlmsghdr *
+xtnetlink_fill(struct sk_buff *skb, const struct xtnetlink_pktref *old=
,
+	       unsigned int flags)
+{
+	uint16_t type =3D NFNL_MSG_TYPE(old->msg->nlmsg_type);
+	struct nlmsghdr *nlmsg;
+	struct nfgenmsg *hdr;
+
+	nlmsg =3D nlmsg_put(skb, NETLINK_CB(old->skb).portid,
+			  old->msg->nlmsg_seq, MAKE_TAGGED_TYPE(type),
+			  sizeof(*hdr), flags);
+	if (nlmsg =3D=3D NULL) {
+		nlmsg_cancel(skb, nlmsg);
+		return ERR_PTR(-ENOBUFS);
+	}
+
+	hdr               =3D nlmsg_data(nlmsg);
+	hdr->nfgen_family =3D NFPROTO_UNSPEC;
+	hdr->version      =3D NFNETLINK_V0;
+	hdr->res_id       =3D 0;
+	return nlmsg;
+}
+
+/**
+ * Ran too often into NULL derefs. Now there is a dummy function for u=
nused
+ * message type 0.
+ */
+static int
+xtnetlink_ignore(struct sock *k, struct sk_buff *s,
+		 const struct nlmsghdr *n, const struct nlattr *const *a)
+{
+	return -ENXIO;
+}
+
+/**
+ * Respond to a %NFXTM_IDENTIFY inquiry. Reports the Xtables2 version =
(for
+ * now), and in future the extension info.
+ */
+static int
+xtnetlink_identify2(struct sk_buff *skb, struct netlink_callback *nl_c=
b)
+{
+	struct xtnetlink_pktref ref =3D {.c_skb =3D skb, .c_msg =3D nl_cb->nl=
h};
+	struct nlmsghdr *nlmsg =3D NULL;
+
+	switch (nl_cb->args[0]) {
+	case 0:
+		nlmsg =3D xtnetlink_fill(skb, &ref, NLM_F_MULTI);
+		if (IS_ERR(nlmsg))
+			return 0;
+		if (nla_put_string(skb, NFXTA_NAME, "Xtables2-xtnl/nfnl") !=3D 0)
+			goto nla_put_failure;
+		++nl_cb->args[0];
+		break;
+	}
+	if (nlmsg !=3D NULL)
+		nlmsg_end(skb, nlmsg);
+	return skb->len;
+ nla_put_failure:
+	return 0;
+}
+
+static int
+xtnetlink_identify(struct sock *xtnl, struct sk_buff *iskb,
+		   const struct nlmsghdr *imsg, const struct nlattr *const *ad)
+{
+	static struct netlink_dump_control ctl __read_mostly =3D {
+		.dump   =3D xtnetlink_identify2,
+		.module =3D THIS_MODULE,
+	};
+	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
+}
+
+static const struct nla_policy xtnetlink_policy[] =3D {
+	[NFXTA_NAME] =3D {.type =3D NLA_NUL_STRING},
+};
+
+/*
+ * Use the same policy for all messages. I do not want to see EINVAL a=
nytime
+ * soon again just because I forgot sending an attribute from userspac=
e.
+ * (If such occurs, it will be dealt with %NFXTE_ATTRSET_INCOMPLETE, t=
bd.)
+ */
+#define pol \
+	.policy =3D xtnetlink_policy, \
+	.attr_count =3D ARRAY_SIZE(xtnetlink_policy)
+static const struct nfnl_callback xtnetlink_callback[] =3D {
+	[0] =3D {.call =3D xtnetlink_ignore},
+	[NFXTM_IDENTIFY] =3D {.call =3D xtnetlink_identify, pol},
+};
+#undef pol
+
+static const struct nfnetlink_subsystem xtnetlink_subsys =3D {
+	.name      =3D "xtables",
+	.subsys_id =3D NFNL_SUBSYS_XTABLES,
+	.cb        =3D xtnetlink_callback,
+	.cb_count  =3D ARRAY_SIZE(xtnetlink_callback),
+};
+
+int __init xtnetlink_init(void)
+{
+	return nfnetlink_subsys_register(&xtnetlink_subsys);
+}
+
+void __exit xtnetlink_exit(void)
+{
+	nfnetlink_subsys_unregister(&xtnetlink_subsys);
+}
+
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_XTABLES);
diff --git a/net/netfilter/xt_nfnetlink.h b/net/netfilter/xt_nfnetlink.=
h
new file mode 100644
index 0000000..f8ed87f
--- /dev/null
+++ b/net/netfilter/xt_nfnetlink.h
@@ -0,0 +1,7 @@
+#ifndef XT_NFNETLINK_H
+#define XT_NFNETLINK_H 1
+
+extern int xtnetlink_init(void);
+extern void xtnetlink_exit(void);
+
+#endif /* XT_NFNETLINK_H */
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
