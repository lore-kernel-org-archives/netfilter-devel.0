From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: 2 problems with my net/conntrack helper for MSN
Date: 31 May 2003 02:55:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054342550.961.68.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-epMO5GOf/MDDKRAW/9HE"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-epMO5GOf/MDDKRAW/9HE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I am trying to write a conntrack/NAT helper for MSN Messenger file
transfers, and I am unable to solve two problems at the moment.

Problem 1. Summary: Can I call ip_conntrack_change_expectation()
           from ip_conntrack_msn, and if so, how do I do this properly ?

First, two small examples on how MSN file transfer works:

        Microsoft
       Switchboard
         Servers
        (Internet)
        ^       ^
        |       |
        |       |
       NAT     NAT
       box     box    (MASQUERADE)
        A       B
        |       |
        |       |
       Host    Host
        A       B

When logging into MSN, host A and B initiate a connection
to the MS switchboard servers. 

If A wants to send a file to host B, and B accepts this, 
Host A sends its IP+port to a switchboard server.
On Nat box A, this allows us to set up an expectation
like this:

?:? -> IP_A:port_A

We have no idea what IP may be connecting to host A as
we only have a connection to the switchboard server.

The switchboard server sends that message on to host B,
so NAT box B is able to set up an expectation like this:

IP_B:? -> IP_A:port_A

(where IP_A and port_A can be the public IP of NAT box A
if ip_nat_msn were fully functional yet).

Now imagine a scenario where Host A and B are behind the 
same NAT box:

        Microsoft
       Switchboard
         Servers
        (Internet)
           ^ ^
           | |
           | |
           NAT  (MASQUERADE) 
           box  
          /   \
         /     \
        |       |
       Host    Host
        A       B

Now what happens is, when host A offers its file for download, 
an expectation is created on the NAT box when Host A offers 
the accepted file:

?:? -> IP_A:port_A

But a switchboard server will inform host B that it can
connect to host A to download the file.
ip_conntrack_msn tries to create a second expectation:

IP_B:? -> IP_A:port_A

The ip_conntrack_expect_related() call fails with -EBUSY,
since the expectation clashes with an already existing
expectation "?:? -> IP_A:port_A".
(see help() function in ip_conntrack_msn.c).

Now, my idea is that, if both hosts are behind the same
NAT machine, and the creation of the second expectation 
fails with -EBUSY, the expectation that already exists
should be changed to incorporate the additional information
about the IP address of host B.

In other words, my take on this is:

- (a) If a MASQ box has a host behind it that offers a file,
  it can only set up an expectation with the IP+port
  of the host offering the file. 
- (b) If a MASQ box has a host behind it that will download a 
  file, it can set up an expectation with both IP
  addresses and the TCP port of the offering host.
- (c) If a MASQ box has both sending and receiving hosts
  behind it, but cannot know this beforehand, the 
  chronology should be that:
  - an expectation is set up as in (a)
  - if the expectation setup in (b) fails, the
    existing expectation from (a) should be modified
    from within ip_conntrack_msn to include some
    more information about the host that will download
    a file.

Now, I don't know how to call ip_conntrack_change_expected()
from within a conntracker. More specifically, I don't
know how to get a pointer to the existing expectation
in a clean way (well, I couldn't even get to this info
by copying bits and pieces from ip_conntrack_core.c
since things turned out to be really messy quickly).
What would be the recommended way to do this ?

Note that I'm not the great netfilter hacker I would like
to be, but I just want to contribute something back
every once in a while that hopefully some people may find 
useful, so I hope I'll be able to understand any
possible hints/solutions :-)

Problem 2. Summary: I don't think my NAT helper's "help" function 
           is getting called !? What is happening ?

When I test things in a setup with two machines (192.168.0.10 and 
172.16.0.33) behind a NAT Internet gateway that has a 
simple -j MASQUARADE on the Internet interface, I
get these loggings from ip_conntrack_msn and
ip_nat_msn:

For the first expectation:

ip_conntrack_msn: Direction: ORIG
ip_conntrack_msn: tuple d23191f0: 6 172.16.0.33:32770 ->
207.46.108.52:1863
ip_conntrack_msn: tuple d231920c: 6 207.46.108.52:1863 ->
195.162.210.151:32770
ip_conntrack_msn: Skipping '\r' or '\n' at beginning of payload
ip_conntrack_msn: parse_msn_header(): Entered
ip_conntrack_msn: Leaving next_line() 3540721256 219 3540721237 17
ip_conntrack_msn: Leaving next_line() 3540721306 169 3540721256 48
ip_conntrack_msn: parse_msn_header(): Found an invitation!!
ip_conntrack_msn: Leaving next_line() 3540721308 167 3540721306 0
ip_conntrack_msn: Leaving next_line() 3540721336 139 3540721308 26
ip_conntrack_msn: parse_msn_header(): Found Invitation-Command, accepted
= 1
ip_conntrack_msn: Leaving next_line() 3540721363 112 3540721336 25
ip_conntrack_msn: Leaving next_line() 3540721388 87 3540721363 23
ip_conntrack_msn: parse_msn_header(): Found 'IP-Address: 172.16.0.33'
ip_conntrack_msn: Leaving next_line() 3540721400 75 3540721388 10
ip_conntrack_msn: parse_msn_header(): Found 'Port: 6891'
ip_conntrack_msn: Leaving next_line() 3540721419 56 3540721400 17
ip_conntrack_msn: Leaving next_line() 3540721446 29 3540721419 25
ip_conntrack_msn: Leaving next_line() 3540721473 2 3540721446 25
ip_conntrack_msn: Leaving next_line() 3540721475 0 3540721473 0
ip_conntrack_msn: parce_msn_header(): Returning bytes_todo: 176
ip_conntrack_msn: help(): bytes_todo: 176 - accepted: 1 - address:
172.16.0.33 - port: 6891
ip_conntrack_msn: help(): 172.16.0.33:6891 offers file in ORIG at
offsets 139 and 158
ip_conntrack_msn: help(): Adding expectation ?:? -> 172.16.0.33:6891
ip_conntrack_msn: help(): ip_conntrack_expect_related() returned 0

And for the second expectation:

ip_conntrack_msn: Direction: REPLY
ip_conntrack_msn: tuple d2319830: 6 192.168.0.10:33021 ->
207.46.108.52:1863
ip_conntrack_msn: tuple d231984c: 6 207.46.108.52:1863 ->
195.162.210.151:33021
ip_conntrack_msn: parse_msn_header(): Entered
ip_conntrack_msn: Leaving next_line() 3540721287 238 3540721224 61
ip_conntrack_msn: Leaving next_line() 3540721306 219 3540721287 17
ip_conntrack_msn: Leaving next_line() 3540721356 169 3540721306 48
ip_conntrack_msn: parse_msn_header(): Found an invitation!!
ip_conntrack_msn: Leaving next_line() 3540721358 167 3540721356 0
ip_conntrack_msn: Leaving next_line() 3540721386 139 3540721358 26
ip_conntrack_msn: parse_msn_header(): Found Invitation-Command, accepted
= 1
ip_conntrack_msn: Leaving next_line() 3540721413 112 3540721386 25
ip_conntrack_msn: Leaving next_line() 3540721438 87 3540721413 23
ip_conntrack_msn: parse_msn_header(): Found 'IP-Address: 172.16.0.33'
ip_conntrack_msn: Leaving next_line() 3540721450 75 3540721438 10
ip_conntrack_msn: parse_msn_header(): Found 'Port: 6891'
ip_conntrack_msn: Leaving next_line() 3540721469 56 3540721450 17
ip_conntrack_msn: Leaving next_line() 3540721496 29 3540721469 25
ip_conntrack_msn: Leaving next_line() 3540721523 2 3540721496 25
ip_conntrack_msn: Leaving next_line() 3540721525 0 3540721523 0
ip_conntrack_msn: parce_msn_header(): Returning bytes_todo: -31
ip_conntrack_msn: help(): bytes_todo: 65505 - accepted: 1 - address:
172.16.0.33 - port: 6891
ip_conntrack_msn: help(): 172.16.0.33:6891 offers file in REPLY at
offsets 201 and 220
ip_conntrack_msn: help(): Adding expectation 192.168.0.10:? ->
172.16.0.33:6891
ip_conntrack_msn: help(): ip_conntrack_expect_related() returned -16

Then I have:

ip_conntrack_msn: Direction: ORIG
ip_conntrack_msn: tuple d2319830: 6 192.168.0.10:33021 ->
207.46.108.52:1863
ip_conntrack_msn: tuple d231984c: 6 207.46.108.52:1863 ->
195.162.210.151:33021
ip_conntrack_msn: Skipping '\r' or '\n' at beginning of payload
ip_conntrack_msn: Leaving next_line() 3354879790 4294967226 3354879721
67
ip_conntrack_msn: parse_msn_command(): After next_line():
ip_nat_msn: msn_nat_expected: We have a connection!
ip_nat_msn: msn_nat_expected: We have a connection!

What I do not understand at all is that the ip_nat_msn's
module help() function has this statement:

DEBUGP("ip_nat_msn: msn_nat_help(): Entered\n");

at the beginning of the function, but it appears to
never get called, even though ip_nat_msn is loaded.
Yet, there are two messages logged from the ip_nat_expected()
function in the NAT helper.
I have absolutely no idea why I cannot see any
logging messages from the NAT module's help() function...

I hope someone can give me some ideas/hints on how to
solve these problems.


Thanks in advance,
Filip

Note that for people who want to test this conntracker,
there is at least one MSN client under Linux: amsn.
It's the client used by my while writing this. Despite
my problems described above, the conntrack part of the
code should actually work in practise (still some bugs to 
fix though (most importantly the bytes_todo counter
that is supposed to track messages spread over multiple 
packets is not decremented correctly!)...).


--=-epMO5GOf/MDDKRAW/9HE
Content-Disposition: attachment; filename=diff.netfilter.msn.20030531-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.netfilter.msn.20030531-1; charset=ANSI_X3.4-1968

diff -urN -X dontdiff linux-2.4.20-orig/Documentation/Configure.help linux-=
2.4.20-msn/Documentation/Configure.help
--- linux-2.4.20-orig/Documentation/Configure.help	2002-11-29 00:53:08.0000=
00000 +0100
+++ linux-2.4.20-msn/Documentation/Configure.help	2003-05-25 03:12:09.00000=
0000 +0200
@@ -2508,6 +2508,16 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+MSN Messenger protocol support
+CONFIG_IP_NF_MSN
+  Tracking MSN Messenger file transfers is problematic:  a special=20
+  helper is needed to track the random ports are used to send the=20
+  files. This option allows users to track MSN Messenger file=20
+  transfer traffic.
+
+  If you want to compile it as a module, say M here and read
+  <file:Documentation/modules.txt>.  If unsure, say `Y'.
+
 IRC Send/Chat protocol support
 CONFIG_IP_NF_IRC
   There is a commonly-used extension to IRC called
diff -urN -X dontdiff linux-2.4.20-orig/Makefile linux-2.4.20-msn/Makefile
--- linux-2.4.20-orig/Makefile	2002-11-29 00:53:16.000000000 +0100
+++ linux-2.4.20-msn/Makefile	2003-05-25 03:12:09.000000000 +0200
@@ -1,7 +1,7 @@
 VERSION =3D 2
 PATCHLEVEL =3D 4
 SUBLEVEL =3D 20
-EXTRAVERSION =3D
+EXTRAVERSION =3D -msn
=20
 KERNELRELEASE=3D$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
=20
diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_con=
ntrack.h linux-2.4.20-msn/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_conntrack.h	2003-05-0=
4 04:53:30.000000000 +0200
+++ linux-2.4.20-msn/include/linux/netfilter_ipv4/ip_conntrack.h	2003-05-25=
 04:42:21.000000000 +0200
@@ -58,12 +58,14 @@
 };
=20
 /* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_msn.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
=20
 /* per expectation: application helper private data */
 union ip_conntrack_expect_help {
 	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_msn_expect exp_msn_info;
 	struct ip_ct_ftp_expect exp_ftp_info;
 	struct ip_ct_irc_expect exp_irc_info;
=20
@@ -77,6 +79,7 @@
 /* per conntrack: application helper private data */
 union ip_conntrack_help {
 	/* insert conntrack helper private data (master) here */
+	struct ip_ct_msn_master ct_msn_info;
 	struct ip_ct_ftp_master ct_ftp_info;
 	struct ip_ct_irc_master ct_irc_info;
 };
diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_con=
ntrack_msn.h linux-2.4.20-msn/include/linux/netfilter_ipv4/ip_conntrack_msn=
.h
--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ip_conntrack_msn.h	1970-=
01-01 01:00:00.000000000 +0100
+++ linux-2.4.20-msn/include/linux/netfilter_ipv4/ip_conntrack_msn.h	2003-0=
5-25 04:42:21.000000000 +0200
@@ -0,0 +1,27 @@
+#ifndef _IP_CONNTRACK_MSN_H
+#define _IP_CONNTRACK_MSN_H
+/* MSN Messenger tracking. */
+
+#ifdef __KERNEL__
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+DECLARE_LOCK_EXTERN(ip_msn_lock);
+
+#define MSN_PORT                         1863
+#endif
+
+/* This structure is per expected connection */
+struct ip_ct_msn_expect {
+	u_int16_t port;            /* port number of this expectation */
+	u_int16_t offset_address;  /* offset of embedded IP address in packet */
+	u_int16_t length_address;  /* length of embedded IP address in packet */
+	u_int16_t offset_port;     /* offset of embedded port number in packet */
+	u_int16_t length_port;     /* length of embedded port number in packet */
+};
+
+/* This structure exists only once per master */
+struct ip_ct_msn_master {
+	u_int16_t bytes_todo;      /* if message is split over multiple packets *=
/
+};
+
+#endif /* _IP_CONNTRACK_MSN_H */
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/Config.in linux-=
2.4.20-msn/net/ipv4/netfilter/Config.in
--- linux-2.4.20-orig/net/ipv4/netfilter/Config.in	2002-11-29 00:53:15.0000=
00000 +0100
+++ linux-2.4.20-msn/net/ipv4/netfilter/Config.in	2003-05-25 03:12:09.00000=
0000 +0200
@@ -8,6 +8,7 @@
 if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
   dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
   dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  MSN Messenger protocol support' CONFIG_IP_NF_MSN $CONFIG=
_IP_NF_CONNTRACK
 fi
=20
 if [ "$CONFIG_EXPERIMENTAL" =3D "y" ]; then
@@ -67,6 +68,13 @@
           define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
         fi
       fi
+      if [ "$CONFIG_IP_NF_MSN" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_MSN m
+      else
+        if [ "$CONFIG_IP_NF_MSN" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_MSN $CONFIG_IP_NF_NAT
+        fi
+      fi
       # If they want FTP, set to $CONFIG_IP_NF_NAT (m or y),=20
       # or $CONFIG_IP_NF_FTP (m or y), whichever is weaker.  Argh.
       if [ "$CONFIG_IP_NF_FTP" =3D "m" ]; then
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/Makefile linux-2=
.4.20-msn/net/ipv4/netfilter/Makefile
--- linux-2.4.20-orig/net/ipv4/netfilter/Makefile	2002-11-29 00:53:15.00000=
0000 +0100
+++ linux-2.4.20-msn/net/ipv4/netfilter/Makefile	2003-05-25 03:12:09.000000=
000 +0200
@@ -32,6 +32,10 @@
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
=20
 # connection tracking helpers
+obj-$(CONFIG_IP_NF_MSN) +=3D ip_conntrack_msn.o
+ifdef CONFIG_IP_NF_NAT_MSN
+	export-objs +=3D ip_conntrack_msn.o
+endif
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o
 ifdef CONFIG_IP_NF_NAT_FTP
 	export-objs +=3D ip_conntrack_ftp.o
@@ -45,6 +49,7 @@
 # NAT helpers=20
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_MSN) +=3D ip_nat_msn.o
=20
 # generic IP tables=20
 obj-$(CONFIG_IP_NF_IPTABLES) +=3D ip_tables.o
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_conntrack_msn=
.c linux-2.4.20-msn/net/ipv4/netfilter/ip_conntrack_msn.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ip_conntrack_msn.c	1970-01-01 01:0=
0:00.000000000 +0100
+++ linux-2.4.20-msn/net/ipv4/netfilter/ip_conntrack_msn.c	2003-05-31 02:53=
:10.000000000 +0200
@@ -0,0 +1,509 @@
+/* MSN Messenger extension for IP connection tracking
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_conntrack_ftp.c and ip_conntrack_irc.c
+ *
+ * ip_conntrack_msn.c v0.01 2002-10-29
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_conntrack_msn.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MSN Messenger servers You wish to=20
+ *      connect to. If you don't specify ports, the default will be TCP=20
+ *      port 1863.
+ *
+ *      More info on MSN Messenger protocol:
+ *      http://www.hypothetic.org/docs/msn/index.php
+ *      http://www.hypothetic.org/docs/msn/ietf_draft.php
+ *      http://www.venkydude.com/articles/msn.htm
+ */
+
+#include <linux/config.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/ip.h>
+#include <linux/ctype.h>
+#include <net/checksum.h>
+#include <net/tcp.h>
+
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+#include <linux/netfilter_ipv4/ip_conntrack_msn.h>
+
+DECLARE_LOCK(ip_msn_lock);
+struct module *ip_conntrack_msn =3D THIS_MODULE;
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of MSN Messenger servers");
+#endif
+
+#if 1=20
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft MSN Messenger connection tracking module");
+MODULE_LICENSE("GPL");
+
+/* #define isdigit(c) (c >=3D '0' && c <=3D '9') */
+
+__inline static int atoin(char *s, unsigned int n)=20
+{
+	int i=3D0;
+	while (isdigit(*s) && n) {
+		i =3D i*10 + *(s++) - '0';
+		--n;
+	}
+	return i;
+}
+
+/* convert ip address string like "192.168.0.10" to unsigned int */
+__inline static u_int32_t asciiiptoi(char *s)
+{
+	unsigned int i, j, k;
+
+	for(i=3Dk=3D0; k<3; ++k, ++s, i<<=3D8) {
+		i+=3Datoin(s, 3);
+		for(j=3D0; (*(++s) !=3D '.') && (j<3); ++j)
+			;
+	}
+	i+=3Datoin(s, 3);
+	return ntohl(i);
+}
+
+int next_line(char **ppbuf, unsigned int *pbuflen, char **ppline, unsigned=
 int *plinelen)
+{
+	char *pbuf =3D *ppbuf;
+	unsigned int buflen =3D *pbuflen;
+	unsigned int linelen =3D 0;
+
+	if(*ppbuf =3D=3D NULL) {
+		DEBUGP("ip_conntrack_msn: Bailing out of next_line()\n");
+		return 0;
+	}
+
+	/* Skip '\n' or '\r' chars in beginning */
+/*
+	while(*pbuf =3D=3D '\r' || *pbuf =3D=3D '\n') {
+		if ( buflen <=3D 1 ) {
+			*ppline =3D *ppbuf;
+			*plinelen =3D ++linelen;
+			*ppbuf =3D NULL;
+			*pbuflen =3D 0;
+
+			return linelen;
+		}
+		pbuf++;
+		linelen++;
+		buflen--;
+	}
+*/
+=09
+	do {
+		while ( *pbuf !=3D '\r' && *pbuf !=3D '\n' ) {
+			if ( buflen <=3D 1 ) {
+				/* It's possible that string is at end of packet
+				 * without a \r\n sequence at the end. In that case,
+				 * return correct values so parsing can continue
+				 */
+				*ppline =3D *ppbuf;
+				*plinelen =3D ++linelen;
+				*ppbuf =3D NULL;
+				*pbuflen =3D 0;
+			=09
+				return linelen;
+			}
+			pbuf++;
+			linelen++;
+			buflen--;
+		}
+
+		if( buflen > 1 && *pbuf =3D=3D '\r' && *(pbuf+1) =3D=3D '\n' ) {
+			pbuf++;
+			buflen--;
+		}
+
+		pbuf++;
+		buflen--;
+	} while ( buflen > 0 && (*pbuf =3D=3D ' ' || *pbuf =3D=3D '\t') );
+=09
+	*ppline =3D *ppbuf;
+	*plinelen =3D linelen;
+	*ppbuf =3D pbuf;
+	*pbuflen =3D buflen;
+
+	DEBUGP("ip_conntrack_msn: Leaving next_line() %u %u %u %u\n",
+	       (unsigned int)*ppbuf, *pbuflen, (unsigned int)*ppline, *plinelen);
+=09
+	return linelen;
+}
+
+unsigned int parse_msn_command(char **pdata, unsigned int *pdatalen,=20
+			       char **ppline, unsigned int *plinelen,=20
+			       unsigned int end_of_packet)
+{
+	unsigned int msglen;
+	char *orig_data =3D *pdata;
+=09
+	if(!next_line(pdata, pdatalen, ppline, plinelen))
+		return 0;
+
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): After next_line():\n");
+=09
+	/* Look for "MSG <seqno> <v> <mimelen>" */
+	if(memcmp(*ppline, "MSG ", 4) !=3D 0)=20
+		return 0;
+	*ppline +=3D 4;
+=09
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): Got a MSG\n");
+=09
+	if(!isdigit(**ppline))
+		return 0;
+	while(isdigit(**ppline))
+		(*ppline)++;
+	if(**ppline !=3D ' ')
+		return 0;
+=09
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): Got a seq no\n");
+=09
+	(*ppline)++;
+	if(!isalpha(**ppline))
+		return 0;
+	(*ppline)++;
+	if(**ppline !=3D ' ')
+		return 0;
+=09
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): Got alphanumeric chars\n")=
;
+=09
+	(*ppline)++;
+	if(!isdigit(**ppline))
+		return 0;
+		=09
+	/* because "MSG ..." can be at end of packet with no \0
+	 * at the end, we must limit atoi conversion to end-of-packet
+	 * */
+	msglen =3D atoin(*ppline, end_of_packet - (unsigned int)*ppline);
+	while(isdigit(**ppline))
+		(*ppline)++;
+
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): %s\n", orig_data);
+	DEBUGP("ip_conntrack_msn: parse_msn_command(): msglen =3D %u\n", msglen);
+	      =20
+	return msglen;
+}
+
+unsigned int parse_msn_header(char **pdata, unsigned int *pdatalen,
+			      char **ppline, unsigned int *plinelen,
+			      unsigned int *paccepted, u_int32_t *paddress,
+			      u_int16_t *pport, unsigned int bytes_todo,
+			      unsigned int *poffset_address,
+			      unsigned int *poffset_port, unsigned int constdata)
+{
+	unsigned int isinvite =3D 0;
+
+	DEBUGP("ip_conntrack_msn: parse_msn_header(): Entered\n");
+=09
+	/* FIXME count down bytes_todo correctly */
+=09
+	/* Parse MIME headers */
+	while(next_line(pdata, pdatalen, ppline, plinelen)) {
+		if(*plinelen=3D=3D0)
+			break;
+		if(memcmp(*ppline, "Content-Type:", 13) =3D=3D 0) {
+			*ppline +=3D 13;
+			bytes_todo -=3D 13;
+			while( **ppline =3D=3D ' ') {
+				(*ppline)++;
+				bytes_todo--;
+			}
+			if(memcmp(*ppline, "text/x-msmsgsinvite;", 20) =3D=3D 0) {
+				DEBUGP("ip_conntrack_msn: parse_msn_header(): Found an invitation!!\n"=
);
+				isinvite =3D 1;
+				bytes_todo -=3D 20;
+			}
+		}
+	}
+=09
+	if(!isinvite)
+		return bytes_todo;
+=09
+	/* parse entity for accept, IP address, port */
+	while(next_line(pdata, pdatalen, ppline, plinelen)) {
+
+/*		DEBUGP("ip_conntrack_msn: Checking %s\n", *ppline); */
+	=09
+		if(memcmp(*ppline, "Invitation-Command:", 19) =3D=3D 0) {
+			DEBUGP("ip_conntrack_msn: parse_msn_header(): Found Invitation-Command,=
 ");
+			*ppline +=3D 19;
+			while(**ppline =3D=3D ' ')
+				(*ppline)++;
+			if(memcmp(*ppline, "ACCEPT", 6) =3D=3D 0)
+				*paccepted =3D 1;
+			DEBUGP("accepted =3D %u\n", *paccepted);
+		}
+		if(memcmp(*ppline, "IP-Address:", 11) =3D=3D 0) {
+			*ppline +=3D 11;
+			while(**ppline =3D=3D ' ')
+				(*ppline)++;
+			if(!*paddress) {
+				*paddress =3D asciiiptoi(*ppline);
+				*poffset_address =3D (unsigned int)(*ppline) - constdata;
+			}
+			DEBUGP("ip_conntrack_msn: parse_msn_header(): Found 'IP-Address: %u.%u.=
%u.%u'\n",
+			       NIPQUAD(*paddress));
+		}
+		if(memcmp(*ppline, "IP-Address-Internal:", 20) =3D=3D 0) {=20
+			/* MSN 5.0 has this - maybe earlier versions too ?=20
+			 * If this is present, this is the internal IP address
+			 * and "IP-Address" has the external address if behind
+			 * a MASQUERADE box ... We need this address instead
+			 * of "IP-Address" to set up the expectation. */
+			*ppline +=3D 20;
+			while(**ppline =3D=3D ' ')
+				(*ppline)++;
+			*paddress =3D asciiiptoi(*ppline);
+			*poffset_address =3D (unsigned int)(*ppline) - constdata;
+			DEBUGP("ip_conntrack_msn: parse_msn_header(): Found 'IP-Address-Interna=
l: %u.%u.%u.%u'\n",
+			       NIPQUAD(*paddress));
+		}
+		if(memcmp(*ppline, "Port:", 5) =3D=3D 0) {
+			*ppline +=3D 5;
+			while(**ppline =3D=3D ' ')
+				(*ppline)++;
+			*pport =3D atoin(*ppline, 5);
+			*poffset_port =3D (unsigned int)(*ppline) - constdata;
+			DEBUGP("ip_conntrack_msn: parse_msn_header(): Found 'Port: %u'\n", *ppo=
rt);
+		}
+		/* MSN 5.0 (possibly other versions too) also has "PortX:" and=20
+		 * "PortX-Internal"; what the hell are those all about ? */
+	}
+
+	DEBUGP("ip_conntrack_msn: parce_msn_header(): Returning bytes_todo: %d\n"=
, bytes_todo);
+	return bytes_todo; /* FIXME this is crap !! value must have reached 0
+	                    * by now
+			    * */
+}
+
+/* FIXME: This should be in userspace.  Later. */
+static int help(const struct iphdr *iph, size_t len,
+		struct ip_conntrack *ct,
+		enum ip_conntrack_info ctinfo)
+{
+	/* tcplen not negative guaranteed by ip_conntrack_tcp.c */
+	struct tcphdr *tcph =3D (void *)iph + iph->ihl * 4;
+	char *data =3D (char *)tcph + tcph->doff * 4;
+	const char *constdata =3D data;
+	unsigned int tcplen =3D len - iph->ihl * 4;
+	unsigned int datalen =3D tcplen - tcph->doff * 4;
+	int i, dir =3D CTINFO2DIR(ctinfo);
+	struct ip_conntrack_expect expect, *exp =3D &expect;=20
+	struct ip_ct_msn_expect *exp_msn_info =3D &exp->help.exp_msn_info;
+	struct ip_ct_msn_master *info =3D &ct->help.ct_msn_info;
+	char *pline;
+	unsigned int linelen;
+	unsigned int accepted =3D 0;
+	u_int32_t address =3D 0;
+	u_int16_t port =3D 0;
+	unsigned int offset_address =3D 0;
+	unsigned int offset_port =3D 0;
+	=20
+	/* Can't track connections formed before we registered */
+	if (!info)
+		return NF_ACCEPT;
+
+	if(ctinfo =3D=3D IP_CT_NEW) {
+		DEBUGP("ip_conntrack_msn: NEW packet, not tracking\n");
+		return NF_ACCEPT;
+	}
+=09
+	/* Not whole TCP header? */
+	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff*4) {
+		DEBUGP("ip_conntrack_msn: tcplen =3D %u\n", (unsigned)tcplen);
+		return NF_ACCEPT;
+	}
+
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+	    csum_partial((char *)tcph, tcplen, 0))) {
+		DEBUGP("ip_conntrack_msn: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
+		       tcph, tcplen, NIPQUAD(iph->saddr),
+		       NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
+=09
+/*	DEBUGP("%s", data); */
+
+	DEBUGP("ip_conntrack_msn: Direction: %s\n", dir =3D=3D IP_CT_DIR_ORIGINAL=
 ? "ORIG" : "REPLY");=20
+	DEBUGP("ip_conntrack_msn: ");
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	DEBUGP("ip_conntrack_msn: ");
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+=09
+	/* FIXME info->bytes_todo must be initialized =3D 0 */
+
+	/* Skip '\n' and '\r' */
+	while(*data =3D=3D '\n' || *data =3D=3D '\r') {
+		DEBUGP("ip_conntrack_msn: Skipping '\\r' or '\\n' at beginning of payloa=
d\n");
+		if(datalen <=3D 1) {
+			--datalen;
+			++data;
+			break;
+		}
+		--datalen;
+		++data;
+	}
+=09
+	LOCK_BH(&ip_msn_lock);
+	if(!info->bytes_todo)
+		info->bytes_todo =3D parse_msn_command(&data, &datalen, &pline, &linelen=
,=20
+				   (unsigned int)tcph + (unsigned int)tcplen);
+=09
+	if(!info->bytes_todo) {
+		UNLOCK_BH(&ip_msn_lock);
+		return NF_ACCEPT;
+	}
+=09
+	info->bytes_todo =3D parse_msn_header(&data, &datalen, &pline, &linelen,=20
+					    &accepted, &address, &port,=20
+					    info->bytes_todo, &offset_address,
+					    &offset_port, (unsigned int)constdata);
+
+	DEBUGP("ip_conntrack_msn: help(): bytes_todo: %d - accepted: %d - "
+	       "address: %u.%u.%u.%u - port: %u\n",
+	       info->bytes_todo, accepted, NIPQUAD(address), port);
+=09
+	if(!accepted || !address || !port) {
+		UNLOCK_BH(&ip_msn_lock);
+		return NF_ACCEPT;
+	}
+
+	DEBUGP("ip_conntrack_msn: help(): %u.%u.%u.%u:%u offers file in %s at off=
sets %u and %u\n",
+	       NIPQUAD(address), port, dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "=
REPLY",=20
+	       offset_address, offset_port);
+=09
+	memset(&expect, 0, sizeof(expect));
+
+	if(dir =3D=3D IP_CT_DIR_ORIGINAL) {
+		DEBUGP("ip_conntrack_msn: help(): Adding expectation ?:? -> %u.%u.%u.%u:=
%u\n",
+		       NIPQUAD(address), port);
+
+		exp->tuple =3D ((struct ip_conntrack_tuple)
+		              { { 0, { 0 } },
+			      { address,
+			        { (__u16) ntohs(port) },
+			        IPPROTO_TCP } }
+		             );
+		exp->mask =3D ((struct ip_conntrack_tuple)
+		             { { 0, { 0 } },
+			     { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF } }
+			     );
+	} else {
+		exp_msn_info->port =3D port;
+		exp_msn_info->offset_address =3D offset_address;
+		exp_msn_info->offset_port =3D offset_port;
+	=09
+		/* exp->seq =3D ? */
+		DEBUGP("ip_conntrack_msn: help(): Adding expectation %u.%u.%u.%u:? -> %u=
.%u.%u.%u:%u\n",
+		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip), NIPQUAD(address), port=
);
+=09
+		exp->tuple =3D ((struct ip_conntrack_tuple)
+		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
+			      { address,
+			        { (__u16) ntohs(port) },
+				IPPROTO_TCP } }
+			     );
+		exp->mask =3D ((struct ip_conntrack_tuple)
+		              { { 0xFFFFFFFF, { 0 } },
+			      { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF } }
+			    );
+	}
+	exp->expectfn =3D NULL;
+	i=3Dip_conntrack_expect_related(ct, &expect);
+=09
+	DEBUGP("ip_conntrack_msn: help(): ip_conntrack_expect_related() returned =
%d\n", i);
+=09
+	/* FIXME count properly - don't tell mummy */
+	info->bytes_todo =3D 0;
+
+	UNLOCK_BH(&ip_msn_lock);
+=09
+	return NF_ACCEPT;
+}
+
+static struct ip_conntrack_helper msn[MAX_PORTS];
+static char msn_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0; (i < ports_c) && ports[i]; i++) {
+		DEBUGP("ip_conntrack_msn: Unregistering MSN conntrack helper for port %d=
\n",
+				ports[i]);
+		ip_conntrack_helper_unregister(&msn[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MSN_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+	=09
+		memset(&msn[i], 0, sizeof(struct ip_conntrack_helper));
+
+		msn[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		msn[i].mask.dst.protonum =3D 0xFFFF;
+		msn[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		msn[i].mask.src.u.tcp.port =3D 0xFFFF;
+		msn[i].max_expected =3D 1;
+		msn[i].timeout =3D 0;
+		msn[i].flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
+		msn[i].me =3D THIS_MODULE;
+		msn[i].help =3D help;
+
+		tmpname =3D &msn_names[i][0];
+		if (ports[i] =3D=3D MSN_PORT)
+			sprintf(tmpname, "msn");
+		else
+			sprintf(tmpname, "msn-%d", ports[i]);
+		msn[i].name =3D tmpname;
+
+		DEBUGP("ip_conntrack_msn: Registering MSN conntrack helper for port %d\n=
",=20
+		       ports[i]);
+		ret =3D ip_conntrack_helper_register(&msn[i]);
+
+		if (ret) {
+			printk("ip_conntrack_msn: Error registering MSN conntrack "
+			       "helper for port %d\n", ports[i]);
+			fini();
+			return ret;
+		}
+
+		ports_c++;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+EXPORT_SYMBOL(ip_msn_lock);
+#endif
+
+module_init(init);
+module_exit(fini);
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_msn.c lin=
ux-2.4.20-msn/net/ipv4/netfilter/ip_nat_msn.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ip_nat_msn.c	1970-01-01 01:00:00.0=
00000000 +0100
+++ linux-2.4.20-msn/net/ipv4/netfilter/ip_nat_msn.c	2003-05-27 04:47:36.00=
0000000 +0200
@@ -0,0 +1,207 @@
+/* MSN Messenger extension for TCP NAT alteration.
+ * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
+ * based on ip_nat_ftp.c and ip_nat_irc.c
+ *
+ * ip_nat_msn.c v0.01 2002-10-29
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Module load syntax:
+ *      insmod ip_nat_msn.o ports=3Dport1,port2,...port<MAX_PORTS>
+ *
+ *      Please give the ports of all MSN Messenger servers You wish to=20
+ *      connect to. If you don't specify ports, the default will be TCP=20
+ *      port 1863.
+ *
+ *      More info on MSN Messenger protocol:
+ *      http://www.hypothetic.org/docs/msn/index.php
+ *      http://www.hypothetic.org/docs/msn/ietf_draft.php
+ *      http://www.venkydude.com/articles/msn.htm
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <net/tcp.h>
+#include <linux/netfilter_ipv4/ip_nat.h>
+#include <linux/netfilter_ipv4/ip_nat_helper.h>
+#include <linux/netfilter_ipv4/ip_nat_rule.h>
+#include <linux/netfilter_ipv4/ip_conntrack_msn.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+
+#if 1=20
+#define DEBUGP printk
+#define DUMP_BYTES(address, counter)                                \
+({                                                                  \
+	int temp_counter;                                           \
+	for(temp_counter=3D0; temp_counter<counter; ++temp_counter) { \
+		DEBUGP("%u ", (u8)*(address+temp_counter));         \
+	};                                                          \
+	DEBUGP("\n");                                               \
+})
+#else
+#define DEBUGP(format, args...)
+#define DUMP_BYTES(address, counter)
+#endif
+
+#define MAX_PORTS 8
+static int ports[MAX_PORTS];
+static int ports_c =3D 0;
+
+#ifdef MODULE_PARM
+MODULE_PARM(ports, "1-" __MODULE_STRING(MAX_PORTS) "i");
+MODULE_PARM_DESC(ports, "port numbers of MSN Messenger servers");
+#endif
+
+MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
+MODULE_DESCRIPTION("Microsoft MSN Messenger NAT helper");
+MODULE_LICENSE("GPL");
+
+DECLARE_LOCK_EXTERN(ip_msn_lock);
+
+/* FIXME: Time out? --RR */
+
+static unsigned int
+msn_nat_expected(struct sk_buff **pskb,
+                 unsigned int hooknum,
+                 struct ip_conntrack *ct,
+                 struct ip_nat_info *info)
+{
+	struct ip_nat_multi_range mr;
+	u_int32_t newdstip, newsrcip, newip;
+
+	struct ip_conntrack *master =3D master_ct(ct);
+
+	IP_NF_ASSERT(info);
+	IP_NF_ASSERT(master);
+
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
+
+	DEBUGP("ip_nat_msn: msn_nat_expected: We have a connection!\n");
+
+	return ip_nat_setup_info(ct, &mr, hooknum);
+}
+
+
+static unsigned int help(struct ip_conntrack *ct,
+			 struct ip_conntrack_expect *exp,
+			 struct ip_nat_info *info,
+			 enum ip_conntrack_info ctinfo,
+			 unsigned int hooknum,
+			 struct sk_buff **pskb)
+{
+	struct iphdr *iph =3D (*pskb)->nh.iph;
+	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
+	unsigned int datalen;
+	int dir =3D CTINFO2DIR(ctinfo);
+	struct ip_ct_msn_expect *ct_msn_info;
+
+	DEBUGP("ip_nat_msn: msn_nat_help(): Entered\n");
+=09
+	if (!exp)
+		DEBUGP("ip_nat_msn: no exp!!");
+
+	ct_msn_info =3D &exp->help.exp_msn_info;
+=09
+	DEBUGP("ip_nat_msn: msn_nat_help(): direction %s, hook %s\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG":"REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
+	/* Only mangle things once: original direction in POST_ROUTING
+	   and reply direction on PRE_ROUTING. */
+	dir =3D CTINFO2DIR(ctinfo);
+	if (!((hooknum =3D=3D NF_IP_POST_ROUTING && dir =3D=3D IP_CT_DIR_ORIGINAL=
)
+	    ||(hooknum =3D=3D NF_IP_PRE_ROUTING && dir =3D=3D IP_CT_DIR_REPLY))) =
{
+		DEBUGP("ip_nat_msn: msn_nat_help: not touching dir %s at hook %s\n",
+		       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+		       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+		       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+		       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+		return NF_ACCEPT;
+	}
+	DEBUGP("ip_nat_msn: msn_nat_help: beyond not touching (dir %s at hook %s)=
\n",
+	       dir =3D=3D IP_CT_DIR_ORIGINAL ? "ORIG" : "REPLY",
+	       hooknum =3D=3D NF_IP_POST_ROUTING ? "POSTROUTING"
+	       : hooknum =3D=3D NF_IP_PRE_ROUTING ? "PREROUTING"
+	       : hooknum =3D=3D NF_IP_LOCAL_OUT ? "OUTPUT" : "???");
+=09
+	datalen =3D (*pskb)->len - iph->ihl * 4 - tcph->doff * 4;
+=09
+	DEBUGP("ip_nat_msn: msn_nat_help: %u+%u=3D%u %u %u\n", exp->seq, ct_msn_i=
nfo->length_address,
+	       exp->seq + ct_msn_info->length_address,
+	       ntohl(tcph->seq),
+	       ntohl(tcph->seq) + datalen);
+=09
+	return NF_ACCEPT;
+}
+
+static struct ip_nat_helper msn[MAX_PORTS];
+static char msn_names[MAX_PORTS][10];
+
+/* Not __exit: called from init() */
+static void fini(void)
+{
+	int i;
+
+	for (i =3D 0; (i < ports_c) && ports[i]; i++) {
+		DEBUGP("ip_nat_msn: Unregistering MSN NAT helper for port %d\n",=20
+		       ports[i]);
+		ip_nat_helper_unregister(&msn[i]);
+	}
+}
+
+static int __init init(void)
+{
+	int i, ret =3D 0;
+	char *tmpname;
+
+	if (ports[0] =3D=3D 0)
+		ports[0] =3D MSN_PORT;
+
+	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
+
+		memset(&msn[i], 0, sizeof(struct ip_nat_helper));
+
+		msn[i].tuple.dst.protonum =3D IPPROTO_TCP;
+		msn[i].tuple.src.u.tcp.port =3D htons(ports[i]);
+		msn[i].mask.dst.protonum =3D 0xFFFF;
+		msn[i].mask.src.u.tcp.port =3D 0xFFFF;
+		msn[i].help =3D help;
+		msn[i].me =3D THIS_MODULE;
+		msn[i].flags =3D 0;
+		msn[i].expect =3D msn_nat_expected;
+
+		tmpname =3D &msn_names[i][0];
+		if (ports[i] =3D=3D MSN_PORT)
+			sprintf(tmpname, "msn");
+		else
+			sprintf(tmpname, "msn-%d", i);
+		msn[i].name =3D tmpname;
+
+		DEBUGP("ip_nat_msn: Registering MSN NAT helper for port %d\n",
+		       ports[i]);
+		ret =3D ip_nat_helper_register(&msn[i]);
+
+		if (ret) {
+			printk("ip_nat_msn: Error registering MSN NAT "
+			       "helper for port %d\n", ports[i]);
+			fini();
+			return ret;
+		}
+
+		ports_c++;
+	}
+
+	return ret;
+}
+
+module_init(init);
+module_exit(fini);

--=-epMO5GOf/MDDKRAW/9HE--
