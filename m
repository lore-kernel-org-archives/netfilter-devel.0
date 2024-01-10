Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4F450248
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DNKcKtEF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dl1NMA4rVOSzjxS9zwCxURhgIakjRNF2oIe0HyfXBuQ=; b=DNKcKtEFM04CPY+sqdvW3aixyb
	IoSSemi5SiU3CiRSP8DndjlNP0b+LL1yhjN8iMsGwgobqmh2uA+1/9eMDDz7X5DmgOOaYN4rudwCk
	dpdqlfWY8ALcTmrIe0QqlQvZLdIKBG95PrIHTVEpzZAJzZE7juA1ieyX5miDf/4QtJzGCXWq54SET
	abdxuLC7BESrPGqasSdyI73LD4SEpGMQIFJIs2JkXfYzQuVG5k8AGh7cTOw46cCzbuTBBbTCM0V61
	NV3FxELofpLRypqahQ0uWYrtzMu/sPBf+Ws55ziKumD13J3tcMPc9/g7wLg71TD+KW/knL8/+Xqj3
	X/UoqYRw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNhGU-000000005Vu-0nwV;
	Wed, 10 Jan 2024 23:41:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 3/3] iptables-save: Avoid /etc/protocols lookups
Date: Wed, 10 Jan 2024 23:41:36 +0100
Message-ID: <20240110224136.11211-4-phil@nwl.cc>
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

Instrument proto_to_name() to abort if given protocol number is not
among the well-known ones in xtables_chain_protos. Along with
xtables_parse_protocol() preferring said array for lookups as well, this
ensures reliable dump'n'restore regardless of /etc/protocols contents.

Another benefit is rule dump performance. A simple test-case dumping
100k rules matching on dccp protocol shows an 8s delta (2s vs. 10s for
legacy, 0.5s vs. 8s for nft) with this patch applied. For reference:

| for variant in nft legacy; do
| 	(
| 		echo "*filter"
| 		for ((i = 0; i < 100000; i++)); do
| 		        echo "-A FORWARD -p dccp -j ACCEPT"
| 		done
| 		echo "COMMIT"
| 	) | iptables-${variant}-restore
| 	time iptables-${variant}-save | wc -l
| 	iptables-${variant} -F
| done

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/testcases/ipt-save/0001load-dumps_0 | 1 +
 iptables/xshared.c                                       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/tests/shell/testcases/ipt-save/0001load-dumps_0 b/iptables/tests/shell/testcases/ipt-save/0001load-dumps_0
index 4e0be51c071c8..48f5f7b423379 100755
--- a/iptables/tests/shell/testcases/ipt-save/0001load-dumps_0
+++ b/iptables/tests/shell/testcases/ipt-save/0001load-dumps_0
@@ -39,6 +39,7 @@ do_simple()
 
 	$XT_MULTI ${iptables}-restore < "$dumpfile"
 	$XT_MULTI ${iptables}-save | grep -v "^#" > "$tmpfile"
+	sed -i -e 's/-p 47 /-p gre /' "$tmpfile"
 	do_diff $dumpfile "$tmpfile"
 	if [ $? -ne 0 ]; then
 		# cp "$tmpfile" "$dumpfile.got"
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 68f70277388a6..51283d7afad1e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1097,7 +1097,7 @@ void save_rule_details(const char *iniface, const char *outiface,
 	}
 
 	if (proto > 0) {
-		const char *pname = proto_to_name(proto, 0);
+		const char *pname = proto_to_name(proto, true);
 
 		if (invflags & XT_INV_PROTO)
 			printf(" !");
-- 
2.43.0

