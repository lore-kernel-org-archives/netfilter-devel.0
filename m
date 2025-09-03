Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981683043DB
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920189; cv=none; b=p7XtJbqSvYkuppw+O6N94XCi2+qcyBKYGJVaHD7vtxAV9y+QNfZ6FGNF7CfISKF71zGM1o2tmOd2i1/gM+CGEZWfzwHILOqqK0in0mEK2gX9KADp6U5K1YJLHMsmhQNMPtZ2tbyt4Bvdmg97RvA9obGNGnBAK6eGbPkBZOGh1yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920189; c=relaxed/simple;
	bh=l3/ZZJJ9iwDcyleAVmH7CnUsa50ufB59fNpJ6EznleU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4jEonFHHf2rH9KEK5qupmwJDK17WQCheWP8wjBjiGRwiAW4eM+FBtCRMzRn8XvmGSGLLazRIDXHFSZ/qXGAlRiybnqB2eeBCl9eyVDwcki3nO4jkqzV9UxsEsiNGfqeEMMTlCVF7BjdYt5Ij5B3e9L2dUQaNof/y/nLErg4tNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CK7Zoe8e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CK7Zoe8e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b0kYMjaQNygENWdhn4EJp9R29qfFqDRY7b7vfk4lPvY=; b=CK7Zoe8eh0OmZpm72PJwWD6uxf
	JOXYNK9w0ssCqS8YZjt78QaePq1rxy5Iu7vj0EDk6z4QwFd7ypP9jpT1d//FEhPJWWK3Y2YqfcLGT
	rclEHYcp4kxSFtpUXwsPNsBJgoX6qYVGt+ReJI5WteiJFUyQnaXZFNmoK8K6LxzP8MtyvZwdp4/+h
	5fuKb1udwUEKllfXTkOPdX6PpN9JkURSjUMsky7Tq6bxwEsm8D/TVrvk3fNr6PKp212O9RzL1HX6L
	1v9d7e+ZXVsoh66zYVqs6/aIH7SUroHh93G03yGbgTsUoEaFTIi3iK8nGdSdOi6h2DR0NieUE5/jv
	RNyoK7oQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCL-0000000080B-2Kk5;
	Wed, 03 Sep 2025 19:23:05 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 01/11] tests: monitor: Label diffs to help users
Date: Wed,  3 Sep 2025 19:22:49 +0200
Message-ID: <20250903172259.26266-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>
References: <20250903172259.26266-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clarify what was expected and what was actually received.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 67d3e618cee07..03091d1745212 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -5,7 +5,7 @@ debug=false
 test_json=false
 
 mydiff() {
-	diff -w -I '^# ' "$@"
+	diff -w -I '^# ' --label "expected" --label "got" "$@"
 }
 
 err() {
-- 
2.51.0

