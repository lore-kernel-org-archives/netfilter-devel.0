From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: xt_hashlimit: fix ip6tables dependency
Date: Wed, 31 Jan 2007 01:39:47 +0100
Message-ID: <45BFE553.2070206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000600090909020106020304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------000600090909020106020304
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

while testing similar combinations that lead to the H.323 linker
error, I noticed this problem with xt_hashlimit.

Please also apply to 2.6.20. Thanks.

--------------000600090909020106020304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: xt_hashlimit: fix ip6tables dependency

IP6_NF_IPTABLES=m, CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y results in a
linker error since ipv6_find_hdr is defined in ip6_tables.c. Fix similar
to Adrian Bunk's H.323 conntrack patch: selecting ip6_tables to be build
as module requires hashlimit to be built as module as well.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 25dfa116b43b65d9e3bb5e89d392b6ebd1d00ec7
tree c4fa2b5e88eca77a237ffd3cd37419df45cb6ef7
parent 9c13a2e187957e0656eb458ca1251bd1b79aebaa
author Patrick McHardy <kaber@trash.net> Wed, 31 Jan 2007 01:35:02 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 31 Jan 2007 01:35:02 +0100

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index cd10e44..2a2bcb3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -628,7 +628,7 @@ config NETFILTER_XT_MATCH_TCPMSS
 
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
-	depends on NETFILTER_XTABLES
+	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
 	help
 	  This option adds a `hashlimit' match.
 

--------------000600090909020106020304--
