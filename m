From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: My first target module is a fiasco.
Date: Mon, 15 Dec 2003 16:36:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FDDD4FD.6080204@balabit.hu>
References: <3FDDD174.5050409@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <3FDDD174.5050409@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Emmanuel Guiton wrote:
> After having written a first version of a new target module, I tried to 
> test it. Well... I does not look promising: segmentation fault, the 
> detail follows. However, what disturbs me is that I commented out 
> totally my module, leaving only some printk to have some feedback and 
> the backbone of the module: register, unregister, the static struct 
> ipt_target, and the - empty - functions that go along with it.
> To summarize: empty module; segmentation fault.

   Could you show us the code of the init function, and the static 
structure it registers? However, it looks like the kernel thinks your 
module failed to load (its __init function did not return 0), however, it 
has successfully registered its target... This is bad, since the memory 
allocated for your module is freed when your __init function returns any 
value other than zero.

> Dec 15 16:53:34 pc104 insmod: 
> /lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_SYNDIS.o: init_module: 
> Device or resource busy
> Dec 15 16:53:34 pc104 insmod: Hint: insmod errors can be caused by 
> incorrect module parameters, including invalid IO or IRQ 
> parameters.       You may find more information in syslog or the output 
> from dmesg
> Dec 15 16:53:34 pc104 insmod: 
> /lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_SYNDIS.o: insmod 
> ipt_SYNDIS failed
> Dec 15 16:53:34 pc104 kernel: SYNDIS: target registered.<1>Unable to 
> handle kernel paging request at virtual address c884c348

-- 
   Regards,
     Krisztian KOVACS
