Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F722539F
	for <netfilter-devel@vger.kernel.org>; Fri,  9 May 2025 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746801385; cv=none; b=QtPmeNpU46YHV6fGqoRVYxhHSrpkiSDkyBr1YNeYCGr7pYk+eICmY+g7aCEbcmmZK4cl8SP3n5VI7xn0rFhDAS+PHrvVI4d2hAGELHamgAUiO/m/5N8M/StGimjEt1gVJ+sZnvUYxXh8ucVZznb1n3ZMp8h9IXIkOscq7Z99Pds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746801385; c=relaxed/simple;
	bh=U3pVmWVkDv8x+PjI3ZYz9ITYuuWZcj6PJqYFwQwj/Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HR9vVCYPrbtdaXDkbYMcn8tMNgAfqWRRaH0bQayIbSnqnz8AVOKCFjh8I5O80QAy/B9X0cMmD/vB+RkNlvwtiOWCN+3x9e8bPONk6Vft7zR3/XwCQrZxgOYw6ZWthgKHKa639Njm+7Cuhb2/zy7WvIjL+d0zRhf5FuQRM/G1qoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VLLdavlw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VLLdavlw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CQFKHF9YsBLOV0+PRvQCP+bU5vFl6LQF9Cuf879L+vg=; b=VLLdavlwnrFmUd0aInxDZOCpg7
	/bOjxw66locWdpJKfm6PUKXXUpRpui5wiYUXQ5xGGdPnCUUc6zjUe4aDGj1vNNrjb/Br2yX5J/yVu
	GewnaG/bWagP9MoJjdluahNiyUcRNK72dmPfP8IRJBnlzio+ygg+Fw2aHnrn7LknTQDC73Ax71nje
	ZxqY4GKqT/xdlTn0imjYUSHPGZDfYOLCBctffmJmRLTwRyraMqeRytuDxFhzbx3vsB2V0p+yiiD/D
	zygufuknuvcD7VXZvMJrPEJgNnr3HVIqe/TLL0jihx5mkq4UIPk9OqoWs8GYrLVh8GmhqTEQoncjF
	xRUpRSXw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uDOpd-000000005Yi-1tGE;
	Fri, 09 May 2025 16:36:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Include kernel taint value in warning
Date: Fri,  9 May 2025 14:53:21 +0200
Message-ID: <20250509125321.21336-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kernel is already tainted, not all tests yield usable results.
Printing the taint cause might help users tracking down the external
cause.

If a test taints the kernel, the value is stored in rc-failed-tainted
file already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 6a9b518c3aed5..2d2e0ad146c80 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -784,7 +784,7 @@ check_kmemleak()
 
 read kernel_tainted < /proc/sys/kernel/tainted
 if [ "$kernel_tainted" -ne 0 ] ; then
-	msg_warn "kernel is tainted"
+	msg_warn "kernel is tainted ($kernel_tainted)"
 	echo
 fi
 
-- 
2.49.0

