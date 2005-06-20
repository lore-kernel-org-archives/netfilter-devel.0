From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/7]: expectation timeouts are compulsory
Date: Tue, 21 Jun 2005 01:04:19 +0200
Message-ID: <42B74B73.1000802@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

[NETFILTER]: expectation timeouts are compulsory

Since expectation timeouts were made compulsory [1], there is no need to
check for them in ip_conntrack_expect_insert.

[1] https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018143.html

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b4be665b104791bd5605849391ed7123e14edd8
tree 61844cac98e0aedcc42238061e4f0e26a1c31102
parent 6f3e8460b395913e1f156c6e66e818c83afc4d25
author Phil Oester <kernel@linuxace.com> Mon, 20 Jun 2005 18:50:05
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:50:05

 net/ipv4/netfilter/ip_conntrack_core.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -760,15 +760,11 @@ static void ip_conntrack_expect_insert(s
 	exp->master->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 
-	if (exp->master->helper->timeout) {
-		init_timer(&exp->timeout);
-		exp->timeout.data = (unsigned long)exp;
-		exp->timeout.function = expectation_timed_out;
-		exp->timeout.expires
-			= jiffies + exp->master->helper->timeout * HZ;
-		add_timer(&exp->timeout);
-	} else
-		exp->timeout.function = NULL;
+	init_timer(&exp->timeout);
+	exp->timeout.data = (unsigned long)exp;
+	exp->timeout.function = expectation_timed_out;
+	exp->timeout.expires = jiffies + exp->master->helper->timeout * HZ;
+	add_timer(&exp->timeout);
 
 	CONNTRACK_STAT_INC(expect_create);
 }
