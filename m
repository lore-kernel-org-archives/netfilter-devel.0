Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAD21A452;
	Wed,  5 Feb 2025 09:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738748232; cv=none; b=EJqhu0bVPL2BC0DjfKCbzUixpDT+gzcGWj7YvvzLXa3isvqI1M3L9ke3w0ocTADfIfjpcRHcH9ISKNlW2ieQJ1D8ztp4T8+YXmpKCiGMBB3YyZN4GyHlQrtikW8ae+1gF1F1GHJT7AhaVhQi9t0FM1WJfzOs2cdhDYE5V8c4Ugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738748232; c=relaxed/simple;
	bh=o8N3nlFHQ51Ewq6RWAFYCFswhaWCt9+7rp61KnQqDXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X53ZM06Dhuo7UcpnBl77TtSYEFFfxbtiLXYPLb0HZ+iEHdmLNIARZ1EUntzJExPDYsEFqc5/XONra+ORoENynbWYUfDwiIAzqUQLVBOBeWW10m1084xP7JiLXcq5IfVnqzOLuFgOfvu+4IzO/lKybwuSugvZMY7ofmE1j5lQiOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Ynw8k5QQMz6K9B6;
	Wed,  5 Feb 2025 17:36:06 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id C1125140442;
	Wed,  5 Feb 2025 17:37:01 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 5 Feb 2025 12:37:01 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 1/3] landlock: Fix non-TCP sockets restriction
Date: Wed, 5 Feb 2025 17:36:49 +0800
Message-ID: <20250205093651.1424339-2-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
References: <20250205093651.1424339-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Use sk_is_tcp() to check if socket is TCP in bind(2) and connect(2) hooks.

SMC, MPTCP, SCTP protocols are currently restricted by TCP access rights.
The purpose of TCP access rights is to provide control over ports that
can be used by userland to establish a TCP connection. Therefore, it is
incorrect to deny bind(2) and connect(2) requests for a socket of another
protocol.

However, SMC, MPTCP and RDS implementations use TCP internal sockets to
establish communication or even to exchange packets over a TCP connection
[1]. Landlock rules that configure bind(2) and connect(2) usage for TCP
sockets should not cover requests for sockets of such protocols. These
protocols have different set of security issues and security properties,
therefore, it is necessary to provide the userland with the ability to
distinguish between them (eg. [2]).

Control over TCP connection used by other protocols can be achieved with
upcoming support of socket creation control [3].

[1] https://lore.kernel.org/all/62336067-18c2-3493-d0ec-6dd6a6d3a1b5@huawei-partners.com/
[2] https://lore.kernel.org/all/20241204.fahVio7eicim@digikod.net/
[3] https://lore.kernel.org/all/20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com/

Closes: https://github.com/landlock-lsm/linux/issues/40
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
Changes since v2:
* Improves commit message.

Changes since v1:
* Validates socket family (=INET{,6}) before any other checks
  with sk_is_tcp().
---
 security/landlock/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index d5dcc4407a19..104b6c01fe50 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -63,8 +63,7 @@ static int current_check_access_socket(struct socket *const sock,
 	if (WARN_ON_ONCE(dom->num_layers < 1))
 		return -EACCES;
 
-	/* Checks if it's a (potential) TCP socket. */
-	if (sock->type != SOCK_STREAM)
+	if (!sk_is_tcp(sock->sk))
 		return 0;
 
 	/* Checks for minimal header length to safely read sa_family. */
-- 
2.34.1

