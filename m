From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/7] net, netfilter refcounter conversions
Date: Wed, 15 Mar 2017 13:10:38 +0200
Message-ID: <1489576245-19472-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, kadlec@blackhole.kfki.hu,
        pablo@netfilter.org, peterz@infradead.org, keescook@chromium.org,
        Elena Reshetova <elena.reshetova@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This series, for the netfilter subsystem, replaces atomic_t reference
counters with the new refcount_t type and API (see include/linux/refcount.h).
By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

Please take the series to your tree if there are no run-time issues.

Elena Reshetova (7):
  net, netfilter: convert ip_vs_conn.refcnt from atomic_t to refcount_t
  net, netfilter: convert ip_vs_dest.refcnt from atomic_t to refcount_t
  net, netfilter: convert ctnl_timeout.refcnt from atomic_t to
    refcount_t
  net, netfilter: convert nf_acct.refcnt from atomic_t to refcount_t
  net, netfilter: convert nf_conntrack_expect.use from atomic_t to
    refcount_t
  net, netfilter: convert nfulnl_instance.use from atomic_t to
    refcount_t
  net, netfilter: convert clusterip_config.refcount and
    clusterip_config.entries from atomic_t to refcount_t

 include/net/ip_vs.h                          | 16 +++++++++-------
 include/net/netfilter/nf_conntrack_expect.h  |  4 +++-
 include/net/netfilter/nf_conntrack_timeout.h |  3 ++-
 net/ipv4/netfilter/ipt_CLUSTERIP.c           | 19 ++++++++++---------
 net/netfilter/ipvs/ip_vs_conn.c              | 24 ++++++++++++------------
 net/netfilter/ipvs/ip_vs_core.c              |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c               | 12 ++++++------
 net/netfilter/ipvs/ip_vs_lblc.c              |  2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c             |  6 +++---
 net/netfilter/ipvs/ip_vs_nq.c                |  2 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c        |  2 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c         |  2 +-
 net/netfilter/ipvs/ip_vs_rr.c                |  2 +-
 net/netfilter/ipvs/ip_vs_sed.c               |  2 +-
 net/netfilter/ipvs/ip_vs_wlc.c               |  2 +-
 net/netfilter/ipvs/ip_vs_wrr.c               |  2 +-
 net/netfilter/nf_conntrack_expect.c          | 10 +++++-----
 net/netfilter/nf_conntrack_netlink.c         |  4 ++--
 net/netfilter/nfnetlink_acct.c               | 16 +++++++++-------
 net/netfilter/nfnetlink_cttimeout.c          | 12 ++++++------
 net/netfilter/nfnetlink_log.c                | 14 ++++++++------
 21 files changed, 85 insertions(+), 75 deletions(-)

-- 
2.7.4
