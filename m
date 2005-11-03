From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Thu, 3 Nov 2005 14:46:14 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511031444220.2680@bizon.gios.gov.pl>
References: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
	<43662D1E.4000308@eurodev.net>
	<Pine.LNX.4.62.0510311544350.31123@bizon.gios.gov.pl>
	<200510311902.j9VJ28Dq026610@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1655916264-1131025574=:2680"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200510311902.j9VJ28Dq026610@toshiba.co.jp>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1655916264-1131025574=:2680
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 1 Nov 2005, Yasuyuki KOZAKAI wrote:

>
> Hi,
>
> From: Krzysztof Oledzki <olenf@ans.pl>
> Date: Mon, 31 Oct 2005 15:46:10 +0100 (CET)
>
>> On Mon, 31 Oct 2005, Pablo Neira wrote:
>>
>>> Krzysztof Oledzki wrote:
>>>> On Mon, 31 Oct 2005, Pablo Neira wrote:
>>>> <CUT>
>>>>
>>>>>> PS: Would you find some time to look at
>>>>>> http://bugzilla.kernel.org/show_bug.cgi?id=3D5438
>>>>>
>>>>>
>>>>> Can you still trigger that oops with the current working copy from SV=
N?
>>>>
>>>> IMHO this is a kernel bug. And to be clear: there is no problem with n=
ew
>>>> version of userspace application/libraries.
>>>>
>>>> The problem apperas only with _old_ library. There were a lot of API
>>>> changes and probably kernel does not properly validate user data
>>>> (boudaries?).
>
> I'm not sure it's the reason of oops, but at least attached patch fixes
> double free after netlink_unicast(). Krzysztof, could you try this ?

Tested. Kernel still generates BUG & oopses:

------------[ cut here ]------------
kernel BUG at kernel/sched.c:2819!
invalid operand: 0000 [#1]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c011a828>]    Not tainted VLI
EFLAGS: 00010086   (2.6.14)
EIP is at add_preempt_count+0x28/0x40
eax: c03e1d95   ebx: c15c9a54   ecx: 00000001   edx: dc8c2000
esi: df55fd00   edi: 00000292   ebp: dc8c2000   esp: dc8c2000
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 298, threadinfo=3Ddc8c1000 task=3Ddce60a90)
Stack:
Call Trace:
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  [<c03b36f0>] sock_rfree+0x0/0x20
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Unable to handle kernel NULL pointer dereference at virtual address 0000000=
6
  printing eip:
c0103f2e
*pde =3D 00000000
Oops: 0000 [#2]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c0103f2e>]    Not tainted VLI
EFLAGS: 00010097   (2.6.14)
EIP is at show_trace+0x2e/0x90
eax: 00000ffd   ebx: 00000006   ecx: 00000000   edx: 00000001
esi: 00000006   edi: 00000000   ebp: 00000068   esp: dc8c1e60
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 298, threadinfo=3Ddc8c1000 task=3Ddce60a90)
Stack: c04f258e c03b36f0 dc8c2000 00000000 00000000 c0104010 00000000 dc8c2=
000
        c063d760 dc8c1fcc 00000000 c01041af 00000000 dc8c2000 0000012a dc8c=
1000
        dce60a90 00010086 c05654a2 00000001 00000000 dc8c1fcc c04f267e dc8c=
2000
Call Trace:
  [<c03b36f0>] sock_rfree+0x0/0x20
  [<c0104010>] show_stack+0x80/0xa0
  [<c01041af>] show_registers+0x15f/0x1d0
  [<c01043c7>] die+0xf7/0x1a0
  [<c0104720>] do_invalid_op+0x0/0xd0
  [<c01047d2>] do_invalid_op+0xb2/0xd0
  [<c011a828>] add_preempt_count+0x28/0x40
  [<c0103ccf>] error_code+0x4f/0x54
  [<c03e1d95>] netlink_sendskb+0x25/0x60
  [<c011a828>] add_preempt_count+0x28/0x40
Code: 83 ec 08 8b 5c 24 1c 89 df 89 de 81 e7 00 f0 ff ff 8d b6 00 00 00 00 =
8d bf 00 00 00 00 39 fe 76 49 8d 87 fd 0f 00 00 39
  <6>note: conntrack[298] exited with preempt_count 3
Unable to handle kernel paging request at virtual address 08a80920
  printing eip:
c0120a9c
*pde =3D 00000000
Oops: 0002 [#3]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c0120a9c>]    Not tainted VLI
EFLAGS: 00010246   (2.6.14)
EIP is at do_exit+0x1ec/0x490
eax: 08a80840   ebx: 08a80840   ecx: 00000001   edx: dc8c1000
esi: dce60a90   edi: dc8c1000   ebp: 0000000b   esp: dc8c1d68
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 298, threadinfo=3Ddc8c1000 task=3Ddce60a90)
Stack: dffeea80 c0661af8 0000012a 00000003 00000001 dc8c1000 dc8c1e2c c04f3=
d93
        0000000e c010446f dce60a90 00000001 dc8c1da0 00000002 dc8c1e2c c04f=
3d93
        00000000 000000ff 0000000b 0000000e c04f3d31 00000006 00000000 0000=
000e
Call Trace:
  [<c010446f>] die+0x19f/0x1a0
  [<c04b59de>] do_page_fault+0x2ee/0x623
  [<c04b56f0>] do_page_fault+0x0/0x623
  [<c0103ccf>] error_code+0x4f/0x54
  [<c0103f2e>] show_trace+0x2e/0x90
  [<c03b36f0>] sock_rfree+0x0/0x20
  [<c0104010>] show_stack+0x80/0xa0
  [<c01041af>] show_registers+0x15f/0x1d0
  [<c01043c7>] die+0xf7/0x1a0
  [<c0104720>] do_invalid_op+0x0/0xd0
  [<c01047d2>] do_invalid_op+0xb2/0xd0
  [<c011a828>] add_preempt_count+0x28/0x40
  [<c0103ccf>] error_code+0x4f/0x54
  [<c03e1d95>] netlink_sendskb+0x25/0x60
  [<c011a828>] add_preempt_count+0x28/0x40
Code: 00 85 c0 0f 85 00 01 00 00 8b 46 04 8b 40 04 8b 58 24 85 db 74 40 b8 =
01 00 00 00 e8 6f 9d ff ff e8 8a 76 15 00 c1 e0 05
  <1>Fixing recursive fault but reboot is needed!
scheduling while atomic: conntrack/0x00000004/298
  [<c04b3e72>] schedule+0x632/0x640
  [<c0105509>] do_IRQ+0x59/0x80
  [<c0120cc7>] do_exit+0x417/0x490
  [<c010446f>] die+0x19f/0x1a0
  [<c04b59de>] do_page_fault+0x2ee/0x623
  [<c04b56f0>] do_page_fault+0x0/0x623
  [<c0103ccf>] error_code+0x4f/0x54
  [<c0120a9c>] do_exit+0x1ec/0x490
  [<c010446f>] die+0x19f/0x1a0
  [<c04b59de>] do_page_fault+0x2ee/0x623
  [<c04b56f0>] do_page_fault+0x0/0x623
  [<c0103ccf>] error_code+0x4f/0x54
  [<c0103f2e>] show_trace+0x2e/0x90
  [<c03b36f0>] sock_rfree+0x0/0x20
  [<c0104010>] show_stack+0x80/0xa0
  [<c01041af>] show_registers+0x15f/0x1d0
  [<c01043c7>] die+0xf7/0x1a0
  [<c0104720>] do_invalid_op+0x0/0xd0
  [<c01047d2>] do_invalid_op+0xb2/0xd0
  [<c011a828>] add_preempt_count+0x28/0x40
  [<c0103ccf>] error_code+0x4f/0x54
  [<c03e1d95>] netlink_sendskb+0x25/0x60
  [<c011a828>] add_preempt_count+0x28/0x40


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1655916264-1131025574=:2680--
