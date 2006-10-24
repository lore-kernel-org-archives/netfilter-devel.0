From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLUSTERIP and UML crash, was [Re: --dport in uml crash]
Date: Tue, 24 Oct 2006 16:24:32 +0200
Message-ID: <453E2220.3090506@trash.net>
References: <1161644625.8705.16.camel@LAPTOP4.MSHOME>	
	<453D4D6C.5050508@trash.net>
	<1161680257.8705.31.camel@LAPTOP4.MSHOME>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oan@frozentux.net
In-Reply-To: <1161680257.8705.31.camel@LAPTOP4.MSHOME>
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

Oskar Andreasson wrote:
> Hi Patrick,
> 
> I'm sorry for the delayed reply, I had to get some sleep. The original
> problem seems to have been caused by compiling iptables-1.3.6 against
> libc6 and then running against an old libc5. It works flawless now that
> they are both the correct version.
> 
> However, I got another kernel panic from the CLUSTERIP target
> (possibly?). If not, please let me know where to get this info to:)
> 
> server1:~# iptables -A INPUT -d 192.168.0.5 -p tcp --dport 4444 -j
> CLUSTERIP --new --hashmode sourceip --clustermac 01:00:00:00:00:20
> --total-nodes 1 --local-node 1
> ip_tables: (C) 2000-2006 Netfilter Core Team
> Kernel panic - not syncing: Kernel mode fault at addr 0xa0be74, ip
> 0x400d8cbe
>  
> EIP: 0073:[<400d8cbe>] CPU: 0 Not tainted ESP: 007b:bfb31118 EFLAGS:
> 00200246
>     Not tainted
> EAX: ffffffda EBX: 00000000 ECX: 40019000 EDX: 00000400
> ESI: 08050ef0 EDI: 4014e6c0 EBP: bfb3112c DS: 007b ES: 007b
> a0bc3728:  [<a0045cf8>] notifier_call_chain+0x28/0x50
> a0bc3744:  [<a0034620>] panic+0x50/0x100
> a0bc375c:  [<a0013433>] segv+0x203/0x2d0
> a0bc3804:  [<a00131b2>] segv_handler+0x92/0x110
> a0bc3828:  [<a0013120>] segv_handler+0x0/0x110
> a0bc382c:  [<a002a328>] sig_handler_common_skas+0xa8/0xe0
> a0bc3854:  [<a002619a>] sig_handler+0x4a/0x60
> a0bc38ac:  [<a012ac26>] vsnprintf+0x396/0x590
> a0bc38dc:  [<a00172a0>] maybe_map+0x70/0xb0
> a0bc38e4:  [<a0017259>] maybe_map+0x29/0xb0
> a0bc3908:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> a0bc390c:  [<a00172fe>] do_op_one_page+0x1e/0x60
> a0bc3924:  [<a0017496>] do_buffer_op+0x156/0x1b0
> a0bc3934:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> a0bc3948:  [<a00260e5>] set_signals+0x25/0x30
> a0bc3954:  [<a007596e>] kmem_cache_alloc+0x2e/0x50
> a0bc3968:  [<a00abe11>] proc_alloc_inode+0x41/0x80
> a0bc3984:  [<a0093615>] get_new_inode_fast+0x25/0xe0
> a0bc39c0:  [<a00abf9d>] proc_get_inode+0xfd/0x180
> a0bc39c8:  [<a00923eb>] d_rehash+0x3b/0x40
> a0bc39d8:  [<a00aed07>] proc_lookup+0x97/0xa0
> a0bc3a00:  [<a0017259>] maybe_map+0x29/0xb0
> a0bc3a24:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> a0bc3a28:  [<a00172fe>] do_op_one_page+0x1e/0x60
> a0bc3a40:  [<a00173d2>] do_buffer_op+0x92/0x1b0
> a0bc3a50:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> a0bc3a5c:  [<a00176c0>] copy_chunk_to_user+0x0/0x30
> a0bc3a7c:  [<a0027a64>] setjmp_wrapper+0x34/0x40
> a0bc3a9c:  [<a0027a48>] setjmp_wrapper+0x18/0x40
> a0bc3aac:  [<a0087954>] link_path_walk+0x64/0xe0
> a0bc3ac8:  [<a001791d>] strncpy_from_user_skas+0x9d/0x120
> a0bc3ad8:  [<a0017820>] strncpy_chunk_from_user+0x0/0x60
> a0bc3b28:  [<a012abe1>] vsnprintf+0x351/0x590
> a0bc3b74:  [<a009a5f8>] seq_printf+0x28/0x50
> a0bc3b90:  [<a0055172>] print_unload_info+0x52/0xd0
> a0bc3bb0:  [<a0057321>] m_show+0x31/0xa0
> a0bc3bd8:  [<a0099f23>] seq_read+0xc3/0x340
> a0bc3c0c:  [<a00789d2>] vfs_read+0xf2/0x1e0
> a0bc3c38:  [<a0078e18>] sys_read+0x38/0x80
> a0bc3c60:  [<a0016f07>] handle_syscall+0xf7/0x1d0
> a0bc3c7c:  [<a0078de0>] sys_read+0x0/0x80
> a0bc3cb4:  [<a002a168>] userspace+0x1c8/0x2e0
> a0bc3cec:  [<a0048d10>] ____call_usermodehelper+0x0/0xc0
> a0bc3cfc:  [<a0048d10>] ____call_usermodehelper+0x0/0xc0
> a0bc3d04:  [<a0016a5a>] new_thread_handler+0x9a/0xb0
> a0bc3d48:  [<a00169c0>] new_thread_handler+0x0/0xb0
> a0bc3d5c:  [<a01e4c41>] kill+0x11/0x20

This looks UML module-load related. The command works fine here
(with -i interface, otherwise it complains about a missing device).
Does it also happen with other auto-loaded modules or when
manually loading ipt_CLUSTERIP?
