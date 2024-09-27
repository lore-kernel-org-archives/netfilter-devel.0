Received: from cmccmta1.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35446249EB;
	Fri, 27 Sep 2024 03:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727407340; cv=none; b=M4IzOTl+LZN07ikQK0xXlMI2t5aQdqpCJrKMhfM0YLV2xQooRN1/meqqKXhTTuv4NdZ7ioDkXJu4ZckExxiUdg7Z6lbH6Ip2GMKvMkuwzpjgoC3qsXDkpyNMVCT15Obwm5qkZrfuh3amh2WewZU6DoIHzGxJ7MEFhwrtfkbtrEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727407340; c=relaxed/simple;
	bh=aB4yHdbOuYemnIPnOJqQfcflOx9o9pRsM3zS6MRokpw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CocYA8O/h5RjbC2PizxEDfiwpC5zcjnw3OT1qmTp/ySnPWwxlR10HbD0hbaV9Dc1iryltskui1Qf3wsbuye2H2M3ddMBD/kz544ZMGSDD0ueyswa4O/oXL1Mtch8vxqlpYOaEVwQ0RXKbdGzWWkgr5lFUUxrm4a2NmHdBVWwBs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee266f624ddebd-d2eca;
	Fri, 27 Sep 2024 11:22:07 +0800 (CST)
X-RM-TRANSID:2ee266f624ddebd-d2eca
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.101])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee166f624dec2b-2cee4;
	Fri, 27 Sep 2024 11:22:07 +0800 (CST)
X-RM-TRANSID:2ee166f624dec2b-2cee4
From: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
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
	zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: [PATCH] selftests: netfilter: Add missing resturn value.
Date: Fri, 27 Sep 2024 11:22:05 +0800
Message-Id: <20240927032205.7264-1-zhangjiao2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

There is no return value in count_entries, just add it.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
---
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index bd9317bf5ada..dc056fec993b 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -207,6 +207,7 @@ static int conntrack_data_generate_v6(struct mnl_socket *sock,
 static int count_entries(const struct nlmsghdr *nlh, void *data)
 {
 	reply_counter++;
+	return MNL_CB_OK;
 }
 
 static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
-- 
2.33.0



