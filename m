From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH] userspace support for IPv6 TProxy
Date: Fri, 28 Aug 2009 07:59:10 +0200
Message-ID: <cover.1251439150.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58470 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890AbZH2PuY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:24 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 45EF413A244
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ Sorry if this reaches you twice, I sent to the wrong address the first time ]

This patchset implements support for the IPv6 TProxy functionality. It also
includes the still missing option to the socket match (--transparent) which
is already present in the kernel but not in the userspace sources.

Balazs Scheidler (2):
  TProxy: added IPv6 support for socket match
  TProxy: added IPv6 support to the TPROXY target

 extensions/libxt_TPROXY.c           |  213 +++++++++++++++++++++++++++++------
 extensions/libxt_socket.c           |  103 ++++++++++++++++--
 extensions/libxt_socket.man         |    6 +-
 include/linux/netfilter/xt_TPROXY.h |   15 ++-
 include/linux/netfilter/xt_socket.h |    8 ++
 5 files changed, 295 insertions(+), 50 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h


