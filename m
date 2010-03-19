From: wzt.wzt@gmail.com
Subject: [PATCH] Netfilter: Remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
Date: Fri, 19 Mar 2010 19:05:52 +0800
Message-ID: <20100319110552.GA3048@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f182.google.com ([209.85.221.182]:61017 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CSDOJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:14:09 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv4/netfilter/nf_nat_h323.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index ee47bf2..bf6a120 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
-- 
1.6.5.3

