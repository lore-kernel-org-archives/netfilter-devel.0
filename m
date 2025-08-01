Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1727C15A
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064675; cv=none; b=owjfOwmbYv5tFZrFqY4dxQ6TNq/JVS3e7lGJUtJZogM3IpyyxISuVEa8WBaPgg26ENKN4S6R41xTe9988mEpaIGSEbEAnshEpFMarDOY2pfHedYR9phr9tVFcc9fiUdhVEW+MZjjpNu158hVFLwbnsdTJIknB70XWK7Xo5MgUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064675; c=relaxed/simple;
	bh=zjOJv9oblkiQ9SSoHzEmNp+wCxNnc64svt2tC0CcGKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0Ib2Hsc7y8QrRwRXOpJTNZUr6CyynxvNnviRrs2Cdxmq6c21Jiy5LPjOWnceI7JXHwIjJWS8ifXgMT8PPyOUziOUL6QdidlAq0wn93zSR3+jz6ehPp/GW+EuPhihBL/v+yxwVXFz4xM6lYsmwz8oZgBf8nYup/bsi4m8/j0uMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SrGB3Xhn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SrGB3Xhn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Mk0/Q9YN+PmpkmfXD7yxzcWh2BnaxUo1ElJZ66qppo8=; b=SrGB3Xhn4ugA3XL4/HZXqUeqi9
	gkTk3/xQQRa6eGk8UT10PPYMNVugY/A6Ir6sq4jKXyi5GZTdrOs2Y5PGtqudD0i6USklstTgDaJzU
	cM2eHWvQWNYJDWHcHFKEu6rECLYwUuTABeBbT0TOSmJhVbMg6HvyYzcN+JK6ADxrVqbOXrtK2YG9J
	maMnTCJcJsqUbMiCJXfbpq1pkLeSHGQVCU+SeorXLlCDN90r04hD7GRhS4lEDDVXpHUrOu62inJce
	3Of/hryPr3p6rPIx+M1c3+eD9Y0vCfUTuCvGkxp42uwNzvLaNugVK+XF2BhO+AQ1Bw5X8kq2mZEy2
	51oECofA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLe-000000005IC-3kxG;
	Fri, 01 Aug 2025 18:11:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/6] tests: shell: Skip packetpath/nat_ftp in fake root env
Date: Fri,  1 Aug 2025 18:11:04 +0200
Message-ID: <20250801161105.24823-6-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250801161105.24823-1-phil@nwl.cc>
References: <20250801161105.24823-1-phil@nwl.cc>
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
2.49.0

