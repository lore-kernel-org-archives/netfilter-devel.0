From: kaber@trash.net
Subject: [PATCH 00/01] netfilter: netfilter fixes
Date: Mon, 14 Feb 2011 17:49:11 +0100
Message-ID: <1297702152-509-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56471 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1BNQtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:49:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a single netfilter bugfix for 2.6.38, fixing incorrect
RCU usage in nf_iterate(). Problem noticed by Eric, patch from myself.

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Thanks!
