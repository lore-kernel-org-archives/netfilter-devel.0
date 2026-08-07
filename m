Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC103F660D;
	Fri,  7 Aug 2026 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786089666; cv=none; b=OQSrWzsFhLA2IfBt6UE+Ttbk/NEgpEjZp3Jm642/ZTHEOyP4Bv7BcUfdSrQTvdI7rbZSNP8EdBgjFxtXJ4ZoTpxfv9K499FdZ75DncWbLX18qRsm93JXcZ/7khkewRtj55Y2TeFKnI/8pGlxGe/CYBRe84buTtNh99jKo/oVgTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786089666; c=relaxed/simple;
	bh=vA+iyiMuAKU4WdXWINwunM/+iSBzTZ/BPT8+SmqDbp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eL/Dl9UPs+pL4y+dDesHia9yVkzR4aPatoXO6knTTioCx5jt/XeSmXxDgBwQhbCoFjJmTJxrv4aaDT12YlucFry9AaFAjd8OTdR9UXLmr75Amn60/uafY625IyD7qi0RQs/IYDHlPMVQkEAJJ5a7U6ZpAShr0u1VH01Tymh/ABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LEkKyh2w; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LEkKyh2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Lr
	5ELda4t3IwetdpAFGn/lX6FGeF2LyHiG4brun4dGU=; b=LEkKyh2whOQ8s+XJiI
	of7giGAeNu9DKUKUB4DNbJ90l1vx2ytrCgdU/GMYacPrA6fwTZH4RzKhDRhjR7jh
	FclDj+LzX6TWcL1M4Ku1/KFlS8i2q/MWgeuICO2ZniD5K7ROmdJFCGIw8JEEDiU1
	K0DioJjHYfi22Z0Gw8bWSLoOg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCn7EdlkHVq3qccNw--.18515S2;
	Fri, 07 Aug 2026 15:59:34 +0800 (CST)
From: Qingshuang Fu <fffsqian@163.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	davem@davemloft.net,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Qingshuang Fu <fffsqian@163.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH net v2] selftests: netfilter: conntrack_dump_flush: remove unused variables and fix typo
Date: Fri,  7 Aug 2026 15:59:28 +0800
Message-Id: <20260807075928.64326-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn7EdlkHVq3qccNw--.18515S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArykCF47XrWDZw17Zw1fWFg_yoW7Jr1Dpw
	18Gwn5Gw18Jr4S93WkCan8AF9xtr9xA34Sqr4xGa4rZanxtr1Yy398ta4fGryYyrWjqr9r
	uFWjgF90ya1ay3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRxhLbUUUUU=
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbCwgg2AWp1kGjaSgAA3K

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

Remove unused 'rplnlh' in conntrack_data_insert(), and remove unused
'rplnlh' and 'nest' variables in conntrack_count_zone() and
conntrack_flush_zone(). These variables were declared but never used
since their introduction.

Also fix typo: rename misspelled conntracK_count_zone() to
conntrack_count_zone().

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
---
v2:
  - Drop Fixes tag as this is a cleanup, not a bug fix
  - Add Reviewed-by tag from Fernando Fernandez Mancera
  - Also fix the typo in function name conntracK_count_zone
  - Link to v1: https://lore.kernel.org/all/20260806075052.1934904-1-fffsqian@163.com/
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
 

base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.25.1

