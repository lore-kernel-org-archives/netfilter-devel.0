From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/21] netfilter: update MAINTAINERS
Date: Sun, 12 Feb 2017 20:42:52 +0100
Message-ID: <1486928573-24773-21-git-send-email-pablo@netfilter.org>
References: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1486928573-24773-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It's been a while since Patrick has been suspended as coreteam member [1].
Update this file to remove him.

While at this, remove references to all foo-tables variants, given the
project hosts more than just that, eg. ipset, conntrack, ...

[1] https://marc.info/?l=netfilter-devel&m=146887464512702

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a9368bba9b37..5864bbd99f8f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8579,9 +8579,8 @@ F:	Documentation/networking/s2io.txt
 F:	Documentation/networking/vxge.txt
 F:	drivers/net/ethernet/neterion/
 
-NETFILTER ({IP,IP6,ARP,EB,NF}TABLES)
+NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
-M:	Patrick McHardy <kaber@trash.net>
 M:	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
-- 
2.1.4
