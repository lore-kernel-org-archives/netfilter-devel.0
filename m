From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: My first target module is a fiasco.
Date: Mon, 15 Dec 2003 17:21:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FDDD174.5050409@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hei!

After having written a first version of a new target module, I tried to 
test it. Well... I does not look promising: segmentation fault, the 
detail follows. However, what disturbs me is that I commented out 
totally my module, leaving only some printk to have some feedback and 
the backbone of the module: register, unregister, the static struct 
ipt_target, and the - empty - functions that go along with it.
To summarize: empty module; segmentation fault.

Can an enlighted and experienced mind points out my gaps?

          Emmanuel

PS: in the following logs, ipt_SYNDIS is my target, and one can notice 
at the 4th line the following: "SYNDIS: target registered." which is the 
result of a printk I inserted at the end of my static int __init 
init(void) function, just before to return.


Dec 15 16:53:34 pc104 insmod: 
/lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_SYNDIS.o: init_module: 
Device or resource busy
Dec 15 16:53:34 pc104 insmod: Hint: insmod errors can be caused by 
incorrect module parameters, including invalid IO or IRQ 
parameters.       You may find more information in syslog or the output 
from dmesg
Dec 15 16:53:34 pc104 insmod: 
/lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_SYNDIS.o: insmod 
ipt_SYNDIS failed
Dec 15 16:53:34 pc104 kernel: SYNDIS: target registered.<1>Unable to 
handle kernel paging request at virtual address c884c348
Dec 15 16:53:34 pc104 kernel:  printing eip:
Dec 15 16:53:34 pc104 kernel: c026f5a6
Dec 15 16:53:34 pc104 kernel: *pde = 07fbe067
Dec 15 16:53:34 pc104 kernel: *pte = 00000000
Dec 15 16:53:34 pc104 kernel: Oops: 0000
Dec 15 16:53:34 pc104 kernel: CPU:    0
Dec 15 16:53:34 pc104 kernel: EIP:    0010:[find_inlist_lock+198/368]    
Not tainted
Dec 15 16:53:34 pc104 kernel: EFLAGS: 00010216
Dec 15 16:53:34 pc104 kernel: eax: c031ea53   ebx: c88480de   ecx: 
c031ea20   edx: c884c340
Dec 15 16:53:34 pc104 kernel: esi: c88480df   edi: c884c348   ebp: 
c0b35b84   esp: c0b35b2c
Dec 15 16:53:34 pc104 kernel: ds: 0018   es: 0018   ss: 0018
Dec 15 16:53:34 pc104 kernel: Process iptables (pid: 593, 
stackpage=c0b35000)
Dec 15 16:53:34 pc104 kernel: Stack: 00000286 5f747069 444e5953 c0005349 
c02ddcfc 00000001 c7fbe128 c0135843
Dec 15 16:53:34 pc104 kernel:        00000000 c0131857 c02ddb1c c02ddcf4 
00000000 00000000 0000042c c0101c88
Dec 15 16:53:34 pc104 kernel:        0004a000 c0b35b60 00000000 c88480dc 
00000001 c8848040 0000009c c026fc8c
Dec 15 16:53:34 pc104 kernel: Call Trace:    [__alloc_pages+99/656] 
[get_vm_area+23/240] [translate_table+1116/1616] [do_replace+379/1072] 
[do_ipt_set_ctl+87/112]
Dec 15 16:53:34 pc104 kernel:   [nf_sockopt+289/304] 
[nf_setsockopt+32/48] [ip_setsockopt+1577/3696] [nf_sockopt+170/304] 
[nf_getsockopt+32/48] [ip_getsockopt+2562/3316]
Dec 15 16:53:34 pc104 kernel:   [enable_irq+97/176] 
[ide_do_request+288/832] [schedule+627/1488] [__alloc_pages+99/656] 
[lru_cache_add+110/128] [do_anonymous_page+269/288]
Dec 15 16:53:34 pc104 kernel:   [do_no_page+458/480] 
[handle_mm_fault+190/208] [vsnprintf+727/1136] [do_page_fault+786/1271] 
[inet_setsockopt+37/48] [sys_setsockopt+69/128]
Dec 15 16:53:34 pc104 kernel:   [sys_socketcall+408/496] 
[do_page_fault+0/1271] [error_code+52/60] [system_call+51/56]
Dec 15 16:53:34 pc104 kernel:
Dec 15 16:53:34 pc104 kernel: Code: ae 75 08 84 c0 75 f8 31 c0 eb 04 19 
c0 0c 01 85 c0 75 2e 89
Dec 15 16:54:14 pc104 syslog: Kernel log daemon terminating.
