Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E053D955B;
	Sun, 27 Sep 2026 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548503; cv=none; b=VThJ1Qm/3XUPc5vB71mkXRDx4M+vvqVlGFpf4Fb+NtUbyw8TqOEOmoMN4t2UvXcI3BBwfJfkIgOCDCbuspGbS4JEX+qI3uFV4gLXbv922xR+Ti+8zB3v1jDOw7orCGj1ZpLGwz1OhaOzfd13dP6jYkD3en8USAs/Kr8m+CVMIOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548503; c=relaxed/simple;
	bh=v7l+NgONL6RJEoVn44OGnMYlHd+uFsAFMWAYLseUJgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwFUYb/Hd9nJ4UiVvzCD4IS8aUgJv+VDfFJaScfK21cWW/DYPuUbEBbDOXLtWespyLi3L4pmxg020+7pjU1LKFNhp2l3bCqznEezqmbJJb+Jlpy0TsPueEQcEM2ctkB420KChjjKHhT3mEPIjg60ZgtbmYpkQ4UkP/Rs2mms8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vBn/c4Xx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vBn/c4Xx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548495;
	bh=8DZhnHU2ZNuJNoQ03GYAz7lKrs6YCZ1EAF7tvID17Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBn/c4XxG1oMczAbV64QIjXDJJvwCU6XnXOVY0GbT47+Ff+E/1ZAZ7iM5Yp8YD9tV
	 LREgAfD/AU+ftccgEhKGxV9m81j3XWgttRL228jhwriZ8VLLEOpSnCYwL2/ku5PZ87
	 5LiNcBqYAdcw8VoEEPPWzDEw9EVY25MWh1Hq+1hHmmdsF+K+AbKDYHVfptoeVLv0u4
	 KJpss3pr8IBnEiuy0pqcel5d4m4vr6P2fHESqJV98dUCNuwsy5eR2RaHlCID04LLvo
	 GQ70sEyMTD9SZSQ91JD0VMqcwpIoVM4bopaaL1zcaSZ10Z0WiPnh7gfL6cgzKaSvQz
	 oWFimEEiNRGeg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9106A60082;
	Mon, 28 Sep 2026 00:34:54 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 11/11] netfilter: conntrack: make filtering by zone discoverable
Date: Mon, 28 Sep 2026 00:34:36 +0200
Message-ID: <20260927223436.269024-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ilya Maximets <i.maximets@ovn.org>

Conntrack flush supports filtering by zone using CTA_ZONE, but this
attribute is really hard to use from user space applications.  The
reason is that it is not possible to tell if it's supported or not.

Older kernels silently ignore CTA_ZONE.  And in that case they just
happily flush all the entries from all zones breaking all the existing
connections.  So, applications have to infer support from the kernel
version.  While it works in most cases, it's not a particularly
reliable or desired way to check kernel capabilities from applications
that aim to be portable.  There should be a better way to probe or
discover features in the kernel.

The CTA_FILTER interface on the other hand is simple enough to probe.
We can check for NLM_F_DUMP_FILTERED in the dump to see if filtering
is supported.  And unknown sub-attributes in CTA_FILTER are rejected
explicitly since strict validation is in use there.

Let's add new CTA_FILTER_ZONE that signals that CTA_ZONE should be
filtered on.  It is a flag, since everything in the CTA_FILTER is a
bit mask, i.e., a form of a flag.  If set, it means that CTA_ZONE must
be present and be used for filtering.  If the flag is not set however,
the filtering on CTA_ZONE will still take place to ensure backwards
compatibility.  So, the flag doesn't really change the filtering
behavior, but it allows user space applications to properly discover
support for CTA_ZONE filtering without need to rely on kernel version
parsing or risk accidental flushes of the entire conntrack table,
and also without modifying the kernel state.

A new test variant is added to test with and without the new flag.
Since the setup code is moved into a shared function, expectations
replaced with assertions to bail early if the base setup fails to
avoid the cascade of secondary failures that can be misleading.
Error return is only for the SKIP cases.

Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/netlink/specs/conntrack.yaml    |   6 +
 .../linux/netfilter/nfnetlink_conntrack.h     |   1 +
 net/netfilter/nf_conntrack_netlink.c          |  11 ++
 .../net/netfilter/conntrack_dump_flush.c      | 145 ++++++++++++------
 4 files changed, 117 insertions(+), 46 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index 1d163130241a..56c13705243b 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -393,6 +393,12 @@ attribute-sets:
         name: reply-flags
         type: u32
         doc: bitmask of tuple fields to filter on, reply direction
+      -
+        name: zone
+        type: flag
+        doc: >-
+          Filter on conntrack zone id; requires the top-level zone
+          (``CTA_ZONE``) attribute.
   -
     name: conntrack-attrs
     attributes:
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 43233af75b9d..985f9c08d3e9 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -285,6 +285,7 @@ enum ctattr_filter {
 	CTA_FILTER_UNSPEC,
 	CTA_FILTER_ORIG_FLAGS,
 	CTA_FILTER_REPLY_FLAGS,
+	CTA_FILTER_ZONE,
 	__CTA_FILTER_MAX
 };
 #define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e8477f792c95..4b6abe36028e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -911,6 +911,7 @@ struct ctnetlink_filter {
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
 	[CTA_FILTER_ORIG_FLAGS]		= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
 	[CTA_FILTER_REPLY_FLAGS]	= NLA_POLICY_MASK(NLA_U32, CTA_FILTER_F_ALL),
+	[CTA_FILTER_ZONE]		= { .type = NLA_FLAG },
 };
 
 static int ctnetlink_parse_filter(const struct nlattr *attr,
@@ -930,6 +931,9 @@ static int ctnetlink_parse_filter(const struct nlattr *attr,
 	if (tb[CTA_FILTER_REPLY_FLAGS])
 		filter->reply_flags = nla_get_u32(tb[CTA_FILTER_REPLY_FLAGS]);
 
+	if (tb[CTA_FILTER_ZONE])
+		filter->zone_filter = true;
+
 	return 0;
 }
 
@@ -1006,6 +1010,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	if (err)
 		goto err_filter;
 
+	/* CTA_ZONE is allowed without CTA_FILTER_ZONE. */
 	if (cda[CTA_ZONE]) {
 		err = ctnetlink_parse_zone(cda[CTA_ZONE], &filter->zone);
 		if (err < 0)
@@ -1020,6 +1025,12 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	if (err < 0)
 		goto err_filter;
 
+	/* CTA_FILTER_ZONE cannot be set without CTA_ZONE. */
+	if (filter->zone_filter && !cda[CTA_ZONE]) {
+		err = -EINVAL;
+		goto err_filter;
+	}
+
 	if (filter->orig_flags) {
 		if (!cda[CTA_TUPLE_ORIG]) {
 			err = -EINVAL;
diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index 31b8250ddc53..0c777323f4ba 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -215,7 +215,22 @@ static int count_entries(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone)
+static void put_zone_attr(struct nlmsghdr *nlh, uint16_t zone,
+			  bool use_cta_filter)
+{
+	struct nlattr *nest;
+
+	mnl_attr_put_u16(nlh, CTA_ZONE, htons(zone));
+
+	if (use_cta_filter) {
+		nest = mnl_attr_nest_start(nlh, CTA_FILTER);
+		mnl_attr_put(nlh, CTA_FILTER_ZONE, 0, NULL);
+		mnl_attr_nest_end(nlh, nest);
+	}
+}
+
+static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone,
+				bool use_cta_filter)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -235,7 +250,7 @@ static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone)
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
-	mnl_attr_put_u16(nlh, CTA_ZONE, htons(zone));
+	put_zone_attr(nlh, zone, use_cta_filter);
 
 	ret = mnl_socket_sendto(sock, nlh, nlh->nlmsg_len);
 	if (ret < 0) {
@@ -261,7 +276,8 @@ static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone)
 	return reply_counter;
 }
 
-static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
+static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone,
+				bool use_cta_filter)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -281,7 +297,7 @@ static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
-	mnl_attr_put_u16(nlh, CTA_ZONE, htons(zone));
+	put_zone_attr(nlh, zone, use_cta_filter);
 
 	ret = mnl_socket_sendto(sock, nlh, nlh->nlmsg_len);
 	if (ret < 0) {
@@ -304,43 +320,40 @@ static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
 	return 0;
 }
 
-FIXTURE(conntrack_dump_flush)
-{
-	struct mnl_socket *sock;
-};
-
-FIXTURE_SETUP(conntrack_dump_flush)
+static int conntrack_zone_setup(struct __test_metadata *_metadata,
+				struct mnl_socket **sock)
 {
 	struct in6_addr src, dst;
 	int ret;
 
-	self->sock = mnl_socket_open(NETLINK_NETFILTER);
-	if (!self->sock) {
+	*sock = mnl_socket_open(NETLINK_NETFILTER);
+	if (!*sock) {
 		perror("mnl_socket_open");
-		SKIP(return, "cannot open netlink_netfilter socket");
+		SKIP(return -1, "cannot open netlink_netfilter socket");
 	}
 
-	ret = mnl_socket_bind(self->sock, 0, MNL_SOCKET_AUTOPID);
-	EXPECT_EQ(ret, 0);
+	ret = mnl_socket_bind(*sock, 0, MNL_SOCKET_AUTOPID);
+	ASSERT_EQ(ret, 0);
 
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(*sock, TEST_ZONE_ID, false);
 	if (ret < 0 && errno == EPERM)
-		SKIP(return, "Needs to be run as root");
+		SKIP(return -1, "Needs to be run as root");
 	else if (ret < 0 && errno == EOPNOTSUPP)
-		SKIP(return, "Kernel does not seem to support conntrack zones");
+		SKIP(return -1,
+		     "Kernel does not seem to support conntrack zones");
 
-	ret = conntrack_data_generate_v4(self->sock, 0xf0f0f0f0, 0xf1f1f1f1,
+	ret = conntrack_data_generate_v4(*sock, 0xf0f0f0f0, 0xf1f1f1f1,
 					 TEST_ZONE_ID);
-	EXPECT_EQ(ret, 0);
-	ret = conntrack_data_generate_v4(self->sock, 0xf2f2f2f2, 0xf3f3f3f3,
+	ASSERT_EQ(ret, 0);
+	ret = conntrack_data_generate_v4(*sock, 0xf2f2f2f2, 0xf3f3f3f3,
 					 TEST_ZONE_ID + 1);
-	EXPECT_EQ(ret, 0);
-	ret = conntrack_data_generate_v4(self->sock, 0xf4f4f4f4, 0xf5f5f5f5,
+	ASSERT_EQ(ret, 0);
+	ret = conntrack_data_generate_v4(*sock, 0xf4f4f4f4, 0xf5f5f5f5,
 					 TEST_ZONE_ID + 2);
-	EXPECT_EQ(ret, 0);
-	ret = conntrack_data_generate_v4(self->sock, 0xf6f6f6f6, 0xf7f7f7f7,
+	ASSERT_EQ(ret, 0);
+	ret = conntrack_data_generate_v4(*sock, 0xf6f6f6f6, 0xf7f7f7f7,
 					 NF_CT_DEFAULT_ZONE_ID);
-	EXPECT_EQ(ret, 0);
+	ASSERT_EQ(ret, 0);
 
 	src = (struct in6_addr) {{
 		.__u6_addr32 = {
@@ -358,9 +371,9 @@ FIXTURE_SETUP(conntrack_dump_flush)
 			0x02000000
 		}
 	}};
-	ret = conntrack_data_generate_v6(self->sock, src, dst,
+	ret = conntrack_data_generate_v6(*sock, src, dst,
 					 TEST_ZONE_ID);
-	EXPECT_EQ(ret, 0);
+	ASSERT_EQ(ret, 0);
 	src = (struct in6_addr) {{
 		.__u6_addr32 = {
 			0xb80d0120,
@@ -377,9 +390,9 @@ FIXTURE_SETUP(conntrack_dump_flush)
 			0x04000000
 		}
 	}};
-	ret = conntrack_data_generate_v6(self->sock, src, dst,
+	ret = conntrack_data_generate_v6(*sock, src, dst,
 					 TEST_ZONE_ID + 1);
-	EXPECT_EQ(ret, 0);
+	ASSERT_EQ(ret, 0);
 	src = (struct in6_addr) {{
 		.__u6_addr32 = {
 			0xb80d0120,
@@ -396,9 +409,9 @@ FIXTURE_SETUP(conntrack_dump_flush)
 			0x06000000
 		}
 	}};
-	ret = conntrack_data_generate_v6(self->sock, src, dst,
+	ret = conntrack_data_generate_v6(*sock, src, dst,
 					 TEST_ZONE_ID + 2);
-	EXPECT_EQ(ret, 0);
+	ASSERT_EQ(ret, 0);
 
 	src = (struct in6_addr) {{
 		.__u6_addr32 = {
@@ -416,14 +429,51 @@ FIXTURE_SETUP(conntrack_dump_flush)
 			0x08000000
 		}
 	}};
-	ret = conntrack_data_generate_v6(self->sock, src, dst,
+	ret = conntrack_data_generate_v6(*sock, src, dst,
 					 NF_CT_DEFAULT_ZONE_ID);
-	EXPECT_EQ(ret, 0);
+	ASSERT_EQ(ret, 0);
 
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
+	return 0;
+}
+
+FIXTURE(conntrack_dump_flush)
+{
+	struct mnl_socket *sock;
+};
+
+FIXTURE_VARIANT(conntrack_dump_flush)
+{
+	bool use_cta_filter;
+};
+
+FIXTURE_VARIANT_ADD(conntrack_dump_flush, cta_zone)
+{
+	.use_cta_filter = false,
+};
+
+FIXTURE_VARIANT_ADD(conntrack_dump_flush, cta_filter)
+{
+	.use_cta_filter = true,
+};
+
+FIXTURE_SETUP(conntrack_dump_flush)
+{
+	int ret;
+
+	if (conntrack_zone_setup(_metadata, &self->sock))
+		return;
+
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID, false);
 	EXPECT_GE(ret, 2);
 	if (ret > 2)
 		SKIP(return, "kernel does not support filtering by zone");
+
+	if (variant->use_cta_filter) {
+		ret = conntrack_count_zone(self->sock, TEST_ZONE_ID, true);
+		if (ret < 0 && errno == EINVAL)
+			SKIP(return, "kernel does not support CTA_FILTER_ZONE");
+		ASSERT_GE(ret, 0);
+	}
 }
 
 FIXTURE_TEARDOWN(conntrack_dump_flush)
@@ -434,39 +484,42 @@ TEST_F(conntrack_dump_flush, test_dump_by_zone)
 {
 	int ret;
 
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID,
+				   variant->use_cta_filter);
 	EXPECT_EQ(ret, 2);
 }
 
 TEST_F(conntrack_dump_flush, test_flush_by_zone)
 {
+	bool filter = variant->use_cta_filter;
 	int ret;
 
-	ret = conntrack_flush_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_flush_zone(self->sock, TEST_ZONE_ID, filter);
 	EXPECT_EQ(ret, 0);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID, filter);
 	EXPECT_EQ(ret, 0);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1, filter);
 	EXPECT_EQ(ret, 2);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2, filter);
 	EXPECT_EQ(ret, 2);
-	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID, filter);
 	EXPECT_EQ(ret, 2);
 }
 
 TEST_F(conntrack_dump_flush, test_flush_by_zone_default)
 {
+	bool filter = variant->use_cta_filter;
 	int ret;
 
-	ret = conntrack_flush_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
+	ret = conntrack_flush_zone(self->sock, NF_CT_DEFAULT_ZONE_ID, filter);
 	EXPECT_EQ(ret, 0);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID, filter);
 	EXPECT_EQ(ret, 2);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1, filter);
 	EXPECT_EQ(ret, 2);
-	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2, filter);
 	EXPECT_EQ(ret, 2);
-	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID, filter);
 	EXPECT_EQ(ret, 0);
 }
 
-- 
2.47.3

