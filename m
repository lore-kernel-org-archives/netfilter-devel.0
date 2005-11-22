From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Tue, 22 Nov 2005 16:54:05 +0100
Message-ID: <43833F1D.3060309@tac.ch>
References: <4381A0C3.7020406@tac.ch> <438327D2.5090506@tac.ch>
	<43833BE3.8060909@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <43833BE3.8060909@tac.ch>
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

> void ip_conntrack_cleanup(void)
> {
>         ip_ct_attach = NULL;
>         /* This makes sure all current packets have passed through
>            netfilter framework.  Roll on, two-stage module
>            delete... */
>         br_write_lock_bh(BR_NETPROTO_LOCK);
>         br_write_unlock_bh(BR_NETPROTO_LOCK);
> 
>  i_see_dead_people:
>         ip_ct_iterate_cleanup(kill_all, NULL);
>         if (atomic_read(&ip_conntrack_count) != 0) {
>                 schedule();
>                 goto i_see_dead_people;
>         }
>         while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
>                 schedule();
> 
>         kmem_cache_destroy(ip_conntrack_cachep);
>         vfree(ip_conntrack_hash);
>         nf_unregister_sockopt(&so_getorigdst);
> }
> 
> I don't see where ip_conntrack_untracked.ct_general.use is > 1, ever ...

SS trap at 0xf89a7227 ([ip_conntrack]get_next_corpse+0xa7)
0xf89a7227 get_next_corpse+0xa7:    cmp    %ebx,%eax
[0]kdb> mm4 ip_conntrack_count 0
0xf89aae68 = 0x0
[0]kdb> go
lb-lb0-phys:~#


So forcing ip_conntrack_count to be 0 of course breaks the endless
schedule(). And naturally after a fw reconfiguration we oops:

kernel BUG at slab.c:815!
invalid operand: 0000
ip_conntrack ipt_limit ip_vs_wlc ip_vs ipt_LOG iptable_raw
iptable_mangle iptable_filter ip_tables
CPU:    0
EIP:    0010:[<c013bb32>]    Not tainted
EFLAGS: 00010246
EIP is at kmem_cache_create+0x262/0x3d0 [kernel]
eax: 00000000   ebx: f7ae6a98   ecx: f7ae6ba0   edx: f7295fc8
esi: f7ae6b99   edi: f89a9945   ebp: f5b1deac   esp: f5b1de84
ds: 0018   es: 0018   ss: 0018
Process modprobe (pid: 7457, stackpage=f5b1d000)
Stack: f7ae6a98 00000160 00002000 f5b1de9c f7ae6ab8 ffffffe0 00000080
00000000
       00000000 00000060 f5b1ded0 f89a7660 f89a9938 00000160 00000020
00022000
       00000000 00000000 00000000 f5b1dee8 f89a4639 ffffffea 00000000
00000060
Call Trace:
 [<f89a7660>] ip_conntrack_init+0x110/0x298 [ip_conntrack]
 [<f89a9938>] .rodata.str1.1+0x198/0x2e0 [ip_conntrack]
 [<f89a4639>] init_or_cleanup+0x19/0x1f0 [ip_conntrack]
 [<f89a4a02>] init_module+0x12/0x20 [ip_conntrack]
 [<c011f40e>] sys_init_module+0x85e/0x8c0 [kernel]
 [<f89a4060>] kill_proto+0x0/0x20 [ip_conntrack]
 [<f89ad1cc>] E ip_conntrack_hash_Rsmp_386855a5+0x2368/0xfffffebc
[ip_conntrack]
 [<f89aa168>]
__ksymtab_ip_conntrack_protocol_register_Rsmp_6e500e17+0x0/0x8
[ip_conntrack]
 [<f89a4060>] kill_proto+0x0/0x20 [ip_conntrack]
 [<c010774f>] system_call+0x33/0x38 [kernel]

Code: 0f 0b 2f 03 57 c8 37 c0 89 d0 8b 12 0f 18 02 3d 90 1b 47 c0

Entering kdb (current=0xf5b1c000, pid 7457) on processor 0 Oops: invalid
operand
due to oops @ 0xc013bb32
eax = 0x00000000 ebx = 0xf7ae6a98 ecx = 0xf7ae6ba0 edx = 0xf7295fc8
esi = 0xf7ae6b99 edi = 0xf89a9945 esp = 0xf5b1de84 eip = 0xc013bb32
ebp = 0xf5b1deac xss = 0xc0350018 xcs = 0x00000010 eflags = 0x00010246
xds = 0xf7ae0018 xes = 0x00000018 origeax = 0xffffffff &regs = 0xf5b1de50
[0]kdb> bt
Stack traceback for pid 7457
0xf5b1c000     7457     7455  1    0   R  0xf5b1c2b0 *modprobe
EBP        EIP        Function (args)
0xf5b1deac 0xc013bb32 kmem_cache_create+0x262 (0xf89a9938, 0x160, 0x20,
0x22000, 0x0)
                               kernel .text 0xc0100000 0xc013b8d0 0xc013bca0
0xf5b1ded0 0xf89a7660 [ip_conntrack]ip_conntrack_init+0x110 (0xffffffea,
0x0, 0x60, 0xffffffea)
                               ip_conntrack .text 0xf89a4060 0xf89a7550
0xf89a77e8
0xf5b1dee8 0xf89a4639 [ip_conntrack]init_or_cleanup+0x19 (0x1)
                               ip_conntrack .text 0xf89a4060 0xf89a4620
0xf89a4810
0xf5b1def4 0xf89a4a02 [ip_conntrack]init_module+0x12 (0xf89a4060,
0x8096a20, 0x916c, 0xf89ad1cc, 0xf89aa168)
                               ip_conntrack .text 0xf89a4060 0xf89a49f0
0xf89a4a10
0xf5b1dfbc 0xc011f40e sys_init_module+0x85e (0x806ab70, 0x80969c0,
0x80969c0, 0x400191d8, 0xbfffb0fc)
                               kernel .text 0xc0100000 0xc011ebb0 0xc011f470
           0xc010774f system_call+0x33
                               kernel .text 0xc0100000 0xc010771c 0xc0107754
[0]kdb> go
Catastrophic error detected
kdb_continue_catastrophic=0, type go a second time if you really want to
continue
[0]kdb> mm4 sysrq_enabled 1
0xc047bf20 = 0x1
[0]kdb> sr 7
<6>SysRq : Changing Loglevel
Loglevel set to 7
[0]kdb> sr s
SysRq : Emergency Sync
[0]kdb> sr u
SysRq : Emergency Remount R/O
[0]kdb> sr s
SysRq : Emergency Sync
[0]kdb> sr b
SysRq : Resetting

Damn! I wish I understood that conntrack stuff better ...

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
