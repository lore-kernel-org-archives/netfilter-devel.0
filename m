Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0F219A868
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132897; cv=none; b=jto8xN6VFoka+M4C9cX03+IpGKCmXJbXrV3GAzFjcYGFt3YjzRjzyu5Z8BiHKaM1BItAOyUeprcRNRmqn49nUvkpW+OWRUNZh8pJlBmM+dMVvnwUjgOka9Qop3WUx/w6MsRuI53JZjis0XmxrsokXxX44Zok8l6Lt0SyvYVZyiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132897; c=relaxed/simple;
	bh=bo6wr9YP4QPIZLTgbKkXlZ0OLVHtyHWFCztyvgDGDgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9ZtM0qcrxlBttlu2Qzth0ZsIVZ/wsWgq2vB/+70wwzPYpnuCWl8r9RQMg35pURXGRYVUiHOzJm6UQlRHfdaTXf0OVtFWUKKFTCtkuwAVRL/lDLf17tBWUmgyaVqtX5chLWOukf1Vm/30X2c1qTnpFAks4pHdrdy8uGnOPgL9tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PN1DAlWQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PN1DAlWQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9eyUAiMqk4xoVRapzFGKh2QXm3/etW3wnSc7MCFlEdQ=; b=PN1DAlWQwTx0r7wXNNXf6QDnn3
	0EtpcYJEEDTQ2Iydsw8858ke/X4p1N9HW5s1/o1+CfnnA2DIJzyEw74EAKhTEJD4LsOO6rfi8ZUOE
	Qly5d7mUENPwS7fCTTvJgsZdk2rUv63aML220Lf48CU+m+wpkTzgEhFlcfjU+jbBdxF5omrxyFy90
	EPvc5LduZq6c2lpaKpgco/2u6RfJYHXKdm+8cbSHcNWzEK2mTg5w2SsI1nvOKmtm/hdgcUVBnYqwc
	aZSIJGw8trPQKT/O0CnTljtgwmI1Cg97logNl20riDkiHwfI8BUQQfmIc2EtPn/X1t5q1qdS6dkGQ
	/KYpQ6Yw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHy-000000007tp-3iUm;
	Tue, 16 Jul 2024 14:28:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 4/8] xtables-monitor: Support arptables chain events
Date: Tue, 16 Jul 2024 14:28:01 +0200
Message-ID: <20240716122805.22331-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print arptables NEWCHAIN/DELCHAIN events just like for iptables, using
the '-0' prefix rule callback already uses.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index e136e9b722e92..714a2dfd7074a 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -151,6 +151,9 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	case NFPROTO_IPV6:
 		family = 6;
 		break;
+	case NFPROTO_ARP:
+		family = 0;
+		break;
 	default:
 		nftnl_chain_snprintf(buf, sizeof(buf), c, NFTNL_OUTPUT_DEFAULT, 0);
 		printf("nft: %s chain: %s\n",
-- 
2.43.0

