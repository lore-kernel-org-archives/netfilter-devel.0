Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D121D31A8;
	Thu, 17 Oct 2024 11:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729163134; cv=none; b=c4A84NXi6c0WLlA+p+h1GFyeJPzfCN/RfE9Kj5spV/3s7GwQXtt6HlV1KNDQEKJsb0iYmVz5k6NulKx0dI2OhYwKVgflhNdlth8cgoJhLABh/Rlo8acNJXZMEuqAFRy2xpd+bh9igXFJAWt+UOT/jgD9sHjeTtDUdSWxh2HOq90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729163134; c=relaxed/simple;
	bh=GYAQ/AAExQ+JQsOxqy/LCiWPZr5UqpIYvsBQuLBlPZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+gvFYnYRN/j47olCmj5osz8AWX19xUpHDuM+WxDjFsplU6l7iQhBqeI2O9C1/uDMynFDXK1OxnbJ0bXJK4YrUPiZ4n38lGrApgaEv+cO5gNHplJsBE9BGd83xwh6jKC9cBWXMMy1HvgDodhoq3lO7mnPsNFwBzDavomZVA4vzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XTlP25FHHz1yn45;
	Thu, 17 Oct 2024 19:05:26 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F58D1402C6;
	Thu, 17 Oct 2024 19:05:20 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Oct 2024 19:05:18 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Date: Thu, 17 Oct 2024 19:04:47 +0800
Message-ID: <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Do not check TCP access right if socket protocol is not IPPROTO_TCP.
LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
should not restrict bind(2) and connect(2) for non-TCP protocols
(SCTP, MPTCP, SMC).

sk_is_tcp() is used for this to check address family of the socket
before doing INET-specific address length validation. This is required
for error consistency.

Closes: https://github.com/landlock-lsm/linux/issues/40
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---

Changes since v1:
* Validate socket family (=INET{,6}) before any other checks
  with sk_is_tcp().
---
 security/landlock/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index fdc1bb0a9c5d..1e80782ba239 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -66,8 +66,8 @@ static int current_check_access_socket(struct socket *const sock,
 	if (WARN_ON_ONCE(dom->num_layers < 1))
 		return -EACCES;
 
-	/* Checks if it's a (potential) TCP socket. */
-	if (sock->type != SOCK_STREAM)
+	/* Do not restrict non-TCP sockets. */
+	if (!sk_is_tcp(sock->sk))
 		return 0;
 
 	/* Checks for minimal header length to safely read sa_family. */
-- 
2.34.1

