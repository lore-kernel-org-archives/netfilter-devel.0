From: Andrew Morton <akpm@osdl.org>
Subject: Re: Pre-emptable lock debug
Date: Thu, 28 Apr 2005 20:54:32 -0700
Message-ID: <20050428205432.05e0721a.akpm@osdl.org>
References: <20050429013756.2B12E7940A8@longblack.object-craft.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew McNamara <andrewm@object-craft.com.au>
In-Reply-To: <20050429013756.2B12E7940A8@longblack.object-craft.com.au>
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

Andrew McNamara <andrewm@object-craft.com.au> wrote:
>
> Suspect this is "not your problem", but...  when installing 2.6.11.7,
> I (probably foolishly?) enabled:
> 
>     CONFIG_PREEMPT=y
>     CONFIG_PREEMPT_BKL=y
>     CONFIG_DEBUG_PREEMPT=y
> 
> So now I'm getting debug (just like I asked for). The following occured
> late in the boot process (after root is mounted RW, apparently when
> interfaces are brought up). Another batch occur very late in the shutdown
> process, although I haven't been able to catch these.
> 
> This is a bog standard kernel 2.6.11.7 - although NV module is loaded later.
>
> BUG: using smp_processor_id() in preemptible [00000001] code: ifconfig/1606
> caller is get_next_corpse+0x14/0x280
>  [<c021a348>] smp_processor_id+0xa8/0xc0
>  [<c03fcfb4>] get_next_corpse+0x14/0x280
>  [<c03fcfb4>] get_next_corpse+0x14/0x280
>  [<c0429aff>] _spin_unlock_irqrestore+0xf/0x30
>  [<c03a78bd>] skb_dequeue+0x4d/0x60
>  [<c03fd254>] ip_ct_iterate_cleanup+0x34/0xd0
>  [<c040d3c0>] device_cmp+0x0/0x110
>  [<c040d388>] masq_inet_event+0x38/0x70
>  [<c040d3c0>] device_cmp+0x0/0x110
>  [<c012db0d>] notifier_call_chain+0x2d/0x50
>  [<c03eb8ec>] inet_del_ifa+0x8c/0x150
>  [<c03ec5b9>] devinet_ioctl+0x4d9/0x5b0
>  [<c03ee876>] inet_ioctl+0x66/0xb0
>  [<c03a2219>] sock_ioctl+0xc9/0x250
>  [<c01717ae>] do_ioctl+0x8e/0xa0
>  [<c01719c5>] vfs_ioctl+0x65/0x1f0
>  [<c0171bb7>] sys_ioctl+0x67/0x90
>  [<c010328f>] syscall_call+0x7/0xb

That's a bug in MUST_BE_WRITE_LOCKED(), doing smp_processor_id() outside
preempt_disable().

Like this, I think:



Avoid smp_processor_id() in premptible code in the netfilter lock debugging
code.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/netfilter_ipv4/lockhelp.h |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/netfilter_ipv4/lockhelp.h~netfilter-debug-locking-fix include/linux/netfilter_ipv4/lockhelp.h
--- 25/include/linux/netfilter_ipv4/lockhelp.h~netfilter-debug-locking-fix	Thu Apr 28 20:53:26 2005
+++ 25-akpm/include/linux/netfilter_ipv4/lockhelp.h	Thu Apr 28 20:53:26 2005
@@ -63,9 +63,11 @@ do { if ((l)->read_locked_map & (1UL << 
 
 #define LOCK_BH(lk)						\
 do {								\
+	preempt_disable();					\
 	MUST_BE_UNLOCKED(lk);					\
 	spin_lock_bh(&(lk)->l);					\
 	atomic_set(&(lk)->locked_by, smp_processor_id());	\
+	preempt_enable();					\
 } while(0)
 
 #define UNLOCK_BH(lk)				\
@@ -77,16 +79,20 @@ do {						\
 
 #define READ_LOCK(lk) 						\
 do {								\
+	preempt_disable();					\
 	MUST_BE_READ_WRITE_UNLOCKED(lk);			\
 	read_lock_bh(&(lk)->l);					\
 	set_bit(smp_processor_id(), &(lk)->read_locked_map);	\
+	preempt_enable();					\
 } while(0)
 
-#define WRITE_LOCK(lk)							  \
-do {									  \
-	MUST_BE_READ_WRITE_UNLOCKED(lk);				  \
-	write_lock_bh(&(lk)->l);					  \
-	set_bit(smp_processor_id(), &(lk)->write_locked_map);		  \
+#define WRITE_LOCK(lk)						\
+do {								\
+	preempt_disable();					\
+	MUST_BE_READ_WRITE_UNLOCKED(lk);			\
+	write_lock_bh(&(lk)->l);				\
+	set_bit(smp_processor_id(), &(lk)->write_locked_map);	\
+	preempt_enable();					\
 } while(0)
 
 #define READ_UNLOCK(lk)							\
_
