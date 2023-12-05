Received: from felix.runs.onstackit.cloud (felix.runs.onstackit.cloud [45.129.43.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC683B2
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 01:35:05 -0800 (PST)
Date: Tue, 5 Dec 2023 09:35:03 +0000
From: Felix Huettner <felix.huettner@mail.schwarz>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 1/2] dump: support filtering by zone
Message-ID: <f5abe59a5d9577db8a5e07317aab90cede94d90a.1701675975.git.felix.huettner@mail.schwarz>
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

based on a kernel side extension of the conntrack api, this patch brings
this extension to userspace.

When dumping the conntrack table we can now filter based on the
conntrack zone directly in kernel space. If the kernel does not yet
support this feature this filtering is ignored.

Signed-off-by: Felix Huettner <felix.huettner@mail.schwarz>
---
 include/internal/object.h                           |  1 +
 .../libnetfilter_conntrack/libnetfilter_conntrack.h |  5 +++++
 src/conntrack/api.c                                 | 13 +++++++++++++
 src/conntrack/build_mnl.c                           |  3 +++
 src/conntrack/filter_dump.c                         |  8 ++++++++
 utils/conntrack_dump_filter.c                       |  2 ++
 6 files changed, 32 insertions(+)

diff --git a/include/internal/object.h b/include/internal/object.h
index 4cac4f1..8854ef2 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -293,6 +293,7 @@ struct nfct_filter_dump {
 	struct nfct_filter_dump_mark	status;
 	uint8_t				l3num;
 	uint32_t			set;
+	uint16_t			zone;
 };
 
 /*
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 76b5c27..2e9458a 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -547,6 +547,7 @@ enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
 	NFCT_FILTER_DUMP_STATUS,	/* struct nfct_filter_dump_mark */
+	NFCT_FILTER_DUMP_ZONE,		/* uint16_t */
 	NFCT_FILTER_DUMP_TUPLE,
 	NFCT_FILTER_DUMP_MAX
 };
@@ -563,6 +564,10 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
 				  const enum nfct_filter_dump_attr type,
 				  uint8_t data);
 
+void nfct_filter_dump_set_attr_u16(struct nfct_filter_dump *filter_dump,
+				  const enum nfct_filter_dump_attr type,
+				  uint16_t data);
+
 /* low level API: netlink functions */
 
 extern __attribute__((deprecated)) int
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index cd8bea8..60c87b3 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1551,6 +1551,19 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
 	nfct_filter_dump_set_attr(filter_dump, type, &value);
 }
 
+/**
+ * nfct_filter_dump_attr_set_u16 - set u16 dump filter attribute
+ * \param filter dump filter object that we want to modify
+ * \param type filter attribute type
+ * \param value value of the filter attribute using unsigned int (32 bits).
+ */
+void nfct_filter_dump_set_attr_u16(struct nfct_filter_dump *filter_dump,
+				  const enum nfct_filter_dump_attr type,
+				  uint16_t value)
+{
+	nfct_filter_dump_set_attr(filter_dump, type, &value);
+}
+
 /**
  * @}
  */
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index eb9fcbf..eed0679 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -658,6 +658,9 @@ int nfct_nlmsg_build_filter(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, CTA_STATUS_MASK,
 				 htonl(filter_dump->status.mask));
 	}
+	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_ZONE)) {
+		mnl_attr_put_u16(nlh, CTA_ZONE, htons(filter_dump->zone));
+	}
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_TUPLE)) {
 		const struct nf_conntrack *ct = &filter_dump->ct;
 		struct nlattr *nest;
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 5723a44..0a19985 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -37,6 +37,13 @@ set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 	filter_dump->l3num = *((uint8_t *)value);
 }
 
+static void
+set_filter_dump_attr_zone(struct nfct_filter_dump *filter_dump,
+			    const void *value)
+{
+	filter_dump->zone = *((uint16_t *)value);
+}
+
 static void
 set_filter_dump_attr_tuple(struct nfct_filter_dump *filter_dump,
 			   const void *value)
@@ -48,6 +55,7 @@ const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
 	[NFCT_FILTER_DUMP_MARK]		= set_filter_dump_attr_mark,
 	[NFCT_FILTER_DUMP_L3NUM]	= set_filter_dump_attr_family,
 	[NFCT_FILTER_DUMP_STATUS]	= set_filter_dump_attr_status,
+	[NFCT_FILTER_DUMP_ZONE]		= set_filter_dump_attr_zone,
 	[NFCT_FILTER_DUMP_TUPLE]	= set_filter_dump_attr_tuple,
 };
 
diff --git a/utils/conntrack_dump_filter.c b/utils/conntrack_dump_filter.c
index 41e3f0c..16492ac 100644
--- a/utils/conntrack_dump_filter.c
+++ b/utils/conntrack_dump_filter.c
@@ -40,6 +40,8 @@ int main(void)
 					&filter_dump_mark);
 	nfct_filter_dump_set_attr_u8(filter_dump, NFCT_FILTER_DUMP_L3NUM,
 					AF_INET);
+	nfct_filter_dump_set_attr_u16(filter_dump, NFCT_FILTER_DUMP_ZONE,
+					123);
 
 	nfct_callback_register(h, NFCT_T_ALL, cb, NULL);
 	ret = nfct_query(h, NFCT_Q_DUMP_FILTER, filter_dump);
-- 
2.43.0

