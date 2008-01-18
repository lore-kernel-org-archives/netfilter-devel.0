From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 08/09]: Support conntrack add/delete/query requests
Date: Fri, 18 Jan 2008 17:55:58 +0100 (MET)
Message-ID: <20080118165525.13385.47304.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbYARQ4A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:56:00 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5d2b826674d411f99e571fd35ad5722fed077e5e
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:53:14 2008 +0100

    [LIBNL]: Support conntrack add/delete/query requests
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/netlink/netfilter/ct.h b/include/netlink/netfilter/ct.h
index 965b869..f554017 100644
--- a/include/netlink/netfilter/ct.h
+++ b/include/netlink/netfilter/ct.h
@@ -39,6 +39,15 @@ extern void		nfnl_ct_put(struct nfnl_ct *);
 
 extern int		nfnl_ct_dump_request(struct nl_handle *);
 
+extern struct nl_msg *	nfnl_ct_build_add_request(const struct nfnl_ct *, int);
+extern int		nfnl_ct_add(struct nl_handle *, const struct nfnl_ct *, int);
+
+extern struct nl_msg *	nfnl_ct_build_delete_request(const struct nfnl_ct *, int);
+extern int		nfnl_ct_delete(struct nl_handle *, const struct nfnl_ct *, int);
+
+extern struct nl_msg *	nfnl_ct_build_query_request(const struct nfnl_ct *, int);
+extern int		nfnl_ct_query(struct nl_handle *, const struct nfnl_ct *, int);
+
 extern void		nfnl_ct_set_family(struct nfnl_ct *, uint8_t);
 extern uint8_t		nfnl_ct_get_family(const struct nfnl_ct *);
 
diff --git a/lib/netfilter/ct.c b/lib/netfilter/ct.c
index e9df924..e16a606 100644
--- a/lib/netfilter/ct.c
+++ b/lib/netfilter/ct.c
@@ -9,6 +9,7 @@
  * Copyright (c) 2003-2006 Thomas Graf <tgraf@suug.ch>
  * Copyright (c) 2007 Philip Craig <philipc@snapgear.com>
  * Copyright (c) 2007 Secure Computing Corporation
+ * Copyright (c= 2008 Patrick McHardy <kaber@trash.net>
  */
 
 /**
@@ -388,6 +389,158 @@ static int ct_request_update(struct nl_cache *c, struct nl_handle *h)
 	return nfnl_ct_dump_request(h);
 }
 
+static int nfnl_ct_build_tuple(struct nl_msg *msg, const struct nfnl_ct *ct,
+			       int repl)
+{
+	struct nlattr *tuple, *ip, *proto;
+	struct nl_addr *addr;
+	int family;
+
+	family = nfnl_ct_get_family(ct);
+
+	tuple = nla_nest_start(msg, repl ? CTA_TUPLE_REPLY : CTA_TUPLE_ORIG);
+	if (!tuple)
+		goto nla_put_failure;
+
+	ip = nla_nest_start(msg, CTA_TUPLE_IP);
+	if (!ip)
+		goto nla_put_failure;
+
+	addr = nfnl_ct_get_src(ct, repl);
+	if (addr)
+		NLA_PUT_ADDR(msg,
+			     family == AF_INET ? CTA_IP_V4_SRC : CTA_IP_V6_SRC,
+			     addr);
+
+	addr = nfnl_ct_get_dst(ct, repl);
+	if (addr)
+		NLA_PUT_ADDR(msg,
+			     family == AF_INET ? CTA_IP_V4_DST : CTA_IP_V6_DST,
+			     addr);
+
+	nla_nest_end(msg, ip);
+
+	proto = nla_nest_start(msg, CTA_TUPLE_PROTO);
+	if (!proto)
+		goto nla_put_failure;
+
+	if (nfnl_ct_test_proto(ct))
+		NLA_PUT_U8(msg, CTA_PROTO_NUM, nfnl_ct_get_proto(ct));
+
+	if (nfnl_ct_test_src_port(ct, repl))
+		NLA_PUT_U16(msg, CTA_PROTO_SRC_PORT,
+			    nfnl_ct_get_src_port(ct, repl));
+
+	if (nfnl_ct_test_dst_port(ct, repl))
+		NLA_PUT_U16(msg, CTA_PROTO_DST_PORT,
+			    nfnl_ct_get_dst_port(ct, repl));
+
+	if (nfnl_ct_test_icmp_id(ct, repl))
+		NLA_PUT_U16(msg, CTA_PROTO_ICMP_ID,
+			    nfnl_ct_get_icmp_id(ct, repl));
+
+	if (nfnl_ct_test_icmp_type(ct, repl))
+		NLA_PUT_U8(msg, CTA_PROTO_ICMP_TYPE,
+			    nfnl_ct_get_icmp_type(ct, repl));
+
+	if (nfnl_ct_test_icmp_code(ct, repl))
+		NLA_PUT_U8(msg, CTA_PROTO_ICMP_CODE,
+			    nfnl_ct_get_icmp_code(ct, repl));
+
+	nla_nest_end(msg, proto);
+
+	nla_nest_end(msg, tuple);
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nl_msg *nfnl_ct_build_message(const struct nfnl_ct *ct, int cmd, int flags)
+{
+	struct nl_msg *msg;
+
+	msg = nfnlmsg_alloc_simple(NFNL_SUBSYS_CTNETLINK, cmd, flags,
+				   nfnl_ct_get_family(ct), 0);
+	if (msg == NULL)
+		return NULL;
+
+	if (nfnl_ct_build_tuple(msg, ct, 0) < 0)
+		goto err_out;
+
+	return msg;
+
+err_out:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+struct nl_msg *nfnl_ct_build_add_request(const struct nfnl_ct *ct, int flags)
+{
+	return nfnl_ct_build_message(ct, IPCTNL_MSG_CT_NEW, flags);
+}
+
+int nfnl_ct_add(struct nl_handle *h, const struct nfnl_ct *ct, int flags)
+{
+	struct nl_msg *msg;
+	int err;
+
+	msg = nfnl_ct_build_add_request(ct, flags);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	err = nl_send_auto_complete(h, msg);
+	nlmsg_free(msg);
+	if (err < 0)
+		return err;
+
+	return nl_wait_for_ack(h);
+}
+
+struct nl_msg *nfnl_ct_build_delete_request(const struct nfnl_ct *ct, int flags)
+{
+	return nfnl_ct_build_message(ct, IPCTNL_MSG_CT_DELETE, flags);
+}
+
+int nfnl_ct_del(struct nl_handle *h, const struct nfnl_ct *ct, int flags)
+{
+	struct nl_msg *msg;
+	int err;
+
+	msg = nfnl_ct_build_delete_request(ct, flags);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	err = nl_send_auto_complete(h, msg);
+	nlmsg_free(msg);
+	if (err < 0)
+		return err;
+
+	return nl_wait_for_ack(h);
+}
+
+struct nl_msg *nfnl_ct_build_query_request(const struct nfnl_ct *ct, int flags)
+{
+	return nfnl_ct_build_message(ct, IPCTNL_MSG_CT_GET, flags);
+}
+
+int nfnl_ct_query(struct nl_handle *h, const struct nfnl_ct *ct, int flags)
+{
+	struct nl_msg *msg;
+	int err;
+
+	msg = nfnl_ct_build_query_request(ct, flags);
+	if (msg == NULL)
+		return nl_errno(ENOMEM);
+
+	err = nl_send_auto_complete(h, msg);
+	nlmsg_free(msg);
+	if (err < 0)
+		return err;
+
+	return nl_wait_for_ack(h);
+}
+
 /**
  * @name Cache Management
  * @{
