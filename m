From: Piotr Chytla <pch@fouk.org>
Subject: ipset problems
Date: Wed, 12 Jan 2005 12:22:20 +0100
Message-ID: <20050112112220.GA19503@fouk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Hi 

IP sets from pom-ng fail to compile with 2.4.28 kernel,
I've gets this :

[..]
gcc -D__KERNEL__ -I/usr/src/linux-2.4.28/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2
+-fno-strict-aliasing -fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2
+-march=i686  -DMODULE -DMODVERSIONS -include
+/usr/src/linux-2.4.28/include/linux/modversions.h  -nostdinc -iwithprefix include
+-DKBUILD_BASENAME=ip_set  -DEXPORT_SYMTAB -c ip_set.c
ip_set.c: In function `ip_set_find_in_hash':
ip_set.c:99: error: structure has no member named `read_locked_map'
ip_set.c:99: error: structure has no member named `write_locked_map'
ip_set.c: In function `__set_hash_del':
ip_set.c:115: error: structure has no member named `write_locked_map'
ip_set.c: In function `ip_set_unbindip':
ip_set.c:644: error: structure has no member named `write_locked_map'
ip_set.c:672: error: structure has no member named `write_locked_map'
ip_set.c: In function `ip_set_destroy_set':
ip_set.c:901: error: structure has no member named `write_locked_map'
make[2]: *** [ip_set.o] Error 1

Jozsef use lock defined as above:

static rwlock_t ip_set_lock = RW_LOCK_UNLOCKED;

but he also use macro from lockhelp.h 

MUST_BE_READ_LOCKED(&ip_set_lock);

I think this conficts with CONFIG_NETFILTER_DEBUG. 

I've attached patch for this, maybe it would be useful for someone.

/pch




 

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ip_set.c.diff"

--- ip_set.c.old	2005-01-10 01:44:25.000000000 +0100
+++ ip_set.c	2005-01-10 12:25:54.000000000 +0100
@@ -32,7 +32,7 @@
 
 static struct list_head set_type_list;		/* all registered sets */
 static struct ip_set **ip_set_list;		/* all individual sets */
-static rwlock_t ip_set_lock = RW_LOCK_UNLOCKED;	/* protects the lists and the hash */
+static DECLARE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
 static DECLARE_MUTEX(ip_set_app_mutex);		/* serializes user access */
 static ip_set_id_t ip_set_max = CONFIG_IP_NF_SET_MAX;
 static ip_set_id_t ip_set_bindings_hash_size =  CONFIG_IP_NF_SET_HASHSIZE;
@@ -129,7 +129,7 @@
 	
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u", ip_set_list[id]->name, ip);	
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	DP("set: %s, ip: %u, binding: %s", ip_set_list[id]->name, ip,
@@ -137,7 +137,7 @@
 
 	if (set_hash != NULL)
 		__set_hash_del(set_hash);
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return 0;
 }
 
@@ -153,7 +153,7 @@
 	IP_SET_ASSERT(ip_set_list[binding]);
 	DP("set: %s, ip: %u, binding: %s", ip_set_list[id]->name, 
 	   ip, ip_set_list[binding]->name);
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	if (!set_hash) {
@@ -175,7 +175,7 @@
 	set_hash->binding = binding;
 	__ip_set_get(set_hash->binding);
     unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return ret;
 }
 
@@ -218,7 +218,7 @@
 	int res, i = 0;
 	
 	IP_SET_ASSERT(flags[i]);
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -229,7 +229,7 @@
 	} while (res > 0 
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 
 	return res;
 }
@@ -244,7 +244,7 @@
 	int res, i= 0;
 
 	IP_SET_ASSERT(flags[i]);
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -258,7 +258,7 @@
 		 || ((res == 0 || res == -EEXIST)
 		     && flags[++i] 
 		     && follow_bindings(index, set, ip)));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 }
 
 void
@@ -271,7 +271,7 @@
 	int res, i = 0;
 
 	IP_SET_ASSERT(flags[i]);
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -282,7 +282,7 @@
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[++i] 
 		 && follow_bindings(index, set, ip));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 }
 
 /* Register and deregister settype */
@@ -315,7 +315,7 @@
 		return -EINVAL;
 	}
 
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	if (find_set_type(set_type->typename)) {
 		/* Duplicate! */
 		ip_set_printk("'%s' already registered!", 
@@ -327,14 +327,14 @@
 	list_append(&set_type_list, set_type);
 	DP("'%s' registered.", set_type->typename);
    unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return ret;
 }
 
 void
 ip_set_unregister_set_type(struct ip_set_type *set_type)
 {
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	if (!find_set_type(set_type->typename)) {
 		ip_set_printk("'%s' not registered?",
 			      set_type->typename);
@@ -344,7 +344,7 @@
 	__MOD_DEC_SELF;
 	DP("'%s' unregistered.", set_type->typename);
    unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 
 }
 
@@ -556,13 +556,13 @@
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 
-		write_lock_bh(&ip_set_lock);
+		WRITE_LOCK(&ip_set_lock);
 		/* Sets as binding values are referenced */
 		if (set->binding != IP_SET_INVALID_ID)
 			__ip_set_put(set->binding);
 		set->binding = binding;
 		__ip_set_get(set->binding);
-		write_unlock_bh(&ip_set_lock);
+		WRITE_UNLOCK(&ip_set_lock);
 
 		return 0;
 	}
@@ -634,15 +634,15 @@
 		/* unbind :all: */
 		if (strcmp(req_bind->binding, IPSET_TOKEN_DEFAULT) == 0) {
 			/* Default binding of sets */
-			write_lock_bh(&ip_set_lock);
+			WRITE_LOCK(&ip_set_lock);
 			FOREACH_SET_DO(__unbind_default);
-			write_unlock_bh(&ip_set_lock);
+			WRITE_UNLOCK(&ip_set_lock);
 			return 0;
 		} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 			/* Flush all bindings of all sets*/
-			write_lock_bh(&ip_set_lock);
+			WRITE_LOCK(&ip_set_lock);
 			FOREACH_HASH_RW_DO(__set_hash_del);
-			write_unlock_bh(&ip_set_lock);
+			WRITE_UNLOCK(&ip_set_lock);
 			return 0;
 		}
 		DP("unreachable reached!");
@@ -658,19 +658,19 @@
 		if (binding == IP_SET_INVALID_ID)
 			return -ENOENT;
 			
-		write_lock_bh(&ip_set_lock);
+		WRITE_LOCK(&ip_set_lock);
 		/* Sets in hash values are referenced */
 		__ip_set_put(set->binding);
 		set->binding = IP_SET_INVALID_ID;
-		write_unlock_bh(&ip_set_lock);
+		WRITE_UNLOCK(&ip_set_lock);
 
 		return 0;
 	} else if (strcmp(req_bind->binding, IPSET_TOKEN_ALL) == 0) {
 		/* Flush all bindings */
 
-		write_lock_bh(&ip_set_lock);
+		WRITE_LOCK(&ip_set_lock);
 		FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
-		write_unlock_bh(&ip_set_lock);
+		WRITE_UNLOCK(&ip_set_lock);
 		return 0;
 	}
 	
@@ -747,10 +747,10 @@
 {
 	struct ip_set_type *type;
 	
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	type = find_set_type(typename);
 	if (type == NULL)
-		read_unlock_bh(&ip_set_lock);
+		READ_UNLOCK(&ip_set_lock);
 
 	return type;
 }
@@ -838,7 +838,7 @@
 		return -ENOENT;
 	}
 	__MOD_INC(set->type->me);
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 
 	/*
 	 * Without holding any locks, create private part.
@@ -857,7 +857,7 @@
 	 * find free id/index and check that it is not already in 
 	 * ip_set_list.
 	 */
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	if ((res = find_free_id(set->name, &index, &id)) != 0) {
 		DP("no free id!");
 		goto cleanup;
@@ -876,11 +876,11 @@
 	DP("create: '%s' created with index %u, id %u!", set->name, index, id);
 	set->id = id;
 	ip_set_list[index] = set;
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return res;
 	
     cleanup:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	set->type->destroy(set);
 	__MOD_DEC(set->type->me);
 	kfree(set);
@@ -897,12 +897,12 @@
 
 	IP_SET_ASSERT(set);
 	DP("set: %s",  set->name);
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	FOREACH_HASH_RW_DO(__set_hash_del_byid, set->id);
 	if (set->binding != IP_SET_INVALID_ID)
 		__ip_set_put(set->binding);
 	ip_set_list[index] = NULL;
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 
 	/* Must call it without holding any lock */
 	set->type->destroy(set);
@@ -973,7 +973,7 @@
 	int res = 0;
 
 	DP("set: %s to %s",  set->name, name);
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	for (i = 0; i < ip_set_max; i++) {
 		if (ip_set_list[i] != NULL
 		    && strncmp(ip_set_list[i]->name, 
@@ -985,7 +985,7 @@
 	}
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
     unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return res;
 }
 
@@ -1007,7 +1007,7 @@
 		return -ENOEXEC;
 
 	/* No magic here: ref munging protected by the mutex */	
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	strncpy(from_name, from->name, IP_SET_MAXNAMELEN);
 	from_ref = atomic_read(&from->ref);
 
@@ -1019,7 +1019,7 @@
 	ip_set_list[from_index] = to;
 	ip_set_list[to_index] = from;
 	
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return 0;
 }
 
@@ -1342,10 +1342,10 @@
 					      hash_save->binding);
 		else {
 			IP_SET_ASSERT(set->binding == IP_SET_INVALID_ID);
-			write_lock_bh(&ip_set_lock);
+			WRITE_LOCK(&ip_set_lock);
 			set->binding = hash_save->binding;
 			__ip_set_get(set->binding);
-			write_unlock_bh(&ip_set_lock);
+			WRITE_UNLOCK(&ip_set_lock);
 			DP("default binding: %u", set->binding);
 		}
 		if (res != 0)

--rwEMma7ioTxnRzrJ--
