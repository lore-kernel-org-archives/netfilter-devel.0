From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: "local_bh_disable" [net/ipv4/netfilter/ip_conntrack_pptp.ko]
	undefined!
Date: Thu, 12 Jan 2006 10:10:41 +0100
Message-ID: <BAY103-F32DBAD0DD8DF026ECDDEE0B2270@phx.gbl>
References: <20060111.160353.29305641.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060111.160353.29305641.davem@davemloft.net>
To: davem@davemloft.net
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


David S. Miller wrote:

>From: "Marco Berizzi" <pupilla@hotmail.com>
>Date: Wed, 11 Jan 2006 10:49:12 +0100
>
> > I'm compiling pptp conntrack/nat as module and I getting this warning:
>
>This should fix it:
>
>diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
>index 799be67..7db4df8 100644
>--- a/include/linux/spinlock.h
>+++ b/include/linux/spinlock.h
>@@ -53,6 +53,7 @@
>  #include <linux/thread_info.h>
>  #include <linux/kernel.h>
>  #include <linux/stringify.h>
>+#include <linux/interrupt.h>
>
>  #include <asm/system.h>

Sorry David for wasting your time, but I applied your patch to 2.6.15-git8
and...

root@Calimero:/usr/src/linux# make bzImage
  Building kernel 2.6.15-git8
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  SYMLINK include/asm -> include/asm-i386
  SPLIT   include/linux/autoconf.h -> include/config/*
  CC      arch/i386/kernel/asm-offsets.s
In file included from include/linux/hardirq.h:6,
                 from include/linux/interrupt.h:11,
                 from include/linux/spinlock.h:56,
                 from include/linux/capability.h:45,
                 from include/linux/sched.h:7,
                 from arch/i386/kernel/asm-offsets.c:7:
include/linux/smp_lock.h:11: error: syntax error before 
"__reacquire_kernel_lock"
include/linux/smp_lock.h:11: warning: type defaults to `int' in declaration 
of `__reacquire_kernel_lock'
include/linux/smp_lock.h:11: warning: data definition has no type or storage 
class
include/linux/smp_lock.h:12: error: syntax error before 
"__release_kernel_lock"
include/linux/smp_lock.h:12: warning: type defaults to `int' in declaration 
of `__release_kernel_lock'
include/linux/smp_lock.h:12: warning: data definition has no type or storage 
class
include/linux/smp_lock.h: In function `reacquire_kernel_lock':
include/linux/smp_lock.h:36: error: dereferencing pointer to incomplete type
include/linux/smp_lock.h: At top level:
include/linux/smp_lock.h:41: error: syntax error before "lock_kernel"
include/linux/smp_lock.h:41: warning: type defaults to `int' in declaration 
of `lock_kernel'
include/linux/smp_lock.h:41: warning: data definition has no type or storage 
class
include/linux/smp_lock.h:42: error: syntax error before "unlock_kernel"
include/linux/smp_lock.h:42: warning: type defaults to `int' in declaration 
of `unlock_kernel'
include/linux/smp_lock.h:42: warning: data definition has no type or storage 
class
In file included from include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:7,
                 from include/linux/interrupt.h:11,
                 from include/linux/spinlock.h:56,
                 from include/linux/capability.h:45,
                 from include/linux/sched.h:7,
                 from arch/i386/kernel/asm-offsets.c:7:
include/linux/irq.h:79: error: syntax error before "spinlock_t"
include/linux/irq.h:79: warning: no semicolon at end of struct or union
include/linux/irq.h:83: warning: type defaults to `int' in declaration of 
`irq_desc_t'
include/linux/irq.h:85: error: syntax error before "irq_desc"
include/linux/irq.h:85: warning: type defaults to `int' in declaration of 
`irq_desc'
include/linux/irq.h:85: warning: data definition has no type or storage 
class
include/linux/irq.h:88: error: syntax error before '*' token
include/linux/irq.h:90: warning: return type defaults to `int'
In file included from include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:7,
                 from include/linux/interrupt.h:11,
                 from include/linux/spinlock.h:56,
                 from include/linux/capability.h:45,
                 from include/linux/sched.h:7,
                 from arch/i386/kernel/asm-offsets.c:7:
include/linux/irq.h:219: error: syntax error before "irq_desc_t"
include/linux/irq.h:220: warning: function declaration isn't a prototype
make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
