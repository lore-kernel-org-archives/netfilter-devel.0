Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D204086C
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709298277; cv=none; b=bc/EwhlxdgIhMQV5t/H0Jn9bk9YF+GJoE0CTkXAN8gn+E1QYHkqEchKLE0AO1vkWBYL+N20Fkke4JPdLxIcihj5o/JJFo5ZpNmeJwoD7nRVVSpbRpOGUVQAz61rUoewXA11APj7DnupLMGm/sho5XwnHH01RfUmg5ZKUiGW7jp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709298277; c=relaxed/simple;
	bh=Mrt4Vo2NAjjDX0n6go+pjUaTYHZWCloB2kQFVZEppz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o96zwT1P2p4ih3M7ROtqSwyI04cFM7GQzzHNFvOngxjKiFkyQlM5bnt64xdbvxZ+oaLgP7j91MMI/A5XRl+wTsdwyvsqQZe5xRpGLdrRYjIk0DWoNns73az2OAG9EyO/Rm0rdk3a0LtskPe1iRtIGyegyrzoOO38GZUVQrG66zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rg2Yz-0002Mi-DR; Fri, 01 Mar 2024 14:04:33 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] parser: allow to define maps that contain ct objects
Date: Fri,  1 Mar 2024 13:59:35 +0100
Message-ID: <20240301125942.20170-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows to store ct object references in maps.
This is a userspace only change.

The only kernel patch required to make the test case work on nf.git
is netfilter: nft_ct: fix l3num expectations with inet pseudo family,
else ct expectations in inet family get rejected.

Note that the second patch is the opposite of what we agreed on at
NFWS, this is also why its both separate and has a very large
wall-of-text commit message.

I did not find a way to solve this without kernel patches in a sane
way.

I could still make it work with the new postfix keywords mentioned
in patch 2 commit message, but it would need a lot of guesswork and
special casing to figure out when to add the "right" postfix keyword.

Please see patch 2 for details and rationale wrt. chosen solution.

Florian Westphal (3):
  parser: allow to define maps that contain timeouts and expectations
  parser: allow to define maps that contain ct helpers
  tests: add test case for named ct objects

 src/parser_bison.y                            | 25 ++++-
 .../testcases/maps/dumps/named_ct_objects.nft | 71 ++++++++++++++
 tests/shell/testcases/maps/named_ct_objects   | 94 +++++++++++++++++++
 3 files changed, 185 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/named_ct_objects.nft
 create mode 100755 tests/shell/testcases/maps/named_ct_objects

-- 
2.43.0

