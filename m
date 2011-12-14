From: pablo@netfilter.org
Subject: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Wed, 14 Dec 2011 12:00:41 +0100
Message-ID: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net, jengelh@medozas.de,
	thomas.jarosch@intra2net.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1LNLBW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:01:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

We currently have two ways to account traffic in netfilter:

- iptables chain and rule counters:

 # iptables -L -n -v
Chain INPUT (policy DROP 3 packets, 867 bytes)
 pkts bytes target     prot opt in     out     source               destinat
    8  1104 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/

- use flow-based accounting provided by ctnetlink:

 # conntrack -L
tcp      6 431999 ESTABLISHED src=192.168.1.130 dst=212.106.219.168 sport=58

While trying to display real-time accounting statistics, we require
to pool the kernel periodically to obtain this information. This is
OK if the number of flows is relatively low. However, in case that
the number of flows is huge, we can spend a considerable amount of
cycles to iterate over the list of flows that have been obtained.

Moreover, if we want to obtain the sum of the flow accounting results
that match some criteria, we have to iterate over the whole list of
existing flows, look for matchings and update the counters.

This patchset adds the extended accounting infrastructure in
kernel-space. It is composed of one nfnetlink interface that
allows you to create, to update and to retrieve accounting objects.
These objects can be used to account traffic with the flexibility
that iptables rules provide (by means of the new NFACCT target).

Quick example of use:

1) You create the accounting object:

libnetfilter_acct/examples# ./nfacct-add http-traffic

2) Add the iptables rules for traffic you want to account:

# iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
# iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic

3) Retrieve the counters.

libnetfilter_acct/examples# ./nfacct-get
http-traffic = { pkts = 000000000125,   bytes = 000000023162 };

You can also atomically retrieve and zero counters in case that you
want to collect information periodically.

This comes with the user-space libnetfilter_acct library:

http://1984.lsi.us.es/git/libnetfilter_acct/

[Note: The current library API is still quite preliminary. I plan
to heavily rework it]

And the NFACCT extension for user-space iptables is here:

http://1984.lsi.us.es/git/iptables/commit/?id=850104ff9d619a7e0bc561aa16fee838fcd1937c

Comments welcome!

Pablo Neira Ayuso (2):
  netfilter: add extended accounting infrastructure over nfnetlink
  netfilter: xtables: add NFACCT target to support extended accounting

 include/linux/netfilter/Kbuild           |    2 +
 include/linux/netfilter/nfnetlink.h      |    3 +-
 include/linux/netfilter/nfnetlink_acct.h |   34 +++
 include/linux/netfilter/xt_NFACCT.h      |   17 ++
 net/netfilter/Kconfig                    |   18 ++
 net/netfilter/Makefile                   |    2 +
 net/netfilter/nfnetlink_acct.c           |  352 ++++++++++++++++++++++++++++++
 net/netfilter/xt_NFACCT.c                |   78 +++++++
 8 files changed, 505 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 include/linux/netfilter/xt_NFACCT.h
 create mode 100644 net/netfilter/nfnetlink_acct.c
 create mode 100644 net/netfilter/xt_NFACCT.c

-- 
1.7.2.5

