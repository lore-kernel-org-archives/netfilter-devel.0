From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: segmentation fault with proc cleanup + CLUSTERIP
Date: Mon, 4 Jul 2005 12:59:19 +1000
Message-ID: <088201c58044$5f81ca00$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
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

Hi Harald,

There seems to be a small issue with your clusterip code cleaning the proc 
entries when removing the iptables rule. This happened when I did an 
iptables remove:

iptables -D input -d 10.1.1.206 -j CLUSTERIP --hashmode ... etc.

I'm running 2.6.12 stable and the latest iptables snapshot.

I have not been able to induce this condition more than once.

Jul  4 12:23:55 localhost user.alert kernel: Unable to handle kernel paging 
request at virtual address 00003d04
Jul  4 12:23:55 localhost user.alert kernel:  printing eip:
Jul  4 12:23:55 localhost user.warn kernel: c018ea2c
Jul  4 12:23:55 localhost user.alert kernel: *pde = 00000000
Jul  4 12:23:55 localhost user.alert kernel: Oops: 0000 [#1]
Jul  4 12:23:55 localhost user.warn kernel: PREEMPT SMP
Jul  4 12:23:55 localhost user.warn kernel: CPU:    0
Jul  4 12:23:55 localhost user.warn kernel: EIP:    0060:[<c018ea2c>]    Not 
tainted VLI
Jul  4 12:23:55 localhost user.warn kernel: EFLAGS: 00010202   (2.6.12)
Jul  4 12:23:55 localhost user.warn kernel: EIP is at 
remove_proc_entry+0x2c/0x150
Jul  4 12:23:55 localhost user.warn kernel: eax: 00000000   ebx: 00003cd0 
ecx: 00000007   edx: 08048000
Jul  4 12:23:55 localhost user.warn kernel: esi: 00000070   edi: 08048008 
ebp: 0000062c   esp: e7169bb0
Jul  4 12:23:55 localhost user.warn kernel: ds: 007b   es: 007b   ss: 0068
Jul  4 12:23:55 localhost user.warn kernel: Process iptables (pid: 16878, 
threadinfo=e7168000 task=f0d10a40)
Jul  4 12:23:55 localhost user.warn kernel: Stack: 00000070 00000027 
000001f0 00001444 08048000 f8dd56fc 00000070 f8dd566c
Jul  4 12:23:55 localhost user.warn kernel:        c0531306 08048000 
00003cd0 c06ae62f f8dd5000 f8dd52ac c05239b9 f8dd56fc
Jul  4 12:23:55 localhost user.warn kernel:        0000003c f8dd2000 
e7169c20 0000001f e7169c50 e7169c64 080d2644 e7169d78
Jul  4 12:23:55 localhost user.warn kernel: Call Trace:
Jul  4 12:23:55 localhost user.warn kernel:  [<c0531306>] destroy+0x26/0xb0
Jul  4 12:23:55 localhost user.warn kernel:  [<c05239b9>] 
do_replace+0x3e9/0x4a0
Jul  4 12:23:55 localhost user.warn kernel:  [<c0523cc3>] 
do_ipt_set_ctl+0x73/0x80
Jul  4 12:23:55 localhost user.warn kernel:  [<c04cc7ef>] 
nf_sockopt+0x12f/0x140
Jul  4 12:23:55 localhost user.warn kernel:  [<c04cc837>] 
nf_setsockopt+0x37/0x40
Jul  4 12:23:55 localhost user.warn kernel:  [<c04e79f0>] 
ip_setsockopt+0x520/0xc60
Jul  4 12:23:55 localhost user.warn kernel:  [<c04cc779>] 
nf_sockopt+0xb9/0x140
Jul  4 12:23:55 localhost user.warn kernel:  [<c04ba5cb>] 
release_sock+0x1b/0x80
Jul  4 12:23:55 localhost user.warn kernel:  [<c04e8748>] 
ip_getsockopt+0x618/0x680
Jul  4 12:23:55 localhost user.warn kernel:  [<c0113f80>] 
do_page_fault+0x380/0x5ac
Jul  4 12:23:55 localhost user.warn kernel:  [<c013fccd>] 
buffered_rmqueue+0x16d/0x210
Jul  4 12:23:55 localhost user.warn kernel:  [<c0140112>] 
__alloc_pages+0x2f2/0x420
Jul  4 12:23:55 localhost user.warn kernel:  [<c014b9f6>] 
do_anonymous_page+0x56/0x1c0
Jul  4 12:23:55 localhost user.warn kernel:  [<c014bbc7>] 
do_no_page+0x67/0x3c0
Jul  4 12:23:55 localhost user.warn kernel:  [<c01499a8>] 
pte_alloc_map+0x88/0xe0
Jul  4 12:23:55 localhost user.warn kernel:  [<c014c15e>] 
handle_mm_fault+0x10e/0x1b0
Jul  4 12:23:55 localhost user.warn kernel:  [<c0113f80>] 
do_page_fault+0x380/0x5ac
Jul  4 12:23:55 localhost user.warn kernel:  [<c04ba7d6>] 
sock_common_setsockopt+0x36/0x40
Jul  4 12:23:55 localhost user.warn kernel:  [<c04b810c>] 
sys_setsockopt+0x6c/0xc0
Jul  4 12:23:55 localhost user.warn kernel:  [<c04b88c4>] 
sys_socketcall+0x204/0x270
Jul  4 12:23:55 localhost user.warn kernel:  [<c0113c00>] 
do_page_fault+0x0/0x5ac
Jul  4 12:23:55 localhost user.warn kernel:  [<c0102fb5>] 
syscall_call+0x7/0xb
Jul  4 12:23:55 localhost user.warn kernel: Code: 56 53 83 ec 14 8b 5c 24 28 
8b 54 24 24 85 db 89 54 24 10 0f 84 03 01 00 00 8b 54 2 
