From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [POSSIBLE PATCH] DECLARE_MUTEX while not in __KERNEL__ (Was: Re:
 [Fwd: RE: Second Request for help!!])
Date: Mon, 07 Feb 2005 18:52:05 -0500
Message-ID: <4207FF25.1060404@cookinglinux.org>
References: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>
Reply-To: sjean@cookinglinux.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, John Hill <jhill@noach.com>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>
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

I wrote on the behalf of john:
>>On Mon, February 7, 2005 9:57 am, John Hill said:
>>
>>>Kernel 2.4.29
>>>Patch-0-Matic 2005 02 01 patched for fixes and pptp
>>>iptables-1.3.0rc1
> 
> [...]
> 
>>>I have had these errors on all iptables except 1.2.11 and

Actually, I can't get iptables-1.2.11 to compile up on linux-2.4.29-bk8 too.
John, you sure you did ?

--

Harald,

I don't know if this patch breaks something, but at least am sure of something:

Into ip_tables.h, DECLARE_MUTEX is used outside of __KERNEL__ compilation.
However, DECLARE_MUTEX exists only when #ifdef __KERNEL__
according to asm/.../semaphore.h.

I couldn't track when and why this semaphore had been introduced, but linux-2.4.26
for sure doesn't use it.

May you explain me the purpose, maybe I missed something..

Thanks!

Samuel

--
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

--- include/linux/netfilter_ipv4/ip_tables.h.orig       2005-02-07 18:25:32.000000000 -0500
+++ include/linux/netfilter_ipv4/ip_tables.h    2005-02-07 18:26:17.000000000 -0500
@@ -336,9 +336,9 @@ ipt_get_target(struct ipt_entry *e)
  /*
   *     Main firewall chains definitions and global var's definitions.
   */
-static DECLARE_MUTEX(ipt_mutex);
  #ifdef __KERNEL__

+static DECLARE_MUTEX(ipt_mutex);
  #include <linux/init.h>
  extern void ipt_init(void) __init;


> ---------------------------- Original Message ----------------------------
> Subject: RE: Second Request for help!!
> From:    "John Hill" <jhill@noach.com>
> Date:    Mon, February 7, 2005 10:28 am
> To:      "'Samuel Jean'" <sj-netfilter@cookinglinux.org>
> --------------------------------------------------------------------------
> 
> I don't have access to post on the developers list.
> 
> Here is the whole compile report.
> Thanks
> --john
> 
> 
> Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag IPv6:ipv6header
> IPv6:hbh IPv6:dst IPv6:rt
> cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
> -DIPTABLES_VERSION=\"1.3.0rc1\"  -fPIC -o extensions/libipt_ah_sh.o -c
> extensions/libipt_ah.c
> In file included from include/libiptc/libiptc.h:6,
>                  from include/iptables.h:5,
>                  from extensions/libipt_ah.c:8:
> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning: type
> defaults to `int' in declaration of `DECLARE_MUTEX'
> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
> parameter names (without types) in function declaration
> /usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:339: warning:
> `DECLARE_MUTEX' declared `static' but never defined
> ld -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
 > [...]
