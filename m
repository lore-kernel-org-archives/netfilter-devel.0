From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?q?=5BPATCH=202/7=5D=20netfilter=3A=20xtables2=3A=20initial=20Netlink=20interface?=
Date: Thu, 19 Jan 2012 17:26:16 +0100
Message-ID: <1326990381-14534-3-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57970 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2ASQ0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:24 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This populates xt2_nfnetlink.c with support for NFXTM_IDENTIFY. Right
now that just returns a freeform string but eventually shall dump all
the match and target modules' info.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild              |    1 +
 include/linux/netfilter/nfnetlink.h         |    3 +-
 include/linux/netfilter/nfnetlink_xtables.h |   20 ++++
 net/netfilter/Kconfig                       |    8 ++
 net/netfilter/Makefile                      |    1 +
 net/netfilter/xt2_nfnetlink.c               |  153 +++++++++++++++++++=
++++++++
 6 files changed, 185 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_xtables.h
 create mode 100644 net/netfilter/xt2_nfnetlink.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/K=
build
index a1b410c..6e568c9 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -10,6 +10,7 @@ header-y +=3D nfnetlink_compat.h
 header-y +=3D nfnetlink_conntrack.h
 header-y +=3D nfnetlink_log.h
 header-y +=3D nfnetlink_queue.h
+header-y +=3D nfnetlink_xtables.h
 header-y +=3D x_tables.h
 header-y +=3D xt_AUDIT.h
 header-y +=3D xt_CHECKSUM.h
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfil=
ter/nfnetlink.h
index 74d3386..93228b4 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -48,7 +48,8 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_ULOG		4
 #define NFNL_SUBSYS_OSF			5
 #define NFNL_SUBSYS_IPSET		6
-#define NFNL_SUBSYS_COUNT		7
+#define NFNL_SUBSYS_XTABLES		8
+#define NFNL_SUBSYS_COUNT		9
=20
 #ifdef __KERNEL__
=20
diff --git a/include/linux/netfilter/nfnetlink_xtables.h b/include/linu=
x/netfilter/nfnetlink_xtables.h
new file mode 100644
index 0000000..4c53042
--- /dev/null
+++ b/include/linux/netfilter/nfnetlink_xtables.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_NFNETLINK_XTABLES_H
+#define _LINUX_NFNETLINK_XTABLES_H 1
+
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
+enum nfxt_errno {
+	NFXTE_SUCCESS =3D 0,
+};
+
+#endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5b3d9ca..6237a30 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -327,6 +327,14 @@ config NETFILTER_XTABLES2
 	Xtables2 is a rework of the internal architecture of Xtables.
 	It supersedes iptables, ip6tables, arptables and ebtables.
=20
+if NETFILTER_XTABLES2
+
+config NETFILTER_XTNFNETLINK
+	tristate "Configuration interface over nfnetlink"
+	default m if NETFILTER_ADVANCED=3Dn
+
+endif # NETFILTER_XTABLES2
+
 if NETFILTER_XTABLES || NETFILTER_XTABLES2
=20
 comment "Xtables combined modules"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 8504ebd..634e6a8 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
 obj-$(CONFIG_NETFILTER_XTABLES2) +=3D xt2_core.o
+obj-$(CONFIG_NETFILTER_XTNFNETLINK) +=3D xt2_nfnetlink.o
=20
 # combos
 obj-$(CONFIG_NETFILTER_XT_MARK) +=3D xt_mark.o
diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlin=
k.c
new file mode 100644
index 0000000..3dc241f
--- /dev/null
+++ b/net/netfilter/xt2_nfnetlink.c
@@ -0,0 +1,153 @@
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
+#include <net/netfilter/x_tables2.h>
+
+MODULE_DESCRIPTION("Xtables2 nfnetlink interface");
+MODULE_AUTHOR("Jan Engelhardt");
+MODULE_LICENSE("GPL");
+
+/**
+ * Something to keep all the pointers that NL gives us in one place.
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
+	uint16_t nlmsg_type =3D NFNL_MSG_TYPE(old->msg->nlmsg_type);
+	struct nlmsghdr *nlmsg;
+	struct nfgenmsg *hdr;
+
+	nlmsg_type |=3D NFNL_SUBSYS_XTABLES << 8;
+	nlmsg =3D nlmsg_put(skb, NETLINK_CB(old->skb).pid, old->msg->nlmsg_se=
q,
+			  nlmsg_type, sizeof(*hdr), flags);
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
+		NLA_PUT_STRING(skb, NFXTA_NAME, XTABLES2_VTAG);
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
+	return netlink_dump_start(xtnl, iskb, imsg, xtnetlink_identify2,
+				  NULL, 0);
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
+static int __init xtnetlink_init(void)
+{
+	return nfnetlink_subsys_register(&xtnetlink_subsys);
+}
+
+static void __exit xtnetlink_exit(void)
+{
+	nfnetlink_subsys_unregister(&xtnetlink_subsys);
+}
+
+module_init(xtnetlink_init);
+module_exit(xtnetlink_exit);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_XTABLES);
--=20
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
