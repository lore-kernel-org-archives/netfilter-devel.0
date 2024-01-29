Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14C24CB28
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556272; cv=none; b=fTXPis116t3QyWTmc2F41lKMpmMsyXcG1dMp5GXfIVrmqAyIU5D7UmGbLy7JZKRPLypSVpGsBKOFL0/Gk0zqZ3xoA5479drDpE0PPeGi58mgKYyn7+3lV9nZLNZZrOBdI6A1AYAen6pJLavFot3/KnqSiQW9kVV8G8/q2FauOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556272; c=relaxed/simple;
	bh=3VDfQCzZRB4xkw7ybUFObORS4d68yxA3vSkZ4Sbqws4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=incNvN+RYoZqRLJ1OmmQhbCFejHuDOT1bAE0x9rKBdNjMX/xrrVlOIhv95y3wfluntqcs+GpwkCvKuQSa6FlFwz7Z/bXCuZMXhYWsbJgLP2sXsv8P0Pm4xVjqR8sbYKyK2Z3/tY5VKU9iGAimNBnC6HPvh1P8GDb2uvJvPLUCj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: nf_log: consolidate check for NULL logger in lookup function
Date: Mon, 29 Jan 2024 20:24:24 +0100
Message-Id: <20240129192425.148310-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate pointer fetch to logger and check for NULL in
__find_logger().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index e16f158388bb..e0bfeb75766f 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -31,10 +31,10 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 	int i;
 
 	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
-		if (loggers[pf][i] == NULL)
+		log = nft_log_dereference(loggers[pf][i]);
+		if (!log)
 			continue;
 
-		log = nft_log_dereference(loggers[pf][i]);
 		if (!strncasecmp(str_logger, log->name, strlen(log->name)))
 			return log;
 	}
-- 
2.30.2

