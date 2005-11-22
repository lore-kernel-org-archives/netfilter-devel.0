From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Tue, 22 Nov 2005 15:14:42 +0100
Message-ID: <438327D2.5090506@tac.ch>
References: <4381A0C3.7020406@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4381A0C3.7020406@tac.ch>
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

> Caveats: Currently we get an oops on SMP iif:

No oops with kdb, a busyloop instead now.

>  o NOTRACK rule loaded, active and used (refcnt>0)
>  o SMP kernel
>  o connection tracking is enabled
>  o a normal rule hitting the conntrack table during lookup
>  o iptables -X; iptables -F, rmmod <all netfilter related modules>
> 
> Earlier attempts to address this issue with Pablo Neira have resulted in
> a misplaced nf_reset(skb) patch, which I have removed again, because it
> broke masquerading (IIRC). I will enable KDB and report back once I get
> time some decent stack trace.

Hmm, with kdb I get following trace (check the bt at the end):

Entering kdb (current=0xc0494000, pid 0) on processor 0 due to cpu switch
[0]kdb> cpu
Currently on cpu 0
Available cpus: 0, 1, 2, 3
[0]kdb> cpu 3

Entering kdb (current=0xf5c72000, pid 7064) on processor 3 due to cpu switch
[3]kdb> ssb
0xf89a7232 get_next_corpse+0xb2:    mov    (%esi),%eax
0xf89a7234 get_next_corpse+0xb4:    inc    %eax
0xf89a7235 get_next_corpse+0xb5:    mov    %eax,%ecx
0xf89a7237 get_next_corpse+0xb7:    mov    %eax,(%esi)
0xf89a7239 get_next_corpse+0xb9:    cmp    0xf89aad04,%ecx
0xf89a723f get_next_corpse+0xbf:    jb     0xf89a71e0 get_next_corpse+0x60
[3]kdb>
0xf89a71e0 get_next_corpse+0x60:    movl   $0x0,0xfffffff0(%ebp)
0xf89a71e7 get_next_corpse+0x67:    mov    0xf89aae64,%eax
0xf89a71ec get_next_corpse+0x6c:    mov    (%eax,%ecx,8),%ebx
0xf89a71ef get_next_corpse+0x6f:    mov    (%ebx),%edx
0xf89a71f1 get_next_corpse+0x71:    prefetchnta (%edx)
0xf89a71f4 get_next_corpse+0x74:    lea    (%eax,%ecx,8),%eax
0xf89a71f7 get_next_corpse+0x77:    jmp    0xf89a7227 get_next_corpse+0xa7
[3]kdb>
0xf89a7227 get_next_corpse+0xa7:    cmp    %ebx,%eax
0xf89a7229 get_next_corpse+0xa9:    jne    0xf89a7200 get_next_corpse+0x80
[3]kdb>
0xf89a722b get_next_corpse+0xab:    mov    0xfffffff0(%ebp),%ecx
0xf89a722e get_next_corpse+0xae:    test   %ecx,%ecx
0xf89a7230 get_next_corpse+0xb0:    jne    0xf89a7276 get_next_corpse+0xf6
[3]kdb>
0xf89a7232 get_next_corpse+0xb2:    mov    (%esi),%eax
0xf89a7234 get_next_corpse+0xb4:    inc    %eax
0xf89a7235 get_next_corpse+0xb5:    mov    %eax,%ecx
0xf89a7237 get_next_corpse+0xb7:    mov    %eax,(%esi)
0xf89a7239 get_next_corpse+0xb9:    cmp    0xf89aad04,%ecx
0xf89a723f get_next_corpse+0xbf:    jb     0xf89a71e0 get_next_corpse+0x60
[3]kdb> ss
SS trap at 0xf89a7227 ([ip_conntrack]get_next_corpse+0xa7)
0xf89a7227 get_next_corpse+0xa7:    cmp    %ebx,%eax
[3]kdb> rd
eax = 0xf89d9f08 ebx = 0xf89d9f08 ecx = 0x00001fe1 edx = 0xf89d9f08
esi = 0xf5c73f20 edi = 0x00000000 esp = 0xf5c73ef4 eip = 0xf89a7227
ebp = 0xf5c73f0c xss = 0xc0350018 xcs = 0x00000010 eflags = 0x00000287
xds = 0x00000018 xes = 0x00000018 origeax = 0xffffffff &regs = 0xf5c73ec0
[3]kdb> ss
SS trap at 0xf89a7229 ([ip_conntrack]get_next_corpse+0xa9)
0xf89a7229 get_next_corpse+0xa9:    jne    0xf89a7200 get_next_corpse+0x80
[3]kdb> rd
eax = 0xf89d9f08 ebx = 0xf89d9f08 ecx = 0x00001fe1 edx = 0xf89d9f08
esi = 0xf5c73f20 edi = 0x00000000 esp = 0xf5c73ef4 eip = 0xf89a7229
ebp = 0xf5c73f0c xss = 0xc0350018 xcs = 0x00000010 eflags = 0x00000246
xds = 0x00000018 xes = 0x00000018 origeax = 0xffffffff &regs = 0xf5c73ec0
[3]kdb> ss
SS trap at 0xf89a722b ([ip_conntrack]get_next_corpse+0xab)
0xf89a722b get_next_corpse+0xab:    mov    0xfffffff0(%ebp),%ecx
[3]kdb> rd
eax = 0xf89d9f08 ebx = 0xf89d9f08 ecx = 0x00001fe1 edx = 0xf89d9f08
esi = 0xf5c73f20 edi = 0x00000000 esp = 0xf5c73ef4 eip = 0xf89a722b
ebp = 0xf5c73f0c xss = 0xc0350018 xcs = 0x00000010 eflags = 0x00000246
xds = 0x00000018 xes = 0x00000018 origeax = 0xffffffff &regs = 0xf5c73ec0
[3]kdb> bt
Stack traceback for pid 7064
0xf5c72000     7064     7011  1    3   R  0xf5c722b0 *rmmod
EBP        EIP        Function (args)
0xf5c73f0c 0xf89a723f [ip_conntrack]get_next_corpse+0xbf (0xf89a7470,
0x0, 0xf5c73f20, 0x1fe2, 0xf5c72000)
                               ip_conntrack .text 0xf89a4060 0xf89a7180
0xf89a72d0
0xf5c73f30 0xf89a7303
[ip_conntrack]ip_ct_iterate_cleanup_Rsmp_4ff11842+0x33 (0xf89a7470, 0x0,
0x0)
                               ip_conntrack .text 0xf89a4060 0xf89a72d0
0xf89a7370
0xf5c73f44 0xf89a74f7 [ip_conntrack]ip_conntrack_cleanup+0x77
(0xf89a990f, 0xc2a7bd20, 0xc0471e20, 0xf89a4000)
                               ip_conntrack .text 0xf89a4060 0xf89a7480
0xf89a7550
0xf5c73f5c 0xf89a479f [ip_conntrack]init_or_cleanup+0x17f (0x0)
                               ip_conntrack .text 0xf89a4060 0xf89a4620
0xf89a4810
0xf5c73f68 0xf89a4a22 [ip_conntrack]fini+0x12 (0xf89a4000, 0xfffffff0,
0xf5d8b000, 0xf5c73f84, 0xf89a4000)
                               ip_conntrack .text 0xf89a4060 0xf89a4a10
0xf89a4a24
0xf5c73f8c 0xc0120641 free_module+0x111 (0xf89a4000, 0x0, 0x1000,
0xbfffde18, 0xf5c72000)
                               kernel .text 0xc0100000 0xc0120530 0xc0120660
0xf5c73fbc 0xc011f639 sys_delete_module+0x129 (0xbffffcd9, 0xbfffefd4,
0xbfffdf2c, 0x1, 0xbfffdf2c)
                               kernel .text 0xc0100000 0xc011f510 0xc011f940
           0xc010774f system_call+0x33
                               kernel .text 0xc0100000 0xc010771c 0xc0107754
[3]kdb>

Tell me if you need more info.

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
