Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4890D15574C;
	Thu, 27 Jun 2024 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487651; cv=none; b=UAlJPI3k/GKwVgO9Qh3GuO8XQxvMkSqylh6r0Tf9GxatkhL82S4mkkPKZx15UJCeKGBzKxNgKlpwFJ1JOjDPLprLV1V5OTk15t/ZqaxBfKokcLbXIEU0Kio5pZSkbrO+n4GAuTDSYKk2j80Sbe05fX7jMlzrhRrAjNMeLtRQ0DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487651; c=relaxed/simple;
	bh=KD8knpXBOYQbSVlqs+ARIVBd61NDg66wZcUOPYafw8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fa9y0iEYnn0cMXRyB6QOsfe4tY/S3wDPn8DE0Tj0QRliQGyWnprjuCo23UprhfvfT57JNvx6FGbH/xXlmG+ugxISXHztaWY0uWNXol2ipmqxCTwz6OteSbCa9KhoqMaLKoJDmGvHcR/hm31FlY/AnGMCfoIZzMtpYXf9JWUZ9k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH nf-next 14/19] netfilter: cttimeout: remove 'l3num' attr check
Date: Thu, 27 Jun 2024 13:27:08 +0200
Message-Id: <20240627112713.4846-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240627112713.4846-1-pablo@netfilter.org>
References: <20240627112713.4846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

After commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping
information"), the attribute of type `CTA_TIMEOUT_L3PROTO` is not used
any more in function cttimeout_default_set.

However, the previous commit ea9cf2a55a7b ("netfilter: cttimeout: remove
set but not used variable 'l3num'") forgot to remove the attribute
present check when removing the related variable.

This commit removes that check to ensure consistency.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f466af4f8531..eab4f476b47f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -366,8 +366,7 @@ static int cttimeout_default_set(struct sk_buff *skb,
 	__u8 l4num;
 	int ret;
 
-	if (!cda[CTA_TIMEOUT_L3PROTO] ||
-	    !cda[CTA_TIMEOUT_L4PROTO] ||
+	if (!cda[CTA_TIMEOUT_L4PROTO] ||
 	    !cda[CTA_TIMEOUT_DATA])
 		return -EINVAL;
 
-- 
2.30.2

