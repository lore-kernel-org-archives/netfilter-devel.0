Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1083520F5C8
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987204; cv=none; b=B2rNDHcUaz0C+wnh1vtk3q/ENg8WUrte7n+rKVMMQRDxCfKaSA4RbUPnStnrI6yO30qJ7qHELZVbGFwrKUsWIOC+PME8pQTLsHrGsozT2Pl7kGak/yVMpxahtuckE3Em3KOjFgecIFFK/HzvmCo3cOPqE+sI/RvPxDKdQtVX5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987204; c=relaxed/simple;
	bh=LjTl2cTf3u3ZTCoG6RR9ojsI5p1zYs0TkxwaMBMxaOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kAlGEREN1/s4Tf7U7WN3GIVdwxoqXPR9/2YVazQ3gqv1ITUJDu4OlzhnkDl1b8LAXoqS5/aKajmBU6xyQ32moCOBpE/sdYKkBChTPyqrdkhPUdFy4/foUwE/h3sNezp1PRp1ldz0Or5JK72Xll11WwjYKE9g/TiQil6FR1NNx/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=COyfIgun; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="COyfIgun"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OzMS0m05jOGKU603gi7WVAngzSG9ZtSc9O+hoZc4uek=; b=COyfIgunix18y23uJX34Bhcn2F
	JufXLwBBur3DO3Uja9xiVUjKK6Knh627LczVrWRUvDhOUNu2qRy8ywMTisnVEKuOz1N+5JOaT01rP
	AAlidWouJsmUU9/NWQAMkkl9UJNrj6DBTFUUOD9I93fZt0ZSzLrwvR7YZiDve2A2FCV65c7r0H69E
	lj9Son2vEwfnsl6j4VLfnGPl5Z79cLW5FxNLs5OOw9jC5we/fz3QP+9mbAW6Lt90ruZZ3KiOHVTnW
	EPDT7yKwli3scXP0oIcSb70vBs8KSzm8VgOvLh8FVPeQ4YEMLufYSedfQFefR23rUIX04c0YRn+Ue
	7o+iQU4w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t92qO-0000000019K-0sJG;
	Thu, 07 Nov 2024 14:46:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] tests: monitor: Become $PWD agnostic
Date: Thu,  7 Nov 2024 14:46:36 +0100
Message-ID: <20241107134636.9069-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to 'cd' is problematic since later the script tries to 'exec
unshare -n $0'. This is not the only problem though: Individual test
cases specified on command line are expected to be relative to the
script's directory, too. Just get rid of these nonsensical restrictions.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 36fc800c10520..9d25a395cbcf2 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -1,7 +1,6 @@
 #!/bin/bash
 
-cd $(dirname $0)
-nft=${NFT:-../../src/nft}
+nft=${NFT:-$(dirname $0)/../../src/nft}
 debug=false
 test_json=false
 
@@ -192,7 +191,7 @@ while [ -n "$1" ]; do
 		nft=nft
 		shift
 		;;
-	testcases/*.t)
+	*.t)
 		testcases+=" $1"
 		shift
 		;;
-- 
2.47.0

