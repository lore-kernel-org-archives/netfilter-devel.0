Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F01224AE6
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999504; cv=none; b=cIKMlKG/IEVKw2oYJgiWmXRPMM2zmM9MqiHVtNA1Xjv50gbSWJ2ZYBpLBrJPRgMTaTzV6a1oaUr4uqakiw33hEzQ0QqghSWOYhVb3kJn/In82GHIMyQLFWk6Bhv7xD/guuTPCRYzu+FddGHugs/YWnyzaRFeV16Rs/obdWG8f8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999504; c=relaxed/simple;
	bh=yLSLpjf4h7z9wrM7wU2lfdXlosiHVtohcj79/VweKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpaoaIXUrkPbBP76xwkYTQnwaJMnvOwfHrLJ+vhRPo8VZUt5S9I2/x7VTewH6N2bxd1ht2PiOIyc/eVHEbIl0G55bmFnYWJNzFuxjBfrj0fOA0F5/V4w8SjCaPzIm/mzjV7uwVqbHEyOQh29OvYDMGf+e/xlFuvrA9RYEcim8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fEne45aS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fEne45aS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lG1Hr9PBHa4u0XjOWQdtt9pkT21jAc7fwelFCPOu3Y4=; b=fEne45aSZ7he/EyarpCTlswSIO
	H7mXJvmZCMiHxr+TbfOrwtCmw3D2YzdKCc6mKiaMiJXHs31fOJAq32O/1UJn4kbiujCrxubBMN+9N
	Zk3k+bRLPSqlQzOAGU96/tP0IeQZVNOHMZ5kYD6N0/7AzA+u6KVAvNAJA2Zr6Ebu1Q6ComI+E45EV
	IrJfbrJgfK+21uR/xlysiDP3/Rig7y2FH7uTOn1Cid7a0K7fCLP9HAN8fFobe8a6LGkNKA8rmRTal
	br0H8h3+XR7s8UxKA8uNV0SViQ5PSU3ZoQ+DOQgo0Hj++1vyVReq/xBlnAQTtyIN0zkFyhwNmGNix
	HZ06La5w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBpc-000000001oC-1ANH;
	Thu, 04 Sep 2025 17:25:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 6/8] tests: build: Do not assume caller's CWD
Date: Thu,  4 Sep 2025 17:24:52 +0200
Message-ID: <20250904152454.13054-7-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250904152454.13054-1-phil@nwl.cc>
References: <20250904152454.13054-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cover for being called from a different directory by changing into the
test suite's directory first.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/build/run-tests.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index 674383cb6cc74..a5e026a97dd5b 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+cd $(dirname $0)
+
 log_file="$(pwd)/tests.log"
 dir=../..
 argument=( --without-cli --with-cli=linenoise --with-cli=editline --enable-debug --with-mini-gmp
-- 
2.51.0

