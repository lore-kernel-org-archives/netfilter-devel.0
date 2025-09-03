Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58E1547C9
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920190; cv=none; b=XHaLxBQEkJtGTk5C3MPNjeh1gxzAGWNhJoocVln88wfKaZIjl2W5KzFs5aDbOgtL14Q8uHCXbfiHGjEXEQdbAumVO+29GcfaL7IgbRTTusI+8lLhddWaMo2lIjqN5qL7M73HLaVYYU3rXU/o3o1H90ScRXZnlGi47bSadqqkMGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920190; c=relaxed/simple;
	bh=Hg+LOHZ74gLkMoqUfRdaWFDXPSvdy97RHEi1xs+DybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTrkuDLwsER4xijUhDuhT4PTuCiO4Fi6U/bQnneGqjGUblWW7jOdV4e8SXHxDXgHByjoJ0WM3V1iBAOKIBBQm0yWbgr/Pe8jvinoLnUL8ZbJtvjxf+6nJhH3kIzQvcv07KK9Ot6QtL1KGGIcXO3dIp+7PVi66W3YX1QiLuQqgq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XkR3tPCW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XkR3tPCW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bVVPlpvVG7I142Zvsz8I7IUybPDx3K/ra2rKwSFjETM=; b=XkR3tPCWd/X+05Sn+n6i2r2jFm
	zt1M8RujHOBcQNKk6JSA3WnWpLDeC2gor0JlazOEaUjivPl5kIjwM5+YYs/5jBz6sahu1X+XV7tXX
	LbPFUSOQIMuZ14RQ5Bwww7QfALZgloToLZUARX63K1d4/8kb4s1ZyPhApZY21cdb8h0eSrPzCJaMD
	6it7pVnKpVxc4bomrSBaSNck5EYTR28j+vVLgtQQNhwz5Jm4cncOacFZlF8j8VCf7urlMrlbDt8vE
	0rIeNlN1mott47WcXeg/HyxPyTeWUMg7L8xxYn7o6fLlTaQeJcS7HrJ1IF0WRgBLpTWWy8VvKg/05
	plKT6Rsw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCM-0000000080G-0HT8;
	Wed, 03 Sep 2025 19:23:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 09/11] tests: shell: Skip packetpath/nat_ftp in fake root env
Date: Wed,  3 Sep 2025 19:22:57 +0200
Message-ID: <20250903172259.26266-10-phil@nwl.cc>
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

