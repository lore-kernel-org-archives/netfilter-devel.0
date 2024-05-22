Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3FE19470;
	Wed, 22 May 2024 23:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419650; cv=none; b=TeZfhAFpAWQJb5TF+HZPxiUmD2AuaSTxJZu84xeWHTAhBXADPA+BvYJiNdyLSXi/4SnNPPqHh4JUlS/QqQHUTaNryqwWhVsmCOuABXlFBNkbpQg3Rjn0irBttzJXHDWRq1Dy/HT7RRnBRztX341muaqaYM6EypO0SW+s9h91yoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419650; c=relaxed/simple;
	bh=buIr1GLOTHDs3JnQ54O+t+FAycQe1Z9jdYot7l9lgpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IBcS6mXoYaIkyuGi7FVzN5OWIJk8kw+vkxKHdzAie07q5fORwWVaaBtmZydE0JtUaqkbP1uWuEK58Z6zknITN1xAK0s36iBYEb8JSerswjCaGcHP9vWFZKgcTc1WOOSO5NmaKqvgf9cAnXNoLzGlBuju7vhVXVBWPvhlWCQiKzA=
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
	fw@strlen.de
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Thu, 23 May 2024 01:13:49 +0200
Message-Id: <20240522231355.9802-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-05-23

Thanks.

----------------------------------------------------------------

The following changes since commit 4b377b4868ef17b040065bd468668c707d2477a5:

  kprobe/ftrace: fix build error due to bad function definition (2024-05-17 19:17:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-05-23

for you to fetch changes up to 4878baa295a377fa9116dbeb43208272efc1cb1b:

  netfilter: nft_fib: allow from forward/input without iif selector (2024-05-21 16:37:01 +0200)

----------------------------------------------------------------
netfilter pull request 24-05-23

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
