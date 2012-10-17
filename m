From: pablo@netfilter.org
Subject: [PATCH] Netfilter/IPVS updates for your net tree (3.7)
Date: Wed, 17 Oct 2012 12:38:50 +0200
Message-ID: <1350470334-5742-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46207 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2JQKjL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:39:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

The following patchset contains Netfilter/IPVS updates for your
net tree, they are:

* Fix incorrect hooks for SNAT and DNAT (bug introduced in recent IPv6
  NAT changes), from Elison Niven.

* Fix xt_TEE (got broken with recent rt_gateway semantic change),
  from Eric Dumazet.

* Fix custom conntrack timeout policy attachment for IPv6, from myself.

* Always initialize ip_vs_timeout_user in case that TCP or UDP protocols
  is disabled, from Arnd Bergmann.

Note that I had to pull from your tree to obtain:

(c92b96553a80c1 ipv4: Add FLOWI_FLAG_KNOWN_NH)

which was required for the xt_TEE fix.

You can pull these changes from:

git://1984.lsi.us.es/nf master

Thanks!

Arnd Bergmann (1):
  ipvs: initialize returned data in do_ip_vs_get_ctl

Elison Niven (1):
  netfilter: xt_nat: fix incorrect hooks for SNAT and DNAT

Eric Dumazet (1):
  netfilter: xt_TEE: don't use destination address found in header

Pablo Neira Ayuso (1):
  netfilter: xt_CT: fix timeout setting with IPv6

-- 
1.7.10.4

