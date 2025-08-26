Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9982E1C6B
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756228016; cv=none; b=fk05W6CYgNHpN+GR+tITg+D5kDwtJK9vIX+hOxcThKCM/lOJPkSRkwXpfmvHlaMkO/u7cUgtfO1He7X6y6W1JtBoDv2NsjF+XHBt/Y9VSmSqCSf3Egqt4sZKIZk2d4mCRyCkfFNELCV7Fs57sCUvg54rljU5BbqG1/pXkcZhNvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756228016; c=relaxed/simple;
	bh=/3sYTb4K9La59uephps2GDIL54HzZIoe8R6d6Vuj5OM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YVin7wZJL/cJ24JzvA1tWlGUfIpuItfIPOSK+VF+IeMq+8ZgQCnQPF3A7I9RcDtCcJhWcwEMTdQ3BKMWhvwh16aKRH3QABCYxOwU9GmlWN1cKpLvg6q4UurAkc+zU2oi0VDu6sHvall14hc5hNoLmsAP4xeV4pL9jGryGVnQRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ISzQP5WP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ISzQP5WP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MCjvhx01YHYewgtHMnnqk9QvMpeJSO649FJj8IqTdwA=; b=ISzQP5WP356o+VNDOdahMAK/9M
	mFKu4qqfVPOzZ1zV0scdHRnmuLupe+fA7H0DHaZZ8x2tjMKEyBEjiw8AluglVLYAV84ACuWuEGXND
	NfwZVCs/qUF+ctLuELAy1t+CckmbgMzpjC2/n+wbOYhb6BA9O/xuEzrETIdD9rcFLGplXkmPcgm60
	6TJPPIe7wVeH/uuGi01A1+kaJlcThvZsXaS4VmtX1JqennMuwKuYoD5N7m3JyKKfo0BKKhoFWu3Dg
	dcVGnj74BnRnVDrwZrcJ89vZpHKW6Q62Uj4xnWhXErAEPBuifhXWPuHSIE3/9uQdpBUcoFH2Y5rjf
	oYvITqEA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uqx8E-000000004fA-1WsD;
	Tue, 26 Aug 2025 19:06:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Makefile: Fix for 'make distcheck'
Date: Tue, 26 Aug 2025 19:06:43 +0200
Message-ID: <20250826170643.3362-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure the files in tools/ are added to the tarball and that the
created nftables.service file is removed upon 'make clean'.

Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 14915a58cdced..3345412991289 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -409,8 +409,12 @@ EXTRA_DIST += \
 EXTRA_DIST += \
 	files \
 	tests \
+	tools/nftables.service.8 \
+	tools/nftables.service.in \
 	$(NULL)
 
+CLEANFILES += tools/nftables.service
+
 AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
 TESTS = tests/json_echo/run-test.py \
 	tests/monitor/run-tests.sh \
-- 
2.51.0

