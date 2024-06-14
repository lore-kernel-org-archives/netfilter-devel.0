Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF016B744
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378209; cv=none; b=ONf1W8DErhw8VpDZihk6UVGQEyFxcXAgtNpkslUdDAii4FkCVivA20O1jaETtbpRZpQxze9dXZgcQK1wO8I5l0K0gaQL9NNFh7X1Y0MUwjGs6xt47RvijmRQaoPAos0vvw138+cqg//pV8RU3xVm48g55yV0D1VS7pazMdiAAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378209; c=relaxed/simple;
	bh=jZHBRWyOpX4qMoMD7q1YqnN2UTqvnqMyaNfrr3mum68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EeL8xs853iN5qh2QedRLzkBoOBryYYGvoccSosrIpF0aEp5xeOZkm6H1i9Pnah7gE3my7pHdOWBmpDe4kYlr0mIfgMFjvPKYkEPSIEdy+k61diGEPlYywa2FI/YkNZz4Sg4gjxMC3Ac30710iYb9aQL83HGTEUJ8RgfseceLBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RNART5wa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RNART5wa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wXZ5If9eigqUj4xOx3mKpbbIuA97hWNR82MW3XwrJ1o=; b=RNART5wadhA7GJbVnrqwBPI89A
	VTw4G0jFKxk4q46Yp9XWGyKgRFyB2ZsUNLRZ2Fa45W0+vm+lKPlTJZ92OFSfyybnVdPUKnmLofhO+
	VSjcesHpSydL2sl6WY7JfMY9jsXzErQ2HMfyOu2cTsS1Wr0NYtEdM/XGxzwqbdz0nXZ6ldFGejWlE
	1DC+Qip+dWLkKBgjHaB3X/D0ec8l5EQw5k0WkUlk+z8eNc2xUpEjK+I1sW6VK2iv5MQbwlX0O+aXL
	K3zzIhfDnig63G9YTXPca31MMTiT2qUMYQqCoEH3n6CeThpOiRMmGKdx50M3E1yUAVMi0bhr/7Ikm
	l5XL8mlA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sI8fP-000000007Kq-1dPO;
	Fri, 14 Jun 2024 17:16:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH v2 0/2] netfilter: xt_recent: Allow for larger hitcount values
Date: Fri, 14 Jun 2024 17:16:39 +0200
Message-ID: <20240614151641.28885-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- Do not support insanely large hitcount values to limit the amount of
  storage allocated per entry
- Fix typo in subject of patch 1

Patch 2 lifts the restriction of 255 as max hitcount value by adjusting
XT_RECENT_MAX_NSTAMPS value and increasing required struct field sizes
accordingly.

In struct recent_entry, field 'nstamps' was 16bit in size of unclear
reasons. Patch 1 changes that to match field 'index' providing rationale
why it is sufficient, thus paving the way for keeping both at 16bit (and
avoiding a larger size for 'nstamps').

Phil Sutter (2):
  netfilter: xt_recent: Reduce size of struct recent_entry::nstamps
  netfilter: xt_recent: Lift restrictions on max hitcount value

 net/netfilter/xt_recent.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.43.0

