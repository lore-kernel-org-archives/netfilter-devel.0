From: "Hung Lin" <hlin@nextone.com>
Subject: RE: Kernel oops when putting the console option in
	/boot/grub/menu.lst
Date: Thu, 10 May 2007 13:06:29 -0400
Message-ID: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D4A@moe.nextone.local>
References: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>
	<46434BE2.5090605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <46434BE2.5090605@trash.net>
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

>Hung Lin wrote:
>> Hi,
>>=20
>> I'm using ipset-2.2.9 with kernel 2.6.11.4-21.13 (SuSE 9.3 kernel) =
and
>> iptables-1.3.1-3 (SuSE 9.3 iptables) and everything is fine.  But=20
>> after I added a console option to /boot/grub/menu.lst, the kenrel =
will=20
>> hang sometimes and show kernel oops message on the monitor.  After=20
>> research, I found it is `iptables -m hashlimit` command to cause this =
problem.
>> Therefore, I did some tests:
>>=20
>> I used a loop to insert and delete hashlimit rules to iptables, =
here's=20
>> the result:
>>=20
>> 1. with ipset patch and without console option in grub menu, no=20
>> problem
>>=20
>> 2. withotu ipset patch and with console option in grub menu, no=20
>> problem
>>=20
>> 3. with ipset patch and with console option in grub menu, kernel=20
>> crashs after hundreds of iterations.
>>=20
>>=20
>> It looks like console option in the grub menu has something conflict=20
>> with ipset kernel patch.  But I don't understand.
>>=20
>> Please give me your advices.  Thanks in advance.


>Please send the oops.



The oops message are not always the same.  Most time the process is =
iptables and the first call trace is htable_destroy,  sometime the first =
call trace is htable_create.  And some times the process is swapper.

Here are the most often oops messages:

Oops: 0002 [#1]
SMP
Modules linked in: af_packet ip_set_ipporthash ip_set_ipportiphash =
ip_set_iphash ipt_limit ip_set_portmap ipt_sethl ip_set_ipnethash =
ipt_ULOG ipt_hashlimit ipt_set ip_set_ipiphash 8021q edd joydev nvram =
thermal processor fan button battery ac bv rp ipt_state ipt_pkttype ipv6 =
hhnet_drawb hhnet hhnet_eth e1000 ehci_hcd uhci_hcd usbcore i2c_i801 =
i2c_core evdev iptable_filter ip6table_filter ip6_tables ip_nat_ftp =
iptable_nat ip_conntrack_ftp ip_conntrack ip_tables dm_mod sr_mod st =
mptspi mptscsih mptbase ide_cd cdrom reiserfs aic79xx sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c012b5bb>]    Tainted: PF    U VLI
EFLAGS: 00010046   (2.6.11.4-430.8-bigsmp)
EIP is at del_timer+0x3b/0x70
eax: f112e034   ebx: c381bae0   ecx: 00000282   edx: f12f2034
esi: f1304034   edi: f561efe0   ebp: e4e54000   esp: e4e55c18
ds: 007b   es: 007b   ss: 0068
Process iptables (pid: 25097, threadinfo=3De4e54000 task=3Ddf2dd020)
Stack: f1304000 00000070 f0eb4427 f561f050 f0976b57 e4e55c58 00000074 =
e4e55c88
       e4e55c9c 08053078 e4e55c84 e4e54000 0000bf60 f0d89000 f5613000 =
f5da5000
       00000000 746c6966 00007265 00000000 00000000 00000000 00000000 =
00000000
Call Trace:
 [<f0eb4427>] htable_destroy+0x37/0x60 [ipt_hashlimit]
 [<f0976b57>] do_replace+0x437/0x650 [ip_tables]
 [<f097701b>] do_ipt_set_ctl+0x4b/0x60 [ip_tables]
 [<c02ccd53>] nf_sockopt+0xc3/0x120
 [<c02ccdce>] nf_setsockopt+0x1e/0x30
 [<c02e5bbc>] ip_setsockopt+0x10c/0xb10
 [<c02ccd20>] nf_sockopt+0x90/0x120
 [<c02e6670>] ip_getsockopt+0xb0/0x6c0
 [<c0119dc3>] do_page_fault+0x1d3/0x613
 [<c0152e6d>] zap_pte_range+0x1fd/0x370
 [<c0148e5c>] buffered_rmqueue+0x14c/0x210
 [<c0149115>] __alloc_pages+0x125/0x450
 [<c0154e0c>] do_anonymous_page+0x7c/0x1e0
 [<c0154fea>] do_no_page+0x7a/0x350
 [<c0155592>] handle_mm_fault+0x1c2/0x1e0
 [<c01f93d4>] vsnprintf+0x394/0x510
 [<c0119dc3>] do_page_fault+0x1d3/0x613
 [<c01649df>] fd_install+0x2f/0x60
 [<c0166559>] fget+0x49/0x60
 [<c02bcb56>] sock_common_setsockopt+0x26/0x40
 [<c02ba659>] sys_setsockopt+0x69/0xd0
 [<c02bac8a>] sys_socketcall+0xca/0x250
 [<c0119bf0>] do_page_fault+0x0/0x613
 [<c010506d>] sysenter_past_esp+0x52/0x75
Code: ff ff eb 17 89 d8 e8 45 fc 20 00 3b 5e 1c 89 c1 74 14 89 c2 89 d8 =
e8 75 fd 20 00 8b 5e 1c 31 c0 85 db 75 e0 eb 2c 8b 56 04 8b 06 <89> 50 =
04 89 02 c7 46 04 00 02 20 00 c7 06 00 01 10 00 c7 46 1c
