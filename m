Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAB11C6BE;
	Thu, 25 Jul 2024 19:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721935721; cv=none; b=J7WJY9iHdOY5IiuwKkmeL22xjDlDkYLJomqZXuDTO+mfqbW/rYrlagBRsWrziiQ8uKdS7jUQlBm62Ary/B9BrAct7w3VgXW+0yvr4HnfMqAIUHHXmx6OczLD1qHZLAfyL7et9RsFODiBcbmByru0kQ9C52fuTuxHuemP/p3Mpmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721935721; c=relaxed/simple;
	bh=NvTRuBPZE2MoleuxtaFh0VRTnFd90URWzd7dcrBraaw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aMu2WDLJDeXGtY98FiHK2lNhPt8+QBkNrtjE4Q3Nlm9nod4B8JKdX8Z4TwcbUsNW6FZn5fzLsjRHPfyscdQ9+HFbA+LRs3lcAQiUAtv4UrJl6wbw9bZI1z7PBGN+re4hxCWcbEQnMrcCs1Rul0MrV4PAvFl5CSR2aD45TxPTnRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=AglCossn; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="AglCossn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721935720; x=1753471720;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Wsrijzk0jnbDYEKEFu70o46BrsAgINklkYPtxD16mVI=;
  b=AglCossne0kfFbGiKRR8svOxMGJE99y9iMXAE7UHqdbrda+Lxbs6TTXF
   Hiqmmt1fGmTqlf25Y7msJDXpaNOLyUkqjsKegMcGJZuTRQp02QJ8yxP/G
   Nfxy6Hr3/mXc2p5Fc5+tVzRcxQL1T/+8eR5GcM0swk3FMJVgqOxHVlytF
   I=;
X-IronPort-AV: E=Sophos;i="6.09,236,1716249600"; 
   d="scan'208";a="109554893"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 19:28:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:31529]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.189:2525] with esmtp (Farcaster)
 id e15cce2b-1b7d-41c5-a0ff-dba5b8682f5a; Thu, 25 Jul 2024 19:28:38 +0000 (UTC)
X-Farcaster-Flow-ID: e15cce2b-1b7d-41c5-a0ff-dba5b8682f5a
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:28:34 +0000
Received: from 88665a182662.ant.amazon.com (10.88.167.203) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:28:32 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>
CC: Florian Westphal <fw@strlen.de>, Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>
Subject: [PATCH v1 nf 0/2] netfilter: iptables: Fix null-ptr-deref in ip6?table_nat_table_init().
Date: Thu, 25 Jul 2024 12:28:19 -0700
Message-ID: <20240725192822.4478-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

We had a report that iptables-restore sometimes triggered null-ptr-deref
at boot time.

The problem is that iptable_nat_table_init() is exposed to user space too
early and accesses net->gen->ptr[iptable_nat_net_ops.id] before allocated.

Patch 1 fixes the issue in iptable_nat, and patch 2 applies the same fix
to ip6table_nat.


Kuniyuki Iwashima (2):
  netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().
  netfilter: iptables: Fix potential null-ptr-deref in
    ip6table_nat_table_init().

 net/ipv4/netfilter/iptable_nat.c  | 18 ++++++++++--------
 net/ipv6/netfilter/ip6table_nat.c | 14 +++++++++-----
 2 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.30.2

