From: "Fangweiwei" <fangweiwei@tom.com>
Subject: anyone can help me with ipqdemo?
Date: Mon, 1 Dec 2003 14:48:4 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1AQhqB-0006F8-Pu@vishnu.netfilter.org>
Reply-To: fangweiwei@tom.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
      boundary="=====000_Dragon777141325815_====="
Cc: aldem-nf@aldem.net <aldem-nf@aldem.net>
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

--=====000_Dragon777141325815_=====
Content-Type: multipart/alternative;
      boundary="=====002_Dragon777141325815_====="


--=====002_Dragon777141325815_=====
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable

netfilter-devel=A3=AChi=A3=A1
   I have download the ipqdemo and run it in the console as root=
 , but the cursor just wait there,and I don't think it works.I am=
 a new user ,and I strive to make it work well, but I failed.Can=
 you help me? 
the source code is:
/*
 * ipqdemo.c by Alexander Demenshin <aldem-nf@aldem.net>
 *  version 0.0a (very, very alpha :))
 *
 * IPQ usage demonstration (very, very basic :)
 *
 * What it does? Nothing serious - only accept packets that are=
 coming
 * from QUEUE target(s) and prints them out (not completely for=
 now).
 * At least it may be usefult for beginners who have no where to=
 start
 * playing with ip_queue :)
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
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4/ip_queue.h>
#include <linux/ip.h>
#include "include/libipq/libipq.h"
/* Normally, we should not expect that packets will be so big,
   even including metadata, but who knows? :)
 */
#define  MAX_PACKET_LEN 8192
void  main(int argc, char **argv)
{
 struct ipq_handle  *qh;
 struct ipq_packet_msg  *qpkt;
 struct iphdr   *iph;
 unsigned char   buff[sizeof *qpkt + MAX_PACKET_LEN];
 int    type;
 int    len;
 /* Init first (flags are not implemented; yet) */
 if ((qh =3D ipq_create_handle(0)) =3D=3D NULL) {
  /* Run away... */
  ipq_perror("create_handle()");
  exit(1);
 }
 
 /* We would like to receive not only metadata... */
 if (ipq_set_mode(qh, IPQ_COPY_PACKET, MAX_PACKET_LEN) < 0) {
  ipq_perror("set_mode()");
  goto cleanup;
 }
 
 /*
  * Now real fun begins... Just stay in loop, read packets,
  * accept them if they are IP.
  */
 while (1) {
  len =3D ipq_read(qh, buff, sizeof buff, 0);
  if (len =3D=3D 0) {
   fprintf(stderr, "read(): Zero length packet; ingnoring\n");
   continue;
  }
  if (len < 0) {
   ipq_perror("read()");
   goto cleanup;
  }
  qpkt =3D ipq_get_packet(buff);
  iph =3D (struct iphdr *)qpkt->payload;
  /* If packet type from kernel is not known to us,
   * just ignore it (but notify user)
   */
  if ((type =3D ipq_message_type(buff)) !=3D IPQM_PACKET) {
   fprintf(stderr, "read(): Unknown message type %u\n",
    type);
   continue;
  }
  /* Now we know that it is IPv4 packet... So, accept it,
   * but print out some use(ful|less) info first :)
   * The reason why I use stderr here is to avoid output
   * delays due to buffering on stdout. Yes, I am lazy :)
   */
  fprintf(stderr, "%08X %08X %04X [%-6s=3D>%6s] (%4u/%4u) %08X =3D>=
 %08X\n",
   qpkt->packet_id, qpkt->mark, qpkt->hook,
   qpkt->indev_name, qpkt->outdev_name,
   qpkt->data_len,
   iph->ihl << 2,
   ntohl(iph->saddr), ntohl(iph->daddr)
  );
  /* Just accept, nothing more... */
  if (ipq_set_verdict(qh, qpkt->packet_id, NF_ACCEPT, 0, NULL) <=
 0) {
   ipq_perror("set_verdict(): Oops!");
   goto cleanup;
  }
 }
cleanup:
 ipq_destroy_handle(qh);
}
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1
    Regards
     
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1Fangweiwei
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1fangweiwei@tom.com
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-12-01

--=====002_Dragon777141325815_=====
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
<P>&nbsp;&nbsp; I have download the ipqdemo and run it in the=
 console as root , 
but the cursor just wait there,and I don't think it works.I am a=
 new user ,and I 
strive to make it work well, but I failed.Can you help me? </P>
<P>the source code is:</P>
<P>/*<BR>&nbsp;* ipqdemo.c&nbsp;by Alexander Demenshin &lt;<A 
href=3D"mailto:aldem-nf@aldem.net">aldem-nf@aldem.net</A>&gt;<BR>&n=
bsp;*&nbsp;&nbsp;version 
0.0a (very, very alpha :))<BR>&nbsp;*<BR>&nbsp;* IPQ usage=
 demonstration (very, 
very basic :)<BR>&nbsp;*<BR>&nbsp;* What it does? Nothing serious=
 - only accept 
packets that are coming<BR>&nbsp;* from QUEUE target(s) and=
 prints them out (not 
completely for now).<BR>&nbsp;* At least it may be usefult for=
 beginners who 
have no where to start<BR>&nbsp;* playing with ip_queue=
 :)<BR>&nbsp;*<BR>&nbsp;* 
This program is free software; you can redistribute it and/or=
 modify<BR>&nbsp;* 
it under the terms of the GNU General Public License as published=
 by<BR>&nbsp;* 
the Free Software Foundation; either version 2 of the License,=
 or<BR>&nbsp;* (at 
your option) any later version.<BR>&nbsp;*<BR>&nbsp;* This=
 program is 
distributed in the hope that it will be useful,<BR>&nbsp;* but=
 WITHOUT ANY 
WARRANTY; without even the implied warranty of<BR>&nbsp;*=
 MERCHANTABILITY or 
FITNESS FOR A PARTICULAR PURPOSE.&nbsp; See the<BR>&nbsp;* GNU=
 General Public 
License for more details.<BR>&nbsp;*<BR>&nbsp;*/</P>
<P>#include&nbsp;&lt;stdlib.h&gt;<BR>#include&nbsp;&lt;stdio.h&gt=
;<BR>#include&nbsp;&lt;unistd.h&gt;</P>
<P>#include&nbsp;&lt;linux/netfilter.h&gt;<BR>#include&nbsp;&lt;l=
inux/netfilter_ipv4/ip_queue.h&gt;<BR>#include&nbsp;&lt;linux/ip.=
h&gt;</P>
<P>#include&nbsp;"include/libipq/libipq.h"</P>
<P>/* Normally, we should not expect that packets will be so 
big,<BR>&nbsp;&nbsp; even including metadata, but who knows? 
:)<BR>&nbsp;*/<BR>#define&nbsp;&nbsp;MAX_PACKET_LEN&nbsp;8192</P>=

<P>void&nbsp;&nbsp;main(int argc, char=
 **argv)<BR>{<BR>&nbsp;struct 
ipq_handle&nbsp;&nbsp;*qh;<BR>&nbsp;struct 
ipq_packet_msg&nbsp;&nbsp;*qpkt;<BR>&nbsp;struct 
iphdr&nbsp;&nbsp;&nbsp;*iph;<BR>&nbsp;unsigned=
 char&nbsp;&nbsp;&nbsp;buff[sizeof 
*qpkt + 
MAX_PACKET_LEN];<BR>&nbsp;int&nbsp;&nbsp;&nbsp;&nbsp;type;<BR>&nb=
sp;int&nbsp;&nbsp;&nbsp;&nbsp;len;</P>
<P>&nbsp;/* Init first (flags are not implemented; yet)=
 */<BR>&nbsp;if ((qh =3D 
ipq_create_handle(0)) =3D=3D NULL) {<BR>&nbsp;&nbsp;/* Run away... 
*/<BR>&nbsp;&nbsp;ipq_perror("create_handle()");<BR>&nbsp;&nbsp;e=
xit(1);<BR>&nbsp;}<BR>&nbsp;<BR>&nbsp;/* 
We would like to receive not only metadata... */<BR>&nbsp;if=
 (ipq_set_mode(qh, 
IPQ_COPY_PACKET, MAX_PACKET_LEN) &lt; 0) 
{<BR>&nbsp;&nbsp;ipq_perror("set_mode()");<BR>&nbsp;&nbsp;goto 
cleanup;<BR>&nbsp;}<BR>&nbsp;<BR>&nbsp;/*<BR>&nbsp; * Now real=
 fun begins... 
Just stay in loop, read packets,<BR>&nbsp; * accept them if they=
 are 
IP.<BR>&nbsp; */<BR>&nbsp;while (1) {<BR>&nbsp;&nbsp;len =3D=
 ipq_read(qh, buff, 
sizeof buff, 0);<BR>&nbsp;&nbsp;if (len =3D=3D 0) 
{<BR>&nbsp;&nbsp;&nbsp;fprintf(stderr, "read(): Zero length=
 packet; 
ingnoring\n");<BR>&nbsp;&nbsp;&nbsp;continue;<BR>&nbsp;&nbsp;}<BR=
>&nbsp;&nbsp;if 
(len &lt; 0) 
{<BR>&nbsp;&nbsp;&nbsp;ipq_perror("read()");<BR>&nbsp;&nbsp;&nbsp=
;goto 
cleanup;<BR>&nbsp;&nbsp;}<BR>&nbsp;&nbsp;qpkt =3D 
ipq_get_packet(buff);<BR>&nbsp;&nbsp;iph =3D (struct iphdr=
 *)qpkt-&gt;payload;</P>
<P>&nbsp;&nbsp;/* If packet type from kernel is not known to=
 us,<BR>&nbsp;&nbsp; 
* just ignore it (but notify user)<BR>&nbsp;&nbsp;=
 */<BR>&nbsp;&nbsp;if ((type =3D 
ipq_message_type(buff)) !=3D IPQM_PACKET)=
 {<BR>&nbsp;&nbsp;&nbsp;fprintf(stderr, 
"read(): Unknown message type 
%u\n",<BR>&nbsp;&nbsp;&nbsp;&nbsp;type);<BR>&nbsp;&nbsp;&nbsp;con=
tinue;<BR>&nbsp;&nbsp;}</P>
<P>&nbsp;&nbsp;/* Now we know that it is IPv4 packet... So,=
 accept 
it,<BR>&nbsp;&nbsp; * but print out some use(ful|less) info first=
 
:)<BR>&nbsp;&nbsp; * The reason why I use stderr here is to avoid=
 
output<BR>&nbsp;&nbsp; * delays due to buffering on stdout. Yes,=
 I am lazy 
:)<BR>&nbsp;&nbsp; */<BR>&nbsp;&nbsp;fprintf(stderr, "%08X %08X=
 %04X 
[%-6s=3D&gt;%6s] (%4u/%4u) %08X =3D&gt; 
%08X\n",<BR>&nbsp;&nbsp;&nbsp;qpkt-&gt;packet_id, qpkt-&gt;mark,=
 
qpkt-&gt;hook,<BR>&nbsp;&nbsp;&nbsp;qpkt-&gt;indev_name, 
qpkt-&gt;outdev_name,<BR>&nbsp;&nbsp;&nbsp;qpkt-&gt;data_len,<BR>=
&nbsp;&nbsp;&nbsp;iph-&gt;ihl 
&lt;&lt; 2,<BR>&nbsp;&nbsp;&nbsp;ntohl(iph-&gt;saddr), 
ntohl(iph-&gt;daddr)<BR>&nbsp;&nbsp;);</P>
<P>&nbsp;&nbsp;/* Just accept, nothing more...=
 */<BR>&nbsp;&nbsp;if 
(ipq_set_verdict(qh, qpkt-&gt;packet_id, NF_ACCEPT, 0, NULL) &lt;=
 0) 
{<BR>&nbsp;&nbsp;&nbsp;ipq_perror("set_verdict(): 
Oops!");<BR>&nbsp;&nbsp;&nbsp;goto=
 cleanup;<BR>&nbsp;&nbsp;}<BR>&nbsp;}</P>
<P>cleanup:<BR>&nbsp;ipq_destroy_handle(qh);<BR>}</P>
<P>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1</P>
<P>&nbsp;&nbsp;&nbsp;&nbsp;Regards<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;</P>
<P>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1Fangweiwei<BR>=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1<A 
href=3D"mailto:fangweiwei@tom.com">fangweiwei@tom.com</A><BR>=A1=A1=A1=A1=A1=A1=
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12003-12-01</P></BODY></HTML>

--=====002_Dragon777141325815_=====--

--=====000_Dragon777141325815_=====
Content-Type: image/gif;
      name="fox.gif"
Content-Transfer-Encoding: base64
Content-Disposition: FoxmailIcon;
      filename="fox.gif"

R0lGODlhIwAfALMLAP///+Dg4OCgAOCAAOAAAMDA4KCgwKBgQIAAAGBggCAgIAAAAAAAAAAAAAAA
AAAAACH/C05FVFNDQVBFMi4wAwHoAwAh+QQJDwALACwAAAAAIwAfAAAE+3DJSem5Na+jux3CxWWi
Zx5DIgiD6Lrgan6FoYZDzuborKGDQKEAXBl1Al/lEgwUjcaeTClhBpDQ6ECypYqwzauAuOhSN8BY
s6AoDBSjczW9atrcibicmQPZ229yS0AGNUEGCkIKghYiBgGQkZIKi4wHBoWSmgEGjHOXBZucnUov
aJeYhUM1pD58fRifCbMJe2Atcy2qBbWlWEdfApmQvD5uMVktFyGhkr0mbllQtCjNxM8dhdJ9CZi8
l5I12BlDyTndw92rNeIUBe6RddyqCQEJfSn1Nu4Tw8TKB9TdQSFAAa19/CRYE0JkRL5aChCAoISg
A6cFC4e0qqBgNlhEBLM0bNI4ToJBbwEofURQkcKjSKs2TlhJoGZNhrMQStjVTkNEmzbD8bLxLFXI
DiqTKl0aAQAh+QQJDwALACwCAAAAIQAfAAAE+3DJSeW5Na+jux3CxWWi1x1DIgiD6Lrgan6FoYZD
zuboXKGDQKEAXBl1At/kEgwUjcaeTMkMIKHRgUTrE12bVgFxwaUCY82CojBQjJSW86ppYyfecGYO
RF+3lQY1BoN6gQZBBgpCCjOBQ48GLgYBlJWWCowZBZaUQ5GDm5yWBhqhokIigaeDpaeVqYOOnqQd
pqJMcQcJuwkmm4+2UC0oB7K9HUKxjwFYTAKqnccVnryyUCIhtgHSFAE2EwmHMSu8KLYF3BMFGeJG
4YF3k5U16TUaewLvoeHAhty0GfDxQ7dtT4oE3tJ1MMivDgoBCqop9CBw1wIFCEBgQgCHL4LBYQqg
YURgseMGFxFBBcA0EgHHjiJaEpg5Uwi6cBNNYKRJ09IQnDk1sBxKtGgEACH5BAkPAAsALAgAAAAb
AB8AAAT7cMl56rz44H2GqBpnbVeXCMIArquHckNhnN9gp3ZHUnZQFB0XCvfaVQaBQHDI1BVFyBuz
OZBURUsUMukBLq4Lg48SdG0LisJAEcKIfUfpdqZOtN0FZdkzT693EgZ5cYIGSAYKPgqAYYMgb0mR
kQqLG4JwBpeSmwYkmnoHn5KZO5qPmYI/Mp2lP3oFEiAJswmMqZKwR6GqtZ6uuEcCnwW9GTcBAkkg
H3mSxTxCWrQdzUnEGzbRAgmZxKG4MxhSQ9ya3KoyMs/ZTOfEAQnZA7MB4RPs5IUJQB4KtPb35JGb
tUABgn4GAcmTV0GBJoMICJJYCMJftwCUICJAYGQahUYCIEH6IMbtGQmDIUPiIjbD5IWMMGPKjAAA
IfkECQ8ACwAsBQAAAB4AHwAABPtwyTmPpbjmvc4Q1rGFXOYlgjCELPulpVcYKDjc6u2VlDcEhYIv
RcQJeBLLLzAkEncwnjJgdD4HEmxM+VIFvh/hQiv1vZYFRWGgECGT5tSStk6431zcXM1+LwwGHT4G
Mz8GCkAKfhIGLAZfkJEBCopvjYAFkpKBSJghhJoBgDyAoJ+lQUGjJZiZTHchCbIJpISuX5yCK7YF
tBu8kblKAqBfvRm2mxUWILdfvhTFwROzMpHHGKA/RSIJmHaPkDPQEzddOd7F3qkz4xjmTjfrvQEJ
5gOyouRj8E7rdB4EKJhFY8O9eLMWKEDwgRICHvcirjigoNhCBLIgRgwxECPTJIcIQpZhcREBgZMn
gfTytq/EQpQor/Wi0TIDpZs4c+KMAAAh+QQJDwALACwCAAAAIQAfAAAE+3DJSeW5Na+jux3CxWWi
1x1DIgiD6Lrgan6FoYZDzuboXKGDQKEAXBl1At/kEgwUjcaeTMkMIKHRgUTrE12bVgFxwaUCY82C
ojBQjJSW86ppYyfecGYORF+34T9ABjVBBgpCCoAULgYBjo+QCokdBhoHBoOQmgGVGpgnF5mbn54F
oJeYg0M1naWgSxcJsgkmql0ol6u0lKYzTAKiQrsVtiYiIQWawxSNvR6zKMmPBcsSos4ZCZjUl5A1
1cHYE9qi2qs138yaQ3s55tQBCe2ynMvBAVgr5nUoAgqzNohJK5BvzqwFChCAkISAl6MYWPZcUCAq
IQJZGVRZ2bNDLuKBf9sCSLKIoCEzNu1STiyJgIBLl0KoaVvmpZ0LhC1fwpxGzQbNF3hGCh1KNAIA
IfkECQ8ACwAsAAAAACMAHwAABPtwyUnpuTWvo7sdwsVlomceQyIIg+i64Gp+haGGQ87m6Kyhg0Ch
AFwZdQJf5RIMFI3GnkwpYQaQ0OhAsqWKsM2rgLjoUjfAWLOgKAwUo3M1vWra3Im4nJkD2dtvcktA
BjVBBgpCCoIWIgYBkJGSCouMBwaFkpoBBoxzlwWbnJ1KL2iXmIVDNaQ+fH0YnwmzCXtgLXMtqgW1
pVhHXwKZkLw+bjFZLRchoZK9Jm5ZULQozcTPHYXSfQmYvJeSNdgZQ8k53cPdqzXiFAXukXXcqgkB
CX0p9TbuE8PEygfU3UEhQAGtffwkWBNCZES+WgoQgKCEoAOnBQuHtKqgYDZYRASzNGzSOE6CQW8B
KH1EUJHCo0irNk5YSaBmTYazEErY1U5DRJs2w/Gy8SxVyA4qkypdGgEAIfkECQ8ACwAsAgAAACEA
HwAABPtwyUnluTWvo7sdwsVlotcdQyIIg+i64Gp+haGGQ87m6Fyhg0ChAFwZdQLf5BIMFI3GnkzJ
DCCh0YFE6xNdQTkwh0sFxs7hlpLCRKbTo/XGDA4EDIrCQKE01AyAbX4GQXhCfCZ+Q4sGLgZ2kJEB
CogVBZJCNQeAl5iQBhqdnkQXfp6AoZ6QIoCcjKAdophMFhcJtwkml4uyUC0om4u5HUKtiwFYTAKm
dgXDljW4igVQIiGyAc8Ud88JhDEruCiyzqEZ30befgmbkdGWsBVhAuqd3ryD2vHyOvfO2WlucVMS
MB8REAqkaZsxD9cCBQgQQpQz4c0FBcwgIrhFcSWOiIScJlFCQBIBxY8lCahUmemWjY4QV65058zG
QhOUcurcqTMCACH5BAkPAAsALAgAAAAbAB8AAAT7cMl56rz44H2GqBpnbVeXCMIArquHckNhnN9g
p3ZHUnZQFB0XCvfaVQaBQHDI1BVFyBuzOZBURUuU66ZaXBcGHyW4HdpypLDvKBWeu+mCkuwZ0N47
iUHO3hvsCYEFCXlgfCBqSYqKCgpxawZ7i5MBBo9JiHKUkTuScweRkT8/nJ0/cwUSIIGBhXuaSalH
oKOEcbCxRwKePrYZNwECmBUfuAG+PEJarB24gxtnUwmiCaCLMsheygLTntOjMtgX0UPfg8dvgZXI
5CjfM0AeCqwzGG9CrAsKCPL7efdnKijwtA9BKxL3QMwTFaBRQQQIjKx4SKBiRR+DpmXbsM8OosVr
g2ZsnOCwpMmTEQAAIfkECQ8ACwAsBQAAAB4AHwAABPtwyTmPpbjmvc4Q1rGFXOYlgjCELPulpVcY
KDjc6u2VlDcEhYIvRcQJeBLLLzAkEncwnjJgdD4HEmxM+VLlPquFVup7mW86ZKWcQrvD6k4ZHAgY
FIWBIm4wyG8GMz93QHtxCwYsBnWMjQEKhkiJfQWOjn6SgSGBlnaYHH2cm6FBQX08lJVMIkkWCa8J
qIGqdZ9KB7MFsRu5jbYeApx1uhmzl2sHILR1uxTCvhOwMo3EGJw/RSIJlAm41DQZaE4328LbpTMz
zVlVOee6AQlur3brYuJO5zRCHwqw4OHwtYG1QAGCfgZ5vHljQYEwgwheKWTYsFwlSBARICBDIhkj
gY8fgejaZq+EQZAgqemiUTIDxpcwY0YAACH5BAkPAAsALAIAAAAhAB8AAAT7cMlJ5bk1r6O7HcLF
ZaLXHUMiCIPouuBqfoWhhkPO5uhcoYNAoQBcGXUC3+QSDBSNxp5MyQwgodGBROsTXZtWAXHBpQJj
zYKiMFCMlJbzqmljJ95wZg5EX7fhP0AGNUEGCkIKgBQuBgGOj5AKiR0GGgcGg5CaAZUamCcXmZuf
ngWgl5iDQzWdpaBLFwmyCSaqXSiXq7SUpjNMAqJCuxW2JiIhBZrDFI29HrMoyY8FyxKizhkJmNSX
kDXVwdgT2qLaqzXfzJpDeznm1AEJ7bKcy8EBWCvmdSgCCrM2iEkrkG/OrAUKEICQhICXoxhY9lxQ
ICohAlkZVFnZs0Mu4oF/2wJIsoigITM27VJOLImAgEuXQqhpW+alnQuELV/CnEbNBs0XeEYKHUo0
AgAh+QQJDwALACwAAAAAIwAfAAAE+3DJSee5NVOs9RkD1y1XcYzZZxjh5b6HYaLpUBTrBe7gJ/y0
yqcQMA1+yF8okVgIgpZBIABKWltQ4c56PZ2yEt1xGvhNlV5w+CMtKn4KIlYdbd9AN6qIzp4WFCBx
enQbH36AA4IzhBZ5ZAoKfgWMEmSWl2SThAaYAZxkK1kwCwELK52hUGI7XxIrMjcGamxIPWsmTAmL
QbRdOitERXsdBVVcLQcCjkW7I8VcP7kJB8GZ0ygyxyAJK9PVfgZNzgVX26cB07A3uuEUmhLVSjvc
BQnobNv27RPvMpbFLujZm3ZEQa59/Pj9M/FlgDQFCApC7OBpwbdYHRT4CwARNAETDZhiiatgEBhH
SAg8jnS1EEfGlARi+mFScqU6HCspQIwpkxmRBDVHvvqYEZLRo0iNRgAAIfkECQ8ACwAsAgAAACEA
HwAABPtwyUnXuTVTrOsZA9dZR3GM22AY4eW+h2GiaVGsF6iDn+DTk08hYBr4jr5QIrEQAC2DQACE
rLaeQV3Vejphc0ZpwCdNdrEkkLSg8CmGV7TkEyUWQLapCE1fK0Bvek8yKzgffoBDMygyNo44eWIK
CmsFKENilZmbnJYZmJwBBqGjYisaoKGiK6QGI6mhAxKFj5d2kWVHLSZLCYsaRLR5VTkrmCZeFTYG
vY0FSC4CuDbJFKJMEgksRj69CSWbBd+fGdtH2szgmTfYEzcaWuhS387i7BSu8FTa4gHfO0uuPQEo
I4G/HgqatQMSr5cCBEYmIZAjYUcLBTKkPESwhCMijITGAkza2FEOho0EUq5ZAnLhk4cpVd7y19Il
ipE4c+qMAAAh+QQJDwALACwIAAAAGwAfAAAE+3BJeeq8eNp8xtiZdhRH2BnGV63sYZDh0hUFWnm4
1wl8PAekAW/I+yQSC4FpEAh4iFBVjIKDRkslX0fYDPCaRezEABR5mgUFT1Fwgi7k8hZd8NDc2cwL
OAcqPGxuUwt7N2h/A4EwU3skd10KCnSDe12Wl10FIZVxl50BKDGVQCiYoAaMj2WEKDQ1lKpyIwdH
CYt6sXwnlSR5F1sCXk0rAqo0vlRCRLUJI5cFzRhVyyjNbZY1SBdP1HHNL662BtoS0zwJLwkBzTlH
oOQL5gLo0Os7CrXj0jlDzAoIQiIhmJIjRwkFlf4hOBKj4Ap8rQJEUsjQxAoJCgloRHMEEyK8EP80
bgRyJ4HHjxcmqlzJMgIAIfkECQ8ACwAsBQAAAB4AHwAABPtwySmPpTjfPM8YG1cdxSFWg2GAVuse
RnmiRaFaX/55Qj8vnkKgNOgZe6BEYiGYeQKBz3HK+qGk0yMIaMUVoYEeFGky/bzQgqKnEFat13Th
U4uGup+04tO2w1VAT0N7A30ycAsGCSRCYAoKcogSYJSVYAVWKgaWAZtggCeajZqcoCIqdVAGE6I1
q6ExjaodJAdKCYcZsbKdtCkxaXcSsZWvgQcCqUO5rLyzC7eLzgWLGMADYWTQKtKVNksYOVoDCSpQ
i7vU3+FYSOQxCQGLOkqd4BM6U+XU8jwKt4o45DNC7pYCBEUeIZihoyELBcACHESghGHDFv9QSVRI
8R4ehxcSJhIYmUZJRo8zDo4kuUxIgpMoOTyaSbMmzQgAIfkECQ8ACwAsAgAAACEAHwAABPtwyUnX
uTVTrOsZA9dZR3GM22AY4eW+h2GiaVGsF6iDn+DTk08hYBr4jr5QIrEQAC2DQACErLaeQV3Vejph
c0ZpwCdNdrEkkLSg8CmGV7TkEyUWQLapCE1fK0BvenJBH36AQzODc3liCgprBUAGGWKVlmKRGiua
lwEGlZuamZQLK52hok8rMjaTI6xAFyZLCYmpNDkrQ0R7E7AoLgKMdl4Vn6MatAkllgXLxrvIFQkr
y7uYBkwUMpjJpgHLrDa12dvNdzvUzuB0IEue2hLcYlsC6gnsRgq05dvR9QIGKFOAQB/BDvOMbNFx
QcE8ggiWZGA1RcuOFvt0BXAEUSSiv4sXMUAkQHLNkozxSLTj4WIBQZIl7QxJgDIljD0cc+rcGQEA
IfkECQ8ACwAsAAAAACMAHwAABPtwyUnnuadqebdfxyB23lVkn3YNxoi9l4Gm1VoYeCjuQyj8tNqh
EAgUBr/kr5dILARBiy6AvCgPgt4sytkJsN8fuAfiSkdJMDaU2UZXPeWVbD7Hfwlk4kuvg3QCTQlF
Cgp5bnU2RYuLJ34UQ0SLCJSNjxOMRQSbCI0BlwsGmZsEnUYGZjALATiSAZWsogWDKXA7W61FNwuz
AYNOJSJJIxxDB4InCb2+wUhyWiG5RseSsxtHzs8YAgWu3cdGwBpHckmCCUOZJ8fiFQYF5TsJOOiu
uhgf3c8i86K+B++6WRtHwdUSee9+6eDnocCEd4yOYJjXCx0SQ+0KTrD3DUfFgHMKEFwM6YEVr4i7
NiiAGCAkgiYbMhm5kVGCoVyFXMKk4E9XN1QqKZHS1eRmu4A/a9pEQIqATyIJjIrDYWCnypxYs2aN
AAAh+QQJDwALACwCAAAAIQAfAAAE+3DJSde5p2p59z5D2HlXkXnVNRgi5l7GiVJqYdxgqA+g4M+0
QyEQKAx8SB8vkVgIgJxc4HhJHgQ8GdSiE1y9vi/Pso2KkN8rKKMFqnhJ67hshvsSx4R3Tn8LmAlE
Cgp4bR4GNjcxIENEjkQmQIgFlJQxlI8Imo4FM42PmI8BBKQInAEen6IBBqKkpJAGqauiN5+brAaB
qBWqtAMStrELgcUUQ5WqSVkmgAUJz0RNE0WKlQFxKsJF0I3TC5aAkwVWVaFFz97UuhMJLEd3gEKi
zUzHGu9I7rrzoBjHsjR02SftwLhnGwIKDPEHUbEcIb6V2eEuWoIehCROZAgoNIECBEcGIaAzYUcW
BYgEabJH8gUhYYM+ImDZJ4PMV5CYvNQI5eMrApAweXRHs2fMo0iRRgAAIfkECQ8ACwAsCAAAABsA
HwAABPtwSXnqmTivqun4XLcdxdVVgwFabGWY5zEURi1/+CALvFgVgUBhwCvydInEQhD7BIgV40Gg
g51wgmmWp9VtRCNQUTuVXWAG4QSlM0q9mrSQrRUkiIksPA5k25NBCgp3VnwBKEBBikElYAsGfQWJ
QQiVigWOkIuKBJ0IlwEimgFynJ0EjAZgo6Sslq0JQXyTmI+jNAuxuhiQk2o/B0kJBcOxAUoSvZsl
MjWJxJJByBsfAgHWh1HRjNDSHkRGwgkky8FJE1jhNeO+cyES1epy472S0xjpPAmQujcf9/ji6eN3
bMcggOhyFBGnAAERQQjA5MhxQcGohgjOdZhoYSKQswCCMGrUwEICxlOMknhEmKHhKVRCoiVYydJk
yJs4cUYAACH5BAkPAAsALAUAAAAeAB8AAAT7cMkpjz00U6vzGSDXLVaBjdVnhFdrGSdKfoVhf2A+
fEIvz4VAoDDoGXu7RGIhkFlAgaLleBDsYs6coLrtcXek3yxk5FY/GOzouTtSweJxu5coJrZwMVug
TAgVCnVqIzZjQUKIQiZxEjAFh0IIkogFjBKJQgSaCJQBcTYGmJqaigY/oIc2kJMBNn6eGqqQpo0G
hzULfroUsom0QAd9BQnDQkuNj5CtE0+qisSHx7bKyylVj5TD0ciY1X0JB9QmfRO2UQFGYAmu4Zgm
IhNa6QProQHg04/HGvJI9La6cIDYx68fHYD3eAQiWBDEEXp9FCAoAgiBDB0YrygwF0AnIgIlFzFe
COQMkEeQKFxI8DjqWQKSDFFIHEVAEbaX61DKMMmzp88IACH5BAkPAAsALAIAAAAhAB8AAAT7cMlJ
17mnann3PkPYeVeRedU1GCLmXsaJUmph3GCoD6Dgz7RDIRAoDHxIHy+RWAiAnFzgeEkeBDwZ1KIT
XL2+L8+yjYqQ3ysoowWqeEnruGyG+xLHhHdOfwuYCUQKCnhtZTVEiYkmdDQFQ4kIkotQBhqKRASa
CIsBKDcbBpiaBJxFlh4GBR4BN5ABk62iBYEVqluuRDYLtAGBTRKqq25CB4AmCb2+E7fEK6q6xpC0
wY/EV4+LyEXAC7MzgAlCmCbG3dBFKAk34q/RI9WUGuuivgfCj90U9do7A+u9xO3Qt89dnDuqfvUg
RJDZtINKwilAcGQQglSQjhzUcUE0AbqJCJhoEDali7+O9IYMAimyoL+TGUCS0sWEkAF9GGB2mEiK
gK5sCWy2jPKCwsqjSJNGAAAh+QQJDwALACwAAAAAIwAfAAAE+3DJSee5NVOs9RkD1y1XcYzZZxjh
5b6HYaLpUBTrBe7gJ/y0yqcQMA1+yF8okVgIgpZBIABKWltQ4c56PZ2yEt1xGvhNlV5w+CMtKn4K
IlYdbd9AN6qIzp4WFCBxenQbH36AA4IzhBZ5ZAoKfgWMEmSWl2SThAaYAZxkK1kwCwELK52hUGI7
XxIrMjcGamxIPWsmTAmLQbRdOitERXsdBVVcLQcCjkW7I8VcP7kJB8GZ0ygyxyAJK9PVfgZNzgVX
26cB07A3uuEUmhLVSjvcBQnobNv27RPvMpbFLujZm3ZEQa59/Pj9M/FlgDQFCApC7OBpwbdYHRT4
CwARNAETDZhiiatgEBhHSAg8jnS1EEfGlARi+mFScqU6HCspQIwpkxmRBDVHvvqYEZLRo0iNRgAA
IfkECQ8ACwAsAgAAACEAHwAABPtwyUnXuTVTrOsZA9dZR3GM22AY4eW+h2GiaVGsF6iDn+DTk08h
YBr4jr5QIrEQAC2DQACErLaeQV3Vejphc0ZpwCdNdrEkkLSg8CmGV7TkEyUWQLapCE1fK0Bvek8y
KzgffoBDMygyNo44eWIKCmsFKENilZmbnJYZmJwBBqGjYisaoKGiK6QGI6mhAxKFj5d2kWVHLSZL
CYsaRLR5VTkrmCZeFTYGvY0FSC4CuDbJFKJMEgksRj69CSWbBd+fGdtH2szgmTfYEzcaWuhS387i
7BSu8FTa4gHfO0uuPQEoI4G/HgqatQMSr5cCBEYmIZAjYUcLBTKkPESwhCMijITGAkza2FEOho0E
Uq5ZAnLhk4cpVd7y19IlipE4c+qMAAAh+QQJDwALACwIAAAAGwAfAAAE+3BJeeq8eNp8xtiZdhRH
2BnGV63sYZDh0hUFWnm41wl8PAekAW/I+yQSC4FpEAh4iFBVjIKDRkslX0fYDPCaRezEABR5mgUF
T1Fwgi7k8hZd8NDc2cwLOAcqPGxuUwt7N2h/A4EwU3skd10KCnSDe12Wl10FIZVxl50BKDGVQCiY
oAaMj2WEKDQ1lKpyIwdHCYt6sXwnlSR5F1sCXk0rAqo0vlRCRLUJI5cFzRhVyyjNbZY1SBdP1HHN
L662BtoS0zwJLwkBzTlHoOQL5gLo0Os7CrXj0jlDzAoIQiIhmJIjRwkFlf4hOBKj4Ap8rQJEUsjQ
xAoJCgloRHMEEyK8EP80bgRyJ4HHjxcmqlzJMgIAIfkECQ8ACwAsBQAAAB4AHwAABPtwySmPpTjf
PM8YG1cdxSFWg2GAVuseRnmiRaFaX/55Qj8vnkKgNOgZe6BEYiGYeQKBz3HK+qGk0yMIaMUVoYEe
FGky/bzQgqKnEFat13ThU4uGup+04tO2w1VAT0N7A30ycAsGCSRCYAoKcogSYJSVYAVWKgaWAZtg
gCeajZqcoCIqdVAGE6I1q6ExjaodJAdKCYcZsbKdtCkxaXcSsZWvgQcCqUO5rLyzC7eLzgWLGMAD
YWTQKtKVNksYOVoDCSpQi7vU3+FYSOQxCQGLOkqd4BM6U+XU8jwKt4o45DNC7pYCBEUeIZihoyEL
BcACHESghGHDFv9QSVRI8R4ehxcSJhIYmUZJRo8zDo4kuUxIgpMoOTyaSbMmzQgAIfkECQ8ACwAs
AgAAACEAHwAABPtwyUnXuTVTrOsZA9dZR3GM22AY4eW+h2GiaVGsF6iDn+DTk08hYBr4jr5QIrEQ
AC2DQACErLaeQV3Vejphc0ZpwCdNdrEkkLSg8CmGV7TkEyUWQLapCE1fK0BvenJBH36AQzODc3li
CgprBUAGGWKVlmKRGiualwEGlZuamZQLK52hok8rMjaTI6xAFyZLCYmpNDkrQ0R7E7AoLgKMdl4V
n6MatAkllgXLxrvIFQkry7uYBkwUMpjJpgHLrDa12dvNdzvUzuB0IEue2hLcYlsC6gnsRgq05dvR
9QIGKFOAQB/BDvOMbNFxQcE8ggiWZGA1RcuOFvt0BXAEUSSiv4sXMUAkQHLNkozxSLTj4WIBQZIl
7QxJgDIljD0cc+rcGQEAIfkECQ8ACwAsAAAAACMAHwAABPtwyUnpuTWvo7sdwsVlomceQyIIg+i6
4Gp+haGGQ87m6Kyhg0ChAFwZdQJf5RIMFI3GnkwpYQaQ0OhAsqWKsM2rgLjoUjfAWLOgKAwUo3M1
vWra3Im4nJkD2dtvcktABjVBBgpCCoIWIgYBkJGSCouMBwaFkpoBBoxzlwWbnJ1KL2iXmIVDNaQ+
fH0YnwmzCXtgLXMtqgW1pVhHXwKZkLw+bjFZLRchoZK9Jm5ZULQozcTPHYXSfQmYvJeSNdgZQ8k5
3cPdqzXiFAXukXXcqgkBCX0p9TbuE8PEygfU3UEhQAGtffwkWBNCZES+WgoQgKCEoAOnBQuHtKqg
YDZYRASzNGzSOE6CQW8BKH1EUJHCo0irNk5YSaBmTYazEErY1U5DRJs2w/Gy8SxVyA4qkypdGgEA
IfkECQ8ACwAsAgAAACEAHwAABPtwyUnluTWvo7sdwsVlotcdQyIIg+i64Gp+haGGQ87m6Fyhg0Ch
AFwZdQLf5BIMFI3GnkzJDCCh0YFE6xNdm1YBccGlAmPNgqIwUIyUlvOqaWMn3nBmDkRft5UGNQaD
eoEGQQYKQgozgUOPBi4GAZSVlgqMGQWWlEORg5uclgYaoaJCIoGng6WnlamDjp6kHaaiTHEHCbsJ
JpuPtlAtKAeyvR1CsY8BWEwCqp3HFZ68slAiIbYB0hQBNhMJhzErvCi2BdwTBRniRuGBd5OVNek1
GnsC76HhwIbctBnw8UO3bU+KBN7SdTDIrw4KAQqqKfQgcNcCBQhAYEIAhy+CwWEKoGFEYLHjBhcR
QQXANBIBx44iWhKYOVMIunATTWCkSdPSEJw5NbAcSrRoBAAh+QQJDwALACwIAAAAGwAfAAAE+3DJ
eeq8+OB9hqgaZ21XlwjCAK6rh3JDYZzfYKd2R1J2UBQdFwr32lUGgUBwyNQVRcgbszmQVEVLFDLp
AS6uC4OPEnRtC4rCQBHCiH1H6XamTrTdBWXZM0+vdxIGeXGCBkgGCj4KgGGDIG9JkZEKixuCcAaX
kpsGJJp6B5+SmTuaj5mCPzKdpT96BRIgCbMJjKmSsEehqrWerrhHAp8FvRk3AQJJIB95ksU8Qlq0
Hc1JxBs20QIJmcShuDMYUkPcmtyqMjLP2UznxAEJ2QOzAeET7OSFCUAeCrT29+SRm7VAAYJ+BgHJ
k1dBgSaDCAiSWAjCX7cAlCAiQGBkGoVGAiBB+iDG7RkJgyFD4iI2w+SFjDBjyowAACH5BAkPAAsA
LAUAAAAeAB8AAAT7cMk5j6W45r3OENaxhVzmJYIwhCz7paVXGCg43OrtlZQ3BIWCL0XECXgSyy8w
JBJ3MJ4yYHQ+BxJsTPlSBb4f4UIr9b2WBUVhoBAhk+bUkrZOuN9c3FzNfi8MBh0+BjM/BgpACn4S
BiwGX5CRAQqKb42ABZKSgUiYIYSaAYA8gKCfpUFBoyWYmUx3IQmyCaSErl+cgiu2BbQbvJG5SgKg
X70ZtpsVFiC3X74UxcETszKRxxigP0UiCZh2j5Az0BM3XTnexd6pM+MY5k43670BCeYDsqLkY/BO
63QeBCiYRWPDvXizFihA8IESAh73Iq44oKDYQgSyIEYMMRAj0ySHCEKWYXERAYGTJ4H08ravxEKU
KK/1otEyA6WbOHPijAAAIfkECQ8ACwAsAgAAACEAHwAABPtwyUnluTWvo7sdwsVlotcdQyIIg+i6
4Gp+haGGQ87m6Fyhg0ChAFwZdQLf5BIMFI3GnkzJDCCh0YFE6xNdm1YBccGlAmPNgqIwUIyUlvOq
aWMn3nBmDkRft+E/QAY1QQYKQgqAFC4GAY6PkAqJHQYaBwaDkJoBlRqYJxeZm5+eBaCXmINDNZ2l
oEsXCbIJJqpdKJertJSmM0wCokK7FbYmIiEFmsMUjb0esyjJjwXLEqLOGQmY1JeQNdXB2BPaotqr
Nd/MmkN7OebUAQntspzLwQFYK+Z1KAIKszaISSuQb86sBQoQgJCEgJejGFj2XFAgKiECWRlUWdmz
Qy7igX/bAkiyiKAhMzbtUk4siYCAS5dCqGlb5qWdC4QtX8KcRs0GzRd4RgodSjQCACH+PEZJTEUg
SURFTlRJVFkNCkNyZWF0ZWQgb3IgbW9kaWZpZWQgYnkNCkVEIVNPTiAnOTYgW1hmL1VDZl0NCgA7


--=====000_Dragon777141325815_=====--
