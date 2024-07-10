Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241C83CCB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 21:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720647715; cv=none; b=toYX/DbICb/IXs4AoKQEz77IdvwyYjlYBsOVK3M8bGUZ1OdJdotPmGHJvwsyphfzktMPFnpFvwGx4iXXZ78kwERNwtXXmE+roMgoprg5j7/MNTDdrc/YdGBJcYDvkBIBOdOQbGFBupAHF2aTvPLqxHLlJIibRH0ZokVVfLKNsYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720647715; c=relaxed/simple;
	bh=s3Vue5VhCKp+41LW+gkM8pin6dAMGh2C13DYDm6XqtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRrvaRx452nLBMWGpe2hQpui6wVEw7BxGDajSjND66+sw5G8IMQAuvFvhewenik91NazysyuCoYmtKoMJKkC2JBzbyn50Q45QX4Oey1cROSbatCUe9qTAhlvQ260mxARA5bFCf/WZykbmoO8Mw8vUXq3gx207etPDEUCdRlhwD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sRf4S-0000mX-FM; Wed, 10 Jul 2024 23:41:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] testcases: test jump to basechain is rejected, even if there is no loop
Date: Wed, 10 Jul 2024 23:42:19 +0200
Message-ID: <20240710214224.11841-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240710214224.11841-1-fw@strlen.de>
References: <20240710214224.11841-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check that we can't jump to input hook from output.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../shell/testcases/chains/jump_to_base_chain | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 tests/shell/testcases/chains/jump_to_base_chain

diff --git a/tests/shell/testcases/chains/jump_to_base_chain b/tests/shell/testcases/chains/jump_to_base_chain
new file mode 100755
index 000000000000..d71da4cf35eb
--- /dev/null
+++ b/tests/shell/testcases/chains/jump_to_base_chain
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+$NFT -f - <<EOF
+table t {
+	chain i {
+		type filter hook input priority 0
+	}
+
+	chain o {
+		type filter hook output priority 0
+		jump c
+	}
+
+	chain c {
+		jump i
+	}
+}
+EOF
+
+if [ $? -eq 0 ];then
+	echo "E: Accepted jump to a base chain"
+	exit 1
+fi
+
+exit 0
-- 
2.44.2

