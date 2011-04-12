From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] rework of userspace expectation support
Date: Tue, 12 Apr 2011 23:59:12 +0200
Message-ID: <20110412215458.3145.40830.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45901 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab1DLV7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:59:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patches rework the userspace expectation support
to fix one problematic scenario: if the master conntrack vanishes
while there are still userspace expectations, we hit an oops
in the destroy event path for expectations.

The idea to fix this is to extend the iptables CT target to
explicit allocate the helper extension for conntracks that
are suppose to behave as master for user-space expectations.

In the case of the userspace FTP helper, people would need
to add the following rule:

iptables -A PREROUTING -t raw \
	-p tcp --dport 21 -j CT --userspace-helper

Thus, we can store the list of expectations that belong to
one master, and delete them in case that the master vanishes.

---

Pablo Neira Ayuso (2):
      netfilter: CT: allow to set userspace helper status flag
      netfilter: nf_ct_expect: rework userspace expectation support


 include/linux/netfilter/nf_conntrack_common.h |    4 ++
 include/linux/netfilter/xt_CT.h               |    3 +
 include/net/netfilter/nf_conntrack_expect.h   |    1 
 net/netfilter/nf_conntrack_expect.c           |   63 ++++++++-----------------
 net/netfilter/nf_conntrack_helper.c           |   12 +++++
 net/netfilter/nf_conntrack_netlink.c          |    5 ++
 net/netfilter/xt_CT.c                         |    8 ++-
 7 files changed, 48 insertions(+), 48 deletions(-)

