Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09FA145B1F
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289181; cv=none; b=scyQjZ8jvSs02T80o9XeB2VTwzuqnBjGN56KMVCdETUzNWvCKg+AlobVH2A1/bu1U5zjFvkXnIeYfykcVemFKs6XvbOBHVutDwFHrnCi1o9kUOo49PlL1yOw4dfHNZ3Qdp1TFp0J6P+cABeVYBKiZUb1oVFAKY04sUcz9knLu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289181; c=relaxed/simple;
	bh=qQZjpGYSBJj2HETHcMRnL0Urec3H+JOlnQzeTX+sNII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J2X4KK0qPDgjA53BsBFKueRUnJCRxVtsWClSmRFVLBxZvCbVqGdsi/+ANQ3odTiEADnDqdDiVmN/pinxSid1QL2GFwhqetrialTkw5mMpksVTWr6k8rN0uOloxMKLPPh/mG5nChPWRatIeOLhk1Uc+xqzNeCGT2TYCP5SRWDxKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MZ4Sx+Kp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MZ4Sx+Kp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EhyA+l9q7aMJszRIzxGxSmip/pKBoc1dszkeEXUj/Wo=; b=MZ4Sx+KpaBWx0F3S4tqkrXIHsT
	qYGEWE+DPewsp1jC4xsjSM4sitJAwp9iyccW5UGMM+epaLDQJy2HTGchs3gcUeMu95wtXfsOrHknD
	+rORmNERPPtVyco/fEfdGeKv4+3Fag+KDjUin8Ao9UStcL6IFAukgPVMsHSoX5xNbTZboW1nO8yxr
	CBR+pE30m5DW4edYYHETs1yC90YjAN1T/ass0J7ddBhrhTAbMLX3TLWFZ68eOrkU2zSiowAuC0PkU
	k/j9f9pZd5aSzbvSvvLGA7EkVfu0PlpZaAHGMw418VaRgzGX7rvDQqVedoAGnxw8yFZlunVzxUURJ
	BQJexpTg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHlVT-000000008WF-0E7U;
	Thu, 13 Jun 2024 16:32:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH 0/2] netfilter: xt_recent: Allow for much larger hitcount values
Date: Thu, 13 Jun 2024 16:32:52 +0200
Message-ID: <20240613143254.26622-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 2 lifts the restriction of 255 as max hitcount value by adjusting
XT_RECENT_MAX_NSTAMPS value and increasing required struct field sizes
accordingly.

In struct recent_entry, field 'nstamps' was 16bit in size of unclear
reasons. Patch 1 changes that to match field 'index' providing rationale
why it is sufficient, thus pavin the way for keeping both at 32bit (and
avoiding a larger size for 'nstamps').

Phil Sutter (2):
  netfilter: xt_reent: Reduce size of struct recent_entry::nstamps
  netfilter: xt_recent: Largely lift restrictions on max hitcount value

 net/netfilter/xt_recent.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

-- 
2.43.0

