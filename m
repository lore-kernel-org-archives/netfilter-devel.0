From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix iptables ABI breakage on (at least) CRIS
Date: Tue, 16 Jan 2007 15:03:01 +0100
Message-ID: <45ACDB15.60003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="x"
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Fix iptables ABI breakage on (at least) CRIS

With the introduction of x_tables we accidentally broke compatibility
by defining IPT_TABLE_MAXNAMELEN to XT_FUNCTION_MAXNAMELEN instead of
XT_TABLE_MAXNAMELEN, which is two bytes larger.

On most architectures it doesn't really matter since we don't have
any tables with names that long in the kernel and the structure
layout didn't change because of alignment requirements of following
members. On CRIS however (and other architectures that don't align
data) this changed the structure layout and thus broke compatibility
with old iptables binaries.

Changing it back will break compatibility with binaries compiled
against recent kernels again, but since the breakage has only been
there for three releases this seems like the better choice.

Spotted by Jonas Berlin <xkr47@outerspace.dyndns.org>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 192c132da69f6a3f53c8c30e2c45a6b51a7369e0
tree f3cf004fcb6a7752fc51af1fc12fe75301562aeb
parent f8f00b3d4bf918190a6edd5b94bbee452b4f5d64
author Patrick McHardy <kaber@trash.net> Tue, 16 Jan 2007 13:49:34 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 16 Jan 2007 15:02:25 +0100

 include/linux/netfilter_ipv4/ip_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 4f06dad..98d566c 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -28,7 +28,7 @@ #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
 
 #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
-#define IPT_TABLE_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
 #define ipt_match xt_match
 #define ipt_target xt_target
 #define ipt_table xt_table
