Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327FC3E9C05;
	Sun, 27 Sep 2026 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548487; cv=none; b=rxCj1M6Hipx0rU9dh/tzpqAId8wBqjS5vbT4XcgRQDy8BUggMGWBe/xlzLnv3TGKd71RgnCtL1Nuiwtr854m40bWSewoms/gyru9snJrMWpHnRZGEI8i3xzby1Y6ZUPHgX2U8CMGNJc7nBY5YGIuit3cjzLab85vDEf6/6fN8vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548487; c=relaxed/simple;
	bh=PfDCk0yR3Yzc3Tfx5grAo2h7374Y3I3pej4wNKskY6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WwoNb+Z3PGtoHxaF1Rndwo41zWj+60IKl2I4Yq4bBgEzEbECVX/kifZmxVTIAFcAl2zIMkqlF89SE924AfTriG0JtroKcSRGwP+SpDnLV7NZWCgB4iSoczaESvvOAqZy+iU4iAXYC5rBjsr7VmjnQDrdEg8bzOqF0y93V6F2rI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CJRJgpDI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CJRJgpDI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548484;
	bh=4mqtO9oGnh1dcvUV6IERFu2opOgN9CQOI0rAFeVKXvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJRJgpDI3/4wJ/KFmlHfJJ9oNiUKezYeOcocuCiPJFKJ1/dFRlh0Ju3HSipgjqYRB
	 USiVOf2q45/qEteQ+d+k9rmQPI6+M0CaKxgAgI/R0pBcSgALQwKwKRS59NLQET29at
	 zLvA1UWK4Gyg+SKyq0ck7ry5sNweA3OcyK3if64eNrUruF6r2wk2ulHCt0FkuhcJs9
	 +pZb70NokBj7OATT8oPxenke9hTS4YTWEPiKFMCYMQSk2uLAlJHFKQq2JddOLX1edX
	 sREgOGkH3VyvbSZzgvfGDaGwt6RIHsRGs0jbZIWRpyQZX7fucq0c0/WpHJzSq6GUNi
	 kCH/vduL0Nh/w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBFDA6008F;
	Mon, 28 Sep 2026 00:34:43 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 03/11] netfilter: osf: remove unreachable break in nf_osf_ttl()
Date: Mon, 28 Sep 2026 00:34:28 +0200
Message-ID: <20260927223436.269024-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linkui Xiao <xiaolinkui@kylinos.cn>

In nf_osf_ttl(), the break statement after return in NF_OSF_TTL_TRUE
case is unreachable dead‑code. The return statement exits the function
immediately, so break will never execute.

Remove the useless break, no functional change.

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index e4835b0f4bb1..c8cd6af95db4 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,7 +36,6 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	switch (ttl_check) {
 	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-		break;
 	case NF_OSF_TTL_NOCHECK:
 		return 1;
 	case NF_OSF_TTL_LESS:
-- 
2.47.3

