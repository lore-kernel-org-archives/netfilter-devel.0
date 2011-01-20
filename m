From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 0/3][RFC] Relationship between conntrack and firewall rules
Date: Thu, 20 Jan 2011 23:47:04 +0100
Message-ID: <1295563629-14996-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39944 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab1ATWrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

as a firewall admin I would like to see which rules allow
the connections through my firewall.
A relationship between conntrack and firewall rules would be nice.
The next five patches bring this feature to the Linux Netfilter.

First a small example.
Consider this iptables rules:
-A INPUT -m state --state ESTABLISHED,RELATED -j APPROVE --rule-id 1
-A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j APPROVE --rule-id 2
-A INPUT -p tcp --dport 22 -m state --state NEW -j APPROVE --rule-id 3
-A INPUT -p icmp -m state --state NEW -j APPROVE --rule-id 4

The APPROVE target is the same as ACCEPT but it stores also a rule id into 
the connection tracking entry.

"conntrack -L" shows us this two entries:
tcp      6 431999 ESTABLISHED src=192.168.1.1 dst=192.168.1.2 sport=51444 \
	dport=22 src=192.168.1.2 dst=192.168.1.1 sport=22 dport=51444 [ASSURED] \
	mark=0 established=1 related=0 new=3 reply=2 use=1

icmp     1 28 src=192.168.1.2 dst=149.20.20.133 type=8 code=0 id=63239 \
	src=149.20.20.133 dst=192.168.1.2 type=0 code=0 id=63239 mark=0 \
	established=2 related=0 new=2 reply=1 use=1

1. We observe a SSH connection from 192.168.1.1 to 192.168.1.2,
it was allowed by rule 1, 3 and 2. (0 indicates that no rule was involved)
2. An ICMP ping from 192.168.1.2 to 149.20.20.133 which was allowed
by the rules 1 and 2.

The ruleid conntrack extension adds four u_int16_t values.
Thus we can have up to 2^16 rules, I think this is enough
and is not much overhead.
Alternatively we a pointer to a string could also be useful.
Maybe in conjunction with xt_comment...

What do you think?
Any feedback is welcome!

//richard

--
Richard Weinberger (3):
  netfilter: add ruleid extension
  netfilter: add APPROVE target
  netfilter: implement ctnetlink_dump_ruleid()

 include/linux/netfilter/nfnetlink_conntrack.h |    4 +
 include/linux/netfilter/xt_APPROVE.h          |    8 +++
 include/net/netfilter/nf_conntrack_extend.h   |    2 +
 include/net/netfilter/nf_conntrack_ruleid.h   |   25 +++++++
 net/netfilter/Kconfig                         |   12 ++++
 net/netfilter/Makefile                        |    3 +-
 net/netfilter/nf_conntrack_core.c             |    6 ++
 net/netfilter/nf_conntrack_netlink.c          |   23 +++++++-
 net/netfilter/nf_conntrack_ruleid.c           |   44 +++++++++++++
 net/netfilter/xt_APPROVE.c                    |   85 +++++++++++++++++++++++++
 10 files changed, 210 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/xt_APPROVE.h
 create mode 100644 include/net/netfilter/nf_conntrack_ruleid.h
 create mode 100644 net/netfilter/nf_conntrack_ruleid.c
 create mode 100644 net/netfilter/xt_APPROVE.c

