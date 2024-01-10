Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1775024C
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JOzFhzsD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Yeunm7X1oBk54xksFTJG4GjXS4G43n72rlPbXtP92dI=; b=JOzFhzsDG1WIH+uNTgU0bed2bN
	KNqU5OwE+iWpbdC+2XPbC4IC4aaArebMnR3qJQVtwPSK5pamajrezUZLhrQ/tO9FWSJtUB7KH5b3Z
	j2yzpzJWRxsBX/HHz6glXuFHqnNdgZ50RJEUnTq7yK80B44Q8MATp8uOw5ZiCurYWtR8LuZarttpp
	eLE47aNaolST9pUQtwVMwBQeiiqkEvD7xfcPPSEEvhcaPU5qztAVk5w3JxY3itrCS8O3HJdMDrJaI
	svJx5j2qJ9J6QojDlZldRP492xzT9yx32wyufU5e514j4DvXXW7covVpXelqSZ/+T8GIC6gOejOrU
	xEy+Lk2Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNhGV-000000005W5-16at;
	Wed, 10 Jan 2024 23:41:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 2/3] libxtables: Add dccp and ipcomp to xtables_chain_protos
Date: Wed, 10 Jan 2024 23:41:35 +0100
Message-ID: <20240110224136.11211-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110224136.11211-1-phil@nwl.cc>
References: <20240110224136.11211-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are "protocol extensions" for both just like with TCP or UDP.
Caching their values allows for implicit extension lookup after '-p'
flag, for instance:

| iptables -A FORWARD -p dccp --dport 1
| iptables -A FORWARD -p ipcomp --ipcompspi 18

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index b4339e8d31275..38b50f7aca93e 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2201,6 +2201,8 @@ const struct xtables_pprot xtables_chain_protos[] = {
 	{"mobility-header", IPPROTO_MH},
 	{"ipv6-mh",   IPPROTO_MH},
 	{"mh",        IPPROTO_MH},
+	{"dccp",      IPPROTO_DCCP},
+	{"ipcomp",    IPPROTO_COMP},
 	{"all",       0},
 	{NULL},
 };
-- 
2.43.0

