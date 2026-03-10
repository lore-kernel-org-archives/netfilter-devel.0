Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BFF36C0DD
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184283; cv=none; b=M2td+J1vjOss5Yf96VqPxKg6jdYfkG5K1CGJUDB1yX9TjH2KPG/+fwztnzjniaWqdsh1OrILwN1cUvpyY6evvbj17clSu79FvJpZjqUZ/Pz+kZGCNGuuDcI9+D9K7ytPiPocAbi7mpOymcAE7PDeCVDKlS8D79wEBOfjMI6YiQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184283; c=relaxed/simple;
	bh=E73FjQd4n7bEhZ8c8qO3taMftQwBbFzZUM6Rt67/JLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LMYzVRnUP5jE55iyJ6Vd7xz+grFxUiPHdpYvdPFQqM8EVPfizT3BQdoJJW3HIX+TAlZTLmmCJwjzY3OE3XiWIqo3ipMyLHRWTLBzO/ugJFI75zfpL+8lo/Cs/Mb/u3u7gTAWYblAg9OgMzW1S3fHHJ/yb0XpJL6Tww4JI1hSlbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OGxqXa7E; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OGxqXa7E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gkGUk8z0m0P4AmAxuO+d7AIWNXD8sFxrNtClQAROwf8=; b=OGxqXa7Emqx1ItpwN+KZ9vpLrH
	vGbeSLoBzQwybYm3pbNvUIVC70z+86cZGao1S9JswPysJUisrSnrH4I4ucMlDSBzXLAmGlduMyNJz
	HahtW5TRN1u9qAwi+dXpOybDCaWbkI8NNKKCq+y631CBX0Wa2t2KutLrYyoMHfZfRwyDfOXEMv5N1
	BJZnnE0AB77dQorGOUDaH8TiHTIMbYXyWUYRLkojXkIOI5XLdftIIatLytOc59FMUiApxUO4XMutg
	gw0vr0navXQ+/FrGJqCjmDFSwr7bVU54AXLX8PISHzmL9/Hsqp+8GVwiOEQcGgL7DdinoBLX7fLwo
	EOw0wiGg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06ES-000000004qY-42ZH;
	Wed, 11 Mar 2026 00:11:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/5] Enhance cache filter for list commands
Date: Wed, 11 Mar 2026 00:11:10 +0100
Message-ID: <20260310231115.25638-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reducing the amount of data fetched from kernel improves performance
with large rule sets but also reduces adverse side-effects if multiple
versions of nftables access the same kernel rule set. Being able to
ignore parts of the rule set one is not interested in allows for (more or
less) safe coexistence if each tool is operating on the data it created
itself only.

This series reduces caching for list commands which specify a family
and/or table. To help testing this, patch 1 extends netlink debug output
to include chains, flowtables and objects so a test case may check if
they are fetched or not.

The remaining patches actually increase filter use.

Phil Sutter (5):
  cache: Include chains, flowtables and objects in netlink debug output
  cache: Respect family in all list commands
  cache: Relax chain_cache_dump filter application
  cache: Filter for table when listing sets or maps
  cache: Filter for table when listing flowtables

 src/cache.c                                 | 11 ++--
 src/mnl.c                                   | 60 ++++++++++++++++++---
 tests/shell/testcases/listing/cache_filters | 53 ++++++++++++++++++
 3 files changed, 113 insertions(+), 11 deletions(-)
 create mode 100755 tests/shell/testcases/listing/cache_filters

-- 
2.51.0

