From: Manu <manuprivat@gmx.de>
Subject: Re: RAWNAT kernel crash
Date: Tue, 15 Jul 2008 13:43:09 +0200
Message-ID: <487C8D4D.7080907@gmx.de>
References: <4875D2DC.9040107@gmx.de> <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr> <4875DCD0.9070107@gmx.de> <alpine.LNX.1.10.0807101209050.27323@fbirervta.pbzchgretzou.qr> <4875EF77.8060700@gmx.de> <4875F12E.3010709@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060008070208040206090803"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752913AbYGOLnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:43:15 -0400
In-Reply-To: <4875F12E.3010709@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060008070208040206090803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Manu schrieb:
> Manu schrieb:
>> Jan Engelhardt schrieb:
>>> (and don't strip the mailing list from cc)
>>>
>>> On Thursday 2008-07-10 11:56, Manu wrote:
>>>  
>>>>>> I can set the rules but everytime I want to send traffic through 
>>>>>> the rules
>>>>>> I got a system crash!?
>>>>>>         
>>>>> I will investigate... I assume you do have dcd0c66 at least?
>>>>>         
>>>> I don't know what you mean with dcd0c66. I downloaded the snapshot of
>>>> 2008-04-28
>>>>     
>>>
>>> Ah ok, if you click on that you will see "commit
>>> dcd0c661355bc5ff95d3a587c49fa59d8c4a8fef"
>>>
>>>  
>>>>> Posting the crash would be helpful.
>>>>>       
>>>> What exactly do you mean with posting the crash?
>>>>     
>>>
>>> Kernel log, oops dump. If you just say "crash", then that could be
>>> anything, with cosmic rays to begin.
>>>
>>>   
>> maybe this is already helpful - i will work on further informations 
>> about the "crash"
>>
>>
>> <3>compat_xtables: compat layer limits reached 
>> (xtnu_skb_make_writable) - dropping packets
>> <3>compat_xtables: compat layer limits reached 
>> (xtnu_skb_make_writable) - dropping packets
>> <1>BUG: unable to handle kernel NULL pointer dereference at virtual 
>> address 00000004
>> <1> printing eip:
>> <4>c02acd98
>> <1>*pde = 00000000
>> <0>Oops: 0002 [#1]
>> <0>PREEMPT
>> <4>Modules linked in: iptable_rawpost xt_RAWNAT compat_xtables ebt_ip 
>> ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too 
>> cramfs
>> <0>CPU:    0
>> <0>EIP:    0060:[<c02acd98>]    Not tainted VLI
>> <0>EFLAGS: 00010047   (2.6.23.9-default #26)
>> <0>EIP is at skb_dequeue+0x21/0x4d
>> <0>eax: 00000000   ebx: c4cf93c0   ecx: 00000246   edx: c5a06c60
>> <0>esi: c5a06c00   edi: 00000000   ebp: c512fe2c   esp: c512fdfc
>> <0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
>>
I have got further informations about the "crash". I activated the 
kernel debug and I adjusted the "crash" 3 times -> I got everytime 
different log-messages?!
see attachment!
I think the "crash" happens after a paket passes the table of the 
iptable rule "-t raw -I PREROUTING -s x.x.x.x -j RAWSNAT --to-source 
x.x.x.x"
I can see that the table "-t rawpost -I POSTROUTING -d x.x.x.x -j 
RAWDNAT --to-destination x.x.x.x" can be passed by a few pakets withour 
a "crash".
I don't know how to collect more informations about the crash? What else 
can I do to provide more informations about it to you?

Regards,
Manu



--------------060008070208040206090803
Content-Type: text/plain;
 name="kernel_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_log"

klogd 1.4.1, log source = /proc/kmsg started.
Cannot find map file.
No module symbols loaded - kernel modules not enabled.

Cannot build symbol table - disabling symbol lookups
<7>kobject holders: unregistering
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject holders: cleaning up
<7>kobject xt_RAWNAT: unregistering
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/xt_RAWNAT'
<7>kobject xt_RAWNAT: cleaning up
<7>kobject xt_RAWNAT: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: xt_RAWNAT, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/xt_RAWNAT'
<6>device eth0 entered promiscuous mode
<5>audit(1216114343.672:13): dev=eth0 prom=256 old_prom=0 auid=4294967295
<6>device eth0 left promiscuous mode
<5>audit(1216114344.804:14): dev=eth0 prom=0 old_prom=256 auid=4294967295
<3>compat_xtables: compat layer limits reached (xtnu_skb_make_writable) - dropping packets
<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000001
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#1]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Not tainted VLI
<0>EFLAGS: 00010002   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 00000001   ecx: c0483b18   edx: c10a9720
<0>esi: 00000296   edi: 00000001   ebp: 000000d0   esp: c5255eb4
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process userstatus (pid: 11776, ti=c5254000 task=c40c3500 task.ti=c5254000)
<0>Stack: bffffff3 c623fd00 c0483b18 00000000 c045aa5c c61bf200 c61bf200 c017c3a5 
<0>       00000000 056ab067 00000007 00000000 056ab067 00000007 bfffff22 00000010 
<0>       00000000 00000007 c6514b58 00000000 bfffff22 c0145bfa c40c3500 00000020 
<0>Call Trace:
<0> [<c017c3a5>] load_elf_binary+0x68/0xb89
<0> [<c0145bfa>] get_user_pages+0x1f7/0x244
<0> [<c01ea803>] copy_from_user+0x31/0x52
<0> [<c01590fa>] search_binary_handler+0xe3/0x259
<0> [<c017c33d>] load_elf_binary+0x0/0xb89
<0> [<c015938c>] do_execve+0x11c/0x171
<0> [<c0102c69>] sys_execve+0x2d/0x7c
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c5255eb4
<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000001
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#2]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010002   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 00000001   ecx: c0483b18   edx: c10a9720
<0>esi: 00000296   edi: 00000001   ebp: 000000d0   esp: c48d7eb4
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process userstatus (pid: 11779, ti=c48d6000 task=c4224a80 task.ti=c48d6000)
<0>Stack: bffffff3 c623f1a0 c0483b18 00000000 c045aa5c c61bf400 c61bf400 c017c3a5 
<0>       00000000 05f4b067 00000007 00000000 05f4b067 00000007 bfffff23 00000010 
<0>       00000000 00000007 c6514c08 00000000 bfffff23 c0145bfa c4224a80 00000020 
<0>Call Trace:
<0> [<c017c3a5>] load_elf_binary+0x68/0xb89
<0> [<c0145bfa>] get_user_pages+0x1f7/0x244
<0> [<c01ea803>] copy_from_user+0x31/0x52
<0> [<c01590fa>] search_binary_handler+0xe3/0x259
<0> [<c017c33d>] load_elf_binary+0x0/0xb89
<0> [<c015938c>] do_execve+0x11c/0x171
<0> [<c0102c69>] sys_execve+0x2d/0x7c
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c48d7eb4
<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000001
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#3]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010002   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 00000001   ecx: c0483b18   edx: c10a9720
<0>esi: 00000286   edi: 00000001   ebp: 000000d0   esp: c415fec0
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process userstatus (pid: 11778, ti=c415e000 task=c40c3500 task.ti=c415e000)
<0>Stack: 00000001 000200d0 c0483b18 c4224000 c415ff24 c54b93c0 c4224000 c011372b 
<0>       c471e5f0 c10a7120 00000000 c0128ad0 c011378e 00000000 0026e98f 00000000 
<0>       00000000 c422414c 00135416 fffffff2 c4224000 00000000 00000001 c4224000 
<0>Call Trace:
<0> [<c011372b>] alloc_files+0x12/0x5f
<0> [<c0128ad0>] getnstimeofday+0x30/0xee
<0> [<c011378e>] dup_fd+0x16/0x222
<0> [<c01139d0>] copy_files+0x36/0x4d
<0> [<c0113e18>] copy_process+0x3a9/0xcc0
<0> [<c012326c>] alloc_pid+0x11/0xba
<0> [<c01147d3>] do_fork+0xa4/0x176
<0> [<c0102bcd>] sys_fork+0x2c/0x30
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c415fec0
<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000001
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#4]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010002   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 00000001   ecx: c0483b18   edx: c10a9720
<0>esi: 00000286   edi: 00000001   ebp: 000000d0   esp: c4d91ec0
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process userstatus (pid: 2810, ti=c4d90000 task=c5ae6000 task.ti=c4d90000)
<0>Stack: 00000001 000200d0 c0483b18 c537c540 c4d91f24 c597c6c0 c537c540 c011372b 
<0>       ffffffff 000000d0 c0113001 c0128ad0 c011378e 00000000 0044b683 00000000 
<0>       00000000 c537c68c 00135416 fffffff2 c537c540 00000000 00000001 c537c540 
<0>Call Trace:
<0> [<c011372b>] alloc_files+0x12/0x5f
<0> [<c0113001>] dup_task_struct+0x1a/0x94
<0> [<c0128ad0>] getnstimeofday+0x30/0xee
<0> [<c011378e>] dup_fd+0x16/0x222
<0> [<c01139d0>] copy_files+0x36/0x4d
<0> [<c0113e18>] copy_process+0x3a9/0xcc0
<0> [<c012326c>] alloc_pid+0x11/0xba
<0> [<c01147d3>] do_fork+0xa4/0x176
<0> [<c015aa7b>] do_pipe+0x8e/0xdc
<0> [<c0102bcd>] sys_fork+0x2c/0x30
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c4d91ec0
<1>BUG: unable to handle kernel paging request at virtual address 4b990000
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#5]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010006   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 4b990000   ecx: c0483b18   edx: c10a9720
<0>esi: 00000296   edi: 4b990000   ebp: 000000d0   esp: c6bb1eb4
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process bonprinterin (pid: 11783, ti=c6bb0000 task=c537da40 task.ti=c6bb0000)
<0>Stack: bffffff1 c623fb60 c0483b18 00000000 c045aa5c c45b8800 c45b8800 c017c3a5 
<0>       00000000 06217067 00000007 00000000 06217067 00000007 bfffff32 00000010 
<0>       00000000 00000007 c65145d8 00000000 bfffff32 c0145bfa c537da40 00000020 
<0>Call Trace:
<0> [<c017c3a5>] load_elf_binary+0x68/0xb89
<0> [<c0145bfa>] get_user_pages+0x1f7/0x244
<0> [<c01ea803>] copy_from_user+0x31/0x52
<0> [<c01590fa>] search_binary_handler+0xe3/0x259
<0> [<c017c33d>] load_elf_binary+0x0/0xb89
<0> [<c015938c>] do_execve+0x11c/0x171
<0> [<c0102c69>] sys_execve+0x2d/0x7c
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c6bb1eb4
<1>BUG: unable to handle kernel paging request at virtual address 4b990000
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#6]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010006   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 4b990000   ecx: c0483b18   edx: c10a9720
<0>esi: 00000286   edi: 4b990000   ebp: 000000d0   esp: c6405ec0
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process bonprinterin (pid: 3130, ti=c6404000 task=c6dac000 task.ti=c6404000)
<0>Stack: 00000001 000200d0 c0483b18 c5ae6000 c6405f24 c597c900 c5ae6000 c011372b 
<0>       ffffffff 000000d0 c0113001 c0128ad0 c011378e 00000000 002bb84e 00000000 
<0>       00000000 c5ae614c 001355a0 fffffff2 c5ae6000 00000000 00000001 c5ae6000 
<0>Call Trace:
<0> [<c011372b>] alloc_files+0x12/0x5f
<0> [<c0113001>] dup_task_struct+0x1a/0x94
<0> [<c0128ad0>] getnstimeofday+0x30/0xee
<0> [<c011378e>] dup_fd+0x16/0x222
<0> [<c01139d0>] copy_files+0x36/0x4d
<0> [<c0113e18>] copy_process+0x3a9/0xcc0
<0> [<c012326c>] alloc_pid+0x11/0xba
<0> [<c01147d3>] do_fork+0xa4/0x176
<0> [<c0102bcd>] sys_fork+0x2c/0x30
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c6405ec0
<1>BUG: unable to handle kernel paging request at virtual address 4b990000
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#7]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Tainted: G      D VLI
<0>EFLAGS: 00010006   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 4b990000   ecx: c0483b18   edx: c10a9720
<0>esi: 00000286   edi: 4b990000   ebp: 000000d0   esp: c66ffec0
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process wlancheck (pid: 11786, ti=c66fe000 task=c537cfc0 task.ti=c66fe000)
<0>Stack: 00000001 000200d0 c0483b18 c40c3500 c66fff24 c54b93c0 c40c3500 c011372b 
<0>       ffffffff 000000d0 c0113001 c0128ad0 c011378e 00000000 004c4451 00000000 
<0>       00000000 c40c364c 001355aa fffffff2 c40c3500 00000000 00000001 c40c3500 
<0>Call Trace:
<0> [<c011372b>] alloc_files+0x12/0x5f
<0> [<c0113001>] dup_task_struct+0x1a/0x94
<0> [<c0128ad0>] getnstimeofday+0x30/0xee
<0> [<c011378e>] dup_fd+0x16/0x222
<0> [<c01139d0>] copy_files+0x36/0x4d
<0> [<c0113e18>] copy_process+0x3a9/0xcc0
<0> [<c012326c>] alloc_pid+0x11/0xba
<0> [<c01147d3>] do_fork+0xa4/0x176
<0> [<c015aa7b>] do_pipe+0x8e/0xdc
<0> [<c0102bcd>] sys_fork+0x2c/0x30
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c66ffec0
<1>BUG: unable to handle kernel paging request at virtual address 4b990000
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#8]
<0>PREEMPT 
<4>Modules linked in: xt_RAWNAT iptable_rawpost compat_xtables ebtable_filter ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0

--------------060008070208040206090803
Content-Type: text/plain;
 name="kernel_log2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_log2"

klogd 1.4.1, log source = /proc/kmsg started.
Cannot find map file.
No module symbols loaded - kernel modules not enabled.

Cannot build symbol table - disabling symbol lookups
 devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0303:00'
<7>kobject LNXTHERM:00: registering. parent: LNXSYSTM:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/LNXSYSTM:00/LNXTHERM:00'
<7>kobject ec: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/acpi/drivers/ec'
<7>kobject power: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/acpi/drivers/power'
<7>kobject tables: registering. parent: acpi, set: <NULL>
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/firmware/acpi/tables'
<6>Linux Plug and Play Support v0.97 (c) Adam Belay
<7>kobject pnp: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp'
<7>kobject devices: registering. parent: pnp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: pnp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>pnp: PnP ACPI init
<7>kobject pnp0: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>ACPI: bus type pnp registered
<7>kobject 00:00: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:00'
<7>kobject 00:01: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:01'
<7>kobject 00:02: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:02'
<7>kobject 00:03: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:03'
<7>kobject 00:04: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:04'
<7>kobject 00:05: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:05'
<7>kobject 00:06: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:06'
<7>kobject 00:07: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:07'
<7>kobject 00:08: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:08'
<7>kobject 00:09: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:09'
<7>kobject 00:0a: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:0a'
<6>pnp: PnP ACPI: found 11 devices
<6>ACPI: ACPI bus type pnp unregistered
<7>kobject misc: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc'
<7>kobject scsi_host: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host'
<7>kobject scsi: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/scsi'
<7>kobject devices: registering. parent: scsi, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: scsi, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject scsi_device: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_device'
<5>SCSI subsystem initialized
<7>libata version 2.21 loaded.
<7>kobject usb: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb'
<7>kobject devices: registering. parent: usb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: usb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usb_host: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host'
<7>kobject usbfs: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usbfs'
<7>kobject drivers: registering. parent: usbcore, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usbfs
<7>kobject hub: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/hub'
<6>usbcore: registered new interface driver hub
<7>kobject usb: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usb'
<6>usbcore: registered new device driver usb
<7>kobject serio: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio'
<7>kobject devices: registering. parent: serio, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: serio, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject input: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input'
<7>kobject i2c: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/i2c'
<7>kobject devices: registering. parent: i2c, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: i2c, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject i2c-adapter: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/i2c-adapter'
<4>PCI: Probing PCI hardware
<7>PCI: Probing PCI hardware (bus 00)
<7>kobject pci0000:00: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject 0000:00: registering. parent: pci_bus, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/pci_bus/0000:00'
<4>PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
<4>PCI quirk: region 5000-500f claimed by vt82c686 SMB
<7>kobject 0000:01: registering. parent: pci_bus, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/pci_bus/0000:01'
<7>kobject 0000:00:00.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.0'
<7>kobject 0000:00:01.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0'
<7>kobject 0000:00:07.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
<7>kobject 0000:00:07.1: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1'
<7>kobject 0000:00:07.2: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2'
<7>kobject 0000:00:07.3: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3'
<7>kobject 0000:00:07.4: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.4'
<7>kobject 0000:00:07.5: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.5'
<7>kobject 0000:00:08.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
<7>kobject 0000:00:09.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
<7>kobject 0000:00:0b.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0'
<7>kobject 0000:01:00.0: registering. parent: 0000:00:01.0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:00.0'
<6>PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
<7>kobject net: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net'
<6>Time: tsc clocksource has been installed.
<7>kobject system: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/system'
<6>pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
<6>pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
<6>pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
<6>pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
<7>kobject mem: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem'
<7>kobject mem: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/mem'
<7>kobject kmem: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/kmem'
<7>kobject null: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/null'
<7>kobject port: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/port'
<7>kobject zero: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/zero'
<7>kobject full: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/full'
<7>kobject random: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/random'
<7>kobject urandom: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/urandom'
<7>kobject kmsg: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/kmsg'
<6>PCI: Bridge: 0000:00:01.0
<6>  IO window: disabled.
<6>  MEM window: e4000000-e6ffffff
<6>  PREFETCH window: 10000000-100fffff
<7>PCI: Setting latency timer of device 0000:00:01.0 to 64
<6>NET: Registered protocol family 2
<6>IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
<6>TCP established hash table entries: 4096 (order: 3, 32768 bytes)
<6>TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
<6>TCP: Hash tables configured (established 4096 bind 4096)
<6>TCP reno registered
<6>checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
<6>Freeing initrd memory: 1085k freed
<7>kobject i8259: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8259'
<7>kobject i82590: registering. parent: <NULL>, set: i8259
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8259/i82590'
<7>kobject i8237: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8237'
<7>kobject i82370: registering. parent: <NULL>, set: i8237
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8237/i82370'
<7>kobject pcspkr: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject timekeeping: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/timekeeping'
<7>kobject timekeeping0: registering. parent: <NULL>, set: timekeeping
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/timekeeping/timekeeping0'
<7>kobject clocksource: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/clocksource'
<7>kobject clocksource0: registering. parent: <NULL>, set: clocksource
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/clocksource/clocksource0'
<6>audit: initializing netlink socket (disabled)
<5>audit(1216114636.808:1): initialized
<3>audit: cannot initialize inotify handle
<7>kobject slab: registering. parent: <NULL>, set: <NULL>
<7>kobject_uevent_env
<7>kobject attempted to send uevent without kset!
<7>kobject shmem_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/shmem_inode_cache'
<7>kobject :0000288: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000288'
<7>kobject :0000448: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000448'
<7>kobject :0000480: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000480'
<7>kobject :0001056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001056'
<7>kobject :0000104: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000104'
<7>kobject :0000912: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000912'
<7>kobject :0000184: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000184'
<7>kobject :0003072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0003072'
<7>kobject :0001536: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001536'
<7>kobject :0000768: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000768'
<7>kobject sock_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/sock_inode_cache'
<7>kobject :0000352: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000352'
<7>kobject file_lock_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/file_lock_cache'
<7>kobject :0000048: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000048'
<7>kobject :0000024: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000024'
<7>kobject proc_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/proc_inode_cache'
<7>kobject :0000144: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000144'
<7>kobject radix_tree_node: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/radix_tree_node'
<7>kobject bdev_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/bdev_cache'
<7>kobject :0000056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000056'
<7>kobject inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/inode_cache'
<7>kobject :a-0000128: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000128'
<7>kobject idr_layer_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/idr_layer_cache'
<7>kobject :a-0000056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000056'
<7>kobject :0000416: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000416'
<7>kobject :0000088: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000088'
<7>kobject :0000384: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000384'
<7>kobject sighand_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/sighand_cache'
<7>kobject :0001344: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001344'
<7>kobject anon_vma: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/anon_vma'
<7>kobject :0000040: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000040'
<7>kobject :4194304: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:4194304'
<7>kobject :2097152: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:2097152'
<7>kobject :1048576: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:1048576'
<7>kobject :0524288: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0524288'
<7>kobject :0262144: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0262144'
<7>kobject :0131072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0131072'
<7>kobject :0065536: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0065536'
<7>kobject :0032768: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0032768'
<7>kobject :0016384: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0016384'
<7>kobject :0008192: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0008192'
<7>kobject :0004096: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0004096'
<7>kobject :0002048: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0002048'
<7>kobject :0001024: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001024'
<7>kobject :0000512: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000512'
<7>kobject :0000256: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000256'
<7>kobject :0000128: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000128'
<7>kobject :0000064: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000064'
<7>kobject :0000032: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000032'
<7>kobject :0000016: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000016'
<7>kobject :0000008: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000008'
<7>kobject :0000192: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000192'
<7>kobject :0000096: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000096'
<7>kobject :0000160: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000160'
<7>kobject ext2_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/ext2_inode_cache'
<7>kobject minix_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/minix_inode_cache'
<7>kobject fat_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/fat_cache'
<7>kobject fat_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/fat_inode_cache'
<7>kobject isofs_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/isofs_inode_cache'
<7>kobject nfs_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/nfs_inode_cache'
<7>kobject :a-0000072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000072'
<7>kobject mqueue_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/mqueue_inode_cache'
<6>io scheduler noop registered
<6>io scheduler deadline registered (default)
<6>PCI: VIA PCI bridge detected. Disabling DAC.
<7>Boot video device is 0000:01:00.0
<7>kobject pnp1: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>isapnp: Scanning for PnP cards...
<6>isapnp: No Plug & Play device found
<7>kobject tty: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty'
<7>kobject console: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/console'
<7>kobject ptmx: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptmx'
<7>kobject tty0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty0'
<7>kobject vc: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc'
<7>kobject vcs: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs'
<7>kobject vcsa: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa'
<7>kobject tty1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty1'
<7>kobject tty2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty2'
<7>kobject tty3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty3'
<7>kobject tty4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty4'
<7>kobject tty5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty5'
<7>kobject tty6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty6'
<7>kobject tty7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty7'
<7>kobject tty8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty8'
<7>kobject tty9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty9'
<7>kobject tty10: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty10'
<7>kobject tty11: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty11'
<7>kobject tty12: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty12'
<7>kobject tty13: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty13'
<7>kobject tty14: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty14'
<7>kobject tty15: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty15'
<7>kobject tty16: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty16'
<7>kobject tty17: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty17'
<7>kobject tty18: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty18'
<7>kobject tty19: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty19'
<7>kobject tty20: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty20'
<7>kobject tty21: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty21'
<7>kobject tty22: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty22'
<7>kobject tty23: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty23'
<7>kobject tty24: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty24'
<7>kobject tty25: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty25'
<7>kobject tty26: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty26'
<7>kobject tty27: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty27'
<7>kobject tty28: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty28'
<7>kobject tty29: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty29'
<7>kobject tty30: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty30'
<7>kobject tty31: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty31'
<7>kobject tty32: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty32'
<7>kobject tty33: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty33'
<7>kobject tty34: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty34'
<7>kobject tty35: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty35'
<7>kobject tty36: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty36'
<7>kobject tty37: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty37'
<7>kobject tty38: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty38'
<7>kobject tty39: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty39'
<7>kobject tty40: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty40'
<7>kobject tty41: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty41'
<7>kobject tty42: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty42'
<7>kobject tty43: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty43'
<7>kobject tty44: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty44'
<7>kobject tty45: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty45'
<7>kobject tty46: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty46'
<7>kobject tty47: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty47'
<7>kobject tty48: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty48'
<7>kobject tty49: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty49'
<7>kobject tty50: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty50'
<7>kobject tty51: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty51'
<7>kobject tty52: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty52'
<7>kobject tty53: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty53'
<7>kobject tty54: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty54'
<7>kobject tty55: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty55'
<7>kobject tty56: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty56'
<7>kobject tty57: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty57'
<7>kobject tty58: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty58'
<7>kobject tty59: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty59'
<7>kobject tty60: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty60'
<7>kobject tty61: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty61'
<7>kobject tty62: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty62'
<7>kobject tty63: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty63'
<7>kobject ptyp0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp0'
<7>kobject ptyp1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp1'
<7>kobject ptyp2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp2'
<7>kobject ptyp3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp3'
<7>kobject ptyp4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp4'
<7>kobject ptyp5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp5'
<7>kobject ptyp6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp6'
<7>kobject ptyp7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp7'
<7>kobject ptyp8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp8'
<7>kobject ptyp9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp9'
<7>kobject ptypa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypa'
<7>kobject ptypb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypb'
<7>kobject ptypc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypc'
<7>kobject ptypd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypd'
<7>kobject ptype: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptype'
<7>kobject ptypf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypf'
<7>kobject ptyq0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq0'
<7>kobject ptyq1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq1'
<7>kobject ptyq2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq2'
<7>kobject ptyq3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq3'
<7>kobject ptyq4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq4'
<7>kobject ptyq5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq5'
<7>kobject ptyq6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq6'
<7>kobject ptyq7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq7'
<7>kobject ptyq8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq8'
<7>kobject ptyq9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq9'
<7>kobject ptyqa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqa'
<7>kobject ptyqb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqb'
<7>kobject ptyqc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqc'
<7>kobject ptyqd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqd'
<7>kobject ptyqe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqe'
<7>kobject ptyqf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqf'
<7>kobject ptyr0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr0'
<7>kobject ptyr1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr1'
<7>kobject ptyr2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr2'
<7>kobject ptyr3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr3'
<7>kobject ptyr4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr4'
<7>kobject ptyr5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr5'
<7>kobject ptyr6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr6'
<7>kobject ptyr7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr7'
<7>kobject ptyr8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr8'
<7>kobject ptyr9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr9'
<7>kobject ptyra: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyra'
<7>kobject ptyrb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrb'
<7>kobject ptyrc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrc'
<7>kobject ptyrd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrd'
<7>kobject ptyre: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyre'
<7>kobject ptyrf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrf'
<7>kobject ptys0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys0'
<7>kobject ptys1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys1'
<7>kobject ptys2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys2'
<7>kobject ptys3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys3'
<7>kobject ptys4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys4'
<7>kobject ptys5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys5'
<7>kobject ptys6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys6'
<7>kobject ptys7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys7'
<7>kobject ptys8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys8'
<7>kobject ptys9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys9'
<7>kobject ptysa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysa'
<7>kobject ptysb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysb'
<7>kobject ptysc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysc'
<7>kobject ptysd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysd'
<7>kobject ptyse: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyse'
<7>kobject ptysf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysf'
<7>kobject ptyt0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt0'
<7>kobject ptyt1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt1'
<7>kobject ptyt2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt2'
<7>kobject ptyt3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt3'
<7>kobject ptyt4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt4'
<7>kobject ptyt5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt5'
<7>kobject ptyt6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt6'
<7>kobject ptyt7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt7'
<7>kobject ptyt8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt8'
<7>kobject ptyt9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt9'
<7>kobject ptyta: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyta'
<7>kobject ptytb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytb'
<7>kobject ptytc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytc'
<7>kobject ptytd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytd'
<7>kobject ptyte: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyte'
<7>kobject ptytf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytf'
<7>kobject ptyu0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu0'
<7>kobject ptyu1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu1'
<7>kobject ptyu2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu2'
<7>kobject ptyu3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu3'
<7>kobject ptyu4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu4'
<7>kobject ptyu5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu5'
<7>kobject ptyu6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu6'
<7>kobject ptyu7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu7'
<7>kobject ptyu8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu8'
<7>kobject ptyu9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu9'
<7>kobject ptyua: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyua'
<7>kobject ptyub: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyub'
<7>kobject ptyuc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyuc'
<7>kobject ptyud: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyud'
<7>kobject ptyue: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyue'
<7>kobject ptyuf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyuf'
<7>kobject ptyv0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv0'
<7>kobject ptyv1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv1'
<7>kobject ptyv2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv2'
<7>kobject ptyv3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv3'
<7>kobject ptyv4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv4'
<7>kobject ptyv5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv5'
<7>kobject ptyv6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv6'
<7>kobject ptyv7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv7'
<7>kobject ptyv8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv8'
<7>kobject ptyv9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv9'
<7>kobject ptyva: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyva'
<7>kobject ptyvb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvb'
<7>kobject ptyvc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvc'
<7>kobject ptyvd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvd'
<7>kobject ptyve: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyve'
<7>kobject ptyvf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvf'
<7>kobject ptyw0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw0'
<7>kobject ptyw1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw1'
<7>kobject ptyw2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw2'
<7>kobject ptyw3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw3'
<7>kobject ptyw4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw4'
<7>kobject ptyw5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw5'
<7>kobject ptyw6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw6'
<7>kobject ptyw7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw7'
<7>kobject ptyw8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw8'
<7>kobject ptyw9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw9'
<7>kobject ptywa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywa'
<7>kobject ptywb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywb'
<7>kobject ptywc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywc'
<7>kobject ptywd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywd'
<7>kobject ptywe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywe'
<7>kobject ptywf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywf'
<7>kobject ptyx0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx0'
<7>kobject ptyx1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx1'
<7>kobject ptyx2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx2'
<7>kobject ptyx3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx3'
<7>kobject ptyx4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx4'
<7>kobject ptyx5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx5'
<7>kobject ptyx6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx6'
<7>kobject ptyx7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx7'
<7>kobject ptyx8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx8'
<7>kobject ptyx9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx9'
<7>kobject ptyxa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxa'
<7>kobject ptyxb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxb'
<7>kobject ptyxc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxc'
<7>kobject ptyxd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxd'
<7>kobject ptyxe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxe'
<7>kobject ptyxf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxf'
<7>kobject ptyy0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy0'
<7>kobject ptyy1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy1'
<7>kobject ptyy2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy2'
<7>kobject ptyy3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy3'
<7>kobject ptyy4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy4'
<7>kobject ptyy5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy5'
<7>kobject ptyy6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy6'
<7>kobject ptyy7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy7'
<7>kobject ptyy8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy8'
<7>kobject ptyy9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy9'
<7>kobject ptyya: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyya'
<7>kobject ptyyb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyb'
<7>kobject ptyyc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyc'
<7>kobject ptyyd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyd'
<7>kobject ptyye: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyye'
<7>kobject ptyyf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyf'
<7>kobject ptyz0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz0'
<7>kobject ptyz1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz1'
<7>kobject ptyz2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz2'
<7>kobject ptyz3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz3'
<7>kobject ptyz4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz4'
<7>kobject ptyz5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz5'
<7>kobject ptyz6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz6'
<7>kobject ptyz7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz7'
<7>kobject ptyz8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz8'
<7>kobject ptyz9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz9'
<7>kobject ptyza: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyza'
<7>kobject ptyzb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzb'
<7>kobject ptyzc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzc'
<7>kobject ptyzd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzd'
<7>kobject ptyze: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyze'
<7>kobject ptyzf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzf'
<7>kobject ptya0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya0'
<7>kobject ptya1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya1'
<7>kobject ptya2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya2'
<7>kobject ptya3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya3'
<7>kobject ptya4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya4'
<7>kobject ptya5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya5'
<7>kobject ptya6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya6'
<7>kobject ptya7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya7'
<7>kobject ptya8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya8'
<7>kobject ptya9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya9'
<7>kobject ptyaa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyaa'
<7>kobject ptyab: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyab'
<7>kobject ptyac: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyac'
<7>kobject ptyad: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyad'
<7>kobject ptyae: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyae'
<7>kobject ptyaf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyaf'
<7>kobject ptyb0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb0'
<7>kobject ptyb1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb1'
<7>kobject ptyb2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb2'
<7>kobject ptyb3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb3'
<7>kobject ptyb4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb4'
<7>kobject ptyb5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb5'
<7>kobject ptyb6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb6'
<7>kobject ptyb7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb7'
<7>kobject ptyb8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb8'
<7>kobject ptyb9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb9'
<7>kobject ptyba: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyba'
<7>kobject ptybb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybb'
<7>kobject ptybc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybc'
<7>kobject ptybd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybd'
<7>kobject ptybe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybe'
<7>kobject ptybf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybf'
<7>kobject ptyc0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc0'
<7>kobject ptyc1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc1'
<7>kobject ptyc2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc2'
<7>kobject ptyc3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc3'
<7>kobject ptyc4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc4'
<7>kobject ptyc5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc5'
<7>kobject ptyc6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc6'
<7>kobject ptyc7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc7'
<7>kobject ptyc8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc8'
<7>kobject ptyc9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc9'
<7>kobject ptyca: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyca'
<7>kobject ptycb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycb'
<7>kobject ptycc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycc'
<7>kobject ptycd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycd'
<7>kobject ptyce: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyce'
<7>kobject ptycf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycf'
<7>kobject ptyd0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd0'
<7>kobject ptyd1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd1'
<7>kobject ptyd2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd2'
<7>kobject ptyd3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd3'
<7>kobject ptyd4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd4'
<7>kobject ptyd5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd5'
<7>kobject ptyd6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd6'
<7>kobject ptyd7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd7'
<7>kobject ptyd8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd8'
<7>kobject ptyd9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd9'
<7>kobject ptyda: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyda'
<7>kobject ptydb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydb'
<7>kobject ptydc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydc'
<7>kobject ptydd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydd'
<7>kobject ptyde: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyde'
<7>kobject ptydf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydf'
<7>kobject ptye0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye0'
<7>kobject ptye1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye1'
<7>kobject ptye2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye2'
<7>kobject ptye3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye3'
<7>kobject ptye4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye4'
<7>kobject ptye5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye5'
<7>kobject ptye6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye6'
<7>kobject ptye7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye7'
<7>kobject ptye8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye8'
<7>kobject ptye9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye9'
<7>kobject ptyea: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyea'
<7>kobject ptyeb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyeb'
<7>kobject ptyec: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyec'
<7>kobject ptyed: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyed'
<7>kobject ptyee: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyee'
<7>kobject ptyef: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyef'
<7>kobject ttyp0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp0'
<7>kobject ttyp1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp1'
<7>kobject ttyp2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp2'
<7>kobject ttyp3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp3'
<7>kobject ttyp4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp4'
<7>kobject ttyp5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp5'
<7>kobject ttyp6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp6'
<7>kobject ttyp7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp7'
<7>kobject ttyp8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp8'
<7>kobject ttyp9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp9'
<7>kobject ttypa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypa'
<7>kobject ttypb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypb'
<7>kobject ttypc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypc'
<7>kobject ttypd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypd'
<7>kobject ttype: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttype'
<7>kobject ttypf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypf'
<7>kobject ttyq0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq0'
<7>kobject ttyq1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq1'
<7>kobject ttyq2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq2'
<7>kobject ttyq3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq3'
<7>kobject ttyq4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq4'
<7>kobject ttyq5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq5'
<7>kobject ttyq6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq6'
<7>kobject ttyq7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq7'
<7>kobject ttyq8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq8'
<7>kobject ttyq9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq9'
<7>kobject ttyqa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqa'
<7>kobject ttyqb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqb'
<7>kobject ttyqc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqc'
<7>kobject ttyqd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqd'
<7>kobject ttyqe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqe'
<7>kobject ttyqf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqf'
<7>kobject ttyr0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr0'
<7>kobject ttyr1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr1'
<7>kobject ttyr2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr2'
<7>kobject ttyr3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr3'
<7>kobject ttyr4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr4'
<7>kobject ttyr5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr5'
<7>kobject ttyr6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr6'
<7>kobject ttyr7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr7'
<7>kobject ttyr8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr8'
<7>kobject ttyr9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr9'
<7>kobject ttyra: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyra'
<7>kobject ttyrb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrb'
<7>kobject ttyrc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrc'
<7>kobject ttyrd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrd'
<7>kobject ttyre: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyre'
<7>kobject ttyrf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrf'
<7>kobject ttys0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys0'
<7>kobject ttys1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys1'
<7>kobject ttys2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys2'
<7>kobject ttys3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys3'
<7>kobject ttys4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys4'
<7>kobject ttys5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys5'
<7>kobject ttys6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys6'
<7>kobject ttys7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys7'
<7>kobject ttys8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys8'
<7>kobject ttys9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys9'
<7>kobject ttysa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysa'
<7>kobject ttysb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysb'
<7>kobject ttysc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysc'
<7>kobject ttysd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysd'
<7>kobject ttyse: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyse'
<7>kobject ttysf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysf'
<7>kobject ttyt0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt0'
<7>kobject ttyt1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt1'
<7>kobject ttyt2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt2'
<7>kobject ttyt3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt3'
<7>kobject ttyt4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt4'
<7>kobject ttyt5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt5'
<7>kobject ttyt6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt6'
<7>kobject ttyt7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt7'
<7>kobject ttyt8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt8'
<7>kobject ttyt9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt9'
<7>kobject ttyta: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyta'
<7>kobject ttytb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytb'
<7>kobject ttytc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytc'
<7>kobject ttytd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytd'
<7>kobject ttyte: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyte'
<7>kobject ttytf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytf'
<7>kobject ttyu0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu0'
<7>kobject ttyu1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu1'
<7>kobject ttyu2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu2'
<7>kobject ttyu3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu3'
<7>kobject ttyu4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu4'
<7>kobject ttyu5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu5'
<7>kobject ttyu6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu6'
<7>kobject ttyu7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu7'
<7>kobject ttyu8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu8'
<7>kobject ttyu9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu9'
<7>kobject ttyua: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyua'
<7>kobject ttyub: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyub'
<7>kobject ttyuc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyuc'
<7>kobject ttyud: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyud'
<7>kobject ttyue: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyue'
<7>kobject ttyuf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyuf'
<7>kobject ttyv0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv0'
<7>kobject ttyv1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv1'
<7>kobject ttyv2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv2'
<7>kobject ttyv3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv3'
<7>kobject ttyv4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv4'
<7>kobject ttyv5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv5'
<7>kobject ttyv6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv6'
<7>kobject ttyv7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv7'
<7>kobject ttyv8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv8'
<7>kobject ttyv9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv9'
<7>kobject ttyva: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyva'
<7>kobject ttyvb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvb'
<7>kobject ttyvc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvc'
<7>kobject ttyvd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvd'
<7>kobject ttyve: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyve'
<7>kobject ttyvf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvf'
<7>kobject ttyw0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw0'
<7>kobject ttyw1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw1'
<7>kobject ttyw2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw2'
<7>kobject ttyw3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw3'
<7>kobject ttyw4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw4'
<7>kobject ttyw5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw5'
<7>kobject ttyw6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw6'
<7>kobject ttyw7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw7'
<7>kobject ttyw8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw8'
<7>kobject ttyw9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw9'
<7>kobject ttywa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywa'
<7>kobject ttywb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywb'
<7>kobject ttywc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywc'
<7>kobject ttywd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywd'
<7>kobject ttywe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywe'
<7>kobject ttywf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywf'
<7>kobject ttyx0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx0'
<7>kobject ttyx1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx1'
<7>kobject ttyx2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx2'
<7>kobject ttyx3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx3'
<7>kobject ttyx4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx4'
<7>kobject ttyx5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx5'
<7>kobject ttyx6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx6'
<7>kobject ttyx7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx7'
<7>kobject ttyx8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx8'
<7>kobject ttyx9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx9'
<7>kobject ttyxa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxa'
<7>kobject ttyxb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxb'
<7>kobject ttyxc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxc'
<7>kobject ttyxd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxd'
<7>kobject ttyxe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxe'
<7>kobject ttyxf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxf'
<7>kobject ttyy0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy0'
<7>kobject ttyy1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy1'
<7>kobject ttyy2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy2'
<7>kobject ttyy3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy3'
<7>kobject ttyy4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy4'
<7>kobject ttyy5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy5'
<7>kobject ttyy6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy6'
<7>kobject ttyy7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy7'
<7>kobject ttyy8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy8'
<7>kobject ttyy9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy9'
<7>kobject ttyya: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyya'
<7>kobject ttyyb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyb'
<7>kobject ttyyc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyc'
<7>kobject ttyyd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyd'
<7>kobject ttyye: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyye'
<7>kobject ttyyf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyf'
<7>kobject ttyz0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz0'
<7>kobject ttyz1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz1'
<7>kobject ttyz2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz2'
<7>kobject ttyz3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz3'
<7>kobject ttyz4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz4'
<7>kobject ttyz5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz5'
<7>kobject ttyz6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz6'
<7>kobject ttyz7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz7'
<7>kobject ttyz8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz8'
<7>kobject ttyz9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz9'
<7>kobject ttyza: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyza'
<7>kobject ttyzb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzb'
<7>kobject ttyzc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzc'
<7>kobject ttyzd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzd'
<7>kobject ttyze: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyze'
<7>kobject ttyzf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzf'
<7>kobject ttya0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya0'
<7>kobject ttya1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya1'
<7>kobject ttya2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya2'
<7>kobject ttya3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya3'
<7>kobject ttya4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya4'
<7>kobject ttya5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya5'
<7>kobject ttya6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya6'
<7>kobject ttya7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya7'
<7>kobject ttya8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya8'
<7>kobject ttya9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya9'
<7>kobject ttyaa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyaa'
<7>kobject ttyab: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyab'
<7>kobject ttyac: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyac'
<7>kobject ttyad: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyad'
<7>kobject ttyae: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyae'
<7>kobject ttyaf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyaf'
<7>kobject ttyb0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb0'
<7>kobject ttyb1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb1'
<7>kobject ttyb2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb2'
<7>kobject ttyb3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb3'
<7>kobject ttyb4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb4'
<7>kobject ttyb5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb5'
<7>kobject ttyb6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb6'
<7>kobject ttyb7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb7'
<7>kobject ttyb8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb8'
<7>kobject ttyb9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb9'
<7>kobject ttyba: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyba'
<7>kobject ttybb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybb'
<7>kobject ttybc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybc'
<7>kobject ttybd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybd'
<7>kobject ttybe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybe'
<7>kobject ttybf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybf'
<7>kobject ttyc0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc0'
<7>kobject ttyc1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc1'
<7>kobject ttyc2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc2'
<7>kobject ttyc3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc3'
<7>kobject ttyc4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc4'
<7>kobject ttyc5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc5'
<7>kobject ttyc6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc6'
<7>kobject ttyc7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc7'
<7>kobject ttyc8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc8'
<7>kobject ttyc9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc9'
<7>kobject ttyca: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyca'
<7>kobject ttycb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycb'
<7>kobject ttycc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycc'
<7>kobject ttycd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycd'
<7>kobject ttyce: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyce'
<7>kobject ttycf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycf'
<7>kobject ttyd0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd0'
<7>kobject ttyd1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd1'
<7>kobject ttyd2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd2'
<7>kobject ttyd3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd3'
<7>kobject ttyd4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd4'
<7>kobject ttyd5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd5'
<7>kobject ttyd6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd6'
<7>kobject ttyd7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd7'
<7>kobject ttyd8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd8'
<7>kobject ttyd9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd9'
<7>kobject ttyda: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyda'
<7>kobject ttydb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydb'
<7>kobject ttydc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydc'
<7>kobject ttydd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydd'
<7>kobject ttyde: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyde'
<7>kobject ttydf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydf'
<7>kobject ttye0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye0'
<7>kobject ttye1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye1'
<7>kobject ttye2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye2'
<7>kobject ttye3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye3'
<7>kobject ttye4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye4'
<7>kobject ttye5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye5'
<7>kobject ttye6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye6'
<7>kobject ttye7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye7'
<7>kobject ttye8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye8'
<7>kobject ttye9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye9'
<7>kobject ttyea: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyea'
<7>kobject ttyeb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyeb'
<7>kobject ttyec: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyec'
<7>kobject ttyed: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyed'
<7>kobject ttyee: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyee'
<7>kobject ttyef: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyef'
<7>kobject printer: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/printer'
<6>lp: driver loaded but no devices found
<7>kobject hpet: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/hpet'
<7>kobject hpet: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/acpi/drivers/hpet'
<6>Generic RTC Driver v1.07
<7>kobject rtc: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/rtc'
<6>Linux agpgart interface v0.102
<7>kobject agpgart-intel: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/agpgart-intel'
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
<7>kobject serial8250: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<7>kobject ttyS0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<7>kobject ttyS1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS2'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS3'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject serial8250: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/serial8250'
<7>kobject serial: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/serial'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS0: cleaning up
<6>00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<7>kobject ttyS0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/pnp0/00:07'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS1: cleaning up
<6>00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<7>kobject ttyS1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/pnp0/00:08'
<7>kobject serial: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/serial'
<7>kobject parport_pc: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/parport_pc'
<7>parport_pc: VIA 686A/8231 detected
<7>parport_pc: probing current configuration
<7>parport_pc: Current parallel port base: 0x378
<6>parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
<7>kobject lp0: registering. parent: printer, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/printer/lp0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
<6>lp0: using parport0 (interrupt-driven).
<6>parport_pc: VIA parallel port: io=0x378, irq=7
<7>kobject parport_pc.956: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.956: cleaning up
<7>kobject parport_pc.888: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.888: cleaning up
<7>kobject parport_pc.632: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.632: cleaning up
<7>kobject parport_pc: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/parport_pc'
<7>kobject isa: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/isa'
<7>kobject devices: registering. parent: isa, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: isa, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject isa: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject ram0: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram0'
<7>kobject ram1: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram1'
<7>kobject ram2: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram2'
<7>kobject ram3: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram3'
<7>kobject ram4: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram4'
<7>kobject ram5: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram5'
<7>kobject ram6: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram6'
<7>kobject ram7: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram7'
<7>kobject ram8: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram8, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram8, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram8'
<7>kobject ram9: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram9, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram9, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram9'
<7>kobject ram10: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram10, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram10, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram10'
<7>kobject ram11: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram11, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram11, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram11'
<7>kobject ram12: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram12, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram12, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram12'
<7>kobject ram13: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram13, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram13, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram13'
<7>kobject ram14: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram14, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram14, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram14'
<7>kobject ram15: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram15, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram15, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram15'
<4>RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
<7>kobject loop0: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop0'
<7>kobject loop1: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop1'
<7>kobject loop2: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop2'
<7>kobject loop3: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop3'
<7>kobject loop4: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop4'
<7>kobject loop5: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop5'
<7>kobject loop6: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop6'
<7>kobject loop7: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop7'
<6>loop: module loaded
<7>kobject plip0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/plip0'
<6>NET3 PLIP version 2.4-parport gniibe@mri.co.jp
<6>plip0: Parallel port at 0x378, using IRQ 7.
<7>kobject lo: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/lo'
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<7>kobject ide: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/ide'
<7>kobject devices: registering. parent: ide, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: ide, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject PCI_IDE: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/PCI_IDE'
<7>Probing IDE interface ide0...
<7>Probing IDE interface ide1...
<4>hdc: TOSHIBA THNCF512MBA, ATA DISK drive
<7>kobject ide1: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>Probing IDE interface ide2...
<7>Probing IDE interface ide3...
<7>Probing IDE interface ide4...
<7>Probing IDE interface ide5...
<4>ide1 at 0x170-0x177,0x376 on irq 15
<7>kobject 1.0: registering. parent: ide1, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject ide-disk: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/ide/drivers/ide-disk'
<6>hdc: max request size: 128KiB
<6>hdc: 1000944 sectors (512 MB) w/2KiB Cache, CHS=993/16/63
<7>kobject hdc: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6> hdc: hdc1 hdc2
<7>kobject hdc1: registering. parent: hdc, set: <NULL>
<7>kobject holders: registering. parent: hdc1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject hdc2: registering. parent: hdc, set: <NULL>
<7>kobject holders: registering. parent: hdc2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc/hdc1'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc/hdc2'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject queue: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject iosched: registering. parent: queue, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject scsi_disk: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_disk'
<7>kobject sd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/scsi/drivers/sd'
<7>kobject scsi_generic: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_generic'
<7>kobject ahci: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/ahci'
<7>kobject sata_via: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/sata_via'
<7>kobject pata_mpiix: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_mpiix'
<7>kobject pata_oldpiix: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_oldpiix'
<7>kobject pata_via: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_via'
<7>pata_via 0000:00:07.1: version 0.3.2
<4>PCI: Unable to reserve I/O region #3:8@170 for device 0000:00:07.1
<4>pata_via 0000:00:07.1: failed to request/iomap BARs for port 1 (errno=-16)
<6>scsi0 : pata_via
<7>kobject host0: registering. parent: 0000:00:07.1, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject host0: registering. parent: scsi_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host/host0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1/host0'
<6>scsi1 : pata_via
<7>kobject host1: registering. parent: 0000:00:07.1, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject host1: registering. parent: scsi_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host/host1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1/host1'
<6>ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001c000 irq 14
<6>ata2: DUMMY
<7>kobject ehci_hcd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/ehci_hcd'
<7>kobject drivers: registering. parent: ehci_hcd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>USB Universal Host Controller Interface driver v3.0
<7>kobject uhci_hcd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/uhci_hcd'
<7>PCI: setting IRQ 12 as level-triggered
<6>PCI: Found IRQ 12 for device 0000:00:07.2
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<6>PCI: Sharing IRQ 12 with 0000:00:08.0
<6>uhci_hcd 0000:00:07.2: UHCI Host Controller
<7>kobject usb_host1: registering. parent: usb_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host/usb_host1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2'
<6>uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
<6>uhci_hcd 0000:00:07.2: irq 11, io base 0x0000c400
<7>kobject usb1: registering. parent: 0000:00:07.2, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1'
<7>kobject usb_endpoint: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint'
<7>kobject usbdev1.1_ep00: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev1.1_ep00'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1'
<6>usb usb1: configuration #1 chosen from 1 choice
<7>kobject 1-0:1.0: registering. parent: usb1, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1/1-0:1.0'
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<7>kobject usbdev1.1_ep81: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev1.1_ep81'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1/1-0:1.0'
<6>PCI: Found IRQ 12 for device 0000:00:07.3
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<6>PCI: Sharing IRQ 12 with 0000:00:08.0
<6>uhci_hcd 0000:00:07.3: UHCI Host Controller
<7>kobject usb_host2: registering. parent: usb_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host/usb_host2'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3'
<6>uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
<6>uhci_hcd 0000:00:07.3: irq 11, io base 0x0000c800
<7>kobject usb2: registering. parent: 0000:00:07.3, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2'
<7>kobject usbdev2.1_ep00: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev2.1_ep00'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2'
<6>usb usb2: configuration #1 chosen from 1 choice
<7>kobject 2-0:1.0: registering. parent: usb2, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2/2-0:1.0'
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<7>kobject usbdev2.1_ep81: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev2.1_ep81'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2/2-0:1.0'
<7>kobject drivers: registering. parent: uhci_hcd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usblp: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usblp'
<7>kobject drivers: registering. parent: usblp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usblp
<6>Initializing USB Mass Storage driver...
<7>kobject usb-storage: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usb-storage'
<7>kobject drivers: registering. parent: usb_storage, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usb-storage
<6>USB Mass Storage support registered.
<7>kobject i8042 kbd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/i8042 kbd'
<7>kobject i8042 aux: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/i8042 aux'
<6>PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
<7>kobject i8042: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/i8042'
<7>kobject i8042: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<7>kobject mice: registering. parent: input, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input/mice'
<7>kobject serio0: registering. parent: i8042, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>kobject psaux: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/psaux'
<6>mice: PS/2 mouse device common for all mice
<7>kobject atkbd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio/drivers/atkbd'
<7>kobject drivers: registering. parent: atkbd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject psmouse: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio/drivers/psmouse'
<7>kobject input0: registering. parent: input, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input/input0'
<7>fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>fill_kobj_path: path = '/class/input/input0'
<6>input: AT Translated Set 2 keyboard as /class/input/input0
<7>kobject drivers: registering. parent: psmouse, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usbhid: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usbhid'
<7>kobject drivers: registering. parent: usbhid, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usbhid
<6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<6>oprofile: using timer interrupt.
<4>Netfilter messages via NETLINK v0.30.
<4>nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
<7>kobject :0000216: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000216'
<7>kobject :0000136: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000136'
<6>IPv4 over IPv4 tunneling driver
<7>kobject tunl0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/tunl0'
<6>GRE over IPv4 tunneling driver
<7>kobject gre0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/gre0'
<6>ip_tables: (C) 2000-2006 Netfilter Core Team
<6>arp_tables: (C) 2002 David S. Miller
<6>TCP cubic registered
<6>Initializing XFRM netlink socket
<6>NET: Registered protocol family 1
<6>NET: Registered protocol family 17
<7>kobject rpc_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/rpc_inode_cache'
<4>Using IPI Shortcut mode
<5>RAMDISK: Compressed image found at block 0
<4>VFS: Mounted root (minix filesystem) readonly.
<6>Freeing unused kernel memory: 176k freed
<4>Warning: unable to open an initial console.
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject cramfs: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cramfs, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cramfs'
<7>kobject 8139too: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: 8139too, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/8139too'
<6>8139too Fast Ethernet driver 0.9.28
<7>kobject 8139too: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/8139too'
<6>PCI: Found IRQ 12 for device 0000:00:08.0
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<7>kobject eth0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
<6>eth0: RealTek RTL8139 at 0xc8016000, 00:30:18:49:b2:31, IRQ 12
<7>eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>PCI: setting IRQ 10 as level-triggered
<6>PCI: Found IRQ 10 for device 0000:00:09.0
<7>kobject eth1: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
<6>eth1: RealTek RTL8139 at 0xc8032000, 00:30:18:49:b2:30, IRQ 10
<7>eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>PCI: setting IRQ 11 as level-triggered
<6>PCI: Found IRQ 11 for device 0000:00:0b.0
<6>IRQ routing conflict for 0000:00:07.5, have irq 5, want irq 11
<7>kobject eth2: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0'
<6>eth2: RealTek RTL8139 at 0xc8034000, 00:30:18:49:b2:2f, IRQ 11
<7>eth2:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>kobject drivers: registering. parent: 8139too, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject 8021q: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: 8021q, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/8021q'
<6>802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
<6>All bugs added by David S. Miller <davem@redhat.com>
<7>kobject tun: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: tun, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/tun'
<6>tun: Universal TUN/TAP device driver, 1.6
<6>tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<7>kobject tun: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/tun'
<6>eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
<6>eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
<6>eth2: link up, 100Mbps, full-duplex, lpa 0x45E1
<7>kobject eth2.2: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.2'
<7>kobject eth2.3: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.3'
<7>kobject eth2.4: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.4'
<7>kobject eth2.5: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.5'
<7>kobject eth2.6: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.6'
<7>kobject eth2.7: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.7'
<7>kobject eth2.8: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.8'
<7>kobject eth2.9: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.9'
<7>kobject eth2.10: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.10'
<7>kobject eth2.11: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.11'
<4>process `named' is using obsolete setsockopt SO_BSDCOMPAT
<7>kobject sch_htb: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: sch_htb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/sch_htb'
<7>kobject cls_u32: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cls_u32, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cls_u32'
<4>u32 classifier
<4>    Performance counters on
<4>    Actions configured 
<7>kobject cls_fw: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cls_fw, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cls_fw'
<7>kobject sch_sfq: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: sch_sfq, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/sch_sfq'
<7>kobject ebtables: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebtables, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebtables'
<6>Ebtables v2.0 registered
<7>kobject ebtable_nat: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebtable_nat, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebtable_nat'
<7>kobject ebt_ip: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebt_ip, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebt_ip'
<6>device eth2 entered promiscuous mode
<5>audit(1216114671.758:2): dev=eth2 prom=256 old_prom=0 auid=4294967295
<6>device eth2.2 entered promiscuous mode
<5>audit(1216114671.774:3): dev=eth2.2 prom=256 old_prom=0 auid=4294967295
<6>device eth2.3 entered promiscuous mode
<5>audit(1216114671.790:4): dev=eth2.3 prom=256 old_prom=0 auid=4294967295
<6>device eth2.4 entered promiscuous mode
<5>audit(1216114671.806:5): dev=eth2.4 prom=256 old_prom=0 auid=4294967295
<6>device eth2.5 entered promiscuous mode
<5>audit(1216114671.822:6): dev=eth2.5 prom=256 old_prom=0 auid=4294967295
<6>device eth2.6 entered promiscuous mode
<5>audit(1216114671.838:7): dev=eth2.6 prom=256 old_prom=0 auid=4294967295
<6>device eth2.7 entered promiscuous mode
<5>audit(1216114671.854:8): dev=eth2.7 prom=256 old_prom=0 auid=4294967295
<6>device eth2.8 entered promiscuous mode
<5>audit(1216114671.870:9): dev=eth2.8 prom=256 old_prom=0 auid=4294967295
<6>device eth2.9 entered promiscuous mode
<5>audit(1216114671.882:10): dev=eth2.9 prom=256 old_prom=0 auid=4294967295
<6>device eth2.10 entered promiscuous mode
<5>audit(1216114671.894:11): dev=eth2.10 prom=256 old_prom=0 auid=4294967295
<6>device eth2.11 entered promiscuous mode
<5>audit(1216114671.914:12): dev=eth2.11 prom=256 old_prom=0 auid=4294967295
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcsa2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcs2: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject vcsa2: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcsa2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject compat_xtables: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: compat_xtables, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/compat_xtables'
<7>kobject xt_RAWNAT: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: xt_RAWNAT, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/xt_RAWNAT'
<7>kobject iptable_rawpost: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: iptable_rawpost, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/iptable_rawpost'
<3>compat_xtables: compat layer limits reached (xtnu_skb_make_writable) - dropping packets
<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000001
<1> printing eip:
<4>c0150f45
<1>*pde = 00000000
<0>Oops: 0000 [#1]
<0>PREEMPT 
<4>Modules linked in: iptable_rawpost xt_RAWNAT compat_xtables ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c0150f45>]    Not tainted VLI
<0>EFLAGS: 00010002   (2.6.23.9-default #30)
<0>EIP is at kmem_cache_alloc+0x4e/0x92
<0>eax: 00000000   ebx: 00000001   ecx: c0483b18   edx: c108c560
<0>esi: 00000296   edi: 00000001   ebp: 000000d0   esp: c4615eb4
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process userstatus (pid: 5867, ti=c4614000 task=c1260a80 task.ti=c4614000)
<0>Stack: bffffff4 c12a7340 c0483b18 00000000 c045aa5c c4ce7e00 c4ce7e00 c017c3a5 
<0>       00000000 059ca067 00000007 00000000 059ca067 00000007 bfffff23 00000010 
<0>       00000000 00000007 c133f160 00000000 bfffff23 c0145bfa c1260a80 00000020 
<0>Call Trace:
<0> [<c017c3a5>] load_elf_binary+0x68/0xb89
<0> [<c0145bfa>] get_user_pages+0x1f7/0x244
<0> [<c01ea803>] copy_from_user+0x31/0x52
<0> [<c01590fa>] search_binary_handler+0xe3/0x259
<0> [<c017c33d>] load_elf_binary+0x0/0xb89
<0> [<c015938c>] do_execve+0x11c/0x171
<0> [<c0102c69>] sys_execve+0x2d/0x7c
<0> [<c0103e62>] syscall_call+0x7/0xb
<0> =======================
<0>Code: 00 85 d2 74 07 8b 7a 0c 85 ff 75 19 89 54 24 04 83 c9 ff 89 ea 8b 44 24 08 89 1c 24 e8 8b fe ff ff 89 c3 eb 0c 0f b7 42 0a 89 fb <8b> 04 87 89 42 0c 56 9d c1 ed 0f 85 db 0f 95 c0 21 c5 83 e5 01 
<0>EIP: [<c0150f45>] kmem_cache_alloc+0x4e/0x92 SS:ESP 0068:c4615eb4
<1>BUG: unable to handle kernel paging request at virtual address 00010101
<1> printing eip:
<4>c015595b
<1>*pde = 00000000
<0>Oops: 0000 [#2]
<0>PREEMPT 
<4>Modules linked in: iptable_rawpost xt_RAWNAT compat_xtables ebt_ip ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too cramfs
<0>CPU:    0
<0>EIP:    0060:[<c015595b>]    Tainted: G      D VLI
<0>EFLAGS: 00010246   (2.6.23.9-default #30)
<0>EIP is at fget_light+0x3f/0x9a
<0>eax: 00000000   ebx: c462bcc0   ecx: bf8fb9d0   edx: 00010101
<0>esi: 00000002   edi: c460dfa8   ebp: c460c000   esp: c460df8c
<0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
<0>Process arping (pid: 5713, ti=c460c000 task=c45fcfc0 task.ti=c460c000)
<0>Stack: 00000002 fffffff7 bf8fb9d0 c0154d74 c5f90a80 c45fcfc0 b7ecfb90 00000000 
<0>       00000002 0000001e c0103e62 00000002 bf8fb9d0 0000001e 0000001e bf8fb9d0 
<0>       bf8fb878 00000004 0000007b 0000007b 00000000 00000004 b7e713a8 00000073 
<0>Call Trace:

--------------060008070208040206090803
Content-Type: text/plain;
 name="kernel_log3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel_log3"

klogd 1.4.1, log source = /proc/kmsg started.
Cannot find map file.
No module symbols loaded - kernel modules not enabled.

Cannot build symbol table - disabling symbol lookups
registering. parent: pnp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: pnp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>pnp: PnP ACPI init
<7>kobject pnp0: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>ACPI: bus type pnp registered
<7>kobject 00:00: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:00'
<7>kobject 00:01: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:01'
<7>kobject 00:02: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:02'
<7>kobject 00:03: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:03'
<7>kobject 00:04: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:04'
<7>kobject 00:05: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:05'
<7>kobject 00:06: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:06'
<7>kobject 00:07: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:07'
<7>kobject 00:08: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:08'
<7>kobject 00:09: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:09'
<7>kobject 00:0a: registering. parent: pnp0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pnp0/00:0a'
<6>pnp: PnP ACPI: found 11 devices
<6>ACPI: ACPI bus type pnp unregistered
<7>kobject misc: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc'
<7>kobject scsi_host: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host'
<7>kobject scsi: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/scsi'
<7>kobject devices: registering. parent: scsi, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: scsi, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject scsi_device: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_device'
<5>SCSI subsystem initialized
<7>libata version 2.21 loaded.
<7>kobject usb: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb'
<7>kobject devices: registering. parent: usb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: usb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usb_host: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host'
<7>kobject usbfs: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usbfs'
<7>kobject drivers: registering. parent: usbcore, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usbfs
<7>kobject hub: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/hub'
<6>usbcore: registered new interface driver hub
<7>kobject usb: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usb'
<6>usbcore: registered new device driver usb
<7>kobject serio: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio'
<7>kobject devices: registering. parent: serio, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: serio, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject input: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input'
<7>kobject i2c: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/i2c'
<7>kobject devices: registering. parent: i2c, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: i2c, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject i2c-adapter: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/i2c-adapter'
<4>PCI: Probing PCI hardware
<7>PCI: Probing PCI hardware (bus 00)
<7>kobject pci0000:00: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject 0000:00: registering. parent: pci_bus, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/pci_bus/0000:00'
<4>PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
<4>PCI quirk: region 5000-500f claimed by vt82c686 SMB
<7>kobject 0000:01: registering. parent: pci_bus, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/pci_bus/0000:01'
<7>kobject 0000:00:00.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:00.0'
<7>kobject 0000:00:01.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0'
<7>kobject 0000:00:07.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
<7>kobject 0000:00:07.1: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1'
<7>kobject 0000:00:07.2: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2'
<7>kobject 0000:00:07.3: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3'
<7>kobject 0000:00:07.4: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.4'
<7>kobject 0000:00:07.5: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.5'
<7>kobject 0000:00:08.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
<7>kobject 0000:00:09.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
<7>kobject 0000:00:0b.0: registering. parent: pci0000:00, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0'
<7>kobject 0000:01:00.0: registering. parent: 0000:00:01.0, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:00.0'
<6>PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
<7>kobject net: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net'
<6>Time: tsc clocksource has been installed.
<7>kobject system: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/system'
<6>pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
<6>pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
<6>pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
<6>pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
<7>kobject mem: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem'
<7>kobject mem: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/mem'
<7>kobject kmem: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/kmem'
<7>kobject null: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/null'
<7>kobject port: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/port'
<7>kobject zero: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/zero'
<7>kobject full: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/full'
<7>kobject random: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/random'
<7>kobject urandom: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/urandom'
<7>kobject kmsg: registering. parent: mem, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/mem/kmsg'
<6>PCI: Bridge: 0000:00:01.0
<6>  IO window: disabled.
<6>  MEM window: e4000000-e6ffffff
<6>  PREFETCH window: 10000000-100fffff
<7>PCI: Setting latency timer of device 0000:00:01.0 to 64
<6>NET: Registered protocol family 2
<6>IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
<6>TCP established hash table entries: 4096 (order: 3, 32768 bytes)
<6>TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
<6>TCP: Hash tables configured (established 4096 bind 4096)
<6>TCP reno registered
<6>checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
<6>Freeing initrd memory: 1085k freed
<7>kobject i8259: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8259'
<7>kobject i82590: registering. parent: <NULL>, set: i8259
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8259/i82590'
<7>kobject i8237: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8237'
<7>kobject i82370: registering. parent: <NULL>, set: i8237
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/i8237/i82370'
<7>kobject pcspkr: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject timekeeping: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/timekeeping'
<7>kobject timekeeping0: registering. parent: <NULL>, set: timekeeping
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/timekeeping/timekeeping0'
<7>kobject clocksource: registering. parent: system, set: system
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/clocksource'
<7>kobject clocksource0: registering. parent: <NULL>, set: clocksource
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/system/clocksource/clocksource0'
<6>audit: initializing netlink socket (disabled)
<5>audit(1216115874.808:1): initialized
<3>audit: cannot initialize inotify handle
<7>kobject slab: registering. parent: <NULL>, set: <NULL>
<7>kobject_uevent_env
<7>kobject attempted to send uevent without kset!
<7>kobject shmem_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/shmem_inode_cache'
<7>kobject :0000288: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000288'
<7>kobject :0000448: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000448'
<7>kobject :0000480: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000480'
<7>kobject :0001056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001056'
<7>kobject :0000104: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000104'
<7>kobject :0000912: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000912'
<7>kobject :0000184: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000184'
<7>kobject :0003072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0003072'
<7>kobject :0001536: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001536'
<7>kobject :0000768: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000768'
<7>kobject sock_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/sock_inode_cache'
<7>kobject :0000352: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000352'
<7>kobject file_lock_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/file_lock_cache'
<7>kobject :0000048: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000048'
<7>kobject :0000024: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000024'
<7>kobject proc_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/proc_inode_cache'
<7>kobject :0000144: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000144'
<7>kobject radix_tree_node: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/radix_tree_node'
<7>kobject bdev_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/bdev_cache'
<7>kobject :0000056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000056'
<7>kobject inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/inode_cache'
<7>kobject :a-0000128: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000128'
<7>kobject idr_layer_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/idr_layer_cache'
<7>kobject :a-0000056: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000056'
<7>kobject :0000416: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000416'
<7>kobject :0000088: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000088'
<7>kobject :0000384: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000384'
<7>kobject sighand_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/sighand_cache'
<7>kobject :0001344: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001344'
<7>kobject anon_vma: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/anon_vma'
<7>kobject :0000040: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000040'
<7>kobject :4194304: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:4194304'
<7>kobject :2097152: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:2097152'
<7>kobject :1048576: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:1048576'
<7>kobject :0524288: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0524288'
<7>kobject :0262144: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0262144'
<7>kobject :0131072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0131072'
<7>kobject :0065536: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0065536'
<7>kobject :0032768: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0032768'
<7>kobject :0016384: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0016384'
<7>kobject :0008192: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0008192'
<7>kobject :0004096: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0004096'
<7>kobject :0002048: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0002048'
<7>kobject :0001024: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0001024'
<7>kobject :0000512: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000512'
<7>kobject :0000256: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000256'
<7>kobject :0000128: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000128'
<7>kobject :0000064: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000064'
<7>kobject :0000032: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000032'
<7>kobject :0000016: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000016'
<7>kobject :0000008: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000008'
<7>kobject :0000192: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000192'
<7>kobject :0000096: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000096'
<7>kobject :0000160: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000160'
<7>kobject ext2_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/ext2_inode_cache'
<7>kobject minix_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/minix_inode_cache'
<7>kobject fat_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/fat_cache'
<7>kobject fat_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/fat_inode_cache'
<7>kobject isofs_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/isofs_inode_cache'
<7>kobject nfs_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/nfs_inode_cache'
<7>kobject :a-0000072: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:a-0000072'
<7>kobject mqueue_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/mqueue_inode_cache'
<6>io scheduler noop registered
<6>io scheduler deadline registered (default)
<6>PCI: VIA PCI bridge detected. Disabling DAC.
<7>Boot video device is 0000:01:00.0
<7>kobject pnp1: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>isapnp: Scanning for PnP cards...
<6>isapnp: No Plug & Play device found
<7>kobject tty: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty'
<7>kobject console: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/console'
<7>kobject ptmx: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptmx'
<7>kobject tty0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty0'
<7>kobject vc: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc'
<7>kobject vcs: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs'
<7>kobject vcsa: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa'
<7>kobject tty1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty1'
<7>kobject tty2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty2'
<7>kobject tty3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty3'
<7>kobject tty4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty4'
<7>kobject tty5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty5'
<7>kobject tty6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty6'
<7>kobject tty7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty7'
<7>kobject tty8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty8'
<7>kobject tty9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty9'
<7>kobject tty10: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty10'
<7>kobject tty11: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty11'
<7>kobject tty12: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty12'
<7>kobject tty13: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty13'
<7>kobject tty14: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty14'
<7>kobject tty15: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty15'
<7>kobject tty16: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty16'
<7>kobject tty17: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty17'
<7>kobject tty18: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty18'
<7>kobject tty19: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty19'
<7>kobject tty20: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty20'
<7>kobject tty21: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty21'
<7>kobject tty22: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty22'
<7>kobject tty23: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty23'
<7>kobject tty24: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty24'
<7>kobject tty25: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty25'
<7>kobject tty26: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty26'
<7>kobject tty27: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty27'
<7>kobject tty28: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty28'
<7>kobject tty29: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty29'
<7>kobject tty30: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty30'
<7>kobject tty31: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty31'
<7>kobject tty32: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty32'
<7>kobject tty33: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty33'
<7>kobject tty34: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty34'
<7>kobject tty35: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty35'
<7>kobject tty36: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty36'
<7>kobject tty37: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty37'
<7>kobject tty38: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty38'
<7>kobject tty39: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty39'
<7>kobject tty40: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty40'
<7>kobject tty41: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty41'
<7>kobject tty42: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty42'
<7>kobject tty43: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty43'
<7>kobject tty44: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty44'
<7>kobject tty45: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty45'
<7>kobject tty46: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty46'
<7>kobject tty47: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty47'
<7>kobject tty48: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty48'
<7>kobject tty49: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty49'
<7>kobject tty50: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty50'
<7>kobject tty51: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty51'
<7>kobject tty52: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty52'
<7>kobject tty53: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty53'
<7>kobject tty54: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty54'
<7>kobject tty55: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty55'
<7>kobject tty56: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty56'
<7>kobject tty57: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty57'
<7>kobject tty58: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty58'
<7>kobject tty59: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty59'
<7>kobject tty60: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty60'
<7>kobject tty61: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty61'
<7>kobject tty62: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty62'
<7>kobject tty63: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/tty63'
<7>kobject ptyp0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp0'
<7>kobject ptyp1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp1'
<7>kobject ptyp2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp2'
<7>kobject ptyp3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp3'
<7>kobject ptyp4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp4'
<7>kobject ptyp5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp5'
<7>kobject ptyp6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp6'
<7>kobject ptyp7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp7'
<7>kobject ptyp8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp8'
<7>kobject ptyp9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyp9'
<7>kobject ptypa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypa'
<7>kobject ptypb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypb'
<7>kobject ptypc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypc'
<7>kobject ptypd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypd'
<7>kobject ptype: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptype'
<7>kobject ptypf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptypf'
<7>kobject ptyq0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq0'
<7>kobject ptyq1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq1'
<7>kobject ptyq2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq2'
<7>kobject ptyq3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq3'
<7>kobject ptyq4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq4'
<7>kobject ptyq5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq5'
<7>kobject ptyq6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq6'
<7>kobject ptyq7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq7'
<7>kobject ptyq8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq8'
<7>kobject ptyq9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyq9'
<7>kobject ptyqa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqa'
<7>kobject ptyqb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqb'
<7>kobject ptyqc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqc'
<7>kobject ptyqd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqd'
<7>kobject ptyqe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqe'
<7>kobject ptyqf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyqf'
<7>kobject ptyr0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr0'
<7>kobject ptyr1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr1'
<7>kobject ptyr2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr2'
<7>kobject ptyr3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr3'
<7>kobject ptyr4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr4'
<7>kobject ptyr5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr5'
<7>kobject ptyr6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr6'
<7>kobject ptyr7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr7'
<7>kobject ptyr8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr8'
<7>kobject ptyr9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyr9'
<7>kobject ptyra: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyra'
<7>kobject ptyrb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrb'
<7>kobject ptyrc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrc'
<7>kobject ptyrd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrd'
<7>kobject ptyre: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyre'
<7>kobject ptyrf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyrf'
<7>kobject ptys0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys0'
<7>kobject ptys1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys1'
<7>kobject ptys2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys2'
<7>kobject ptys3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys3'
<7>kobject ptys4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys4'
<7>kobject ptys5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys5'
<7>kobject ptys6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys6'
<7>kobject ptys7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys7'
<7>kobject ptys8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys8'
<7>kobject ptys9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptys9'
<7>kobject ptysa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysa'
<7>kobject ptysb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysb'
<7>kobject ptysc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysc'
<7>kobject ptysd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysd'
<7>kobject ptyse: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyse'
<7>kobject ptysf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptysf'
<7>kobject ptyt0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt0'
<7>kobject ptyt1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt1'
<7>kobject ptyt2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt2'
<7>kobject ptyt3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt3'
<7>kobject ptyt4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt4'
<7>kobject ptyt5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt5'
<7>kobject ptyt6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt6'
<7>kobject ptyt7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt7'
<7>kobject ptyt8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt8'
<7>kobject ptyt9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyt9'
<7>kobject ptyta: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyta'
<7>kobject ptytb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytb'
<7>kobject ptytc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytc'
<7>kobject ptytd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytd'
<7>kobject ptyte: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyte'
<7>kobject ptytf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptytf'
<7>kobject ptyu0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu0'
<7>kobject ptyu1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu1'
<7>kobject ptyu2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu2'
<7>kobject ptyu3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu3'
<7>kobject ptyu4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu4'
<7>kobject ptyu5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu5'
<7>kobject ptyu6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu6'
<7>kobject ptyu7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu7'
<7>kobject ptyu8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu8'
<7>kobject ptyu9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyu9'
<7>kobject ptyua: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyua'
<7>kobject ptyub: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyub'
<7>kobject ptyuc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyuc'
<7>kobject ptyud: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyud'
<7>kobject ptyue: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyue'
<7>kobject ptyuf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyuf'
<7>kobject ptyv0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv0'
<7>kobject ptyv1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv1'
<7>kobject ptyv2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv2'
<7>kobject ptyv3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv3'
<7>kobject ptyv4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv4'
<7>kobject ptyv5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv5'
<7>kobject ptyv6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv6'
<7>kobject ptyv7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv7'
<7>kobject ptyv8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv8'
<7>kobject ptyv9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyv9'
<7>kobject ptyva: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyva'
<7>kobject ptyvb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvb'
<7>kobject ptyvc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvc'
<7>kobject ptyvd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvd'
<7>kobject ptyve: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyve'
<7>kobject ptyvf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyvf'
<7>kobject ptyw0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw0'
<7>kobject ptyw1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw1'
<7>kobject ptyw2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw2'
<7>kobject ptyw3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw3'
<7>kobject ptyw4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw4'
<7>kobject ptyw5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw5'
<7>kobject ptyw6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw6'
<7>kobject ptyw7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw7'
<7>kobject ptyw8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw8'
<7>kobject ptyw9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyw9'
<7>kobject ptywa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywa'
<7>kobject ptywb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywb'
<7>kobject ptywc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywc'
<7>kobject ptywd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywd'
<7>kobject ptywe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywe'
<7>kobject ptywf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptywf'
<7>kobject ptyx0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx0'
<7>kobject ptyx1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx1'
<7>kobject ptyx2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx2'
<7>kobject ptyx3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx3'
<7>kobject ptyx4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx4'
<7>kobject ptyx5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx5'
<7>kobject ptyx6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx6'
<7>kobject ptyx7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx7'
<7>kobject ptyx8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx8'
<7>kobject ptyx9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyx9'
<7>kobject ptyxa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxa'
<7>kobject ptyxb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxb'
<7>kobject ptyxc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxc'
<7>kobject ptyxd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxd'
<7>kobject ptyxe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxe'
<7>kobject ptyxf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyxf'
<7>kobject ptyy0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy0'
<7>kobject ptyy1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy1'
<7>kobject ptyy2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy2'
<7>kobject ptyy3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy3'
<7>kobject ptyy4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy4'
<7>kobject ptyy5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy5'
<7>kobject ptyy6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy6'
<7>kobject ptyy7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy7'
<7>kobject ptyy8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy8'
<7>kobject ptyy9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyy9'
<7>kobject ptyya: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyya'
<7>kobject ptyyb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyb'
<7>kobject ptyyc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyc'
<7>kobject ptyyd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyd'
<7>kobject ptyye: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyye'
<7>kobject ptyyf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyyf'
<7>kobject ptyz0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz0'
<7>kobject ptyz1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz1'
<7>kobject ptyz2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz2'
<7>kobject ptyz3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz3'
<7>kobject ptyz4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz4'
<7>kobject ptyz5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz5'
<7>kobject ptyz6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz6'
<7>kobject ptyz7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz7'
<7>kobject ptyz8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz8'
<7>kobject ptyz9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyz9'
<7>kobject ptyza: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyza'
<7>kobject ptyzb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzb'
<7>kobject ptyzc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzc'
<7>kobject ptyzd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzd'
<7>kobject ptyze: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyze'
<7>kobject ptyzf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyzf'
<7>kobject ptya0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya0'
<7>kobject ptya1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya1'
<7>kobject ptya2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya2'
<7>kobject ptya3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya3'
<7>kobject ptya4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya4'
<7>kobject ptya5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya5'
<7>kobject ptya6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya6'
<7>kobject ptya7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya7'
<7>kobject ptya8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya8'
<7>kobject ptya9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptya9'
<7>kobject ptyaa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyaa'
<7>kobject ptyab: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyab'
<7>kobject ptyac: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyac'
<7>kobject ptyad: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyad'
<7>kobject ptyae: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyae'
<7>kobject ptyaf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyaf'
<7>kobject ptyb0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb0'
<7>kobject ptyb1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb1'
<7>kobject ptyb2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb2'
<7>kobject ptyb3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb3'
<7>kobject ptyb4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb4'
<7>kobject ptyb5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb5'
<7>kobject ptyb6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb6'
<7>kobject ptyb7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb7'
<7>kobject ptyb8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb8'
<7>kobject ptyb9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyb9'
<7>kobject ptyba: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyba'
<7>kobject ptybb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybb'
<7>kobject ptybc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybc'
<7>kobject ptybd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybd'
<7>kobject ptybe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybe'
<7>kobject ptybf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptybf'
<7>kobject ptyc0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc0'
<7>kobject ptyc1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc1'
<7>kobject ptyc2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc2'
<7>kobject ptyc3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc3'
<7>kobject ptyc4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc4'
<7>kobject ptyc5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc5'
<7>kobject ptyc6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc6'
<7>kobject ptyc7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc7'
<7>kobject ptyc8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc8'
<7>kobject ptyc9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyc9'
<7>kobject ptyca: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyca'
<7>kobject ptycb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycb'
<7>kobject ptycc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycc'
<7>kobject ptycd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycd'
<7>kobject ptyce: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyce'
<7>kobject ptycf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptycf'
<7>kobject ptyd0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd0'
<7>kobject ptyd1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd1'
<7>kobject ptyd2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd2'
<7>kobject ptyd3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd3'
<7>kobject ptyd4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd4'
<7>kobject ptyd5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd5'
<7>kobject ptyd6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd6'
<7>kobject ptyd7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd7'
<7>kobject ptyd8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd8'
<7>kobject ptyd9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyd9'
<7>kobject ptyda: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyda'
<7>kobject ptydb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydb'
<7>kobject ptydc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydc'
<7>kobject ptydd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydd'
<7>kobject ptyde: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyde'
<7>kobject ptydf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptydf'
<7>kobject ptye0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye0'
<7>kobject ptye1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye1'
<7>kobject ptye2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye2'
<7>kobject ptye3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye3'
<7>kobject ptye4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye4'
<7>kobject ptye5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye5'
<7>kobject ptye6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye6'
<7>kobject ptye7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye7'
<7>kobject ptye8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye8'
<7>kobject ptye9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptye9'
<7>kobject ptyea: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyea'
<7>kobject ptyeb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyeb'
<7>kobject ptyec: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyec'
<7>kobject ptyed: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyed'
<7>kobject ptyee: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyee'
<7>kobject ptyef: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ptyef'
<7>kobject ttyp0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp0'
<7>kobject ttyp1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp1'
<7>kobject ttyp2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp2'
<7>kobject ttyp3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp3'
<7>kobject ttyp4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp4'
<7>kobject ttyp5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp5'
<7>kobject ttyp6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp6'
<7>kobject ttyp7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp7'
<7>kobject ttyp8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp8'
<7>kobject ttyp9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyp9'
<7>kobject ttypa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypa'
<7>kobject ttypb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypb'
<7>kobject ttypc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypc'
<7>kobject ttypd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypd'
<7>kobject ttype: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttype'
<7>kobject ttypf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttypf'
<7>kobject ttyq0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq0'
<7>kobject ttyq1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq1'
<7>kobject ttyq2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq2'
<7>kobject ttyq3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq3'
<7>kobject ttyq4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq4'
<7>kobject ttyq5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq5'
<7>kobject ttyq6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq6'
<7>kobject ttyq7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq7'
<7>kobject ttyq8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq8'
<7>kobject ttyq9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyq9'
<7>kobject ttyqa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqa'
<7>kobject ttyqb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqb'
<7>kobject ttyqc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqc'
<7>kobject ttyqd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqd'
<7>kobject ttyqe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqe'
<7>kobject ttyqf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyqf'
<7>kobject ttyr0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr0'
<7>kobject ttyr1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr1'
<7>kobject ttyr2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr2'
<7>kobject ttyr3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr3'
<7>kobject ttyr4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr4'
<7>kobject ttyr5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr5'
<7>kobject ttyr6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr6'
<7>kobject ttyr7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr7'
<7>kobject ttyr8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr8'
<7>kobject ttyr9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyr9'
<7>kobject ttyra: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyra'
<7>kobject ttyrb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrb'
<7>kobject ttyrc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrc'
<7>kobject ttyrd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrd'
<7>kobject ttyre: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyre'
<7>kobject ttyrf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyrf'
<7>kobject ttys0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys0'
<7>kobject ttys1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys1'
<7>kobject ttys2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys2'
<7>kobject ttys3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys3'
<7>kobject ttys4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys4'
<7>kobject ttys5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys5'
<7>kobject ttys6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys6'
<7>kobject ttys7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys7'
<7>kobject ttys8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys8'
<7>kobject ttys9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttys9'
<7>kobject ttysa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysa'
<7>kobject ttysb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysb'
<7>kobject ttysc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysc'
<7>kobject ttysd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysd'
<7>kobject ttyse: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyse'
<7>kobject ttysf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttysf'
<7>kobject ttyt0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt0'
<7>kobject ttyt1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt1'
<7>kobject ttyt2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt2'
<7>kobject ttyt3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt3'
<7>kobject ttyt4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt4'
<7>kobject ttyt5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt5'
<7>kobject ttyt6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt6'
<7>kobject ttyt7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt7'
<7>kobject ttyt8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt8'
<7>kobject ttyt9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyt9'
<7>kobject ttyta: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyta'
<7>kobject ttytb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytb'
<7>kobject ttytc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytc'
<7>kobject ttytd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytd'
<7>kobject ttyte: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyte'
<7>kobject ttytf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttytf'
<7>kobject ttyu0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu0'
<7>kobject ttyu1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu1'
<7>kobject ttyu2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu2'
<7>kobject ttyu3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu3'
<7>kobject ttyu4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu4'
<7>kobject ttyu5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu5'
<7>kobject ttyu6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu6'
<7>kobject ttyu7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu7'
<7>kobject ttyu8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu8'
<7>kobject ttyu9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyu9'
<7>kobject ttyua: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyua'
<7>kobject ttyub: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyub'
<7>kobject ttyuc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyuc'
<7>kobject ttyud: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyud'
<7>kobject ttyue: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyue'
<7>kobject ttyuf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyuf'
<7>kobject ttyv0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv0'
<7>kobject ttyv1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv1'
<7>kobject ttyv2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv2'
<7>kobject ttyv3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv3'
<7>kobject ttyv4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv4'
<7>kobject ttyv5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv5'
<7>kobject ttyv6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv6'
<7>kobject ttyv7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv7'
<7>kobject ttyv8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv8'
<7>kobject ttyv9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyv9'
<7>kobject ttyva: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyva'
<7>kobject ttyvb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvb'
<7>kobject ttyvc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvc'
<7>kobject ttyvd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvd'
<7>kobject ttyve: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyve'
<7>kobject ttyvf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyvf'
<7>kobject ttyw0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw0'
<7>kobject ttyw1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw1'
<7>kobject ttyw2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw2'
<7>kobject ttyw3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw3'
<7>kobject ttyw4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw4'
<7>kobject ttyw5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw5'
<7>kobject ttyw6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw6'
<7>kobject ttyw7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw7'
<7>kobject ttyw8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw8'
<7>kobject ttyw9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyw9'
<7>kobject ttywa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywa'
<7>kobject ttywb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywb'
<7>kobject ttywc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywc'
<7>kobject ttywd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywd'
<7>kobject ttywe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywe'
<7>kobject ttywf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttywf'
<7>kobject ttyx0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx0'
<7>kobject ttyx1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx1'
<7>kobject ttyx2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx2'
<7>kobject ttyx3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx3'
<7>kobject ttyx4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx4'
<7>kobject ttyx5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx5'
<7>kobject ttyx6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx6'
<7>kobject ttyx7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx7'
<7>kobject ttyx8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx8'
<7>kobject ttyx9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyx9'
<7>kobject ttyxa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxa'
<7>kobject ttyxb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxb'
<7>kobject ttyxc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxc'
<7>kobject ttyxd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxd'
<7>kobject ttyxe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxe'
<7>kobject ttyxf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyxf'
<7>kobject ttyy0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy0'
<7>kobject ttyy1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy1'
<7>kobject ttyy2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy2'
<7>kobject ttyy3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy3'
<7>kobject ttyy4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy4'
<7>kobject ttyy5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy5'
<7>kobject ttyy6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy6'
<7>kobject ttyy7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy7'
<7>kobject ttyy8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy8'
<7>kobject ttyy9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyy9'
<7>kobject ttyya: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyya'
<7>kobject ttyyb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyb'
<7>kobject ttyyc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyc'
<7>kobject ttyyd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyd'
<7>kobject ttyye: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyye'
<7>kobject ttyyf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyyf'
<7>kobject ttyz0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz0'
<7>kobject ttyz1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz1'
<7>kobject ttyz2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz2'
<7>kobject ttyz3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz3'
<7>kobject ttyz4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz4'
<7>kobject ttyz5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz5'
<7>kobject ttyz6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz6'
<7>kobject ttyz7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz7'
<7>kobject ttyz8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz8'
<7>kobject ttyz9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyz9'
<7>kobject ttyza: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyza'
<7>kobject ttyzb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzb'
<7>kobject ttyzc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzc'
<7>kobject ttyzd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzd'
<7>kobject ttyze: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyze'
<7>kobject ttyzf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyzf'
<7>kobject ttya0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya0'
<7>kobject ttya1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya1'
<7>kobject ttya2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya2'
<7>kobject ttya3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya3'
<7>kobject ttya4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya4'
<7>kobject ttya5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya5'
<7>kobject ttya6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya6'
<7>kobject ttya7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya7'
<7>kobject ttya8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya8'
<7>kobject ttya9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttya9'
<7>kobject ttyaa: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyaa'
<7>kobject ttyab: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyab'
<7>kobject ttyac: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyac'
<7>kobject ttyad: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyad'
<7>kobject ttyae: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyae'
<7>kobject ttyaf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyaf'
<7>kobject ttyb0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb0'
<7>kobject ttyb1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb1'
<7>kobject ttyb2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb2'
<7>kobject ttyb3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb3'
<7>kobject ttyb4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb4'
<7>kobject ttyb5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb5'
<7>kobject ttyb6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb6'
<7>kobject ttyb7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb7'
<7>kobject ttyb8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb8'
<7>kobject ttyb9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyb9'
<7>kobject ttyba: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyba'
<7>kobject ttybb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybb'
<7>kobject ttybc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybc'
<7>kobject ttybd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybd'
<7>kobject ttybe: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybe'
<7>kobject ttybf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttybf'
<7>kobject ttyc0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc0'
<7>kobject ttyc1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc1'
<7>kobject ttyc2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc2'
<7>kobject ttyc3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc3'
<7>kobject ttyc4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc4'
<7>kobject ttyc5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc5'
<7>kobject ttyc6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc6'
<7>kobject ttyc7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc7'
<7>kobject ttyc8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc8'
<7>kobject ttyc9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyc9'
<7>kobject ttyca: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyca'
<7>kobject ttycb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycb'
<7>kobject ttycc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycc'
<7>kobject ttycd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycd'
<7>kobject ttyce: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyce'
<7>kobject ttycf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttycf'
<7>kobject ttyd0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd0'
<7>kobject ttyd1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd1'
<7>kobject ttyd2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd2'
<7>kobject ttyd3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd3'
<7>kobject ttyd4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd4'
<7>kobject ttyd5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd5'
<7>kobject ttyd6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd6'
<7>kobject ttyd7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd7'
<7>kobject ttyd8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd8'
<7>kobject ttyd9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyd9'
<7>kobject ttyda: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyda'
<7>kobject ttydb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydb'
<7>kobject ttydc: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydc'
<7>kobject ttydd: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydd'
<7>kobject ttyde: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyde'
<7>kobject ttydf: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttydf'
<7>kobject ttye0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye0'
<7>kobject ttye1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye1'
<7>kobject ttye2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye2'
<7>kobject ttye3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye3'
<7>kobject ttye4: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye4'
<7>kobject ttye5: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye5'
<7>kobject ttye6: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye6'
<7>kobject ttye7: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye7'
<7>kobject ttye8: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye8'
<7>kobject ttye9: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttye9'
<7>kobject ttyea: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyea'
<7>kobject ttyeb: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyeb'
<7>kobject ttyec: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyec'
<7>kobject ttyed: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyed'
<7>kobject ttyee: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyee'
<7>kobject ttyef: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyef'
<7>kobject printer: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/printer'
<6>lp: driver loaded but no devices found
<7>kobject hpet: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/hpet'
<7>kobject hpet: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/acpi/drivers/hpet'
<6>Generic RTC Driver v1.07
<7>kobject rtc: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/rtc'
<6>Linux agpgart interface v0.102
<7>kobject agpgart-intel: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/agpgart-intel'
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
<7>kobject serial8250: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<7>kobject ttyS0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<7>kobject ttyS1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS2: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS2'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS3: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS3'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject serial8250: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/serial8250'
<7>kobject serial: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/serial'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS0: cleaning up
<6>00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<7>kobject ttyS0: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS0'
<7>fill_kobj_path: path = '/devices/pnp0/00:07'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/platform/serial8250'
<7>kobject ttyS1: cleaning up
<6>00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<7>kobject ttyS1: registering. parent: tty, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/tty/ttyS1'
<7>fill_kobj_path: path = '/devices/pnp0/00:08'
<7>kobject serial: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/serial'
<7>kobject parport_pc: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/parport_pc'
<7>parport_pc: VIA 686A/8231 detected
<7>parport_pc: probing current configuration
<7>parport_pc: Current parallel port base: 0x378
<6>parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
<7>kobject lp0: registering. parent: printer, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/printer/lp0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.0'
<6>lp0: using parport0 (interrupt-driven).
<6>parport_pc: VIA parallel port: io=0x378, irq=7
<7>kobject parport_pc.956: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.956: cleaning up
<7>kobject parport_pc.888: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.888: cleaning up
<7>kobject parport_pc.632: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject parport_pc.632: cleaning up
<7>kobject parport_pc: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/parport_pc'
<7>kobject isa: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/isa'
<7>kobject devices: registering. parent: isa, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: isa, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject isa: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject ram0: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram0'
<7>kobject ram1: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram1'
<7>kobject ram2: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram2'
<7>kobject ram3: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram3'
<7>kobject ram4: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram4'
<7>kobject ram5: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram5'
<7>kobject ram6: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram6'
<7>kobject ram7: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram7'
<7>kobject ram8: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram8, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram8, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram8'
<7>kobject ram9: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram9, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram9, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram9'
<7>kobject ram10: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram10, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram10, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram10'
<7>kobject ram11: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram11, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram11, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram11'
<7>kobject ram12: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram12, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram12, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram12'
<7>kobject ram13: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram13, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram13, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram13'
<7>kobject ram14: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram14, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram14, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram14'
<7>kobject ram15: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: ram15, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: ram15, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/ram15'
<4>RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
<7>kobject loop0: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop0, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop0'
<7>kobject loop1: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop1'
<7>kobject loop2: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop2'
<7>kobject loop3: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop3, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop3'
<7>kobject loop4: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop4, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop4'
<7>kobject loop5: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop5, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop5'
<7>kobject loop6: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop6, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop6'
<7>kobject loop7: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: loop7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: loop7, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/loop7'
<6>loop: module loaded
<7>kobject plip0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/plip0'
<6>NET3 PLIP version 2.4-parport gniibe@mri.co.jp
<6>plip0: Parallel port at 0x378, using IRQ 7.
<7>kobject lo: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/lo'
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<7>kobject ide: registering. parent: <NULL>, set: bus
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/ide'
<7>kobject devices: registering. parent: ide, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject drivers: registering. parent: ide, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject PCI_IDE: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/PCI_IDE'
<7>Probing IDE interface ide0...
<7>Probing IDE interface ide1...
<4>hdc: TOSHIBA THNCF512MBA, ATA DISK drive
<7>kobject ide1: registering. parent: <NULL>, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>Probing IDE interface ide2...
<7>Probing IDE interface ide3...
<7>Probing IDE interface ide4...
<7>Probing IDE interface ide5...
<4>ide1 at 0x170-0x177,0x376 on irq 15
<7>kobject 1.0: registering. parent: ide1, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject ide-disk: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/ide/drivers/ide-disk'
<6>hdc: max request size: 128KiB
<6>hdc: 1000944 sectors (512 MB) w/2KiB Cache, CHS=993/16/63
<7>kobject hdc: registering. parent: <NULL>, set: block
<7>kobject holders: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject slaves: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6> hdc: hdc1 hdc2
<7>kobject hdc1: registering. parent: hdc, set: <NULL>
<7>kobject holders: registering. parent: hdc1, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject hdc2: registering. parent: hdc, set: <NULL>
<7>kobject holders: registering. parent: hdc2, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc/hdc1'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/block/hdc/hdc2'
<7>fill_kobj_path: path = '/devices/ide1/1.0'
<7>kobject queue: registering. parent: hdc, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject iosched: registering. parent: queue, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject scsi_disk: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_disk'
<7>kobject sd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/scsi/drivers/sd'
<7>kobject scsi_generic: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_generic'
<7>kobject ahci: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/ahci'
<7>kobject sata_via: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/sata_via'
<7>kobject pata_mpiix: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_mpiix'
<7>kobject pata_oldpiix: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_oldpiix'
<7>kobject pata_via: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/pata_via'
<7>pata_via 0000:00:07.1: version 0.3.2
<4>PCI: Unable to reserve I/O region #3:8@170 for device 0000:00:07.1
<4>pata_via 0000:00:07.1: failed to request/iomap BARs for port 1 (errno=-16)
<6>scsi0 : pata_via
<7>kobject host0: registering. parent: 0000:00:07.1, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject host0: registering. parent: scsi_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host/host0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1/host0'
<6>scsi1 : pata_via
<7>kobject host1: registering. parent: 0000:00:07.1, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject host1: registering. parent: scsi_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/scsi_host/host1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.1/host1'
<6>ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001c000 irq 14
<6>ata2: DUMMY
<7>kobject ehci_hcd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/ehci_hcd'
<7>kobject drivers: registering. parent: ehci_hcd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>USB Universal Host Controller Interface driver v3.0
<7>kobject uhci_hcd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/uhci_hcd'
<7>PCI: setting IRQ 12 as level-triggered
<6>PCI: Found IRQ 12 for device 0000:00:07.2
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<6>PCI: Sharing IRQ 12 with 0000:00:08.0
<6>uhci_hcd 0000:00:07.2: UHCI Host Controller
<7>kobject usb_host1: registering. parent: usb_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host/usb_host1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2'
<6>uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
<6>uhci_hcd 0000:00:07.2: irq 11, io base 0x0000c400
<7>kobject usb1: registering. parent: 0000:00:07.2, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1'
<7>kobject usb_endpoint: registering. parent: <NULL>, set: class
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint'
<7>kobject usbdev1.1_ep00: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev1.1_ep00'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1'
<6>usb usb1: configuration #1 chosen from 1 choice
<7>kobject 1-0:1.0: registering. parent: usb1, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1/1-0:1.0'
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<7>kobject usbdev1.1_ep81: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev1.1_ep81'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.2/usb1/1-0:1.0'
<6>PCI: Found IRQ 12 for device 0000:00:07.3
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<6>PCI: Sharing IRQ 12 with 0000:00:08.0
<6>uhci_hcd 0000:00:07.3: UHCI Host Controller
<7>kobject usb_host2: registering. parent: usb_host, set: class_obj
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_host/usb_host2'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3'
<6>uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
<6>uhci_hcd 0000:00:07.3: irq 11, io base 0x0000c800
<7>kobject usb2: registering. parent: 0000:00:07.3, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2'
<7>kobject usbdev2.1_ep00: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev2.1_ep00'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2'
<6>usb usb2: configuration #1 chosen from 1 choice
<7>kobject 2-0:1.0: registering. parent: usb2, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2/2-0:1.0'
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<7>kobject usbdev2.1_ep81: registering. parent: usb_endpoint, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/usb_endpoint/usbdev2.1_ep81'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:07.3/usb2/2-0:1.0'
<7>kobject drivers: registering. parent: uhci_hcd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usblp: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usblp'
<7>kobject drivers: registering. parent: usblp, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usblp
<6>Initializing USB Mass Storage driver...
<7>kobject usb-storage: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usb-storage'
<7>kobject drivers: registering. parent: usb_storage, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usb-storage
<6>USB Mass Storage support registered.
<7>kobject i8042 kbd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/i8042 kbd'
<7>kobject i8042 aux: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pnp/drivers/i8042 aux'
<6>PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
<7>kobject i8042: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/platform/drivers/i8042'
<7>kobject i8042: registering. parent: platform, set: devices
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<7>kobject mice: registering. parent: input, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input/mice'
<7>kobject serio0: registering. parent: i8042, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>kobject psaux: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/psaux'
<6>mice: PS/2 mouse device common for all mice
<7>kobject atkbd: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio/drivers/atkbd'
<7>kobject drivers: registering. parent: atkbd, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject psmouse: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/serio/drivers/psmouse'
<7>kobject input0: registering. parent: input, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/input/input0'
<7>fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>fill_kobj_path: path = '/class/input/input0'
<6>input: AT Translated Set 2 keyboard as /class/input/input0
<7>kobject drivers: registering. parent: psmouse, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject usbhid: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/usb/drivers/usbhid'
<7>kobject drivers: registering. parent: usbhid, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<6>usbcore: registered new interface driver usbhid
<6>drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<6>oprofile: using timer interrupt.
<4>Netfilter messages via NETLINK v0.30.
<4>nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
<7>kobject :0000216: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000216'
<7>kobject :0000136: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/:0000136'
<6>IPv4 over IPv4 tunneling driver
<7>kobject tunl0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/tunl0'
<6>GRE over IPv4 tunneling driver
<7>kobject gre0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/gre0'
<6>ip_tables: (C) 2000-2006 Netfilter Core Team
<6>arp_tables: (C) 2002 David S. Miller
<6>TCP cubic registered
<6>Initializing XFRM netlink socket
<6>NET: Registered protocol family 1
<6>NET: Registered protocol family 17
<7>kobject rpc_inode_cache: registering. parent: <NULL>, set: slab
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/slab/rpc_inode_cache'
<4>Using IPI Shortcut mode
<5>RAMDISK: Compressed image found at block 0
<4>VFS: Mounted root (minix filesystem) readonly.
<6>Freeing unused kernel memory: 176k freed
<4>Warning: unable to open an initial console.
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject cramfs: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cramfs, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cramfs'
<7>kobject 8139too: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: 8139too, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/8139too'
<6>8139too Fast Ethernet driver 0.9.28
<7>kobject 8139too: registering. parent: <NULL>, set: drivers
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/bus/pci/drivers/8139too'
<6>PCI: Found IRQ 12 for device 0000:00:08.0
<6>IRQ routing conflict for 0000:00:07.2, have irq 11, want irq 12
<6>IRQ routing conflict for 0000:00:07.3, have irq 11, want irq 12
<7>kobject eth0: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth0'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:08.0'
<6>eth0: RealTek RTL8139 at 0xc8016000, 00:30:18:49:b2:31, IRQ 12
<7>eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>PCI: setting IRQ 10 as level-triggered
<6>PCI: Found IRQ 10 for device 0000:00:09.0
<7>kobject eth1: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth1'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:09.0'
<6>eth1: RealTek RTL8139 at 0xc8032000, 00:30:18:49:b2:30, IRQ 10
<7>eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>PCI: setting IRQ 11 as level-triggered
<6>PCI: Found IRQ 11 for device 0000:00:0b.0
<6>IRQ routing conflict for 0000:00:07.5, have irq 5, want irq 11
<7>kobject eth2: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2'
<7>fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0'
<6>eth2: RealTek RTL8139 at 0xc8034000, 00:30:18:49:b2:2f, IRQ 11
<7>eth2:  Identified 8139 chip type 'RTL-8100B/8139D'
<7>kobject drivers: registering. parent: 8139too, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject 8021q: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: 8021q, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/8021q'
<6>802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
<6>All bugs added by David S. Miller <davem@redhat.com>
<7>kobject tun: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: tun, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/tun'
<6>tun: Universal TUN/TAP device driver, 1.6
<6>tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<7>kobject tun: registering. parent: misc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/misc/tun'
<6>eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
<6>eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
<6>eth2: link up, 100Mbps, full-duplex, lpa 0x45E1
<7>kobject eth2.2: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.2'
<7>kobject eth2.3: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.3'
<7>kobject eth2.4: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.4'
<7>kobject eth2.5: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.5'
<7>kobject eth2.6: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.6'
<7>kobject eth2.7: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.7'
<7>kobject eth2.8: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.8'
<7>kobject eth2.9: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.9'
<7>kobject eth2.10: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.10'
<7>kobject eth2.11: registering. parent: net, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/net/eth2.11'
<4>process `named' is using obsolete setsockopt SO_BSDCOMPAT
<7>kobject sch_htb: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: sch_htb, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/sch_htb'
<7>kobject cls_u32: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cls_u32, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cls_u32'
<4>u32 classifier
<4>    Performance counters on
<4>    Actions configured 
<7>kobject cls_fw: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: cls_fw, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/cls_fw'
<7>kobject sch_sfq: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: sch_sfq, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/sch_sfq'
<7>kobject ebtables: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebtables, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebtables'
<6>Ebtables v2.0 registered
<7>kobject ebtable_nat: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebtable_nat, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebtable_nat'
<7>kobject ebt_ip: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: ebt_ip, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/ebt_ip'
<6>device eth2 entered promiscuous mode
<5>audit(1216115913.546:2): dev=eth2 prom=256 old_prom=0 auid=4294967295
<6>device eth2.2 entered promiscuous mode
<5>audit(1216115913.558:3): dev=eth2.2 prom=256 old_prom=0 auid=4294967295
<6>device eth2.3 entered promiscuous mode
<5>audit(1216115913.574:4): dev=eth2.3 prom=256 old_prom=0 auid=4294967295
<6>device eth2.4 entered promiscuous mode
<5>audit(1216115913.590:5): dev=eth2.4 prom=256 old_prom=0 auid=4294967295
<6>device eth2.5 entered promiscuous mode
<5>audit(1216115913.606:6): dev=eth2.5 prom=256 old_prom=0 auid=4294967295
<6>device eth2.6 entered promiscuous mode
<5>audit(1216115913.622:7): dev=eth2.6 prom=256 old_prom=0 auid=4294967295
<6>device eth2.7 entered promiscuous mode
<5>audit(1216115913.638:8): dev=eth2.7 prom=256 old_prom=0 auid=4294967295
<6>device eth2.8 entered promiscuous mode
<5>audit(1216115913.654:9): dev=eth2.8 prom=256 old_prom=0 auid=4294967295
<6>device eth2.9 entered promiscuous mode
<5>audit(1216115913.674:10): dev=eth2.9 prom=256 old_prom=0 auid=4294967295
<6>device eth2.10 entered promiscuous mode
<5>audit(1216115913.690:11): dev=eth2.10 prom=256 old_prom=0 auid=4294967295
<6>device eth2.11 entered promiscuous mode
<5>audit(1216115913.706:12): dev=eth2.11 prom=256 old_prom=0 auid=4294967295
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcsa2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcs2: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject vcsa2: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcs1: cleaning up
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject vcsa1: cleaning up
<7>kobject vcs2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject vcsa2: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa2'
<7>kobject vcs1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcs1'
<7>kobject vcsa1: registering. parent: vc, set: devices
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/class/vc/vcsa1'
<7>kobject compat_xtables: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: compat_xtables, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/compat_xtables'
<7>kobject xt_RAWNAT: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: xt_RAWNAT, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/xt_RAWNAT'
<7>kobject iptable_rawpost: registering. parent: <NULL>, set: module
<7>kobject holders: registering. parent: iptable_rawpost, set: <NULL>
<7>kobject_uevent_env
<7>kobject filter function caused the event to drop!
<7>kobject_uevent_env
<7>fill_kobj_path: path = '/module/iptable_rawpost'
<6>device eth0 entered promiscuous mode
<5>audit(1216116448.402:13): dev=eth0 prom=256 old_prom=0 auid=4294967295
<6>device eth0 left promiscuous mode
<5>audit(1216116451.503:14): dev=eth0 prom=0 old_prom=256 auid=4294967295
<6>device eth0 entered promiscuous mode
<5>audit(1216116456.575:15): dev=eth0 prom=256 old_prom=0 auid=4294967295
<6>device eth0 left promiscuous mode
<5>audit(1216116466.115:16): dev=eth0 prom=0 old_prom=256 auid=4294967295
<3>compat_xtables: compat layer limits reached (xtnu_skb_make_writable) - dropping packets

--------------060008070208040206090803--
