From: "Peter Olsson" <aa@tbh.se>
Subject: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Tue, 15 Jun 2004 09:40:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002401c452ac$06523580$7c01a8c0@std.visionutv.se>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0021_01C452BC.C9D4EB00"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0021_01C452BC.C9D4EB00
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

After running my firewall without any problems for about 90 days, I =
suddenly got a Kernel Oops.
When running it through ksymoops I received the result below.

I've read a few comments about a bug in the newnat code in =
unexpect_related, but what I can see
this should be fixed a long time ago, and if I compare the =
unexpect_related calls in the ip_conntrack_core.c
from version 2.4.25 til 2.4.26 they work in exactly the same way. Could =
there be something else causing
this problem? I don't think it's hardware related, I've been using the =
same hardware, but with kernel 2.4.27
for about a year before this happened, and it's been working really =
good.

Best regards,

Peter Olsson

----

ksymoops on i686 2.4.25.  Options used
     -V (specified)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.25/ (default)
     -m /boot/System.map-2.4.25 (default)

Unable to handle kernel NULL pointer dereference at virtual address =
00000004 printing eip:
c026f410
*pde =3D 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<c026f410>]  Tainted: P
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: 00000000   ebx: e1499a80     ecx: e1499a8c       edx: 00000000
esi: f7c34b8c   edi: f7c34b80     ebp: c2477380       esp: c036bcfc
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=3Dc036b000)
Stack: 00000000 f7dd1000 e1499a80 c036a000 c036a000 c0271bc0 e1499a80 =
e1499a80
       c0272ee0 e1499a80 e1499a80 e6c9c500 f7c34b80 f7c34bc0 00000000 =
c02704fd
       e6c9c500 c9648c80 cd6dd2d9 00000001 f7c34b80 c036bddc e6c9c500 =
020749d4
Call Trace:    [<c0271bc0>] [<c0272ee0>] [<c02704fd>] [<c027067c>] =
[<c022fac6>]
  [<c023d148>] [<c023be60>] [<c022f75e>] [<c023be60>] [<c023be60>] =
[<c022fa8f>]
  [<c023be60>] [<c023bce6>] [<c023be60>] [<c0227889>] [<c0222fbf>] =
[<c0227889>]
  [<c0227985>] [<f99a5f68>] [<c0227adf>] [<c011dafb>] [<c0108bad>] =
[<c01052c0>]
  [<c01052c0>] [<c01052c0>] [<c01052c0>] [<c01052e9>] [<c0105372>] =
[<c0105000>]
Code: 89 50 04 89 02 8b 43 0c c7 03 00 00 00 00 c7 43 04 00 00 00

>>EIP; c026f410 <__unexpect_related+10/60>   <=3D=3D=3D=3D=3D
Trace; c0271bc0 <ip_conntrack_unexpect_related+30/70>
Trace; c0272ee0 <pptp_expectfn+90/b0>
Trace; c02704fd <init_conntrack+40d/420>
Trace; c027067c <ip_conntrack_in+16c/2a0>
Trace; c022fac6 <nf_hook_slow+106/180>
Trace; c023d148 <ip_forward+1f8/260>
Trace; c023be60 <ip_rcv_finish+0/20f>
Trace; c022f75e <nf_iterate+2e/80>
Trace; c023be60 <ip_rcv_finish+0/20f>
Trace; c023be60 <ip_rcv_finish+0/20f>
Trace; c022fa8f <nf_hook_slow+cf/180>
Trace; c023be60 <ip_rcv_finish+0/20f>
Trace; c023bce6 <ip_rcv+3a6/3f0>
Trace; c023be60 <ip_rcv_finish+0/20f>
Trace; c0227889 <netif_receive_skb+189/1c0>
Trace; c0222fbf <alloc_skb+ef/1c0>
Trace; c0227889 <netif_receive_skb+189/1c0>
Trace; c0227985 <process_backlog+c5/180>
Trace; f99a5f68 <[tg3]tg3_poll+f8/110>
Trace; c0227adf <net_rx_action+9f/160>
Trace; c011dafb <do_softirq+6b/d0>
Trace; c0108bad <do_IRQ+dd/f0>
Trace; c01052c0 <default_idle+0/40>
Trace; c01052c0 <default_idle+0/40>
Trace; c01052c0 <default_idle+0/40>
Trace; c01052c0 <default_idle+0/40>
Trace; c01052e9 <default_idle+29/40>
Trace; c0105372 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>
Code;  c026f410 <__unexpect_related+10/60>
00000000 <_EIP>:
Code;  c026f410 <__unexpect_related+10/60>   <=3D=3D=3D=3D=3D
   0:   89 50 04                  mov    %edx,0x4(%eax)   =
<=3D=3D=3D=3D=3D
Code;  c026f413 <__unexpect_related+13/60>
   3:   89 02                     mov    %eax,(%edx)
Code;  c026f415 <__unexpect_related+15/60>
   5:   8b 43 0c                  mov    0xc(%ebx),%eax
Code;  c026f418 <__unexpect_related+18/60>
   8:   c7 03 00 00 00 00         movl   $0x0,(%ebx)
Code;  c026f41e <__unexpect_related+1e/60>
   e:   c7 43 04 00 00 00 00      movl   $0x0,0x4(%ebx)

 <0>Kernel panic: Aiee, killing interrupt handler!

----

This is the actual __unexpect_related code in my ip_contrack_core.c:

static void __unexpect_related(struct ip_conntrack_expect *expect)
{
        DEBUGP("unexpect_related(%p)\n", expect);
        MUST_BE_WRITE_LOCKED(&ip_conntrack_lock); =20

        /* we're not allowed to unexpect a confirmed expectation! */
        IP_NF_ASSERT(!expect->sibling);

        /* delete from global and local lists */
        list_del(&expect->list);
        list_del(&expect->expected_list);

        /* decrement expect-count of master conntrack */
        if (expect->expectant)
                expect->expectant->expecting--;

        ip_conntrack_expect_put(expect);
}

------=_NextPart_000_0021_01C452BC.C9D4EB00
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>After running my firewall without any =
problems for=20
about 90 days, I suddenly got a Kernel Oops.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>When running it through ksymoops I =
received the=20
result below.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I've read a few comments about a bug in =
the newnat=20
code in unexpect_related, but what I can see</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>this should be fixed a long time ago, =
and if I=20
compare the unexpect_related calls in the =
ip_conntrack_core.c</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>from version 2.4.25 til 2.4.26 they =
work in exactly=20
the same way. Could there be something else causing</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>this problem? I don't think it's =
hardware related,=20
I've been using the same hardware, but with kernel 2.4.27</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>for about a year before this happened, =
and it's=20
been working really good.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Best regards,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Peter Olsson</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>----</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>ksymoops on i686 2.4.25.&nbsp; Options=20
used<BR>&nbsp;&nbsp;&nbsp;&nbsp; -V =
(specified)<BR>&nbsp;&nbsp;&nbsp;&nbsp; -k=20
/proc/ksyms (default)<BR>&nbsp;&nbsp;&nbsp;&nbsp; -l /proc/modules=20
(default)<BR>&nbsp;&nbsp;&nbsp;&nbsp; -o /lib/modules/2.4.25/=20
(default)<BR>&nbsp;&nbsp;&nbsp;&nbsp; -m /boot/System.map-2.4.25=20
(default)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Unable to handle kernel NULL pointer =
dereference at=20
virtual address 00000004 printing eip:<BR>c026f410<BR>*pde =3D =
00000000<BR>Oops:=20
0002<BR>CPU:&nbsp;&nbsp;&nbsp; 0<BR>EIP:&nbsp;&nbsp;&nbsp;=20
0010:[&lt;c026f410&gt;]&nbsp; Tainted: P<BR>Using defaults from ksymoops =
-t=20
elf32-i386 -a i386<BR>EFLAGS: 00010286<BR>eax: 00000000&nbsp;&nbsp; ebx: =

e1499a80&nbsp;&nbsp;&nbsp;&nbsp; ecx:=20
e1499a8c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; edx: 00000000<BR>esi:=20
f7c34b8c&nbsp;&nbsp; edi: f7c34b80&nbsp;&nbsp;&nbsp;&nbsp; ebp:=20
c2477380&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; esp: c036bcfc<BR>ds:=20
0018&nbsp;&nbsp; es: 0018&nbsp;&nbsp; ss: 0018<BR>Process swapper (pid: =
0,=20
stackpage=3Dc036b000)<BR>Stack: 00000000 f7dd1000 e1499a80 c036a000 =
c036a000=20
c0271bc0 e1499a80 e1499a80<BR></FONT><FONT face=3DArial=20
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c0272ee0 e1499a80 e1499a80 =
e6c9c500=20
f7c34b80 f7c34bc0 00000000 =
c02704fd<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
e6c9c500 c9648c80 cd6dd2d9 00000001 f7c34b80 c036bddc e6c9c500 =
020749d4<BR>Call=20
Trace:&nbsp;&nbsp;&nbsp; [&lt;c0271bc0&gt;] [&lt;c0272ee0&gt;]=20
[&lt;c02704fd&gt;] [&lt;c027067c&gt;] [&lt;c022fac6&gt;]<BR>&nbsp;=20
[&lt;c023d148&gt;] [&lt;c023be60&gt;] [&lt;c022f75e&gt;] =
[&lt;c023be60&gt;]=20
[&lt;c023be60&gt;] [&lt;c022fa8f&gt;]<BR>&nbsp; [&lt;c023be60&gt;]=20
[&lt;c023bce6&gt;] [&lt;c023be60&gt;] [&lt;c0227889&gt;] =
[&lt;c0222fbf&gt;]=20
[&lt;c0227889&gt;]<BR>&nbsp; [&lt;c0227985&gt;] [&lt;f99a5f68&gt;]=20
[&lt;c0227adf&gt;] [&lt;c011dafb&gt;] [&lt;c0108bad&gt;]=20
[&lt;c01052c0&gt;]<BR>&nbsp; [&lt;c01052c0&gt;] [&lt;c01052c0&gt;]=20
[&lt;c01052c0&gt;] [&lt;c01052e9&gt;] [&lt;c0105372&gt;]=20
[&lt;c0105000&gt;]<BR>Code: 89 50 04 89 02 8b 43 0c c7 03 00 00 00 00 c7 =
43 04=20
00 00 00</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&gt;&gt;EIP; c026f410=20
&lt;__unexpect_related+10/60&gt;&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D<BR>Trace; c0271bc0=20
&lt;ip_conntrack_unexpect_related+30/70&gt;<BR>Trace; c0272ee0=20
&lt;pptp_expectfn+90/b0&gt;<BR>Trace; c02704fd=20
&lt;init_conntrack+40d/420&gt;<BR>Trace; c027067c=20
&lt;ip_conntrack_in+16c/2a0&gt;<BR>Trace; c022fac6=20
&lt;nf_hook_slow+106/180&gt;<BR>Trace; c023d148=20
&lt;ip_forward+1f8/260&gt;<BR>Trace; c023be60=20
&lt;ip_rcv_finish+0/20f&gt;<BR>Trace; c022f75e=20
&lt;nf_iterate+2e/80&gt;<BR>Trace; c023be60=20
&lt;ip_rcv_finish+0/20f&gt;<BR>Trace; c023be60=20
&lt;ip_rcv_finish+0/20f&gt;<BR>Trace; c022fa8f=20
&lt;nf_hook_slow+cf/180&gt;<BR>Trace; c023be60=20
&lt;ip_rcv_finish+0/20f&gt;<BR>Trace; c023bce6 =
&lt;ip_rcv+3a6/3f0&gt;<BR>Trace;=20
c023be60 &lt;ip_rcv_finish+0/20f&gt;<BR>Trace; c0227889=20
&lt;netif_receive_skb+189/1c0&gt;<BR>Trace; c0222fbf=20
&lt;alloc_skb+ef/1c0&gt;<BR>Trace; c0227889=20
&lt;netif_receive_skb+189/1c0&gt;<BR>Trace; c0227985=20
&lt;process_backlog+c5/180&gt;<BR>Trace; f99a5f68=20
&lt;[tg3]tg3_poll+f8/110&gt;<BR>Trace; c0227adf=20
&lt;net_rx_action+9f/160&gt;<BR>Trace; c011dafb=20
&lt;do_softirq+6b/d0&gt;<BR>Trace; c0108bad =
&lt;do_IRQ+dd/f0&gt;<BR>Trace;=20
c01052c0 &lt;default_idle+0/40&gt;<BR>Trace; c01052c0=20
&lt;default_idle+0/40&gt;<BR>Trace; c01052c0 =
&lt;default_idle+0/40&gt;<BR>Trace;=20
c01052c0 &lt;default_idle+0/40&gt;<BR>Trace; c01052e9=20
&lt;default_idle+29/40&gt;<BR>Trace; c0105372 =
&lt;cpu_idle+52/70&gt;<BR>Trace;=20
c0105000 &lt;_stext+0/0&gt;<BR>Code;&nbsp; c026f410=20
&lt;__unexpect_related+10/60&gt;<BR>00000000 =
&lt;_EIP&gt;:<BR>Code;&nbsp;=20
c026f410 &lt;__unexpect_related+10/60&gt;&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D<BR>&nbsp;&nbsp;=20
0:&nbsp;&nbsp; 89 50=20
04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
mov&nbsp;&nbsp;&nbsp; %edx,0x4(%eax)&nbsp;&nbsp; =
&lt;=3D=3D=3D=3D=3D<BR>Code;&nbsp;=20
c026f413 &lt;__unexpect_related+13/60&gt;<BR>&nbsp;&nbsp; 3:&nbsp;&nbsp; =
89=20
02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
mov&nbsp;&nbsp;&nbsp; %eax,(%edx)<BR>Code;&nbsp; c026f415=20
&lt;__unexpect_related+15/60&gt;<BR>&nbsp;&nbsp; 5:&nbsp;&nbsp; 8b 43=20
0c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
mov&nbsp;&nbsp;&nbsp; 0xc(%ebx),%eax<BR>Code;&nbsp; c026f418=20
&lt;__unexpect_related+18/60&gt;<BR>&nbsp;&nbsp; 8:&nbsp;&nbsp; c7 03 00 =
00 00=20
00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; movl&nbsp;&nbsp;=20
$0x0,(%ebx)<BR>Code;&nbsp; c026f41e=20
&lt;__unexpect_related+1e/60&gt;<BR>&nbsp;&nbsp; e:&nbsp;&nbsp; c7 43 04 =
00 00=20
00 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; movl&nbsp;&nbsp; =
$0x0,0x4(%ebx)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&lt;0&gt;Kernel panic: Aiee, =
killing=20
interrupt handler!<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>----</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>This is the actual __unexpect_related =
code in my=20
ip_contrack_core.c:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>static void __unexpect_related(struct=20
ip_conntrack_expect =
*expect)<BR>{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
DEBUGP("unexpect_related(%p)\n",=20
expect);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
MUST_BE_WRITE_LOCKED(&amp;ip_conntrack_lock);&nbsp; </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* we're=20
not allowed to unexpect a confirmed expectation!=20
*/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
IP_NF_ASSERT(!expect-&gt;sibling);</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*=20
delete from global and local lists=20
*/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
list_del(&amp;expect-&gt;list);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;=20
list_del(&amp;expect-&gt;expected_list);</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*=20
decrement expect-count of master conntrack=20
*/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if=20
(expect-&gt;expectant)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
expect-&gt;expectant-&gt;expecting--;</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
ip_conntrack_expect_put(expect);<BR>}</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;</DIV></FONT></BODY></HTML>

------=_NextPart_000_0021_01C452BC.C9D4EB00--
