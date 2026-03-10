Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADFA39BFF7;
	Tue, 10 Mar 2026 13:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148861; cv=none; b=oSxDvPkIVqXG26JLPTqkA1hAmnZtxuFBEoYo+QfzKvXgWuWKa9lsN1Eu1CIrA6S4c3m5wEA98AikueaOwCXEQMLEnVn4d7wti1uMtwsuLZPUipy0WsZbSzgy7Amxa2FluQ6nuMWOxkq6FpCTV929OoI7a0WJ9Fm90O5ZUo7fjak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148861; c=relaxed/simple;
	bh=E0GcpSDCh8vyCSHbkioU8U/rpLb/yr6t5ujlj0dWZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QBeib8HsYkFsIYGHMUby7CzBkMn7WL46PnOBX2AL6SwHYnbG5MZmQGQfJNBDAnbusWxENo9aVwBwunwqjtxKawGv6fXKmQ8P9ZBs+vemqLf9ZQ2xXofpOzcnUsx+QqAyaeaNmPj4Ub28wlllWk6r2fb7LyfNjzGWBsq1dDoyJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BE9876052A; Tue, 10 Mar 2026 14:20:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net v2 0/7] netfilter: updates for net
Date: Tue, 10 Mar 2026 14:20:42 +0100
Message-ID: <20260310132050.630-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following patchset contains Netfilter fixes for *net*:

Change since v1: drop patches 7-9 (ctnetlink expectation handling):
Expectation infra in conntrack has design issues wrt. rcu
lifetime guarantees.  No ETA on a new iteration at ths time.
There are no other changes.

Due to large volume of backlogged patches its unlikely I will make the
2nd planned PR this week, so several legit fixes will be pushed back to
next week.  Sorry for the inconvenience but I am out of ideas and
alternatives.

1) syzbot managed to add/remove devices to a flowtable, due to a bug in
   the flowtable netdevice notifier this gets us a double-add and
   eventually UaF when device is removed again (we only expect one
   entry, duplicate remains past net_device end-of-life).
   From Phil Sutter, bug added in 6.16.

2) Yiming Qian reports another nf_tables transaction handling bug:
   in some cases error unwind misses to undo certain set elements,
   resulting in refcount underflow and use-after-free, bug added in 6.4.

3) Jenny Guanni Qu found out-of-bounds read in pipapo set type.
   While the value is never used, it still rightfully triggers KASAN
   splats.  Bug exists since this set type was added in 5.6.

4) a few x_tables modules contain copypastry tcp option parsing code which
    can read 1 byte past the option area.  This bug is ancient, fix from
    David Dull.

5) nfnetlink_queue leaks kernel memory if userspace provides bad
   NFQA_VLAN/NFQA_L2HDR attributes.  From Hyunwoo Kim, bug stems from
   from 4.7 days.

6) nfnetlink_cthelper has incorrect loop restart logic which may result
   in reading one pointer past end of array. From 3.6 days, fix also from
   Hyunwoo Kim.

7) xt_IDLETIMER v0 extension must reject working with timers added
   by revision v1, else we get list corruption. Bug added in v5.7.
   From Yifan Wu, Juefei Pu and Yuan Tan via Xin Lu.

Please, pull these changes from:
The following changes since commit 6f1a9140ecda3baba3d945b9a6155af4268aafc4:

  net: add xmit recursion limit to tunnel xmit functions (2026-03-10 13:30:30 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-03-10

for you to fetch changes up to 329f0b9b48ee6ab59d1ab72fef55fe8c6463a6cf:

  netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels (2026-03-10 14:10:43 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-03-10

----------------------------------------------------------------

David Dull (1):
  netfilter: x_tables: guard option walkers against 1-byte tail reads

Florian Westphal (1):
  netfilter: nf_tables: always walk all pending catchall elements

Hyunwoo Kim (2):
  netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path
  netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()

Jenny Guanni Qu (1):
  netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()

Phil Sutter (1):
  netfilter: nf_tables: Fix for duplicate device in netdev hooks

Yuan Tan (1):
  netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels

 net/netfilter/nf_tables_api.c      | 4 +---
 net/netfilter/nfnetlink_cthelper.c | 8 ++++----
 net/netfilter/nfnetlink_queue.c    | 4 +++-
 net/netfilter/nft_chain_filter.c   | 2 +-
 net/netfilter/nft_set_pipapo.c     | 3 ++-
 net/netfilter/xt_IDLETIMER.c       | 6 ++++++
 net/netfilter/xt_dccp.c            | 4 ++--
 net/netfilter/xt_tcpudp.c          | 6 ++++--
 8 files changed, 23 insertions(+), 14 deletions(-)
-- 
2.52.0
