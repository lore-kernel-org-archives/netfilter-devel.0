From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: Support NAT-ed expect entries from user space
Date: Mon, 23 Jun 2008 17:31:53 +0200
Message-ID: <20080623153153.GE3261@phoenix.home>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org> <4856D28C.3030302@trash.net> <20080616221759.GM2860@phoenix.home> <4856EC99.6070903@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sgneBHv3152wZ8jf"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:64945 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYFWPb7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:31:59 -0400
Received: from dolphin ([86.101.25.238]) by viefep11-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080623153154.LAAS5076.viefep11-int.chello.at@dolphin>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 23 Jun 2008 17:31:54 +0200
Content-Disposition: inline
In-Reply-To: <4856EC99.6070903@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Jun 17, 2008 at 12:43:37AM +0200, Patrick McHardy wrote:
> I understand that, the expectation part looks like a subset of what
> a helper module does though, with the only differences that a helper
> might want to queue the packet. And since expectfn setup also doesn't
> belong in nf_conntrack_netlink.c (especially not NAT related expectfns),
> this is how I think it should be done.

I attached a new version of the expect setup patch. I think it's general
enough to include into the kernel. What's your opinion? The saved_ip
field is only used by the nf_nat_sip and nf_nat_h323 helpers, we only
need it if we want to set expectfn of our choice.

Bye,
Bozo

--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfct_expect_setup.patch"

--- linux-2.6.25.7/net/netfilter/nf_conntrack_netlink.c	2008-06-20 11:21:38.000000000 +0200
+++ linux/net/netfilter/nf_conntrack_netlink.c	2008-06-23 17:00:26.000000000 +0200
@@ -37,8 +37,9 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_protocol.h>
+#include <net/netfilter/nf_nat_helper.h>
 #endif
 
 #include <linux/netfilter/nfnetlink.h>
@@ -1666,6 +1667,7 @@
 	struct nf_conntrack_expect *exp;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
+	struct nlattr *tb[CTA_EXPNAT_MAX+1];
 	int err = 0;
 
 	/* caller guarantees that those three CTA_EXPECT_* exist */
@@ -1699,6 +1701,27 @@
 	}
 
 	exp->expectfn = NULL;
+#ifdef CONFIG_NF_NAT_NEEDED
+	if (cda[CTA_EXPECT_NAT]) {
+		exp->expectfn = nf_nat_follow_master;
+		err = nla_parse_nested(tb, CTA_EXPNAT_MAX,
+				       cda[CTA_EXPECT_NAT], NULL);
+		if (err < 0)
+			goto out;
+
+		if (tb[CTA_EXPNAT_SAVED_PROTO])
+			exp->saved_proto.all = nla_get_be16(tb[CTA_EXPNAT_SAVED_PROTO]);
+		if (tb[CTA_EXPNAT_DIRECTION]) {
+			exp->dir = nla_get_u8(tb[CTA_EXPNAT_DIRECTION]);
+			if (exp->dir != IP_CT_DIR_ORIGINAL &&
+			    exp->dir != IP_CT_DIR_REPLY) {
+				err = -EINVAL;
+				goto out;
+			}
+		} else
+			exp->dir = IP_CT_DIR_ORIGINAL;
+	}
+#endif
 	exp->flags = 0;
 	exp->master = ct;
 	exp->helper = NULL;
--- linux-2.6.25.7/include/linux/netfilter/nfnetlink_conntrack.h	2008-06-16 22:24:36.000000000 +0200
+++ linux/include/linux/netfilter/nfnetlink_conntrack.h	2008-06-23 16:29:08.000000000 +0200
@@ -138,6 +138,7 @@
 	CTA_EXPECT_TIMEOUT,
 	CTA_EXPECT_ID,
 	CTA_EXPECT_HELP_NAME,
+	CTA_EXPECT_NAT,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
@@ -149,4 +150,12 @@
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
 
+enum ctattr_expnat {
+	CTA_EXPNAT_UNSPEC,
+	CTA_EXPNAT_SAVED_PROTO,
+	CTA_EXPNAT_DIRECTION,
+	__CTA_EXPNAT_MAX
+};
+#define CTA_EXPNAT_MAX (__CTA_EXPNAT_MAX - 1)
+
 #endif /* _IPCONNTRACK_NETLINK_H */

--sgneBHv3152wZ8jf--
