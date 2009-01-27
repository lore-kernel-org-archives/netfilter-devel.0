From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [RFT 0/4] Iptables rwlock elimination
Date: Tue, 27 Jan 2009 15:53:10 -0800
Message-ID: <20090127235310.159946902@vyatta.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These are some experimental patches to eliminate the read/write lock
in the fast path of iptables.  Not a big iptables user myself, so these
more review and testing.

-- 

