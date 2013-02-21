From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset patches
Date: Thu, 21 Feb 2013 17:45:44 +0100
Message-ID: <1361465146-11861-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:43034 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab3BUQps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:45:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next two patches against your nf tree.
You can pull the changes from

git://blackhole.kfki.hu/nf master

Best regards,
Jozsef

Josh Hunt (1):
  netfilter: ipset: timeout values corrupted on set resize

Jozsef Kadlecsik (1):
  netfilter: ipset: "Directory not empty" error message

 include/linux/netfilter/ipset/ip_set_ahash.h |    4 +++-
 net/netfilter/ipset/ip_set_core.c            |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

