From: pablo@netfilter.org
Subject: [PATCH 0/2] netfilter updates for net tree (3.5-rc2)
Date: Tue, 12 Jun 2012 19:36:01 +0200
Message-ID: <1339522563-9227-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

The following two patches are netfilter fixes for your net tree, they
provide:

* endianess fixes to calm down warnings spotted by the sparse utility for
  xt_HMARK from Hans Schillstrom.

* One fix for h323 conntrack helper from Sanket Shah and Jagdish Motwani.
  The log says it's been me instead because they sent an incomplete patch
  without header, so I had to manually include all the information, but
  forgot to change the GIT_AUTHOR thing.

You can pull these two changes from:

git://1984.lsi.us.es/net master

Thanks!

Hans Schillstrom (1):
  netfilter: xt_HMARK: fix endianness and provide consistent hashing

Pablo Neira Ayuso (1):
  netfilter: nf_ct_h323: fix bug in rtcp natting

 include/linux/netfilter/xt_HMARK.h     |    5 +++
 net/netfilter/nf_conntrack_h323_main.c |    5 +--
 net/netfilter/xt_HMARK.c               |   72 ++++++++++++++++++--------------
 3 files changed, 48 insertions(+), 34 deletions(-)

-- 
1.7.10
