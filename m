Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345043ECBF7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770302323; cv=none; b=RsKtpoVd/C+An6GisMQ0Vy0u56DiKVqsWlj986UH5T5ynmBFbSEit1rBcfSWkzWNXewS+Y/sckk5irRFv4qX1zvsjP8Lq59rOIZGSqYt11MuY/B2IBw0rj0iG+uQ1quQubv0cim2IxQ/W8O2b3a1y15jRPCsoWKLLlvwutHaYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770302323; c=relaxed/simple;
	bh=70GVbcaqcfL6A4yAmRrY2f7XBSJzndhtUynrT3SoWRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p+VSBHzEcGBJtpMz1gHBUtAYVNmg2YWqBFsICC3WYFIAv0zuL/bJexR+CzQy5DQtUmhCNt5iyokbqSgqy9L1zHkehV9rOr81144QSOPxdPkzDfHVXcP3GYYTjqU6YKtusH/zsipr2bICD0lxmNapek0FzggDiwnjXndHOTgywfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eKVRTh8s; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eKVRTh8s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kqvJZQu8WcnB1BLo0XLQtKuR5oR9QFxi15H60AM6Zos=; b=eKVRTh8snCE+r/1AYoyRVE/mRl
	CIc6umJDY4fnJ8t1iUkVG8CQNDX9LEZ9yY7qKN0odtndMF+zfrbkbrgTw4znp5/Ow+S/fviQwT+P3
	QXhKfTQDjkQOcm/2y2eJuRVbvWZWPoZ+yJ5pImaYNtdUTJkzEN0TrtDN+c7lFpkhJBS+YkhprqRLV
	/uVvZn3yl+Qk7xpfWfko92KpVayngpIHr3jTQthj1LeBmo2OB2Ybot6RCycNIMHsm654YX8Ubyb0n
	pATKAUOm5WlmQQa+DtiE8z/jrdLlE2QFYhbcDVuWMRdc8TEmhEB4GEQNESoM1yMpbFIsPeaEtdJ19
	+5rW1+fQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vo0VF-000000002dz-2cm2;
	Thu, 05 Feb 2026 15:38:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] Makefile: Pass PKG_CONFIG_PATH to internal builds
Date: Thu,  5 Feb 2026 15:38:17 +0100
Message-ID: <20260205143836.20146-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building nftables git HEAD, I use a script which also builds libmnl
and libnftnl in their respective repositories and populates
PKG_CONFIG_PATH variable so nftables is linked against them instead of
host libraries. This is mandatory as host-installed libraries are
chronically outdated and linking against them would fail.

Pass this variable to build test suite as well as the VPATH build
performed by distcheck target based on the presumption that if a custom
PKG_CONFIG_PATH was needed for the main build, these derived builds will
need it as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Cover for distcheck as well
- Adjust patch description accordingly
---
 Makefile.am | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index c60c2e63d5aff..828146bc4fb1a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,7 +23,8 @@ libnftables_LIBVERSION = 2:0:1
 ###############################################################################
 
 ACLOCAL_AMFLAGS = -I m4
-AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
+AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck \
+			       PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
 
 EXTRA_DIST =
 BUILT_SOURCES =
@@ -446,6 +447,7 @@ tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
 endif
 
 if !BUILD_DISTCHECK
+AM_TESTS_ENVIRONMENT = PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
 TESTS = tests/build/run-tests.sh \
 	tests/json_echo/run-test.py \
 	tests/monitor/run-tests.sh \
-- 
2.51.0

