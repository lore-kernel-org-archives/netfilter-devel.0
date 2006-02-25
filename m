From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: fix incorrect __exit attribute
Date: Sat, 25 Feb 2006 10:07:21 +0100
Message-ID: <44001E49.1050806@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: H.323 helper: fix incorrect __exit attribute

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 134aa8950c66de37bd644e7826c4d5cb1f1535ab
tree 70502408972e3e9b98fa65ab0b1d4006c240de69
parent 5f82d1be86080aa5981557cf1431b1f96c636c20
author Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:10:10 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:10:10 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 0250055..5692b2f 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -1522,7 +1522,8 @@ static void ip_conntrack_ras_expect(stru
 }
 
 /****************************************************************************/
-static void __exit fini(void)
+/* Not __exit - called from init() */
+static void fini(void)
 {
 	ip_conntrack_helper_unregister(&ip_conntrack_helper_ras);
 	ip_conntrack_helper_unregister(&ip_conntrack_helper_q931);
