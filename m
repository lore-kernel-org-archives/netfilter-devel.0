From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/39]: xt_limit: don't reset state on unrelated rule
	updates
Date: Wed, 20 Sep 2006 10:24:00 +0200 (MEST)
Message-ID: <20060920082451.14636.99033.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_limit: don't reset state on unrelated rule updates

The limit match reinitializes its state whenever the ruleset changes,
which means it will forget about previously used credits.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9bab1a93f9739bf8346f256181e971dabf0ea775
tree 5880436a577221212da57efd669a2cc6f35f0e69
parent 78cd435225fca1420030a898433ae7eae9ab0cf6
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:15 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:15 +0200

 net/netfilter/xt_limit.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index b9c9ff3..8bfcbdf 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -122,16 +122,16 @@ ipt_limit_checkentry(const char *tablena
 		return 0;
 	}
 
-	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
-	   128. */
-	r->prev = jiffies;
-	r->credit = user2credits(r->avg * r->burst);	 /* Credits full. */
-	r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
-	r->cost = user2credits(r->avg);
-
 	/* For SMP, we only want to use one set of counters. */
 	r->master = r;
-
+	if (r->cost == 0) {
+		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
+		   128. */
+		r->prev = jiffies;
+		r->credit = user2credits(r->avg * r->burst);	 /* Credits full. */
+		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
+		r->cost = user2credits(r->avg);
+	}
 	return 1;
 }
 
