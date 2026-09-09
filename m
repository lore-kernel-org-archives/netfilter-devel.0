Received: from mail-e842.seohost-mail.eu (mail-e842.seohost-mail.eu [213.239.133.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7331C27FB1C;
	Wed,  9 Sep 2026 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.239.133.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788965402; cv=none; b=F57dfwcDTm6uKlWXWumFIOgYSD10OPCJHUj6qWIDF9d+r4Jv8rMA4lrRleM0XAwwjtGaoFiJCvwo1PdW6N5FR67ySTerSTTlRYZahUWpDLWG1rUEgWHSeMfp7nzj5uqnyCcfgzYKprvRub9ArJw+NJ3xMZocIBxU813fYuvBJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788965402; c=relaxed/simple;
	bh=XGKpAg0B6i8uXNqCCjlOfsBCteU3bFFpYlXU53Vx9o0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O8qQe74D02p+BLnhFcZCAZnN6uJa09dX/bjWM2CkbVoyD3ROGl1WIeXGGFWzAk4m3u87QKz6h1yyCMf4WKV/wPq3Wv7qfnw/yKmzzGtVX7uES+FOYHhZDUDfa0r15LnYxLBWVySmw0XtWNUYensR4VtKcqN7wMOXUkNWnfmFx+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kubik.pl; spf=pass smtp.mailfrom=kubik.pl; arc=none smtp.client-ip=213.239.133.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kubik.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kubik.pl
Received: from static-46-238-236-132.awacom.net ([46.238.236.132] helo=localhost)
	by h84.seohost.pl with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <piotr@kubik.pl>)
	id 1x4Jca-0000000C04w-28zI;
	Wed, 09 Sep 2026 16:49:56 +0200
From: Piotr Kubik <piotr@kubik.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Wed,  9 Sep 2026 16:49:29 +0200
Message-ID: <20260909144929.2688367-1-piotr@kubik.pl>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: piotr@kubik.pl

ctnetlink_filter_match_tuple() rejects an entry when
!ipv6_addr_cmp(filter, entry) is true. ipv6_addr_cmp() is a memcmp() and
returns 0 for equal addresses, so the condition is true exactly when the
addresses match: a CTA_FILTER dump with an IPv6 CTA_IP_SRC or CTA_IP_DST
skips every entry that matches the requested address and returns all the
others. The IPv4 branch compares with != and behaves correctly.

Observed with libnetfilter_conntrack NFCT_FILTER_DUMP_TUPLE: a dump
filtered on src 2001:db8::10 returned only the unrelated entries, and a
dump filtered on ::1 returned every entry except the ::1 ones.
conntrack-tools does not use the tuple filter for -L, which is why this
went unnoticed.

Use ipv6_addr_equal() so the IPv6 branch mirrors the IPv4 one.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 579ada063b1b..ef483699659b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1098,13 +1098,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->src.u3.in6,
+				     &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->dst.u3.in6,
+				     &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.55.0

