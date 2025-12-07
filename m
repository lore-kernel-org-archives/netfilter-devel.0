Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551EE2222C4;
	Sun,  7 Dec 2025 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765069803; cv=none; b=Y4dvvafQJkdBjm17/9y3Mbfeua7TLE/hk2ixpT3jUG5Y15nGIZ5rgClwUsr4qdvflc2QxPDxmyEbmB6wgqWjF/HEfD+WldYdqnHk/W+J8+Rf2OXrQSHG/lf1i3NBsbLxbw/6iXmEyQW9JgEFcm43lukYSHOK1A95cSXtrljTreI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765069803; c=relaxed/simple;
	bh=dS6JEZqy6xUdkt/KNxu/ZvPmvZy/gOCCl+3NNubDG8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VrHCXc//HJz5S6cr08Pe1C9PrDqyLzDCXEjPCNijwS4MC3eeEMkIjrhjUsqPvdbPFHcOoHHry8b/7tOa/iFuVaq9S+rMhLSmPgIFjVu8pUlgQc5EnNBNvSko05e/Vlm+p46U18ZOrDe/WmGjG607E71ci4eXD3Gcr5SUlUC2uSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7Yw2E8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7Yw2E8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D69BC4CEF5;
	Sun,  7 Dec 2025 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765069802;
	bh=dS6JEZqy6xUdkt/KNxu/ZvPmvZy/gOCCl+3NNubDG8M=;
	h=From:To:Cc:Subject:Date:From;
	b=e7Yw2E8AxE6UBc1+C3B4yvf8XcVOsQBo90OoIKwWTWvzPnYfEDsBfWKCtfJTPubte
	 ifd8CRZpofIx3pbCYRZRYDBMDociJYlKEk+Hp8yYkUzEYqMdzUPr2gG+G2TVV1X0wb
	 qlIDTmlPIra8LOjr5xtFDbcaj/Isz1ZwaNfBnRsIL7GCI8FIhtJZRgNXrEBVI2Rt84
	 xNb69fHvMf7tdjbaxqIvVCyFt7HrWw014R6/NqDqrq7Ftkulgis+HNXkAY78m3rOPK
	 0YclI5Rg10Ax+U6OMO5sSYNWrmir0oezhQ7tCAwpHoeK+D+aWZMONbna9aHCK5VSkr
	 x4rq9cA6vUfXQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	kuniyu@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/4] inet: frags: flush pending skbs in fqdir_pre_exit()
Date: Sat,  6 Dec 2025 17:09:38 -0800
Message-ID: <20251207010942.1672972-1-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the issue reported by NIPA starting on Sep 18th [1], where
pernet_ops_rwsem is constantly held by a reader, preventing writers
from grabbing it (specifically driver modules from loading).

The fact that reports started around that time seems coincidental.
The issue seems to be skbs queued for defrag preventing conntrack
from exiting.

First patch fixes another theoretical issue, it's mostly a leftover
from an attempt to get rid of the inet_frag_queue refcnt, which
I gave up on (still think it's doable but a bit of a time sink).
Second patch is a minor refactor.

The real fix is in the third patch. It's the simplest fix I can
think of which is to flush the frag queues. Perhaps someone has
a better suggestion?

Last patch adds an explicit warning for conntrack getting stuck,
as this seems like something that can easily happen if bugs sneak in.
The warning will hopefully save us the first 20% of the investigation
effort.

Link: https://lore.kernel.org/20251001082036.0fc51440@kernel.org # [1]

Jakub Kicinski (4):
  inet: frags: avoid theoretical race in ip_frag_reinit()
  inet: frags: add inet_frag_queue_flush()
  inet: frags: flush pending skbs in fqdir_pre_exit()
  netfilter: conntrack: warn when cleanup is stuck

 include/net/inet_frag.h           | 18 ++--------
 include/net/ipv6_frag.h           |  9 +++--
 net/ipv4/inet_fragment.c          | 55 ++++++++++++++++++++++++++++---
 net/ipv4/ip_fragment.c            | 22 +++++--------
 net/netfilter/nf_conntrack_core.c |  3 ++
 5 files changed, 72 insertions(+), 35 deletions(-)

-- 
2.52.0

