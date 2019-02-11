From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] Netfilter fixes for net
Date: Mon, 11 Feb 2019 17:53:17 +0100
Message-ID: <20190211165319.17965-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Out-of-bound access to packet data from the snmp nat helper,
   from Jann Horn.

2) ICMP(v6) error packets are set as related traffic by conntrack,
   update protocol number before calling nf_nat_ipv4_manip_pkt()
   to use ICMP(v6) rather than the original protocol number,
   from Florian Westphal.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 31b58ad0c3279817cd246eab27eaf53b626dfcde:

  Merge branch 'r8169-revert-two-commits-due-to-a-regression' (2019-02-10 12:54:49 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8303b7e8f018724a2cd7752eb29c2801fa8c4067:

  netfilter: nat: fix spurious connection timeouts (2019-02-11 17:43:17 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nat: fix spurious connection timeouts

Jann Horn (1):
      netfilter: nf_nat_snmp_basic: add missing length checks in ASN.1 cbs

 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c    | 1 +
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c | 7 ++++++-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c    | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)
