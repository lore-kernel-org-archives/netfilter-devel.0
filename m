From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: Fix iptables ABI breakage on (at least) CRIS
Date: Wed, 24 Jan 2007 17:46:39 +0100
Message-ID: <45B78D6F.9000600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020903060405080307000908"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------020903060405080307000908
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch fixes iptables ABI breakage on CRIS introduced in
2.6.16. The patch is already queued in Dave's net-2.6 tree.

Please apply, thanks.


--------------020903060405080307000908
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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
commit f884ee8c1cdf56df0bf03967a45fd8e43db76935
tree bc0c61acf7d5431edd227c9099cab8620fa841f2
parent 3ac4e26b2cc43180661453851174f40a1292da09
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 17:44:40 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 17:44:40 +0100

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

--------------020903060405080307000908--
