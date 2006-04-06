From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: remove changelog
Date: Fri, 07 Apr 2006 01:13:13 +0200
Message-ID: <4435A089.4040602@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000700050900040402090400"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jing Min Zhao <zhaojingmin@hotmail.com>
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
--------------000700050900040402090400
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Since we have the git history now, remove the changelogs from
the H.323 helper.



--------------000700050900040402090400
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: H.323 helper: remove changelog

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4a7986fa34c9eed31b2f7df81a59fe7a282f689d
tree 5df1f9c86ed575131439d866ad240464816024b1
parent f29b83bf3ca68ea545b7cf6d25f0ababe109b8a9
author Patrick McHardy <kaber@trash.net> Fri, 07 Apr 2006 01:04:53 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 07 Apr 2006 01:04:53 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   31 -------------------------
 net/ipv4/netfilter/ip_nat_helper_h323.c       |   18 ---------------
 2 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index dccc6c3..2c2fb70 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -9,37 +9,6 @@
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *
  * For more information, please see http://nath323.sourceforge.net/
- *
- * Changes:
- * 	2006-02-01 - initial version 0.1
- *
- *	2006-02-20 - version 0.2
- *	  1. Changed source format to follow kernel conventions
- *	  2. Deleted some unnecessary structures
- *	  3. Minor fixes
- *
- * 	2006-03-10 - version 0.3
- * 	  1. Added support for multiple TPKTs in one packet (suggested by
- * 	     Patrick McHardy)
- * 	  2. Avoid excessive stack usage (based on Patrick McHardy's patch)
- * 	  3. Added support for non-linear skb (based on Patrick McHardy's patch)
- * 	  4. Fixed missing H.245 module owner (Patrick McHardy)
- * 	  5. Avoid long RAS expectation chains (Patrick McHardy)
- * 	  6. Fixed incorrect __exit attribute (Patrick McHardy)
- * 	  7. Eliminated unnecessary return code
- * 	  8. Fixed incorrect use of NAT data from conntrack code (suggested by
- * 	     Patrick McHardy)
- * 	  9. Fixed TTL calculation error in RCF
- * 	  10. Added TTL support in RRQ
- * 	  11. Better support for separate TPKT header and data
- *
- * 	2006-03-15 - version 0.4
- * 	  1. Added support for T.120 channels
- * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)
- * 	  3. Splitted ASN.1 code and data (suggested by Patrick McHardy)
- * 	  4. Sort ASN.1 data to avoid forwarding declarations (suggested by
- * 	     Patrick McHardy)
- * 	  5. Reset next TPKT data length in get_tpkt_data()
  */
 
 #include <linux/config.h>
diff --git a/net/ipv4/netfilter/ip_nat_helper_h323.c b/net/ipv4/netfilter/ip_nat_helper_h323.c
index 6f19c20..d45663d 100644
--- a/net/ipv4/netfilter/ip_nat_helper_h323.c
+++ b/net/ipv4/netfilter/ip_nat_helper_h323.c
@@ -7,24 +7,6 @@
  *
  * Based on the 'brute force' H.323 NAT module by
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- *
- * Changes:
- *	2006-02-01 - initial version 0.1
- *
- *	2006-02-20 - version 0.2
- *	  1. Changed source format to follow kernel conventions
- *	  2. Deleted some unnecessary structures
- *	  3. Minor fixes
- *
- * 	2006-03-10 - version 0.3
- * 	  1. Added support for multiple TPKTs in one packet (suggested by
- * 	     Patrick McHardy)
- * 	  2. Added support for non-linear skb (based on Patrick McHardy's patch)
- * 	  3. Eliminated unnecessary return code
- *
- * 	2006-03-15 - version 0.4
- * 	  1. Added support for T.120 channels
- * 	  2. Added parameter gkrouted_only (suggested by Patrick McHardy)
  */
 
 #include <linux/module.h>

--------------000700050900040402090400--
