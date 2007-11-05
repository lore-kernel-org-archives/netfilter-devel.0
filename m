From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] nf_nat_core: fix memset size error
Date: Mon, 05 Nov 2007 09:47:15 +0800
Message-ID: <472E7623.1030707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:53008 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbXKEBtD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:49:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

The size passing to memset is the size of a pointer.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 56e93f6..70e7997 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, void *data)
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
-- 
1.5.3.rc7

