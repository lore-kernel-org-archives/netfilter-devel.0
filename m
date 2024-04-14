Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98221353FB;
	Sun, 14 Apr 2024 23:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713135886; cv=none; b=Qpo2pb1BdyfoFH6IOK5PBv4J5XNJ9a3Oqg/NpscII35rYtWd3SDvjLZ+y8zGQRoOZJfFG9lzvM8YGzaxebslibpqqHPJliHX4dXTuzPt84TV31Gz/f044/uFq/Az/7DJD91a98PLsA39gikSjMqHKI8zkAtvWVuv3p4MbLO8pJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713135886; c=relaxed/simple;
	bh=y97KmOGqK7/F1/6SQpCuZNIapMaS3H4yjOpG0Os5suw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI5jyj3zWX6palPrqftQ+lrSfYa81jOgv3yMsUSET98GhrP/6mStPbBZr6RxZ7cArO6rThXf1t7atD57FIwkabU+eOGuizlWYaHMlBIeHS182sba/lAwzQGu/lypQKKvisFQsBmrOzcDlwFTqit36E8ZxIomLnMoBi4WbTewxcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rw8tl-0002VV-DB; Mon, 15 Apr 2024 01:04:33 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 02/12] selftests: netfilter: conntrack_tcp_unreplied.sh: move to lib.sh infra
Date: Mon, 15 Apr 2024 00:57:14 +0200
Message-ID: <20240414225729.18451-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240414225729.18451-1-fw@strlen.de>
References: <20240414225729.18451-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace nc with socat. Too many different implementations of nc
are around with incompatible options ("nc: cannot use -p and -l").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/config | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index a34c284242ec..9df6a9f11384 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -2,8 +2,6 @@ CONFIG_AUDIT=y
 CONFIG_BRIDGE_EBT_BROUTE=m
 CONFIG_BRIDGE_EBT_REDIRECT=m
 CONFIG_BRIDGE_NETFILTER=m
-CONFIG_NF_CONNTRACK=m
-CONFIG_NF_CT_NETLINK=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP6_NF_MATCH_RPFILTER=m
 CONFIG_IP_SCTP=m
-- 
2.43.2

