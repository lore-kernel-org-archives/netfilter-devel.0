From: Moritz Sichert <moritz+linux@sichert.me>
Subject: [PATCH] netfilter: Remove references to obsolete
 CONFIG_IP_ROUTE_FWMARK
Date: Thu, 30 Jun 2016 11:46:28 +0200
Message-ID: <8e3e7f0b-73f7-3cde-509b-79403503c6de@sichert.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This option was removed in commit 47dcf0cb1005 ("[NET]: Rethink mark field
in struct flowi").

Signed-off-by: Moritz Sichert <moritz+linux@sichert.me>
---
 net/netfilter/Kconfig | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 95e757c..9266cee 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -609,9 +609,8 @@ config NETFILTER_XT_MARK
 	The target allows you to create rules in the "mangle" table which alter
 	the netfilter mark (nfmark) field associated with the packet.
 
-	Prior to routing, the nfmark can influence the routing method (see
-	"Use netfilter MARK value as routing key") and can also be used by
-	other subsystems to change their behavior.
+	Prior to routing, the nfmark can influence the routing method and can
+	also be used by other subsystems to change their behavior.
 
 config NETFILTER_XT_CONNMARK
 	tristate 'ctmark target and match support'
@@ -753,9 +752,8 @@ config NETFILTER_XT_TARGET_HMARK
 
 	The target allows you to create rules in the "raw" and "mangle" tables
 	which set the skbuff mark by means of hash calculation within a given
-	range. The nfmark can influence the routing method (see "Use netfilter
-	MARK value as routing key") and can also be used by other subsystems to
-	change their behaviour.
+	range. The nfmark can influence the routing method and can also be used
+	by other subsystems to change their behaviour.
 
 	To compile it as a module, choose M here. If unsure, say N.
 
-- 
2.9.0
