From: "leeroot" <leeroot@163.net>
Subject: ipt_recent on 2.4.18-Newnat13+Helpers crashed
Date: Fri, 31 May 2002 13:15:29 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020531051315.B89211D743833@bjapp9.163.net>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

	2.4.18-Newnat13+Helpers iptables-1.2.6a, ipt_recent patched, 1 CPU, gcc compiler on Redhat7.2. take cmd:
		iptables -A FORWARD -m recent --rcheck -j DROP
	system crashed, if load ipt_recent first use cmd: 
		modprobe ipt_recent
	then call 	iptables cmd, it's ok most all(only 1 time crashed i meet), if add paramter to module, for example:
		modprobe ipt_recent ip_list_tot 2000
	then call iptables cmd, crashed all.

system crashed message after: modprobe ipt_recent ip_list_tot=2000, iptables -A FORWARD -m recent --rcheck -j DROP

==========================================================================
invalid operand: 000
CPU:	0
EIP:	0010:[<c0128132>]	Not tainted
EFLAGS:	00010202
eax: 000001f0	ebx: c1803a40	ecx: c1803a50	edx: 00000000
esi: c1803a40	edi: 000001f0	ebp: c1803a40	esp: ddd51d34
ds: 0018	es: 0018	ss: 0018
Process iptables (pid 515, stackpage=ddd51000)
Stack: c01274c6 0008a000 c0101e0c e088a000 c0101e0c 00000282 e085672c c1803a40
	   00000246 000001f0 c1803a40 c012847d c1803a40 000001f0 e0888000 ddd50000
	   00000000 e0888000 00000000 e08882f6 dfbd0348 dfbd0280 e0880c2c 00009c40
Call Trace: [<c01274c6>] [<c012847d>] [<e0880c2c>] [<e0850a15>] [<e08511d9>]
	[<e0851697>] [<e0852980>] [<c01fc45a>] [<c01fc4c0>] [<c0207fc8>] [<c0223765>]
	[<c01f0f56>] [<c01f15e6>] [<c0110c80>] [<c0106dec>] [<c0106cfb>]

Code: 0f 0b 89 7c 24 04 b8 03 00 00 00 81 64 24 04 f0 01 00 00 c7
 <0>Kernel panic: Aiee, Killing interrupt handler!
In interrupt handler -  not syncing
==========================================================================
