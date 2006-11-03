From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH IPTABLES 1/2]: changes IP6T_SO_GET_REVISION_{MATCH,TARGET}
 to 68,69
Date: Sat, 04 Nov 2006 00:53:32 +0900 (JST)
Message-ID: <200611031553.kA3FrYTx000664@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


These patches are for revision check in ip[6]tables.
The one in this mail changes the definitions of
IP6T_SO_GET_REVISION_{MATCH,TARGET}, the other is
to load ip[6]_tables.ko just before calling getsockopt().

I'll commit them in next week if no objection.

-- Yasuyuki Kozakai


changes IP6T_SO_GET_REVISION_{MATCH,TARGET} to 68,69
66 and 67 is conflicted with IPv6 Advanced API in kernel <= 2.6.18.

---
commit 1d9e63a2ebb1e3ce04773653f6be4adf56dac70a
tree 25e2109a18358b45024ff15c4c06919eec35e541
parent 5caf88f28272f6408754f9eec8205e06cbd69b79
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 03 Nov 2006 23:47:39 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 03 Nov 2006 23:47:39 +0900

 include/ip6tables.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 406f255..8fe7899 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -16,8 +16,8 @@
 #endif
 
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
-#define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 2)
-#define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 3)
+#define IP6T_SO_GET_REVISION_MATCH	68
+#define IP6T_SO_GET_REVISION_TARGET	69
 
 struct ip6t_get_revision
 {
