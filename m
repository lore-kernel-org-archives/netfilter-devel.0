From: Maik Hentsche <netfilter@mm-double.de>
Subject: possible Bug in ip_conntrack
Date: Mon, 14 Aug 2006 10:58:05 +0200
Message-ID: <1155545885.44e03b1dcec01@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

Hi!
While debugging a new version of conntrackd, I (nearly) every time get
athe following error "BUG: soft lockup detected on CPU#1!" which
completely hangs the system. Here is, what I do to reproduce the error:
I ue keepalived to manage a virtual IP, that is default gw for two other
machines, which communicate over this IP. I use a client-server-program
to count connections, which simply opens a tcp-socket and immediately
closes it. The gateway uses keepalived and conntrackd-0.8.3 for hot
standby. The HS-master (thta produces the error) has kernel 2.6.18-rc4
running (with no other patches), the slave is a 2.6.17.3 (also
vanilla).  I use valgrind --leak-check=yes for debugging. After some
time, usually between 1 and 5 minutes, the system hangs and writes
something like this out on the serial console.

BUG: soft lockup detected on CPU#1!
Call Trace:
 <IRQ> [<ffffffff80252bc9>] softlockup_tick+0xf9/0x140
 [<ffffffff80239367>] update_process_times+0x57/0x90
 [<ffffffff80216243>] smp_local_timer_interrupt+0x23/0x50
 [<ffffffff802167a8>] smp_apic_timer_interrupt+0x38/0x40
 [<ffffffff8020a962>] apic_timer_interrupt+0x66/0x6c
 <EOI> [<ffffffff8042028d>] _write_lock_irqsave+0x6d/0x90
 [<ffffffff8042026a>] _write_lock_irqsave+0x4a/0x90
 [<ffffffff80420416>] _write_lock_bh+0x6/0x20
 [<ffffffff8811b2a9>] :ip_conntrack:destroy_conntrack+0x69/0x100
 [<ffffffff88137da6>]
:ip_conntrack_netlink:ctnetlink_dump_table+0x116/0x160
 [<ffffffff803c5582>] netlink_dump+0x82/0x1c0
 [<ffffffff803c6ff7>] netlink_recvmsg+0x197/0x2a0
 [<ffffffff803ab13e>] sock_recvmsg+0xde/0x100
 [<ffffffff802264fc>] task_rq_lock+0x4c/0x90
 [<ffffffff80244580>] autoremove_wake_function+0x0/0x30
 [<ffffffff802346db>] current_fs_time+0x3b/0x40
 [<ffffffff80226433>] __wake_up+0x43/0x70
 [<ffffffff8027e3ae>] fget_light+0xae/0xe0
 [<ffffffff803acf7a>] sys_recvfrom+0xfa/0x190
 [<ffffffff80209dbe>] system_call+0x7e/0x83

The calltrace differs every time, but ip_conntrack is always included,
therefore and because it only occured yet when I was debugging
conntrackd I assume its a ip_conntrack problem.

More logmessages and the buggy version of conntrackd can be found here:
http://www-user.tu-chemnitz.de/~hmai/ip_conntrack/

If you need more informations, please let me know.

so long
Maik
