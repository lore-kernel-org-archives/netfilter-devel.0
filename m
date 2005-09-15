From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/8]: pptp helper: fix expectation leaks
Date: Fri, 16 Sep 2005 00:44:41 +0200
Message-ID: <4329F959.906@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: pptp helper: fix expectation leaks

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 66479fa28dab1e923dd946ae1eafe7cbf89fa9a1
tree 846f0596cdeea1e41696258b182fe86f6730ae03
parent b806b1f4d971bfb3bd348a7d8d9029b6b5c9c23b
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:32:57 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:32:57 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    2 ++
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -129,6 +129,7 @@ static void pptp_expectfn(struct ip_conn
 			/* delete other expectation.  */
 			DEBUGP("found\n");
 			ip_conntrack_unexpect_related(exp_other);
+			ip_conntrack_expect_put(exp_other);
 		} else {
 			DEBUGP("not found\n");
 		}
@@ -160,6 +161,7 @@ static int timeout_ct_or_exp(const struc
 		if (exp) {
 			DEBUGP("unexpect_related of expect %p\n", exp);
 			ip_conntrack_unexpect_related(exp);
+			ip_conntrack_expect_put(exp);
 			return 1;
 		}
 	}
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -104,6 +104,7 @@ static void pptp_nat_expected(struct ip_
 	other_exp = __ip_conntrack_expect_find(&t);
 	if (other_exp) {
 		ip_conntrack_unexpect_related(other_exp);
+		ip_conntrack_expect_put(other_exp);
 		DEBUGP("success\n");
 	} else {
 		DEBUGP("not found!\n");
