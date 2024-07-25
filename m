Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BCC2B9BC;
	Thu, 25 Jul 2024 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721935769; cv=none; b=SfVP9GTiO21g6eHH1nTMLiJvZ3tzef+UDK1oh5iidOdbq0uaEdOvfL6oZpT8U5HZI713or35FnWNbyrvX2Z+iOo9krat5u2nskcJ14lBJXQpL7u/mHdF70QEdYQS++5eFEatwcnNdwqdb9BzY2qGpypeJrg6ydPzBh7kWbAqBRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721935769; c=relaxed/simple;
	bh=l60CdqWsTH7bN/sWdfttIwkmtyFbUVureRpQqjQ3Clk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOT+LOoW8jsItZ2B99Q5YEoWpwbThvKMIQiRzxDXHeeX6c1cc10cqLI5Ni1ix1TDPG+KNiSrpvtJ8YSCQXT1Bc5rlBh9NCJVomQkB4xQSvyaUg8ouie/bNHBeo8pEI9Bzg4Y78GRZp0UDCvtll7YwHFDG6Nw+CciiYMJBhb6v04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=JEafkARv; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="JEafkARv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721935767; x=1753471767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d33HhOG5NKWjKAdfBkwmZosAnO77BQeIN7MJ7W1KQlI=;
  b=JEafkARvYXV2Hr4nwdAN8/rCHUtTcoRZVN8pN8iL/puMo/+qtzKFpmmS
   Q4CkjTLNRjf9nW6MQrZ9Y0p83cUN8x23+ibmjPquY4mz85yOmHpVNGBqe
   FcFaUQ4j7zDTtK/pDzUatZKeqHKD3N6jjNP2qYIwH+Jr1aAYEnS6S+qvS
   w=;
X-IronPort-AV: E=Sophos;i="6.09,236,1716249600"; 
   d="scan'208";a="109762214"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 19:29:26 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:45626]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.254:2525] with esmtp (Farcaster)
 id 809b5de6-769b-438e-8d3c-e8c8fad31ea4; Thu, 25 Jul 2024 19:29:25 +0000 (UTC)
X-Farcaster-Flow-ID: 809b5de6-769b-438e-8d3c-e8c8fad31ea4
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:29:24 +0000
Received: from 88665a182662.ant.amazon.com (10.88.167.203) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 25 Jul 2024 19:29:22 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>
CC: Florian Westphal <fw@strlen.de>, Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>
Subject: [PATCH v1 nf 2/2] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
Date: Thu, 25 Jul 2024 12:28:21 -0700
Message-ID: <20240725192822.4478-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240725192822.4478-1-kuniyu@amazon.com>
References: <20240725192822.4478-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

ip6table_nat_table_init() accesses net->gen->ptr[ip6table_nat_net_ops.id],
but the function is exposed to user space before the entry is allocated
via register_pernet_subsys().

Let's call register_pernet_subsys() before xt_register_template().

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv6/netfilter/ip6table_nat.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 52cf104e3478..e119d4f090cc 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -147,23 +147,27 @@ static struct pernet_operations ip6table_nat_net_ops = {
 
 static int __init ip6table_nat_init(void)
 {
-	int ret = xt_register_template(&nf_nat_ipv6_table,
-				       ip6table_nat_table_init);
+	int ret;
 
+	/* net->gen->ptr[ip6table_nat_net_id] must be allocated
+	 * before calling ip6t_nat_register_lookups().
+	 */
+	ret = register_pernet_subsys(&ip6table_nat_net_ops);
 	if (ret < 0)
 		return ret;
 
-	ret = register_pernet_subsys(&ip6table_nat_net_ops);
+	ret = xt_register_template(&nf_nat_ipv6_table,
+				   ip6table_nat_table_init);
 	if (ret)
-		xt_unregister_template(&nf_nat_ipv6_table);
+		unregister_pernet_subsys(&ip6table_nat_net_ops);
 
 	return ret;
 }
 
 static void __exit ip6table_nat_exit(void)
 {
-	unregister_pernet_subsys(&ip6table_nat_net_ops);
 	xt_unregister_template(&nf_nat_ipv6_table);
+	unregister_pernet_subsys(&ip6table_nat_net_ops);
 }
 
 module_init(ip6table_nat_init);
-- 
2.30.2

