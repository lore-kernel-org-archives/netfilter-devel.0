Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E41A1547DA;
	Thu,  3 Oct 2024 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966428; cv=none; b=dVkt1E3tDHtDFWIbXhIanm2BV5ZW7YYCbO2cIi6usG4oSYqabLwFobSjGYnCcjDl5ZJfnbg1hTPZgxCxYTFjE+YUwQQ0AHrZSD9WuzNRpM9DNyhFcyhexpPeTzGhWg4FMSEXtcBdN2681AosZFxHNiuxadyW0X6f/Gi61WmMJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966428; c=relaxed/simple;
	bh=S+R3ACkSrRJtw0+j//fKOjmNPYfK1qqX/6EvwezgaPg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvLCKgHVIICqiNyzRtnixKlxpOKk0YmY4kR75TCSQVSDkPNghh9ix+0auR2++6Z18HbOL+v52YyEElnEJksbeo8x2zkpgwTtWoCTPTfKIZurTtcfV+Zz+UwUSmr1Cipoq0/dIqhudy/6hISqsM9dOd2NIfUSOuUEp6Vck8UzwL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XKDpn1JtczFqt1;
	Thu,  3 Oct 2024 22:39:45 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 92D0718005F;
	Thu,  3 Oct 2024 22:40:15 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Oct 2024 22:40:13 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v1 1/2] landlock: Fix non-TCP sockets restriction
Date: Thu, 3 Oct 2024 22:39:31 +0800
Message-ID: <20241003143932.2431249-2-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
References: <20241003143932.2431249-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100004.china.huawei.com (7.188.51.133) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Do not check TCP access right if socket protocol is not IPPROTO_TCP.
LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
should not restrict bind(2) and connect(2) for non-TCP protocols
(SCTP, MPTCP, SMC).

Closes: https://github.com/landlock-lsm/linux/issues/40
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 security/landlock/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index bc3d943a7118..6f59dd98bb13 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -68,7 +68,7 @@ static int current_check_access_socket(struct socket *const sock,
 		return -EACCES;
 
 	/* Checks if it's a (potential) TCP socket. */
-	if (sock->type != SOCK_STREAM)
+	if (sock->type != SOCK_STREAM || sock->sk->sk_protocol != IPPROTO_TCP)
 		return 0;
 
 	/* Checks for minimal header length to safely read sa_family. */
-- 
2.34.1

