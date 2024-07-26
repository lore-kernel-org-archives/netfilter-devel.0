Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321081802E
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 01:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721959196; cv=none; b=Cil4DRdhGCGMM4ZtaIFoosU1sACKTrHNQfxqENgAwxlWDIaY4zs/KzV0w4nfxulz7J5eERkwN/eRzWgb6QYCABVZJSBp3qWtAY34kMtrtjowCwNuD4e8uqtDk7ZD2/4A0YuRBDdos1XulytQiG3yXOSanTR47ynuW1RYBOP1GH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721959196; c=relaxed/simple;
	bh=qWtsLKoz0SPC28GUDv08M16QMmlQZFx6E4bv5jcXkV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZhVHPaf5qddXAUwLOPLsEFDlHPJTcc+4IFdTFPUB70/+jcVIzNWA22rgMgm7n22C2pRNEHLWbiJC/T1BOMAiYz7JgHlqI+XsH8phWVdt6emW6NF1HcIXrq7sDbsQmOslhvVKu4AZ7blqGh6M1Wpg6bWELezOolc8iYlsF+kkClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sXAFM-0004Hr-60; Fri, 26 Jul 2024 03:59:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/4] list hooks refactoring
Date: Fri, 26 Jul 2024 03:58:27 +0200
Message-ID: <20240726015837.14572-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First patch adds a bit more documentation for
"nft list hooks".

2nd patch removes decnet support, this was removed
2 years ago from the kernel.

3rd patch fixes 'nft list hooks device foo' from
listing hooks for 'foo' as 'bridge' family instead of 'netdev'.

Last patch adds support for egress hooks, this was missing
so far.

Florian Westphal (4):
  doc: add documentation about list hooks feature
  src: remove decnet support
  src: mnl: clean up hook listing code
  src: add egress support for 'list hooks'

 Makefile.am                      |   2 +-
 doc/additional-commands.txt      | 115 +++++++++++++++++++++++++++
 doc/nft.txt                      |  63 +--------------
 include/linux/netfilter_decnet.h |  72 -----------------
 src/mnl.c                        | 132 +++++++++----------------------
 5 files changed, 156 insertions(+), 228 deletions(-)
 create mode 100644 doc/additional-commands.txt
 delete mode 100644 include/linux/netfilter_decnet.h

-- 
2.44.2

