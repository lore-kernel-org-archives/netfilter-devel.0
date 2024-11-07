Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653142170D5
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984361; cv=none; b=rMbXN9miTWCJb5/rdUwU2ur96Tc1voiXbwiiv9t9MBv/VcsUnOXv2R+fBOis5yjqLTxbHtfoe33g9cnoc9Bg19N2U+M+x+0fjpDVyzG26Vyf8ksMGVovMOJzhlSK/1CgLDkAuvOdfgHovJm435l7jOpObugGoAKDrrCdXMf24fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984361; c=relaxed/simple;
	bh=wdns+SjX/Zuv3fNQSxNalPR1S/1S7uwsYfH8zEF1VDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lDxSo9z12OpM3oP6ZnsJhiGQ6jFxsXwMRoFuYTV72glrt/1pUV3wkNhcnOjQZiZ/4IbfJWgG5JE6GiCTEr7O61kgGRMMumUehHG0Dv4p9OJefzDxFUxPBnIT/yBf6/rMlezY2nAYYFpySmPqmEjI3LEDcd2x/R2eAEJddV54XYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t926W-00050J-DT; Thu, 07 Nov 2024 13:59:16 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: monitor: run-tests.sh: restore cwd before unshare
Date: Thu,  7 Nov 2024 13:56:53 +0100
Message-ID: <20241107125657.28339-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The monitor script no longer works if not called from tests/monitor directory:

% tests/monitor/run-tests.sh
unshare: failed to execute tests/monitor/run-tests.sh: No such file or directory

... because the script will change the directory.
Stash and restore to old one so unshare $0 can work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/monitor/run-tests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 214512d269e8..7a8b1a719dc1 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+pushd .
 cd $(dirname $0)
 nft=${NFT:-../../src/nft}
 debug=false
@@ -125,6 +126,7 @@ for arg in "$@"; do
 	[[ "$arg" == "--no-netns" ]] && netns=false
 done
 if $netns; then
+	popd
 	exec unshare -n $0 --no-netns "$@"
 fi
 
-- 
2.45.2

