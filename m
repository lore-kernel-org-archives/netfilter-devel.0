From: sandr8 <alessandro.salvatori@eurecom.fr>
Subject: [patch] Re: adding field into conntrack
Date: Thu, 05 Aug 2004 18:33:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41126161.8030803@eurecom.fr>
References: <1091042173.4107fb7d2cabf@mail.crocetta.org> <1091060982.28111.30.camel@bach> <20040801171930.GD14539@sunbeam2> <1091434360.410df7789a879@mail.crocetta.org> <20040802084602.GJ18758@sunbeam2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sandr8@crocetta.org, Rusty Russell <rusty@rustcorp.com.au>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040802084602.GJ18758@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Mon, Aug 02, 2004 at 10:12:40AM +0200, sandr8@crocetta.org wrote:
>[snip]
>  
>
>>The error we made could be huge with respect to open loop streams
>>(such as UDP), while with closed loop ones we could imagine that there
>>will be not that much difference between the throughput seen before
>>the enqueuing and the goodput seen after the deuqueuing.
>>    
>>
>[snip]
>But if I understood your approach corretly, you would want to keep this
>code in place but later check for enqueue result and decrement
>accounting?  This means that the extra write lock grab would only happen
>in case of dropped packets... that sounds fine.
>
>Please prepare an incremental patch and we'll review & discuss with
>netdev people.
>  
>
Here's what my little hamster managed to do... sorry i'm late, but i 
didn't feed
it that much, so it couldn't run that fast on the wheel; furthermore -- how
unlucky it is -- it had to apply manually some 10 or 12 hunk to 
2.6.8-rc3 that
has just changed those files the hamster itself had touched...

 the following patch changes the interface of the enqueue() and requeue()
 operations... the "struct sk_buff * skb" is now a "struct sk_buff ** 
const skb"
 (const is there in the hope to avoid stupid bugs). It applies cleanly 
to the
 2.6.8-rc3 kernel (after having patched it with the pending Harald 
Welte's ACCT
 patch).

 ouch, this has never happened before but i've changed all the packet 
schedulers
 and the core/dev.c consequently... tell me if i'm raving or  it makes 
at least some
  little sense... (please don't slaughter me nor my _terribly slow_ 
hamster :-)
 
 at that expence, imho we would get some advantages:
 
 a) the socket buffer is freed as late as possible (lazy lazy lazy!), 
hence the
 latest word is said by the more external enqueuing operation. This 
means that
 whatever packet "Barabba" is choosen to be dropped internally, it can be
 further saved by the caller, who can exchange it with an other victim...
 
 b) as a consequence of (a) it should be possible to remove the deprecated
 __parent field due to cbq by handling the reshape from the outside, 
whoever
 drops whatever

 c) now it's possible to have (almost) a single point (core/dev.c) where 
packets
 are dropped.
 
 In that point (and in some other few points) a little function
 (ct_sub_counters()) is executed if and only if the connection tracking 
module
 is loaded. In that function, if  ACCT was compiled into the kernel, the 
flow
 the packet belongs to is unbilled  for the traffic that was dropped, since
 otherwise we would make very coarse  errors against udp flows and "open 
loop"
 protocols in general.
 
 [the following paragraph is not something in this patch!]
   If it makes sense and some other people need to gather informations from
   packets dropped, the name of that function could change and a hook 
could be
   placed just outside of the #ifdef CONFIG_IP_NF_CT_ACCT. kfree_skb() 
would
   just have the right type for the okfn :) maybe the ACCT code for the 
unbilling
   could be registered to the hook as well, instead of using the little 
pointer
   hack as for now. That way netfilter could also put an hook to catch 
packets
   dropped _after_ they were enqueued.
  
     [at this point i can read into your mind... you are saying: 'hey 
dude, in the old good
      times when mice were not wireless you didn't even need to buy a 
rope to hang yourself' :-]
 
Alessandro

(here's a little change to the defines in order to distinguish more 
quickly between success and congestion...)
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/include/linux/netdevice.h 
linux-2.6.8-rc3-ACCT-drops/include/linux/netdevice.h
--- linux-2.6.8-rc3-ACCT/include/linux/netdevice.h    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/include/linux/netdevice.h    2004-08-05 
12:44:17.000000000 +0200
@@ -52,12 +52,14 @@
 #define HAVE_NETDEV_PRIV        /* netdev_priv() */
 
 #define NET_XMIT_SUCCESS    0
-#define NET_XMIT_DROP        1    /* skb dropped            */
-#define NET_XMIT_CN        2    /* congestion notification    */
-#define NET_XMIT_POLICED    3    /* skb is shot by police    */
-#define NET_XMIT_BYPASS        4    /* packet does not leave via dequeue;
+#define NET_XMIT_BYPASS        2    /* packet does not leave via dequeue;
                        (TC use only - dev_queue_xmit
                        returns this as NET_XMIT_SUCCESS) */
+#define NET_XMIT_RESHAPED       4
+
+#define NET_XMIT_DROP        5    /* skb dropped            */
+#define NET_XMIT_CN        7    /* congestion notification    */
+#define NET_XMIT_POLICED    9    /* skb is shot by police    */
 
 /* Backlog congestion levels */
 #define NET_RX_SUCCESS        0   /* keep 'em coming, baby */
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/include/net/pkt_sched.h 
linux-2.6.8-rc3-ACCT-drops/include/net/pkt_sched.h
--- linux-2.6.8-rc3-ACCT/include/net/pkt_sched.h    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/include/net/pkt_sched.h    2004-08-05 
15:53:06.000000000 +0200
@@ -10,6 +10,21 @@
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 
+#ifdef CONFIG_IP_NF_CT_ACCT
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/ip.h>
+extern struct ip_conntrack *
+(*ip_ct_get)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo);
+
+#ifdef CONFIG_NETFILTER_DEBUG
+extern struct rwlock_debug * ip_conntrack_lockp;
+#else
+extern rwlock_t * ip_conntrack_lockp;
+#endif
+
+#endif
+
 struct rtattr;
 struct Qdisc;
 
@@ -52,10 +67,10 @@
     char            id[IFNAMSIZ];
     int            priv_size;
 
-    int             (*enqueue)(struct sk_buff *, struct Qdisc *);
+    int             (*enqueue)(struct sk_buff ** const, struct Qdisc *);
     struct sk_buff *    (*dequeue)(struct Qdisc *);
-    int             (*requeue)(struct sk_buff *, struct Qdisc *);
-    unsigned int        (*drop)(struct Qdisc *);
+    int             (*requeue)(struct sk_buff ** const, struct Qdisc *);
+    unsigned int        (*drop)(struct Qdisc *, struct sk_buff ** const);
 
     int            (*init)(struct Qdisc *, struct rtattr *arg);
     void            (*reset)(struct Qdisc *);
@@ -71,7 +86,7 @@
 
 struct Qdisc
 {
-    int             (*enqueue)(struct sk_buff *skb, struct Qdisc *dev);
+    int             (*enqueue)(struct sk_buff ** const skb, struct 
Qdisc *dev);
     struct sk_buff *    (*dequeue)(struct Qdisc *dev);
     unsigned        flags;
 #define TCQ_F_BUILTIN    1
@@ -87,7 +102,8 @@
     struct tc_stats        stats;
     spinlock_t        *stats_lock;
     struct rcu_head     q_rcu;
-    int            (*reshape_fail)(struct sk_buff *skb, struct Qdisc *q);
+    int            (*reshape_fail)(struct sk_buff ** const skb,
+                    struct Qdisc *q);
 
     /* This field is deprecated, but it is still used by CBQ
      * and it will live until better solution will be invented.
@@ -432,6 +448,56 @@
 
 extern int qdisc_restart(struct net_device *dev);
 
+static inline void ct_sub_counters(const struct sk_buff *skb)
+{
+    /* skb must not be NULL */
+#ifdef CONFIG_IP_NF_CT_ACCT
+    if(ip_ct_get){ /* FIXME: is this the best way to do that?
+                                            * wouldn't it be better to 
add a new HOOK
+                            * for when packets are dropped? you register
+                            * there packet filters that wanna gather
+                            * informations from dropped packets... the
+                        * kfree_skb() has the right declaration to
+                        * be used as the okfn */
+        enum ip_conntrack_info ctinfo;
+        struct ip_conntrack *ct;
+
+        struct ip_conntrack *
+        (*the_connection_tracking_is_loaded)(struct sk_buff *skb, enum 
ip_conntrack_info *ctinfo);
+
+        if(skb->nfct && (the_connection_tracking_is_loaded=ip_ct_get)){
+            mb();
+            ct=the_connection_tracking_is_loaded(
+                (struct sk_buff *)skb,
+                &ctinfo);
+            if(ct){
+                WRITE_LOCK(ip_conntrack_lockp);
+
+                ct->counters[CTINFO2DIR(ctinfo)].packets--;
+                ct->counters[CTINFO2DIR(ctinfo)].bytes -=
+                    ntohs(skb->nh.iph->tot_len);
+
+                WRITE_UNLOCK(ip_conntrack_lockp);
+            }
+        }
+    }
+#endif
+}
+
+#define IMPLICIT_DROP() do; while (0)
+
+static inline unsigned any_dropped(unsigned code)
+{
+    return(0x1 & code);
+}
+
+static inline unsigned no_dropped(unsigned code)
+{
+    return(!(0x1 & code));
+}
+
+
+
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/core/dev.c 
linux-2.6.8-rc3-ACCT-drops/net/core/dev.c
--- linux-2.6.8-rc3-ACCT/net/core/dev.c    2004-08-05 10:54:11.000000000 
+0200
+++ linux-2.6.8-rc3-ACCT-drops/net/core/dev.c    2004-08-05 
16:16:14.000000000 +0200
@@ -113,6 +113,23 @@
 #include <net/iw_handler.h>
 #endif    /* CONFIG_NET_RADIO */
 #include <asm/current.h>
+#include <linux/ip.h>
+#ifdef CONFIG_IP_NF_CT_ACCT
+struct ip_conntrack *
+(* ip_ct_get)(struct sk_buff *skb,
+    enum ip_conntrack_info *ctinfo)=NULL;
+DECLARE_RWLOCK(ct_load);
+#ifdef CONFIG_NETFILTER_DEBUG
+struct rwlock_debug * ip_conntrack_lockp=NULL;
+#else
+rwlock_t * ip_conntrack_lockp=NULL;
+#endif
+
+EXPORT_SYMBOL(ip_ct_get);
+EXPORT_SYMBOL(ip_conntrack_lockp);
+
+#endif
+
 
 /* This define, if set, will randomly drop a packet when congestion
  * is more than moderate.  It helps fairness in the multi-interface
@@ -1341,13 +1358,19 @@
         /* Grab device queue */
         spin_lock_bh(&dev->queue_lock);
 
-        rc = q->enqueue(skb, q);
+        rc = q->enqueue(&skb, q);
 
         qdisc_run(dev);
 
         spin_unlock_bh(&dev->queue_lock);
         rcu_read_unlock();
         rc = rc == NET_XMIT_BYPASS ? NET_XMIT_SUCCESS : rc;
+
+        if(rc!=NET_XMIT_SUCCESS){ /* unlikely? better dynamically IMHO */
+            ct_sub_counters(skb);
+            goto out_kfree_skb;
+        }
+    
         goto out;
     }
     rcu_read_unlock();
@@ -1747,7 +1770,7 @@
         }
         spin_lock(&dev->ingress_lock);
         if ((q = dev->qdisc_ingress) != NULL)
-            result = q->enqueue(skb, q);
+            result = q->enqueue(&skb, q);
         spin_unlock(&dev->ingress_lock);
 
     }
diff -ruN -X dontdiff 
linux-2.6.8-rc3-ACCT/net/ipv4/netfilter/ip_conntrack_core.c 
linux-2.6.8-rc3-ACCT-drops/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.8-rc3-ACCT/net/ipv4/netfilter/ip_conntrack_core.c    
2004-08-05 12:38:13.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/ipv4/netfilter/ip_conntrack_core.c    
2004-08-05 12:44:17.000000000 +0200
@@ -56,6 +56,21 @@
 #define DEBUGP(format, args...)
 #endif
 
+#ifdef CONFIG_IP_NF_CT_ACCT
+extern struct ip_conntrack *
+(*ip_ct_get)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo);
+
+
+
+#ifdef CONFIG_NETFILTER_DEBUG 
+extern struct rwlock_debug * ip_conntrack_lockp;
+#else 
+extern rwlock_t * ip_conntrack_lockp;
+#endif 
+
+#endif
+
+
 DECLARE_RWLOCK(ip_conntrack_lock);
 DECLARE_RWLOCK(ip_conntrack_expect_tuple_lock);
 
@@ -1373,6 +1388,10 @@
 void ip_conntrack_cleanup(void)
 {
     ip_ct_attach = NULL;
+#ifdef CONFIG_IP_NF_CT_ACCT
+    ip_ct_get = NULL;
+#endif   
+   
     /* This makes sure all current packets have passed through
            netfilter framework.  Roll on, two-stage module
            delete... */
@@ -1451,6 +1470,12 @@
 
     /* For use by ipt_REJECT */
     ip_ct_attach = ip_conntrack_attach;
+   
+#ifdef CONFIG_IP_NF_CT_ACCT
+    /* For the core kernel, in net/core/dev.c */
+    ip_conntrack_lockp=&ip_conntrack_lock;
+    ip_ct_get = ip_conntrack_get;
+#endif
 
     /* Set up fake conntrack:
         - to never be deleted, not in any hashes */
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/ipv4/netfilter/Kconfig 
linux-2.6.8-rc3-ACCT-drops/net/ipv4/netfilter/Kconfig
--- linux-2.6.8-rc3-ACCT/net/ipv4/netfilter/Kconfig    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/ipv4/netfilter/Kconfig    2004-08-05 
15:57:16.000000000 +0200
@@ -19,6 +19,18 @@
 
       To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_CT_ACCT
+    bool "Connection tracking flow accounting"
+    depends on IP_NF_CONNTRACK
+    ---help---
+      If you enable this option, the connection tracking code will keep
+      per-flow packet and byte counters.
+
+      Those counters can be used for flow-based accounting or the
+      `connbytes' match.
+
+      If unsure, say N.
+
 config IP_NF_FTP
     tristate "FTP protocol support"
     depends on IP_NF_CONNTRACK
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_api.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_api.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_api.c    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_api.c    2004-08-05 
12:54:01.000000000 +0200
@@ -94,9 +94,9 @@
 
    ---enqueue
 
-   enqueue returns 0, if packet was enqueued successfully.
+   enqueue returns an even number, if packet was enqueued successfully.
    If packet (this one or another one) was dropped, it returns
-   not zero error code.
+   an odd error code.
    NET_XMIT_DROP     - this packet dropped
      Expected action: do not backoff, but wait until queue will clear.
    NET_XMIT_CN         - probably this packet enqueued, but another one 
dropped.
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_atm.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_atm.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_atm.c    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_atm.c    2004-08-05 
15:42:19.000000000 +0200
@@ -397,7 +397,7 @@
 /* --------------------------- Qdisc operations 
---------------------------- */
 
 
-static int atm_tc_enqueue(struct sk_buff *skb,struct Qdisc *sch)
+static int atm_tc_enqueue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
     struct atm_qdisc_data *p = PRIV(sch);
     struct atm_flow_data *flow = NULL ; /* @@@ */
@@ -405,13 +405,13 @@
     int result;
     int ret = NET_XMIT_POLICED;
 
-    D2PRINTK("atm_tc_enqueue(skb %p,sch %p,[qdisc %p])\n",skb,sch,p);
+    D2PRINTK("atm_tc_enqueue(skb %p,sch %p,[qdisc %p])\n",*skb,sch,p);
     result = TC_POLICE_OK; /* be nice to gcc */
-    if (TC_H_MAJ(skb->priority) != sch->handle ||
-        !(flow = (struct atm_flow_data *) atm_tc_get(sch,skb->priority)))
+    if (TC_H_MAJ((*skb)->priority) != sch->handle ||
+        !(flow = (struct atm_flow_data *) 
atm_tc_get(sch,(*skb)->priority)))
         for (flow = p->flows; flow; flow = flow->next)
             if (flow->filter_list) {
-                result = tc_classify(skb,flow->filter_list,
+                result = tc_classify((*skb),flow->filter_list,
                     &res);
                 if (result < 0) continue;
                 flow = (struct atm_flow_data *) res.class;
@@ -421,17 +421,17 @@
     if (!flow) flow = &p->link;
     else {
         if (flow->vcc)
-            ATM_SKB(skb)->atm_options = flow->vcc->atm_options;
+            ATM_SKB(*skb)->atm_options = flow->vcc->atm_options;
             /*@@@ looks good ... but it's not supposed to work :-)*/
 #ifdef CONFIG_NET_CLS_POLICE
         switch (result) {
             case TC_POLICE_SHOT:
-                kfree_skb(skb);
+                IMPLICIT_DROP();
                 break;
             case TC_POLICE_RECLASSIFY:
                 if (flow->excess) flow = flow->excess;
                 else {
-                    ATM_SKB(skb)->atm_options |=
+                    ATM_SKB(*skb)->atm_options |=
                         ATM_ATMOPT_CLP;
                     break;
                 }
@@ -507,8 +507,11 @@
                 struct sk_buff *new;
 
                 new = skb_realloc_headroom(skb,flow->hdr_len);
+                if(!new)
+                    ct_sub_counters(skb);
                 dev_kfree_skb(skb);
-                if (!new) continue;
+                if (!new)
+                    continue;
                 skb = new;
             }
             D2PRINTK("sch_atm_dequeue: ip %p, data %p\n",
@@ -537,12 +540,12 @@
 }
 
 
-static int atm_tc_requeue(struct sk_buff *skb,struct Qdisc *sch)
+static int atm_tc_requeue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
     struct atm_qdisc_data *p = PRIV(sch);
     int ret;
 
-    D2PRINTK("atm_tc_requeue(skb %p,sch %p,[qdisc %p])\n",skb,sch,p);
+    D2PRINTK("atm_tc_requeue(skb %p,sch %p,[qdisc %p])\n",*skb,sch,p);
     ret = p->link.q->ops->requeue(skb,p->link.q);
     if (!ret) sch->q.qlen++;
     else {
@@ -553,7 +556,7 @@
 }
 
 
-static unsigned int atm_tc_drop(struct Qdisc *sch)
+static unsigned int atm_tc_drop(struct Qdisc *sch, struct sk_buff ** 
const  skb)
 {
     struct atm_qdisc_data *p = PRIV(sch);
     struct atm_flow_data *flow;
@@ -561,7 +564,7 @@
 
     DPRINTK("atm_tc_drop(sch %p,[qdisc %p])\n",sch,p);
     for (flow = p->flows; flow; flow = flow->next)
-        if (flow->q->ops->drop && (len = flow->q->ops->drop(flow->q)))
+        if (flow->q->ops->drop && (len = flow->q->ops->drop(flow->q, skb)))
             return len;
     return 0;
 }
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_cbq.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_cbq.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_cbq.c    2004-08-05 
10:54:11.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_cbq.c    2004-08-05 
15:36:20.000000000 +0200
@@ -113,7 +113,7 @@
     struct qdisc_rate_table    *R_tab;
 
     /* Overlimit strategy parameters */
-    void            (*overlimit)(struct cbq_class *cl);
+    void            (*overlimit)(struct cbq_class *cl); //FIXME:sandr8 
, struct sk_buff ** const );
     long            penalty;
 
     /* General scheduler (WRR) parameters */
@@ -296,6 +296,7 @@
         }
 
         if (terminal) {
+            ct_sub_counters(skb);
             kfree_skb(skb);
             return NULL;
         }
@@ -417,12 +418,12 @@
 }
 
 static int
-cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch)
+cbq_enqueue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct cbq_sched_data *q = (struct cbq_sched_data *)sch->data;
-    int len = skb->len;
+    int len = (*skb)->len;
     int ret = NET_XMIT_SUCCESS;
-    struct cbq_class *cl = cbq_classify(skb, sch,&ret);
+    struct cbq_class *cl = cbq_classify(*skb, sch,&ret);
 
 #ifdef CONFIG_NET_CLS_POLICE
     q->rx_class = cl;
@@ -445,7 +446,7 @@
 #ifndef CONFIG_NET_CLS_ACT
     sch->stats.drops++;
     if (cl == NULL)
-        kfree_skb(skb);
+        IMPLICIT_DROP();
     else {
         cbq_mark_toplevel(q, cl);
         cl->stats.drops++;
@@ -464,14 +465,14 @@
 }
 
 static int
-cbq_requeue(struct sk_buff *skb, struct Qdisc *sch)
+cbq_requeue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct cbq_sched_data *q = (struct cbq_sched_data *)sch->data;
     struct cbq_class *cl;
     int ret;
 
     if ((cl = q->tx_class) == NULL) {
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         sch->stats.drops++;
         return NET_XMIT_CN;
     }
@@ -625,9 +626,13 @@
 
 static void cbq_ovl_drop(struct cbq_class *cl)
 {
+    struct sk_buff * skb;
+
     if (cl->q->ops->drop)
-        if (cl->q->ops->drop(cl->q))
+        if (cl->q->ops->drop(cl->q, &skb)){
+            ct_sub_counters(skb);
             cl->qdisc->q.qlen--;
+        }
     cl->xstats.overactions++;
     cbq_ovl_classic(cl);
 }
@@ -711,16 +716,16 @@
 
 #ifdef CONFIG_NET_CLS_POLICE
 
-static int cbq_reshape_fail(struct sk_buff *skb, struct Qdisc *child)
+static int cbq_reshape_fail(struct sk_buff ** const skb, struct Qdisc 
*child)
 {
-    int len = skb->len;
+    int len = (*skb)->len;
     struct Qdisc *sch = child->__parent;
     struct cbq_sched_data *q = (struct cbq_sched_data *)sch->data;
     struct cbq_class *cl = q->rx_class;
 
     q->rx_class = NULL;
 
-    if (cl && (cl = cbq_reclassify(skb, cl)) != NULL) {
+    if (cl && (cl = cbq_reclassify(*skb, cl)) != NULL) {
 
         cbq_mark_toplevel(q, cl);
 
@@ -1268,7 +1273,7 @@
     }
 }
 
-static unsigned int cbq_drop(struct Qdisc* sch)
+static unsigned int cbq_drop(struct Qdisc* sch, struct sk_buff ** 
const  skb)
 {
     struct cbq_sched_data *q = (struct cbq_sched_data *)sch->data;
     struct cbq_class *cl, *cl_head;
@@ -1281,7 +1286,7 @@
 
         cl = cl_head;
         do {
-            if (cl->q->ops->drop && (len = cl->q->ops->drop(cl->q))) {
+            if (cl->q->ops->drop && (len = cl->q->ops->drop(cl->q, skb))) {
                 sch->q.qlen--;
                 return len;
             }
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_dsmark.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_dsmark.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_dsmark.c    2004-06-16 
07:18:59.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_dsmark.c    2004-08-05 
12:55:00.000000000 +0200
@@ -186,38 +186,38 @@
 /* --------------------------- Qdisc operations 
---------------------------- */
 
 
-static int dsmark_enqueue(struct sk_buff *skb,struct Qdisc *sch)
+static int dsmark_enqueue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
     struct dsmark_qdisc_data *p = PRIV(sch);
     struct tcf_result res;
     int result;
     int ret = NET_XMIT_POLICED;
 
-    D2PRINTK("dsmark_enqueue(skb %p,sch %p,[qdisc %p])\n",skb,sch,p);
+    D2PRINTK("dsmark_enqueue(skb %p,sch %p,[qdisc %p])\n",*skb,sch,p);
     if (p->set_tc_index) {
         /* FIXME: Safe with non-linear skbs? --RR */
-        switch (skb->protocol) {
+        switch ((*skb)->protocol) {
             case __constant_htons(ETH_P_IP):
-                skb->tc_index = ipv4_get_dsfield(skb->nh.iph);
+                (*skb)->tc_index = ipv4_get_dsfield((*skb)->nh.iph);
                 break;
             case __constant_htons(ETH_P_IPV6):
-                skb->tc_index = ipv6_get_dsfield(skb->nh.ipv6h);
+                (*skb)->tc_index = ipv6_get_dsfield((*skb)->nh.ipv6h);
                 break;
             default:
-                skb->tc_index = 0;
+                (*skb)->tc_index = 0;
                 break;
         };
     }
     result = TC_POLICE_OK; /* be nice to gcc */
-    if (TC_H_MAJ(skb->priority) == sch->handle) {
-        skb->tc_index = TC_H_MIN(skb->priority);
+    if (TC_H_MAJ((*skb)->priority) == sch->handle) {
+        (*skb)->tc_index = TC_H_MIN((*skb)->priority);
     } else {
-        result = tc_classify(skb,p->filter_list,&res);
+        result = tc_classify(*skb,p->filter_list,&res);
         D2PRINTK("result %d class 0x%04x\n",result,res.classid);
         switch (result) {
 #ifdef CONFIG_NET_CLS_POLICE
             case TC_POLICE_SHOT:
-                kfree_skb(skb);
+                IMPLICIT_DROP(); /* this whole ifdef will never be 
coded! */
                 break;
 #if 0
             case TC_POLICE_RECLASSIFY:
@@ -225,13 +225,13 @@
 #endif
 #endif
             case TC_POLICE_OK:
-                skb->tc_index = TC_H_MIN(res.classid);
+                (*skb)->tc_index = TC_H_MIN(res.classid);
                 break;
             case TC_POLICE_UNSPEC:
                 /* fall through */
             default:
                 if (p->default_index != NO_DEFAULT_INDEX)
-                    skb->tc_index = p->default_index;
+                    (*skb)->tc_index = p->default_index;
                 break;
         };
     }
@@ -240,11 +240,11 @@
         result == TC_POLICE_SHOT ||
 #endif
 
-        ((ret = p->q->enqueue(skb,p->q)) != 0)) {
+        (0x1 & (ret = p->q->enqueue(skb,p->q))) ) {
         sch->stats.drops++;
         return ret;
     }
-    sch->stats.bytes += skb->len;
+    sch->stats.bytes += (*skb)->len;
     sch->stats.packets++;
     sch->q.qlen++;
     return ret;
@@ -289,12 +289,12 @@
 }
 
 
-static int dsmark_requeue(struct sk_buff *skb,struct Qdisc *sch)
+static int dsmark_requeue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
     int ret;
     struct dsmark_qdisc_data *p = PRIV(sch);
 
-    D2PRINTK("dsmark_requeue(skb %p,sch %p,[qdisc %p])\n",skb,sch,p);
+    D2PRINTK("dsmark_requeue(skb %p,sch %p,[qdisc %p])\n",*skb,sch,p);
         if ((ret = p->q->ops->requeue(skb, p->q)) == 0) {
         sch->q.qlen++;
         return 0;
@@ -304,7 +304,7 @@
 }
 
 
-static unsigned int dsmark_drop(struct Qdisc *sch)
+static unsigned int dsmark_drop(struct Qdisc *sch, struct sk_buff ** 
const  skb)
 {
     struct dsmark_qdisc_data *p = PRIV(sch);
     unsigned int len;
@@ -312,7 +312,7 @@
     DPRINTK("dsmark_reset(sch %p,[qdisc %p])\n",sch,p);
     if (!p->q->ops->drop)
         return 0;
-    if (!(len = p->q->ops->drop(p->q)))
+    if (!(len = p->q->ops->drop(p->q, skb)))
         return 0;
     sch->q.qlen--;
     return len;
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_fifo.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_fifo.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_fifo.c    2004-06-16 
07:19:01.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_fifo.c    2004-08-05 
12:55:00.000000000 +0200
@@ -43,30 +43,34 @@
 };
 
 static int
-bfifo_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+bfifo_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct fifo_sched_data *q = (struct fifo_sched_data *)sch->data;
 
-    if (sch->stats.backlog + skb->len <= q->limit) {
-        __skb_queue_tail(&sch->q, skb);
-        sch->stats.backlog += skb->len;
-        sch->stats.bytes += skb->len;
+    if (sch->stats.backlog + (*skb)->len <= q->limit) {
+        __skb_queue_tail(&sch->q, *skb);
+        sch->stats.backlog += (*skb)->len;
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         return 0;
     }
     sch->stats.drops++;
 #ifdef CONFIG_NET_CLS_POLICE
-    if (sch->reshape_fail==NULL || sch->reshape_fail(skb, sch))
+    if (sch->reshape_fail==NULL || sch->reshape_fail(skb, sch)){
+#endif
+        IMPLICIT_DROP();
+        return NET_XMIT_DROP;
+#ifdef CONFIG_NET_CLS_POLICE
+    }
+    return NET_XMIT_RESHAPED;
 #endif
-        kfree_skb(skb);
-    return NET_XMIT_DROP;
 }
 
 static int
-bfifo_requeue(struct sk_buff *skb, struct Qdisc* sch)
+bfifo_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
-    __skb_queue_head(&sch->q, skb);
-    sch->stats.backlog += skb->len;
+    __skb_queue_head(&sch->q, *skb);
+    sch->stats.backlog += (*skb)->len;
     return 0;
 }
 
@@ -82,15 +86,13 @@
 }
 
 static unsigned int
-fifo_drop(struct Qdisc* sch)
+fifo_drop(struct Qdisc* sch, struct sk_buff ** const  skb)
 {
-    struct sk_buff *skb;
-
-    skb = __skb_dequeue_tail(&sch->q);
-    if (skb) {
-        unsigned int len = skb->len;
+    *skb = __skb_dequeue_tail(&sch->q);
+    if (*skb) {
+        unsigned int len = (*skb)->len;
         sch->stats.backlog -= len;
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         return len;
     }
     return 0;
@@ -104,28 +106,33 @@
 }
 
 static int
-pfifo_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+pfifo_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct fifo_sched_data *q = (struct fifo_sched_data *)sch->data;
 
     if (sch->q.qlen < q->limit) {
-        __skb_queue_tail(&sch->q, skb);
-        sch->stats.bytes += skb->len;
+        __skb_queue_tail(&sch->q, *skb);
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         return 0;
     }
     sch->stats.drops++;
+
+#ifdef CONFIG_NET_CLS_POLICE
+    if (sch->reshape_fail==NULL || sch->reshape_fail(skb, sch)){
+#endif
+        IMPLICIT_DROP();
+        return NET_XMIT_DROP;
 #ifdef CONFIG_NET_CLS_POLICE
-    if (sch->reshape_fail==NULL || sch->reshape_fail(skb, sch))
+    }
+    return NET_XMIT_RESHAPED;
 #endif
-        kfree_skb(skb);
-    return NET_XMIT_DROP;
 }
 
 static int
-pfifo_requeue(struct sk_buff *skb, struct Qdisc* sch)
+pfifo_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
-    __skb_queue_head(&sch->q, skb);
+    __skb_queue_head(&sch->q, *skb);
     return 0;
 }
 
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_generic.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_generic.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_generic.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_generic.c    2004-08-05 
15:34:51.000000000 +0200
@@ -129,6 +129,7 @@
                packet when deadloop is detected.
              */
             if (dev->xmit_lock_owner == smp_processor_id()) {
+                ct_sub_counters(skb);
                 kfree_skb(skb);
                 if (net_ratelimit())
                     printk(KERN_DEBUG "Dead loop on netdevice %s, fix 
it urgently!\n", dev->name);
@@ -147,7 +148,7 @@
            3. device is buggy (ppp)
          */
 
-        q->ops->requeue(skb, q);
+        q->ops->requeue(&skb, q);
         netif_schedule(dev);
         return 1;
     }
@@ -215,9 +216,9 @@
  */
 
 static int
-noop_enqueue(struct sk_buff *skb, struct Qdisc * qdisc)
+noop_enqueue(struct sk_buff ** const skb, struct Qdisc * qdisc)
 {
-    kfree_skb(skb);
+    IMPLICIT_DROP();
     return NET_XMIT_CN;
 }
 
@@ -228,11 +229,11 @@
 }
 
 static int
-noop_requeue(struct sk_buff *skb, struct Qdisc* qdisc)
+noop_requeue(struct sk_buff ** const  skb, struct Qdisc* qdisc)
 {
     if (net_ratelimit())
-        printk(KERN_DEBUG "%s deferred output. It is buggy.\n", 
skb->dev->name);
-    kfree_skb(skb);
+        printk(KERN_DEBUG "%s deferred output. It is buggy.\n", 
(*skb)->dev->name);
+    IMPLICIT_DROP();
     return NET_XMIT_CN;
 }
 
@@ -281,22 +282,22 @@
  */
 
 static int
-pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc)
+pfifo_fast_enqueue(struct sk_buff ** const skb, struct Qdisc* qdisc)
 {
     struct sk_buff_head *list;
 
     list = ((struct sk_buff_head*)qdisc->data) +
-        prio2band[skb->priority&TC_PRIO_MAX];
+        prio2band[(*skb)->priority&TC_PRIO_MAX];
 
     if (list->qlen < qdisc->dev->tx_queue_len) {
-        __skb_queue_tail(list, skb);
+        __skb_queue_tail(list, (*skb));
         qdisc->q.qlen++;
-        qdisc->stats.bytes += skb->len;
+        qdisc->stats.bytes += (*skb)->len;
         qdisc->stats.packets++;
         return 0;
     }
     qdisc->stats.drops++;
-    kfree_skb(skb);
+    IMPLICIT_DROP();
     return NET_XMIT_DROP;
 }
 
@@ -318,14 +319,14 @@
 }
 
 static int
-pfifo_fast_requeue(struct sk_buff *skb, struct Qdisc* qdisc)
+pfifo_fast_requeue(struct sk_buff ** const  skb, struct Qdisc* qdisc)
 {
     struct sk_buff_head *list;
 
     list = ((struct sk_buff_head*)qdisc->data) +
-        prio2band[skb->priority&TC_PRIO_MAX];
+        prio2band[(*skb)->priority&TC_PRIO_MAX];
 
-    __skb_queue_head(list, skb);
+    __skb_queue_head(list, *skb);
     qdisc->q.qlen++;
     return 0;
 }
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_gred.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_gred.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_gred.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_gred.c    2004-08-05 
12:55:00.000000000 +0200
@@ -102,7 +102,7 @@
 };
 
 static int
-gred_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+gred_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     psched_time_t now;
     struct gred_sched_data *q=NULL;
@@ -116,7 +116,7 @@
     }
 
 
-    if ( ((skb->tc_index&0xf) > (t->DPs -1)) || 
!(q=t->tab[skb->tc_index&0xf])) {
+    if ( (((*skb)->tc_index&0xf) > (t->DPs -1)) || 
!(q=t->tab[(*skb)->tc_index&0xf])) {
         printk("GRED: setting to default (%d)\n ",t->def);
         if (!(q=t->tab[t->def])) {
             DPRINTK("GRED: setting to default FAILED! dropping!! "
@@ -125,11 +125,11 @@
         }
         /* fix tc_index? --could be controvesial but needed for
            requeueing */
-        skb->tc_index=(skb->tc_index&0xfffffff0) | t->def;
+        (*skb)->tc_index=((*skb)->tc_index&0xfffffff0) | t->def;
     }
 
     D2PRINTK("gred_enqueue virtualQ 0x%x classid %x backlog %d "
-        "general backlog %d\n",skb->tc_index&0xf,sch->handle,q->backlog,
+        "general backlog %d\n",(*skb)->tc_index&0xf,sch->handle,q->backlog,
         sch->stats.backlog);
     /* sum up all the qaves of prios <= to ours to get the new qave*/
     if (!t->eqp && t->grio) {
@@ -144,7 +144,7 @@
     }
 
     q->packetsin++;
-    q->bytesin+=skb->len;
+    q->bytesin+=(*skb)->len;
 
     if (t->eqp && t->grio) {
         qave=0;
@@ -175,12 +175,12 @@
     if ((q->qave+qave) < q->qth_min) {
         q->qcount = -1;
 enqueue:
-        if (q->backlog + skb->len <= q->limit) {
-            q->backlog += skb->len;
+        if (q->backlog + (*skb)->len <= q->limit) {
+            q->backlog += (*skb)->len;
 do_enqueue:
-            __skb_queue_tail(&sch->q, skb);
-            sch->stats.backlog += skb->len;
-            sch->stats.bytes += skb->len;
+            __skb_queue_tail(&sch->q, *skb);
+            sch->stats.backlog += (*skb)->len;
+            sch->stats.bytes += (*skb)->len;
             sch->stats.packets++;
             return 0;
         } else {
@@ -188,7 +188,7 @@
         }
 
 drop:
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         sch->stats.drops++;
         return NET_XMIT_DROP;
     }
@@ -212,17 +212,17 @@
 }
 
 static int
-gred_requeue(struct sk_buff *skb, struct Qdisc* sch)
+gred_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct gred_sched_data *q;
     struct gred_sched *t= (struct gred_sched *)sch->data;
-    q= t->tab[(skb->tc_index&0xf)];
+    q= t->tab[((*skb)->tc_index&0xf)];
 /* error checking here -- probably unnecessary */
     PSCHED_SET_PASTPERFECT(q->qidlestart);
 
-    __skb_queue_head(&sch->q, skb);
-    sch->stats.backlog += skb->len;
-    q->backlog += skb->len;
+    __skb_queue_head(&sch->q, *skb);
+    sch->stats.backlog += (*skb)->len;
+    q->backlog += (*skb)->len;
     return 0;
 }
 
@@ -259,29 +259,27 @@
     return NULL;
 }
 
-static unsigned int gred_drop(struct Qdisc* sch)
+static unsigned int gred_drop(struct Qdisc* sch, struct sk_buff ** 
const  skb)
 {
-    struct sk_buff *skb;
-
     struct gred_sched_data *q;
     struct gred_sched *t= (struct gred_sched *)sch->data;
 
-    skb = __skb_dequeue_tail(&sch->q);
-    if (skb) {
-        unsigned int len = skb->len;
+    *skb = __skb_dequeue_tail(&sch->q);
+    if (*skb) {
+        unsigned int len = (*skb)->len;
         sch->stats.backlog -= len;
         sch->stats.drops++;
-        q= t->tab[(skb->tc_index&0xf)];
+        q= t->tab[((*skb)->tc_index&0xf)];
         if (q) {
             q->backlog -= len;
             q->other++;
             if (!q->backlog && !t->eqp)
                 PSCHED_GET_TIME(q->qidlestart);
         } else {
-            D2PRINTK("gred_dequeue: skb has bad tcindex 
%x\n",skb->tc_index&0xf);
+            D2PRINTK("gred_dequeue: skb has bad tcindex 
%x\n",(*skb)->tc_index&0xf);
         }
 
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         return len;
     }
 
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_hfsc.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_hfsc.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_hfsc.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_hfsc.c    2004-08-05 
15:36:47.000000000 +0200
@@ -967,7 +967,8 @@
         return 0;
     }
     len = skb->len;
-    if (unlikely(sch->ops->requeue(skb, sch) != NET_XMIT_SUCCESS)) {
+    if (unlikely(sch->ops->requeue(&skb, sch) != NET_XMIT_SUCCESS)) {
+        ct_sub_counters(skb);
         if (net_ratelimit())
             printk("qdisc_peek_len: failed to requeue\n");
         return 0;
@@ -1272,6 +1273,7 @@
         }
 
         if (terminal) {
+            ct_sub_counters(skb);
             kfree_skb(skb);
             return NULL;
         }
@@ -1685,11 +1687,11 @@
 }
 
 static int
-hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch)
+hfsc_enqueue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     int ret = NET_XMIT_SUCCESS;
-    struct hfsc_class *cl = hfsc_classify(skb, sch, &ret);
-    unsigned int len = skb->len;
+    struct hfsc_class *cl = hfsc_classify(*skb, sch, &ret);
+    unsigned int len = (*skb)->len;
     int err;
 
 
@@ -1702,14 +1704,14 @@
     }
 #else
     if (cl == NULL) {
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         sch->stats.drops++;
         return NET_XMIT_DROP;
     }
 #endif
 
     err = cl->qdisc->enqueue(skb, cl->qdisc);
-    if (unlikely(err != NET_XMIT_SUCCESS)) {
+    if (unlikely(any_dropped(err))) {
         cl->stats.drops++;
         sch->stats.drops++;
         return err;
@@ -1797,17 +1799,17 @@
 }
 
 static int
-hfsc_requeue(struct sk_buff *skb, struct Qdisc *sch)
+hfsc_requeue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct hfsc_sched *q = (struct hfsc_sched *)sch->data;
 
-    __skb_queue_head(&q->requeue, skb);
+    __skb_queue_head(&q->requeue, *skb);
     sch->q.qlen++;
     return NET_XMIT_SUCCESS;
 }
 
 static unsigned int
-hfsc_drop(struct Qdisc *sch)
+hfsc_drop(struct Qdisc *sch, struct sk_buff ** const  skb)
 {
     struct hfsc_sched *q = (struct hfsc_sched *)sch->data;
     struct hfsc_class *cl;
@@ -1815,7 +1817,7 @@
 
     list_for_each_entry(cl, &q->droplist, dlist) {
         if (cl->qdisc->ops->drop != NULL &&
-            (len = cl->qdisc->ops->drop(cl->qdisc)) > 0) {
+            (len = cl->qdisc->ops->drop(cl->qdisc, skb)) > 0) {
             if (cl->qdisc->q.qlen == 0) {
                 update_vf(cl, 0, 0);
                 set_passive(cl);
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_htb.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_htb.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_htb.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_htb.c    2004-08-05 
15:25:34.000000000 +0200
@@ -335,7 +335,7 @@
         }
 
         if (terminal) {
-            kfree_skb(skb);
+            IMPLICIT_DROP();
             return NULL;
         }
 #else
@@ -709,17 +709,17 @@
     list_del_init(&cl->un.leaf.drop_list);
 }
 
-static int htb_enqueue(struct sk_buff *skb, struct Qdisc *sch)
+static int htb_enqueue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     int ret = NET_XMIT_SUCCESS;
     struct htb_sched *q = (struct htb_sched *)sch->data;
-    struct htb_class *cl = htb_classify(skb,sch,&ret);
+    struct htb_class *cl = htb_classify(*skb,sch,&ret);
 
 
 #ifdef CONFIG_NET_CLS_ACT
     if (cl == HTB_DIRECT ) {
     if (q->direct_queue.qlen < q->direct_qlen ) {
-        __skb_queue_tail(&q->direct_queue, skb);
+        __skb_queue_tail(&q->direct_queue, *skb);
         q->direct_pkts++;
     }
     } else if (!cl) {
@@ -732,10 +732,10 @@
     if (cl == HTB_DIRECT || !cl) {
     /* enqueue to helper queue */
     if (q->direct_queue.qlen < q->direct_qlen && cl) {
-        __skb_queue_tail(&q->direct_queue, skb);
+        __skb_queue_tail(&q->direct_queue, *skb);
         q->direct_pkts++;
     } else {
-        kfree_skb (skb);
+        IMPLICIT_DROP();
         sch->stats.drops++;
         return NET_XMIT_DROP;
     }
@@ -746,32 +746,31 @@
     cl->stats.drops++;
     return NET_XMIT_DROP;
     } else {
-    cl->stats.packets++; cl->stats.bytes += skb->len;
+    cl->stats.packets++; cl->stats.bytes += (*skb)->len;
     htb_activate (q,cl);
     }
 
     sch->q.qlen++;
-    sch->stats.packets++; sch->stats.bytes += skb->len;
-    HTB_DBG(1,1,"htb_enq_ok cl=%X skb=%p\n",(cl && cl != 
HTB_DIRECT)?cl->classid:0,skb);
+    sch->stats.packets++; sch->stats.bytes += (*skb)->len;
+    HTB_DBG(1,1,"htb_enq_ok cl=%X skb=%p\n",(cl && cl != 
HTB_DIRECT)?cl->classid:0,*skb);
     return NET_XMIT_SUCCESS;
 }
 
 /* TODO: requeuing packet charges it to policers again !! */
-static int htb_requeue(struct sk_buff *skb, struct Qdisc *sch)
+static int htb_requeue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct htb_sched *q = (struct htb_sched *)sch->data;
     int ret =  NET_XMIT_SUCCESS;
-    struct htb_class *cl = htb_classify(skb,sch, &ret);
-    struct sk_buff *tskb;
+    struct htb_class *cl = htb_classify(*skb,sch, &ret);
 
     if (cl == HTB_DIRECT || !cl) {
     /* enqueue to helper queue */
     if (q->direct_queue.qlen < q->direct_qlen && cl) {
-        __skb_queue_head(&q->direct_queue, skb);
+        __skb_queue_head(&q->direct_queue, *skb);
     } else {
-            __skb_queue_head(&q->direct_queue, skb);
-            tskb = __skb_dequeue_tail(&q->direct_queue);
-            kfree_skb (tskb);
+            __skb_queue_head(&q->direct_queue, *skb);
+            *skb = __skb_dequeue_tail(&q->direct_queue);
+            IMPLICIT_DROP();
             sch->stats.drops++;
             return NET_XMIT_CN;   
     }
@@ -783,7 +782,7 @@
         htb_activate (q,cl);
 
     sch->q.qlen++;
-    HTB_DBG(1,1,"htb_req_ok cl=%X skb=%p\n",(cl && cl != 
HTB_DIRECT)?cl->classid:0,skb);
+    HTB_DBG(1,1,"htb_req_ok cl=%X skb=%p\n",(cl && cl != 
HTB_DIRECT)?cl->classid:0,*skb);
     return NET_XMIT_SUCCESS;
 }
 
@@ -1145,7 +1144,7 @@
 }
 
 /* try to drop from each class (by prio) until one succeed */
-static unsigned int htb_drop(struct Qdisc* sch)
+static unsigned int htb_drop(struct Qdisc* sch, struct sk_buff ** 
const  skb)
 {
     struct htb_sched *q = (struct htb_sched *)sch->data;
     int prio;
@@ -1157,7 +1156,7 @@
                               un.leaf.drop_list);
             unsigned int len;
             if (cl->un.leaf.q->ops->drop &&
-                (len = cl->un.leaf.q->ops->drop(cl->un.leaf.q))) {
+                (len = cl->un.leaf.q->ops->drop(cl->un.leaf.q, skb))) {
                 sch->q.qlen--;
                 if (!cl->un.leaf.q->q.qlen)
                     htb_deactivate (q,cl);
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_ingress.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_ingress.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_ingress.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_ingress.c    2004-08-05 
15:29:42.000000000 +0200
@@ -137,14 +137,14 @@
 /* --------------------------- Qdisc operations 
---------------------------- */
 
 
-static int ingress_enqueue(struct sk_buff *skb,struct Qdisc *sch)
+static int ingress_enqueue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
     struct ingress_qdisc_data *p = PRIV(sch);
     struct tcf_result res;
     int result;
 
-    D2PRINTK("ingress_enqueue(skb %p,sch %p,[qdisc %p])\n", skb, sch, p);
-    result = tc_classify(skb, p->filter_list, &res);
+    D2PRINTK("ingress_enqueue(skb %p,sch %p,[qdisc %p])\n", *skb, sch, p);
+    result = tc_classify(*skb, p->filter_list, &res);
     D2PRINTK("result %d class 0x%04x\n", result, res.classid);
     /*
      * Unlike normal "enqueue" functions, ingress_enqueue returns a
@@ -152,7 +152,7 @@
      */
 #ifdef CONFIG_NET_CLS_ACT
     sch->stats.packets++;
-    sch->stats.bytes += skb->len;
+    sch->stats.bytes += (*skb)->len;
     switch (result) {
         case TC_ACT_SHOT:
             result = TC_ACT_SHOT;
@@ -166,7 +166,7 @@
         case TC_ACT_OK:
         case TC_ACT_UNSPEC:
         default:
-            skb->tc_index = TC_H_MIN(res.classid);
+            (*skb)->tc_index = TC_H_MIN(res.classid);
             result = TC_ACT_OK;
             break;
     };
@@ -183,7 +183,7 @@
         case TC_POLICE_UNSPEC:
         default:
         sch->stats.packets++;
-        sch->stats.bytes += skb->len;
+        sch->stats.bytes += (*skb)->len;
         result = NF_ACCEPT;
         break;
     };
@@ -192,7 +192,7 @@
     D2PRINTK("Overriding result to ACCEPT\n");
     result = NF_ACCEPT;
     sch->stats.packets++;
-    sch->stats.bytes += skb->len;
+    sch->stats.bytes += (*skb)->len;
 #endif
 #endif
 
@@ -210,21 +210,24 @@
 }
 
 
-static int ingress_requeue(struct sk_buff *skb,struct Qdisc *sch)
+static int ingress_requeue(struct sk_buff ** const skb,struct Qdisc *sch)
 {
 /*
     struct ingress_qdisc_data *p = PRIV(sch);
-    D2PRINTK("ingress_requeue(skb %p,sch %p,[qdisc 
%p])\n",skb,sch,PRIV(p));
+    D2PRINTK("ingress_requeue(skb %p,sch %p,[qdisc 
%p])\n",*skb,sch,PRIV(p));
 */
     return 0;
 }
 
-static unsigned int ingress_drop(struct Qdisc *sch)
+static unsigned int ingress_drop(struct Qdisc *sch, struct sk_buff ** 
const skb)
 {
 #ifdef DEBUG_INGRESS
     struct ingress_qdisc_data *p = PRIV(sch);
 #endif
     DPRINTK("ingress_drop(sch %p,[qdisc %p])\n", sch, p);
+   
+    *skb=NULL;
+   
     return 0;
 }
 
@@ -254,8 +257,12 @@
 
     if (dev->qdisc_ingress) {
         spin_lock(&dev->queue_lock);
-        if ((q = dev->qdisc_ingress) != NULL)
-            fwres = q->enqueue(skb, q);
+        if ((q = dev->qdisc_ingress) != NULL){
+            fwres = q->enqueue(pskb, q);
+            if(any_dropped(fwres)){
+                ct_sub_counters(*pskb);
+            }
+        }
         spin_unlock(&dev->queue_lock);
         }
            
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_netem.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_netem.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_netem.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_netem.c    2004-08-05 
16:23:57.000000000 +0200
@@ -601,14 +601,14 @@
 /* Enqueue packets with underlying discipline (fifo)
  * but mark them with current time first.
  */
-static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch)
+static int netem_enqueue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct netem_sched_data *q = (struct netem_sched_data *)sch->data;
-    struct netem_skb_cb *cb = (struct netem_skb_cb *)skb->cb;
+    struct netem_skb_cb *cb = (struct netem_skb_cb *)(*skb)->cb;
     psched_time_t now;
     long delay;
 
-    pr_debug("netem_enqueue skb=%p @%lu\n", skb, jiffies);
+    pr_debug("netem_enqueue skb=%p @%lu\n", *skb, jiffies);
 
     /* Random packet drop 0 => none, ~0 => all */
     if (q->loss && q->loss >= net_random()) {
@@ -644,20 +644,20 @@
    
     /* Always queue at tail to keep packets in order */
     if (likely(q->delayed.qlen < q->limit)) {
-        __skb_queue_tail(&q->delayed, skb);
+        __skb_queue_tail(&q->delayed, *skb);
         sch->q.qlen++;
-        sch->stats.bytes += skb->len;
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         return 0;
     }
 
     sch->stats.drops++;
-    kfree_skb(skb);
+    IMPLICIT_DROP();
     return NET_XMIT_DROP;
 }
 
 /* Requeue packets but don't change time stamp */
-static int netem_requeue(struct sk_buff *skb, struct Qdisc *sch)
+static int netem_requeue(struct sk_buff ** const skb, struct Qdisc *sch)
 {
     struct netem_sched_data *q = (struct netem_sched_data *)sch->data;
     int ret;
@@ -668,12 +668,12 @@
     return ret;
 }
 
-static unsigned int netem_drop(struct Qdisc* sch)
+static unsigned int netem_drop(struct Qdisc* sch, struct sk_buff ** 
const skb)
 {
     struct netem_sched_data *q = (struct netem_sched_data *)sch->data;
     unsigned int len;
 
-    if ((len = q->qdisc->ops->drop(q->qdisc)) != 0) {
+    if ((len = q->qdisc->ops->drop(q->qdisc, skb)) != 0) {
         sch->q.qlen--;
         sch->stats.drops++;
     }
@@ -706,7 +706,7 @@
         }
         __skb_unlink(skb, &q->delayed);
 
-        if (q->qdisc->enqueue(skb, q->qdisc))
+        if (q->qdisc->enqueue(&skb, q->qdisc))
             sch->stats.drops++;
     }
 
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_prio.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_prio.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_prio.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_prio.c    2004-08-05 
16:19:16.000000000 +0200
@@ -74,6 +74,7 @@
             break;
         };
         if (terminal) {
+            ct_sub_counters(skb);
             kfree_skb(skb);
             return NULL;
         }
@@ -96,18 +97,18 @@
 }
 
 static int
-prio_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+prio_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct Qdisc *qdisc;
     int ret = NET_XMIT_SUCCESS;
 
-    qdisc = prio_classify(skb, sch, &ret);
+    qdisc = prio_classify(*skb, sch, &ret);
 
     if (NULL == qdisc)
         goto dropped;
 
     if ((ret = qdisc->enqueue(skb, qdisc)) == NET_XMIT_SUCCESS) {
-        sch->stats.bytes += skb->len;
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         sch->q.qlen++;
         return NET_XMIT_SUCCESS;
@@ -128,12 +129,12 @@
 
 
 static int
-prio_requeue(struct sk_buff *skb, struct Qdisc* sch)
+prio_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct Qdisc *qdisc;
     int ret = NET_XMIT_DROP;
 
-    qdisc = prio_classify(skb, sch, &ret);
+    qdisc = prio_classify(*skb, sch, &ret);
     if (qdisc == NULL)
         goto dropped;
 
@@ -167,7 +168,7 @@
 
 }
 
-static unsigned int prio_drop(struct Qdisc* sch)
+static unsigned int prio_drop(struct Qdisc* sch, struct sk_buff ** 
const  skb)
 {
     struct prio_sched_data *q = (struct prio_sched_data *)sch->data;
     int prio;
@@ -176,7 +177,7 @@
 
     for (prio = q->bands-1; prio >= 0; prio--) {
         qdisc = q->queues[prio];
-        if ((len = qdisc->ops->drop(qdisc)) != 0) {
+        if ((len = qdisc->ops->drop(qdisc, skb)) != 0) {
             sch->q.qlen--;
             return len;
         }
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_red.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_red.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_red.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_red.c    2004-08-05 
12:55:00.000000000 +0200
@@ -178,7 +178,7 @@
 }
 
 static int
-red_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+red_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct red_sched_data *q = (struct red_sched_data *)sch->data;
 
@@ -242,16 +242,16 @@
     if (q->qave < q->qth_min) {
         q->qcount = -1;
 enqueue:
-        if (sch->stats.backlog + skb->len <= q->limit) {
-            __skb_queue_tail(&sch->q, skb);
-            sch->stats.backlog += skb->len;
-            sch->stats.bytes += skb->len;
+        if (sch->stats.backlog + (*skb)->len <= q->limit) {
+            __skb_queue_tail(&sch->q, *skb);
+            sch->stats.backlog += (*skb)->len;
+            sch->stats.bytes += (*skb)->len;
             sch->stats.packets++;
             return NET_XMIT_SUCCESS;
         } else {
             q->st.pdrop++;
         }
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         sch->stats.drops++;
         return NET_XMIT_DROP;
     }
@@ -259,7 +259,7 @@
         q->qcount = -1;
         sch->stats.overlimits++;
 mark:
-        if  (!(q->flags&TC_RED_ECN) || !red_ecn_mark(skb)) {
+        if  (!(q->flags&TC_RED_ECN) || !red_ecn_mark(*skb)) {
             q->st.early++;
             goto drop;
         }
@@ -295,20 +295,20 @@
     goto enqueue;
 
 drop:
-    kfree_skb(skb);
+    IMPLICIT_DROP();
     sch->stats.drops++;
     return NET_XMIT_CN;
 }
 
 static int
-red_requeue(struct sk_buff *skb, struct Qdisc* sch)
+red_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct red_sched_data *q = (struct red_sched_data *)sch->data;
 
     PSCHED_SET_PASTPERFECT(q->qidlestart);
 
-    __skb_queue_head(&sch->q, skb);
-    sch->stats.backlog += skb->len;
+    __skb_queue_head(&sch->q, *skb);
+    sch->stats.backlog += (*skb)->len;
     return 0;
 }
 
@@ -327,18 +327,17 @@
     return NULL;
 }
 
-static unsigned int red_drop(struct Qdisc* sch)
+static unsigned int red_drop(struct Qdisc* sch, struct sk_buff ** 
const  skb)
 {
-    struct sk_buff *skb;
     struct red_sched_data *q = (struct red_sched_data *)sch->data;
 
-    skb = __skb_dequeue_tail(&sch->q);
-    if (skb) {
-        unsigned int len = skb->len;
+    *skb = __skb_dequeue_tail(&sch->q);
+    if (*skb) {
+        unsigned int len = (*skb)->len;
         sch->stats.backlog -= len;
         sch->stats.drops++;
         q->st.other++;
-        kfree_skb(skb);
+        IMPLICIT_DROP();
         return len;
     }
     PSCHED_GET_TIME(q->qidlestart);
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_sfq.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_sfq.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_sfq.c    2004-06-16 
07:20:03.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_sfq.c    2004-08-05 
15:42:55.000000000 +0200
@@ -209,11 +209,10 @@
     sfq_link(q, x);
 }
 
-static unsigned int sfq_drop(struct Qdisc *sch)
+static unsigned int sfq_drop(struct Qdisc *sch, struct sk_buff ** const 
skb)
 {
     struct sfq_sched_data *q = (struct sfq_sched_data *)sch->data;
     sfq_index d = q->max_depth;
-    struct sk_buff *skb;
     unsigned int len;
 
     /* Queue is full! Find the longest slot and
@@ -221,10 +220,10 @@
 
     if (d > 1) {
         sfq_index x = q->dep[d+SFQ_DEPTH].next;
-        skb = q->qs[x].prev;
-        len = skb->len;
-        __skb_unlink(skb, &q->qs[x]);
-        kfree_skb(skb);
+        *skb = q->qs[x].prev;
+        len = (*skb)->len;
+        __skb_unlink(*skb, &q->qs[x]);
+        IMPLICIT_DROP();
         sfq_dec(q, x);
         sch->q.qlen--;
         sch->stats.drops++;
@@ -236,10 +235,10 @@
         d = q->next[q->tail];
         q->next[q->tail] = q->next[d];
         q->allot[q->next[d]] += q->quantum;
-        skb = q->qs[d].prev;
-        len = skb->len;
-        __skb_unlink(skb, &q->qs[d]);
-        kfree_skb(skb);
+        *skb = q->qs[d].prev;
+        len = (*skb)->len;
+        __skb_unlink(*skb, &q->qs[d]);
+        IMPLICIT_DROP();
         sfq_dec(q, d);
         sch->q.qlen--;
         q->ht[q->hash[d]] = SFQ_DEPTH;
@@ -251,10 +250,10 @@
 }
 
 static int
-sfq_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+sfq_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct sfq_sched_data *q = (struct sfq_sched_data *)sch->data;
-    unsigned hash = sfq_hash(q, skb);
+    unsigned hash = sfq_hash(q, *skb);
     sfq_index x;
 
     x = q->ht[hash];
@@ -262,7 +261,7 @@
         q->ht[hash] = x = q->dep[SFQ_DEPTH].next;
         q->hash[x] = hash;
     }
-    __skb_queue_tail(&q->qs[x], skb);
+    __skb_queue_tail(&q->qs[x], *skb);
     sfq_inc(q, x);
     if (q->qs[x].qlen == 1) {        /* The flow is new */
         if (q->tail == SFQ_DEPTH) {    /* It is the first flow */
@@ -276,20 +275,20 @@
         }
     }
     if (++sch->q.qlen < q->limit-1) {
-        sch->stats.bytes += skb->len;
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         return 0;
     }
 
-    sfq_drop(sch);
+    sfq_drop(sch, skb);
     return NET_XMIT_CN;
 }
 
 static int
-sfq_requeue(struct sk_buff *skb, struct Qdisc* sch)
+sfq_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct sfq_sched_data *q = (struct sfq_sched_data *)sch->data;
-    unsigned hash = sfq_hash(q, skb);
+    unsigned hash = sfq_hash(q, *skb);
     sfq_index x;
 
     x = q->ht[hash];
@@ -297,7 +296,7 @@
         q->ht[hash] = x = q->dep[SFQ_DEPTH].next;
         q->hash[x] = hash;
     }
-    __skb_queue_head(&q->qs[x], skb);
+    __skb_queue_head(&q->qs[x], *skb);
     sfq_inc(q, x);
     if (q->qs[x].qlen == 1) {        /* The flow is new */
         if (q->tail == SFQ_DEPTH) {    /* It is the first flow */
@@ -314,7 +313,7 @@
         return 0;
 
     sch->stats.drops++;
-    sfq_drop(sch);
+    sfq_drop(sch, skb);
     return NET_XMIT_CN;
 }
 
@@ -362,8 +361,10 @@
 {
     struct sk_buff *skb;
 
-    while ((skb = sfq_dequeue(sch)) != NULL)
+    while ((skb = sfq_dequeue(sch)) != NULL){
+        ct_sub_counters(skb);
         kfree_skb(skb);
+    }
 }
 
 static void sfq_perturbation(unsigned long arg)
@@ -394,8 +395,11 @@
     if (ctl->limit)
         q->limit = min_t(u32, ctl->limit, SFQ_DEPTH);
 
-    while (sch->q.qlen >= q->limit-1)
-        sfq_drop(sch);
+    struct sk_buff * skb;
+    while (sch->q.qlen >= q->limit-1){
+        sfq_drop(sch, &skb);
+        ct_sub_counters(skb);
+    }
 
     del_timer(&q->perturb_timer);
     if (q->perturb_period) {
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_tbf.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_tbf.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_tbf.c    2004-08-05 
10:54:12.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_tbf.c    2004-08-05 
12:55:00.000000000 +0200
@@ -135,19 +135,23 @@
 #define L2T(q,L)   ((q)->R_tab->data[(L)>>(q)->R_tab->rate.cell_log])
 #define L2T_P(q,L) ((q)->P_tab->data[(L)>>(q)->P_tab->rate.cell_log])
 
-static int tbf_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+static int tbf_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct tbf_sched_data *q = (struct tbf_sched_data *)sch->data;
     int ret;
 
-    if (skb->len > q->max_size) {
+    if ((*skb)->len > q->max_size) {
         sch->stats.drops++;
+
 #ifdef CONFIG_NET_CLS_POLICE
-        if (sch->reshape_fail == NULL || sch->reshape_fail(skb, sch))
+        if (sch->reshape_fail==NULL || sch->reshape_fail(skb, sch)){
+#endif
+            IMPLICIT_DROP();
+            return NET_XMIT_DROP;
+#ifdef CONFIG_NET_CLS_POLICE
+        }
+        return NET_XMIT_RESHAPED;
 #endif
-            kfree_skb(skb);
-
-        return NET_XMIT_DROP;
     }
 
     if ((ret = q->qdisc->enqueue(skb, q->qdisc)) != 0) {
@@ -156,12 +160,12 @@
     }
 
     sch->q.qlen++;
-    sch->stats.bytes += skb->len;
+    sch->stats.bytes += (*skb)->len;
     sch->stats.packets++;
     return 0;
 }
 
-static int tbf_requeue(struct sk_buff *skb, struct Qdisc* sch)
+static int tbf_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct tbf_sched_data *q = (struct tbf_sched_data *)sch->data;
     int ret;
@@ -172,12 +176,12 @@
     return ret;
 }
 
-static unsigned int tbf_drop(struct Qdisc* sch)
+static unsigned int tbf_drop(struct Qdisc* sch, struct sk_buff ** const 
skb)
 {
     struct tbf_sched_data *q = (struct tbf_sched_data *)sch->data;
     unsigned int len;
 
-    if ((len = q->qdisc->ops->drop(q->qdisc)) != 0) {
+    if ((len = q->qdisc->ops->drop(q->qdisc, skb)) != 0) {
         sch->q.qlen--;
         sch->stats.drops++;
     }
@@ -247,8 +251,9 @@
            (cf. CSZ, HPFQ, HFSC)
          */
 
-        if (q->qdisc->ops->requeue(skb, q->qdisc) != NET_XMIT_SUCCESS) {
+        if (q->qdisc->ops->requeue(&skb, q->qdisc) != NET_XMIT_SUCCESS) {
             /* When requeue fails skb is dropped */
+            ct_sub_counters(skb);
             sch->q.qlen--;
             sch->stats.drops++;
         }
diff -ruN -X dontdiff linux-2.6.8-rc3-ACCT/net/sched/sch_teql.c 
linux-2.6.8-rc3-ACCT-drops/net/sched/sch_teql.c
--- linux-2.6.8-rc3-ACCT/net/sched/sch_teql.c    2004-06-16 
07:19:01.000000000 +0200
+++ linux-2.6.8-rc3-ACCT-drops/net/sched/sch_teql.c    2004-08-05 
12:55:00.000000000 +0200
@@ -88,30 +88,30 @@
 /* "teql*" qdisc routines */
 
 static int
-teql_enqueue(struct sk_buff *skb, struct Qdisc* sch)
+teql_enqueue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct net_device *dev = sch->dev;
     struct teql_sched_data *q = (struct teql_sched_data *)sch->data;
 
-    __skb_queue_tail(&q->q, skb);
+    __skb_queue_tail(&q->q, *skb);
     if (q->q.qlen <= dev->tx_queue_len) {
-        sch->stats.bytes += skb->len;
+        sch->stats.bytes += (*skb)->len;
         sch->stats.packets++;
         return 0;
     }
 
-    __skb_unlink(skb, &q->q);
-    kfree_skb(skb);
+    __skb_unlink(*skb, &q->q);
+    IMPLICIT_DROP();
     sch->stats.drops++;
     return NET_XMIT_DROP;
 }
 
 static int
-teql_requeue(struct sk_buff *skb, struct Qdisc* sch)
+teql_requeue(struct sk_buff ** const skb, struct Qdisc* sch)
 {
     struct teql_sched_data *q = (struct teql_sched_data *)sch->data;
 
-    __skb_queue_head(&q->q, skb);
+    __skb_queue_head(&q->q, *skb);
     return 0;
 }
 
@@ -340,6 +340,7 @@
 
 drop:
     master->stats.tx_dropped++;
+    ct_sub_counters(skb);
     dev_kfree_skb(skb);
     return 0;
 }
