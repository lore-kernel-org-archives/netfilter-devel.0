From: Simon Horman <horms@verge.net.au>
Subject: [GIT PULL nf-2.6] IPVS
Date: Wed,  2 Mar 2011 07:59:34 +0900
Message-ID: <1299020375-11362-1-git-send-email-horms@verge.net.au>
Cc: Hans Schillstrom <hans@schillstrom.com>,
	Julian Anastasov <ja@ssi.bg>,
	Patrick McHardy <kaber@trash.net>,
	Simon Horman <horms@verge.net.au>
To: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46114 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab1CAW7m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:59:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

please consider pulling
git://git.kernel.org/pub/scm/linux/kernel/git/horms/lvs-test-2.6.git for-patrick
to get the following change from Julian. Please note that it is an nf-2.6
(that is 2.6.38-rc) change.

Julian Anastasov (1):
      ipvs: fix dst_lock locking on dest update

 net/netfilter/ipvs/ip_vs_ctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
