From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] Netfilter fixes for net
Date: Fri,  5 Jan 2018 16:08:22 +0100
Message-ID: <20180105150825.18460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for your net tree,
they are:

1) Fix chain filtering when dumping rules via nf_tables_dump_rules().

2) Fix accidental change in NF_CT_STATE_UNTRACKED_BIT through uapi,
   introduced when removing the untracked conntrack object, from
   Florian Westphal.

3) Fix potential nul-dereference when releasing dump filter in
   nf_tables_dump_obj_done(), patch from Hangbin Liu.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit b4681c2829e24943aadd1a7bb3a30d41d0a20050:

  ipv4: Fix use-after-free when flushing FIB tables (2017-12-20 15:12:39 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8bea728dce8972e534e6b99fd550f7b5cc3864e8:

  netfilter: nf_tables: fix potential NULL-ptr deref in nf_tables_dump_obj_done() (2017-12-26 17:16:47 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: uapi: correct UNTRACKED conntrack state bit number

Hangbin Liu (1):
      netfilter: nf_tables: fix potential NULL-ptr deref in nf_tables_dump_obj_done()

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix chain filter in nf_tables_dump_rules()

 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 net/netfilter/nf_tables_api.c                      | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)
