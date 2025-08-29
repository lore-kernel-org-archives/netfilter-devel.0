Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48136321453
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477525; cv=none; b=X7h0hfvKL1d6QnwoeFKK27x15yyfvOP2VhrkClv9+uGh++XD5JHfVxZBGSeaX7ZyRa0LyIKZiazYYsC3phwltT+qVTxqbweq2O3PPCCnOv9iK7QV1+VGxEh7EJbCtxWSU4NxIOD/R8v68AMqOUKfwCxnxK4b7BIWcVrE22slG4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477525; c=relaxed/simple;
	bh=u7FYoKzN+VgCxgRLZG8cbFc4tNupVOSStFlMRblx6Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoJ/PYoc33jqpOlzJVX6zFjU3OqX064y9kZgv0ni9Uwdt6Lok6Gwm6XmZrlqv/JCUxcY0HrSM2oH9DaxbhXC4Ly7YbftREAL0zRzaGxOMb9UujuXosedWc5tGOhE9jWul0MUfIUfPRM0jZdjC9z2ShJWFkoa+oG0JKvwnjcl81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QTmmIj4p; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QTmmIj4p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HODFcxTBKvTd60HhlkjrbQq+J1oX8Ho6l7LiWW0SAoQ=; b=QTmmIj4paT0baWugzekj6twlP6
	fRg4mUnehoi8b9HPgt1iytS9XGaLdqbCrZ6Q3aeFsLMFG9SOPUoH0t5zwYuXKEiPucTXZNSsVhr63
	2wh25d+++Ha33ePLOREboUoLdE2yR1flS8eHlLOSGF3lkdPo3nbzvAQ8bmDbIww+caxVOqhjcPn3L
	uMBLDWVcLCQqr15LnOI+cEhyYIx3MjAHtp2jzO6GyH+bYiHkbL8AEHunSFXHfvP58Vmluap15+YFD
	JwsgG80k+U34kUr7JCsYKb2rEhhrhCt3tXeQT49ip/3wAmlG58iAZFuEk02AMHjTqpZhD8CQYX46I
	Jl28EC4Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02b-00000000736-0xjl;
	Fri, 29 Aug 2025 16:25:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/5] tools: gitignore nftables.service file
Date: Fri, 29 Aug 2025 16:25:09 +0200
Message-ID: <20250829142513.4608-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/.gitignore

diff --git a/tools/.gitignore b/tools/.gitignore
new file mode 100644
index 0000000000000..2d06c49835b15
--- /dev/null
+++ b/tools/.gitignore
@@ -0,0 +1 @@
+nftables.service
-- 
2.51.0

