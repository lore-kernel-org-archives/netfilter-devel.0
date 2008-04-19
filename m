From: Ingo Molnar <mingo@elte.hu>
Subject: [built bug] drivers/net/wireless/iwlwifi/iwl-debugfs.c
Date: Sat, 19 Apr 2008 15:56:02 +0200
Message-ID: <20080419135602.GA2499@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:51060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbYDSN4a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:56:30 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


here's another networking (iwlwifi) related build failure with latest 
-git:

drivers/net/wireless/iwlwifi/iwl-debugfs.c: In function 'iwl_dbgfs_stations_read':
drivers/net/wireless/iwlwifi/iwl-debugfs.c:256: error: 'struct iwl4965_tid_data' has no member named 'agg'

  http://redhat.com/~mingo/misc/config-Sat_Apr_19_14_41_43_CEST_2008.bad

	Ingo
