From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/8]: pptp helper: use locked variants of
 ip_conntrack_find_* functions
Date: Fri, 16 Sep 2005 00:44:48 +0200
Message-ID: <4329F960.3060006@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="04.diff"
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

[NETFILTER]: pptp helper: use locked variants of ip_conntrack_find_* functions

ip_conntrack_lock is not held while the helper is running so it needs
to use the locked variants of __ip_conntrack_expect_find and
__ip_conntrack_find.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f406547e6d2cee9aad722ef4cc48fd14c89ddf08
tree 1c3b6a32ab742bb76b90c8eb5c17529933ec0577
parent 1305f20c8446e6e944924a93eaf90e1896abf788
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:14:31 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 23:14:31 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    7 ++++---
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -124,7 +124,7 @@ static void pptp_expectfn(struct ip_conn
 		DEBUGP("trying to unexpect other dir: ");
 		DUMP_TUPLE(&inv_t);
 	
-		exp_other = __ip_conntrack_expect_find(&inv_t);
+		exp_other = ip_conntrack_expect_find(&inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			DEBUGP("found\n");
@@ -147,7 +147,7 @@ static int timeout_ct_or_exp(const struc
 	DEBUGP("trying to timeout ct or exp for tuple ");
 	DUMP_TUPLE(t);
 
-	h = __ip_conntrack_find(t, NULL);
+	h = ip_conntrack_find_get(t, NULL);
 	if (h)  {
 		struct ip_conntrack *sibling = tuplehash_to_ctrack(h);
 		DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
@@ -155,9 +155,10 @@ static int timeout_ct_or_exp(const struc
 		sibling->proto.gre.stream_timeout = 0;
 		/* refresh_acct will not modify counters if skb == NULL */
 		ip_ct_refresh_acct(sibling, 0, NULL, 0);
+		ip_conntrack_put(sibling);
 		return 1;
 	} else {
-		exp = __ip_conntrack_expect_find(t);
+		exp = ip_conntrack_expect_find(t);
 		if (exp) {
 			DEBUGP("unexpect_related of expect %p\n", exp);
 			ip_conntrack_unexpect_related(exp);
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -101,7 +101,7 @@ static void pptp_nat_expected(struct ip_
 
 	DEBUGP("trying to unexpect other dir: ");
 	DUMP_TUPLE(&t);
-	other_exp = __ip_conntrack_expect_find(&t);
+	other_exp = ip_conntrack_expect_find(&t);
 	if (other_exp) {
 		ip_conntrack_unexpect_related(other_exp);
 		ip_conntrack_expect_put(other_exp);
