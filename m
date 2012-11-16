From: pablo@netfilter.org
Subject: [PATCH 0/3] [-stable] Netfilter updates for stable 3.0 onwards
Date: Fri, 16 Nov 2012 15:00:11 +0100
Message-ID: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2KPOA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:00:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi!

Please, consider the following Netfilter patches for stable 3.0 and
onwards inclusion.

The selected three patches are:

4a70bbf netfilter: Validate the sequence number of dataless ACK packets as well
64f509c netfilter: Mark SYN/ACK packets as invalid from original direction
[BACKPORT] 38fe36a netfilter: nf_nat: don't check for port change on ICMP tuples

The first two patches can be considered security fixes in the TCP connection
tracking to make harder off-path attacks. For more information you can read:
"Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel.

The latter fixes the re-routing of every ICMP packet going through NAT even
if it is not required, which is an expensive operation. That one has been
backported to 3.0.

Please, cherry-pick them. Thanks!

Jozsef Kadlecsik (2):
  netfilter: Mark SYN/ACK packets as invalid from original direction
  netfilter: Validate the sequence number of dataless ACK packets as well

Ulrich Weber (1):
  netfilter: nf_nat: don't check for port change on ICMP tuples

 net/ipv4/netfilter/nf_nat_standalone.c |    6 ++++--
 net/netfilter/nf_conntrack_proto_tcp.c |   29 ++++++++++-------------------
 2 files changed, 14 insertions(+), 21 deletions(-)

--
1.7.10.4

