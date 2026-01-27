Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8D9276028
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769552226; cv=none; b=KD85VOIsLwjD9jVYBa6FAayh4p3BFhZhw9vFkGFRDiThU/ugU4uXemCYmMtyLmF+xBYJz/xhwOF2OX67fatpIMO64YxhhfjRzGtGeILGoHV0rCqxRqUzn0sgwdwvMAG1eGtGkDt6ncc3ZHQsIm8ND2snz19gnw4CO7aZV1vGl0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769552226; c=relaxed/simple;
	bh=ngibuQx8auydCH6cQE2ag8LRIvGPazARrX5wkncl3QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VKcZ05FV4f0zv4DGUPtTAofKNDYOOVVj7ZmdReqGknkH3Sp316qZzc/nBPbx4drsNwGw8+CVKbL2MIJjiGNyPnLzm1gouDXZsn8qfs9wHpU40DSmHD3/JBP6NIsUkKUCH8GkhY6DCeDWM65SjUnGahiufMHbZx0sDNZbF2lFoT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MRC9FrXL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MRC9FrXL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4S0jY4n8HCMhvx+bR3uhZSoRgcRmu7SnnC2q1gOHjuo=; b=MRC9FrXLWb0RZOmvfkT2y7hug0
	NuR2XvVAmqIoJCr8xl2vT8zXjOxAS7t6X0GSasjcqPgCSnPyVqvnCffNZAkJ4uo8NiF4TrUin8tTI
	UNlhjuELCd3o3Y6UbgU3LpAgnohSrnGTIB9fVRgrl2PEopO5X+chVOYatfH+GQ0txI1HYK+3CTSYh
	GRMjFlpPXM6IKQyK0hRWDxVVFXHktpBs84O67uaj7uF0vTkIEHe3/IhunNCW9jDwqA2ONXQogJncH
	O9S1vGJrG4nRjUrvqom3SuRFDUehzUsADGuoFe9sGGtmZ7DgzPrttzRSGz7dDc6meBsOOR3jf70WU
	MzVlZ3aA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrMs-000000002XG-3Mfj;
	Tue, 27 Jan 2026 23:17:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Makefile: Set PKG_CONFIG_PATH env for 'make check'
Date: Tue, 27 Jan 2026 23:15:58 +0100
Message-ID: <20260127221657.28148-1-phil@nwl.cc>
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

Same situation exists with build test suite. Luckily the PKG_CONFIG_PATH
variable value used to build the project is cached in Makefiles and
Automake supports populating test runners' environment.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Pablo: Could you please confirm this does not break your workflow? I
recall you relied upon build test suite while it never passed for me due
to the reasons described above.
---
 Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.am b/Makefile.am
index b134330d5ca22..18af82a927dc0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -450,6 +450,7 @@ tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
 endif
 
 if !BUILD_DISTCHECK
+AM_TESTS_ENVIRONMENT = PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
 TESTS = tests/build/run-tests.sh \
 	tests/json_echo/run-test.py \
 	tests/monitor/run-tests.sh \
-- 
2.51.0

