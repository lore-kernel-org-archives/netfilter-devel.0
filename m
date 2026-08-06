Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0E63DD862;
	Thu,  6 Aug 2026 07:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002742; cv=none; b=hsdJ433Cda/Fks8TUrsuf9X4Au9jifx2s90uVSJ8j8ph+7vPz2Qpd5NHuamRQFpBXcD1MEGKYGnxT+rWNLmXQqS/MMKuzYv4ttqmNbtSvxpgqMbPW4JYlZJpuPSoLXlgD1Yn1Bbr/qEzW7hysSJ2BYmKlahw9ctsGRFh/XqkRWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002742; c=relaxed/simple;
	bh=cyJjygUTcWoAmU+IN9viNm1qaL3IAsUPuxkfMeZHQ5I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EgGUciDxhkv78OFnK2qPK5Pr7ThBUwpy+w7Lbn4eYj6NLTHWh8nEZ3iro6qMzJ5SMkaN/fjnVGJlFvCW966m+qbvAZ5g1iSQl07Mw1AP7pHbNJYhtCTTjTfmRe7HWcLAsy4sLg4hQkJy+ajfikP88CHnDVE+DZAj/KyU1ZPkaM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=d4XI3hJJ; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="d4XI3hJJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ed
	6WxXmO/sQLzhZwOEPID5bXGk+YxYWCDlW+DllF+Ek=; b=d4XI3hJJmfIk1BpSvM
	xLEGiezfYXIPz+czvfQbGVMikoJeRJK/ARkqguEYJU702qTZRJY6YxmAZWIsDac4
	/sTrb5VelO11TaP9eZOaT9VBcTayx+aLT02VT1Tgr4HmTHCug3w55XxaZXBuwef8
	Q+NFA/zQ5xOlvTBQXXwrdRCc8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wB3wVTePHRqYcLgMA--.151S2;
	Thu, 06 Aug 2026 15:50:58 +0800 (CST)
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
	Qingshuang Fu <fffsqian@163.com>
Subject: [PATCH] selftests: netfilter: Remove unused variables in conntrack_dump_flush
Date: Thu,  6 Aug 2026 15:50:52 +0800
Message-Id: <20260806075052.1934904-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3wVTePHRqYcLgMA--.151S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw47Zr43WFy7Gr4DZr1fWFg_yoW8uF4Dp3
	WrKw15Jr4xtFW3uw4kCa15AFySqrZIkw1xuF1UC3s3Xwsxtr97WFWfKFyUC3W5ArWvgr4f
	CFyj9r4jvanxAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piuT5PUUUUU=
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbCwgL+yWp0POJDIAAA3U

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

The variables 'rplnlh' in conntrack_data_insert() and 'rplnlh' together
with 'nest' in conntracK_count_zone() and conntrack_flush_zone() were
declared but never used since they were introduced.

Similarly, commit 76342e842587 ("selftests: netfilter: remove unused
parameter") removed the unused 'err' variable from these functions but
overlooked the remaining unused 'rplnlh' and 'nest' variables.  Remove
them to clean up the code.

Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
---
 .../testing/selftests/net/netfilter/conntrack_dump_flush.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index 5cecb8a1bc94..c8e4794ec5cb 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -102,7 +102,6 @@ static int conntrack_data_insert(struct mnl_socket *sock, struct nlmsghdr *nlh,
 				 uint16_t zone)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *rplnlh;
 	unsigned int portid;
 	int ret;
 
@@ -219,9 +218,8 @@ static int count_entries(const struct nlmsghdr *nlh, void *data)
 static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
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
 

base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.25.1

