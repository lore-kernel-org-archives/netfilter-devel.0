From: "ultraice" <it@easy-boarding.com>
Subject: Re: This netlink socket error, atteched the souce ,who can help me
Date: Tue, 20 May 2003 14:19:34 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19I0TM-0001LM-00@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/alternative;
      boundary="=====002_Dragon403682403783_====="
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?GB2312?Q?=B8=DF=B7=E5@=CD=F8=D2=D7?= <zpeak@163.com>,
 netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
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

--=====002_Dragon403682403783_=====
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable

=B8=DF=B7=E5@=CD=F8=D2=D7=A3=AC=C4=FA=BA=C3=A3=A1 

=A1=A1=A1=A1=CE=D2=B6=D4linux=C4=DA=BA=CB=D2=B2=BA=DC=B8=D0=D0=CB=C8=A4=A3=AC=B2=BB=D6=AA=C4=E3=D7=F6=CA=B2=C3=B4=B9=A4=D7=F7=C4=D8=A3=AC=CA=C7=B2=BB=CA=C7=D7=F6linux=CF=E0=B9=
=D8=B5=C4=BF=AA=B7=A2=B0=A1=A3=BF

=3D=3D=3D=3D=3D=3D=3D=3D 2003-05-13 11:58:00 =C4=FA=D4=DA=C0=B4=D0=C5=D6=D0=D0=B4=B5=C0=A3=BA =3D=3D=3D=3D=3D=3D=3D=3D

>    unable to handle kernel NULL pointer dereference at virtual=
 address
>    000004a0
>     printing eip:
>    c689a16e
>    *pde =3D 00000000
>    Oops: 0000
>    myfirewall ipt_MASQUERADE iptable_nat ip_conntrack autofs=
 pcnet32 mii
>    ipt_REJE
>    CPU:    0
>    EIP:    0010:[<c689a16e>]    Tainted: P
>    EFLAGS: 00000296
>     
>    EIP is at fini [myfirewall] 0x1e (2.4.18-14)
>    eax: 00000000   ebx: c689a000   ecx: c0305480   edx:=
 c03861a8
>    esi: fffffff0   edi: 00000000   ebp: c3387f8c   esp:=
 c3387f78
>    ds: 0018   es: 0018   ss: 0018
>    Process rmmod (pid: 1033, stackpage=3Dc3387000)
>    Stack: 0000001d c0305480 c1038030 c03054dc 00000203 bfffeb18=
 c011ce2a
>    c689a000
>           c689a000 fffffff0 c32eb000 c011c1a7 c689a000 00000000=
 00001000
>    c3386000
>           00000001 08073ad8 c010910f bffffc9a bffffba4 0805cb7e=
 00000001
>    08073ad8
>    Call Trace: [<c011ce2a>] free_module [kernel] 0xba=
 (0xc3387f90))
>    [<c011c1a7>] sys_delete_module [kernel] 0xa7 (0xc3387fa4))
>    [<c010910f>] system_call [kernel] 0x33 (0xc3387fc0))
>     

>    Code: ff b0 a0 04 00 00 e8 37 ed 94 f9 83 c4 10 c9 c3 55 89=
 e5 83
>     ./k: line 1:  1033 Segmentation fault      rmmod=
 myfirewall

 
 
-----------------------------------------------------------------=
------------------
-------------------------------------------------------
#ifndef __KERNEL__
#define __KERNEL__
#endif

#ifndef MODULE
#define MODULE
#endif
#ifndef NETLINK_MYLOG
#define NETLINK_MYLOG   9 
#endif 

#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <linux/socket.h>
#include <linux/netlink.h>
#include <linux/config.h>
#include <linux/ip.h>
#include <linux/mm.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/spinlock.h>
#include <asm-i386/segment.h>
#include <asm-i386/uaccess.h>
#include <linux/netfilter_ipv4.h>
#include <linux/sched.h>
#include <net/sock.h>
#include <linux/bitops.h>
#include <linux/netfilter_ipv4/ip_tables.h>
static struct sock *nfmylog ;

static size_t qlen ;
#define BUFFERSIZE 65535 
static void  mylog_send(struct sk_buff* skb)
{
  netlink_broadcast(nfmylog,skb,0,~0,GFP_ATOMIC) ;
}

static unsigned int myfirewall(unsigned int hooknum,struct=
 sk_buff **skb,
  const struct net_device *in,
  const struct net_device *out,int (*okfn)(struct sk_buff*))
{
 struct sk_buff *newskb ;
 int len ;
 len =3D (*skb)->truesize ;

 newskb =3D alloc_skb(len,GFP_ATOMIC);
 if(!newskb) {
  printk("can't alloc whole buffer \n");
 }

 newskb =3D skb_copy(*skb,GFP_ATOMIC);

 netlink_broadcast(nfmylog,skb,0 , ~0,GFP_ATOMIC) ;
 kfree_skb(newskb) ;
 
 return NF_ACCEPT;
}

static struct nf_hook_ops iplimitfilter=3D
{
 {NULL,NULL},
 myfirewall,
 PF_INET,
 NF_IP_PRE_ROUTING,
 NF_IP_PRI_FILTER
};

int  init_module(void)
{
 nfmylog =3D netlink_kernel_create(NETLINK_MYLOG,NULL);
 return nf_register_hook(&iplimitfilter);
}

static  void  cleanup_module(void)
{ 
 nf_unregister_hook(&iplimitfilter);
 sock_release(nfmylog->socket);
}




=3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D 
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=D6=C2
=C0=F1=A3=A1

=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1ultraice
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1it@easy-boarding.com
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-05-20

--=====002_Dragon403682403783_=====
Content-Type: text/html;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Dgb2312"=
 http-equiv=3DContent-Type>
<META content=3D"MSHTML 5.00.2920.0" name=3DGENERATOR></HEAD>
<BODY bgColor=3D#eaeaea><FONT size=3D2><FONT=
 face=3D=CB=CE=CC=E5>=B8=DF=B7=E5@=CD=F8=D2=D7=A3=AC=C4=FA=BA=C3=A3=A1</FONT> </FONT>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D=CB=CE=CC=E5 
size=3D2>=A1=A1=A1=A1=CE=D2=B6=D4linux=C4=DA=BA=CB=D2=B2=BA=DC=B8=D0=D0=CB=C8=A4=A3=AC=B2=BB=D6=AA=C4=E3=D7=F6=CA=B2=C3=B4=B9=A4=D7=F7=C4=D8=A3=AC=CA=C7=B2=BB=CA=C7=D7=F6l=
inux=CF=E0=B9=D8=B5=C4=BF=AA=B7=A2=B0=A1=A3=BF</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D=CB=CE=CC=E5 size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=
 2003-05-13&nbsp;11:58:00&nbsp;=C4=FA=D4=DA=C0=B4=D0=C5=D6=D0=D0=B4=B5=C0=A3=BA 
=3D=3D=3D=3D=3D=3D=3D=3D</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>
<TABLE width=3D"100%">
  <TBODY>
  <TR>
    <TD width=3D"100%">
      <BLOCKQUOTE 
      style=3D"BORDER-LEFT: #000000 2px solid; MARGIN-LEFT: 5px;=
 MARGIN-RIGHT: 0px; PADDING-LEFT: 5px; PADDING-RIGHT: 0px">
        <DIV>&gt;&nbsp;&nbsp;&nbsp; unable to handle kernel NULL=
 pointer 
        dereference at virtual address<BR>&gt;&nbsp;&nbsp;&nbsp;=
 
        000004a0<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp; printing 
        eip:<BR>&gt;&nbsp;&nbsp;&nbsp;=
 c689a16e<BR>&gt;&nbsp;&nbsp;&nbsp; *pde =3D 
        00000000<BR>&gt;&nbsp;&nbsp;&nbsp; Oops:=
 0000<BR>&gt;&nbsp;&nbsp;&nbsp; 
        myfirewall ipt_MASQUERADE iptable_nat ip_conntrack autofs=
 pcnet32 
        mii<BR>&gt;&nbsp;&nbsp;&nbsp;=
 ipt_REJE<BR>&gt;&nbsp;&nbsp;&nbsp; 
        CPU:&nbsp;&nbsp;&nbsp; 0<BR>&gt;&nbsp;&nbsp;&nbsp; 
        EIP:&nbsp;&nbsp;&nbsp;=
 0010:[&lt;c689a16e&gt;]&nbsp;&nbsp;&nbsp; 
        Tainted: P<BR>&gt;&nbsp;&nbsp;&nbsp; EFLAGS: 
        00000296<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp;=
 <BR>&gt;&nbsp;&nbsp;&nbsp; EIP 
        is at fini [myfirewall] 0x1e=
 (2.4.18-14)<BR>&gt;&nbsp;&nbsp;&nbsp; eax: 
        00000000&nbsp;&nbsp; ebx: c689a000&nbsp;&nbsp; ecx:=
 c0305480&nbsp;&nbsp; 
        edx: c03861a8<BR>&gt;&nbsp;&nbsp;&nbsp; esi:=
 fffffff0&nbsp;&nbsp; edi: 
        00000000&nbsp;&nbsp; ebp: c3387f8c&nbsp;&nbsp; esp: 
        c3387f78<BR>&gt;&nbsp;&nbsp;&nbsp; ds: 0018&nbsp;&nbsp;=
 es: 
        0018&nbsp;&nbsp; ss: 0018<BR>&gt;&nbsp;&nbsp;&nbsp;=
 Process rmmod (pid: 
        1033, stackpage=3Dc3387000)<BR>&gt;&nbsp;&nbsp;&nbsp;=
 Stack: 0000001d 
        c0305480 c1038030 c03054dc 00000203 bfffeb18 
        c011ce2a<BR>&gt;&nbsp;&nbsp;&nbsp; 
       =
 c689a000<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; 
        c689a000 fffffff0 c32eb000 c011c1a7 c689a000 00000000 
        00001000<BR>&gt;&nbsp;&nbsp;&nbsp; 
       =
 c3386000<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; 
        00000001 08073ad8 c010910f bffffc9a bffffba4 0805cb7e 
        00000001<BR>&gt;&nbsp;&nbsp;&nbsp;=
 08073ad8<BR>&gt;&nbsp;&nbsp;&nbsp; 
        Call Trace: [&lt;c011ce2a&gt;] free_module [kernel] 0xba=
 
        (0xc3387f90))<BR>&gt;&nbsp;&nbsp;&nbsp;=
 [&lt;c011c1a7&gt;] 
        sys_delete_module [kernel] 0xa7=
 (0xc3387fa4))<BR>&gt;&nbsp;&nbsp;&nbsp; 
        [&lt;c010910f&gt;] system_call [kernel] 0x33 
        (0xc3387fc0))<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp; 
        <BR><BR>&gt;&nbsp;&nbsp;&nbsp; Code: ff b0 a0 04 00 00 e8=
 37 ed 94 f9 83 
        c4 10 c9 c3 55 89 e5 83<BR>&gt;&nbsp;&nbsp;&nbsp;&nbsp;=
 ./k: line 
        1:&nbsp; 1033 Segmentation=
 fault&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rmmod 
        myfirewall</DIV>
        <DIV>&nbsp;</DIV>
        <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
        <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
        <DIV><FONT 
       =
 size=3D2>---------------------------------------------------------=
--------------------------</FONT></DIV>
       =
 <DIV>-------------------------------------------------------<BR>=
#ifndef 
        __KERNEL__<BR>#define __KERNEL__<BR>#endif<BR><BR>#ifndef=
 
        MODULE<BR>#define MODULE<BR>#endif<BR>#ifndef=
 NETLINK_MYLOG<BR>#define 
        NETLINK_MYLOG&nbsp;&nbsp; 9 <BR>#endif <BR><BR>#include 
        &lt;linux/module.h&gt;<BR>#include=
 &lt;linux/skbuff.h&gt;<BR>#include 
        &lt;linux/netdevice.h&gt;<BR>#include=
 &lt;linux/socket.h&gt;<BR>#include 
        &lt;linux/netlink.h&gt;<BR>#include=
 &lt;linux/config.h&gt;<BR>#include 
        &lt;linux/ip.h&gt;<BR>#include=
 &lt;linux/mm.h&gt;<BR>#include 
        &lt;linux/tcp.h&gt;<BR>#include=
 &lt;linux/udp.h&gt;<BR>#include 
        &lt;linux/spinlock.h&gt;<BR>#include 
        &lt;asm-i386/segment.h&gt;<BR>#include 
        &lt;asm-i386/uaccess.h&gt;<BR>#include 
        &lt;linux/netfilter_ipv4.h&gt;<BR>#include 
        &lt;linux/sched.h&gt;<BR>#include=
 &lt;net/sock.h&gt;<BR>#include 
        &lt;linux/bitops.h&gt;<BR>#include 
        &lt;linux/netfilter_ipv4/ip_tables.h&gt;<BR>static struct=
 sock *nfmylog 
        ;<BR><BR>static size_t qlen ;<BR>#define BUFFERSIZE 65535=
 <BR>static 
        void&nbsp; mylog_send(struct sk_buff* skb)<BR>{<BR>&nbsp;=
 
        netlink_broadcast(nfmylog,skb,0,~0,GFP_ATOMIC)=
 ;<BR>}<BR><BR>static 
        unsigned int myfirewall(unsigned int hooknum,struct=
 sk_buff 
        **skb,<BR>&nbsp; const struct net_device *in,<BR>&nbsp;=
 const struct 
        net_device *out,int (*okfn)(struct=
 sk_buff*))<BR>{<BR>&nbsp;struct 
        sk_buff *newskb ;<BR>&nbsp;int len ;<BR>&nbsp;len =3D=
 (*skb)-&gt;truesize 
        ;<BR><BR>&nbsp;newskb =3D=
 alloc_skb(len,GFP_ATOMIC);<BR>&nbsp;if(!newskb) 
        {<BR>&nbsp; printk("can't alloc whole buffer 
        \n");<BR>&nbsp;}<BR><BR>&nbsp;newskb =3D 
       =
 skb_copy(*skb,GFP_ATOMIC);<BR><BR>&nbsp;netlink_broadcast(nfmylo=
g,skb,0 
        , ~0,GFP_ATOMIC) ;<BR>&nbsp;kfree_skb(newskb) 
        ;<BR>&nbsp;<BR>&nbsp;return NF_ACCEPT;<BR>}<BR><BR>static=
 struct 
        nf_hook_ops 
       =
 iplimitfilter=3D<BR>{<BR>&nbsp;{NULL,NULL},<BR>&nbsp;myfirewall,<B=
R>&nbsp;PF_INET,<BR>&nbsp;NF_IP_PRE_ROUTING,<BR>&nbsp;NF_IP_PRI_F=
ILTER<BR>};<BR><BR>int&nbsp; 
        init_module(void)<BR>{<BR>&nbsp;nfmylog =3D 
       =
 netlink_kernel_create(NETLINK_MYLOG,NULL);<BR>&nbsp;return 
       =
 nf_register_hook(&amp;iplimitfilter);<BR>}<BR><BR>static&nbsp; 
        void&nbsp; cleanup_module(void)<BR>{ 
       =
 <BR>&nbsp;nf_unregister_hook(&amp;iplimitfilter);<BR>&nbsp;sock_=
release(nfmylog-&gt;socket);<BR>}<BR><BR><BR></DIV></BLOCKQUOTE><=
/TD></TR></TBODY></TABLE></FONT></DIV>
<DIV>
<P><FONT face=3D=CB=CE=CC=E5 size=3D2>=3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D =3D=
 =3D =3D </FONT></P>
<P><FONT face=3D=CB=CE=CC=E5 size=3D2>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=D6=C2<BR>=C0=F1=A3=A1</FONT></P>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D=CB=CE=CC=E5=
 size=3D2>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1ultraice</FONT></DIV>
<DIV><FONT face=3D=CB=CE=CC=E5 size=3D2><FONT face=3D=CB=CE=CC=E5=
 size=3D2>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1</FONT><A 
href=3D"mailto:it@easy-boarding.com">it@easy-boarding.com</A></FONT=
></DIV>
<DIV><FONT face=3D=CB=CE=CC=E5=
 size=3D2>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-05-20</FONT></DIV>=

<DIV>&nbsp;</DIV></DIV></BODY></HTML>

--=====002_Dragon403682403783_=====--
