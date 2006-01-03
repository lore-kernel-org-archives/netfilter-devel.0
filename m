From: Moises Silva <moises.silva@gmail.com>
Subject: Patch for H323 connection tracking for kernel 2.6.14 and Panic with
	SIP tracking
Date: Tue, 3 Jan 2006 14:37:20 -0600
Message-ID: <c4d05cbe0601031237r17e13dadta6da17543714d529@mail.gmail.com>
References: <c4d05cbe0512311447v33a9cb13w4e6201c5d6ccbd00@mail.gmail.com>
	<c4d05cbe0601021028x4dad0a18n2b3c1b8e10506f11@mail.gmail.com>
	<43BA605E.3020801@trash.net>
	<c4d05cbe0601031235i45561171tc0ba691cf5fa417e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2478_19853498.1136320640272"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <c4d05cbe0601031235i45561171tc0ba691cf5fa417e@mail.gmail.com>
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

------=_Part_2478_19853498.1136320640272
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have already done the changes to use ip_ct_refresh() and still
panics. But as time passes and i read more stuff, im more confused. I
found this patch

http://people.ecsc.co.uk/~matt/patches/kernel/2.6.14/05-netfilter-sip-connt=
rack-nat.patch

however i didnt check for differences between that patch and the one
provided by patch-o-matic, so i made a copy of my previous kernel but
with this other patch, and seems to work. I made a diff -Nur between
both kernels and didnt find anything particular about the sip
conntrack. Then i backed again to the buggy kernel and now is giving
the next errors when i try to modprobe ip_nat_sip:

Jan  3 13:17:17 [kernel] kobject_register failed for ip_conntrack_sip (-17)
Jan  3 13:17:17 [kernel] ------------[ cut here ]------------
Jan  3 13:17:17 [kernel] kernel BUG at net/ipv4/netfilter/ip_nat_sip.c:241!
Jan  3 13:17:17 [kernel] invalid operand: 0000 [#1]

Im attaching a copy of the kernel panic it gives me the first time.
Notice that i have seen 2 different kernel panics, one when my box is
booting up, and other when I load the ip_nat_sip module. The first
kernel panic is the one im attaching a copy of, but the second one i
havent had the time of copyingit, theres a painless way of copying the
dump when panics??

Any help would be appreciated.

On 1/3/06, Patrick McHardy <kaber@trash.net> wrote:
> Moises Silva wrote:
> > still getting kernel panic, copy the whole thing is a time consuming
> > task, for now doing nothing, but i have downgraded the kernel to
> > 2.6.13 and at least it does not kernel panics. Some one has a patch
> > for sip connection tracking for kernel-2.6.14??
>
> Most likely you need to change
>
>          ip_ct_refresh_acct(ct, ctinfo, NULL, sip_timeout * HZ);
>
> to
>
>          ip_ct_refresh(ct, *pskb, sip_timeout * HZ);
>
> in net/ipv4/netfilter/ip_conntrack_sip.c. If that doesn't help
> please post the entire oops.
>


--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"




--
"Su nombre es GNU/Linux, no solamente Linux, mas info en http://www.gnu.org=
"

------=_Part_2478_19853498.1136320640272
Content-Type: application/octet-stream; name=panic
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="panic"

[<c0482c25>] nf_hook_slow+0x75/0x130
[<c043df50>] ip_finish_output2+0x0/0x10
[<c043bab0>] ip_output+0x270/0x2a0
[<c043df50>] ip_finish_output+0x0/0x10
[<c043d97e>] ip_push_pending_frames+0x30e/0x4b0
[<c043df20>] dst_output+0x0/0x30
[<c0458abe>] udp_push_pending_frames+0x15e/0x2a0
[<c0458fb8>] udp_sendmsg+0x378/0x700
[<c045b487>] arp_bind_neighbor+0x67/0xa0
[<c0460c1a>] inet_sendmsg+0x4a/0x60
[<c0410955>] sock_sendmsg+0xe5/0x100
[<c0436a7f>] ip_route_output_flow+0x1f/0x60
[<c0132e00>] autoremove_wait_function+0x0/0x60
[<c0410488>] move_addr_to_kernel+0x48/0x70
[<c0411fc3>] sys_sendto+0xe3/0x100
[<de8ed3ab>] ct_receive+0x2ab/0x7c0[zaptel]
[<c01522d6>] __handle_mm_fault+0xf6/0x170
[<c02ac9b6>] copy_from_user+0x46/0x90
[<c04128f5>] sys_socketcall+0x1b5/0x280
[<c0103155>] syscall_call+0x7/0xb
code: 00 00 89 5e 14 c7 44 24 08 08 00 00 00 8b 6c 24 0c 85 ed 74 3e 83 ff 03 19
c0 83 e0 f8 ff 44 06 30 89 c3 86 54 24 10 8b 7c 1e 30 <8b> 42 20 0f b7 50 02 89
d0 c1 ea 08 c1 e0 08 09 b0 0f b7 c0 03
<0> kernel panic - not syncing: fatal exception in interrupt


------=_Part_2478_19853498.1136320640272--
