Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE19EC2
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Naizb0q0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XUj0SACcJOtcLOcw4zQHfJszOtF5XbtwQKopYBeRILc=; b=Naizb0q0yayWaRrJ8c4mX9RlTj
	PULIIcOE36eZY36+1Q6U+sbZp+0bDBY376tDIM9+yZTOtnVnGzAWObKmlYErextLG4p0ecm8Lr7qY
	xmFkv+t8Jl0PuG5BQHbMlPiKNnwhY8iSPutxCVsZUkB8Hl/zpUIokBldKMsdbOhvxpqveErZB0wfW
	UOkNQl4PQ5kpSfUB7jJenmuyMLOSZCVrHfRevcE32XzAe85Ad0ni6iEjTYNku8jQrP3ZwUSDjHIpw
	xdcyQ1d7gGWHhgYSiTBSQYozAluvJ3vuyZwft0bFTYFjDr3rm8Ao9yoqiMYiDdB0zEDuweFpyVqz9
	3w+9NhVw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNZqX-000000006HY-03GZ;
	Wed, 10 Jan 2024 15:46:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 2/2] iptables-save: Avoid /etc/protocols lookups
Date: Wed, 10 Jan 2024 15:46:19 +0100
Message-ID: <20240110144619.32070-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110144619.32070-1-phil@nwl.cc>
References: <20240110144619.32070-1-phil@nwl.cc>
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
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 6d4ae992a5591..53704c6908133 100644
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

