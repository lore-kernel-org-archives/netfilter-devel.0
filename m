Received: from felix.runs.onstackit.cloud (felix.runs.onstackit.cloud [45.129.43.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C1B2
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 01:35:18 -0800 (PST)
Date: Tue, 5 Dec 2023 09:35:16 +0000
From: Felix Huettner <felix.huettner@mail.schwarz>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 2/2] flush: support filtering
Message-ID: <c9696e00a16dbf14f3149f8ee7f3e24def730050.1701675975.git.felix.huettner@mail.schwarz>
References: <cover.1701675975.git.felix.huettner@mail.schwarz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1701675975.git.felix.huettner@mail.schwarz>

flushing already supports filtering on the kernel side for value like
mark, l3num or zone. This patch extends the userspace code to also
support this.

To reduce code duplication the `nfct_filter_dump` struct and associated
logic is reused. Note that filtering by tuple is not supported, since
`CTA_FILTER` is not yet supported on the kernel side for flushing.
Trying to use it returns `-ENOTSUP`.

Signed-off-by: Felix Huettner <felix.huettner@mail.schwarz>
---
 include/internal/prototypes.h  |  1 +
 src/conntrack/api.c            |  1 +
 src/conntrack/filter_dump.c    |  9 +++++
 utils/.gitignore               |  1 +
 utils/Makefile.am              |  4 +++
 utils/conntrack_flush_filter.c | 60 ++++++++++++++++++++++++++++++++++
 6 files changed, 76 insertions(+)
 create mode 100644 utils/conntrack_flush_filter.c

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 5e935f0..82a3f29 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -36,6 +36,7 @@ void __copy_fast(struct nf_conntrack *ct1, const struct nf_conntrack *ct);
 int __setup_netlink_socket_filter(int fd, struct nfct_filter *filter);
 
 int __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
+int __build_filter_flush(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
 
 int nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type);
 int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 60c87b3..769eb1a 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -835,6 +835,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 		break;
 	case NFCT_Q_FLUSH_FILTER:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_DELETE, NLM_F_ACK, *family, 1);
+		assert(__build_filter_flush(req, size, data) == 0);
 		break;
 	case NFCT_Q_DUMP:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, *family,
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 0a19985..2d32dcd 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -64,3 +64,12 @@ int __build_filter_dump(struct nfnlhdr *req, size_t size,
 {
 	return nfct_nlmsg_build_filter(&req->nlh, filter_dump);
 }
+
+int __build_filter_flush(struct nfnlhdr *req, size_t size,
+			const struct nfct_filter_dump *filter_dump)
+{
+	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_TUPLE)) {
+		return -ENOTSUP;
+	}
+	return nfct_nlmsg_build_filter(&req->nlh, filter_dump);
+}
diff --git a/utils/.gitignore b/utils/.gitignore
index 0de05c0..c63fd8b 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -7,6 +7,7 @@
 /conntrack_events
 /conntrack_filter
 /conntrack_flush
+/conntrack_flush_filter
 /conntrack_get
 /conntrack_grp_create
 /conntrack_master
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 438ca74..e24d037 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -10,6 +10,7 @@ check_PROGRAMS = expect_dump expect_create expect_get expect_delete \
 	       conntrack_grp_create \
 	       conntrack_dump_filter \
 	       conntrack_dump_filter_tuple \
+		   conntrack_flush_filter \
 	       ctexp_events
 
 conntrack_grp_create_SOURCES = conntrack_grp_create.c
@@ -42,6 +43,9 @@ conntrack_dump_filter_tuple_LDADD = ../src/libnetfilter_conntrack.la
 conntrack_flush_SOURCES = conntrack_flush.c
 conntrack_flush_LDADD = ../src/libnetfilter_conntrack.la
 
+conntrack_flush_filter_SOURCES = conntrack_flush_filter.c
+conntrack_flush_filter_LDADD = ../src/libnetfilter_conntrack.la
+
 conntrack_events_SOURCES = conntrack_events.c
 conntrack_events_LDADD = ../src/libnetfilter_conntrack.la
 
diff --git a/utils/conntrack_flush_filter.c b/utils/conntrack_flush_filter.c
new file mode 100644
index 0000000..6e8d93b
--- /dev/null
+++ b/utils/conntrack_flush_filter.c
@@ -0,0 +1,60 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+static int cb(enum nf_conntrack_msg_type type,
+	      struct nf_conntrack *ct,
+	      void *data)
+{
+	char buf[1024];
+
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3 | NFCT_OF_TIMESTAMP);
+	printf("%s\n", buf);
+
+	return NFCT_CB_CONTINUE;
+}
+
+int main(void)
+{
+	int ret;
+	struct nfct_handle *h;
+
+	h = nfct_open(CONNTRACK, 0);
+	if (!h) {
+		perror("nfct_open");
+		return -1;
+	}
+	struct nfct_filter_dump *filter_dump = nfct_filter_dump_create();
+	if (filter_dump == NULL) {
+		perror("nfct_filter_dump_alloc");
+		return -1;
+	}
+	struct nfct_filter_dump_mark filter_dump_mark = {
+		.val = 1,
+		.mask = 0xffffffff,
+	};
+	nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_MARK,
+					&filter_dump_mark);
+	nfct_filter_dump_set_attr_u8(filter_dump, NFCT_FILTER_DUMP_L3NUM,
+					AF_INET);
+	nfct_filter_dump_set_attr_u16(filter_dump, NFCT_FILTER_DUMP_ZONE,
+					123);
+
+	nfct_callback_register(h, NFCT_T_ALL, cb, NULL);
+	ret = nfct_query(h, NFCT_Q_FLUSH_FILTER, filter_dump);
+
+	nfct_filter_dump_destroy(filter_dump);
+
+	printf("TEST: get conntrack ");
+	if (ret == -1)
+		printf("(%d)(%s)\n", ret, strerror(errno));
+	else
+		printf("(OK)\n");
+
+	nfct_close(h);
+
+	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
+}
-- 
2.43.0

