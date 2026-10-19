Received: from out28-147.mail.aliyun.com (out28-147.mail.aliyun.com [115.124.28.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDB549481C;
	Mon, 19 Oct 2026 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792396610; cv=none; b=tokp43FgzQldXmdm3Vo46+BWv6gW46EIVNHRjWsY4p3f7CF2LU7NBm/XYcdjPjvf3si6Il3NZUJOYLdCncIh5jk0PMLnHH6iBbpb4u1LdAWJzGFgjbiRA+ut59ZzRoAOcpMf7+4SIZCTGkR1ub1FZkxJT/nO30dRg4Yq1V4u2hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792396610; c=relaxed/simple;
	bh=D6GoqLrBJ52YEbUH7ns2rPeL3+MpjBYUnOmiWl+jSZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P+2gBvNG35cUrVXwSyRFQf13x7ma9j5+dW8mw3voz41ci/zieWYe45YjsKr7tUR22THuFlSF82wfc0uM4lQ4uPqUo/46UKZv1eqrmdsrFglrzKnwS/LuvSel4aXeV8Kr5g0G7dKnF1i3WRmCvS7s43bWkyyDRHn1FckYt+FxKQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=H/rqvpJW; arc=none smtp.client-ip=115.124.28.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="H/rqvpJW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1792396591; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Z5DVAeUGxz/cUycSAr/s96NUWD1NlJPK/sUiDuV7kQo=;
	b=H/rqvpJWuJF8N9hHuJTlaTZ3PsuQDOxyaftDuwff1r0FxEF6IgE0fO071KMzwb0Pz4vPmP+I2yLNs07hbE8dY/7MR5PqvlVUNNcF1yJsjgwLE/kJ0WrXuh5lxm25a6qhXUCiikHXkwTZ051iJOxkoFWMYz8LAdoGa0uTei+N7lY=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07716876|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00401948-0.000306144-0.995674;FP=8718219688756733345|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037025160;MF=liuc63@xiaopeng.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.jkSo8yf_1792396589;
Received: from localhost(mailfrom:liuc63@xiaopeng.com fp:SMTPD_---.jkSo8yf_1792396589 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 19 Oct 2026 15:56:31 +0800
From: liuc63 <liuc63@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Florent Fourcot <florent.fourcot@wifirst.fr>,
	Romain Bellan <romain.bellan@wifirst.fr>,
	Weibin Liu <liuwb@xiaopeng.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Liu Chao <liuc63@xiaopeng.com>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter
Date: Mon, 19 Oct 2026 15:56:26 +0800
Message-ID: <20261019075629.2091511-1-liuc63@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Liu Chao <liuc63@xiaopeng.com>

ctnetlink_filter_match_tuple() returns 0 (no match) when the IPv6
source or destination address differs from the filter, because the
!ipv6_addr_cmp() test is inverted.  ipv6_addr_cmp() returns 0 when
the addresses are equal, so the negation makes the branch trigger on
a match instead of a mismatch, which is the opposite of the IPv4
path above.

Drop the '!' so the IPv6 branch returns 0 only when the addresses
differ, matching the IPv4 semantics and the caller's expectation.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e5d7c701436..cc8695d5356d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1098,13 +1098,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    ipv6_addr_cmp(&filter_tuple->src.u3.in6,
+				  &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
+				  &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.50.1

