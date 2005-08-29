From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [PATCH] Re: Errors in ip_set.c, ipt_hashlimit.c
Date: Mon, 29 Aug 2005 16:44:21 +0200
Message-ID: <m2hdd8pzui.fsf_-_@cerbere.dyndns.info>
References: <4312F2A6.7050802@ieee.org>
	<Pine.LNX.4.58.0508291412490.1159@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Nikolai Malykh <nmalykh@ieee.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0508291412490.1159@blackhole.kfki.hu> (Jozsef
	Kadlecsik's message of "Mon, 29 Aug 2005 14:13:34 +0200 (CEST)")
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

--=-=-=

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> writes:

> On Mon, 29 Aug 2005, Nikolai Malykh wrote:
>> there are few errors in ip_set.c and ipt_hashlimit.c
>> In both missing include statement
>> #include <linux/netfilter_ipv4/lockhelp.h>
>> lockhelp.h file missed in 2.6.13 source code tree.
>
> Yes, lockhelp.h was removed from the 2.6.13 tree. Expect the new ipset
> version somewhere in this week.
>
> Best regards,
> Jozsef

Hi Jozsef,
this is the fix for ipset after the 'kill lockhelp.h' patch in upstream.

regards,
Samir Bellabes



--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=ipset_kill_lockhelp.patch

tree 2fbd504d5f2c1e35c2174cc82bb48d62480dba31
parent 0b5a1a5697ad9ad1a0b3db48777c9ddf510de3b9
author Samir Bellabes <sbellabes@mandriva.com> 1121952497 +0200
committer Samir Bellabes <sbellabes@mandriva.com> 1121952497 +0200

[NETFILTER] kill lockhelp.h for ipset

------------------------------------------------------------------------------

 ip_set.c |   83 ++++++++++++++++++++++++++++++---------------------------------
 1 files changed, 40 insertions(+), 43 deletions(-)

------------------------------------------------------------------------------

diff --git a/net/ipv4/netfilter/ip_set.c b/net/ipv4/netfilter/ip_set.c
--- a/net/ipv4/netfilter/ip_set.c
+++ b/net/ipv4/netfilter/ip_set.c
@@ -32,7 +32,7 @@
 
 static struct list_head set_type_list;		/* all registered sets */
 static struct ip_set **ip_set_list;		/* all individual sets */
-static DECLARE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
+static rwlock_t ip_set_lock = RW_LOCK_UNLOCKED;
 static DECLARE_MUTEX(ip_set_app_mutex);		/* serializes user access */
 static ip_set_id_t ip_set_max = CONFIG_IP_NF_SET_MAX;
 static ip_set_id_t ip_set_bindings_hash_size =  CONFIG_IP_NF_SET_HASHSIZE;
@@ -83,7 +83,6 @@ ip_set_find_in_hash(ip_set_id_t id, ip_s
 				% ip_set_bindings_hash_size;
 	struct ip_set_hash *set_hash;
 
-	MUST_BE_READ_LOCKED(&ip_set_lock);
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
 	
@@ -100,7 +99,6 @@ ip_set_find_in_hash(ip_set_id_t id, ip_s
 static inline void 
 __set_hash_del(struct ip_set_hash *set_hash)
 {
-	MUST_BE_WRITE_LOCKED(&ip_set_lock);
 	IP_SET_ASSERT(ip_set_list[set_hash->binding]);	
 
 	__ip_set_put(set_hash->binding);
@@ -117,7 +115,7 @@ ip_set_hash_del(ip_set_id_t id, ip_set_i
 	
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
@@ -126,7 +124,7 @@ ip_set_hash_del(ip_set_id_t id, ip_set_i
 
 	if (set_hash != NULL)
 		__set_hash_del(set_hash);
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return 0;
 }
 
@@ -142,7 +140,7 @@ ip_set_hash_add(ip_set_id_t id, ip_set_i
 	IP_SET_ASSERT(ip_set_list[binding]);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name, 
 	   HIPQUAD(ip), ip_set_list[binding]->name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	if (!set_hash) {
@@ -164,7 +162,7 @@ ip_set_hash_add(ip_set_id_t id, ip_set_i
 	set_hash->binding = binding;
 	__ip_set_get(set_hash->binding);
     unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return ret;
 }
 
@@ -184,7 +182,6 @@ ip_set_hash_add(ip_set_id_t id, ip_set_i
 	ip_set_id_t __key;							\
 	struct ip_set_hash *__set_hash, *__n;					\
 										\
-	MUST_BE_WRITE_LOCKED(&ip_set_lock);					\
 	for (__key = 0; __key < ip_set_bindings_hash_size; __key++) {		\
 		list_for_each_entry_safe(__set_hash, __n, &ip_set_hash[__key], list)\
 			fn(__set_hash , ## args);				\
@@ -207,7 +204,7 @@ ip_set_testip_kernel(ip_set_id_t index,
 	int res, i = 0;
 	
 	IP_SET_ASSERT(flags[i]);
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -218,7 +215,7 @@ ip_set_testip_kernel(ip_set_id_t index,
 	} while (res > 0 
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	return res;
 }
@@ -234,7 +231,7 @@ ip_set_addip_kernel(ip_set_id_t index,
 
 	IP_SET_ASSERT(flags[i]);
    retry:
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -245,7 +242,7 @@ ip_set_addip_kernel(ip_set_id_t index,
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	if (res == -EAGAIN
 	    && set->type->retry
@@ -263,7 +260,7 @@ ip_set_delip_kernel(ip_set_id_t index,
 	int res, i = 0;
 
 	IP_SET_ASSERT(flags[i]);
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -274,7 +271,7 @@ ip_set_delip_kernel(ip_set_id_t index,
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 }
 
 /* Register and deregister settype */
@@ -307,7 +304,7 @@ ip_set_register_set_type(struct ip_set_t
 		return -EINVAL;
 	}
 
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if (find_set_type(set_type->typename)) {
 		/* Duplicate! */
 		ip_set_printk("'%s' already registered!", 
@@ -322,14 +319,14 @@ ip_set_register_set_type(struct ip_set_t
 	list_append(&set_type_list, set_type);
 	DP("'%s' registered.", set_type->typename);
    unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return ret;
 }
 
 void
 ip_set_unregister_set_type(struct ip_set_type *set_type)
 {
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if (!find_set_type(set_type->typename)) {
 		ip_set_printk("'%s' not registered?",
 			      set_type->typename);
@@ -339,7 +336,7 @@ ip_set_unregister_set_type(struct ip_set
 	module_put(THIS_MODULE);
 	DP("'%s' unregistered.", set_type->typename);
    unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 
 }
 
@@ -551,13 +548,13 @@ ip_set_bindip(ip_set_id_t index,
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		/* Sets as binding values are referenced */
 		if (set->binding != IP_SET_INVALID_ID)
 			__ip_set_put(set->binding);
 		set->binding = binding;
 		__ip_set_get(set->binding);
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 
 		return 0;
 	}
@@ -629,15 +626,15 @@ ip_set_unbindip(ip_set_id_t index,
 		/* unbind :all: */
 		if (strcmp(req_bind->binding, IPSET_TOKEN_DEFAULT) == 0) {
 			/* Default binding of sets */
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			FOREACH_SET_DO(__unbind_default);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			return 0;
 		} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 			/* Flush all bindings of all sets*/
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			FOREACH_HASH_RW_DO(__set_hash_del);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			return 0;
 		}
 		DP("unreachable reached!");
@@ -653,19 +650,19 @@ ip_set_unbindip(ip_set_id_t index,
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 			
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		/* Sets in hash values are referenced */
 		__ip_set_put(set->binding);
 		set->binding = IP_SET_INVALID_ID;
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 
 		return 0;
 	} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 		/* Flush all bindings */
 
-		WRITE_LOCK(&ip_set_lock);
+		write_lock_bh(&ip_set_lock);
 		FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
-		WRITE_UNLOCK(&ip_set_lock);
+		write_unlock_bh(&ip_set_lock);
 		return 0;
 	}
 	
@@ -741,10 +738,10 @@ find_set_type_rlock(const char *typename
 {
 	struct ip_set_type *type;
 	
-	READ_LOCK(&ip_set_lock);
+	read_lock_bh(&ip_set_lock);
 	type = find_set_type(typename);
 	if (type == NULL)
-		READ_UNLOCK(&ip_set_lock);
+		read_unlock_bh(&ip_set_lock);
 
 	return type;
 }
@@ -832,11 +829,11 @@ ip_set_create(const char *name,
 		goto out;
 	}
 	if (!try_module_get(set->type->me)) {
-		READ_UNLOCK(&ip_set_lock);
+		read_unlock_bh(&ip_set_lock);
 		res = -EFAULT;
 		goto out;
 	}
-	READ_UNLOCK(&ip_set_lock);
+	read_unlock_bh(&ip_set_lock);
 
 	/*
 	 * Without holding any locks, create private part.
@@ -852,7 +849,7 @@ ip_set_create(const char *name,
 	 * find free id/index and check that it is not already in 
 	 * ip_set_list.
 	 */
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	if ((res = find_free_id(set->name, &index, &id)) != 0) {
 		DP("no free id!");
 		goto cleanup;
@@ -871,11 +868,11 @@ ip_set_create(const char *name,
 	DP("create: '%s' created with index %u, id %u!", set->name, index, id);
 	set->id = id;
 	ip_set_list[index] = set;
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return res;
 	
     cleanup:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	set->type->destroy(set);
     put_out:
 	module_put(set->type->me);
@@ -894,12 +891,12 @@ ip_set_destroy_set(ip_set_id_t index)
 
 	IP_SET_ASSERT(set);
 	DP("set: %s",  set->name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
 	if (set->binding != IP_SET_INVALID_ID)
 		__ip_set_put(set->binding);
 	ip_set_list[index] = NULL;
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 
 	/* Must call it without holding any lock */
 	set->type->destroy(set);
@@ -970,7 +967,7 @@ ip_set_rename(ip_set_id_t index, const c
 	int res = 0;
 
 	DP("set: %s to %s",  set->name, name);
-	WRITE_LOCK(&ip_set_lock);
+	write_lock_bh(&ip_set_lock);
 	for (i = 0; i < ip_set_max; i++) {
 		if (ip_set_list[i] != NULL
 		    && strncmp(ip_set_list[i]->name, 
@@ -982,7 +979,7 @@ ip_set_rename(ip_set_id_t index, const c
 	}
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
     unlock:
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return res;
 }
 
@@ -1004,7 +1001,7 @@ ip_set_swap(ip_set_id_t from_index, ip_s
 		return -ENOEXEC;
 
 	/* No magic here: ref munging protected by the mutex */	
-	WRITE_LOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	strncpy(from_name, from->name, IP_SET_MAXNAMELEN);
 	from_ref = atomic_read(&from->ref);
 
@@ -1016,7 +1013,7 @@ ip_set_swap(ip_set_id_t from_index, ip_s
 	ip_set_list[from_index] = to;
 	ip_set_list[to_index] = from;
 	
-	WRITE_UNLOCK(&ip_set_lock);
+	write_unlock_bh(&ip_set_lock);
 	return 0;
 }
 
@@ -1332,10 +1329,10 @@ static int ip_set_restore(void *data,
 					      hash_save->binding);
 		else {
 			IP_SET_ASSERT(set->binding == IP_SET_INVALID_ID);
-			WRITE_LOCK(&ip_set_lock);
+			write_lock_bh(&ip_set_lock);
 			set->binding = hash_save->binding;
 			__ip_set_get(set->binding);
-			WRITE_UNLOCK(&ip_set_lock);
+			write_unlock_bh(&ip_set_lock);
 			DP("default binding: %u", set->binding);
 		}
 		if (res != 0)

--=-=-=--
