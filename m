From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/3]: Fix ECN target TCP marking
Date: Sat, 20 Aug 2005 03:39:55 +0200
Message-ID: <430689EB.10103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080105060807050704080206"
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
--------------080105060807050704080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

these patches fix HW checksum handling in the ECN and TCPMSS target.
The second and third patch don't apply to both net-2.6 and net-2.6.14
because of the nfcache removal and renaming of skb_ip_make_writable,
I've attached one patch for each tree.


--------------080105060807050704080206
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: Fix ECN target TCP marking

An incorrect check made it bail out before doing anything.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a811712706846bff6ad796394ce4aa3abcc657b0
tree 58734ec94ba7a8d54accc29c5d986b242a2b5180
parent 97023145be4225d4b39c73264da10377982205ab
author Patrick McHardy <kaber@trash.net> Fri, 19 Aug 2005 08:51:18 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 19 Aug 2005 08:51:18 +0200

 net/ipv4/netfilter/ipt_ECN.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -60,10 +60,10 @@ set_ect_tcp(struct sk_buff **pskb, const
 	if (!tcph)
 		return 0;
 
-	if (!(einfo->operation & IPT_ECN_OP_SET_ECE
-	      || tcph->ece == einfo->proto.tcp.ece)
-	    && (!(einfo->operation & IPT_ECN_OP_SET_CWR
-		  || tcph->cwr == einfo->proto.tcp.cwr)))
+	if ((!(einfo->operation & IPT_ECN_OP_SET_ECE) ||
+	     tcph->ece == einfo->proto.tcp.ece) &&
+	    ((!(einfo->operation & IPT_ECN_OP_SET_CWR) ||
+	     tcph->cwr == einfo->proto.tcp.cwr)))
 		return 1;
 
 	if (!skb_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))

--------------080105060807050704080206--
