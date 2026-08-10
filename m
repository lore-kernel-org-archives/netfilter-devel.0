Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDAC449B3D;
	Mon, 10 Aug 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390853; cv=none; b=lBjNnTDAzHDFUpNavc9uyzFbpCSiZy38vMYzNq32BS9z9+iIONVKDOH8oHoi9T9+5aWTdvNq39sOC8gDjkrN53Og/iYmudY+s9a7cqJjewRYYUD9zOI9fVI3VeC9DXlKh96fj5j6RUgOhvHo5toS1hch6KYGnYyRWsoVrHjo7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390853; c=relaxed/simple;
	bh=qJo/+puEs05rtfAup6SCUl6vCqomz3hFd0UdXGwNoB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW7K9MuIJNLyuF7X9UBtBmSZP/afM27hxZwk+yisS4CGLuj4/FrHktU1pUMdmITAiZpyhObTpfU4n88OA31NT0RNQ5IiW+kHHI+ycipO6JM6iBqMPfnvQ6QAeclzIHzPcf4R6Rzs0abjMK6IHni4llP3PAaAc7yF3pjBLtjvyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AQiwimKn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AQiwimKn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F05A46021A;
	Mon, 10 Aug 2026 21:40:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390841;
	bh=nPuyOZBRb8z1aRwUidnIcLGbi1nMdd7ciC5imrcO/BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQiwimKnW4ERQS+6fB0eyzXpSAub+zJR0Ybln6/osH2O1jLPeirehxQV8E3IiAH0x
	 uJY9uE3zDpJ72iBuR5Um+FP5gcuPd/mfDi8NxUT78+hyzCchwngytsgQ3mMDRW8z3r
	 bHOlgZYlYeaVRrbD+N8bytMgnulBWR+bGfAB22KeERXNQ3IjjAvQN+ELx+PjaZRKui
	 OLedDvY4AEFdZJlQgpsWpVzDwmGx7xRsX3RvgIihXYNiXPjLo+ir4o8CRa0cKzarPb
	 pGEGLycAmlWzFGIup3SwqLmvUi8swrdq5bn10U7u60SZuhxMrYXDUCc+kH+ffyKhFp
	 1fGgR4WI6zwnA==
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
Subject: [PATCH net-next 12/12] selftests: netfilter: conntrack_dump_flush: remove unused variables and fix typo
Date: Mon, 10 Aug 2026 21:40:15 +0200
Message-ID: <20260810194015.932627-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

Remove unused 'rplnlh' in conntrack_data_insert(), and remove unused
'rplnlh' and 'nest' variables in conntrack_count_zone() and
conntrack_flush_zone(). These variables were declared but never used
since their introduction.

Also fix typo: rename misspelled conntracK_count_zone() to
conntrack_count_zone().

Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/netfilter/conntrack_dump_flush.c      | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index 5cecb8a1bc94..31b8250ddc53 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -102,7 +102,6 @@ static int conntrack_data_insert(struct mnl_socket *sock, struct nlmsghdr *nlh,
 				 uint16_t zone)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *rplnlh;
 	unsigned int portid;
 	int ret;
 
@@ -216,12 +215,11 @@ static int count_entries(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
+static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh, *rplnlh;
+	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
-	struct nlattr *nest;
 	unsigned int portid;
 	int ret;
 
@@ -266,9 +264,8 @@ static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
 static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh, *rplnlh;
+	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfh;
-	struct nlattr *nest;
 	unsigned int portid;
 	int ret;
 
@@ -326,7 +323,7 @@ FIXTURE_SETUP(conntrack_dump_flush)
 	ret = mnl_socket_bind(self->sock, 0, MNL_SOCKET_AUTOPID);
 	EXPECT_EQ(ret, 0);
 
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
 	if (ret < 0 && errno == EPERM)
 		SKIP(return, "Needs to be run as root");
 	else if (ret < 0 && errno == EOPNOTSUPP)
@@ -423,7 +420,7 @@ FIXTURE_SETUP(conntrack_dump_flush)
 					 NF_CT_DEFAULT_ZONE_ID);
 	EXPECT_EQ(ret, 0);
 
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
 	EXPECT_GE(ret, 2);
 	if (ret > 2)
 		SKIP(return, "kernel does not support filtering by zone");
@@ -437,7 +434,7 @@ TEST_F(conntrack_dump_flush, test_dump_by_zone)
 {
 	int ret;
 
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
 	EXPECT_EQ(ret, 2);
 }
 
@@ -447,13 +444,13 @@ TEST_F(conntrack_dump_flush, test_flush_by_zone)
 
 	ret = conntrack_flush_zone(self->sock, TEST_ZONE_ID);
 	EXPECT_EQ(ret, 0);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
 	EXPECT_EQ(ret, 0);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID + 1);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1);
 	EXPECT_EQ(ret, 2);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID + 2);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2);
 	EXPECT_EQ(ret, 2);
-	ret = conntracK_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
 	EXPECT_EQ(ret, 2);
 }
 
@@ -463,13 +460,13 @@ TEST_F(conntrack_dump_flush, test_flush_by_zone_default)
 
 	ret = conntrack_flush_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
 	EXPECT_EQ(ret, 0);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID);
 	EXPECT_EQ(ret, 2);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID + 1);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 1);
 	EXPECT_EQ(ret, 2);
-	ret = conntracK_count_zone(self->sock, TEST_ZONE_ID + 2);
+	ret = conntrack_count_zone(self->sock, TEST_ZONE_ID + 2);
 	EXPECT_EQ(ret, 2);
-	ret = conntracK_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
+	ret = conntrack_count_zone(self->sock, NF_CT_DEFAULT_ZONE_ID);
 	EXPECT_EQ(ret, 0);
 }
 
-- 
2.47.3

