From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset bugfix patch
Date: Fri, 29 Jun 2012 21:42:27 +0200
Message-ID: <1340998948-29672-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:33936 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab2F2Tma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:42:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

In my previous patchset a bug slipped in by ignoring a special
value of the timeout parameter for the SET target. Please submit
the next patch for the stable branch. Thanks!

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  Timeout fixing bug broke SET target special timeout value, fixed

 net/netfilter/xt_set.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

