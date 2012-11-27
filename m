From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] netfilter: ipset: Increase the number of maximal sets automatically
Date: Tue, 27 Nov 2012 20:58:08 +0100
Message-ID: <1354046289-17547-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:49310 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab2K0T6L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:58:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows the final version of the patch. It passes cleanly

CONFIG_SPARSE_RCU_POINTER=y

make C=2 net/netfilter/ipset/ip_set_core.o

and also the complete ipset testsuite.

You can also pull the patch from here:

	git://blackhole.kfki.hu/nf-next master

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  netfilter: ipset: Increase the number of maximal sets automatically

 net/netfilter/ipset/ip_set_core.c |  243 ++++++++++++++++++++++++-------------
 1 files changed, 160 insertions(+), 83 deletions(-)

