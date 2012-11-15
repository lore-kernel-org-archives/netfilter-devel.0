From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3] examples: add connlabel dump/set/clear demo programs
Date: Thu, 15 Nov 2012 16:50:11 +0100
Message-ID: <1352994611-3707-4-git-send-email-fw@strlen.de>
References: <1352994611-3707-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41029 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab2KOPsW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:48:22 -0500
In-Reply-To: <1352994611-3707-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 examples/Makefile.am            |   10 +++
 examples/nfct-mnl-dump-labels.c |  103 +++++++++++++++++++++++
 examples/nfct-mnl-set-label.c   |  170 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 283 insertions(+), 0 deletions(-)
 create mode 100644 examples/nfct-mnl-dump-labels.c
 create mode 100644 examples/nfct-mnl-set-label.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 55bd750..a366390 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -3,6 +3,8 @@ include $(top_srcdir)/Make_global.am
 check_PROGRAMS = nfct-mnl-create	\
 		 nfct-mnl-del		\
 		 nfct-mnl-dump		\
+		 nfct-mnl-dump-labels	\
+		 nfct-mnl-set-label	\
 		 nfct-mnl-event		\
 		 nfct-mnl-flush		\
 		 nfct-mnl-get		\
@@ -21,6 +23,14 @@ nfct_mnl_dump_SOURCES = nfct-mnl-dump.c
 nfct_mnl_dump_LDADD = ../src/libnetfilter_conntrack.la
 nfct_mnl_dump_LDFLAGS = -dynamic -ldl -lmnl
 
+nfct_mnl_dump_labels_SOURCES = nfct-mnl-dump-labels.c
+nfct_mnl_dump_labels_LDADD = ../src/libnetfilter_conntrack.la
+nfct_mnl_dump_labels_LDFLAGS = -dynamic -ldl -lmnl
+
+nfct_mnl_set_label_SOURCES = nfct-mnl-set-label.c
+nfct_mnl_set_label_LDADD = ../src/libnetfilter_conntrack.la
+nfct_mnl_set_label_LDFLAGS = -dynamic -ldl -lmnl
+
 nfct_mnl_event_SOURCES = nfct-mnl-event.c
 nfct_mnl_event_LDADD = ../src/libnetfilter_conntrack.la
 nfct_mnl_event_LDFLAGS = -dynamic -ldl -lmnl
diff --git a/examples/nfct-mnl-dump-labels.c b/examples/nfct-mnl-dump-labels.c
new file mode 100644
index 0000000..babb928
--- /dev/null
+++ b/examples/nfct-mnl-dump-labels.c
@@ -0,0 +1,103 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <time.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+static void print_label(struct nf_conntrack *ct, struct nfct_labelmap *map)
+{
+	unsigned int i, max;
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	if (!b)
+		return;
+
+	puts("labels:");
+	max = nfct_bitmask_maxbit(b);
+	for (i = 0; i <= max; i++) {
+		if (nfct_bitmask_test_bit(b, i))
+			printf("\t'%s' (%d)\n", map ? nfct_labelmap_get_name(map, i) : "", i);
+	}
+}
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct;
+	char buf[4096];
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, 0);
+	printf("%s\n", buf);
+
+	print_label(ct, data);
+
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
+int main(void)
+{
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	unsigned int seq, portid;
+	int ret;
+	struct nfct_labelmap *l = nfct_labelmap_new(NULL);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | IPCTNL_MSG_CT_GET;
+	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = AF_UNSPEC;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+
+	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+
+
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, l);
+		if (ret <= MNL_CB_STOP)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	if (l)
+		nfct_labelmap_destroy(l);
+
+	mnl_socket_close(nl);
+
+	return 0;
+}
diff --git a/examples/nfct-mnl-set-label.c b/examples/nfct-mnl-set-label.c
new file mode 100644
index 0000000..dd52011
--- /dev/null
+++ b/examples/nfct-mnl-set-label.c
@@ -0,0 +1,170 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+struct callback_args {
+	struct mnl_socket *nl;
+	unsigned int seq;
+	int bit;
+};
+
+static void set_label(struct nf_conntrack *ct, struct callback_args *cbargs)
+{
+	struct nfct_bitmask *b = (void *) nfct_get_attr(ct, ATTR_CONNLABELS);
+	int bit = cbargs->bit;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	if (b) {
+		if (bit >= 0 && nfct_bitmask_test_bit(b, bit))
+			return;
+	} else if (bit < 0)
+		return;
+
+	b = nfct_bitmask_new(bit < 0 ? 0 : bit);
+	if (!b)
+		return;
+	if (bit >= 0)
+		nfct_bitmask_set_bit(b, bit);
+	nfct_set_attr(ct, ATTR_CONNLABELS, b);
+
+	cbargs->seq++;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | IPCTNL_MSG_CT_NEW;
+	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_CREATE;
+	nlh->nlmsg_seq = cbargs->seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = nfct_get_attr_u8(ct, ATTR_L3PROTO);
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	nfct_nlmsg_build(nlh, ct);
+
+	if (mnl_socket_sendto(cbargs->nl, nlh, nlh->nlmsg_len) < 0)
+		perror("mnl_socket_sendto");
+}
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct;
+	char buf[4096];
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, 0);
+	printf("%s\n", buf);
+
+	set_label(ct, data);
+
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
+static void show_labels(struct nfct_labelmap *l)
+{
+	unsigned int i = 0;
+	const char *name;
+
+	if (l) {
+		fputs("usage: program label, configured labels are:\n", stderr);
+		while ((name = nfct_labelmap_get_name(l, i))) {
+			if (*name)
+				fprintf(stderr, "%s -> bit %d\n", name, i);
+			i++;
+		}
+	} else {
+		fputs("no labels configured, usage: program bit\n", stderr);
+	}
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	unsigned int seq, portid;
+	struct callback_args cbargs;
+	int ret;
+	struct nfct_labelmap *l = nfct_labelmap_new(NULL);
+
+	if (argc < 2)
+		show_labels(l);
+
+	cbargs.bit = l ? nfct_labelmap_get_bit(l, argv[1]) : -1;
+
+	if (cbargs.bit < 0) {
+		cbargs.bit = atoi(argv[1]);
+		if (cbargs.bit == 0 && argv[1][0] != '0')
+			show_labels(l);
+	}
+
+	if (cbargs.bit < 0)
+		puts("will clear all labels");
+	else
+		printf("will set label bit %d\n", cbargs.bit);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | IPCTNL_MSG_CT_GET;
+	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = AF_UNSPEC;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+
+	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+
+	cbargs.nl = nl;
+	cbargs.seq = seq;
+
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, &cbargs);
+		if (ret <= MNL_CB_STOP)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	if (l)
+		nfct_labelmap_destroy(l);
+	mnl_socket_close(nl);
+
+	return 0;
+}
-- 
1.7.8.6

