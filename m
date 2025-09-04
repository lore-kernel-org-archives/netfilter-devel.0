Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D1F22F74F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999504; cv=none; b=Gf7Izegl8u/VzFa5jUnIl84/hODXMzxO5YqXpYj2rK6lQS7jfnTHn0oCZqIg6XMCh+DmHGya0UBe6irK4GxoQZWlGnXBl2NYUtTzGt3yrt1krtkubCBp2Y9rHa4jXopmraKqbDb8IwIT91+euUOvoagE0XIckx4yOq18IdMt8js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999504; c=relaxed/simple;
	bh=Hg+LOHZ74gLkMoqUfRdaWFDXPSvdy97RHEi1xs+DybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0GA01RuFiEGygEki88VciwZO0fFxstyhBh0yvHRcdP17Ew+6rsGOVxPbY5/d3DzQUhmjOG8Bfz+6CEnS8Kg+mEXItKecS/53gQbTut9Ravvim48NIcwPURwDKGJe/mtY7qeE3ljeFDezNi3B9SPLpxB2XyPbYU8z2+3LiNMnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fWDavNqd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fWDavNqd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVVPlpvVG7I142Zvsz8I7IUybPDx3K/ra2rKwSFjETM=; b=fWDavNqd7wr0a3zN/aDfmrnvKL
	Wb+bGjt6TKLAVT1pjoYoaI+GGHCCLdxMrDZi4UYzYBinHG8sE+OxOCdPGMW33ChIecBPtoptYbRwP
	CmzWzis4bi8QBFe6I49Y+PwdS3lUEO448up0cLuprGj1FYV82Kpa7wnpFQpa38MvNjW1NQxf73OIR
	VXn4DTbK1IN7K6o/Uu4QLbwyecYPRvIiI00heSOj+0Z/xZE8nScidaDE+w1Xduu1+tog7+zL9cUFb
	FYrRTDePzyl9/C5XsFqfo5I+fldCYyYq6Sk78MUMRascX2DacSxCTodO2gNJfhjOMSKE12d8PYMk6
	ZLWyEGhQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBpd-000000001om-02sn;
	Thu, 04 Sep 2025 17:25:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 5/8] tests: shell: Skip packetpath/nat_ftp in fake root env
Date: Thu,  4 Sep 2025 17:24:51 +0200
Message-ID: <20250904152454.13054-6-phil@nwl.cc>
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

