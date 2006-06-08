From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.18 3/3]: hashlimit match: fix random initialization
Date: Thu, 08 Jun 2006 09:12:01 +0200
Message-ID: <4487CDC1.5060806@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: hashlimit match: fix random initialization

hashlimit does:

        if (!ht->rnd)
                get_random_bytes(&ht->rnd, 4);

ignoring that 0 is also a valid random number.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f42a39846047e78d30c913270125bed2e0c5a0da
tree a875d2fb478ecaa405810a020ee4af61fa5c42f1
parent b010cc3184ce7cb65a9865ae52ec2ce6f3fe4c9d
author Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 20:43:40 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 20:43:40 +0200

 net/ipv4/netfilter/ipt_hashlimit.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 85edfb7..92980ab 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -80,6 +80,7 @@ struct ipt_hashlimit_htable {
 	/* used internally */
 	spinlock_t lock;		/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
+	int rnd_initialized;
 	struct timer_list timer;	/* timer for gc */
 	atomic_t count;			/* number entries in table */
 
@@ -134,8 +135,10 @@ __dsthash_alloc_init(struct ipt_hashlimi
 
 	/* initialize hash with random val at the time we allocate
 	 * the first hashtable entry */
-	if (!ht->rnd)
+	if (!ht->rnd_initialized) {
 		get_random_bytes(&ht->rnd, 4);
+		ht->rnd_initialized = 1;
+	}
 
 	if (ht->cfg.max &&
 	    atomic_read(&ht->count) >= ht->cfg.max) {
@@ -214,7 +217,7 @@ static int htable_create(struct ipt_hash
 
 	atomic_set(&hinfo->count, 0);
 	atomic_set(&hinfo->use, 1);
-	hinfo->rnd = 0;
+	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 	hinfo->pde = create_proc_entry(minfo->name, 0, hashlimit_procdir);
 	if (!hinfo->pde) {
