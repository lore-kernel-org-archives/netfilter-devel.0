From: "John Ye" <johny@asimco.com.cn>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Wed, 10 Oct 2007 09:48:22 +0800
Message-ID: <007701c80adf$a8a50170$ca8510ac@asimco>
References: <00de01c80175$7402ef90$ca8510ac@asimco> <46FCF121.8010807@ufomechanic.net> <000d01c809a3$7019fe10$d6ddfea9@JOHNYE1> <470A5D68.7060606@trash.net>
Cc: "Amin Azez" <azez@ufomechanic.net>,
	<netfilter-devel@vger.kernel.org>, " john ye" <johny@asimco.com.cn>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:54020 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbXJJBpr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:45:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All,

This is the BS version 2 patch for kernel 2.6.23-rc8.
If you need patch for other versions, I can make it and mail to you.

BS version 2 move the parallelization point from ip_rcv to netif_receive_skb.
So, it can support all protocols' netfilter, not only ipv4.

Our primarily test shown good result when iptables load is high.
I need your review and test. Only your test are trustable.


John Ye

-------------------------------------------------------------------------------
--- linux-2.6.23-rc8/net/core/dev.c 2007-09-25 08:33:10.000000000 +0800
+++ linux-2.6.23-rc8/net/core/dev.c 2007-10-10 09:30:30.000000000 +0800
@@ -1919,12 +1919,269 @@
 }
 #endif

+
+#define CONFIG_BOTTOM_SOFTIRQ_SMP
+#define CONFIG_BOTTOM_SOFTIRQ_SMP_SYSCTL
+
+
+#ifdef CONFIG_BOTTOM_SOFTIRQ_SMP
+
+/*
+[PATCH: 2.6.13-15-SMP 1/2] network: concurrently run softirq network code on SMP
+Bottom Softirq Implementation. John Ye, 2007.08.27
+
+This is the version 2 BS patch. it will make parallelization for all protocol's
+netfilter runing in softirq, IPV4, IPV6, bridge, etc.
+
+Why this patch:
+Make kernel be able to concurrently execute softirq's net code on SMP system.
+Take full advantages of SMP to handle more packets and greatly raises NIC throughput.
+The current kernel's net packet processing logic is:
+1) The CPU which handles a hardirq must be executing its related softirq.
+2) One softirq instance(irqs handled by 1 CPU) can't be executed on more than 2 CPUs
+at the same time.
+The limitation make kernel network be hard to take the advantages of SMP.
+
+How this patch:
+It splits the current softirq code into 2 parts: the cpu-sensitive top half,
+and the cpu-insensitive bottom half, then make bottom half(calld BS) be
+executed on SMP concurrently.
+The two parts are not equal in terms of size and load. Top part has constant code
+size(mainly, in net/core/dev.c and NIC drivers), while bottom part involves
+netfilter(iptables) whose load varies very much. An iptalbes with 1000 rules to match
+will make the bottom part's load be very high. So, if the bottom part softirq
+can be distributed to processors and run concurrently on them, the network will
+gain much more packet handling capacity, network throughput will be be increased
+remarkably.
+
+Where useful:
+It's useful on SMP machines that meet the following 2 conditions:
+1) have high kernel network load, for example, running iptables with thousands of rules, etc).
+2) have more CPUs than active NICs, e.g. a 4 CPUs machine with 2 NICs).
+On these system, with the increase of softirq load, some CPUs will be idle
+while others(number is equal to # of NIC) keeps busy.
+IRQBALANCE will help, but it only shifts IRQ among CPUS, makes no softirq concurrency.
+Balancing the load of each cpus will not remarkably increase network speed.
+
+Where NOT useful:
+If the bottom half of softirq is too small(without running iptables), or the network
+is too idle, BS patch will not be seen to have visible effect. But It has no
+negative affect either.
+User can turn off BS functionality by set /proc/sys/net/bs_policy value to 0.
+
+How to test:
+On a linux box, run iptables, add 2000 rules to table filter & table nat to simulate huge
+softirq load. Then, open 20 ftp sessions to download big file. On another machine(who
+use this test machine as gateway), open 20 more ftp download sessions. Compare the speed,
+without BS enabled, and with BS enabled.
+cat /proc/sys/net/bs_policy. 1 for flow dispatch, 2 random dispatch. 0 no dispatch.
+cat /proc/sys/net/bs_status. this shows the usage of each CPUs
+Test shown that when bottom softirq load is high, the network throughput can be nearly
+doubled on 2 CPUs machine. hopefully it may be quadrupled on a 4 cpus linux box.
+
+Bugs:
+It will NOT allow hotplug CPU.
+It only allows incremental CPUs ids, starting from 0 to num_online_cpus().
+for example, 0,1,2,3 is OK. 0,1,8,9 is KO.
+
+Some considerations in the future:
+1) With BS patch, the irq balance code on arch/i386/kernel/io_apic.c seems no need any more,
+at least not for network irq.
+2) Softirq load will become very small. It only run the top half of old softirq, which
+is much less expensive than bottom half---the netfilter program.
+To let top softirq process more packets, can these 3 network parameters be given a larger value?
+extern int netdev_max_backlog = 1000;
+extern int netdev_budget = 300;
+extern int weight_p = 64;
+3) Now, BS are running on built-in keventd thread, we can create new workqueues to let it run on?
+
+Signed-off-by: John Ye (Seeker) <[email]johny@webizmail.com[/email]>
+*/
+
+
+#define CBPTR( skb ) (*((void **)(skb->cb)))
+#define BS_USE_PERCPU_DATA
+struct cpu_stat
+{
+        unsigned long irqs;                       //total irqs
+        unsigned long dids;                       //I did,
+        unsigned long works;
+};
+#define BS_CPU_STAT_DEFINED
+
+static int nr_cpus = 0;
+
+#define BS_POL_LINK     1
+#define BS_POL_RANDOM   2
+int bs_policy = BS_POL_LINK; //cpu hash. 0 will turn off BS. 1 link based, 2 random
+
+static DEFINE_PER_CPU(struct sk_buff_head, bs_cpu_queues);
+static DEFINE_PER_CPU(struct work_struct, bs_works);
+//static DEFINE_PER_CPU(struct cpu_stat, bs_cpu_status);
+struct cpu_stat bs_cpu_status[NR_CPUS];
+
+//static int __netif_recv_skb(struct sk_buff *skb, struct net_device *odev);
+static int __netif_recv_skb(struct sk_buff *skb);
+
+static void bs_func(struct work_struct *data)
+{
+        int flags, num, cpu;
+        struct sk_buff *skb;
+        struct work_struct *bs_works;
+        struct sk_buff_head *q;
+        cpu = smp_processor_id();
+
+        bs_works = &per_cpu(bs_works, cpu);
+        q = &per_cpu(bs_cpu_queues, cpu);
+
+        //local_bh_disable();
+        restart:
+
+        num = 0;
+        while(1)
+        {
+                spin_lock_irqsave(&q->lock, flags);
+                if(!(skb = __skb_dequeue(q))) {
+                spin_unlock_irqrestore(&q->lock, flags);
+ break;
+ }
+                spin_unlock_irqrestore(&q->lock, flags);
+                num++;
+
+                local_bh_disable();
+                __netif_recv_skb(skb);
+                local_bh_enable();      // sub_preempt_count(SOFTIRQ_OFFSET - 1);
+        }
+
+        bs_cpu_status[cpu].dids += num;
+        //if(num > 2) printk("%d %d\n", num, cpu);
+        if(num > 0)
+                goto restart;
+
+        //__local_bh_enable();
+        bs_works->func = 0;
+
+        return;
+}
+
+struct cpu_workqueue_struct {
+
+ spinlock_t lock;
+
+ struct list_head worklist;
+ wait_queue_head_t more_work;
+ struct work_struct *current_work;
+
+ struct workqueue_struct *wq;
+ struct task_struct *thread;
+
+ int run_depth; /* Detect run_workqueue() recursion depth */
+} ____cacheline_aligned;
+
+struct workqueue_struct {
+ struct cpu_workqueue_struct *cpu_wq;
+ struct list_head list;
+ const char *name;
+ int singlethread;
+ int freezeable; /* Freeze threads during suspend */
+};
+
+#ifndef CONFIG_BOTTOM_SOFTIRQ_MODULE
+extern void __queue_work(struct cpu_workqueue_struct *cwq, struct work_struct *work);
+extern struct workqueue_struct *keventd_wq;
+#endif
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+
+static inline int bs_dispatch(struct sk_buff *skb)
+{
+ struct iphdr *iph = ip_hdr(skb);
+
+ if(!nr_cpus)
+ nr_cpus = num_online_cpus();
+
+ if(bs_policy && nr_cpus > 1) { // && iph->protocol != IPPROTO_ICMP) {
+ //if(bs_policy && nr_cpus > 1 && iph->protocol == IPPROTO_ICMP) { //test on icmp first
+ unsigned int flags, cur, cpu;
+ struct work_struct *bs_works;
+ struct sk_buff_head *q;
+
+ cpu = cur = smp_processor_id();
+
+ bs_cpu_status[cur].irqs++;
+
+ //good point for Jamal. thanks no reordering
+ if(bs_policy == BS_POL_LINK) {
+ int seed = 0;
+ if(iph->protocol == IPPROTO_TCP || iph->protocol == IPPROTO_UDP) {
+ struct tcphdr *th = (struct tcphdr*)(iph + 1);  //udp is same as tcp
+ seed = ntohs(th->source) + ntohs(th->dest);
+ }
+ cpu = (iph->saddr + iph->daddr + seed) % nr_cpus;
+
+ /*
+ if(net_ratelimit() && iph->protocol == IPPROTO_TCP) {
+ struct tcphdr *th = iph + 1;
+
+ printk("seed %u (%u %u) cpu %d. source %d dest %d\n",
+                                seed, iph->saddr + iph->daddr, iph->saddr + iph->daddr + seed, cpu,
+ ntohs(th->source), ntohs(th->dest));
+ }
+ */
+ } else
+ //random distribute
+ if(bs_policy == BS_POL_RANDOM)
+ cpu = (bs_cpu_status[cur].irqs % nr_cpus);
+
+ //cpu = cur;
+ //cpu = (cur? 0: 1);
+
+ if(cpu == cur) {
+ bs_cpu_status[cpu].dids++;
+ return __netif_recv_skb(skb);
+ }
+
+ q = &per_cpu(bs_cpu_queues, cpu);
+
+ if(!q->next) { // || skb_queue_len(q) == 0 ) {
+ skb_queue_head_init(q);
+ }
+
+
+ bs_works = &per_cpu(bs_works, cpu);
+ spin_lock_irqsave(&q->lock, flags);
+ __skb_queue_tail(q, skb);
+ spin_unlock_irqrestore(&q->lock, flags);
+
+    if (!bs_works->func) {
+                        INIT_WORK(bs_works, bs_func);
+                        bs_cpu_status[cpu].works++;
+                        preempt_disable();
+ set_bit(WORK_STRUCT_PENDING, work_data_bits(bs_works));
+ __queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), bs_works);
+                        preempt_enable();
+ }
+
+ } else {
+
+ bs_cpu_status[smp_processor_id()].dids++;
+ return __netif_recv_skb(skb);
+ }
+ return 0;
+}
+
+
+
+#endif
+
+
 int netif_receive_skb(struct sk_buff *skb)
 {
- struct packet_type *ptype, *pt_prev;
+ //struct packet_type *ptype, *pt_prev;
  struct net_device *orig_dev;
- int ret = NET_RX_DROP;
- __be16 type;
+ //int ret = NET_RX_DROP;
+ //__be16 type;

  /* if we've gotten here through NAPI, check netpoll */
  if (skb->dev->poll && netpoll_rx(skb))
@@ -1947,6 +2204,19 @@
  skb_reset_transport_header(skb);
  skb->mac_len = skb->network_header - skb->mac_header;

+ CBPTR(skb) = orig_dev;
+ return bs_dispatch(skb);
+}
+
+int __netif_recv_skb(struct sk_buff *skb)
+{
+ struct packet_type *ptype, *pt_prev;
+ struct net_device *orig_dev;
+ int ret = NET_RX_DROP;
+ __be16 type;
+
+ orig_dev = CBPTR(skb);
+ CBPTR(skb) = 0;
  pt_prev = NULL;

  rcu_read_lock();
--- linux-2.6.23-rc8/kernel/workqueue.c 2007-09-25 08:33:10.000000000 +0800
+++ linux-2.6.23-rc8/kernel/workqueue.c 2007-10-10 08:52:05.000000000 +0800
@@ -138,7 +138,9 @@
 }

 /* Preempt must be disabled. */
-static void __queue_work(struct cpu_workqueue_struct *cwq,
+//static void __queue_work(struct cpu_workqueue_struct *cwq,
+// struct work_struct *work)
+void __queue_work(struct cpu_workqueue_struct *cwq,
  struct work_struct *work)
 {
  unsigned long flags;
@@ -515,7 +517,12 @@
 }
 EXPORT_SYMBOL(cancel_delayed_work_sync);

+
+/*
 static struct workqueue_struct *keventd_wq __read_mostly;
+*/
+struct workqueue_struct *keventd_wq __read_mostly;
+

 /**
  * schedule_work - put work task in global workqueue
@@ -848,5 +855,6 @@
  cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
  hotcpu_notifier(workqueue_cpu_callback, 0);
  keventd_wq = create_workqueue("events");
+ printk("keventd_wq %p %p OK.\n", keventd_wq, keventd_wq->cpu_wq);
  BUG_ON(!keventd_wq);
 }
--- linux-2.6.23-rc8/net/sysctl_net.c 2007-09-25 08:33:10.000000000 +0800
+++ linux-2.6.23-rc8/net/sysctl_net.c 2007-10-09 21:10:41.000000000 +0800
@@ -29,6 +29,15 @@
 #include <linux/if_tr.h>
 #endif

+struct cpu_stat
+{
+        unsigned long irqs;                       /* total irqs on me */
+        unsigned long dids;                       /* I did, */
+        unsigned long works;                      /* q works */
+};
+extern int bs_policy;
+extern struct cpu_stat bs_cpu_status[NR_CPUS];
+
 struct ctl_table net_table[] = {
  {
  .ctl_name = NET_CORE,
@@ -36,6 +45,24 @@
  .mode = 0555,
  .child = core_table,
  },
+
+        {
+                .ctl_name       = 99,
+                .procname       = "bs_status",
+                .data           = &bs_cpu_status,
+                .maxlen         = sizeof(bs_cpu_status),
+                .mode           = 0644,
+                .proc_handler   = &proc_dointvec,
+        },
+        {
+                .ctl_name       = 99,
+                .procname       = "bs_policy",
+                .data           = &bs_policy,
+                .maxlen         = sizeof(int),
+                .mode           = 0644,
+                .proc_handler   = &proc_dointvec,
+        },
+
 #ifdef CONFIG_INET
  {
  .ctl_name = NET_IPV4,


