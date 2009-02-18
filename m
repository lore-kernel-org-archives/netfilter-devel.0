From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [RFT 0/4] Netfilter/iptables performance improvements
Date: Tue, 17 Feb 2009 21:19:06 -0800
Message-ID: <20090218051906.174295181@vyatta.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	Rick Jones <rick.jones2@hp.com>,
	Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:37151 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZBRFed (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:34:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bring together the three performance improvements suggested.
  1) RCU for ip_tables entries
  2) mod_timer_noact for conntrack timer
  3) eliminate tcp_lock

I took the patches for 2 & 3 and made them build and basically work.

This patch set is against Patrick's netfilter next tree since
it is where it should end up.
	git.kernel.org:/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

-- 

