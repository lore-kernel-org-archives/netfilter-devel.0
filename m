From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue freeze with 2.6.9 RHEL4
Date: Thu, 21 Jul 2005 09:44:44 +0200
Message-ID: <42DF526C.5070305@trash.net>
References: <1121891748.16195.25.camel@localhost.localdomain>	
	<42DEC52F.2020500@trash.net>
	<1121931584.5535.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090105020803070909050701"
Cc: netfilter-devel@lists.netfilter.org, redhat-list@redhat.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1121931584.5535.3.camel@localhost.localdomain>
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
--------------090105020803070909050701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Leblond wrote:
> I've got one rule only :
> 	iptables -A INPUT -p tcp --dport 22 --syn -j ACCEPT
>
> It freezes just after I send the NF_ACCEPT decision.

This looks like a problem we've already fixed in current kernels. Please
try this patch.


--------------090105020803070909050701
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix deadlock with ip_queue and tcp local input path.

When we have ip_queue being used from LOCAL_IN, then we end up with a
situation where the verdicts coming back from userspace traverse the TCP
input path from syscall context.  While this seems to work most of the
time, there's an ugly deadlock:

syscall context is interrupted by the timer interrupt.  When the timer
interrupt leaves, the timer softirq get's scheduled and calls
tcp_delack_timer() and alike.  They themselves do bh_lock_sock(sk),
which is already held from somewhere else -> boom.

I've now tested the suggested solution by Patrick McHardy and Herbert Xu to
simply use local_bh_{en,dis}able().

Signed-off-by: Harald Welte <laforge@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 9bb7bc942d3da606f184ac6a4dfc7e4d470c831b
tree dc310200df5988d4c71c346baad6a923a4bdeb9d
parent 5e485b7975472ba4a408523deb6541e70c451842
author Harald Welte <laforge@netfilter.org> Mon, 30 May 2005 15:35:26 -0700
committer David S. Miller <davem@davemloft.net> Mon, 30 May 2005 15:35:26 -0700

 net/ipv4/netfilter/ip_queue.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -3,6 +3,7 @@
  * communicating with userspace via netlink.
  *
  * (C) 2000-2002 James Morris <jmorris@intercode.com.au>
+ * (C) 2003-2005 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -17,6 +18,7 @@
  * 2005-01-10: Added /proc counter for dropped packets; fixed so
  *             packets aren't delivered to user space if they're going 
  *             to be dropped. 
+ * 2005-05-26: local_bh_{disable,enable} around nf_reinject (Harald Welte)
  *
  */
 #include <linux/module.h>
@@ -71,7 +73,15 @@ static DECLARE_MUTEX(ipqnl_sem);
 static void
 ipq_issue_verdict(struct ipq_queue_entry *entry, int verdict)
 {
+	/* TCP input path (and probably other bits) assume to be called
+	 * from softirq context, not from syscall, like ipq_issue_verdict is
+	 * called.  TCP input path deadlocks with locks taken from timer
+	 * softirq, e.g.  We therefore emulate this by local_bh_disable() */
+
+	local_bh_disable();
 	nf_reinject(entry->skb, entry->info, verdict);
+	local_bh_enable();
+
 	kfree(entry);
 }
 

--------------090105020803070909050701--
