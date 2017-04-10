From: Simon Horman <horms@verge.net.au>
Subject: [GIT 0/3] Second Round of IPVS Updates for v4.12
Date: Mon, 10 Apr 2017 09:58:32 -0700
Message-ID: <1491843515-1627-1-git-send-email-horms@verge.net.au>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

please consider these clean-ups and enhancements to IPVS for v4.12.

* Removal unused variable
* Use kzalloc where appropriate
* More efficient detection of presence of NAT extension


The following changes since commit 592d42ac7fd36408979e09bf2f170f2595dab7b8:

  Merge branch 'qed-IOV-cleanups' (2017-03-21 19:02:38 -0700)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git ipvs2-for-v4.12

for you to fetch changes up to e24113769960980579610ecfd657bb17f19373a3:

  ipvs: remove unused variable (2017-03-30 14:54:47 +0200)

----------------------------------------------------------------
Arushi Singhal (1):
      ipvs: remove unused variable

Florian Westphal (1):
      netfilter: ipvs: don't check for presence of nat extension

Varsha Rao (1):
      netfilter: ipvs: Replace kzalloc with kcalloc.

 net/netfilter/ipvs/ip_vs_ftp.c  | 7 ++-----
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)
