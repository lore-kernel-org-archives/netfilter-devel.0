From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: [PATCH] ipt_hashlimit.c: avoid data corruption on checkentry
Date: Mon, 14 Feb 2005 23:04:19 -0500
Message-ID: <421174C3.8030705@cookinglinux.org>
References: <42005218.5000401@cookinglinux.org>
	<20050215005255.GS3829@sunbeam.de.gnumonks.org>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090608010506080600050002"
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050215005255.GS3829@sunbeam.de.gnumonks.org>
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
--------------090608010506080600050002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

*Sorry if you get it twice. Looks like I sent from wrong email.*

Harald Welte wrote:

> Please consider / comment the following (untested) patch.

Yes. That's much less complicated than the other proposed patch.

> 
> Not really sure whether nesting the rwlock inside the mutex is that much
> of a good idea... but as the comment indicates, I think it's the best we
> can get.

I think the best we actually can get, is also replacing those rwlock's with
simple lock's. As you said on IRC, that's a bit overkill.

Incremental (also untested, but compiles) patch to your is attached.




--------------090608010506080600050002
Content-Type: text/x-patch;
	name="linux-2.6.11-rc4-bk2-incremental_get_rid_rwlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="linux-2.6.11-rc4-bk2-incremental_get_rid_rwlock.patch"

#
#Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#
--- d/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 20:48:33.000000000 -0500
+++ e/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-14 21:00:07.000000000 -0500
@@ -97,7 +97,7 @@ struct ipt_hashlimit_htable {
 	struct list_head hash[0];	/* hashtable itself */
 };
 
-static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
+static DECLARE_LOCK(hashlimit_lock);	/* protects htables list */
 static DECLARE_MUTEX(hlimit_mutex);	/* additional checkentry protection */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
@@ -230,9 +230,9 @@ static int htable_create(struct ipt_hash
 	hinfo->timer.function = htable_gc;
 	add_timer(&hinfo->timer);
 
-	WRITE_LOCK(&hashlimit_lock);
+	LOCK_BH(&hashlimit_lock);
 	list_add(&hinfo->list, &hashlimit_htables);
-	WRITE_UNLOCK(&hashlimit_lock);
+	UNLOCK_BH(&hashlimit_lock);
 
 	return 0;
 }
@@ -296,15 +296,15 @@ static struct ipt_hashlimit_htable *htab
 {
 	struct ipt_hashlimit_htable *hinfo;
 
-	READ_LOCK(&hashlimit_lock);
+	LOCK_BH(&hashlimit_lock);
 	list_for_each_entry(hinfo, &hashlimit_htables, list) {
 		if (!strcmp(name, hinfo->pde->name)) {
 			atomic_inc(&hinfo->use);
-			READ_UNLOCK(&hashlimit_lock);
+			UNLOCK_BH(&hashlimit_lock);
 			return hinfo;
 		}
 	}
-	READ_UNLOCK(&hashlimit_lock);
+	UNLOCK_BH(&hashlimit_lock);
 
 	return NULL;
 }
@@ -312,9 +312,9 @@ static struct ipt_hashlimit_htable *htab
 static void htable_put(struct ipt_hashlimit_htable *hinfo)
 {
 	if (atomic_dec_and_test(&hinfo->use)) {
-		WRITE_LOCK(&hashlimit_lock);
+		LOCK_BH(&hashlimit_lock);
 		list_del(&hinfo->list);
-		WRITE_UNLOCK(&hashlimit_lock);
+		UNLOCK_BH(&hashlimit_lock);
 		htable_destroy(hinfo);
 	}
 }



--------------090608010506080600050002--
