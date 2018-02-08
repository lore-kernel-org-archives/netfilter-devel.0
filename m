From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 2/4] netlink: add generic object description
 infrastructure
Date: Thu, 8 Feb 2018 17:21:54 +0100
Message-ID: <20180208162154.4prs5hxxx47jxjvn@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
 <20180207013713.2432-3-pablo@netfilter.org>
 <6b52d0e8-de06-0b9c-0874-d65865a36ae9@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="re7qpakrxvv4p4qt"
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6b52d0e8-de06-0b9c-0874-d65865a36ae9@infradead.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--re7qpakrxvv4p4qt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Randy,

On Wed, Feb 07, 2018 at 05:28:20PM -0800, Randy Dunlap wrote:
[...]
> > diff --git a/include/net/nldesc.h b/include/net/nldesc.h
> > new file mode 100644
> > index 000000000000..19306a648f10
> > --- /dev/null
> > +++ b/include/net/nldesc.h
> > @@ -0,0 +1,160 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __NET_NLDESC_H
> > +#define __NET_NLDESC_H
> > +
> > +#include <linux/types.h>
> > +
> > +struct nl_desc_cmd;
> > +struct nl_desc_obj;
> > +
> > +struct nl_desc_cmds {
> > +	int				max;
> > +	const struct nl_desc_cmd	*table;
> > +};
> > +
> > +struct nl_desc_objs {
> > +	int				max;
> > +	const struct nl_desc_obj	**table;
> > +};
> > +
> > +struct nl_desc_req {
> > +	u32				bus;
> > +};
> > +
> > +struct net;
> > +struct sk_buff;
> > +struct nlmsghdr;
> > +struct nlattr;
> > +
> 
> > +
> > +/**
> > + * struct nl_desc_obj - netlink object description
> > + * @id: unique ID to identify this netlink object
> > + * @max: number of attributes to describe this object
> 
>       @attr_max:

Thanks for spotting this.

> > + * @attrs: array of attribute descriptions
> > + */
> > +struct nl_desc_obj {
> > +	u16				id;
> > +	u16				attr_max;
> > +	const struct nl_desc_attr	*attrs;
> > +};
> 
> 
> Is there a test program for this?

I'm attaching what I have used to test this. These files print the
netlink bus description.

> Maybe add it to tools/testing/ ?

Yes, I can place it there, no problem. This userspace code depends on
libmnl though.

I was planning to add infrastructure to libmnl to add a couple of helper
functions that allows us to populate the nl_desc cache and to look up
for presence of commands/attributes.

People that don't like libmnl for whatever reason can add similar code
to their libraries too, of course.

Thanks!

--re7qpakrxvv4p4qt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-examples-add-netlink-bus-description.patch"

>From 7826d6aa47d20bc09f7c8e33a457a5a338a8db55 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 16 Jan 2018 00:05:37 +0100
Subject: [PATCH libmnl] examples: add netlink bus description

Add nft-dump-desc-cmds.c and nft-dump-desc-obj.c to dump command and
object descriptions.
---
 examples/Makefile.am          |  11 ++
 examples/nft-dump-desc-cmds.c | 177 ++++++++++++++++++++++++++++
 examples/nft-dump-desc-objs.c | 263 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 451 insertions(+)
 create mode 100644 examples/nft-dump-desc-cmds.c
 create mode 100644 examples/nft-dump-desc-objs.c

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
-- 
2.11.0


--re7qpakrxvv4p4qt--
