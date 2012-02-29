From: pablo@netfilter.org
Subject: [PATCH 0/7] [RFC] new cttimeout infrastructure
Date: Wed, 29 Feb 2012 03:39:25 +0100
Message-ID: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965501Ab2B2Cjm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:39:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

This patchset adds the cttimeout infrastructure that allows you
to define fine-grain conntrack timeout policies, eg:

.test = {
        .l3proto = 2,
        .l4proto = 6,
        .policy = {
                .SYN_SENT = 100,
                .SYN_RECV = 120,
                .ESTABLISHED = 60,
                .FIN_WAIT = 432000,
                .CLOSE_WAIT = 120,
                .LAST_ACK = 60,
                .TIME_WAIT = 30,
                .CLOSE = 120,
                .SYN_SENT2 = 10,
        },
};

Timeout policies are identify by the name. You can attach the
defined timeout policy to one flow via the CT target.

Previous proposals were not flexible enough to allow this, eg.
http://lwn.net/Articles/260066/

You can find the user-space library:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_cttimeout.git;a=summary

Anytime soon, there will be one command line tool `nfct-timeout'
to allow to define timeout policies.

Pablo Neira Ayuso (7):
  netfilter: nf_ct_udp[lite]: convert UDP[lite] timeouts to array
  netfilter: nf_ct_tcp: move retransmission and unacknowledged timeout to array
  netfilter: nf_ct_gre: add unsigned int array to define timeouts
  netfilter: nf_conntrack: pass timeout array to l4->new and l4->packet
  netfilter: add cttimeout infrastructure for fine timeout tuning
  netfilter: nf_ct_ext: add timeout extension
  netfilter: xt_CT: allow to attach timeout policy + glue code

 include/linux/netfilter/Kbuild                 |    1 +
 include/linux/netfilter/nf_conntrack_tcp.h     |    5 +-
 include/linux/netfilter/nfnetlink.h            |    3 +-
 include/linux/netfilter/nfnetlink_cttimeout.h  |  114 +++++++
 include/linux/netfilter/xt_CT.h                |   12 +
 include/net/netfilter/nf_conntrack_extend.h    |    4 +
 include/net/netfilter/nf_conntrack_l4proto.h   |   19 +-
 include/net/netfilter/nf_conntrack_timeout.h   |   78 +++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   60 ++++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   60 ++++-
 net/netfilter/Kconfig                          |   21 ++
 net/netfilter/Makefile                         |    2 +
 net/netfilter/nf_conntrack_core.c              |   34 ++-
 net/netfilter/nf_conntrack_proto_dccp.c        |   86 +++++-
 net/netfilter/nf_conntrack_proto_generic.c     |   77 ++++-
 net/netfilter/nf_conntrack_proto_gre.c         |   82 +++++-
 net/netfilter/nf_conntrack_proto_sctp.c        |   83 +++++-
 net/netfilter/nf_conntrack_proto_tcp.c         |  168 +++++++++-
 net/netfilter/nf_conntrack_proto_udp.c         |  106 ++++++-
 net/netfilter/nf_conntrack_proto_udplite.c     |  103 ++++++-
 net/netfilter/nf_conntrack_timeout.c           |   60 ++++
 net/netfilter/nfnetlink_cttimeout.c            |  416 ++++++++++++++++++++++++
 net/netfilter/xt_CT.c                          |  220 ++++++++++++-
 23 files changed, 1719 insertions(+), 95 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_cttimeout.h
 create mode 100644 include/net/netfilter/nf_conntrack_timeout.h
 create mode 100644 net/netfilter/nf_conntrack_timeout.c
 create mode 100644 net/netfilter/nfnetlink_cttimeout.c

-- 
1.7.7.3

