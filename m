From: "john ye" <johny@asimco.com.cn>
Subject: Re: remarkably Increase iptables' speed on SMP system.
Date: Mon, 1 Oct 2007 20:10:08 +0800
Message-ID: <001b01c80424$02def8c0$d6ddfea9@JOHNYE1>
References: <00de01c80175$7402ef90$ca8510ac@asimco> <46FCF121.8010807@ufomechanic.net> <002d01c803fb$a9f96e70$d6ddfea9@JOHNYE1>
Cc: <netfilter-devel@vger.kernel.org>, "YE QY" <iceburgue@gmail.com>,
	"John Ye" <johny@asimco.com.cn>
To: "john ye" <johny@asimco.com.cn>, "Amin Azez" <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asimco-na.com ([207.138.153.195]:31584 "EHLO
	mail.asimco-na.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJAMK1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:10:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

All,

I am feeling very sorry for patch's patch.
The following lines:
+               if(bs_policy == BS_POL_LINK) {
+                       seed = 0;
+                       if(iph->protocol == IPPROTO_TCP)
+                               seed = skb->h.th->source + skb->h.th->dest;
+                       cpu = (iph->saddr + iph->daddr + seed) % nr_cpus;
+               } else

should be changed into:
                if(bs_policy == BS_POL_LINK) {
                        seed = 0;
                        if(iph->protocol == IPPROTO_TCP || iph->protocol == IPPROTO_UDP) {
                                struct tcphdr *th = skb->nh.iph + 1;    //upd is same as tcp
                                seed = ntohs(th->source) + ntohs(th->dest);
                        }
                        cpu = (iph->saddr + iph->daddr + seed) % nr_cpus;
                } else

This is because skb-h.th has not been filled with correct value yet when tcp_rcv is called.
use the raw ip packet to get tcp/udp source port and dest port.

And, I think you had better to get the module for testing.
recompiling kernel is not a good and quick thing to do.

John Ye & Qianye Ye.




----- Original Message ----- 
From: "john ye" <johny@asimco.com.cn>
To: "Amin Azez" <azez@ufomechanic.net>
Cc: <netfilter-devel@vger.kernel.org>; "YE QY" <iceburgue@gmail.com>; "John Ye" <johny@asimco.com.cn>
Sent: Monday, October 01, 2007 3:21 PM
Subject: Re: remarkably Increase iptables' speed on SMP system.


All,

This is the patch for kernel 2.6.13-15-smp. I don't have environment of other kernel versions.
If you want module for multiple kernel version, you can ftp it from
ftp://218.247.5.185
login: netfilter
pass: iptables

the file is main.c

John Ye

Thanks.
--------------------------------------------------------------------------------
--- old/net/ipv4/ip_input.c 2007-09-20 20:50:31.000000000 +0800
+++ new/net/ipv4/ip_input.c 2007-10-02 00:43:37.000000000 +0800
@@ -362,6 +362,187 @@
         return NET_RX_DROP;
 }

+
+#define CONFIG_BOTTOM_SOFTIRQ_SMP
+#define CONFIG_BOTTOM_SOFTIRQ_SMP_SYSCTL
+
+#ifdef CONFIG_BOTTOM_SOFTIRQ_SMP
+
+/*
+ *
+Bottom Softirq Implementation. John Ye, 2007.08.27
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
+User can turn on/off BS functionality by /proc/sys/net/bs_enable switch.
+
+How to test:
+On a linux box, run iptables, add 2000 rules to table filter & table nat to simulate huge
+softirq load. Then, open 20 ftp sessions to download big file. On another machine(who
+use this test machine as gateway), open 20 more ftp download sessions. Compare the speed,
+without BS enabled, and with BS enabled.
+cat /proc/sys/net/bs_enable. this is a switch to turn on/off BS
+cat /proc/sys/net/bs_status. this shows the usage of each CPUs
+Test shown that when bottom softirq load is high, the network throughput can be nearly
+doubled on 2 CPUs machine. hopefully it may be quadrupled on a 4 cpus linux box.
+
+Bugs:
+It will NOT allow hotpug CPU.
+It only allows incremental CPUs ids, starting from 0 to num_online_cpus().
+for example, 0,1,2,3 is OK. 0,1,8,9 is KO.
+
+Some considerations in the future:
+1) With BS patch, the irq balance code on arch/i386/kernel/io_apic.c seems no need any more,
+at least not for network irq.
+2) Softirq load will become very small. It only run the top half of old softirq, which
+is much less expensive than bottom half---the netfilter program.
+To let top softirq process more packets, cant these 3 network parameters be enlarged?
+extern int netdev_max_backlog = 1000;
+extern int netdev_budget = 300;
+extern int weight_p = 64;
+3) Now, BS are running on built-in keventd thread, we can create new workqueues to let it run on?
+
+Signed-off-by: John Ye (Seeker) <johny@asimco.com.cn>
+ *
+ */
+
+struct cpu_stat {
+ unsigned long irqs; //total irqs I have
+ unsigned long dids; //I did myself
+ unsigned long others; //help others
+ unsigned long works; //# of enqueues
+};
+#define BS_CPU_STAT_DEFINED
+
+static int nr_cpus = 0;
+
+static DEFINE_PER_CPU(struct sk_buff_head, bs_cpu_queues); // cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct work_struct, bs_works);
+struct cpu_stat bs_cpu_status[NR_CPUS];
+
+int bs_enable = 1;
+
+#define BS_POL_LINK 1
+#define BS_POL_RANDOM 2
+int bs_policy = BS_POL_LINK;
+
+static int ip_rcv1(struct sk_buff *skb, struct net_device *dev)
+{
+ return NF_HOOK_COND(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL, ip_rcv_finish, nf_hook_input_cond(skb));
+}
+
+
+static void bs_func(void *data)
+{
+ int  flags, num, cpu;
+ struct sk_buff *skb, *last;
+ struct work_struct *bs_works;
+ struct sk_buff_head *q;
+ cpu = smp_processor_id();
+
+ bs_works = &per_cpu(bs_works, cpu);
+ q = &per_cpu(bs_cpu_queues, cpu);
+
+ local_bh_disable();
+restart:
+ num = 0;
+ while(1) {
+ last = skb;
+ spin_lock_irqsave(&q->lock, flags);
+         skb = __skb_dequeue(q);
+ spin_unlock_irqrestore(&q->lock, flags);
+ if(!skb) break;
+ num++;
+ //local_bh_disable();
+         ip_rcv1(skb, skb->dev);
+ //__local_bh_enable(); //sub_preempt_count(SOFTIRQ_OFFSET - 1);
+ }
+
+ bs_cpu_status[cpu].others += num;
+ if(num > 0) { goto restart; }
+
+ __local_bh_enable(); //sub_preempt_count(SOFTIRQ_OFFSET - 1);
+ bs_works->func = 0;
+
+ return;
+}
+
+/* COPY_IN_START_FROM kernel/workqueue.c */
+struct cpu_workqueue_struct {
+
+ spinlock_t lock;
+
+ long remove_sequence; /* Least-recently added (next to run) */
+ long insert_sequence; /* Next to add */
+
+ struct list_head worklist;
+ wait_queue_head_t more_work;
+ wait_queue_head_t work_done;
+
+ struct workqueue_struct *wq;
+ struct task_struct *thread;
+
+ int run_depth; /* Detect run_workqueue() recursion depth */
+} ____cacheline_aligned;
+
+
+struct workqueue_struct {
+ struct cpu_workqueue_struct cpu_wq[NR_CPUS];
+ const char *name;
+ struct list_head list; /* Empty if single thread */
+};
+/* COPY_IN_END_FROM kernel/worqueue.c */
+
+extern struct workqueue_struct *keventd_wq;
+
+/* Preempt must be disabled. */
+static void __queue_work(struct cpu_workqueue_struct *cwq,
+ struct work_struct *work)
+{
+ unsigned long flags;
+
+ spin_lock_irqsave(&cwq->lock, flags);
+ work->wq_data = cwq;
+ list_add_tail(&work->entry, &cwq->worklist);
+ cwq->insert_sequence++;
+ wake_up(&cwq->more_work);
+ spin_unlock_irqrestore(&cwq->lock, flags);
+}
+#endif //CONFIG_BOTTOM_SOFTIRQ_SMP
+
+
 /*
  * Main IP Receive routine.
  */
@@ -424,8 +605,67 @@
  }
  }

+#ifdef CONFIG_BOTTOM_SOFTIRQ_SMP
+ if(!nr_cpus)
+ nr_cpus = num_online_cpus();
+
+    if(bs_enable && nr_cpus > 1 && iph->protocol != IPPROTO_ICMP) {
+    //if(bs_enable && iph->protocol == IPPROTO_ICMP) { //test on icmp first
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
+ seed = 0;
+ if(iph->protocol == IPPROTO_TCP)
+ seed = skb->h.th->source + skb->h.th->dest;
+ cpu = (iph->saddr + iph->daddr + seed) % nr_cpus;
+ } else
+ //random distribute
+ if(bs_policy == BS_POL_RANDOM)
+ cpu = (bs_cpu_status[cur].irqs % nr_cpus);
+
+ if(cpu == cur) {
+ bs_cpu_status[cpu].dids++;
+ return ip_rcv1(skb, dev);
+ }
+
+ q = &per_cpu(bs_cpu_queues, cpu);
+
+ if(!q->next) {
+ skb_queue_head_init(q);
+ }
+
+ bs_works = &per_cpu(bs_works, cpu);
+        spin_lock_irqsave(&q->lock, flags);
+ __skb_queue_tail(q, skb);
+        spin_unlock_irqrestore(&q->lock, flags);
+ //if(net_ratelimit()) printk("qlen %d\n", q->qlen);
+
+           if (!bs_works->func) {
+       INIT_WORK(bs_works, bs_func, q);
+ bs_cpu_status[cpu].works++;
+ preempt_disable();
+ __queue_work(keventd_wq->cpu_wq + cpu, bs_works);
+ preempt_enable();
+ }
+ } else {
+ int cpu = smp_processor_id();
+ bs_cpu_status[cpu].irqs++;
+ bs_cpu_status[cpu].dids++;
+ return ip_rcv1(skb, dev);
+ }
+ return 0;
+#else
  return NF_HOOK_COND(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
-                     ip_rcv_finish, nf_hook_input_cond(skb));
+            ip_rcv_finish, nf_hook_input_cond(skb));
+#endif //CONFIG_BOTTOM_SOFTIRQ_SMP
+

 inhdr_error:
  IP_INC_STATS_BH(IPSTATS_MIB_INHDRERRORS);
--- old/net/sysctl_net.c 2007-09-20 23:30:29.000000000 +0800
+++ new/net/sysctl_net.c 2007-10-02 00:32:42.000000000 +0800
@@ -30,6 +30,22 @@
 extern struct ctl_table tr_table[];
 #endif

+
+#define CONFIG_BOTTOM_SOFTIRQ_SMP_SYSCTL
+#ifdef CONFIG_BOTTOM_SOFTIRQ_SMP_SYSCTL
+#if !defined(BS_CPU_STAT_DEFINED)
+struct cpu_stat {
+ unsigned long irqs; //total irqs
+ unsigned long dids; //I did,
+ unsigned long others;
+ unsigned long works;
+};
+#endif
+extern struct cpu_stat bs_cpu_status[NR_CPUS];
+
+extern int bs_enable;
+#endif
+
 struct ctl_table net_table[] = {
  {
  .ctl_name = NET_CORE,
@@ -61,5 +77,33 @@
  .child = tr_table,
  },
 #endif
+
+#ifdef CONFIG_BOTTOM_SOFTIRQ_SMP_SYSCTL
+ {
+ .ctl_name = 99,
+ .procname = "bs_status",
+ .data = &bs_cpu_status,
+ .maxlen = sizeof(bs_cpu_status),
+ .mode = 0644,
+ .proc_handler = &proc_dointvec,
+ },
+ {
+ .ctl_name = 99,
+ .procname = "bs_policy",
+ .data = &bs_policy,
+ .maxlen = sizeof(int),
+ .mode = 0644,
+ .proc_handler = &proc_dointvec,
+ },
+ {
+ .ctl_name = 99,
+ .procname = "bs_enable",
+ .data = &bs_enable,
+ .maxlen = sizeof(int),
+ .mode = 0644,
+ .proc_handler = &proc_dointvec,
+ },
+#endif
+
  { 0 },
 };
--- old/kernel/workqueue.c 2007-09-21 04:48:13.000000000 +0800
+++ new/kernel/workqueue.c 2007-10-02 00:39:05.000000000 +0800
@@ -384,7 +384,12 @@
  kfree(wq);
 }

+/*
 static struct workqueue_struct *keventd_wq;
+*/
+/* EXPORTed so I have access */
+struct workqueue_struct *keventd_wq;
+EXPORT_SYMBOL(keventd_wq);

 int fastcall schedule_work(struct work_struct *work)
 {




