From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix table iteration breakage in {ip6,arp}_tables
Date: Sun, 27 Nov 2005 05:44:06 +0100
Message-ID: <43893996.9050609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090201020000060507010406"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------090201020000060507010406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Another fix for the iptables NUMA optimization.


--------------090201020000060507010406
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix table iteration breakage in {ip6,arp}_tables

Fix breakage from the NUMA optimization, newinfo->entries
is an array now.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f79000270d87887521fdc81a969b84b709722cfc
tree aa36c4d49ae0fa0397402e7111415f5f18d44302
parent 34166a04163effbc5403dc4017ec00429a320013
author Patrick McHardy <kaber@trash.net> Sun, 27 Nov 2005 05:42:05 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 27 Nov 2005 05:42:05 +0100

 net/ipv4/netfilter/arp_tables.c |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 54cdb18..bba1563 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -705,7 +705,7 @@ static int translate_table(const char *n
 	i = 0;
 
 	/* Walk through entries, checking offsets. */
-	ret = ARPT_ENTRY_ITERATE(newinfo->entries, newinfo->size,
+	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
 				 check_entry_size_and_hooks,
 				 newinfo,
 				 entry0,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ac1e112..f7b9317 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -952,7 +952,7 @@ translate_table(const char *name,
 	duprintf("translate_table: size %u\n", newinfo->size);
 	i = 0;
 	/* Walk through entries, checking offsets. */
-	ret = IP6T_ENTRY_ITERATE(newinfo->entries, newinfo->size,
+	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry_size_and_hooks,
 				newinfo,
 				entry0,

--------------090201020000060507010406--
