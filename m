From: "Fangweiwei" <fangweiwei@tom.com>
Subject: some problem with ipq_client.c
Date: Wed, 26 Nov 2003 14:48:49 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1AOtT8-00008X-S5@vishnu.netfilter.org>
Reply-To: fangweiwei@tom.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
      boundary="=====000_Dragon753533688881_====="
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
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

--=====000_Dragon753533688881_=====
Content-Type: multipart/alternative;
      boundary="=====002_Dragon753533688881_====="


--=====002_Dragon753533688881_=====
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable

netfilter-devel=A3=AChi=A3=A1
   To study the libipq, I download the sample code ipq_client.c=
 and compile it with gcc, and then I run it by root in console:
/ipq_client.out  
but it just don't do anything.the cursor just wait and print no=
 information.can you tell me what to do ? thanks a lot!
the code is as following:
-----------------------------------------------------------------=
---------------------------
/*
 * ipq_client.c
 *
 * Simple ipq client for test & development.  If you set=
 dump_payload
 * to 1, you'll probably want to run as ./ipq_client > dump.out
 *
 * At the moment, this code grabs queued packets, mangles the TOS=
 field, 
 * then issues NF_ACCEPT verdicts.  This is to establish that=
 modifying 
 * packets works.
 *
 * TODO: - Make more flexible, use getopts
 *       - Add differential csum
 *       - Add support for more protocols
 *
 * This program is free software; you can redistribute it and/or=
 modify
 * it under the terms of the GNU General Public License as=
 published by
 * the Free Software Foundation; either version 2 of the License,=
 or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be=
 useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty=
 of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */
#include <stdio.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <linux/netfilter.h>
#include <unistd.h>
#include "libipq.h"
#define BUFSIZE 2048 
static void die(struct ipq_handle *h);
static void dump_metadata(ipq_packet_msg_t *m);
static void dump_iphdr(unsigned char *buf);
static u_int16_t csum_partial(void *buffer,
                              unsigned int len, u_int16_t=
 prevsum);
int main(int argc, char **argv)
{ 
 int status;
 unsigned char dump_payload =3D 0;
 unsigned char inbuf[BUFSIZE];
 struct ipq_handle *h;
 int verdict =3D NF_ACCEPT;
 
 h =3D ipq_create_handle(0, PF_INET);
 if (!h)
  die(h);
 status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
 if (status < 0)
  die(h);
 do  {
  status =3D ipq_read(h, inbuf, BUFSIZE, 0);
  if (status < 0)
   die(h);
  switch (ipq_message_type(inbuf)) {
   case NLMSG_ERROR:
    fprintf(stderr, "Received error message %d\n",
     ipq_get_msgerr(inbuf));
    break;
   case IPQM_PACKET: {
    ipq_packet_msg_t *m =3D ipq_get_packet(inbuf);
    unsigned char *packet =3D NULL;
    struct iphdr *iph =3D NULL;
    if (!m)
     break;
    dump_metadata(m);
    if (m->data_len >=3D sizeof(struct iphdr)) {
     packet =3D (unsigned char *)m
              + sizeof(*m);
     dump_iphdr(packet);
    }
    fprintf(stderr, "Sending verdict %d on "
            "packet %lX\n", verdict, m->packet_id);
    iph =3D (struct iphdr *)packet;         
    iph->tos =3D 0x55;
    iph->check =3D 0;
    iph->check =3D ~csum_partial(packet,
                               sizeof(struct iphdr),
                               0);
    status =3D ipq_set_verdict(h,
                             m->packet_id,
                             verdict,
                             m->data_len,
                             packet);
    if (status < 0)
     die(h);
    break;
   }
   default:
    fprintf(stderr, "Unknown message!\n");
    break;
  }
  if (dump_payload)
   write(1, inbuf, status);
 } while (1);
 ipq_destroy_handle(h);
 return 0;
} 
static void die(struct ipq_handle *h)
{
 ipq_perror("ERROR");
 ipq_destroy_handle(h);
 exit(1);
}
static void dump_metadata(ipq_packet_msg_t *m)
{
 if(!m)
  return;
 fprintf(stderr, "Dumping Metadata:\nID=3D0x%08lX MARK=3D0x%08lX=
 TSEC=3D%ld "
         "TUSEC=3D%ld HOOK=3D%u IN=3D%s OUT=3D%s DLEN=3D%d\n",
         m->packet_id,
         m->mark,
         m->timestamp_sec,
         m->timestamp_usec,
         m->hook,
         m->indev_name[0] ? m->indev_name : "[none]",
         m->outdev_name[0] ? m->outdev_name : "[none]",
         m->data_len);
}
/* 
 * This does not handle IP options yet, although it may at some=
 point 
 * in the near future.  Some of this code was stolen from=
 ipt_LOG.c.
 */
static void dump_iphdr(unsigned char *buf)
{
 struct iphdr *iph =3D (struct iphdr *)buf;
 fputs("Dumping IP Header:\n", stderr);
 fprintf(stderr, "VER=3D%u HLEN=3D%u TOS=3D0x%02hX TLEN=3D%u ID=3D%u ",
         iph->version,
         iph->ihl * 4,
         iph->tos, 
         ntohs(iph->tot_len),
         ntohs(iph->id));
 if (ntohs(iph->frag_off) & IP_DF)
  fputs("DF ", stderr);
 if (ntohs(iph->frag_off) & IP_MF)
  fputs("MF ", stderr);
 if (ntohs(iph->frag_off) & 0x1FFF)
  fprintf(stderr, "FRAG=3D%u ",
          (ntohs(iph->frag_off) & 0x1FFF) * 8);
 fprintf(stderr, "TTL=3D%u PROT=3D%u CSUM=3D0x%04X ",
         iph->ttl,
         iph->protocol,
         ntohs(iph->check));
 fprintf(stderr, "SRC=3D%u.%u.%u.%u DST=3D%u.%u.%u.%u\n\n",
         (ntohl(iph->saddr) >> 24) & 0xFF,
         (ntohl(iph->saddr) >> 16) & 0xFF,
         (ntohl(iph->saddr) >> 8) & 0xFF,
         (ntohl(iph->saddr)) & 0xFF,
         (ntohl(iph->daddr) >> 24) & 0xFF,
         (ntohl(iph->daddr) >> 16) & 0xFF,
         (ntohl(iph->daddr) >> 8) & 0xFF,
         (ntohl(iph->daddr)) & 0xFF);
}
/* This is from gen_ip.c */
static u_int16_t csum_partial(void *buffer,
                              unsigned int len, u_int16_t=
 prevsum)
{
 u_int32_t sum =3D 0;
 u_int16_t *ptr =3D buffer;
 
 while (len > 1)  {
  sum +=3D *ptr++;
  len -=3D 2;
 }
 if (len) {
  union {
   u_int8_t byte;
   u_int16_t wyde;
  } odd;
 
  odd.wyde =3D 0;
  odd.byte =3D *((u_int8_t *)ptr);
  sum +=3D odd.wyde;
 }
 sum =3D (sum >> 16) + (sum & 0xFFFF);
 sum +=3D prevsum;
 return (sum + (sum >> 16));
}
-----------------------------------------------------------------=
----------------------
 thank you very much. 
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1
    Regards
     
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1Fangweiwei
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1fangweiwei@tom.com
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-11-26

--=====002_Dragon753533688881_=====
Content-Type: text/html;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Dgb2312"=
 http-equiv=3DContent-Type>
<META content=3D"MSHTML 5.00.2920.0" name=3DGENERATOR></HEAD>
<BODY>
<P><SPAN id=3D_FoxToName>netfilter-devel</SPAN>=A3=AChi=A3=A1</P>
<P>&nbsp;&nbsp; To study the libipq, I download the sample code=
 ipq_client.c and 
compile it with gcc, and then I run it by root in console:</P>
<P>./ipq_client.out&nbsp; </P>
<P>but it just don't do anything.the cursor just wait and print=
 no 
information.can you tell me what to do ? thanks a lot!</P>
<P>the code is as following:</P>
<P>--------------------------------------------------------------=
------------------------------</P>
<P>/*<BR>&nbsp;* ipq_client.c<BR>&nbsp;*<BR>&nbsp;* Simple ipq=
 client for test 
&amp; development.&nbsp; If you set dump_payload<BR>&nbsp;* to 1,=
 you'll 
probably want to run as ./ipq_client &gt;=
 dump.out<BR>&nbsp;*<BR>&nbsp;* At the 
moment, this code grabs queued packets, mangles the TOS field,=
 <BR>&nbsp;* then 
issues NF_ACCEPT verdicts.&nbsp; This is to establish that=
 modifying <BR>&nbsp;* 
packets works.<BR>&nbsp;*<BR>&nbsp;* TODO: - Make more flexible,=
 use 
getopts<BR>&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - Add=
 differential 
csum<BR>&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - Add support=
 for more 
protocols<BR>&nbsp;*<BR>&nbsp;* This program is free software;=
 you can 
redistribute it and/or modify<BR>&nbsp;* it under the terms of=
 the GNU General 
Public License as published by<BR>&nbsp;* the Free Software=
 Foundation; either 
version 2 of the License, or<BR>&nbsp;* (at your option) any=
 later 
version.<BR>&nbsp;*<BR>&nbsp;* This program is distributed in the=
 hope that it 
will be useful,<BR>&nbsp;* but WITHOUT ANY WARRANTY; without even=
 the implied 
warranty of<BR>&nbsp;* MERCHANTABILITY or FITNESS FOR A=
 PARTICULAR 
PURPOSE.&nbsp; See the<BR>&nbsp;* GNU General Public License for=
 more 
details.<BR>&nbsp;*<BR>&nbsp;*/<BR>#include=
 &lt;stdio.h&gt;<BR>#include 
&lt;netinet/in.h&gt;<BR>#include &lt;netinet/ip.h&gt;<BR>#include=
 
&lt;linux/netfilter.h&gt;<BR>#include &lt;unistd.h&gt;</P>
<P>#include "libipq.h"</P>
<P>#define BUFSIZE 2048 </P>
<P>static void die(struct ipq_handle *h);<BR>static void 
dump_metadata(ipq_packet_msg_t *m);<BR>static void=
 dump_iphdr(unsigned char 
*buf);<BR>static u_int16_t csum_partial(void 
*buffer,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
unsigned int len, u_int16_t prevsum);</P>
<P>int main(int argc, char **argv)<BR>{ <BR>&nbsp;int=
 status;<BR>&nbsp;unsigned 
char dump_payload =3D 0;<BR>&nbsp;unsigned char=
 inbuf[BUFSIZE];<BR>&nbsp;struct 
ipq_handle *h;<BR>&nbsp;int verdict =3D=
 NF_ACCEPT;<BR>&nbsp;<BR>&nbsp;h =3D 
ipq_create_handle(0, PF_INET);<BR>&nbsp;if 
(!h)<BR>&nbsp;&nbsp;die(h);<BR>&nbsp;status =3D ipq_set_mode(h,=
 IPQ_COPY_PACKET, 
BUFSIZE);<BR>&nbsp;if (status &lt;=
 0)<BR>&nbsp;&nbsp;die(h);<BR>&nbsp;do&nbsp; 
{<BR>&nbsp;&nbsp;status =3D ipq_read(h, inbuf, BUFSIZE,=
 0);<BR>&nbsp;&nbsp;if 
(status &lt;=
 0)<BR>&nbsp;&nbsp;&nbsp;die(h);<BR>&nbsp;&nbsp;switch 
(ipq_message_type(inbuf)) {<BR>&nbsp;&nbsp;&nbsp;case 
NLMSG_ERROR:<BR>&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, "Received=
 error message 
%d\n",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ipq_get_msgerr(inbuf));<B=
R>&nbsp;&nbsp;&nbsp;&nbsp;break;<BR>&nbsp;&nbsp;&nbsp;case 
IPQM_PACKET: {<BR>&nbsp;&nbsp;&nbsp;&nbsp;ipq_packet_msg_t *m =3D 
ipq_get_packet(inbuf);<BR>&nbsp;&nbsp;&nbsp;&nbsp;unsigned char=
 *packet =3D 
NULL;<BR>&nbsp;&nbsp;&nbsp;&nbsp;struct iphdr *iph =3D NULL;</P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;if 
(!m)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<BR>&nbsp;&nbsp;&nbsp=
;&nbsp;dump_metadata(m);<BR>&nbsp;&nbsp;&nbsp;&nbsp;if 
(m-&gt;data_len &gt;=3D sizeof(struct iphdr)) 
{<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;packet =3D (unsigned char 
*)m<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; 
+ 
sizeof(*m);<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dump_iphdr(packet);<=
BR>&nbsp;&nbsp;&nbsp;&nbsp;}<BR>&nbsp;&nbsp;&nbsp;&nbsp;fprintf(s=
tderr, 
"Sending verdict %d on 
"<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; "packet 
%lX\n", verdict, m-&gt;packet_id);<BR>&nbsp;&nbsp;&nbsp;&nbsp;iph=
 =3D (struct 
iphdr *)packet;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<BR>&nbsp;&nbsp;&nbsp;&nbsp;iph-&gt;tos =3D 
0x55;<BR>&nbsp;&nbsp;&nbsp;&nbsp;iph-&gt;check =3D 
0;<BR>&nbsp;&nbsp;&nbsp;&nbsp;iph-&gt;check =3D 
~csum_partial(packet,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 
sizeof(struct 
iphdr),<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
0);<BR>&nbsp;&nbsp;&nbsp;&nbsp;status =3D 
ipq_set_verdict(h,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;packet_id,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
verdict,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;data_len,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
packet);<BR>&nbsp;&nbsp;&nbsp;&nbsp;if (status &lt; 
0)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;die(h);<BR>&nbsp;&nbsp;&nbsp;=
&nbsp;break;<BR>&nbsp;&nbsp;&nbsp;}<BR>&nbsp;&nbsp;&nbsp;default:=
<BR>&nbsp;&nbsp;&nbsp;&nbsp;fprintf(stderr, 
"Unknown 
message!\n");<BR>&nbsp;&nbsp;&nbsp;&nbsp;break;<BR>&nbsp;&nbsp;}<=
BR>&nbsp;&nbsp;if 
(dump_payload)<BR>&nbsp;&nbsp;&nbsp;write(1, inbuf,=
 status);<BR>&nbsp;} while 
(1);<BR>&nbsp;ipq_destroy_handle(h);<BR>&nbsp;return 0;<BR>}=
 </P>
<P>static void die(struct ipq_handle 
*h)<BR>{<BR>&nbsp;ipq_perror("ERROR");<BR>&nbsp;ipq_destroy_handl=
e(h);<BR>&nbsp;exit(1);<BR>}</P>
<P>static void dump_metadata(ipq_packet_msg_t 
*m)<BR>{<BR>&nbsp;if(!m)<BR>&nbsp;&nbsp;return;<BR>&nbsp;fprintf(=
stderr, 
"Dumping Metadata:\nID=3D0x%08lX MARK=3D0x%08lX TSEC=3D%ld 
"<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "TUSEC=3D%ld=
 HOOK=3D%u IN=3D%s 
OUT=3D%s=
 DLEN=3D%d\n",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 
m-&gt;packet_id,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; 
m-&gt;mark,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;timestamp_sec,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 
m-&gt;timestamp_usec,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 
m-&gt;hook,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;indev_name[0] ? m-&gt;indev_name : 
"[none]",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;outdev_name[0] ? m-&gt;outdev_name : 
"[none]",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
m-&gt;data_len);<BR>}</P>
<P>/* <BR>&nbsp;* This does not handle IP options yet, although=
 it may at some 
point <BR>&nbsp;* in the near future.&nbsp; Some of this code was=
 stolen from 
ipt_LOG.c.<BR>&nbsp;*/<BR>static void dump_iphdr(unsigned char 
*buf)<BR>{<BR>&nbsp;struct iphdr *iph =3D (struct iphdr *)buf;</P>
<P>&nbsp;fputs("Dumping IP Header:\n",=
 stderr);<BR>&nbsp;fprintf(stderr, "VER=3D%u 
HLEN=3D%u TOS=3D0x%02hX TLEN=3D%u ID=3D%u 
",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
iph-&gt;version,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; iph-&gt;ihl 
* 4,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 iph-&gt;tos, 
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
ntohs(iph-&gt;tot_len),<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; 
ntohs(iph-&gt;id));<BR>&nbsp;if (ntohs(iph-&gt;frag_off) &amp; 
IP_DF)<BR>&nbsp;&nbsp;fputs("DF ", stderr);<BR>&nbsp;if=
 (ntohs(iph-&gt;frag_off) 
&amp; IP_MF)<BR>&nbsp;&nbsp;fputs("MF ", stderr);<BR>&nbsp;if 
(ntohs(iph-&gt;frag_off) &amp;=
 0x1FFF)<BR>&nbsp;&nbsp;fprintf(stderr, "FRAG=3D%u 
",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
(ntohs(iph-&gt;frag_off) &amp; 0x1FFF) *=
 8);<BR>&nbsp;fprintf(stderr, "TTL=3D%u 
PROT=3D%u CSUM=3D0x%04X=
 ",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
iph-&gt;ttl,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 
iph-&gt;protocol,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 
ntohs(iph-&gt;check));<BR>&nbsp;fprintf(stderr, "SRC=3D%u.%u.%u.%u=
 
DST=3D%u.%u.%u.%u\n\n",<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; 
(ntohl(iph-&gt;saddr) &gt;&gt; 24) &amp; 
0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (ntohl(iph-&gt;saddr) 
&gt;&gt; 16) &amp;=
 0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
(ntohl(iph-&gt;saddr) &gt;&gt; 8) &amp; 
0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (ntohl(iph-&gt;saddr)) 
&amp; 0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
(ntohl(iph-&gt;daddr) &gt;&gt; 24) &amp; 
0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (ntohl(iph-&gt;daddr) 
&gt;&gt; 16) &amp;=
 0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
(ntohl(iph-&gt;daddr) &gt;&gt; 8) &amp; 
0xFF,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 (ntohl(iph-&gt;daddr)) 
&amp; 0xFF);<BR>}</P>
<P>/* This is from gen_ip.c */<BR>static u_int16_t=
 csum_partial(void 
*buffer,<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
unsigned int len, u_int16_t prevsum)<BR>{<BR>&nbsp;u_int32_t sum=
 =3D 
0;<BR>&nbsp;u_int16_t *ptr =3D buffer;<BR>&nbsp;<BR>&nbsp;while=
 (len &gt; 1)&nbsp; 
{<BR>&nbsp;&nbsp;sum +=3D *ptr++;<BR>&nbsp;&nbsp;len -=3D=
 2;<BR>&nbsp;}<BR>&nbsp;if 
(len) {<BR>&nbsp;&nbsp;union {<BR>&nbsp;&nbsp;&nbsp;u_int8_t 
byte;<BR>&nbsp;&nbsp;&nbsp;u_int16_t wyde;<BR>&nbsp;&nbsp;} 
odd;<BR>&nbsp;<BR>&nbsp;&nbsp;odd.wyde =3D=
 0;<BR>&nbsp;&nbsp;odd.byte =3D 
*((u_int8_t *)ptr);<BR>&nbsp;&nbsp;sum +=3D=
 odd.wyde;<BR>&nbsp;}<BR>&nbsp;sum =3D 
(sum &gt;&gt; 16) + (sum &amp; 0xFFFF);<BR>&nbsp;sum +=3D=
 prevsum;<BR>&nbsp;return 
(sum + (sum &gt;&gt; 
16));<BR>}<BR>---------------------------------------------------=
------------------------------------</P>
<P>&nbsp;thank you very much. </P>
<P>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1</P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;Regards<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;</P>
<P>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1Fangweiwei<BR>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1<A 
href=3D"mailto:fangweiwei@tom.com">fangweiwei@tom.com</A><BR>=A1=A1=A1=A1=A1=A1=
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-11-26</P></BODY></HTML>

--=====002_Dragon753533688881_=====--

--=====000_Dragon753533688881_=====
Content-Type: image/gif;
      name="fox.gif"
Content-Transfer-Encoding: base64
Content-Disposition: FoxmailIcon;
      filename="fox.gif"

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


--=====000_Dragon753533688881_=====--
