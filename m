Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51702E336F
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034491; cv=none; b=LsMEtE+9rAAU0tULMqZawUrNOQ55ROKhD5Xr5zhFiK8ImQ77g1Re5NKQ9x26fkfgSmXtfVw1ELS6uQYva3IoFl/o9TBUITBMrGhwGiciawfTzAQGs/XVPmlG+K/0a6wAkg7lA4pnnd6H6wyUxT1YAcXAH9a4smTHOY0V5nEm7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034491; c=relaxed/simple;
	bh=JQtqpQB83zHX7btJPq3KvStFlbiubkX/9xNt1ShliYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAgmAfQ2ob01SVagxsbjq5RsQ5xlVi4Z+1X/eq7awtCOtHiafQLFXZVon6q8anO2Co3Lnh3Z/VztoyR//+BKitlE51P7heupOsKRCuCQWO4O2Zoq0Tj39lg8t792sRyHnUVuxiMG9dhG4s6sn0HIzx6QiVqyJI4hRIL63yE62GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 09E2B608B7; Fri, 27 Jun 2025 16:28:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/4] netfilter: conntrack: fix obscure confirmed race
Date: Fri, 27 Jun 2025 16:27:49 +0200
Message-ID: <20250627142758.25664-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We go a crash report pointing at __nf_ct_delete_from_lists.
While I've been unable to reproduce this, there appears to be a race,
IPS_CONFIRMED bit is set too early and can cause datapath or gc worker
to unlink an entry that hasn't been fully initialised.

The last patch is the actual fix, the first 3 patches extend and add
a few more conntrack tests to exercise clash resolution for udp.

Florian Westphal (4):
  selftests: netfilter: conntrack_resize.sh: extend resize test
  selftests: netfilter: add conntrack clash resolution test case
  selftests: netfilter: conntrack_resize.sh: also use udpclash tool
  netfilter: nf_conntrack: fix crash due to removal of uninitialised
    entry

 include/net/netfilter/nf_conntrack.h          |  15 +-
 net/netfilter/nf_conntrack_core.c             |  18 +-
 .../selftests/net/netfilter/.gitignore        |   1 +
 .../testing/selftests/net/netfilter/Makefile  |   3 +
 .../net/netfilter/conntrack_clash.sh          | 175 ++++++++++++++++++
 .../net/netfilter/conntrack_resize.sh         |  97 +++++++++-
 .../selftests/net/netfilter/udpclash.c        | 158 ++++++++++++++++
 7 files changed, 454 insertions(+), 13 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_clash.sh
 create mode 100644 tools/testing/selftests/net/netfilter/udpclash.c

-- 
2.49.0

