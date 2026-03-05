Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746039C632;
	Thu,  5 Mar 2026 12:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713603; cv=none; b=OvYlrdouYBdESYTweR6dSDIYeRfINKOSPQq8zZWWT9cMAENNcfs8TVn/Svi0q6B+JY25uuhZDcSo5HscWnzd+gsTxwEqQmZN/F+gaE63DUBKMGIdL0SIS83ypl2CzxsFaEx/Z503Bd8/otZIjHHqV32x7vKvvIou5nHwBuRFAmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713603; c=relaxed/simple;
	bh=4i+MtDgEJ6L14OkL8OR6KuG4ubR/hfwIN/x052K7+s4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h17dfZjAhEhu+lixRDpgT+sijongyabPd155TN9ZlCJ3vQYU2/EDmHiAR8TGLda9WdJ4bwLX6vRtMExtYkMBlYGmm7+FtachEhnJJ17shuowUwojigPcz8+DPCBFdnzsTUwPc/JHIdlABfSua1Vy1TG/TGvF8rXNV0/OukH7o48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 097206047A; Thu, 05 Mar 2026 13:26:40 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net v2 0/3] netfilter: updates for net
Date: Thu,  5 Mar 2026 13:26:32 +0100
Message-ID: <20260305122635.23525-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ v2: remove patch 1 from series, no other changes ]

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Inseo An reported a bug with the set element handling in nf_tables:
   When set cannot accept more elements, we unlink and immediately free
   an element that was inserted into a public data structure, freeing it
   without waiting for RCU grace period.  Fix this by doing the
   increment earlier and by deferring possible unlink-and-free to the
   existing abort path, which performs the needed synchronize_rcu before
   free.  From Pablo Neira Ayuso. This is an ancient bug, dating back to
   kernel 4.10.

2) syzbot reported WARN_ON() splat in nf_tables that occurs on memory
   allocation failure.  Fix this by a new iterator annotation:
   The affected walker does not need to clone the data structure and
   can just use the live version if no clone exists yet.
   Also from Pablo.  This bug existed since 6.10 days.

3) Ancient forever bug in nft_pipapo data structure:
   The garbage collection logic to remove expired elements is broken.
   We must unlink from data structure and can only hand the freeing
   to call_rcu after the clone/live pointers of the data structures
   have been swapped.  Else, readers can observe the free'd element.
   Reported by Yiming Qian.

Please, pull these changes from:
The following changes since commit b824c3e16c1904bf80df489e293d1e3cbf98896d:

  net: Provide a PREEMPT_RT specific check for netdev_queue::_xmit_lock (2026-03-05 12:14:21 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-03-05

for you to fetch changes up to 9df95785d3d8302f7c066050117b04cd3c2048c2:

  netfilter: nft_set_pipapo: split gc into unlink and reclaim phase (2026-03-05 13:22:37 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-03-05

----------------------------------------------------------------

Florian Westphal (1):
  netfilter: nft_set_pipapo: split gc into unlink and reclaim phase

Pablo Neira Ayuso (2):
  netfilter: nf_tables: unconditionally bump set->nelems before insertion
  netfilter: nf_tables: clone set on flush only

 include/net/netfilter/nf_tables.h |  7 ++++
 net/netfilter/nf_tables_api.c     | 45 ++++++++++++----------
 net/netfilter/nft_set_hash.c      |  1 +
 net/netfilter/nft_set_pipapo.c    | 62 ++++++++++++++++++++++++++-----
 net/netfilter/nft_set_pipapo.h    |  2 +
 net/netfilter/nft_set_rbtree.c    |  8 ++--
 6 files changed, 92 insertions(+), 33 deletions(-)

-- 
2.52.0
