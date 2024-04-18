Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D8716D4C8;
	Thu, 18 Apr 2024 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454238; cv=none; b=s5xIXiCVgoeZIp3Mb9w0kLmBwI3ftzNOK392j8rVkEdi0UZFwEj/2/X1MdNnJytO7+4q9RQM0qPpL3ADxk2IoI+U8JcjAzaTSf/2fB5X9BDWkg9Hly8X7vGh23xRxLZwXqaVKHg/9Pg008pYH1XoFLce6J2D+fb8BoSIskpLZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454238; c=relaxed/simple;
	bh=bRy7CVpGOzC54o9VKJbW6ezYVRb4esYKFVIgRXMzYUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo4P2M9le6gdtyVHfHvBPlqN7iOnf/oJoHMRIHIjRVdYg1CBC4Xn+ydCJSbw8pa6UFfgNp4WVwfqxGpkzRdo9EHRmJ87QB2mg8vqkRb15yrcf0PHuRlcTYoyWxYl1Gicmi7D6DCxcLgv5E92qITFayg4IdlTb5vm24p8O5LHa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTib-0000Ap-Qv; Thu, 18 Apr 2024 17:30:33 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 10/12] selftests: netfilter: nft_meta.sh: small shellcheck cleanup
Date: Thu, 18 Apr 2024 17:27:38 +0200
Message-ID: <20240418152744.15105-11-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
References: <20240418152744.15105-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shellcheck complains about missing "", so add those.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nft_meta.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_meta.sh b/tools/testing/selftests/net/netfilter/nft_meta.sh
index f33154c04d34..71505b6cb252 100755
--- a/tools/testing/selftests/net/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/net/netfilter/nft_meta.sh
@@ -91,10 +91,10 @@ check_one_counter()
 	local want="packets $2"
 	local verbose="$3"
 
-	if ! ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want"; then
+	if ! ip netns exec "$ns0" nft list counter inet filter "$cname" | grep -q "$want"; then
 		echo "FAIL: $cname, want \"$want\", got"
 		ret=1
-		ip netns exec "$ns0" nft list counter inet filter $cname
+		ip netns exec "$ns0" nft list counter inet filter "$cname"
 	fi
 }
 
-- 
2.43.2

