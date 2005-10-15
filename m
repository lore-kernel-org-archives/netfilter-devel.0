From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] use C99 initializer in ip6t_MARK
Date: Sat, 15 Oct 2005 20:22:00 +0900 (JST)
Message-ID: <200510151122.j9FBM12h005637@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct_15_20_22_00_2005_026)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Sat_Oct_15_20_22_00_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald, Now I'm checking the patch of revision support to ip6_tables,
and found that ip6t_MARK cannot be build because of this.

Please apply this patch.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sat_Oct_15_20_22_00_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="08-mark-c99.patch"

[NETFILTER] use C99 initializer in ip6t_MARK

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit bc31e1b2d681728024414bf8c5fbabc447aaaaf9
tree 3e49d6ca7abd35f150eb9b604645615bf5298923
parent 56ff34b05ef4d3961296520d46b2a691f0986e40
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 15 Oct 2005 19:57:58 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 15 Oct 2005 19:57:58 +0900

 net/ipv6/netfilter/ip6t_MARK.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_MARK.c b/net/ipv6/netfilter/ip6t_MARK.c
--- a/net/ipv6/netfilter/ip6t_MARK.c
+++ b/net/ipv6/netfilter/ip6t_MARK.c
@@ -56,8 +56,12 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ip6t_target ip6t_mark_reg
-= { { NULL, NULL }, "MARK", target, checkentry, NULL, THIS_MODULE };
+static struct ip6t_target ip6t_mark_reg = { 
+	.name		= "MARK",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
+};
 
 static int __init init(void)
 {

----Next_Part(Sat_Oct_15_20_22_00_2005_026)----
