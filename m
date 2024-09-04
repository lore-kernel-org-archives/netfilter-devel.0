Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A214F1CFEAB;
	Wed,  4 Sep 2024 10:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725446946; cv=none; b=V8VZhcDNPhNmQFkN3Z+ItTjj6syDMV2J9Pn5XGgjm1yq4LBq++qi58syySKMsF/Eo6o/Ju8PDsyHshsnUcc4pcyc6eUCRGlVSgFNNqtIvln4aMmyHxWj0AsTUffCXp5j8nEdr1dXK8tSZ+S76ai99b37YukRd0pffE9105+7UJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725446946; c=relaxed/simple;
	bh=9U/ib4/w/+BXpfPUe69d2A4jP4W7vuNzlLQWjhhSUkg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWuUeXS8ysmehbhFu5Uig/s0iJiyVE43o6NHXTozpqfS5x6ToBUG7NP0S2F0yb44GaWFnjLwber1+/djHvz0pYZmNVQLKeaGLq9KOOqqbkU+vwlH4ODycq6f291h0HMGwNHWkQskXRv8DY6N+3ehmOAiKmHggWUlkPZcyI/vZ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzK3Z47rJz1j84D;
	Wed,  4 Sep 2024 18:48:42 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id B4E841402CC;
	Wed,  4 Sep 2024 18:49:02 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 18:49:01 +0800
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v3 17/19] samples/landlock: Replace atoi() with strtoull() in populate_ruleset_net()
Date: Wed, 4 Sep 2024 18:48:22 +0800
Message-ID: <20240904104824.1844082-18-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 kwepemj200016.china.huawei.com (7.202.194.28)

Add str2num() helper and replace atoi() with it. atoi() does not provide
overflow checks, checks of invalid characters in a string and it is
recommended to use strtol-like functions (Cf. atoi() manpage).

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 samples/landlock/sandboxer.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index e8223c3e781a..d4dba9e4ce89 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -150,6 +150,26 @@ static int populate_ruleset_fs(const char *const env_var, const int ruleset_fd,
 	return ret;
 }
 
+static int str2num(const char *numstr, unsigned long long *num_dst)
+{
+	char *endptr = NULL;
+	int err = 1;
+	unsigned long long num;
+
+	errno = 0;
+	num = strtoull(numstr, &endptr, 0);
+	if (errno != 0)
+		goto out;
+
+	if (*endptr != '\0')
+		goto out;
+
+	*num_dst = num;
+	err = 0;
+out:
+	return err;
+}
+
 static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 				const __u64 allowed_access)
 {
@@ -168,7 +188,12 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 
 	env_port_name_next = env_port_name;
 	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
-		net_port.port = atoi(strport);
+		if (str2num(strport, &net_port.port)) {
+			fprintf(stderr,
+				"Failed to convert \"%s\" into a number\n",
+				strport);
+			goto out_free_name;
+		}
 		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
 				      &net_port, 0)) {
 			fprintf(stderr,
-- 
2.34.1

