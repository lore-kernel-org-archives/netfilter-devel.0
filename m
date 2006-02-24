From: Piotr Chytla <pch@packetconsulting.pl>
Subject: problem with ipset and 2.4.31, again...
Date: Fri, 24 Feb 2006 12:10:12 +0100
Message-ID: <20060224111012.GA26233@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
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


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Hi

ipset from patch-o-matic-ng(r6345) fails to compile on 2.4.31/32, Problem and
solution is the same as this :

http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018087.html

In some earlier version this was fixed but this problem comes back again
:)

When CONFIG_NETFILTER_DEBUG is defined RWLOCK is structure but without 
DEBUG , only rwlock_t l is use , WRITE_LOCK is write_lock_bh etc etc, 
maybe this need some note in patch-o-matic-ng/patchlets/set/help that set must 
by compiled without  DEBUG , or use macros everywhere . 

patch is attached.

/pch

-- 
Dyslexia bug unpatched since 1977 ...
exploit has been leaked to the underground.

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ip_set.c.diff"

--- ip_set.c.20060224	2006-02-24 09:32:29.000000000 +0100
+++ ip_set.c	2006-02-24 10:16:49.000000000 +0100
@@ -130,7 +130,7 @@
 	
 	IP_SET_ASSERT(ip_set_list[id]);
 	DP("set: %s, ip: %u.%u.%u.%u", ip_set_list[id]->name, HIPQUAD(ip));	
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name,
@@ -139,7 +139,7 @@
 
 	if (set_hash != NULL)
 		__set_hash_del(set_hash);
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return 0;
 }
 
@@ -155,7 +155,7 @@
 	IP_SET_ASSERT(ip_set_list[binding]);
 	DP("set: %s, ip: %u.%u.%u.%u, binding: %s", ip_set_list[id]->name, 
 	   HIPQUAD(ip), ip_set_list[binding]->name);
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	set_hash = LIST_FIND(&ip_set_hash[key], ip_hash_cmp,
 			     struct ip_set_hash *, id, ip);
 	if (!set_hash) {
@@ -177,7 +177,7 @@
 	set_hash->binding = binding;
 	__ip_set_get(set_hash->binding);
     unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return ret;
 }
 
@@ -221,7 +221,7 @@
 	unsigned char i = 0;
 	
 	IP_SET_ASSERT(flags[i]);
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -233,7 +233,7 @@
 	} while (res > 0 
 		 && flags[i] 
 		 && follow_bindings(index, set, ip));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 
 	return res;
 }
@@ -250,7 +250,7 @@
 
 	IP_SET_ASSERT(flags[i]);
     retry:
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -262,7 +262,7 @@
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[i] 
 		 && follow_bindings(index, set, ip));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 	
 	if (res == -EAGAIN
 	    && set->type->retry
@@ -281,7 +281,7 @@
 	unsigned char i = 0;
 
 	IP_SET_ASSERT(flags[i]);
-	read_lock_bh(&ip_set_lock);
+	READ_LOCK(&ip_set_lock);
 	do {
 		set = ip_set_list[index];
 		IP_SET_ASSERT(set);
@@ -293,7 +293,7 @@
 	} while ((res == 0 || res == -EEXIST)
 		 && flags[i] 
 		 && follow_bindings(index, set, ip));
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 }
 
 /* Register and deregister settype */
@@ -326,7 +326,7 @@
 		return -EINVAL;
 	}
 
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	if (find_set_type(set_type->typename)) {
 		/* Duplicate! */
 		ip_set_printk("'%s' already registered!", 
@@ -338,14 +338,14 @@
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
@@ -355,7 +355,7 @@
 	__MOD_DEC_SELF;
 	DP("'%s' unregistered.", set_type->typename);
    unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 
 }
 
@@ -567,13 +567,13 @@
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
@@ -645,15 +645,15 @@
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
@@ -669,19 +669,19 @@
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
 	
@@ -757,10 +757,10 @@
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
@@ -848,7 +848,7 @@
 		return -ENOENT;
 	}
 	__MOD_INC(set->type->me);
-	read_unlock_bh(&ip_set_lock);
+	READ_UNLOCK(&ip_set_lock);
 
 	/*
 	 * Without holding any locks, create private part.
@@ -867,7 +867,7 @@
 	 * find free id/index and check that it is not already in 
 	 * ip_set_list.
 	 */
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	if ((res = find_free_id(set->name, &index, &id)) != 0) {
 		DP("no free id!");
 		goto cleanup;
@@ -886,11 +886,11 @@
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
@@ -907,12 +907,12 @@
 
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
@@ -983,7 +983,7 @@
 	int res = 0;
 
 	DP("set: %s to %s",  set->name, name);
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	for (i = 0; i < ip_set_max; i++) {
 		if (ip_set_list[i] != NULL
 		    && strncmp(ip_set_list[i]->name, 
@@ -995,7 +995,7 @@
 	}
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
     unlock:
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return res;
 }
 
@@ -1017,7 +1017,7 @@
 		return -ENOEXEC;
 
 	/* No magic here: ref munging protected by the mutex */	
-	write_lock_bh(&ip_set_lock);
+	WRITE_LOCK(&ip_set_lock);
 	strncpy(from_name, from->name, IP_SET_MAXNAMELEN);
 	from_ref = atomic_read(&from->ref);
 
@@ -1029,7 +1029,7 @@
 	ip_set_list[from_index] = to;
 	ip_set_list[to_index] = from;
 	
-	write_unlock_bh(&ip_set_lock);
+	WRITE_UNLOCK(&ip_set_lock);
 	return 0;
 }
 
@@ -1351,10 +1351,10 @@
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

--X1bOJ3K7DJ5YkBrT--
