Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172882E1C79
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034504; cv=none; b=E4XanGUmRfTcdmxO+iXeTeE4dRFO2xd363hUvUWZiAjrZfxG477/+joCIesf9HyfnAhGuwkc02/vWX3p8682MMTKBxGKuVw58bFW66aZPA+WkD7PNEsympNbT48mFus0SOCZPph2UQo4emhp47srFLmyNpUW2L4v8lNRp5f1CFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034504; c=relaxed/simple;
	bh=WukY6ttxvlZ2dHKq3aw7wY3Vi1V/xqY6WHfw8cFbLhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7aJcpymFWpzJdH4l+hr7nNemt8Hx7XWF/Bhz6+ctx9iSRVSe6hds2KU9J3RRAY/zQ8dzDJaDto1Ha6pclMwujlZ4BPvcqzXNqCCtSk38CZkBQLzC+8vKs8x2cYWDEG7v69mkQNMzcWaAvxHdrmW+KptVeBcZRf36ZCtY6OMJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 35E6D60A73; Fri, 27 Jun 2025 16:28:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/4] selftests: netfilter: conntrack_resize.sh: also use udpclash tool
Date: Fri, 27 Jun 2025 16:27:52 +0200
Message-ID: <20250627142758.25664-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250627142758.25664-1-fw@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous patch added a new clash resolution test case.
Also use this during conntrack resize stress test in addition
to icmp ping flood.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/conntrack_resize.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index aa1ba07eaf50..788cd56ea4a0 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -177,6 +177,22 @@ EOF
 	done
 }
 
+ct_udpclash()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	[ -x udpclash ] || return
+
+        while [ $now -lt $end ]; do
+		ip netns exec "$ns" ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
+
+		now=$(date +%s)
+	done
+}
+
 # dump to /dev/null.  We don't want dumps to cause infinite loops
 # or use-after-free even when conntrack table is altered while dumps
 # are in progress.
@@ -267,6 +283,7 @@ insert_flood()
 
 	ct_pingflood "$n" "$timeout" "floodresize" &
 	ct_udpflood "$n" "$timeout" &
+	ct_udpclash "$n" "$timeout" &
 
 	insert_ctnetlink "$n" "$r" &
 	ctflush "$n" "$timeout" &
-- 
2.49.0

