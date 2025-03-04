Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D3224C093
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Mar 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741101132; cv=none; b=BymGSiD91daWFfTSe1caF6EukRlee4z4EFklBIVnNDgF0JjLIuiKEX4QKBKuGmjFGNSRKlHMlecnVlEig4eOlqhMEwPOu59eBKG9EHdSk23e7m8Ff8UPYaHtc33TYQAMvYc3sS4ESG+BmRpZFirG2+pBgvInLB8+TyNg+3pVr9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741101132; c=relaxed/simple;
	bh=haD7QT6Gox/C/NiMB8ThpZ/Svue71iTP0YPcA/DfhnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jhXmN38FnH0jqHvlBeGhD0kxVWEMVcxpa/++1yXowDg16FIqUy/czpXYEjBK8BVIlnjHBxthtdtrUrgV4qXcllaKD8atiidSexzPOGOoZ4xLq3VzL4/+uFLxLg+Z4owMXrP/fslUym0RE6yr5gBADz9PN99CpMjr9+RzjVrtpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tpTwF-0004od-9A; Tue, 04 Mar 2025 16:12:07 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: remove temporary file
Date: Tue,  4 Mar 2025 16:11:57 +0100
Message-ID: <20250304151202.2570205-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

0002-relative leaves a temporary file in the current working
directory, at the time the "trap" argument is expanded, tmpfile2
isn't set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/include/0002relative_0 | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/include/0002relative_0 b/tests/shell/testcases/include/0002relative_0
index dbf11e7db171..ac8355475320 100755
--- a/tests/shell/testcases/include/0002relative_0
+++ b/tests/shell/testcases/include/0002relative_0
@@ -7,9 +7,14 @@ if [ ! -w "$tmpfile1" ] ; then
 	exit 77
 fi
 
-trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
-set -e
+cleanup()
+{
+	rm -f "$tmpfile1" "$tmpfile2"
+}
+
+trap cleanup EXIT
 
+set -e
 tmpfile2=$(mktemp -p .)
 
 RULESET1="add table x"
-- 
2.48.1

