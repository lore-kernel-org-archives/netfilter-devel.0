Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CCA190462
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471051; cv=none; b=tzxYne7Y9cbCPnEz5Q/h6sTygwA9Zl7ivhLvb5kekY3J6ABIIpOQYrouhu+U9rYfa1BU7fYXVrIdtpdcZGGrJyPZq8MXXks2LWm/penFw0d8z4q7SerWiZ1sKJaxYJdtdkhIaLXyChFRsXFzlPtgD6nIqlORQhI3bWBNy+L6VZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471051; c=relaxed/simple;
	bh=PP0PdBRRWs2rthGFQ52dz0l0v8tH3F+pTxoTSebv92E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hwz5exsvA3YtspoGbzM3Br2qowDFAfOX/QRyeoC/0CAngWuHxyzHPucI6vdm08+uxFltE6kL5kcyaWIUt2S8U8IxAUzpNzIpE9w7QkAgBJNKLzPJaDflS9WTVUE4HTCdYlcNxtqmunHRnu2dWsrM8y+UK9Gm5mikedvfS1FFtA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hKzSt1sX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hKzSt1sX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SwdhLEobVP70CQnLNoHpdR3nRLwOWjF1nRPEvCt2GP8=; b=hKzSt1sXCYniQCvqiN+gcD0zsZ
	N7IBzmrDBh80obGGD52Kyv8i5ZAUNgGMf6Hvd6K05tv7DUPzmDzqgzn4gFwp/BuNrGf2z8wGEztAm
	mvDNz0fyhNY288DT5M9WHQ5q23yt4uwpWVjzMmbLgt5YkicS5sTI6lo9M2KGOz9k9cfuOz9aY/wwR
	PbveGVu37aRYkmgISGZo9hVYprKjH39ke2HO8QpI8FNXJd64CvLc53LwMMoUr6hdxFw8HCjY+TeMc
	/fTH7bVsJt3sLXOLtrDx32kON0wryxbPYIudwqucYrWdX937mVCfrMouM3AOx/cNnpNycynbYt51P
	wv73ojcQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHC-000000007QQ-2asY
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/5] gitignore: Ignore generated arptables-translate.8
Date: Wed,  9 Oct 2024 12:50:36 +0200
Message-ID: <20241009105037.30114-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is a semantic link created by the build system.

Fixes: 68ff869e94a1b ("Makefile: Install arptables-translate link and man page")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/.gitignore b/iptables/.gitignore
index 8141e34d8b629..b922239279654 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -1,3 +1,4 @@
+/arptables-translate.8
 /ebtables-translate.8
 /ip6tables
 /ip6tables.8
-- 
2.43.0

