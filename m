Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8B3277A2
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482737; cv=none; b=YvqnAYr/fx+/hA5wieKwlypB+ycClJHt/pMa13/2/yXMLyvRzD3TJYsZ9cZjoff1Zzi7l6bVTuBvIdCrfKTBbRhzhtK+DCy+NGNPW22GOUEEM/aOMIyZDHw1Mtgz1Lybc1HvDVi2Edqvrg0irz/EvoI+S9+iXUz8pJ+0trg9gnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482737; c=relaxed/simple;
	bh=Hg+LOHZ74gLkMoqUfRdaWFDXPSvdy97RHEi1xs+DybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+e8SdeDFWCOCM9kIPl2z/MsuMbWFMV7L9dsHqdxkiLsngyseX9aKZXD5HV7v+JJpS709jR8wxgLe29ELVj8XiSP58Xiqgjw6jUzPLW7LpULzlxvoOl0Qj7xfV3mc3dTEXKdqzpk+/0X9CnuSNXOG7/UiKKbp9injS+pqacQp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ig54GuJx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ig54GuJx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVVPlpvVG7I142Zvsz8I7IUybPDx3K/ra2rKwSFjETM=; b=ig54GuJxA2Nt3HmcYIbO1CrWWl
	s3W+nbJu25c38XvuGrzRUvfSSsBsWSllNMc4dK0KqVSqxMn2TymGlv47D0njwWx5eT94CPVv/3/IN
	mcCogOrKi1EbpUCl+39HMphcRz06xWiis7FVd86Ogu0ovlAPqEyl/IQgNcHKqHUjGYRaoI5l6IjcP
	uLRyzKJeyXwdn8uWPKSejc7ioC7j8a16JgJ6QRSKIVGBbH4Z3yA+uiwWccJdshEJW66MzB0oqQLNG
	T/1CbQs43HA91usT953ntIO8EXodTDhjTmkGOxnw1lpkHbgXdRp8QrR9YgI9Xl5tXurCpHu68wDda
	7BqKV6uA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Of-000000001SF-0LfY;
	Fri, 29 Aug 2025 17:52:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 5/7] tests: shell: Skip packetpath/nat_ftp in fake root env
Date: Fri, 29 Aug 2025 17:52:01 +0200
Message-ID: <20250829155203.29000-6-phil@nwl.cc>
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

The script relies upon a call to modprobe which does not work in
fake root environments.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/nat_ftp | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index c2fb3a1c8ebcd..d0faf2ef59c57 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -4,6 +4,9 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
 
+# modprobe does not work in fake root env
+[ "$NFT_TEST_HAS_REALROOT" != y ] && exit 77
+
 . $NFT_TEST_LIBRARY_FILE
 
 cleanup()
-- 
2.51.0

