Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CAC1CDFCA
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920189; cv=none; b=S1EQ+uHfKo4n070NlPTws5xh5l3aDLNicfAGYYaH4Q6WoTkyq42Pfr8EJ97M/xzPBUF0FguZiadUKoQiPyiVofe1iwU//H27tZ8EZqbSX6JId2gi3Ufk7ci26iLWBciHysZSyq9xP2eI5dliELUIwhEsWYmev9g9WguSJ3nenJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920189; c=relaxed/simple;
	bh=yLSLpjf4h7z9wrM7wU2lfdXlosiHVtohcj79/VweKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaSAvypiVskGQMAARbmw0w50QJSgsiRNmGnrsO9jupC0sYsZa3ylJUmV400GzrwilgBH2ILXJ6iZzhypC/8LNfUD24BPwTmHXZTIHWFsQEPWZ+wKlvp/Arq4QEuTabjlt/OCUAgIlTf/ic+6Cex0/4SEOJU4T2hFyl/v7BftfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TttsixkL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TttsixkL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lG1Hr9PBHa4u0XjOWQdtt9pkT21jAc7fwelFCPOu3Y4=; b=TttsixkLBlphWt4scHFvu5SUnp
	rC/na5kWPxRw7yvlNLOcFb8xsrv+B2hBHfWlEAgWiOGIUb9hRtT9GQrWY2C1CdU37G8HZHjVBmX6d
	hjNjbNqCZwlBk9K/DNmho+Vge6Pa3lIIvvfYKRSn/Z9FpD9NipO95SY7d7hI/c3cyAK1zPLoCIXlW
	lGV1gS7Nr5Ndkr6mI6MblDFRqAlOQXdVJ91vRbZGgJ9b27iq1++Oh+rw2MVB5Kubnk3HTB1q/BthM
	sXlb3bE+XQ4kMB8BVHDwbzN7ikSiebk25aKqoAkCcQdzK9/nMarjM+3jjqx2Z+LI9kpdbQH3zxDfV
	CY/MRfFg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCK-00000000800-2JeI;
	Wed, 03 Sep 2025 19:23:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 10/11] tests: build: Do not assume caller's CWD
Date: Wed,  3 Sep 2025 19:22:58 +0200
Message-ID: <20250903172259.26266-11-phil@nwl.cc>
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

