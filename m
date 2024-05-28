Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA99A8F49;
	Tue, 28 May 2024 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936930; cv=none; b=D3LUFv30YM9Q7nY3vp3s5hkv5EE2RGWq17+bXqqSz6ppnmzyxGSVEkWBqIgc4ay+h4RsdSmyVF16rKAHDjn8EvEfjrb+Iw4xcqkbUb9oOeruSmrIpcj/jhYbhMppnG96aNk0RVNj4JAJLBsCuxfL5c5T5c4pWA328RuEOSOCXGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936930; c=relaxed/simple;
	bh=f7NcCWVoW/042CNhA7DgggRDBuBV1seISr10Qu1IlHc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jXrJKAaLj0h8DDZsqbo/50WaLQi12/dTdA27FiIVktkQ+N90R7zPGZFeuV4Fw3oD3qgBUc6KboaF1VbOw0FiJJURpScNJ++n0WIrsR4iMdhaDdD7mj4cNkOzqR6LTuHfw1OWWa5TNXiviJU0/AQWsfwUUY+PYGbJtVtof+dtTPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 0/6,v3] Netfilter fixes for net
Date: Wed, 29 May 2024 00:55:13 +0200
Message-Id: <20240528225519.1155786-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: fixes checkpatch warning in 4/6 on use of space instead of indentation.

-o-

Hi,

The following patchset contains Netfilter fixes for net:

Patch #1 syzbot reports that nf_reinject() could be called without
         rcu_read_lock() when flushing pending packets at nfnetlink
         queue removal, from Eric Dumazet.

Patch #2 flushes ipset list:set when canceling garbage collection to
         reference to other lists to fix a race, from Jozsef Kadlecsik.

Patch #3 restores q-in-q matching with nft_payload by reverting
         f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support").

Patch #4 fixes vlan mangling in skbuff when vlan offload is present
         in skbuff, without this patch nft_payload corrupts packets
         in this case.

Patch #5 fixes possible nul-deref in tproxy no IP address is found in
         netdevice, reported by syzbot and patch from Florian Westphal.

Patch #6 removes a superfluous restriction which prevents loose fib
         lookups from input and forward hooks, from Eric Garver.

My assessment is that patches #1, #2 and #5 address possible kernel
crash, anything else in this batch fixes broken features.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-05-29

Thanks.

----------------------------------------------------------------

The following changes since commit 4b377b4868ef17b040065bd468668c707d2477a5:

  kprobe/ftrace: fix build error due to bad function definition (2024-05-17 19:17:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-05-29

for you to fetch changes up to e8ded22ef0f4831279c363c264cd41cd9d59ca9e:

  netfilter: nft_fib: allow from forward/input without iif selector (2024-05-29 00:37:51 +0200)

----------------------------------------------------------------
netfilter pull request 24-05-29

----------------------------------------------------------------
Alexander Maltsev (1):
      netfilter: ipset: Add list flush to cancel_gc

Eric Dumazet (1):
      netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Eric Garver (1):
      netfilter: nft_fib: allow from forward/input without iif selector

Florian Westphal (1):
      netfilter: tproxy: bail out if IP has been disabled on the device

Pablo Neira Ayuso (2):
      netfilter: nft_payload: restore vlan q-in-q match support
      netfilter: nft_payload: skbuff vlan metadata mangle support

 net/ipv4/netfilter/nf_tproxy_ipv4.c   |  2 +
 net/netfilter/ipset/ip_set_list_set.c |  3 ++
 net/netfilter/nfnetlink_queue.c       |  2 +
 net/netfilter/nft_fib.c               |  8 ++-
 net/netfilter/nft_payload.c           | 95 ++++++++++++++++++++++++++---------
 5 files changed, 82 insertions(+), 28 deletions(-)
