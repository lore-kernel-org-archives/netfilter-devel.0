From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: make header files usable from userspace
Date: Sun, 28 Aug 2011 16:30:23 +0200
Message-ID: <1314541826-7448-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54440 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1H1Oa3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 10:30:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


While refreshing iptables's header files with new ones from the
kernel, libxt_SET fails to compile because some definitions were
locked away in __KERNEL__ sections when they should not have been.

This should therefore go into the current -rc.
