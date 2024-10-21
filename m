Received: from cmccmta3.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC56C1E1A23;
	Mon, 21 Oct 2024 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729497903; cv=none; b=JfEUUDx907jwMNfS6QjFahPl2JBAyhp420LZ/yv+vCQZb/d4vWhrZidCVEz/7cdLcNaxDxum2qlXqYB9caUXgzznmj/1poTgcldexz8o5cjrKipWMWs+kKQKEnEYGUoB+fev2kUlOQDiBp2Scm3RmHHFYOHyrkvpTUaDvOHnph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729497903; c=relaxed/simple;
	bh=LGbII50R6hgO8HmPvsf0+iBOEdW4TEQSRo59AZhEgqI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cRy2bGnBo99Vg9tHPno7u0jCoEJqe//apmKNru3nEF0mV0TIp5c5jMU1B5t6FxcGfIAdBfnbSJPEyFJnSMmwvqUp4TcgyA/coZi0iwu3hQTJvubny8ZKC2LMO/fTcZmnUT81rjOWORrhjhKvIQGS8jT2zPnMV1c6PkRgHMk2wvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee967160b21ee4-59ef1;
	Mon, 21 Oct 2024 16:04:49 +0800 (CST)
X-RM-TRANSID:2ee967160b21ee4-59ef1
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain.localdomain (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee267160b20724-4b70c;
	Mon, 21 Oct 2024 16:04:49 +0800 (CST)
X-RM-TRANSID:2ee267160b20724-4b70c
From: Liu Jing <liujing@cmss.chinamobile.com>
To: pablo@netfilter.org
Cc: kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] selftests: netfilter: remove unused parameter
Date: Mon, 21 Oct 2024 16:04:47 +0800
Message-Id: <20241021080447.2918-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>

---
V1 -> V2:  Delete more unused parameters, such as err, v1 only deleted rplnlh parameter

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 .../testing/selftests/net/netfilter/conntrack_dump_flush.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index e03ddc60b5d4..63ae49f166a1 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -97,7 +97,7 @@ static int conntrack_data_insert(struct mnl_socket *sock, struct nlmsghdr *nlh,
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	unsigned int portid;
-	int err, ret;
+	int ret;
 
 	portid = mnl_socket_get_portid(sock);
 
@@ -215,7 +215,7 @@ static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
 	struct nfgenmsg *nfh;
 	struct nlattr *nest;
 	unsigned int portid;
-	int err, ret;
+	int ret;
 
 	portid = mnl_socket_get_portid(sock);
 
@@ -262,7 +262,7 @@ static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
 	struct nfgenmsg *nfh;
 	struct nlattr *nest;
 	unsigned int portid;
-	int err, ret;
+	int ret;
 
 	portid = mnl_socket_get_portid(sock);
 
-- 
2.27.0



