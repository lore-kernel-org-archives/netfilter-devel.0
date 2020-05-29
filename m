Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B5DC433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 01:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4066120B80
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 01:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzUt4OyT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390904AbgE2Bou (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 21:44:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22700 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390689AbgE2Bos (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 21:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590716685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Xyxj5/TDbjdlA3+eV4LtEp/i31Q4MHxvnPp9oxxL0qc=;
        b=bzUt4OyTe0xvt9JkA7SEtf89TuKsxsHNErQpYBInwmqzvQqbPA+8+x4Wtw1hCylWSMbzfb
        kQvLkV5LQY/cTWsXZaaFYH4i0fMnkLNsT2rgWP6n2xJR/vA5H3Z6VnvF5UQ+aZZ7PFI0p7
        KPTXT7bwY8hY2uLEBoJXOoCRgA98ZM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-If5AABpnOQmO7Qix9sPqsA-1; Thu, 28 May 2020 21:44:40 -0400
X-MC-Unique: If5AABpnOQmO7Qix9sPqsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ED61EC1A5;
        Fri, 29 May 2020 01:44:39 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D50F5C1C3;
        Fri, 29 May 2020 01:44:26 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak124 v2] audit: log nftables configuration change events
Date:   Thu, 28 May 2020 21:44:00 -0400
Message-Id: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables, ip6tables, arptables and ebtables table registration,
replacement and unregistration configuration events are logged for the
native (legacy) iptables setsockopt api, but not for the
nftables netlink api which is used by the nft-variant of iptables in
addition to nftables itself.

Add calls to log the configuration actions in the nftables netlink api.

This uses the same NETFILTER_CFG record format but overloads the table
field.

  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=?:0;?:0 family=unspecified entries=2 op=nft_register_gen pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
  ...
  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=firewalld:1;?:0 family=inet entries=0 op=nft_register_table pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
  ...
  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=8 op=nft_register_chain pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
  ...
  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=101 op=nft_register_rule pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
  ...
  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=87 op=nft_register_setelem pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
  ...
  type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=0 op=nft_register_set pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld

For further information please see issue
https://github.com/linux-audit/audit-kernel/issues/124

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Changelog:
v2:
- differentiate between xtables and nftables
- add set, setelem, obj, flowtable, gen
- use nentries field as appropriate per type
- overload the "tables" field with table handle and chain/set/flowtable

 include/linux/audit.h         | 52 +++++++++++++++++++++++++
 kernel/auditsc.c              | 24 ++++++++++--
 net/netfilter/nf_tables_api.c | 89 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3fcd9ee49734..d79866a38505 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
+#include <uapi/linux/netfilter/nf_tables.h>
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
@@ -98,6 +99,57 @@ enum audit_nfcfgop {
 	AUDIT_XT_OP_REGISTER,
 	AUDIT_XT_OP_REPLACE,
 	AUDIT_XT_OP_UNREGISTER,
+	AUDIT_NFT_OP_TABLE_REGISTER,
+	AUDIT_NFT_OP_TABLE_UNREGISTER,
+	AUDIT_NFT_OP_CHAIN_REGISTER,
+	AUDIT_NFT_OP_CHAIN_UNREGISTER,
+	AUDIT_NFT_OP_RULE_REGISTER,
+	AUDIT_NFT_OP_RULE_UNREGISTER,
+	AUDIT_NFT_OP_SET_REGISTER,
+	AUDIT_NFT_OP_SET_UNREGISTER,
+	AUDIT_NFT_OP_SETELEM_REGISTER,
+	AUDIT_NFT_OP_SETELEM_UNREGISTER,
+	AUDIT_NFT_OP_GEN_REGISTER,
+	AUDIT_NFT_OP_OBJ_REGISTER,
+	AUDIT_NFT_OP_OBJ_UNREGISTER,
+	AUDIT_NFT_OP_OBJ_RESET,
+	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
+	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+	AUDIT_NFT_OP_INVALID,
+};
+
+struct audit_nftcfgop_tab {
+	enum nf_tables_msg_types	nftop;
+	enum audit_nfcfgop		op;
+};
+
+static const struct audit_nftcfgop_tab audit_nftcfgs[] = {
+	{ NFT_MSG_NEWTABLE,	AUDIT_NFT_OP_TABLE_REGISTER		},
+	{ NFT_MSG_GETTABLE,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELTABLE,	AUDIT_NFT_OP_TABLE_UNREGISTER		},
+	{ NFT_MSG_NEWCHAIN,	AUDIT_NFT_OP_CHAIN_REGISTER		},
+	{ NFT_MSG_GETCHAIN,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELCHAIN,	AUDIT_NFT_OP_CHAIN_UNREGISTER		},
+	{ NFT_MSG_NEWRULE,	AUDIT_NFT_OP_RULE_REGISTER		},
+	{ NFT_MSG_GETRULE,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELRULE,	AUDIT_NFT_OP_RULE_UNREGISTER		},
+	{ NFT_MSG_NEWSET,	AUDIT_NFT_OP_SET_REGISTER		},
+	{ NFT_MSG_GETSET,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELSET,	AUDIT_NFT_OP_SET_UNREGISTER		},
+	{ NFT_MSG_NEWSETELEM,	AUDIT_NFT_OP_SETELEM_REGISTER		},
+	{ NFT_MSG_GETSETELEM,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELSETELEM,	AUDIT_NFT_OP_SETELEM_UNREGISTER		},
+	{ NFT_MSG_NEWGEN,	AUDIT_NFT_OP_GEN_REGISTER		},
+	{ NFT_MSG_GETGEN,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_TRACE,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_NEWOBJ,	AUDIT_NFT_OP_OBJ_REGISTER		},
+	{ NFT_MSG_GETOBJ,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELOBJ,	AUDIT_NFT_OP_OBJ_UNREGISTER		},
+	{ NFT_MSG_GETOBJ_RESET,	AUDIT_NFT_OP_OBJ_RESET			},
+	{ NFT_MSG_NEWFLOWTABLE,	AUDIT_NFT_OP_FLOWTABLE_REGISTER		},
+	{ NFT_MSG_GETFLOWTABLE,	AUDIT_NFT_OP_INVALID			},
+	{ NFT_MSG_DELFLOWTABLE,	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER	},
+	{ NFT_MSG_MAX,		AUDIT_NFT_OP_INVALID			},
 };
 
 extern int is_audit_feature_set(int which);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 468a23390457..3a9100e95fda 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -75,6 +75,7 @@
 #include <linux/uaccess.h>
 #include <linux/fsnotify_backend.h>
 #include <uapi/linux/limits.h>
+#include <uapi/linux/netfilter/nf_tables.h>
 
 #include "audit.h"
 
@@ -136,9 +137,26 @@ struct audit_nfcfgop_tab {
 };
 
 static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
-	{ AUDIT_XT_OP_REGISTER,		"register"	},
-	{ AUDIT_XT_OP_REPLACE,		"replace"	},
-	{ AUDIT_XT_OP_UNREGISTER,	"unregister"	},
+	{ AUDIT_XT_OP_REGISTER,			"xt_register"		   },
+	{ AUDIT_XT_OP_REPLACE,			"xt_replace"		   },
+	{ AUDIT_XT_OP_UNREGISTER,		"xt_unregister"		   },
+	{ AUDIT_NFT_OP_TABLE_REGISTER,		"nft_register_table"	   },
+	{ AUDIT_NFT_OP_TABLE_UNREGISTER,	"nft_unregister_table"	   },
+	{ AUDIT_NFT_OP_CHAIN_REGISTER,		"nft_register_chain"	   },
+	{ AUDIT_NFT_OP_CHAIN_UNREGISTER,	"nft_unregister_chain"	   },
+	{ AUDIT_NFT_OP_RULE_REGISTER,		"nft_register_rule"	   },
+	{ AUDIT_NFT_OP_RULE_UNREGISTER,		"nft_unregister_rule"	   },
+	{ AUDIT_NFT_OP_SET_REGISTER,		"nft_register_set"	   },
+	{ AUDIT_NFT_OP_SET_UNREGISTER,		"nft_unregister_set"	   },
+	{ AUDIT_NFT_OP_SETELEM_REGISTER,	"nft_register_setelem"	   },
+	{ AUDIT_NFT_OP_SETELEM_UNREGISTER,	"nft_unregister_setelem"   },
+	{ AUDIT_NFT_OP_GEN_REGISTER,		"nft_register_gen"	   },
+	{ AUDIT_NFT_OP_OBJ_REGISTER,		"nft_register_obj"	   },
+	{ AUDIT_NFT_OP_OBJ_UNREGISTER,		"nft_unregister_obj"	   },
+	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
+	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
+	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
+	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4471393da6d8..7a386eca6e04 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -12,6 +12,7 @@
 #include <linux/netlink.h>
 #include <linux/vmalloc.h>
 #include <linux/rhashtable.h>
+#include <linux/audit.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -693,6 +694,14 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
+			      ctx->table->name, ctx->table->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			ctx->table->use,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -1428,6 +1437,15 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
+			      ctx->table->name, ctx->table->handle,
+			      ctx->chain->name, ctx->chain->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			ctx->chain->use,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -2691,6 +2709,15 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
+			      ctx->table->name, ctx->table->handle,
+			      ctx->chain->name, ctx->chain->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			rule->handle,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -3692,6 +3719,15 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
 	int err;
+	char *buf = kasprintf(gfp_flags, "%s:%llu;%s:%llu",
+			      ctx->table->name, ctx->table->handle,
+			      set->name, set->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			set->field_count,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -4789,6 +4825,15 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	u32 portid = ctx->portid;
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
+			      ctx->table->name, ctx->table->handle,
+			      set->name, set->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			set->handle,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
@@ -5875,6 +5920,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			    obj->ops->type->type != filter->type)
 				goto cont;
 
+			if (reset) {
+				char *buf = kasprintf(GFP_KERNEL,
+						      "%s:%llu;?:0",
+						      table->name,
+						      table->handle);
+
+				audit_log_nfcfg(buf,
+						family,
+						obj->handle,
+						audit_nftcfgs[NFT_MSG_GETOBJ_RESET].op);
+				kfree(buf);
+			}
+
 			if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NFT_MSG_NEWOBJ,
@@ -5985,6 +6043,17 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
+	if (reset) {
+		char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
+				      table->name, table->handle);
+
+		audit_log_nfcfg(buf,
+				family,
+				obj->handle,
+				audit_nftcfgs[NFT_MSG_GETOBJ_RESET].op);
+		kfree(buf);
+	}
+
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
 				      nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
@@ -6060,6 +6129,14 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 {
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
+			      table->name, table->handle);
+
+	audit_log_nfcfg(buf,
+			family,
+			obj->handle,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
@@ -6686,6 +6763,15 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
+	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
+			      flowtable->table->name, flowtable->table->handle,
+			      flowtable->name, flowtable->handle);
+
+	audit_log_nfcfg(buf,
+			ctx->family,
+			flowtable->hooknum,
+			audit_nftcfgs[event].op);
+	kfree(buf);
 
 	if (ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -6807,6 +6893,9 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	int err;
 
+	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
+			audit_nftcfgs[event].op);
+
 	if (nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
-- 
1.8.3.1

