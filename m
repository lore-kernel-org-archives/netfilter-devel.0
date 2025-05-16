Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98FC1D86F2
	for <netfilter-devel@vger.kernel.org>; Fri, 16 May 2025 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419942; cv=none; b=GzH/AGfN3zCLD7AoM0f+PwNpmMAMHFjMfkUqP8iWjdbpimeTKVgLPf1ANAMmEm3aJxz6J5WuS5KEWFKIzEIviFIQYqB3cd2qYmkDY5GxLaOOqsmIwBuMZxBn0b/6pSEjX8xY7Tz+gfb2R+T/alcUifLlVXOlr5/NrVNhcYoPC0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419942; c=relaxed/simple;
	bh=fQZI61XuFFSoCCOcG/I1xFn6wZGuyyeyTUVtPu8bdNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ryyUC/OP/mAInCfNwlPBmG60r6rHWb7rdVIfHZAc3nG0HzViQvQnUMWIp6qPt0gHbVlJbqveHG3q5G2x/lqqlzdnvmzeydYcrbA89dtWE+cb6glA4Pu8ItSXE8tWA+L5P3oMxJEG/hhX1N86bA6Xn7zISE2qySKwZEB0qyreUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZgolhcWp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZgolhcWp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9vk42uYKhi0xBJ1sWeSufaBdICkcx5xGDoD8E6aujK8=; b=ZgolhcWpiQ/OBB04ajbCDRDuNB
	56v9XLQqJLfHfqgJntMe7HgdxsGUOM+UKSEFE8oOUSNZZkdZz0UgTVilIKXR/ugI6fhKOryjHpv0d
	c6ozvyJS6sbPczFwByxXoOvQKQltPSgnv5sGV7aGnVDxwZT+2sxAQiw+NqOIXPrj3dqEAOWOOQ5WZ
	FAFHrSDpTvIVBg/ALhKhiJ7EdWnF+PcF40ZP3MxgDErbsc3LBNkKQWtAkMnZlPtlGfOehGNwDaATy
	JGj0rYrlgCP4OP9n6GmdRj2K56iTho9nn3oFiUhDSNuJJwhsAwuV26bMNYrWgBOX9oCR8xenbneSv
	h5PYlgzA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uFzkZ-000000005jD-0EGo;
	Fri, 16 May 2025 20:25:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/2] Sanitize two error conditions in netlink code
Date: Fri, 16 May 2025 20:25:31 +0200
Message-ID: <20250516182533.2739-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While reviewing netlink deserialization code I noticed these two
potential issues. Submitting them separately from other work as they are
clear fixes (IMO).

Phil Sutter (2):
  netlink: Avoid potential NULL-ptr deref parsing set elem expressions
  netlink: Catch unknown types when deserializing objects

 src/netlink.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.49.0

