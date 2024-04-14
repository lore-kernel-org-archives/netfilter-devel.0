Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962381353FB;
	Sun, 14 Apr 2024 23:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713135884; cv=none; b=WldesqwJcRDOpSmsfNT+AU2XNZt9YLH2Hvo4BDZal2d/X4iri/rowNwC/9YfgNdF4WuIhIWTZ/4GRg2KixNHiTjWu1F3/hJD9pOF9rBp83uXJHTVYs/30lws/3eqoyttn1znpwx02BOmYGTSGLHr5nz+Q5vJg74d4tq3zv8n4X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713135884; c=relaxed/simple;
	bh=hY/K7apEHIXleeXMJjk5vn6BueqzeOMCUYSQ4VUDRlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbGS8SRqcWltghIjSauRhRmktXUkTtzF0bmCbBSBdJtS72XEyon8NDQVeYX7hALXDwSpXZfNtQDYzm9U5R0WYcOwpDUDB0iMHE6cNXhn+kbh3ShsIDttdIxojzNY/rG2PD5A7et+xR6xfQJhXNp8MnZh3ExKFmPHGuhGkPME/Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rw8tk-0002VK-AJ; Mon, 15 Apr 2024 01:04:32 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/12] selftests: netfilter: conntrack_icmp_related.sh: move to lib.sh infra
Date: Mon, 15 Apr 2024 00:57:13 +0200
Message-ID: <20240414225729.18451-2-fw@strlen.de>
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

Only relevant change is that netns names have random suffix names,
i.e. its safe to run this in parallel with other tests.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 9df6a9f11384..a34c284242ec 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -2,6 +2,8 @@ CONFIG_AUDIT=y
 CONFIG_BRIDGE_EBT_BROUTE=m
 CONFIG_BRIDGE_EBT_REDIRECT=m
 CONFIG_BRIDGE_NETFILTER=m
+CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CT_NETLINK=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP6_NF_MATCH_RPFILTER=m
 CONFIG_IP_SCTP=m
-- 
2.43.2

