From: "Colin Cyrille" <engp2437@nus.edu.sg>
Subject: RE: A libipq program error . It seems link error,
Date: Tue, 20 May 2003 12:15:29 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6330DC96389A924A804F52FA3848930E88A8C9@MBXSRV26.stu.nus.edu.sg>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C31E86.7267BD1A"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "??@??" <zpeak@163.com>
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

------_=_NextPart_001_01C31E86.7267BD1A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

i had the same problem some times ago. try 'gcc testLIbipq.c -l ipq'


	-----Original Message-----
	From: zpeak@163.com [mailto:zpeak@163.com]=20
	Sent: Friday, May 16, 2003 11:14 AM
	To: netfilter-devel@lists.netfilter.org
	Cc: netfilter-devel@lists.netfilter.org
	Subject: Fw: A libipq program error . It seems link error,=20
=09
=09
	I have update the iptables from 1.2.6a to 1.2.8  =20
	 use the next command=20
	       make  jxvf iptables1.2.8.tar.tar
	       make  install KERNEL_DIR=3D/usr/src/linux
	       make  install-devel KERNEL_DIR=3D/usr/src/linux=20
	=20
	i use the command iptables ,it appears it has been updated to
1.2.8
	=20
	But i use a program test libipq ,it is occored the next error
,Who can tell me the reasons.
	=20
	ot@zhaopeng test]# gcc testLIbipq.c
	/tmp/ccwmXAsQ.o: In function `die':
	/tmp/ccwmXAsQ.o(.text+0xf): undefined reference to `ipq_perror'
	/tmp/ccwmXAsQ.o(.text+0x1d): undefined reference to
`ipq_destroy_handle'
	/tmp/ccwmXAsQ.o: In function `main':
	/tmp/ccwmXAsQ.o(.text+0x49): undefined reference to
`ipq_create_handle'
	/tmp/ccwmXAsQ.o(.text+0x81): undefined reference to
`ipq_set_mode'
	/tmp/ccwmXAsQ.o(.text+0xb8): undefined reference to `ipq_read'
	/tmp/ccwmXAsQ.o(.text+0xe4): undefined reference to
`ipq_message_type'
	/tmp/ccwmXAsQ.o(.text+0x116): undefined reference to
`ipq_get_msgerr'
	/tmp/ccwmXAsQ.o(.text+0x141): undefined reference to
`ipq_get_packet'
	/tmp/ccwmXAsQ.o(.text+0x166): undefined reference to
`ipq_set_verdict'
	collect2: ld returned 1 exit status
	=20
	=20
	The source is =20
=09
----------------------------------------------------------------------
	/*
	 * This code is GPL.
	 */
	#include <linux/netfilter.h
<file:///usr/include/linux/netfilter.h> >
	#include <libipq.h <file:///usr/include/libipq.h> >
	#include <stdio.h <file:///usr/include/stdio.h> >
=09
	#define BUFSIZE 2048=20
=09
	static void die(struct ipq_handle *h)
	{
	        ipq_perror("passer");
	        ipq_destroy_handle(h);
	        exit <http://localhost/cgi-bin/man/man2html?1+exit> (1);
	}
=09
	int main(int argc, char **argv)
	{
	        int status;
	        unsigned char buf[BUFSIZE];
	        struct ipq_handle *h;
	       =20
	        h =3D ipq_create_handle(0, PF_INET);
	        if (!h)
	                die(h);
	               =20
	        status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
	        if (status < 0)
	                die(h);
	               =20
	        do{
	                status =3D ipq_read(h, buf, BUFSIZE, 0);
	                if (status < 0)
	                        die(h);
	                       =20
	                switch (ipq_message_type(buf)) {
	                        case NLMSG_ERROR:
	                                fprintf(stderr, "Received error
message %d\n",
	                                        ipq_get_msgerr(buf));
	                                break;
	                               =20
	                        case IPQM_PACKET: {
	                                ipq_packet_msg_t *m =3D
ipq_get_packet(buf);
	                               =20
	                                status =3D ipq_set_verdict(h,
m->packet_id,
=09
NF_ACCEPT, 0, NULL);
	                                if (status < 0)
	                                        die(h);
	                                break;
	                        }
	                       =20
	                        default:
	                                fprintf(stderr, "Unknown message
type!\n");
	                                break;
	                }
	        } while (1);
	       =20
	        ipq_destroy_handle(h);
	        return 0;
	}
	=20


------_=_NextPart_001_01C31E86.7267BD1A
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Message</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2800.1141" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><SPAN class=3D063331404-20052003><FONT face=3DArial color=3D#0000ff =
size=3D2>i had=20
the same problem some times ago. try <FONT color=3D#000000>'gcc =
testLIbipq.c -l=20
ipq'</FONT><BR></FONT></SPAN></DIV>
<BLOCKQUOTE dir=3Dltr style=3D"MARGIN-RIGHT: 0px">
  <DIV></DIV>
  <DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr =
align=3Dleft><FONT=20
  face=3DTahoma size=3D2>-----Original Message-----<BR><B>From:</B> =
zpeak@163.com=20
  [mailto:zpeak@163.com] <BR><B>Sent:</B> Friday, May 16, 2003 11:14=20
  AM<BR><B>To:</B> netfilter-devel@lists.netfilter.org<BR><B>Cc:</B>=20
  netfilter-devel@lists.netfilter.org<BR><B>Subject:</B> Fw: A libipq =
program=20
  error . It seems link error, <BR><BR></FONT></DIV>
  <DIV><FONT size=3D2>I have update the iptables from 1.2.6a to =
1.2.8&nbsp;&nbsp;=20
  </FONT></DIV>
  <DIV><FONT size=3D2>&nbsp;use the next command </FONT></DIV>
  <DIV><FONT =
size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;make&nbsp; jxvf=20
  iptables1.2.8.tar.tar</FONT></DIV>
  <DIV><FONT size=3D2>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;make&nbsp; =
install=20
  KERNEL_DIR=3D/usr/src/linux</FONT></DIV>
  <DIV><FONT size=3D2>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;make&nbsp;=20
  install-devel KERNEL_DIR=3D/usr/src/linux </FONT></DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
  <DIV><FONT size=3D2>i use the command iptables ,it appears it has been =
updated=20
  to 1.2.8</FONT></DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
  <DIV><FONT size=3D2>But i use a program test libipq ,it is occored the =
next=20
  error ,Who can tell me the reasons.</FONT></DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
  <DIV><FONT size=3D2><A href=3D"mailto:ot@zhaopeng">ot@zhaopeng</A> =
test]# gcc=20
  testLIbipq.c<BR>/tmp/ccwmXAsQ.o: In function=20
  `die':<BR>/tmp/ccwmXAsQ.o(.text+0xf): undefined reference to=20
  `ipq_perror'<BR>/tmp/ccwmXAsQ.o(.text+0x1d): undefined reference to=20
  `ipq_destroy_handle'<BR>/tmp/ccwmXAsQ.o: In function=20
  `main':<BR>/tmp/ccwmXAsQ.o(.text+0x49): undefined reference to=20
  `ipq_create_handle'<BR>/tmp/ccwmXAsQ.o(.text+0x81): undefined =
reference to=20
  `ipq_set_mode'<BR>/tmp/ccwmXAsQ.o(.text+0xb8): undefined reference to=20
  `ipq_read'<BR>/tmp/ccwmXAsQ.o(.text+0xe4): undefined reference to=20
  `ipq_message_type'<BR>/tmp/ccwmXAsQ.o(.text+0x116): undefined =
reference to=20
  `ipq_get_msgerr'<BR>/tmp/ccwmXAsQ.o(.text+0x141): undefined reference =
to=20
  `ipq_get_packet'<BR>/tmp/ccwmXAsQ.o(.text+0x166): undefined reference =
to=20
  `ipq_set_verdict'<BR>collect2: ld returned 1 exit status</FONT></DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV>
  <DIV><FONT size=3D2>The source is&nbsp; </FONT></DIV>
  <DIV><FONT=20
  =
size=3D2>----------------------------------------------------------------=
------</FONT></DIV>
  <DIV><PRE>/*
 * This code is GPL.
 */
#include &lt;<A =
href=3D"file:///usr/include/linux/netfilter.h">linux/netfilter.h</A>&gt;
#include &lt;<A href=3D"file:///usr/include/libipq.h">libipq.h</A>&gt;
#include &lt;<A href=3D"file:///usr/include/stdio.h">stdio.h</A>&gt;

#define BUFSIZE 2048=20

static void die(struct ipq_handle *h)
{
        ipq_perror("passer");
        ipq_destroy_handle(h);
        <A =
href=3D"http://localhost/cgi-bin/man/man2html?1+exit">exit</A>(1);
}

int main(int argc, char **argv)
{
        int status;
        unsigned char buf[BUFSIZE];
        struct ipq_handle *h;
       =20
        h =3D ipq_create_handle(0, PF_INET);
        if (!h)
                die(h);
               =20
        status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
        if (status &lt; 0)
                die(h);
               =20
        do{
                status =3D ipq_read(h, buf, BUFSIZE, 0);
                if (status &lt; 0)
                        die(h);
                       =20
                switch (ipq_message_type(buf)) {
                        case NLMSG_ERROR:
                                fprintf(stderr, "Received error message =
%d\n",
                                        ipq_get_msgerr(buf));
                                break;
                               =20
                        case IPQM_PACKET: {
                                ipq_packet_msg_t *m =3D =
ipq_get_packet(buf);
                               =20
                                status =3D ipq_set_verdict(h, =
m-&gt;packet_id,
                                                         NF_ACCEPT, 0, =
NULL);
                                if (status &lt; 0)
                                        die(h);
                                break;
                        }
                       =20
                        default:
                                fprintf(stderr, "Unknown message =
type!\n");
                                break;
                }
        } while (1);
       =20
        ipq_destroy_handle(h);
        return 0;
}
</PRE></DIV>
  <DIV><FONT size=3D2></FONT>&nbsp;</DIV></BLOCKQUOTE></BODY></HTML>
=00
------_=_NextPart_001_01C31E86.7267BD1A--
