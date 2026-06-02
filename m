Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC57337A493
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780405651; cv=none; b=batLQ0T1kbD18H9JplrZSuXFgEj1DCl3PJWxSKP2VTVXRap4Kv8suyAFL5RpVSMZq561ALk41mXYoSCkEnnVi8r3yjJ56fF/sT+bvYcLtCD2ZYdXV9xqsYEIRRrD5TWx63VpJnSyuz00+cSndqPq0mHaLDfPJY7PAkqpUmBdwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780405651; c=relaxed/simple;
	bh=ulIMXrdw+4wUEhT6vbBlmhRu6IkP8EtPwV+4uxSk+ik=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hoYrFhptZG1hryBQN1eX8DP6fnJuNUHXm0RQ5Sxs5LAZf3LQ9D9VFWMjHwMosYpyusTrdw9Voc8KgBIi6hEGBPV2iADT4t+1OAAGDZpr6rPjGeiSRr1wbvC4kFmmai3mdINMmuCxGXj9ypckdgsm+cIHBa96qWhVi2PVMdXYpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=knBwufFr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="knBwufFr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fdjQGybUKJ4Xsld021jpmpCL3ZfHYmMGVhd03ZIh7FE=; b=knBwufFrmveJCaCNwqLBfix952
	uIorNzqeFeQX1tlb6GfY/R9Ka6N3OToh4pjDYK+ww+HIlLnA2U4vNRap0bVg9+R8nPwGdGG+1jBbX
	nFLqTXTsbKjKbMsLo2ODQ7AkJc541nrxrgkonVvabL4REXzBHPEgNvuhTp1Zxsngs+BZRgytr8ElF
	r2Gf8EIEZb2nFZMVQdm9aefFHDBr+cJ5ujUNfbzkj/VKj0zkNaHy/1gnu/ezFJKLXL7uwRLif5h58
	drMuvOICH6Jz/Yp/skEmrj/ZUaXmXAt3f/uSsXVIS/EFXgvEGZFrgkZ9PloQL8KiVeu5ZSGWZA8bl
	ATIHEvww==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUOq0-000000001F0-3L6l
	for netfilter-devel@vger.kernel.org;
	Tue, 02 Jun 2026 15:07:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: packetpath/ct_count: Add missing socat feature test
Date: Tue,  2 Jun 2026 15:07:15 +0200
Message-ID: <20260602130715.727246-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip the test on systems which don't have socat installed.

Fixes: 95e4cbf6b63c2 ("tests: shell: add simple 'ct count' test case")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/ct_count | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/testcases/packetpath/ct_count b/tests/shell/testcases/packetpath/ct_count
index 06f586ed7cce5..77efc715be3be 100755
--- a/tests/shell/testcases/packetpath/ct_count
+++ b/tests/shell/testcases/packetpath/ct_count
@@ -1,6 +1,8 @@
 #!/bin/bash
 # Test nftables connlimit functionality using network namespaces and socat
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
 . $NFT_TEST_LIBRARY_FILE
 
 set -e
-- 
2.54.0

