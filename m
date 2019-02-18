From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] Netfilter/IPVS fixes for net
Date: Tue, 19 Feb 2019 00:08:21 +0100
Message-ID: <20190218230823.8114-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for net:

1) Follow up patch to fix a compilation warning in a recent IPVS fix:
   098e13f5b21d ("ipvs: fix dependency on nf_defrag_ipv6").

2) Bogus ENOENT error on flush after rule deletion in the same batch,
   reported by Phil Sutter.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit f9bcc9f3ee4fbbe8f11dfec76745476f5780517e:

  net: ethernet: freescale: set FEC ethtool regs version (2019-02-14 12:45:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to c93a49b9769e435990c82297aa0baa31e1538790:

  ipvs: fix warning on unused variable (2019-02-16 10:41:42 +0100)

----------------------------------------------------------------
Andrea Claudi (1):
      ipvs: fix warning on unused variable

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix flush after rule deletion in the same batch

 net/netfilter/ipvs/ip_vs_ctl.c | 3 ++-
 net/netfilter/nf_tables_api.c  | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)
