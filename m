Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8339B1A2C0E
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Mar 2025 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741538521; cv=none; b=DxpwCZ3KqxgWfQJFpmIeSZTwlA4AOZcWt0xZaQ22d5hoON/gjPOk47uQMLflv0hVXh2kwEgBmPR1bZGYKwR/Ti6LSCInFUzZeJTIIEd+h+gKcizR5SBeiPGccRz5mY8OgUMxaObBD1vyKPRRYnSzjW6bfarj5PiWdnpSM+MvjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741538521; c=relaxed/simple;
	bh=EGKFhWt75NWGl6gZMu3kETj2MTb2uDUgVO7URR2jvU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X23UnDcmuylJ6vNiHCpeuizKd9WsejBVDCGrNqWFtRmYtw7vtbiwAM0vfwJzsgtzmyaPjLWS6EWpL/Kyc4SEMneHtpFj7lOzoapGRbD7z4aqWx5Nw5Qjnx+4USlGvvPLpEr28bgPRD5GQniHPjQs3s1Cd3eZ4km99a6ae/sMF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ZqxUEqkC; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZqxUEqkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oW4FK1kpyaVUAbNtcFUDUTwWNpXnf7nFt9T6s8O6BzM=; b=ZqxUEqkCGTDe8SUbCokK1kDAgk
	h10DkpPBsIHzRKer4zVqT3m3rCQOckpcXKVUxLD3MUESanEpZSOk5uXwcMfeULqpVLBr6zbBUDDp7
	VIddLzEKyDOCTjj7af1qLSwCimMdVdihCzo5vLSBQ0B4i91kPmuiiG85Nzxc0b11wx+If1jE2yETk
	D37wMqErQRdqqgO8XpLCWWN23DyNdTyNPG+zuFI4wJE0WGCUPjnAPVcXFwjvoNbTY314NQzxy2Wpn
	Lr7xUBVfhqJ2BMi5C4gMccdHNYmV6toZZ+By7Pv2e912YqW4WkuRm1uLwT0E7uyuTPFcW3lN8UGKl
	66bH9Miw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1trJip-00GJEH-1B;
	Sun, 09 Mar 2025 16:41:51 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/2] A couple of build fixes
Date: Sun,  9 Mar 2025 16:41:26 +0000
Message-ID: <20250309164131.1890225-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The first of these fixes the building of libxt_ACCOUNT.so and libxt_pknock.so.
I sent this once before, at the beginning of December, but it did not elicit a
response.

The second updates Makefile.iptrules.in to clean up some cpp dependency files.

Jeremy Sowden (2):
  build: fix inclusion of Makefile.extra
  build: clean `.*.oo.d` cpp dependency files

 Makefile.iptrules.in           | 2 +-
 extensions/ACCOUNT/Makefile.am | 2 +-
 extensions/Makefile.am         | 2 +-
 extensions/pknock/Makefile.am  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.47.2

