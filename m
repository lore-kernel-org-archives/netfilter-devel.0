From: Yoshihiro Kawabe <sowhat@amnis.co.jp>
Subject: 2.6.14-rc1 ip_conntrack lockup.
Date: Mon, 19 Sep 2005 23:13:33 +0900 (JST)
Message-ID: <20050919.231333.74747459.sowhat@amnis.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello folks,

I have experinced a `soft lockup' with ip_conntrack.

Kernel version: 2.6.14-rc1

CONFIG_IP_NF_CONNTRACK=m
CONFIG_IP_NF_CT_ACCT=y
CONFIG_IP_NF_CONNTRACK_MARK=y
CONFIG_IP_NF_CONNTRACK_EVENTS=y

modprobe ip_conntrack.

----
BUG: soft lockup detected on CPU#0!

Pid: 0, comm:              swapper
EIP: 0060:[<c03bd492>] CPU: 0
EIP is at _write_lock_irqsave+0x82/0xb0
 EFLAGS: 00000202    Not tainted  (2.6.14-rc1-sa1-pm-dbg.0)
EAX: 00000001 EBX: 00000286 ECX: f88bd160 EDX: 00000001
ESI: f88bd160 EDI: c04c6000 EBP: c04c7d24 DS: 007b ES: 007b
CR0: 8005003b CR2: 0808e09c CR3: 362df000 CR4: 000006c0
 [<c01014ea>] show_regs+0x15a/0x184
 [<c0148080>] softlockup_tick+0x80/0x90
 [<c012da99>] do_timer+0x49/0xe0
 [<c0107fce>] timer_interrupt+0x2e/0x80
 [<c01482ca>] handle_IRQ_event+0x2a/0x60
 [<c0148389>] __do_IRQ+0x89/0xf0
 [<c0105463>] do_IRQ+0x33/0x70
 [<c0103d0e>] common_interrupt+0x1a/0x20
 [<c03bd4d9>] _write_lock_bh+0x9/0x20
 [<f88b15bb>] destroy_conntrack+0x6b/0x180 [ip_conntrack]
 [<f88b0ec5>] __ip_ct_event_cache_init+0x85/0xd0 [ip_conntrack]
 [<f88b30f6>] ip_ct_refresh_acct+0x156/0x170 [ip_conntrack]
 [<f88b49f1>] udp_packet+0x91/0xa0 [ip_conntrack]
 [<f88b247c>] ip_conntrack_in+0xbc/0x340 [ip_conntrack]
 [<c039584e>] nf_iterate+0x6e/0xb0
 [<c03958f6>] nf_hook_slow+0x66/0x130
 [<c0357ee3>] ip_rcv+0x193/0x560
 [<c0332e71>] netif_receive_skb+0x2c1/0x3a0
 [<c0332fe1>] process_backlog+0x91/0x120
 [<c033311a>] net_rx_action+0xaa/0x1d0
 [<c012964c>] __do_softirq+0xdc/0x100
 [<c01296bd>] do_softirq+0x4d/0x50
 [<c01297be>] irq_exit+0x4e/0x50
 [<c0105468>] do_IRQ+0x38/0x70
 [<c0103d0e>] common_interrupt+0x1a/0x20
 [<c010113d>] cpu_idle+0x8d/0xd0
 [<c01002cd>] rest_init+0x2d/0x30
 [<c04c89e0>] start_kernel+0x190/0x1e0
 [<c0100210>] 0xc0100210

----
I hoped that this problem would be solved early, and tried to analyze
source code, with writing a call flow based on stack trace.  I found
that ip_conntrack_event_cache called in the lock state of
ip_conntrack_lock. Consequently, since destroy_conntrack was called in
the flow after ip_conntrack_event_cache, it was going to perform
recursive lock acquisition.

Then, ip_conntrack_event_cache The above-mentioned problem stopped
coming out, as a result of changing so that it may call outside
ip_conntrack_lock.

----
Call flow, Brief:

  ip_conntrack_local (net/ipv4/netfilter/ip_conntrack_standalone.c)
    + ip_conntrack_in (net/ipv4/netfilter/ip_conntrack_core.c)
        + udp_packet (net/ipv4/netfilter/ip_conntrack_proto_udp.c)
            + ip_ct_refresh_acct (net/ipv4/netfilter/ip_conntrack_core.c)
                LOCK -- &ip_conntrack_lock
                + ip_conntrack_event_cache (include/linux/netfilter_ipv4/ip_conntrack.h)
                    + __ip_ct_event_cache_init (net/ipv4/netfilter/ip_conntrack_core.c)
		        + __ip_ct_deliver_cached_events (net/ipv4/netfilter/ip_conntrack_core.c)
			    + ip_conntrack_put (include/linux/netfilter_ipv4/ip_conntrack.h)
			        + nf_conntrack_put (include/linux/skbuff.h)
				    + nfct->destroy(nfct) => destroy_conntrack
				!!!!!  LOCK -- &ip_conntrack_lock
                UNLOCK -- &ip_conntrack_lock

----
This is the patch. It is the base which applied the patch which
Mr. Harald Welte sent several days ago to 2.6.14-rc1.
 
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2005-09-14 21:27:45.000000000 +0900
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2005-09-18 23:22:17.000000000 +0900
@@ -1143,10 +1143,13 @@
         if (del_timer(&ct->timeout)) {
             ct->timeout.expires = jiffies + extra_jiffies;
             add_timer(&ct->timeout);
+            write_unlock_bh(&ip_conntrack_lock);
+            if(skb)
                 ip_conntrack_event_cache(IPCT_REFRESH, skb);
+        } else {
+            write_unlock_bh(&ip_conntrack_lock);
         }
         ct_add_counters(ct, ctinfo, skb);
-        write_unlock_bh(&ip_conntrack_lock);
     }
 }
 
--
  Kawabe,Yoshihiro <sowhat@amnis.co.jp>
  As the stars blink in the night sky, our married hearts are never splitted.
  Even if we will unclasp each other hands, until we retain that. by H.S.
