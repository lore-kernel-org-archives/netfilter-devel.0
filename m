Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32693199E91
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726749607; cv=none; b=Tqy0bbDqoEdX+RUs1y9AhntBPaDGKHbBdZaI/zbK5N4lWmwlXRMyORnvYmBQhSGq+Apm2p/SScWs1U+GBYU7z8m2PcyXd3xIVlQtULLtGDicGq1TsAxpese1ZdEmsTc5iVVoSS88HWMyeeGNbrU0v5VkP9ZMp3jaEtavpi7vNdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726749607; c=relaxed/simple;
	bh=3Zb2LhEHQH0d0eyeXg9VLnLJHABPOWwtL21/gTsxMyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T5aElseM1u1Ugz3xtEpXWlMbsmKk7KvM3X4SNrTspkkD1O0sToECJ7kkuTwAOc7wGHU75w84rkK0eM+EF6ehKqIPUK0UrUWztBDm1tG49ZJ3j4fzFkwnjQ9Gkz+IznLQIPr6n26+KzEPVJiNYXMSwNgMwJLa4zj5dzy5yBlitmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=URDP++iI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="URDP++iI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+UTKba5sxNInYW6gr70LaXc51queLYKS1Zfm/TbEWQw=; b=URDP++iIKHL7tLt0eYrJgOIWpX
	Z1t3CxRWPxSk7hJjhGJQjCnRQiLVCNLpCwej3MtsAGbSnOQ/f4r76eSc2lAeX9v6AFNMgwg9WGRV/
	xCxD9JdDjQ8r1p32q8kE/d4Z2fOHruFAP1ngFYApbdnhtMLdec/r3F7RTKU9HNacVWCzKrabqkAYb
	5m4MEq8EDGDOxFAoOohGd+fnAsptf28Id1NR3n7RpmAbHsW+u58Jc4LLIHb1kQurVKg22/AglW6dm
	s5WBo0mhy8Xdg1LebGhI3HTG18/6nE3NmsZncushYvDa8qFLkZtTFkrkKLsnYPd4w3QAML4LTw7tv
	uO6BwABg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srGS3-000000003bI-2ee1;
	Thu, 19 Sep 2024 14:40:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2] selftests: netfilter: Avoid hanging ipvs.sh
Date: Thu, 19 Sep 2024 14:40:00 +0200
Message-ID: <20240919124000.24079-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the client can't reach the server, the latter remains listening
forever. Kill it after 5s of waiting.

Fixes: 867d2190799ab ("selftests: netfilter: add ipvs test script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Don't rely upon availability of 'waitpid' but use 'timeout' instead.
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 4ceee9fb3949..d3edb16cd4b3 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -97,7 +97,7 @@ cleanup() {
 }
 
 server_listen() {
-	ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
+	ip netns exec "$ns2" timeout 5 socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
 	server_pid=$!
 	sleep 0.2
 }
-- 
2.43.0

