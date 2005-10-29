From: Pablo Neira <pablo@eurodev.net>
Subject: Re: remaining libnetfilter_conntrack issues
Date: Sat, 29 Oct 2005 14:45:27 +0200
Message-ID: <43636EE7.20601@eurodev.net>
References: <20051028205955.GA10568@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000205080009030809040508"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051028205955.GA10568@rama.de.gnumonks.org>
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

This is a multi-part message in MIME format.
--------------000205080009030809040508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald!

Harald Welte wrote:
> I've started to write a new ulogd2 plugin against the new
> libnetfilter_conntrack, and found a number of issues, mostly related to
> header files:
> 
> 1) why do we need 'asm/types.h'?  this is unacceptable
> 2) why do we need 'linux/if.h'?

I just killed those. I'm not aware of having added those by myself, my 
guess is that they are remains of the primitive libctnetlink.

> 3) libnetfilter_conntrack needs to be split into two parts:
> 	a) what is visible to application programs
> 	b) what is visible to extensions
> 4) if we do '3', we can get rid of the ugly "linux_list.h" include

OK, now we have libnetfilter_conntrack.h and 
libnetfilter_conntrack_extensions.h, have a look at the patch below. I'm 
going to commit it asap.

> 5) we'd ideally get rid of the ip_conntrack.h include, too

I just did it, we just need the status bits. So I just took them from 
ip_conntrack.h

> 6) we should ship a copy of both nfnetlink.h and nfnetlink_conntrack.h with the library
>    this way userspace programs can be built without any
>    nfnetlink-enabled kernel headers installed.
> 
> All copies should be performed during the 'distrib' stage, i.e. every
> time we make a release we tell the automake/autoconf system where to
> take a current copy of those headers from.  They would not be present in
> svn.

OK, so we could just do it in autogen.sh, that would be quite straight 
forward. fine with it?

> 7) we put the definition of the 'nfct_handle' into a private header
>    file. this is good practise for encapsulation, since it prevents the
>    application from making any assumptions about its size and/or
>    contents.

Done

> 8) IPv6 addresses are 128bit, not 64!

Aiee, fixed as well.

I think we can release the first 1.0 version of conntrack this week, 
together with the first release of libnetfilter_conntrack. As soon as I 
finish the test for the expectation part of libnetfilter_conntrack (see 
utils) and fix some remaining problems reported on netfilter-devel. 
Then, I'll have a look back at your previous email detailing how to do 
releases, I didn't have time to do it up to now.

cheers,
Pablo

--------------000205080009030809040508
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: extensions/libnetfilter_conntrack_sctp.c
===================================================================
--- extensions/libnetfilter_conntrack_sctp.c	(revision 4394)
+++ extensions/libnetfilter_conntrack_sctp.c	(working copy)
@@ -14,6 +14,7 @@
 #include <netinet/in.h> /* For htons */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_extensions.h>
 
 void parse_proto(struct nfattr *cda[], struct nfct_tuple *tuple)
 {
Index: extensions/libnetfilter_conntrack_tcp.c
===================================================================
--- extensions/libnetfilter_conntrack_tcp.c	(revision 4394)
+++ extensions/libnetfilter_conntrack_tcp.c	(working copy)
@@ -14,6 +14,7 @@
 #include <netinet/in.h> /* For htons */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_extensions.h>
 
 static const char *states[] = {
 	"NONE",
Index: extensions/libnetfilter_conntrack_icmp.c
===================================================================
--- extensions/libnetfilter_conntrack_icmp.c	(revision 4394)
+++ extensions/libnetfilter_conntrack_icmp.c	(working copy)
@@ -14,6 +14,7 @@
 #include <netinet/in.h> /* For htons */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_extensions.h>
 
 void parse_proto(struct nfattr *cda[], struct nfct_tuple *tuple)
 {
Index: extensions/libnetfilter_conntrack_udp.c
===================================================================
--- extensions/libnetfilter_conntrack_udp.c	(revision 4394)
+++ extensions/libnetfilter_conntrack_udp.c	(working copy)
@@ -14,6 +14,7 @@
 #include <netinet/in.h> /* For htons */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_extensions.h>
 
 void parse_proto(struct nfattr *cda[], struct nfct_tuple *tuple)
 {
Index: include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h	(revision 0)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h	(revision 0)
@@ -0,0 +1,28 @@
+/*
+ * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#ifndef _LIBNETFILTER_CONNTRACK_EXTENSIONS_H_
+#define _LIBNETFILTER_CONNTRACK_EXTENSIONS_H_
+
+#include "linux_list.h"
+
+struct nfct_proto {
+	struct list_head head;
+	
+	char 		*name;
+	u_int8_t 	protonum;
+	char		*version;
+	
+	void (*parse_proto)(struct nfattr **, struct nfct_tuple *);
+	void (*parse_protoinfo)(struct nfattr **, struct nfct_conntrack *);
+	int (*print_protoinfo)(char *, union nfct_protoinfo *);
+	int (*print_proto)(char *, struct nfct_tuple *);
+};
+
+extern void nfct_register_proto(struct nfct_proto *h);
+
+#endif
Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(revision 4394)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(working copy)
@@ -9,13 +9,9 @@
 #define _LIBNETFILTER_CONNTRACK_H_
 
 #include <netinet/in.h>
-#include <asm/types.h>
-#include <linux/if.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h> 
 #include <libnfnetlink/libnfnetlink.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include "linux_list.h"
 
 #define LIBNETFILTER_CONNTRACK_VERSION "0.2.0"
 
@@ -57,7 +53,7 @@
 struct nfct_tuple {
 	union {
 		u_int32_t v4;
-		u_int64_t v6;
+		u_int32_t v6[4];
 	} src;
 
 	union {
@@ -112,18 +108,6 @@
 	unsigned int id;
 };
 
-struct nfct_proto {
-	struct list_head head;
-	
-	char 		*name;
-	u_int8_t 	protonum;
-	char		*version;
-	
-	void (*parse_proto)(struct nfattr **, struct nfct_tuple *);
-	void (*parse_protoinfo)(struct nfattr **, struct nfct_conntrack *);
-	int (*print_protoinfo)(char *, union nfct_protoinfo *);
-	int (*print_proto)(char *, struct nfct_tuple *);
-};
 
 enum {
 	NFCT_STATUS_BIT = 0,
@@ -151,6 +135,58 @@
 	NFCT_ID = (1 << NFCT_ID_BIT)
 };
 
+/* Bitset representing status of connection. Taken from ip_conntrack.h
+ * 
+ * Note: For backward compatibility this shouldn't ever change
+ * 	 in kernel space.
+ */
+enum ip_conntrack_status {
+	/* It's an expected connection: bit 0 set.  This bit never changed */
+	IPS_EXPECTED_BIT = 0,
+	IPS_EXPECTED = (1 << IPS_EXPECTED_BIT),
+
+	/* We've seen packets both ways: bit 1 set.  Can be set, not unset. */
+	IPS_SEEN_REPLY_BIT = 1,
+	IPS_SEEN_REPLY = (1 << IPS_SEEN_REPLY_BIT),
+
+	/* Conntrack should never be early-expired. */
+	IPS_ASSURED_BIT = 2,
+	IPS_ASSURED = (1 << IPS_ASSURED_BIT),
+
+	/* Connection is confirmed: originating packet has left box */
+	IPS_CONFIRMED_BIT = 3,
+	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
+
+	/* Connection needs src nat in orig dir.  This bit never changed. */
+	IPS_SRC_NAT_BIT = 4,
+	IPS_SRC_NAT = (1 << IPS_SRC_NAT_BIT),
+
+	/* Connection needs dst nat in orig dir.  This bit never changed. */
+	IPS_DST_NAT_BIT = 5,
+	IPS_DST_NAT = (1 << IPS_DST_NAT_BIT),
+
+	/* Both together. */
+	IPS_NAT_MASK = (IPS_DST_NAT | IPS_SRC_NAT),
+
+	/* Connection needs TCP sequence adjusted. */
+	IPS_SEQ_ADJUST_BIT = 6,
+	IPS_SEQ_ADJUST = (1 << IPS_SEQ_ADJUST_BIT),
+
+	/* NAT initialization bits. */
+	IPS_SRC_NAT_DONE_BIT = 7,
+	IPS_SRC_NAT_DONE = (1 << IPS_SRC_NAT_DONE_BIT),
+
+	IPS_DST_NAT_DONE_BIT = 8,
+	IPS_DST_NAT_DONE = (1 << IPS_DST_NAT_DONE_BIT),
+
+	/* Both together */
+	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+
+	/* Connection is dying (removed from lists), can not be unset. */
+	IPS_DYING_BIT = 9,
+	IPS_DYING = (1 << IPS_DYING_BIT),
+};
+
 enum {
 	NFCT_MSG_UNKNOWN,
 	NFCT_MSG_NEW,
@@ -163,14 +199,6 @@
 typedef int (*nfct_handler)(struct nfct_handle *cth, struct nlmsghdr *nlh,
 			    void *arg);
 
-struct nfct_handle {
-	struct nfnl_handle nfnlh;
-	nfct_callback callback;		/* user callback */
-	nfct_handler handler;		/* netlink handler */
-};
-
-extern void nfct_register_proto(struct nfct_proto *h);
-
 /*
  * [Allocate|free] a conntrack
  */
Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(revision 4397)
+++ src/libnetfilter_conntrack.c	(working copy)
@@ -17,6 +17,7 @@
 #include "linux_list.h"
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_extensions.h>
 
 #define NFCT_BUFSIZE 4096
 
@@ -26,6 +27,13 @@
 	((unsigned char *)&addr)[2], \
 	((unsigned char *)&addr)[3]
 
+/* Harald says: "better for encapsulation" ;) */
+struct nfct_handle {
+	struct nfnl_handle nfnlh;
+	nfct_callback callback;		/* user callback */
+	nfct_handler handler;		/* netlink handler */
+};
+
 static char *lib_dir = LIBNETFILTER_CONNTRACK_DIR;
 static LIST_HEAD(proto_list);
 static char *proto2str[IPPROTO_MAX] = {

--------------000205080009030809040508--
