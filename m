Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D128C5C0
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064676; cv=none; b=BBZsVZJnNHFt9GWfmZx0THoUTGXLC/p3DohFkxCqHZ1Pj0LR3jRajtEuL7ceBdP1ELoFawj80iArZSF3vDk4VEPDrAYbLk1QsOw54xaTI06EENn+tXp0zABzDFFHexaD368Pl5XNSPMA+JKx2yjPsa63EnF9ADLUgPGUYBZ8phc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064676; c=relaxed/simple;
	bh=h4RLZ3fWIUe7vGIyRNDySRRv1lfqTQjqU7iLHIRKU30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4krRsoOeXUxFHnY+CfMrrXq9r21oysA5bweftB/vMdKbDYiFJfArv74tkoZg6xy6xfvBckutZYoZsCxDAx8AQRQTBYWPO30vyD3T7zeHDp1SUtsaVKkXi/slvXER52pyoRbio0W/Yvi3EBY2jFWlf0DuB5e6r1UeI+0EIcfiUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gt9vfIpT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gt9vfIpT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8n0PD4A7fuIyMORX1SSTfgjamFI8/xbmtb6AwLmH2+g=; b=gt9vfIpTq0GlH0lD3DhAb4IvDM
	nnBWRFVDa3j8YJxSyQpivDLs9pzr+IVi7WqiIOgiAyUj0T674PdE0/CxGv5h+rikHxPlVQ3ZZ5QeU
	xugag4vdugp5pjpAMBKnmQ+H53V7SzWnCi6qBzMO//vCmO78NTbAnn5QRM19IZUgV919SJfubA9OM
	TvPon7mbNwzyUWvMJsZJwZaVZTnNQXT/piLSiPySsI8+50b1RK6ULeml3alN8NNqYm1Ar9yRexju3
	4mkB2x2aWkO314WE2R9hXFfH7ILTd/5xrAFWDcJj/40JTOvFNTi4Hq+sH1+yDTDcl+irrkpW8Y/Vx
	0UPx1RDw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLg-000000005IR-1i4s;
	Fri, 01 Aug 2025 18:11:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Date: Fri,  1 Aug 2025 18:11:05 +0200
Message-ID: <20250801161105.24823-7-phil@nwl.cc>
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

Add the various testsuite runners to TESTS variable and have make call
them with RUN_FULL_TESTSUITE=1 env var.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index ba09e7f0953d5..4fb75b85a5d59 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -409,5 +409,11 @@ EXTRA_DIST += \
 	tests \
 	$(NULL)
 
+AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
+TESTS = tests/json_echo/run-test.py \
+	tests/monitor/run-tests.sh \
+	tests/py/nft-test.py \
+	tests/shell/run-tests.sh
+
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
-- 
2.49.0

