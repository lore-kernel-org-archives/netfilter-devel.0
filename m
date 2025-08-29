Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B8F322DD0
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482735; cv=none; b=ADi5tniQd26kntKNBRXsYBksbD97+A93KNoq8X4H1WBQ5VHvY0RYMeh7BQdcMSupLFg4lppR7McMyoonm7qhe29K9RoBmnurr0ijyqo/9OuZRfVZlbzs/HOWHdUlq6vXvQ+we4XOAixHuH9+YenOVxUtb0vLXGQplK0Wa/+9sfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482735; c=relaxed/simple;
	bh=yLSLpjf4h7z9wrM7wU2lfdXlosiHVtohcj79/VweKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpqtMAG1kMx1KozaF7mHw+AB6rO+QzTmb2MnH00JbbTCqWJyPK1vfn+WGRLWN/UymPaMVqsVcDoqG/SvfHap5rvUa2viAEkOIPcVk0Kb43YfX/pbl4PlpM/ETsGETDav9A5yBuLJwF/agigijui4Q1fUrvmCEBcmOSW0nfRBIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pN6K60mL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pN6K60mL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lG1Hr9PBHa4u0XjOWQdtt9pkT21jAc7fwelFCPOu3Y4=; b=pN6K60mLDoGk049p0vbAloC/Rc
	Rq+36fXBGrlkvFEF9xZUImrLKYjGEPlReSOz+ofgm8TGFEs0Ze6vEknaDtIgnsDhvSJtOpmKt9aNG
	QLWbKHv3wgvbM6wm4WCgvtitddoi7i9NYBan2GnAkRrphfL+fdAaPQrhQKzURnLMbO9HHJfNiLrkN
	OUs1U3Ec0fURaqkaP+qzhFAYhGZOGNRZY+Mz6CtoydZoT0l6/0+QX396QBv3kSfm47TwF3MC7kaTP
	oDha/zCINYyBZkdbB6sIDdK88biOZb1IHxnLPMNtTZ2ZjjKjawPPMri+XlrX9Q0wV9ztQ88Yu6a4+
	+QtvXAkA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Oe-000000001SA-1wPZ;
	Fri, 29 Aug 2025 17:52:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 6/7] tests: build: Do not assume caller's CWD
Date: Fri, 29 Aug 2025 17:52:02 +0200
Message-ID: <20250829155203.29000-7-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829155203.29000-1-phil@nwl.cc>
References: <20250829155203.29000-1-phil@nwl.cc>
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

