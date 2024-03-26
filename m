Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D36487B5;
	Tue, 26 Mar 2024 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711447047; cv=none; b=tza1WwwpRGgOIMHYEmKEn9XWs8RVtzs5gGEW9InY9G0Tux6BOl6Y2vudov0eAggcTOGuRJE33pl0MmO8UR2tgBjsX3KYj3r6reHdIsctjyO2R9uRZG3iUpWubPsl3+VFBlAeP8/ERWdQ77CcBwzI/Rb4a6rPKx7wnnUV4xBoKrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711447047; c=relaxed/simple;
	bh=+oKix8TDa/erex+yEij8/8FaBF30hD83a+heP0Kqg4g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t5Tt5kmEbHF3fDxE7kpDweYHtLQWIRS0/5zvjMfNn0yD+Rxt4HEInACzx8OY7WVPt5zTaKCb5qx9E37u97iloLqRxdtK/1tcLcD2dv7tbi4R465uz2SaZqIKjKXOwz14Xf3X24KDq9W3VVshwwXBweq+j5+KAL3wfyr/P+puaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4V3lX20SPQzwQ27;
	Tue, 26 Mar 2024 17:54:42 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 36603140157;
	Tue, 26 Mar 2024 17:57:21 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 17:57:19 +0800
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [PATCH] samples/landlock: Fix incorrect free in populate_ruleset_net
Date: Tue, 26 Mar 2024 17:56:25 +0800
Message-ID: <20240326095625.3576164-1-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Pointer env_port_name changes after strsep(). Memory allocated via
strdup() will not be freed if landlock_add_rule() returns non-zero value.

Fixes: 5e990dcef12e ("samples/landlock: Support TCP restrictions")
Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 samples/landlock/sandboxer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 32e930c853bb..8b8ecd65c28c 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -153,7 +153,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 				const __u64 allowed_access)
 {
 	int ret = 1;
-	char *env_port_name, *strport;
+	char *env_port_name, *env_port_name_next, *strport;
 	struct landlock_net_port_attr net_port = {
 		.allowed_access = allowed_access,
 		.port = 0,
@@ -165,7 +165,8 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	env_port_name = strdup(env_port_name);
 	unsetenv(env_var);
 
-	while ((strport = strsep(&env_port_name, ENV_DELIMITER))) {
+	env_port_name_next = env_port_name;
+	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
 		net_port.port = atoi(strport);
 		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
 				      &net_port, 0)) {
-- 
2.34.1

