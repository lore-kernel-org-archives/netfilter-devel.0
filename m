Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8673BC4321A
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 10:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECB72087F
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 10:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfD0KwU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 06:52:20 -0400
Received: from mail.us.es ([193.147.175.20]:57444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfD0KwT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 06:52:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4E82AF26EE
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 12:52:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CBF6DA714
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 12:52:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3072FDA711; Sat, 27 Apr 2019 12:52:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 487D3DA704;
        Sat, 27 Apr 2019 12:52:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Apr 2019 12:52:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B3A14265A32;
        Sat, 27 Apr 2019 12:52:09 +0200 (CEST)
Date:   Sat, 27 Apr 2019 12:52:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190427105208.xlqv77pmjvkpyxr4@salvia>
References: <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
 <20190411192647.xsnhno6gcf5fen5u@salvia>
 <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
 <20190426164252.a2yxjxf3thotrqu3@salvia>
 <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
 <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
 <20190426180430.h5h7lqivx2qufuyi@salvia>
 <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
 <20190426192054.4iedgasehywqzyx6@salvia>
 <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hq2x6vy3dqr766cf"
Content-Disposition: inline
In-Reply-To: <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--hq2x6vy3dqr766cf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 26, 2019 at 09:37:43PM +0200, Johannes Berg wrote:
> On Fri, 2019-04-26 at 21:20 +0200, Pablo Neira Ayuso wrote:
> 
[...]
> So ... I guess I need to think about this a bit more.
> 
> My approach to this was that as long as you have a single enum
> (namespace) for attributes (e.g. enum nft_chain_attributes to pick a
> random example), you'd also want to have a single policy for these,
> describing the possibilities.
> 
> I do admit though that this doesn't cover the "only some of these
> attributes are valid for a given command" part, and I also admit that I
> had sort of punted that part.
> 
> We can solve that by having separate policies, so if you have two
> operations using NTFA_CHAIN_*, then perhaps an operation deletes a chain
> can only take a NFTA_CHAIN_HANDLE or NFTA_CHAIN_NAME, but an operations
> that sets things inside might take all the other attributes.
>
> HOWEVER, having separate policies then opens up an easy avenue for
> (mistakenly or not) having, well, separate policies! Even for the same
> attribute type. And that's something we really *don't* want.
>
> So I actually think that separating "type description", which is the
> policy today, from the "type validity description" is valuable, because
> ideally we do want each type (e.g. NFTA_CHAIN_HANDLE) to always be the
> same regardless of command, so that a hypothetical GET_STATS command
> won't take a U64 CHAIN_HANDLE while a (similarly hypothetical)
> DELETE_CHAIN command takes a U32 CHAIN_HANDLE!

If we want to avoid the extra code for the netlink description, and
reuse the existing policy objects, then we'll need policies for each
command that express what attributes make sense per command as you
describe above.

> Hence my thought of separating "this is the policy for the attributes
> (types)" and "this is the list of allowed types for this command". I do
> realize now that the latter becomes difficult with nested attributes
> though, but we're probably better off finding ways to express that than
> having entirely different policies (also, the data would be smaller).

The netlink description is telling what attributes are available for
each command and policies, so policy definitions are a subset of the
netlink description.

If I understand well, your concern is that you would like that we
use reuse / extend the existing policy structures to be used for the
netlink description. That's very reasonable indeed and a good idea.

> [[[ total aside: we could do something like the "list of allowed types"
> being an array of
> union valid_type {
>    u16 attr;
>    struct nested *nested;
> };
> 
> with
> 
> struct nested {
>   u16 attr;
>   union valid_type *valid_nested_types;
> };
>
> I think we can probably safely assume that pointers are always >>MAX_U16
> but if not we can either make that larger or find other ways of
> disambiguating, e.g. by alignment (and making ATTR_TO_PTR(attr)
> something like "(attr << 1) | 0x1" since "struct nested" requires 2-byte 
> alignment.
> 
> > > > If we use the list policies that you propose, then it's just an extra
> > > > enumeration to maintain for each command. And many commands will
> > > > likely reuse the same object ID.
> > > 
> > > A policy pointer, really.
> > 
> > Sort of, but it has to be stable along time for userspace, right?
> > Actually, it's an ID.
> 
> The ID in my policy export is not stable in any way. The only thing that
> it's used for is to identify which sub-policy is used while you're
> dumping it. It will be stable by virtue of the algorithm, but will
> change when you add different sub-policy links etc. You cannot rely on
> it being stable, but you also do not need to since it's only relevant
> that you are able to identify the nested policy while dumping.
>
> > > The list of policies is just built internally when you dump out a policy
> > > with its sub-policies for nested attributes/arrays.
> > 
> > If we expose these to userspace, we need that these object IDs are
> > stable, hence the enum. So userspace results in a simple program that
> > just makes look ups for the object ID that contains the description of
> > the attributes that are available.
> 
> Well, no.
> 
> You're now thinking of the "policy ID" I assigned for the wire format as
> the object ID, but really that's not what it is. The object ID that
> you're looking for is the attribute type of the nested attribute.

I'm attaching userspace code for the netlink description
infrastructure for libmnl. It should be easy to rework it to build a
flat table with these IDs. The IDs are helping to provide a easy way
to express this graph in a data structure that is easy to navigate
from userspace.

My usecase is this: I don't want to probe the kernel to guess if a
command / attribute is available for this kernel version or not.
I just want to dump the netlink description, then navigate this table
to search if that command / attribute is there.

> So if you have
> 
> struct nla_policy nested_policy[...] = { ... };
> 
> struct nla_policy policy[...] = {
>     [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
> };
> 
> and you dump out starting from "policy" then yes, "policy" will have ID
> 0, and "nested_policy" will have ID 1, but those are only temporary
> identifiers for the dump. What's really relevant is the attribute type
> "MY_ATTR".

Do you have userspace I can have a look? With runtime / dynamic ID
generation, I cannot see yet how to navigate such a table or how the
userspace representation would look like.

By using MY_ATTR as ID, I think you will have to build a graph
structure in userspace, I was trying to provide a simple flat table
representation for userspace.

Thanks!

--hq2x6vy3dqr766cf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nl-desc-libmnl.patch"

commit 7826d6aa47d20bc09f7c8e33a457a5a338a8db55
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Jan 16 00:05:37 2018 +0100

    examples: add netlink bus description
    
    Add nft-dump-desc-cmds.c and nft-dump-desc-obj.c to dump command and
    object descriptions.

diff --git a/examples/Makefile.am b/examples/Makefile.am
index e5cb052b315c..a8d4ba50f5ad 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -1 +1,12 @@
+include $(top_srcdir)/Make_global.am
+
 SUBDIRS = genl kobject netfilter rtnl
+
+check_PROGRAMS = nft-dump-desc-cmds \
+                 nft-dump-desc-objs
+
+nft_dump_desc_cmds_SOURCES = nft-dump-desc-cmds.c
+nft_dump_desc_cmds_LDADD = ../src/libmnl.la
+
+nft_dump_desc_objs_SOURCES = nft-dump-desc-objs.c
+nft_dump_desc_objs_LDADD = ../src/libmnl.la
diff --git a/examples/nft-dump-desc-cmds.c b/examples/nft-dump-desc-cmds.c
new file mode 100644
index 000000000000..cfb5276e911f
--- /dev/null
+++ b/examples/nft-dump-desc-cmds.c
@@ -0,0 +1,177 @@
+#include <endian.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <time.h>
+#include <arpa/inet.h>
+#include <inttypes.h>
+
+#include <linux/netlink.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#include <libmnl/libmnl.h>
+
+struct nl_desc_cmd;
+struct nl_desc_attr;
+
+struct nl_desc {
+	uint32_t			num_cmds;
+	struct nl_desc_cmd		*cmds;
+};
+
+struct nl_desc_cmd {
+	uint32_t			id;
+	uint32_t			obj_id;
+};
+
+static struct nl_desc nl_desc;
+
+static int nla_desc_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NLA_DESC_CMD_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NLA_DESC_CMD_ID:
+	case NLA_DESC_CMD_OBJ:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void print_desc_cmd(const struct nlattr *nest, struct nl_desc_cmd *cmd)
+{
+	struct nlattr *tb[NLA_DESC_CMD_MAX + 1] = {};
+
+	mnl_attr_parse_nested(nest, nla_desc_attr_cb, tb);
+	if (tb[NLA_DESC_CMD_ID])
+		cmd->id = mnl_attr_get_u32(tb[NLA_DESC_CMD_ID]);
+	if (tb[NLA_DESC_CMD_OBJ])
+		cmd->obj_id = mnl_attr_get_u32(tb[NLA_DESC_CMD_OBJ]);
+}
+
+static void print_desc_cmds(const struct nlattr *nest, struct nl_desc_cmd *cmds)
+{
+	struct nlattr *pos;
+	int j = 1;
+
+	mnl_attr_for_each_nested(pos, nest)
+		print_desc_cmd(pos, &cmds[j++]);
+}
+
+static int nla_desc_cmds_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NLA_DESC_OBJ_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NLA_DESC_NUM_OBJS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NLA_DESC_OBJS:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[NLA_DESC_CMDS_MAX + 1] = {};
+
+	mnl_attr_parse(nlh, 0, nla_desc_cmds_cb, tb);
+	if (tb[NLA_DESC_CMDS_NUM]) {
+		nl_desc.num_cmds = mnl_attr_get_u32(tb[NLA_DESC_CMDS_NUM]);
+
+		nl_desc.cmds = calloc(nl_desc.num_cmds + 1, sizeof(struct nl_desc_cmd));
+		if (!nl_desc.cmds)
+			return MNL_CB_ERROR;
+	}
+
+	if (tb[NLA_DESC_CMDS])
+		print_desc_cmds(tb[NLA_DESC_CMDS], nl_desc.cmds);
+
+	return MNL_CB_OK;
+}
+
+#define NETLINK_DESC	23
+#define NLDESC_GET_CMDS	16
+
+int main(void)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	uint32_t seq, portid;
+	struct nlattr *nest;
+	int ret, i;
+
+	nl = mnl_socket_open(NETLINK_DESC);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = NLDESC_GET_CMDS;
+	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	mnl_attr_put_u32(nlh, NLA_DESC_REQ_BUS, NETLINK_NETFILTER);
+	nest = mnl_attr_nest_start(nlh, NLA_DESC_REQ_DATA);
+	mnl_attr_put_u32(nlh, NFNL_DESC_REQ_SUBSYS, NFNL_SUBSYS_NFTABLES);
+	mnl_attr_nest_end(nlh, nest);
+
+	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	while (1) {
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, &nl_desc);
+		if (ret == -1) {
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		} else if (ret <= MNL_CB_STOP)
+                        break;
+	}
+
+	mnl_socket_close(nl);
+
+	for (i = 1; nl_desc.cmds[i].obj_id; i++) {
+		printf("cmd = %d\n", nl_desc.cmds[i].id);
+		printf("obj_id = %d\n", nl_desc.cmds[i].obj_id);
+	}
+
+	return 0;
+}
diff --git a/examples/nft-dump-desc-objs.c b/examples/nft-dump-desc-objs.c
new file mode 100644
index 000000000000..8f5b365e3c64
--- /dev/null
+++ b/examples/nft-dump-desc-objs.c
@@ -0,0 +1,263 @@
+#include <endian.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <time.h>
+#include <arpa/inet.h>
+#include <inttypes.h>
+
+#include <linux/netlink.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#include <libmnl/libmnl.h>
+
+struct n_desc_obj;
+struct n_desc_attr;
+
+struct nl_desc {
+	uint32_t			num_objs;
+	struct nl_desc_obj		*objs;
+};
+
+struct nl_desc_obj {
+	uint16_t			id;
+	uint16_t			max;
+	struct nl_desc_attr		*attrs;
+};
+
+struct nl_desc_attr {
+	uint16_t			nest_id;
+	uint16_t			num;
+	uint16_t			type;
+	uint16_t			len;
+	uint32_t			max;
+};
+
+static struct nl_desc nl_desc;
+
+static int nla_desc_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NLA_DESC_ATTR_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
+	case NLA_DESC_ATTR_NUM:
+	case NLA_DESC_ATTR_TYPE:
+	case NLA_DESC_ATTR_LEN:
+	case NLA_DESC_ATTR_MAXVAL:
+	case NLA_DESC_ATTR_NEST_ID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void print_desc_attr(const struct nlattr *nest, struct nl_desc_attr *attr)
+{
+	struct nlattr *tb[NLA_DESC_ATTR_MAX + 1] = {};
+
+	mnl_attr_parse_nested(nest, nla_desc_attr_cb, tb);
+	if (tb[NLA_DESC_ATTR_NUM])
+		attr->num = mnl_attr_get_u32(tb[NLA_DESC_ATTR_NUM]);
+	if (tb[NLA_DESC_ATTR_TYPE])
+		attr->type = mnl_attr_get_u32(tb[NLA_DESC_ATTR_TYPE]);
+	if (tb[NLA_DESC_ATTR_LEN])
+		attr->len = mnl_attr_get_u32(tb[NLA_DESC_ATTR_LEN]);
+	if (tb[NLA_DESC_ATTR_MAXVAL])
+		attr->max = mnl_attr_get_u32(tb[NLA_DESC_ATTR_MAXVAL]);
+	if (tb[NLA_DESC_ATTR_NEST_ID])
+		attr->nest_id = mnl_attr_get_u32(tb[NLA_DESC_ATTR_NEST_ID]);
+}
+
+static void print_desc_attrs(const struct nlattr *nest, struct nl_desc_attr *attrs)
+{
+	struct nlattr *pos;
+	int j = 1;
+
+	mnl_attr_for_each_nested(pos, nest)
+		print_desc_attr(pos, &attrs[j++]);
+}
+
+static int nla_desc_obj_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NLA_DESC_OBJ_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NLA_DESC_OBJ_ID:
+	case NLA_DESC_OBJ_ATTRS_MAX:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NLA_DESC_OBJ_ATTRS:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void print_desc_obj(const struct nlattr *nest)
+{
+	struct nlattr *tb[NLA_DESC_OBJ_MAX + 1] = {};
+	uint32_t id = 0, attrs_max;
+
+	mnl_attr_parse_nested(nest, nla_desc_obj_attr_cb, tb);
+	if (tb[NLA_DESC_OBJ_ID])
+		id = mnl_attr_get_u32(tb[NLA_DESC_OBJ_ID]);
+	if (tb[NLA_DESC_OBJ_ATTRS_MAX]) {
+		attrs_max = mnl_attr_get_u32(tb[NLA_DESC_OBJ_ATTRS_MAX]);
+
+		nl_desc.objs[id].attrs = calloc(attrs_max + 1, sizeof(struct nl_desc_attr));
+		if (!nl_desc.objs[id].attrs)
+			return;
+
+		nl_desc.objs[id].max = attrs_max;
+	}
+	if (tb[NLA_DESC_OBJ_ATTRS])
+		print_desc_attrs(tb[NLA_DESC_OBJ_ATTRS], nl_desc.objs[id].attrs);
+}
+
+static void print_desc_objs(const struct nlattr *nest)
+{
+	struct nlattr *pos;
+
+	mnl_attr_for_each_nested(pos, nest)
+		print_desc_obj(pos);
+}
+
+static int nla_desc_objs_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NLA_DESC_OBJ_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case NLA_DESC_NUM_OBJS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	case NLA_DESC_OBJS:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[NLA_DESC_MAX + 1] = {};
+
+	mnl_attr_parse(nlh, 0, nla_desc_objs_cb, tb);
+	if (tb[NLA_DESC_NUM_OBJS]) {
+		nl_desc.num_objs = mnl_attr_get_u32(tb[NLA_DESC_NUM_OBJS]);
+
+		nl_desc.objs = calloc(nl_desc.num_objs + 1, sizeof(struct nl_desc_obj));
+		if (!nl_desc.objs)
+			return MNL_CB_ERROR;
+	}
+
+	if (tb[NLA_DESC_OBJS])
+		print_desc_objs(tb[NLA_DESC_OBJS]);
+
+	return MNL_CB_OK;
+}
+
+#define NETLINK_DESC	23
+#define NLDESC_GET_OBJS	18
+
+int main(void)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	uint32_t seq, portid;
+	struct nlattr *nest;
+	int ret, i, j;
+
+	nl = mnl_socket_open(NETLINK_DESC);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = NLDESC_GET_OBJS;
+	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	mnl_attr_put_u32(nlh, NLA_DESC_REQ_BUS, NETLINK_NETFILTER);
+	nest = mnl_attr_nest_start(nlh, NLA_DESC_REQ_DATA);
+	mnl_attr_put_u32(nlh, NFNL_DESC_REQ_SUBSYS, NFNL_SUBSYS_NFTABLES);
+	mnl_attr_nest_end(nlh, nest);
+
+	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+	if (ret == -1) {
+		perror("mnl_socket_sendto");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	while (1) {
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			perror("mnl_socket_recvfrom");
+			exit(EXIT_FAILURE);
+		}
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, &nl_desc);
+		if (ret == -1) {
+			perror("mnl_cb_run");
+			exit(EXIT_FAILURE);
+		} else if (ret <= MNL_CB_STOP)
+                        break;
+	}
+
+	mnl_socket_close(nl);
+
+	for (i = 1; i <= nl_desc.num_objs; i++) {
+		printf("id = %d\n", i);
+		printf("attrs_max = %d\n", nl_desc.objs[i].max);
+		for (j = 1; j < nl_desc.objs[i].max + 1; j++) {
+			printf("\t---------\n");
+			printf("\tnum = %d\n", nl_desc.objs[i].attrs[j].num);
+			printf("\ttype = %d\n", nl_desc.objs[i].attrs[j].type);
+			if (nl_desc.objs[i].attrs[j].nest_id)
+				printf("\tnest_id = %d\n", nl_desc.objs[i].attrs[j].nest_id);
+			else {
+				printf("\tlen = %d\n", nl_desc.objs[i].attrs[j].len);
+				if (nl_desc.objs[i].attrs[j].max)
+					printf("\tmax = %d\n", nl_desc.objs[i].attrs[j].max);
+			}
+		}
+	}
+
+	return 0;
+}

--hq2x6vy3dqr766cf--
