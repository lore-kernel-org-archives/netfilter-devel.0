From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 19:45:33 +0200
Message-ID: <432C563D.7050607@trash.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>	<4329F94E.4060107@trash.net>	<20050916091548.GO5034@sunbeam.de.gnumonks.org>	<20050916.154556.116608678.davem@davemloft.net>	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <432C443C.5010101@trash.net>
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

Following are my remaining suggestions. Mostly really minor things.

First, wouldn't it make sense to make ip_{conntrack,nat}_proto_gre
usable without pptp as well?

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c 
b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
new file mode 100644
--- /dev/null
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c

I would prefer the name ip_conntrack_pptp.c for consisteny with
other helpers. Same for ip_nat_helper_pptp.c.

+static int timeout_ct_or_exp(const struct ip_conntrack_tuple *t)
+{
+    struct ip_conntrack_tuple_hash *h;
+    struct ip_conntrack_expect *exp;
+
+    DEBUGP("trying to timeout ct or exp for tuple ");
+    DUMP_TUPLE(t);
+
+    h = __ip_conntrack_find(t, NULL);
+    if (h)  {
+        struct ip_conntrack *sibling = tuplehash_to_ctrack(h);
+        DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
+        sibling->proto.gre.timeout = 0;
+        sibling->proto.gre.stream_timeout = 0;
+        /* refresh_acct will not modify counters if skb == NULL */
+        ip_ct_refresh_acct(sibling, 0, NULL, 0);

The regular way of doing this (del_timer, call ct->timeout.function)
seems cleaner too me.

+/* timeout GRE data connections */
+static int pptp_timeout_related(struct ip_conntrack *ct)
+{
+    struct ip_conntrack_tuple t;
+    int ret;
+
+    /* Since ct->sibling_list has literally rusted away in 2.6.11,
+       we now need another way to find out about our sibling
+     * contrack and expects... -HW */
+
+    /* try original (pns->pac) tuple */
+    memcpy(&t, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(t));
+    t.dst.protonum = IPPROTO_GRE;
+    t.src.u.gre.key = htons(ct->help.ct_pptp_info.pns_call_id);
+    t.dst.u.gre.key = htons(ct->help.ct_pptp_info.pac_call_id);
+
+    ret = timeout_ct_or_exp(&t);
+
+    /* try reply (pac->pns) tuple */
+    memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
+    t.dst.protonum = IPPROTO_GRE;
+    t.src.u.gre.key = htons(ct->help.ct_pptp_info.pac_call_id);
+    t.dst.u.gre.key = htons(ct->help.ct_pptp_info.pns_call_id);
+
+    ret += timeout_ct_or_exp(&t);


The return value of this function isn't used, so timeout_ct_or_exp and
itself can be made void. The name also seems a bit misleading since it
wants to destroy related conntracks and is not used in any function
dealing with timouts - how about pptp_destroy_related()?

+EXPORT_SYMBOL(ip_pptp_lock);

This export is not used.

diff --git a/net/ipv4/netfilter/ip_conntrack_pptp_priv.h 
b/net/ipv4/netfilter/ip_conntrack_pptp_priv.h
new file mode 100644
--- /dev/null
+++ b/net/ipv4/netfilter/ip_conntrack_pptp_priv.h
+@@ -0,0 +1,24 @@
+#ifndef _IP_CT_PPTP_PRIV_H
+#define _IP_CT_PPTP_PRIV_H
+
+/* PptpControlMessageType names */
+static const char *strMName[] = {

This should go in the pptp helper itself.

+int
+ip_ct_gre_keymap_add(struct ip_conntrack *ct,
+             struct ip_conntrack_tuple *t, int reply)
+{
+    struct ip_ct_gre_keymap *km, *old;
+
+    if (!ct->helper || strcmp(ct->helper->name, "pptp")) {
+        DEBUGP("refusing to add GRE keymap to non-pptp session\n");
+        return -1;
+    }
+
+    km = kmalloc(sizeof(*km), GFP_ATOMIC);
+    if (!km)
+        return -1;
+
+    /* initializing list head should be sufficient */
+    memset(km, 0, sizeof(*km));

The comment doesn't match the code.

+
+    memcpy(&km->tuple, t, sizeof(*t));
+
+    if (!reply) {
+        if (ct->help.ct_pptp_info.keymap_orig) {
+            kfree(km);
+
+            /* check whether it's a retransmission */
+            old = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
+                    struct ip_ct_gre_keymap *, t);
+            if (old == ct->help.ct_pptp_info.keymap_orig) {
+                DEBUGP("retransmission\n");
+                return 0;
+            }
+
+            DEBUGP("trying to override keymap_orig for ct %p\n",
+                ct);
+            return -2;

All users only check for <= 0, using -1 or -EEXIST or something seems
cleaner than using magic values.

+        }
+        ct->help.ct_pptp_info.keymap_orig = km;
+    } else {
+        if (ct->help.ct_pptp_info.keymap_reply) {
+            kfree(km);
+
+            /* check whether it's a retransmission */
+            old = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
+                    struct ip_ct_gre_keymap *, t);
+            if (old == ct->help.ct_pptp_info.keymap_reply) {
+                DEBUGP("retransmission\n");
+                return 0;
+            }
+
+            DEBUGP("trying to override keymap_reply for ct %p\n",
+                ct);
+            return -2;
+        }
+        ct->help.ct_pptp_info.keymap_reply = km;

It looks like the above blocks could be merged by using a pointer
to ct->help.ct_pptp_info.keymap_{orig,reply}. Memory allocation
can then be moved below the "if (!reply)" block.

+void __exit ip_ct_proto_gre_fini(void)
+{
+    struct list_head *pos, *n;
+
+    /* delete all keymap entries */
+    write_lock_bh(&ip_ct_gre_lock);
+    list_for_each_safe(pos, n, &gre_keymap_list) {
+        DEBUGP("deleting keymap %p at module unload time\n", pos);
+        list_del(pos);
+        kfree(pos);

break;

+    }
+    write_unlock_bh(&ip_ct_gre_lock);


+/* generate unique tuple ... */
+static int +gre_unique_tuple(struct ip_conntrack_tuple *tuple,
+         const struct ip_nat_range *range,
+         enum ip_nat_manip_type maniptype,
+         const struct ip_conntrack *conntrack)
+{
+    u_int32_t min, i, range_size;
+    u_int16_t key = 0, *keyptr;

How about using the same static u_int16_t key trick used in
the other NAT helpers to increase chances of finding an unused
tuple at the first try?
