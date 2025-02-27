Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB2025D91A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667969; cv=none; b=kePtZ3PFVQe5ZIxV+y98bvPXWJUgYkV/sAwawMMk3+uydWw3E6qLpONXSVTDelRE9CEGuqwdhjMPeq4ZgzFzRLsKnJ/sFLkmjDtsyZTjwaN+7GYI0tawhlpSN+22i3zPDq6/vAJnyQcRuhTuGbySMLIOBkcsJcy1nCecwEua7DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667969; c=relaxed/simple;
	bh=edmA71L70nTsrAT2vbLqLi0pXyUbPnSZ2jAdsFxsLKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I759CbQl2r6BuAvgRtro6Hm4dOZKkPY2JnHpsVpClPWggfLb2XW7oaB/QKG0czC8WQWItiqPh9aeNkIaYkJvsu7rT3ZKTQDlxt/53kKXTvfIgrdfzLKgFK/2bQCI6hxC/yhn76LOfR3VBQLC2yTaTPJDL7l/CYj5MvJCokUkjfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnfFj-0002MD-9H; Thu, 27 Feb 2025 15:52:43 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] add mptcp suboption mnemonics
Date: Thu, 27 Feb 2025 15:52:06 +0100
Message-ID: <20250227145214.27730-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow users to do
  tcp option mptcp subtype mp-capable

instead of having to use the raw values described in rfc8684.

First patch adds this, rest of the patches resolve printing issues
when the mptcp option match is used in sets and concatenations.

Florian Westphal (4):
  tcpopt: add symbol table for mptcp suboptions
  expression: propagate key datatype for anonymous sets
  netlink_delinearize: also consider exthdr type when trimming binops
  expression: expr_build_udata_recurse should recurse

 include/datatype.h                            |  5 +-
 src/expression.c                              | 37 +++++++-
 src/netlink_delinearize.c                     | 10 +-
 src/tcpopt.c                                  | 30 +++++-
 tests/py/any/tcpopt.t                         |  7 +-
 tests/py/any/tcpopt.t.json                    | 94 +++++++++++++++++--
 tests/py/any/tcpopt.t.payload                 | 25 +++--
 .../testcases/sets/dumps/typeof_sets_0.nft    | 19 ++++
 tests/shell/testcases/sets/typeof_sets_0      | 37 ++++++++
 9 files changed, 245 insertions(+), 19 deletions(-)

-- 
2.45.3

