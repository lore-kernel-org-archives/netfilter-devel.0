Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428FC39A800
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781473; cv=none; b=Ej9I/avPdwC4oopr5R7u6GOr1bwM0edf7h3pwO6TMxHLrXiwJnKdHzoi56d1Dc8yFe6rBPncgE7G/ooEUdkpx2Zl7tlzTOpmQtoz0mUHBdKIOW6ua763aDZ68Zc4wh0G9tbRCexS8/362C3ZFr19ELWeu70FOjugHRVVqni3twg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781473; c=relaxed/simple;
	bh=auG6FIqTZIvzO7tflaLr9CvoYRRjvWOIvPYuSzNEH44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gImwyDv7Wbo4k+BHSr0S4fEWbSfVD9XS+q6bca/OOuXbesl/COU+bJUXTWSm7cQQsM/LPln7RzluIrrDzvwXcTDm3pPydM+YLoS/6U2tqyxl29apE5Gg17nT0CKABEgfCgomtuAjB78pei3JbKkYsH5zK6c2ecys8wjOsgIklGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ykb0W6fa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ykb0W6fa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=59wuYdP/yIfIZNwKWs/Wwa/oysPV+TZEBr+CJbHiHgo=; b=Ykb0W6faLlwfHB8PsAPLovXi7D
	KCznqdFQMzokzudFRT9uGZcqQW7xMqF2YGbDngZSlPAFAV4nsQnNaUNSxfJPpfQOj8Wm6m58rWaBv
	LEeZT8TANQM6bQkUzAV0IswceED+ZzHbPiNw9sTQmfoZ0H+dDKEZm/etDSv1xYQg/4SZXhQrFBFc8
	Xk65ExM3zlD+nfw75RB7Qv0OrHd6CFZTvYAVRxJvhsUN4JS0hn5nZejI7Z9/ayV05OE1ERY03dHu7
	reIlU72tm/sYJB9eBNRZBT9rLaNHYrcECUSPEzOjZ4qAQNl1ww+svvfb2cBcK39/vFrHScFPIvQkk
	egRgdXvg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1waAkm-000000002zV-0nG3;
	Thu, 18 Jun 2026 13:17:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Run tests with a fixed TZ
Date: Thu, 18 Jun 2026 13:17:43 +0200
Message-ID: <20260618111743.3001357-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Inheriting the system's local TZ is problematic with meta time/hour
expressions in dumps. Use UTC-2 since that matches what py test suite is
using.

While at it, fix up the first two dumps containing such expressions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/helpers/test-wrapper.sh                             | 1 +
 .../shell/testcases/parsing/dumps/exclusive_start_cond.json-nft | 2 +-
 tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft    | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index cef38a59b776c..7a73e531f7e42 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -62,6 +62,7 @@ START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
 export TMPDIR="$NFT_TEST_TESTTMPDIR"
 export NFT_TEST_LIBRARY_FILE="$NFT_TEST_BASEDIR/helpers/lib.sh"
+export TZ='UTC-2'
 
 CLEANUP_UMOUNT_VAR_RUN=n
 
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
index b0fffef2d2a33..a1fbaafd1aa13 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
@@ -1730,7 +1730,7 @@
                   "key": "time"
                 }
               },
-              "right": "1970-01-01 01:00:00"
+              "right": "1970-01-01 02:00:00"
             }
           }
         ]
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
index 5cd2d1b3c576e..2b94feaa77d8e 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
@@ -73,7 +73,7 @@ table ip t {
 		limit rate 1/second burst 5 packets oifgroup "default"
 		limit rate 1/second burst 5 packets meta cgroup 0
 		limit rate 1/second burst 5 packets meta ipsec missing
-		limit rate 1/second burst 5 packets meta time "1970-01-01 01:00:00"
+		limit rate 1/second burst 5 packets meta time "1970-01-01 02:00:00"
 		limit rate 1/second burst 5 packets meta day "Sunday"
 		limit rate 1/second burst 5 packets meta hour "02:00"
 		limit rate 1/second burst 5 packets socket mark 0x00000000
-- 
2.54.0

