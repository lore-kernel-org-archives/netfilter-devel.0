From: Andre Marais <andre.marais@secureworx.com>
Subject: [PATCH] ip_conntrack_ftp.c
Date: 11 Nov 2002 14:23:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1037017388.5688.143.camel@lightning>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-wTJ5wDzjYiV3TYKX0zzt"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: NETFILTER development <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-wTJ5wDzjYiV3TYKX0zzt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Netfilter team,

CERT has published a vulnerability related to poor ftp state tracking
where arbitrary connections could be established to machines behind a
firewall with FTP connection tracking enabled (CERT VU#328867).

Although the netfilter code as it stands now does not allow this to
happen with sane FTP servers, I fear that a poor implementation or
completely broken (or hacked) FTP server could render the firewall
useless.

I have generated a patch against linux 2.4.18 that does bi-directional
state tracking (based on a patch for 2.4.0 by Jozsef Kadlecsik) and does
more explicit checks.

Feedback would be much appreciated, but please mail me directly since
I'm not on the mailing list.

Regards,
Andre

-- 
Andre Marais
SecureWorx (Pty) Ltd.
Development Engineer
+27-82-645-5889
www.secureworx.com

Reading, after a certain age, diverts the mind too much from its 
creative pursuits. Any man who read too much and uses his own brain 
too little falls into lazy habits of thinking.
 - Albert Einstein.

-----------------------------------------------------------------------
LEGAL DISCLAIMER:
The views or representations contained in this message, whether express
or implied, are those of the sender only, unless that sender expressly
states them to be the view or representations of an entity or person,
who shall be named by the sender and the sender shall state to
represent. No liability shall otherwise attach to any other entity or
person.
-----------------------------------------------------------------------

Established in 1995, SECUREWORX South Africa (Pty) Ltd
(www.SECUREWORX.com), SECUREWORX designs, develops, manufactures and
sells Internet security infrastructure solutions that secure information
assets and enable privacy and security for e-Business and m-Business
communications.
 
SECUREWORX is a pioneer in the creation of plug-and-protect all-in-one
Gateway Security solutions for customers in small offices/home offices
(SOHO's), Small Medium Enterprise (SME), Remote Office Branch Office
(ROBO), SME headquarters', telecommuters and mobile workers, Data
Centres, Education and Government markets - particularly those using
"always-on" broadband internet connections which includes Satellite,
Digital Subscriber Line (DSL), and cable modem users (collectively, our
target market).  

SECUREWORX's Vision is to be an internationally acclaimed developer of
Threat Management Security Solutions that provide "Defence-in-depth" and
"Security Piece-of-Mind"

--=-wTJ5wDzjYiV3TYKX0zzt
Content-Disposition: attachment; filename=ip_conntrack_ftp-2.4.18.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=ip_conntrack_ftp-2.4.18.diff; charset=ISO-8859-15

diff -Naur --exclude '*.orig' --exclude '*.swp' --exclude '*.rej' --exclude=
 .config --exclude .depend --exclude .depend --exclude .config --exclude .h=
depend --exclude .version --exclude System.map --exclude '*.o' --exclude '*=
.flags' --exclude compile.h --exclude autoconf.h linux-original/include/lin=
ux/netfilter_ipv4/ip_conntrack_ftp.h linux/include/linux/netfilter_ipv4/ip_=
conntrack_ftp.h
--- linux-original/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	Thu Apr =
26 00:00:28 2001
+++ linux/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	Mon Nov 11 13:56:=
27 2002
@@ -1,3 +1,22 @@
+/* Date of FTP PASV patch : 2002-11-11
+ * Credits :
+ *   o SecureWorx [www.secureworx.com]
+ *     Credits go to Andre Marais (andre.marais@secureworx.com)
+ *     as primary contributer.
+ *   o Jozsef Kadlecsik for the initial base-code patch for 2.4.0.=20
+ *
+ * Disclaimer :
+ *
+ *   SECUREWORX DISCLAIMS ALL WARRANTIES WITH REGARD TO
+ *   THIS SOFTWARE/PATCHES, INCLUDING ALL IMPLIED WARRANTIES OF=20
+ *   MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL SECUREWORX=20
+ *   BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES=20
+ *   OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR=20
+ *   PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER=20
+ *   TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE=20
+ *   OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 #ifndef _IP_CONNTRACK_FTP_H
 #define _IP_CONNTRACK_FTP_H
 /* FTP tracking. */
@@ -11,16 +30,22 @@
 /* Protects ftp part of conntracks */
 DECLARE_LOCK_EXTERN(ip_ftp_lock);
=20
-enum ip_ct_ftp_type
+/* enum ip_ct_ftp_type */
+enum ip_ct_ftp_state
 {
+	/* New double states to see who's sending
+	   possible garbage around...=20
+	   One for PORT command and one for PASV */
+	FTP_STATE_INVALID,
+
 	/* PORT command from client */
-	IP_CT_FTP_PORT,
+	FTP_STATE_PORT_REQUEST,
+	/* PORT response from client */
+	FTP_STATE_PORT_RESPONSE,
+	/* PASV command from client */
+	FTP_STATE_PASV_REQUEST,
 	/* PASV response from server */
-	IP_CT_FTP_PASV,
-	/* EPRT command from client */
-	IP_CT_FTP_EPRT,
-	/* EPSV response from server */
-	IP_CT_FTP_EPSV,
+	FTP_STATE_PASV_RESPONSE,
 };
=20
 /* We record seq number and length of ftp ip/port text here: all in
@@ -32,7 +57,15 @@
 	u_int32_t seq;
 	/* 0 means not found yet */
 	u_int32_t len;
-	enum ip_ct_ftp_type ftptype;
+	/* enum ip_ct_ftp_type ftptype; */
+
+	/* Direction of packet, which must be mangled by NAT */
+	enum ip_conntrack_dir dir;
+	/* Expected FTP state */
+	enum ip_ct_ftp_state expect;
+	/* Current FTP state */
+	enum ip_ct_ftp_state cur_state;
+
 	/* Port that was to be used */
 	u_int16_t port;
 	/* Next valid seq position for cmd matching after newline */
diff -Naur --exclude '*.orig' --exclude '*.swp' --exclude '*.rej' --exclude=
 .config --exclude .depend --exclude .depend --exclude .config --exclude .h=
depend --exclude .version --exclude System.map --exclude '*.o' --exclude '*=
.flags' --exclude compile.h --exclude autoconf.h linux-original/net/ipv4/ne=
tfilter/ip_conntrack_ftp.c linux/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-original/net/ipv4/netfilter/ip_conntrack_ftp.c	Wed Oct 31 01:08:1=
2 2001
+++ linux/net/ipv4/netfilter/ip_conntrack_ftp.c	Mon Nov 11 13:56:10 2002
@@ -1,3 +1,22 @@
+/* Date of FTP PASV patch : 2002-11-11
+ * Credits :
+ *   o SecureWorx [www.secureworx.com]
+ *     Credits go to Andre Marais (andre.marais@secureworx.com)
+ *     as primary contributer.
+ *   o Jozsef Kadlecsik for the initial base-code patch for 2.4.0.=20
+ *
+ * Disclaimer :
+ *
+ *   SECUREWORX DISCLAIMS ALL WARRANTIES WITH REGARD TO
+ *   THIS SOFTWARE/PATCHES, INCLUDING ALL IMPLIED WARRANTIES OF=20
+ *   MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL SECUREWORX=20
+ *   BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES=20
+ *   OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR=20
+ *   PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER=20
+ *   TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE=20
+ *   OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 /* FTP extension for IP connection tracking. */
 #include <linux/module.h>
 #include <linux/netfilter.h>
@@ -13,6 +32,15 @@
 DECLARE_LOCK(ip_ftp_lock);
 struct module *ip_conntrack_ftp =3D THIS_MODULE;
=20
+#define PORT_REQUEST "PORT "   /* FORMAT : 'PORT xxx,xxx,xxx,xxx,xxx,xxx\r=
\n' */
+#define PORT_RESPONSE "200 "   /* FORMAT : '200 blah blah blah\r\n' */
+#define PASV_REQUEST "PASV"    /* FORMAT : 'PASV\r\n' */
+#define PASV_RESPONSE "227 "   /* FORMAT : '227 blah blah blah (xxx,xxx,xx=
x,xxx,xxx,xxx).\r\n */
+
+#define PORT_NONE      0
+#define PORT_SET       1
+#define PORT_ACCEPT    2
+
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
@@ -33,41 +61,35 @@
 static int try_eprt(const char *, size_t, u_int32_t [], char);
 static int try_espv_response(const char *, size_t, u_int32_t [], char);
=20
+/* Please note that EPRT and 229 support has been
+   removed due to lack of IPV6 support this far. */
 static struct ftp_search {
-	enum ip_conntrack_dir dir;
 	const char *pattern;
 	size_t plen;
 	char skip;
 	char term;
-	enum ip_ct_ftp_type ftptype;
+	enum ip_ct_ftp_state expect;
+	enum ip_conntrack_dir expected_dir;
+	enum ip_conntrack_dir dir;
+	int port;
 	int (*getnum)(const char *, size_t, u_int32_t[], char);
 } search[] =3D {
-	{
-		IP_CT_DIR_ORIGINAL,
-		"PORT",	sizeof("PORT") - 1, ' ', '\r',
-		IP_CT_FTP_PORT,
-		try_rfc959,
-	},
-	{
-		IP_CT_DIR_REPLY,
-		"227 ",	sizeof("227 ") - 1, '(', ')',
-		IP_CT_FTP_PASV,
-		try_rfc959,
-	},
-	{
-		IP_CT_DIR_ORIGINAL,
-		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
-		IP_CT_FTP_EPRT,
-		try_eprt,
-	},
-	{
-		IP_CT_DIR_REPLY,
-		"229 ", sizeof("229 ") - 1, '(', ')',
-		IP_CT_FTP_EPSV,
-		try_espv_response,
-	},
+		[FTP_STATE_INVALID] { 0,0,0,'\r',0,0,0,0,0 },
+		[FTP_STATE_PORT_REQUEST] 	{	PORT_REQUEST, sizeof(PORT_REQUEST) - 1, ' ',=
 '\r',
+			FTP_STATE_PORT_RESPONSE, IP_CT_DIR_ORIGINAL, IP_CT_DIR_ORIGINAL,
+			PORT_SET, try_rfc959},
+		[FTP_STATE_PORT_RESPONSE] {	PORT_RESPONSE, sizeof(PORT_RESPONSE) - 1, 0,=
 0,
+			FTP_STATE_PORT_REQUEST, IP_CT_DIR_REPLY, IP_CT_DIR_ORIGINAL,
+			PORT_SET | PORT_ACCEPT, try_rfc959},
+		[FTP_STATE_PASV_REQUEST] 	{ PASV_REQUEST, sizeof(PASV_REQUEST) - 1, 0, '=
\r',
+			FTP_STATE_PASV_RESPONSE, IP_CT_DIR_ORIGINAL, IP_CT_DIR_REPLY,
+			PORT_NONE, try_rfc959 },
+		[FTP_STATE_PASV_RESPONSE]	{ PASV_RESPONSE, sizeof(PASV_RESPONSE) - 1, '(=
',')',
+			FTP_STATE_PASV_REQUEST, IP_CT_DIR_REPLY,IP_CT_DIR_REPLY,
+			PORT_SET | PORT_ACCEPT, try_rfc959},
 };
=20
+
 static int try_number(const char *data, size_t dlen, u_int32_t array[],
 		      int array_size, char sep, char term)
 {
@@ -137,7 +159,7 @@
 	int length;
=20
 	/* First character is delimiter, then "1" for IPv4, then
-           delimiter again. */
+		delimiter again. */
 	if (dlen <=3D 3) return 0;
 	delim =3D data[0];
 	if (isdigit(delim) || delim < 33 || delim > 126
@@ -173,13 +195,16 @@
=20
 /* Return 1 for match, 0 for accept, -1 for partial. */
 static int find_pattern(const char *data, size_t dlen,
-			const char *pattern, size_t plen,
-			char skip, char term,
 			unsigned int *numoff,
 			unsigned int *numlen,
 			u_int32_t array[6],
+			enum ip_ct_ftp_state state,
 			int (*getnum)(const char *, size_t, u_int32_t[], char))
 {
+	const char *pattern =3D search[state].pattern;
+	size_t plen =3D search[state].plen;
+	char skip =3D search[state].skip;
+	char term =3D search[state].term;
 	size_t i;
=20
 	DEBUGP("find_pattern `%s': dlen =3D %u\n", pattern, dlen);
@@ -188,9 +213,13 @@
=20
 	if (dlen <=3D plen) {
 		/* Short packet: try for partial? */
-		if (strnicmp(data, pattern, dlen) =3D=3D 0)
+		if (strnicmp(data, pattern, dlen) =3D=3D 0) {
+			DEBUGP("partial match found in dlen <=3D plen\n");
 			return -1;
-		else return 0;
+		} else {
+			DEBUGP("partial match not found in dlen <=3D plen\n");
+			return 0;
+		}
 	}
=20
 	if (strnicmp(data, pattern, plen) !=3D 0) {
@@ -199,7 +228,7 @@
=20
 		DEBUGP("ftp: string mismatch\n");
 		for (i =3D 0; i < plen; i++) {
-			DEBUGFTP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
+			DEBUG("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
 				 i, data[i], data[i],
 				 pattern[i], pattern[i]);
 		}
@@ -208,20 +237,45 @@
 	}
=20
 	DEBUGP("Pattern matches!\n");
+
 	/* Now we've found the constant string, try to skip
 	   to the 'skip' character */
-	for (i =3D plen; data[i] !=3D skip; i++)
-		if (i =3D=3D dlen - 1) return -1;
+	*numoff =3D 0;
+	*numlen =3D dlen;
+	i =3D 0;
+
+	/* Now we've found the constant string, try to skip
+	to the 'skip' character */
+	if (skip !=3D 0) {
+		for (/* */; (i < dlen) && (data[i] !=3D skip); i++)
+			;
+		i++;    /* skip over the last character */
+
+		if (i >=3D dlen) {
+			DEBUGP("No skip character found!!!\n");
+			return 0;
+		}
=20
-	/* Skip over the last character */
-	i++;
+		*numoff =3D i;
+	}
+
+	/*DEBUGP("Skipped up to `%c'!\n", skip); */
=20
-	DEBUGP("Skipped up to `%c'!\n", skip);
+	if (search[state].port & PORT_SET) {
+		*numlen =3D getnum(data + i, dlen - i, array, term);
+		if (!*numlen) {
+			DEBUGP("No IP number and port found!!!!\n");
+			return -1;
+		}
+		return  1;
+	}
=20
-	*numoff =3D i;
-	*numlen =3D getnum(data + i, dlen - i, array, term);
-	if (!*numlen)
+	if (term !=3D 0) {
+		if (*(data + plen) =3D=3D term)
+			return 1;
+		DEBUGP("No terminator found!!!!\n");
 		return -1;
+	}
=20
 	DEBUGP("Match succeeded!\n");
 	return 1;
@@ -241,12 +295,16 @@
 	int old_seq_aft_nl_set;
 	u_int32_t array[6] =3D { 0 };
 	int dir =3D CTINFO2DIR(ctinfo);
-	unsigned int matchlen, matchoff;
+	unsigned int matchlen, matchoff =3D 0;
 	struct ip_conntrack_tuple t, mask;
 	struct ip_ct_ftp *info =3D &ct->help.ct_ftp_info;
+	enum ip_ct_ftp_state expect, try;
+	u_int16_t port;
 	unsigned int i;
 	int found =3D 0;
=20
+	DEBUGP("conntrack_ftp ----> New FTP packet\n");
+
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo !=3D IP_CT_ESTABLISHED
 	    && ctinfo !=3D IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
@@ -260,6 +318,10 @@
 		return NF_ACCEPT;
 	}
=20
+	/* Dataless packet */
+	if (datalen =3D=3D 0)
+		return NF_ACCEPT;
+
 	/* Checksum invalid?  Ignore. */
 	/* FIXME: Source route IP option packets --RR */
 	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
@@ -273,6 +335,7 @@
 	LOCK_BH(&ip_ftp_lock);
 	old_seq_aft_nl_set =3D info->seq_aft_nl_set[dir];
 	old_seq_aft_nl =3D info->seq_aft_nl[dir];
+	expect =3D info->expect;
=20
 	DEBUGP("conntrack_ftp: datalen %u\n", datalen);
 	if ((datalen > 0) && (data[datalen-1] =3D=3D '\n')) {
@@ -301,51 +364,99 @@
 	array[2] =3D (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
 	array[3] =3D ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;
=20
-	for (i =3D 0; i < sizeof(search) / sizeof(search[0]); i++) {
-		if (search[i].dir !=3D dir) continue;
+	DEBUGP("IP Retrieved from tuple hash : %u.%u.%u.%u\n",array[0],array[1],a=
rray[2],array[3],array[4]);
=20
-		found =3D find_pattern(data, datalen,
-				     search[i].pattern,
-				     search[i].plen,
-				     search[i].skip,
-				     search[i].term,
-				     &matchoff, &matchlen,
-				     array,
-				     search[i].getnum);
-		if (found) break;
-	}
-	if (found =3D=3D -1) {
-		/* We don't usually drop packets.  After all, this is
-		   connection tracking, not packet filtering.
-		   However, it is neccessary for accurate tracking in
-		   this case. */
-		if (net_ratelimit())
-			printk("conntrack_ftp: partial %s %u+%u\n",
-			       search[i].pattern,
-			       ntohl(tcph->seq), datalen);
-		return NF_DROP;
-	} else if (found =3D=3D 0) /* No match */
-		return NF_ACCEPT;
-
-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-	       (int)matchlen, data + matchoff,
-	       matchlen, ntohl(tcph->seq) + matchoff);
+	/* Check if it's a response, or if it's a resent, depending on=20
+	   the direction or try to match a PASV request. */
+	try =3D expect ? (dir =3D=3D search[expect].expected_dir ? expect : searc=
h[expect].expect)
+								: FTP_STATE_PASV_REQUEST;
+	DEBUGP("ip_conntrack_ftp_help : expect =3D %d, try =3D %d, search.expecte=
d_dir =3D %d, search.expect =3D %d.\n",
+				 expect, try, search[expect].expected_dir, search[expect].expect);
+again:
+	switch (find_pattern(data, datalen,
+		&matchoff, &matchlen,
+		array,
+		try, search[try].getnum)) /* Be carefull not to set the state to somethi=
ng meaningless... */
+	{
+		case -1: /* partial */
+			/* We don't usually drop packets.  After all, this is
+			connection tracking, not packet filtering.
+			However, it is neccessary for accurate tracking in
+			this case. */
+			if (net_ratelimit())
+				printk("conntrack_ftp: partial %s %u+%u\n",
+					search[expect].pattern,
+					ntohl(tcph->seq), datalen);
+			LOCK_BH(&ip_ftp_lock);
+			info->cur_state =3D FTP_STATE_INVALID;
+			UNLOCK_BH(&ip_ftp_lock);
+			return NF_DROP;
+
+		case 0: /* no match */
+			switch (try) {
+				case FTP_STATE_PASV_REQUEST: /* No PASV: is it a PORT request? */
+					try =3D FTP_STATE_PORT_REQUEST;
+					goto again;
+
+				case FTP_STATE_PORT_REQUEST: /* No PASV and neither a PORT request */
+					DEBUGP("ip_conntrack_ftp_help: no match\n");
+					return NF_ACCEPT;
+
+				default:
+					/* No match - clean ftp info, but accept the packet:
+					it can be a rejected FTP PASV/PORT command */
+					DEBUGP("ip_conntrack_ftp_help: no PORT/PASV response match\n");
+					LOCK_BH(&ip_ftp_lock);
+					info->expect =3D FTP_STATE_INVALID;
+					UNLOCK_BH(&ip_ftp_lock);
+
+					return NF_ACCEPT;
+				}
+		case 1:
+			LOCK_BH(&ip_ftp_lock);
+			info->cur_state =3D try; /* Set the current state to what we found. */
+			UNLOCK_BH(&ip_ftp_lock);
+	}
+
+	DEBUGP("conntrack_ftp: match found. Going to update ftp info...\n");
+
+	DEBUGP("conntrack_ftp: match '%.*s' (%u bytes at %u)\n",
+				(int)matchlen, data + matchoff,=20
+				 matchlen, ntohl(tcph->seq) + matchoff);
=20
 	/* Update the ftp info */
+	/*
+	 * Update the ftp info only if the source address matches the address spe=
cified
+	 * in the PORT or PASV command.  Closes hole where packets could be dange=
rously
+	 * marked as RELATED to bypass filtering rules. Thanks to Cristiano Linco=
ln
+	 * Mattos for the report.
+	 */
 	LOCK_BH(&ip_ftp_lock);
-	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3=
])
-	    =3D=3D ct->tuplehash[dir].tuple.src.ip) {
+	if (search[try].port & PORT_SET
+		&& htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3=
])
+				=3D=3D ct->tuplehash[dir].tuple.src.ip)=20
+	{
+		DEBUGP("conntrack_ftp: Updating info->* \n");
 		info->is_ftp =3D 21;
 		info->seq =3D ntohl(tcph->seq) + matchoff;
 		info->len =3D matchlen;
-		info->ftptype =3D search[i].ftptype;
+		info->dir =3D search[try].dir;
+		info->expect  =3D search[try].expect;
 		info->port =3D array[4] << 8 | array[5];
+	} else if (search[try].port =3D=3D PORT_NONE)
+			info->expect =3D search[try].expect;
+
+
+	if (search[try].port & PORT_ACCEPT) {
+			DEBUGP("conntrack_ftp: Updating due to PORT_ACCEPT \n");
+			info->expect =3D FTP_STATE_INVALID;
+			port =3D htons(info->port);
 	} else {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
 		   server: it really wants us to connect to a
 		   different IP address.  Simply don't record it for
 		   NAT. */
-		DEBUGP("conntrack_ftp: NOT RECORDING: %u,%u,%u,%u !=3D %u.%u.%u.%u\n",
+		DEBUGP("conntrack_ftp: NOT RECORDING due to PORT_ACCEPT not set : %u,%u,=
%u,%u !=3D %u.%u.%u.%u\n",
 		       array[0], array[1], array[2], array[3],
 		       NIPQUAD(ct->tuplehash[dir].tuple.src.ip));
=20
@@ -359,13 +470,18 @@
 	t =3D ((struct ip_conntrack_tuple)
 		{ { ct->tuplehash[!dir].tuple.src.ip,
 		    { 0 } },
-		  { htonl((array[0] << 24) | (array[1] << 16)
+		  /*{ htonl((array[0] << 24) | (array[1] << 16)
 			  | (array[2] << 8) | array[3]),
-		    { htons(array[4] << 8 | array[5]) },
-		    IPPROTO_TCP }});
+		    { htons(array[4] << 8 | array[5]) }, */
+				{ ct->tuplehash[dir].tuple.src.ip,=20
+					{ port },
+			IPPROTO_TCP } });
 	mask =3D ((struct ip_conntrack_tuple)
 		{ { 0xFFFFFFFF, { 0 } },
 		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+
+	DEBUGP("conntrack_ftp: RECORDING entry.\n");
+
 	/* Ignore failure; should only happen with NAT */
 	ip_conntrack_expect_related(ct, &t, &mask, NULL);
  out:
diff -Naur --exclude '*.orig' --exclude '*.swp' --exclude '*.rej' --exclude=
 .config --exclude .depend --exclude .depend --exclude .config --exclude .h=
depend --exclude .version --exclude System.map --exclude '*.o' --exclude '*=
.flags' --exclude compile.h --exclude autoconf.h linux-original/net/ipv4/ne=
tfilter/ip_nat_ftp.c linux/net/ipv4/netfilter/ip_nat_ftp.c
--- linux-original/net/ipv4/netfilter/ip_nat_ftp.c	Wed Oct 31 01:08:12 2001
+++ linux/net/ipv4/netfilter/ip_nat_ftp.c	Mon Nov 11 13:56:45 2002
@@ -1,3 +1,22 @@
+/* Date of FTP PASV patch : 2002-11-11
+ * Credits :
+ *   o SecureWorx [www.secureworx.com]
+ *     Credits go to Andre Marais (andre.marais@secureworx.com)
+ *     as primary contributer.
+ *   o Jozsef Kadlecsik for the initial base-code patch for 2.4.0.=20
+ *
+ * Disclaimer :
+ *
+ *   SECUREWORX DISCLAIMS ALL WARRANTIES WITH REGARD TO
+ *   THIS SOFTWARE/PATCHES, INCLUDING ALL IMPLIED WARRANTIES OF=20
+ *   MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL SECUREWORX=20
+ *   BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES=20
+ *   OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR=20
+ *   PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER=20
+ *   TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE=20
+ *   OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
 /* FTP extension for TCP NAT alteration. */
 #include <linux/module.h>
 #include <linux/netfilter_ipv4.h>
@@ -58,8 +77,7 @@
 		return 0;
 	}
=20
-	if (ftpinfo->ftptype =3D=3D IP_CT_FTP_PORT
-	    || ftpinfo->ftptype =3D=3D IP_CT_FTP_EPRT) {
+	if (ftpinfo->dir =3D=3D IP_CT_DIR_ORIGINAL) {
 		/* PORT command: make connection go to the client. */
 		newdstip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
@@ -115,7 +133,9 @@
 	sprintf(buffer, "%u,%u,%u,%u,%u,%u",
 		NIPQUAD(newip), port>>8, port&0xFF);
=20
-	DEBUGP("calling ip_nat_mangle_tcp_packet\n");
+	DEBUGP("Selected IP and Port %s\n",buffer);
+	DEBUGP("calling ip_nat_mangle_tcp_packet with matchoff =3D %ld, matchlen =
=3D %ld, buffer =3D '%s'.\n",
+				 matchoff,matchlen,buffer);
=20
 	return ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, matchoff,=20
 					matchlen, buffer, strlen(buffer));
@@ -170,10 +190,11 @@
 		     unsigned int,
 		     struct ip_conntrack *,
 		     enum ip_conntrack_info)
-=3D { [IP_CT_FTP_PORT] mangle_rfc959_packet,
-    [IP_CT_FTP_PASV] mangle_rfc959_packet,
-    [IP_CT_FTP_EPRT] mangle_eprt_packet,
-    [IP_CT_FTP_EPSV] mangle_epsv_packet
+=3D { [FTP_STATE_INVALID] mangle_rfc959_packet,
+		[FTP_STATE_PORT_REQUEST] mangle_rfc959_packet,
+    [FTP_STATE_PORT_RESPONSE] mangle_rfc959_packet,
+    [FTP_STATE_PASV_REQUEST] mangle_rfc959_packet,
+    [FTP_STATE_PASV_RESPONSE] mangle_rfc959_packet,
 };
=20
 static int ftp_data_fixup(const struct ip_ct_ftp *ct_ftp_info,
@@ -200,16 +221,17 @@
=20
 	/* Change address inside packet to match way we're mapping
 	   this connection. */
-	if (ct_ftp_info->ftptype =3D=3D IP_CT_FTP_PASV
-	    || ct_ftp_info->ftptype =3D=3D IP_CT_FTP_EPSV) {
+	if (ct_ftp_info->dir =3D=3D IP_CT_DIR_REPLY) {
 		/* PASV/EPSV response: must be where client thinks server
 		   is */
+		DEBUGP("FTP_NAT: processing reply direction.\n");
 		newip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 		/* Expect something from client->server */
 		tuple.src.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		tuple.dst.ip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 	} else {
 		/* PORT command: must be where server thinks client is */
+		DEBUGP("FTP_NAT: processing request direction.\n");
 		newip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 		/* Expect something from server->client */
 		tuple.src.ip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
@@ -217,6 +239,7 @@
 	}
 	tuple.dst.protonum =3D IPPROTO_TCP;
=20
+	DEBUGP("FTP_NAT: Try to get port, otherwise change it.\n");
 	/* Try to get same port: if not, try to change it. */
 	for (port =3D ct_ftp_info->port; port !=3D 0; port++) {
 		tuple.dst.u.tcp.port =3D htons(port);
@@ -227,7 +250,10 @@
 	if (port =3D=3D 0)
 		return 0;
=20
-	if (!mangle[ct_ftp_info->ftptype](pskb, newip, port,
+	/*if (!mangle[ct_ftp_info->ftptype](pskb, newip, port,*/
+	DEBUGP("FTP_NAT: Mangle the packet. ct_ftp_info->dir =3D %u.\n",ct_ftp_in=
fo->dir);
+	/*if (!mangle[ct_ftp_info->dir](pskb, newip, port, */
+	if (!mangle[ct_ftp_info->cur_state](pskb, newip, port,
 					  ct_ftp_info->seq - ntohl(tcph->seq),
 					  ct_ftp_info->len, ct, ctinfo))
 		return 0;

--=-wTJ5wDzjYiV3TYKX0zzt--
