From: pablo@netfilter.org
Subject: [PATCH 6/7] netfilter: nf_ct_pptp: Fix comment referring to incorrect RFC
Date: Tue, 19 Feb 2013 01:10:50 +0100
Message-ID: <1361232651-5626-7-git-send-email-pablo@netfilter.org>
References: <1361232651-5626-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1361232651-5626-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Reese Moore <ram@vt.edu>

The header of this file cites to "RFFC2673" which is "Binary Labels in the
Domain Name System". It should refer to "RFC 2637" which is "Point-to-Point
Tunneling Protocol (PPTP)". This patch also corrects the typo RFFC.

Signed-off-by: Reese Moore <ram@vt.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index cc7669e..e6678d2 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -14,7 +14,7 @@
  * Limitations:
  * 	 - We blindly assume that control connections are always
  * 	   established in PNS->PAC direction.  This is a violation
- * 	   of RFFC2673
+ *	   of RFC 2637
  * 	 - We can only support one single call within each session
  * TODO:
  *	 - testing of incoming PPTP calls
-- 
1.7.10.4
