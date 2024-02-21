Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A495D4120B;
	Wed, 21 Feb 2024 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515000; cv=none; b=P1iJ5rVk5DmgzAmuppXhE20FxKrBYceG6npPFn0ETuq5lFpeTGCzCZRDqqWzZ/Sa+eXehklWEOt8FWB5Aztg1ryW7KUAJutnCZnAczEjyU6WQ/VEytD0bktYT2QHXwfdfHS5aV8pOVngUt5s0TbMjdDe7NFkBEmS4BGGPcvq/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515000; c=relaxed/simple;
	bh=xerHGnIMtR/q4LquwWbcJISmaHjquvhFpnEVsOK1DjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unrVKFYBaYemF6LJ4Fwbh6iEAeWh9XVFpk98Qi2aWrntzZ5Mh/EpKTjJG3gAhlff/vNHFQmyj1SRVMU9kCdiVVOP3Zjrfvykoy1sKmJTUmjvBozT40fuuQZkv9JyTYkIQ/A/6JIAzrIsVn0leLdESTa2wnQDYBfT2oIKj4ePdpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcknF-0003sC-SW; Wed, 21 Feb 2024 12:29:41 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 02/12] netfilter: nf_log: consolidate check for NULL logger in lookup function
Date: Wed, 21 Feb 2024 12:26:04 +0100
Message-ID: <20240221112637.5396-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Consolidate pointer fetch to logger and check for NULL in
__find_logger().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.43.0

