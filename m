From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: QUEUEing packets to userspace problem
Date: Thu, 29 Apr 2004 15:59:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005001c42df2$3c94d960$061012ac@in.edm.luc.ac.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_004D_01C42E03.0011C280"
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

------=_NextPart_000_004D_01C42E03.0011C280
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello all,

I'm very new at Linux and especially Linux programming. I apologize if =
this turns out to be a stupid question :-)

When I try the libipq example in the man page, I do not receive any =
packets in my userspace application. I have loaded the iptable_filter =
and ip_queue modules, and I added the following rule to iptables:

iptables -A OUTPUT -p icmp -j QUEUE

Then i hit the "Execute Program" button of my KDeveloper (see below for =
the full code). This way, locally created ping packets should be =
delivered to this application right? But immediately after running the =
code, i get the following error message:=20

Received error message 1
Unknown error
ERROR

and packets do not start comming in in the application when I ping =
another PC. Here's my code:


#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include the netfilter and libipq C libraries
#include <linux/netfilter.h>
#include <libipq.h>

#define BUFSIZE 2048

static void die(struct ipq_handle *h)
{
  ipq_perror(NULL);
  ipq_destroy_handle(h);
  printf("Exiting ...\n");
  exit(1);
}

int main(int argc, char *argv[])
{
  printf("Starting up ...\n");
 =20
  int status;
  unsigned char buf[BUFSIZE];
  struct ipq_handle *h;
 =20
  // Initialize the libipq library
  h =3D ipq_create_handle(0, PF_INET);
  if (!h)
  	die(h);
  else
  	printf("Libipq handle created successfully!\n");

  status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
  if (status < 0)
  	die(h);
  else
  	printf("Lipipq mode set to IPQ_COPY_PACKET\n");
 =20
  // Continuously receive packets from kernel space, process them and =
reinject them into the kernel
  while(1) {  =20
  	// Grab the packet
  	status =3D ipq_read(h, buf, BUFSIZE, 0);
    	if (status < 0)
                	die(h);
    	else
    		printf("Libipq packet read successful\n");
	=09
    	switch( ipq_message_type(buf) ) {
    		case NLMSG_ERROR: {
    			fprintf(stderr, "Received error message %d\n", =
ipq_get_msgerr(buf));
    			printf("%s\n", ipq_errstr());
    			ipq_perror(NULL);
    			break;
    		}
    		case IPQM_PACKET: {
    			// In case of a packet and not an error -> get the packet (header =
+ payload)
    			printf("Received a packet from kernel space");
    			ipq_packet_msg_t *m =3D ipq_get_packet(buf);
	=09
    			// Print the payload of the packet
    			if ( m->data_len > 0 ) {
    				printf("Printing content of packet:\n");
                                                                /* To be =
included */
                                  	}
	=09
    			// Reinject the packet into kernel space
    			status =3D ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
    			if (status < 0)
    				die(h);
		=09
    			break;
    		}
    		default: {
    			fprintf(stderr, "Unknown message type!\n");
    			break;
    		}
    	}
  }
 =20
  printf("Closing down ...\n");
 =20
  // Cleanup the libipq library
  ipq_destroy_handle(h);
  return EXIT_SUCCESS;
}


Does anyone have any ideas what i am doing wrong? I am using kernel =
version 2.4.20, and I have also installed the latest version of =
iptables, including the "devel" (header, libraries, ...) part. Thanks in =
advance.

Maarten
------=_NextPart_000_004D_01C42E03.0011C280
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1106" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hello all,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I'm very new at Linux and especially =
Linux=20
programming. I apologize if this turns out to be a stupid question=20
:-)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>When I try the libipq example in the =
man page, I do=20
not receive any packets in my userspace application. I have loaded the=20
iptable_filter and ip_queue modules, and I added the following rule to=20
iptables:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -A OUTPUT -p icmp -j =
QUEUE</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Then i hit the "Execute Program" button =
of my=20
KDeveloper (see below for the full code). This way, locally created ping =
packets=20
should be delivered to this application right? But immediately after =
running the=20
code, i get the following error message: </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Received error message 1</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Unknown error</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ERROR</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>and packets do not start comming in in =
the=20
application when I ping another PC. Here's my code:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>#ifdef HAVE_CONFIG_H<BR>#include=20
&lt;config.h&gt;<BR>#endif<BR><BR>#include &lt;stdio.h&gt;<BR>#include=20
&lt;stdlib.h&gt;<BR>#include &lt;string.h&gt;<BR><BR>// Include the =
netfilter=20
and libipq C libraries<BR>#include &lt;linux/netfilter.h&gt;<BR>#include =

&lt;libipq.h&gt;<BR><BR>#define BUFSIZE 2048<BR><BR>static void =
die(struct=20
ipq_handle *h)<BR>{<BR>&nbsp; ipq_perror(NULL);<BR>&nbsp;=20
ipq_destroy_handle(h);<BR>&nbsp; printf("Exiting=20
...\n");<BR>&nbsp;&nbsp;exit(1);<BR>}<BR><BR>int main(int argc, char=20
*argv[])<BR>{<BR>&nbsp; printf("Starting up ...\n");<BR>&nbsp; =
<BR>&nbsp; int=20
status;<BR>&nbsp; unsigned char buf[BUFSIZE];<BR>&nbsp; struct =
ipq_handle=20
*h;<BR>&nbsp; <BR>&nbsp; // Initialize the libipq library<BR>&nbsp; h =
=3D=20
ipq_create_handle(0, PF_INET);<BR>&nbsp; if (!h)<BR>&nbsp; 	=
die(h);<BR>&nbsp;=20
else<BR>&nbsp; 	printf("Libipq handle created =
successfully!\n");<BR><BR>&nbsp;=20
status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);<BR>&nbsp; if =
(status &lt;=20
0)<BR>&nbsp; 	die(h);<BR>&nbsp; else<BR>&nbsp; 	printf("Lipipq mode set =
to=20
IPQ_COPY_PACKET\n");<BR>&nbsp; <BR>&nbsp; // Continuously receive =
packets from=20
kernel space, process them and reinject them into the kernel<BR>&nbsp; =
while(1)=20
{&nbsp;&nbsp;&nbsp;<BR>&nbsp;&nbsp;	// Grab the packet<BR>&nbsp; 	status =
=3D=20
ipq_read(h, buf, BUFSIZE, 0);<BR>&nbsp;&nbsp;&nbsp; 	if (status &lt;=20
0)<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;	die(h);<BR>&nbsp;&nbsp;&nbsp;=20
	else<BR>&nbsp;&nbsp;&nbsp; 		printf("Libipq packet read=20
successful\n");<BR>		<BR>&nbsp;&nbsp;&nbsp; 	switch( =
ipq_message_type(buf) )=20
{<BR>&nbsp;&nbsp;&nbsp; 		case NLMSG_ERROR: {<BR>&nbsp;&nbsp;&nbsp;=20
			fprintf(stderr, "Received error message %d\n",=20
ipq_get_msgerr(buf));<BR>&nbsp;&nbsp;&nbsp; 			printf("%s\n",=20
ipq_errstr());<BR>&nbsp;&nbsp;&nbsp; 			=
ipq_perror(NULL);<BR>&nbsp;&nbsp;&nbsp;=20
			break;<BR>&nbsp;&nbsp;&nbsp; 		}<BR>&nbsp;&nbsp;&nbsp; 		case =
IPQM_PACKET:=20
{<BR>&nbsp;&nbsp;&nbsp; 			// In case of a packet and not an error -&gt; =
get the=20
packet (header + payload)<BR>&nbsp;&nbsp;&nbsp; 			printf("Received a =
packet=20
from kernel space");<BR>&nbsp;&nbsp;&nbsp; 			ipq_packet_msg_t *m =3D=20
ipq_get_packet(buf);<BR>		<BR>&nbsp;&nbsp;&nbsp; 			// Print the payload =
of the=20
packet<BR>&nbsp;&nbsp;&nbsp; 			if ( m-&gt;data_len &gt; 0 )=20
{<BR>&nbsp;&nbsp;&nbsp; 				printf("Printing content of=20
packet:\n");</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /* To be included=20
*/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	}<BR>		=
<BR>&nbsp;&nbsp;&nbsp;=20
			// Reinject the packet into kernel space<BR>&nbsp;&nbsp;&nbsp; 			=
status =3D=20
ipq_set_verdict(h, m-&gt;packet_id, NF_ACCEPT, 0, =
NULL);<BR>&nbsp;&nbsp;&nbsp;=20
			if (status &lt; 0)<BR>&nbsp;&nbsp;&nbsp;=20
				die(h);<BR>			<BR>&nbsp;&nbsp;&nbsp; 			break;<BR>&nbsp;&nbsp;&nbsp; =

		}<BR>&nbsp;&nbsp;&nbsp; 		default: {<BR>&nbsp;&nbsp;&nbsp; 			=
fprintf(stderr,=20
"Unknown message type!\n");<BR>&nbsp;&nbsp;&nbsp;=20
			break;<BR>&nbsp;&nbsp;&nbsp; 		}<BR>&nbsp;&nbsp;&nbsp; 	}<BR>&nbsp;=20
}<BR>&nbsp; <BR>&nbsp; printf("Closing down ...\n");<BR>&nbsp; =
<BR>&nbsp; //=20
Cleanup the libipq library<BR>&nbsp; ipq_destroy_handle(h);<BR>&nbsp; =
return=20
EXIT_SUCCESS;<BR>}</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Does anyone have any ideas what i am =
doing wrong? I=20
am using kernel version 2.4.20, and I have also installed the latest =
version of=20
iptables, including the "devel" (header, libraries, ...) part. Thanks in =

advance.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Maarten</FONT></DIV></BODY></HTML>

------=_NextPart_000_004D_01C42E03.0011C280--
