From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: RE: [PATCH] big endian patch against netfilter after PPTP NAT
 pat ch
Date: Mon, 10 Feb 2003 10:39:29 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A487DCF3@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_000_01C2D12B.5D1369EC"
Cc: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Harald Welte'" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D12B.5D1369EC
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2D12B.5D1369EC"
Content-Transfer-Encoding: 7bit


------_=_NextPart_001_01C2D12B.5D1369EC
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

Here is the patch for changing most of the initializers to use qualified fields


------_=_NextPart_001_01C2D12B.5D1369EC
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=us-ascii">
<META NAME="Generator" CONTENT="MS Exchange Server version 5.5.2653.12">
<TITLE>RE: [PATCH] big endian patch against netfilter after PPTP NAT pat ch</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=2>Here is the patch for changing most of the initializers to use qualified fields</FONT>
</P>

<P><FONT FACE="MingLiu" SIZE=2 COLOR="#000000"></FONT>&nbsp;

</BODY>
</HTML>
------_=_NextPart_001_01C2D12B.5D1369EC--

------_=_NextPart_000_01C2D12B.5D1369EC
Content-Type: application/octet-stream;
 name=linux-netfilter-mask.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=linux-netfilter-mask.patch

diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_amanda.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_amanda.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	Thu Feb  =
6 09:40:14 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_amanda.c	Thu Feb  6 =
10:32:04 2003=0A=
@@ -154,11 +154,11 @@=0A=
 						{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,=0A=
 						  { 0 } },=0A=
 				  		{ ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,=0A=
-						  { htons(exp_amanda_info->port) },=0A=
+						  { tcp: { port: htons(exp_amanda_info->port) } },=0A=
 				    	  IPPROTO_TCP }});=0A=
 				expect.mask =3D ((struct ip_conntrack_tuple)=0A=
 							   { { 0, { 0 } },=0A=
-				  				 { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+				  				 { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 =0A=
 				expect.expectfn =3D NULL;=0A=
 =0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_core.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_core.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c	Thu Feb  6 =
11:43:44 2003=0A=
@@ -1328,8 +1328,8 @@=0A=
 getorigdst(struct sock *sk, int optval, void *user, int *len)=0A=
 {=0A=
 	struct ip_conntrack_tuple_hash *h;=0A=
-	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { sk->sport } =
},=0A=
-					    { sk->daddr, { sk->dport },=0A=
+	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { tcp: { port: =
sk->sport } } },=0A=
+					    { sk->daddr, { tcp: { port: sk->dport },=0A=
 					      IPPROTO_TCP } };=0A=
 =0A=
 	/* We only do TCP at the moment: is there a better way? */=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_ftp.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_ftp.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Nov 28 =
15:53:15 2002=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Feb  6 =
10:34:48 2003=0A=
@@ -366,11 +366,11 @@=0A=
 		    { 0 } },=0A=
 		  { htonl((array[0] << 24) | (array[1] << 16)=0A=
 			  | (array[2] << 8) | array[3]),=0A=
-		    { htons(array[4] << 8 | array[5]) },=0A=
+		    { tcp: { port: htons(array[4] << 8 | array[5]) } },=0A=
 		    IPPROTO_TCP }});=0A=
 	exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 		{ { 0xFFFFFFFF, { 0 } },=0A=
-		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+		  { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 =0A=
 	exp->expectfn =3D NULL;=0A=
 =0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_h323.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_h323.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_h323.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_h323.c	Thu Feb  6 =
11:07:37 2003=0A=
@@ -108,11 +108,11 @@=0A=
 				{ { ct->tuplehash[!dir].tuple.src.ip,=0A=
 				    { 0 } },=0A=
 				  { data_ip,=0A=
-				    { data_port },=0A=
+				    { udp: { port: data_port } },=0A=
 				    IPPROTO_UDP }});=0A=
 			exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 				{ { 0xFFFFFFFF, { 0 } },=0A=
-				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+				  { 0xFFFFFFFF, { udp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 	=0A=
 			exp->expectfn =3D NULL;=0A=
 			=0A=
@@ -137,7 +137,7 @@=0A=
           240,					/* timeout */=0A=
           { { 0, { 0 } },			/* tuple */=0A=
             { 0, { 0 }, IPPROTO_TCP } },=0A=
-          { { 0, { 0xFFFF } },			/* mask */=0A=
+          { { 0, { tcp: { port: 0xFFFF } } },	/* mask */=0A=
             { 0, { 0 }, 0xFFFF } },=0A=
           h245_help				/* helper */=0A=
 	};=0A=
@@ -237,11 +237,11 @@=0A=
 					{ { ct->tuplehash[!dir].tuple.src.ip,=0A=
 					    { 0 } },=0A=
 					  { data_ip,=0A=
-					    { data_port },=0A=
+					    { tcp: { port: data_port } },=0A=
 					    IPPROTO_TCP }});=0A=
 				exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 					{ { 0xFFFFFFFF, { 0 } },=0A=
-					  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+					  { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 	=0A=
 				exp->expectfn =3D h225_expect;=0A=
 				=0A=
@@ -284,9 +284,9 @@=0A=
 	  THIS_MODULE,					/* module */=0A=
 	  2,						/* max_expected */=0A=
 	  240,						/* timeout */=0A=
-	  { { 0, { __constant_htons(H225_PORT) } },	/* tuple */=0A=
+	  { { 0, { tcp: { port: __constant_htons(H225_PORT) } } },	/* tuple =
*/=0A=
 	    { 0, { 0 }, IPPROTO_TCP } },=0A=
-	  { { 0, { 0xFFFF } },				/* mask */=0A=
+	  { { 0, { tcp: { port: 0xFFFF } } },		/* mask */=0A=
 	    { 0, { 0 }, 0xFFFF } },=0A=
 	  h225_help					/* helper */=0A=
 	};=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_irc.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_irc.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_irc.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_irc.c	Thu Feb  6 =
11:07:37 2003=0A=
@@ -209,11 +209,11 @@=0A=
 =0A=
 			exp->tuple =3D ((struct ip_conntrack_tuple)=0A=
 				{ { 0, { 0 } },=0A=
-				  { htonl(dcc_ip), { htons(dcc_port) },=0A=
+				  { htonl(dcc_ip), { tcp: { port: htons(dcc_port) } },=0A=
 				    IPPROTO_TCP }});=0A=
 			exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 				{ { 0, { 0 } },=0A=
-				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+				  { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 =0A=
 			exp->expectfn =3D NULL;=0A=
 =0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_mms.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_mms.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_mms.c	Thu Feb  6 =
09:40:45 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_mms.c	Thu Feb  6 =
11:12:49 2003=0A=
@@ -238,12 +238,12 @@=0A=
 		exp->tuple =3D ((struct ip_conntrack_tuple)=0A=
 		              { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },=0A=
 		              { mms_ip,=0A=
-		                { (__u16) ntohs(mms_port) },=0A=
+		                { tcp: { port: (__u16) ntohs(mms_port) } },=0A=
 		                mms_proto } }=0A=
 		             );=0A=
 		exp->mask  =3D ((struct ip_conntrack_tuple)=0A=
 		             { { 0xFFFFFFFF, { 0 } },=0A=
-		               { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+		               { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF =
}});=0A=
 		exp->expectfn =3D NULL;=0A=
 		ip_conntrack_expect_related(ct, &expect);=0A=
 		UNLOCK_BH(&ip_mms_lock);=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_quake3.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_quake3.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_quake3.c	Thu Feb  =
6 09:41:03 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_quake3.c	Thu Feb  6 =
11:15:53 2003=0A=
@@ -82,12 +82,12 @@=0A=
 			exp.tuple =3D ((struct ip_conntrack_tuple)=0A=
 			             { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },=0A=
 			               { (u_int32_t) *((u_int32_t *)((int)udph + i)), =0A=
-			               { (__u16) *((__u16 *)((int)udph+i+4)) }, =0A=
+			               { udp: { port : (__u16) *((__u16 *)((int)udph+i+4)) =
} }, =0A=
 			                 IPPROTO_UDP } }=0A=
 			            );=0A=
 			exp.mask  =3D ((struct ip_conntrack_tuple)=0A=
 			             { { 0xFFFFFFFF, { 0 } },=0A=
-		                       { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+		                       { 0xFFFFFFFF, { udp: { port: 0xFFFF } }, =
0xFFFF }});=0A=
 			exp.expectfn =3D NULL;=0A=
 =0A=
 			ip_conntrack_expect_related(ct, &exp);=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_talk.c =
linux-2.4.20/net/ipv4/netfilter/ip_conntrack_talk.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_talk.c	Thu Feb  6 =
09:41:26 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_talk.c	Thu Feb  6 =
11:27:18 2003=0A=
@@ -119,11 +119,11 @@=0A=
 			{ { ct->tuplehash[dir].tuple.src.ip,=0A=
 			    { 0 } },=0A=
 			  { ct->tuplehash[dir].tuple.dst.ip,=0A=
-			    { htons(talk_port) },=0A=
+			    { udp: { port: htons(talk_port) } },=0A=
 			    IPPROTO_UDP }});=0A=
 		exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 			{ { 0xFFFFFFFF, { 0 } },=0A=
-			  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+			  { 0xFFFFFFFF, { udp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 		=0A=
 		exp->expectfn =3D talk_expectfn[talk_port - TALK_PORT];=0A=
 =0A=
@@ -148,11 +148,11 @@=0A=
 			{ { ct->tuplehash[!dir].tuple.src.ip,=0A=
 			    { 0 } },=0A=
 			  { addr->ta_addr,=0A=
-			    { addr->ta_port },=0A=
+			    { tcp: { port: addr->ta_port } },=0A=
 			    IPPROTO_TCP }});=0A=
 		exp->mask =3D ((struct ip_conntrack_tuple)=0A=
 			{ { 0xFFFFFFFF, { 0 } },=0A=
-			  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});=0A=
+			  { 0xFFFFFFFF, { tcp: { port: 0xFFFF } }, 0xFFFF }});=0A=
 		=0A=
 		exp->expectfn =3D NULL;=0A=
 		=0A=
@@ -261,9 +261,9 @@=0A=
 	    NULL,					/* module */=0A=
 	    1,						/* max_expected */=0A=
 	    240,					/* timeout */=0A=
-            { { 0, { __constant_htons(TALK_PORT) } },	/* tuple */=0A=
+            { { 0, { udp: { port: __constant_htons(TALK_PORT) } } },	=
/* tuple */=0A=
 	      { 0, { 0 }, IPPROTO_UDP } },=0A=
-	    { { 0, { 0xFFFF } },			/* mask */=0A=
+	    { { 0, { udp: { port: 0xFFFF } } },		/* mask */=0A=
 	      { 0, { 0 }, 0xFFFF } },=0A=
 	    lookup_help },				/* helper */=0A=
           { { NULL, NULL },=0A=
@@ -272,9 +272,9 @@=0A=
 	    NULL,					/* module */=0A=
 	    1,						/* max_expected */=0A=
 	    240,					/* timeout */=0A=
-	    { { 0, { __constant_htons(NTALK_PORT) } },	/* tuple */=0A=
+	    { { 0, { udp: { port: __constant_htons(NTALK_PORT) } } },	/* =
tuple */=0A=
 	      { 0, { 0 }, IPPROTO_UDP } },=0A=
-	    { { 0, { 0xFFFF } },			/* mask */=0A=
+	    { { 0, { udp: { port: 0xFFFF } } },		/* mask */=0A=
 	      { 0, { 0 }, 0xFFFF } },=0A=
     	    lookup_nhelp }				/* helper */=0A=
         };=0A=
@@ -318,9 +318,9 @@=0A=
 	    THIS_MODULE,				/* module */=0A=
 	    1,						/* max_expected */=0A=
 	    240,					/* timeout */=0A=
-	    { { 0, { __constant_htons(TALK_PORT) } },	/* tuple */=0A=
+	    { { 0, { udp: { port: __constant_htons(TALK_PORT) } } },	/* tuple =
*/=0A=
  	      { 0, { 0 }, IPPROTO_UDP } },=0A=
-	    { { 0, { 0xFFFF } },			/* mask */=0A=
+	    { { 0, { udp: { port: 0xFFFF } } },		/* mask */=0A=
 	      { 0, { 0 }, 0xFFFF } },=0A=
 	    help },					/* helper */=0A=
           { { NULL, NULL },=0A=
@@ -329,9 +329,9 @@=0A=
 	    THIS_MODULE,				/* module */=0A=
 	    1,						/* max_expected */=0A=
 	    240,					/* timeout */=0A=
-	    { { 0, { __constant_htons(NTALK_PORT) } },	/* tuple */=0A=
+	    { { 0, { udp: { port: __constant_htons(NTALK_PORT) } } },	/* =
tuple */=0A=
 	      { 0, { 0 }, IPPROTO_UDP } },=0A=
-	    { { 0, { 0xFFFF } },			/* mask */=0A=
+	    { { 0, { udp: { port: 0xFFFF } } },		/* mask */=0A=
 	      { 0, { 0 }, 0xFFFF } },=0A=
 	    nhelp }					/* helper */=0A=
 	};=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_amanda.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_amanda.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_amanda.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_amanda.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -60,6 +60,7 @@=0A=
 =0A=
 	DEBUGP("nat_expected: We have a connection!\n");=0A=
 	exp_info =3D &ct->master->help.exp_amanda_info;=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	newdstip =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;=0A=
 	newsrcip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;=0A=
@@ -82,9 +83,8 @@=0A=
 =0A=
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {=0A=
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
-		mr.range[0].min =3D mr.range[0].max=0A=
-			=3D ((union ip_conntrack_manip_proto)=0A=
-				{ htons(port) });=0A=
+		mr.range[0].min.tcp.port =3D mr.range[0].max.tcp.port=0A=
+			=3D htons(port);=0A=
 	}=0A=
 =0A=
 	return ip_nat_setup_info(ct, &mr, hooknum);=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_ftp.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_ftp.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_ftp.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_ftp.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -47,6 +47,7 @@=0A=
 =0A=
 	DEBUGP("nat_expected: We have a connection!\n");=0A=
 	exp_ftp_info =3D &ct->master->help.exp_ftp_info;=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	LOCK_BH(&ip_ftp_lock);=0A=
 =0A=
@@ -82,9 +83,8 @@=0A=
 	   sure we map to the correct port */=0A=
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {=0A=
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
-		mr.range[0].min =3D mr.range[0].max=0A=
-			=3D ((union ip_conntrack_manip_proto)=0A=
-				{ htons(exp_ftp_info->port) });=0A=
+		mr.range[0].min.tcp.port =3D mr.range[0].max.tcp.port=0A=
+			=3D htons(exp_ftp_info->port);=0A=
 	}=0A=
 	return ip_nat_setup_info(ct, &mr, hooknum);=0A=
 }=0A=
@@ -182,6 +182,7 @@=0A=
 	DEBUGP("FTP_NAT: seq %u + %u in %u\n",=0A=
 	       expect->seq, ct_ftp_info->len,=0A=
 	       ntohl(tcph->seq));=0A=
+	memset((void *)&newtuple, 0, sizeof(struct ip_conntrack_tuple));=0A=
 =0A=
 	/* Change address inside packet to match way we're mapping=0A=
 	   this connection. */=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_h323.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_h323.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_h323.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_h323.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -58,7 +58,7 @@=0A=
 	  NULL,					/* module */=0A=
 	  { { 0, { 0 } },			/* tuple */=0A=
 	    { 0, { 0 }, IPPROTO_TCP } },=0A=
-	  { { 0, { 0xFFFF } },			/* mask */=0A=
+	  { { 0, { tcp: { port: 0xFFFF } } },	/* mask */=0A=
 	    { 0, { 0 }, 0xFFFF } },=0A=
 	  h225_nat_help,			/* helper */=0A=
 	  h225_nat_expected			/* expectfn */=0A=
@@ -86,6 +86,7 @@=0A=
 	DEBUGP("h225_nat_expected: We have a connection!\n");=0A=
 	master_info =3D &ct->master->expectant->help.ct_h225_info;=0A=
 	exp_info =3D &ct->master->help.exp_h225_info;=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	LOCK_BH(&ip_h323_lock);=0A=
 =0A=
@@ -127,9 +128,8 @@=0A=
 	   sure we map to the correct port */=0A=
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {=0A=
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
-		mr.range[0].min =3D mr.range[0].max=0A=
-			=3D ((union ip_conntrack_manip_proto)=0A=
-				{ port });=0A=
+		mr.range[0].min.tcp.port =3D mr.range[0].max.tcp.port=0A=
+			=3D port;=0A=
 	}=0A=
 =0A=
 	ret =3D ip_nat_setup_info(ct, &mr, hooknum);=0A=
@@ -252,6 +252,7 @@=0A=
 	DEBUGP("h323_data_fixup: offset %u + 6 in %u\n", info->offset, =
tcplen);=0A=
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);=0A=
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);=0A=
+	memset((void *)&newtuple, 0, sizeof(struct ip_conntrack_tuple));=0A=
 =0A=
 	if (!between(expect->seq + 6, ntohl(tcph->seq),=0A=
 		    ntohl(tcph->seq) + tcplen - tcph->doff * 4)) {=0A=
@@ -390,9 +391,9 @@=0A=
 	  "H.225",					/* name */=0A=
 	  IP_NAT_HELPER_F_ALWAYS, 			/* flags */=0A=
 	  THIS_MODULE,					/* module */=0A=
-	  { { 0, { __constant_htons(H225_PORT) } },	/* tuple */=0A=
+	  { { 0, { tcp: { port: __constant_htons(H225_PORT) } } },	/* tuple =
*/=0A=
 	    { 0, { 0 }, IPPROTO_TCP } },=0A=
-	  { { 0, { 0xFFFF } },				/* mask */=0A=
+	  { { 0, { tcp: { port: 0xFFFF } } },		/* mask */=0A=
 	    { 0, { 0 }, 0xFFFF } },=0A=
 	  h225_nat_help,				/* helper */=0A=
 	  h225_nat_expected				/* expectfn */=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_irc.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_irc.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_irc.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_irc.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -68,6 +68,7 @@=0A=
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));=0A=
 =0A=
 	DEBUGP("nat_expected: We have a connection!\n");=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	newdstip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;=0A=
 	newsrcip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_mms.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_mms.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_mms.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_mms.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -194,6 +194,7 @@=0A=
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));=0A=
 =0A=
 	DEBUGP("ip_nat_mms: mms_nat_expected: We have a connection!\n");=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	newdstip =3D master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;=0A=
 	newsrcip =3D ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_pptp.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_pptp.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_pptp.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_pptp.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -65,6 +65,7 @@=0A=
	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));=0A=
=0A=
	DEBUGP("we have a connection!\n");=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
=0A=
	LOCK_BH(&ip_pptp_lock);=0A=
	ct_pptp_info =3D &master->help.ct_pptp_info;=0A=
@@ -101,8 +102,7 @@=0A=
 		mr.rangesize =3D 1;=0A=
 		mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS | =
IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
 		mr.range[0].min_ip =3D mr.range[0].max_ip =3D newdstip;=0A=
-		mr.range[0].min =3D mr.range[0].max =3D =0A=
-			((union ip_conntrack_manip_proto ) { newcid }); =0A=
+		mr.range[0].min.gre.key =3D mr.range[0].max.gre.key =3D newcid;=0A=
 		DEBUGP("change dest ip to %u.%u.%u.%u\n", =0A=
 			NIPQUAD(newdstip));=0A=
 		DEBUGP("change dest key to 0x%x\n", ntohl(newcid));=0A=
@@ -117,8 +117,7 @@=0A=
 		mr.range[0].flags =3D IP_NAT_RANGE_MAP_IPS=0A=
 			            |IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
 		mr.range[0].min_ip =3D mr.range[0].max_ip =3D newsrcip;=0A=
-		mr.range[0].min =3D mr.range[0].max =3D =0A=
-			((union ip_conntrack_manip_proto ) { newcid });=0A=
+		mr.range[0].min.gre.key =3D mr.range[0].max.gre.key =3D newcid;=0A=
 		DEBUGP("change src ip to %u.%u.%u.%u\n", =0A=
 			NIPQUAD(newsrcip));=0A=
 		DEBUGP("change 'src' key to 0x%x\n", ntohl(newcid));=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_quake3.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_quake3.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_quake3.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_quake3.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -152,6 +152,7 @@=0A=
=0A=
	DEBUGP("ip_nat_quake3: quake3_nat_expected: here we are\n");=0A=
	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
=0A=
	IP_NF_ASSERT(info);=0A=
	IP_NF_ASSERT(master);=0A=
diff -urbw linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_talk.c =
linux-2.4.20/net/ipv4/netfilter/ip_nat_talk.c=0A=
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_nat_talk.c	Thu Feb  6 =
09:40:30 2003=0A=
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_talk.c	Thu Feb  6 11:43:44 =
2003=0A=
@@ -335,9 +335,9 @@=0A=
             "talk",					/* name */=0A=
             IP_NAT_HELPER_F_ALWAYS, 			/* flags */=0A=
             THIS_MODULE,				/* module */=0A=
-            { { 0, { __constant_htons(TALK_PORT) } },	/* tuple */=0A=
+            { { 0, { udp: { port: __constant_htons(TALK_PORT) } } },	=
/* tuple */=0A=
               { 0, { 0 }, IPPROTO_UDP } },=0A=
-            { { 0, { 0xFFFF } },			/* mask */=0A=
+            { { 0, { udp: { port: 0xFFFF } } },	/* mask */=0A=
               { 0, { 0 }, 0xFFFF } },=0A=
             help, 					/* helper */=0A=
             talk_nat_expected },			/* expectfn */=0A=
@@ -345,9 +345,9 @@=0A=
             "ntalk", 					/* name */=0A=
             IP_NAT_HELPER_F_ALWAYS, 			/* flags */=0A=
             THIS_MODULE,					/* module */=0A=
-            { { 0, { __constant_htons(NTALK_PORT) } },	/* tuple */=0A=
+            { { 0, { udp: { port: __constant_htons(NTALK_PORT) } } },	=
/* tuple */=0A=
               { 0, { 0 }, IPPROTO_UDP } },=0A=
-            { { 0, { 0xFFFF } },				/* mask */=0A=
+            { { 0, { udp: { port: 0xFFFF } } },		/* mask */=0A=
               { 0, { 0 }, 0xFFFF } },=0A=
             nhelp, 					/* helper */=0A=
             talk_nat_expected }				/* expectfn */=0A=
@@ -372,6 +372,7 @@=0A=
 	IP_NF_ASSERT(!(info->initialized & (1<<HOOK2MANIP(hooknum))));=0A=
 =0A=
 	DEBUGP("ip_nat_talk_expected: We have a connection!\n");=0A=
+	memset((void *)&mr, 0, sizeof (struct ip_nat_multi_range));=0A=
 =0A=
 	LOCK_BH(&ip_talk_lock);=0A=
 	port =3D ct->master->help.exp_talk_info.port;=0A=
@@ -429,9 +430,8 @@=0A=
 	   sure we map to the correct port */=0A=
 	if (HOOK2MANIP(hooknum) =3D=3D IP_NAT_MANIP_DST) {=0A=
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;=0A=
-		mr.range[0].min =3D mr.range[0].max=0A=
-			=3D ((union ip_conntrack_manip_proto)=0A=
-				{ port });=0A=
+		mr.range[0].min.udp.port =3D mr.range[0].max.udp.port=0A=
+			=3D port;=0A=
 	}=0A=
 	ret =3D ip_nat_setup_info(ct, &mr, hooknum);=0A=
 =0A=

------_=_NextPart_000_01C2D12B.5D1369EC--
