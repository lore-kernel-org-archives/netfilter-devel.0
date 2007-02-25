From: Patrick McHardy <kaber@trash.net>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Sun, 25 Feb 2007 18:31:12 +0100
Message-ID: <45E1C7E0.9070102@trash.net>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com> <45E04468.7020001@trash.net> <45E06546.504@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000501040101060500070205"
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965013AbXBYRZZ@vger.kernel.org>
In-Reply-To: <45E06546.504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000501040101060500070205
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Chuck Ebbert wrote:
> It is the standard Fedora script "iptables" and it recursively
> unloads all referring modules, then the base ones: ip_tables and
> ip_conntrack. I can't tell which module it stopped on because
> that computer is at home today. 
> 
> And yes, it really locks up until it's caught by the softlockup
> watchdog. Has only happened on a uniprocessor i686 system so far,
> but happens every time on shutdown.


Can you try this patch please?

--------------000501040101060500070205
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops

{nf,ip}_ct_iterate_cleanup iterate over the unconfirmed list for cleaning
up conntrack entries, which is wrong for multiple reasons:

- unconfirmed entries can not be killed manually, which means we might
  iterate forever without making forward progress.

  This can happen in combination with the conntrack event cache, which
  holds a reference to the conntrack entry, which is only released when
  the packet makes it all the way through the stack or a different
  packet is handled.

- taking references to an unconfirmed entry and using it outside the
  locked section doesn't work, the list entries are not refcounted and
  another CPU might already be waiting to destroy the entry

Split ip_ct_iterate_cleanup in ip_ct_iterate, which iterates over both
confirmed and unconfirmed entries, but doesn't attempt to kill them,
and ip_ct_cleanup, which makes sure no unconfirmed entries exist by
calling synchronize_net() prior to walking the conntrack hash.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 08ace206d2703e377efebe1852539177458593ff
tree 1d27d4759a77db062d48c4420459c810e7fec14a
parent 9654640d0af8f2de40ff3807d3695109d3463f54
author Patrick McHardy <kaber@trash.net> Sun, 25 Feb 2007 17:57:21 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 25 Feb 2007 18:28:22 +0100

 include/linux/netfilter_ipv4/ip_conntrack.h  |    5 ++--
 include/net/netfilter/nf_conntrack.h         |    5 +++-
 include/net/netfilter/nf_nat_rule.h          |    3 ++
 net/ipv4/netfilter/ip_conntrack_core.c       |   30 ++++++++++++++++++------
 net/ipv4/netfilter/ip_conntrack_standalone.c |    5 ++--
 net/ipv4/netfilter/ip_nat_core.c             |    5 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c          |    4 ++-
 net/ipv4/netfilter/nf_nat_core.c             |    7 ++----
 net/netfilter/nf_conntrack_core.c            |   33 ++++++++++++++++++++------
 net/netfilter/nf_conntrack_proto.c           |    4 ++-
 10 files changed, 69 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index da9274e..90b12b2 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -250,8 +250,9 @@ ip_ct_gather_frags(struct sk_buff *skb, 
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *data),
-		      void *data);
+ip_ct_cleanup(int (*iter)(struct ip_conntrack *i, void *data), void *data);
+extern void
+ip_ct_iterate(void (*iter)(struct ip_conntrack *i, void *data), void *data);
 
 extern struct ip_conntrack_helper *
 __ip_conntrack_helper_find_byname(const char *);
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 0e690e3..a9271df 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -233,7 +233,10 @@ extern int nf_ct_no_defrag;
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
 extern void
-nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
+nf_ct_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data);
+extern void
+nf_ct_iterate(void (*iter)(struct nf_conn *i, void *data), void *data);
+
 extern void nf_conntrack_free(struct nf_conn *ct);
 extern struct nf_conn *
 nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
diff --git a/include/net/netfilter/nf_nat_rule.h b/include/net/netfilter/nf_nat_rule.h
index f191c67..2f16114 100644
--- a/include/net/netfilter/nf_nat_rule.h
+++ b/include/net/netfilter/nf_nat_rule.h
@@ -11,7 +11,8 @@ #define ip_conntrack_get		nf_ct_get
 #define ip_conntrack			nf_conn
 #define ip_nat_setup_info		nf_nat_setup_info
 #define ip_nat_multi_range_compat	nf_nat_multi_range_compat
-#define ip_ct_iterate_cleanup		nf_ct_iterate_cleanup
+#define ip_ct_cleanup			nf_ct_cleanup
+#define ip_ct_iterate			nf_ct_iterate
 #define	IP_NF_ASSERT			NF_CT_ASSERT
 
 extern int nf_nat_rule_init(void) __init;
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 07ba1dd..eaf6b07 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1251,11 +1251,6 @@ get_next_corpse(int (*iter)(struct ip_co
 				goto found;
 		}
 	}
-	list_for_each_entry(h, &unconfirmed, list) {
-		ct = tuplehash_to_ctrack(h);
-		if (iter(ct, data))
-			goto found;
-	}
 	write_unlock_bh(&ip_conntrack_lock);
 	return NULL;
 
@@ -1266,11 +1261,16 @@ found:
 }
 
 void
-ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *), void *data)
+ip_ct_cleanup(int (*iter)(struct ip_conntrack *i, void *), void *data)
 {
 	struct ip_conntrack *ct;
 	unsigned int bucket = 0;
 
+	if (!list_empty(&unconfirmed)) {
+		synchronize_net();
+		WARN_ON(!list_empty(&unconfirmed));
+	}
+
 	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
@@ -1281,6 +1281,22 @@ ip_ct_iterate_cleanup(int (*iter)(struct
 	}
 }
 
+void ip_ct_iterate(void (*iter)(struct ip_conntrack *i, void *), void *data)
+{
+	struct ip_conntrack_tuple_hash *h;
+	unsigned int i;
+
+	read_lock_bh(&ip_conntrack_lock);
+
+	list_for_each_entry(h, &unconfirmed, list)
+		iter(tuplehash_to_ctrack(h), data);
+	for (i = 0; i < ip_conntrack_htable_size; i++) {
+		list_for_each_entry(h, &ip_conntrack_hash[i], list)
+			iter(tuplehash_to_ctrack(h), data);
+	}
+	read_unlock_bh(&ip_conntrack_lock);
+}
+
 /* Fast function for those who don't want to parse /proc (and I don't
    blame them). */
 /* Reversing the socket's dst/src point of view gives us the reply
@@ -1351,7 +1367,7 @@ static int kill_all(struct ip_conntrack 
 
 void ip_conntrack_flush(void)
 {
-	ip_ct_iterate_cleanup(kill_all, NULL);
+	ip_ct_cleanup(kill_all, NULL);
 }
 
 static void free_conntrack_hash(struct list_head *hash, int vmalloced,int size)
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 56b2f75..0288527 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -811,7 +811,7 @@ void ip_conntrack_protocol_unregister(st
 	synchronize_rcu();
 
 	/* Remove all contrack entries for this protocol */
-	ip_ct_iterate_cleanup(kill_proto, &proto->proto);
+	ip_ct_cleanup(kill_proto, &proto->proto);
 }
 
 static int __init ip_conntrack_standalone_init(void)
@@ -915,7 +915,8 @@ EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(need_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
-EXPORT_SYMBOL(ip_ct_iterate_cleanup);
+EXPORT_SYMBOL(ip_ct_cleanup);
+EXPORT_SYMBOL(ip_ct_iterate);
 EXPORT_SYMBOL(__ip_ct_refresh_acct);
 
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 40737fd..bcdc22b 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -613,16 +613,15 @@ static int __init ip_nat_init(void)
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
-static int clean_nat(struct ip_conntrack *i, void *data)
+static void clean_nat(struct ip_conntrack *i, void *data)
 {
 	memset(&i->nat, 0, sizeof(i->nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
-	return 0;
 }
 
 static void __exit ip_nat_cleanup(void)
 {
-	ip_ct_iterate_cleanup(&clean_nat, NULL);
+	ip_ct_iterate(&clean_nat, NULL);
 	rcu_assign_pointer(ip_conntrack_destroyed, NULL);
 	synchronize_rcu();
 	vfree(bysource);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index b5955f3..5b3883e 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -158,7 +158,7 @@ static int masq_device_event(struct noti
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
 
-		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
@@ -176,7 +176,7 @@ static int masq_inet_event(struct notifi
 		   and forget them. */
 		IP_NF_ASSERT(dev->ifindex != 0);
 
-		ip_ct_iterate_cleanup(device_cmp, (void *)(long)dev->ifindex);
+		ip_ct_cleanup(device_cmp, (void *)(long)dev->ifindex);
 	}
 
 	return NOTIFY_DONE;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 2c01378..5bc459c 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -628,20 +628,19 @@ static int __init nf_nat_init(void)
 }
 
 /* Clear NAT section of all conntracks, in case we're loaded again. */
-static int clean_nat(struct nf_conn *i, void *data)
+static void clean_nat(struct nf_conn *i, void *data)
 {
 	struct nf_conn_nat *nat = nfct_nat(i);
 
 	if (!nat)
-		return 0;
+		return;
 	memset(nat, 0, sizeof(nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
-	return 0;
 }
 
 static void __exit nf_nat_cleanup(void)
 {
-	nf_ct_iterate_cleanup(&clean_nat, NULL);
+	nf_ct_iterate(&clean_nat, NULL);
 	rcu_assign_pointer(nf_conntrack_destroyed, NULL);
 	synchronize_rcu();
 	vfree(bysource);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 32891eb..6dc20da 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1067,11 +1067,6 @@ get_next_corpse(int (*iter)(struct nf_co
 				goto found;
 		}
 	}
-	list_for_each_entry(h, &unconfirmed, list) {
-		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (iter(ct, data))
-			goto found;
-	}
 	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
 found:
@@ -1081,11 +1076,16 @@ found:
 }
 
 void
-nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data)
+nf_ct_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
 	struct nf_conn *ct;
 	unsigned int bucket = 0;
 
+	if (!list_empty(&unconfirmed)) {
+		synchronize_net();
+		WARN_ON(!list_empty(&unconfirmed));
+	}
+
 	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
@@ -1095,7 +1095,24 @@ nf_ct_iterate_cleanup(int (*iter)(struct
 		nf_ct_put(ct);
 	}
 }
-EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
+EXPORT_SYMBOL_GPL(nf_ct_cleanup);
+
+void
+nf_ct_iterate(void (*iter)(struct nf_conn *i, void *data), void *data)
+{
+	struct nf_conntrack_tuple_hash *h;
+	unsigned int i;
+
+	read_lock_bh(&nf_conntrack_lock);
+	list_for_each_entry(h, &unconfirmed, list)
+		iter(nf_ct_tuplehash_to_ctrack(h), data);
+	for (i = 0; i < nf_conntrack_htable_size; i++) {
+		list_for_each_entry(h, &nf_conntrack_hash[i], list)
+			iter(nf_ct_tuplehash_to_ctrack(h), data);
+	}
+	read_unlock_bh(&nf_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_iterate);
 
 static int kill_all(struct nf_conn *i, void *data)
 {
@@ -1113,7 +1130,7 @@ static void free_conntrack_hash(struct l
 
 void nf_conntrack_flush(void)
 {
-	nf_ct_iterate_cleanup(kill_all, NULL);
+	nf_ct_cleanup(kill_all, NULL);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 456155f..695b734 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -229,7 +229,7 @@ void nf_conntrack_l3proto_unregister(str
 	nf_ct_l3proto_unregister_sysctl(proto);
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(kill_l3proto, proto);
+	nf_ct_cleanup(kill_l3proto, proto);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregister);
 
@@ -374,6 +374,6 @@ void nf_conntrack_l4proto_unregister(str
 	nf_ct_l4proto_unregister_sysctl(l4proto);
 
 	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_cleanup(kill_l4proto, l4proto);
+	nf_ct_cleanup(kill_l4proto, l4proto);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_unregister);

--------------000501040101060500070205--
