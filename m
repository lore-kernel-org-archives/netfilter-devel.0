Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4081AE853;
	Thu, 26 Sep 2024 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348854; cv=none; b=r9wo8IS3s12flLGnYOfGnjYeM7MTEaSkoUH5HnZruGUjdoUXRMS3jE7R88L88kdNplXvCnwUkbaKUKPOcc8o0jcoU/AHNkbHcQyWDtPDAJZSiQt+lvD/huVE+TkqWykM3vVW8V1pxwPUezLw90bGVr/laPqj+VdbY3heULfVG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348854; c=relaxed/simple;
	bh=zWgRg7nMrwKg/bUXSAkx21ciAIsuGerg3evJtaOEdAo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZwfuJfzA+IOWfMlagzuVTte+ILKV8QgDmAjhz/yw+jWBO2nC0porYE2ftYfSZprFTKWfwys8Zcnl3eI/pjn07TIbHdLv9DAlLsw0dEUKlokdAJzK9ogHpEBvOKblMqKgIuYieAagVeHQ1Fhd4mFMKZOE/G4aLSthoVNyP9IeWr8=
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
Subject: [PATCH net,v2 00/14] Netfilter fixes for net
Date: Thu, 26 Sep 2024 13:07:03 +0200
Message-Id: <20240926110717.102194-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v2: with kdoc fixes per Paolo Abeni.

-o-

The following patchset contains Netfilter fixes for net:

Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
packets to one another, two packets of the same flow in each direction
handled by different CPUs that result in two conntrack objects in NEW
state, where reply packet loses race. Then, patch #3 adds a testcase for
this scenario. Series from Florian Westphal.

1) NAT engine can falsely detect a port collision if it happens to pick
   up a reply packet as NEW rather than ESTABLISHED. Add extra code to
   detect this and suppress port reallocation in this case.

2) To complete the clash resolution in the reply direction, extend conntrack
   logic to detect clashing conntrack in the reply direction to existing entry.

3) Adds a test case.

Then, an assorted list of fixes follow:

4) Add a selftest for tproxy, from Antonio Ojea.

5) Guard ctnetlink_*_size() functions under
   #if defined(CONFIG_NETFILTER_NETLINK_GLUE_CT) || defined(CONFIG_NF_CONNTRACK_EVENTS)
   From Andy Shevchenko.

6) Use -m socket --transparent in iptables tproxy documentation.
   From XIE Zhibang.

7) Call kfree_rcu() when releasing flowtable hooks to address race with
   netlink dump path, from Phil Sutter.

8) Fix compilation warning in nf_reject with CONFIG_BRIDGE_NETFILTER=n.
   From Simon Horman.

9) Guard ctnetlink_label_size() under CONFIG_NF_CONNTRACK_EVENTS which
   is its only user, to address a compilation warning. From Simon Horman.

10) Use rcu-protected list iteration over basechain hooks from netlink
    dump path.

11) Fix memcg for nf_tables, use GFP_KERNEL_ACCOUNT is not complete.

12) Remove old nfqueue conntrack clash resolution. Instead trying to
    use same destination address consistently which requires double DNAT,
    use the existing clash resolution which allows clashing packets
    go through with different destination. Antonio Ojea originally
    reported an issue from the postrouting chain, I proposed a fix:
    https://lore.kernel.org/netfilter-devel/ZuwSwAqKgCB2a51-@calendula/T/
    which he reported it did not work for him.

13) Adds a selftest for patch 12.

14) Fixes ipvs.sh selftest.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-09-26

Thanks.

----------------------------------------------------------------

The following changes since commit 9410645520e9b820069761f3450ef6661418e279:

  Merge tag 'net-next-6.12' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2024-09-16 06:02:27 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-09-26

for you to fetch changes up to fc786304ad9803e8bb86b8599bc64d1c1746c75f:

  selftests: netfilter: Avoid hanging ipvs.sh (2024-09-26 13:03:03 +0200)

----------------------------------------------------------------
netfilter pull request 24-09-26

----------------------------------------------------------------
Andy Shevchenko (1):
      netfilter: ctnetlink: Guard possible unused functions

Antonio Ojea (1):
      selftests: netfilter: nft_tproxy.sh: add tcp tests

Florian Westphal (5):
      netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash
      netfilter: conntrack: add clash resolution for reverse collisions
      selftests: netfilter: add reverse-clash resolution test case
      netfilter: nfnetlink_queue: remove old clash resolution logic
      kselftest: add test for nfqueue induced conntrack race

Pablo Neira Ayuso (2):
      netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path
      netfilter: nf_tables: missing objects with no memcg accounting

Phil Sutter (2):
      netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
      selftests: netfilter: Avoid hanging ipvs.sh

Simon Horman (2):
      netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
      netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS

谢致邦 (XIE Zhibang) (1):
      docs: tproxy: ignore non-transparent sockets in iptables

 Documentation/networking/tproxy.rst                |   2 +-
 include/linux/netfilter.h                          |   4 -
 net/ipv4/netfilter/nf_reject_ipv4.c                |  10 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +-
 net/netfilter/nf_conntrack_core.c                  | 141 +++-----
 net/netfilter/nf_conntrack_netlink.c               |   9 +-
 net/netfilter/nf_nat_core.c                        | 121 ++++++-
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nft_compat.c                         |   6 +-
 net/netfilter/nft_log.c                            |   2 +-
 net/netfilter/nft_meta.c                           |   2 +-
 net/netfilter/nft_numgen.c                         |   2 +-
 net/netfilter/nft_set_pipapo.c                     |  13 +-
 net/netfilter/nft_tunnel.c                         |   5 +-
 tools/testing/selftests/net/netfilter/Makefile     |   4 +
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../net/netfilter/conntrack_reverse_clash.c        | 125 +++++++
 .../net/netfilter/conntrack_reverse_clash.sh       |  51 +++
 tools/testing/selftests/net/netfilter/ipvs.sh      |   2 +-
 tools/testing/selftests/net/netfilter/nft_queue.sh |  92 +++++-
 .../selftests/net/netfilter/nft_tproxy_tcp.sh      | 358 +++++++++++++++++++++
 .../selftests/net/netfilter/nft_tproxy_udp.sh      | 262 +++++++++++++++
 22 files changed, 1091 insertions(+), 132 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
 create mode 100755 tools/testing/selftests/net/netfilter/nft_tproxy_tcp.sh
 create mode 100755 tools/testing/selftests/net/netfilter/nft_tproxy_udp.sh
