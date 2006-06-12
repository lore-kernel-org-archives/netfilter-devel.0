From: Holger Eitzenberger <holger@my-eitzenberger.de>
Subject: Re: [RFC] libnfnetlink, libnetfilter_log,
	libnetfilter_queue  error handling
Date: Mon, 12 Jun 2006 14:34:47 +0200
Message-ID: <20060612123447.GA18551@kruemel.my-eitzenberger.de>
References: <44899B44.2030605@net.in.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
Content-Disposition: inline
In-Reply-To: <44899B44.2030605@net.in.tum.de>
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


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 09, 2006 at 06:01:08PM +0200, Gregor Maier wrote:

> I noticed that libnfnetlink, libnetfilter_* are currently missing decent
> error handling and reporting mechanisms.

Yes, go ahead and implement proper error handling in the library.  For
ctsyncd I basically commented out all those printf's.

Another point: at least libnetfilter_conntrack is far from "const
clean".  That is: no even a single function in libnetfilter-conntrack
uses 'const' for one of its paramters, though it could.  This is quite
annoying if you use const in your programs.  I have a patch at hand
which does this for functions such as nfct_conntrack_compare and some
others.

I have attached my current version of the patch, status: works-for-me.
May someone please comment on it, I will update if need be.

Thanks.  /holger

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="libnetfilter_conntrack_const_clean.patch"

[NETFILTER] libnetfilter_conntrack: make partly const clean

Not using 'const' in libnetfilter_conntrack does is make hard to
use 'const' in programs using it.  This patch fixes it partly for
the compare and extension libs.

Signed-off-by: Holger Eitzenberger <holger@my-eitzenberger.de>

---
commit 49ead977ec32613b05082a7b583c8abd407e723a
tree 8518d270c18ccb1d1529d956ee6683b4f0b33921
parent 07f71e55c5d9413114661a8d878cf68c698eb7fb
author Holger Eitzenberger <holger@my-eitzenberger.de> Sat, 03 Jun 2006 22:10:58 +0200
committer Holger Eitzenberger <holger@jonathan.my-eitzenberger.de> Sat, 03 Jun 2006 22:10:58 +0200

 extensions/libnetfilter_conntrack_icmp.c           |    7 +++----
 extensions/libnetfilter_conntrack_sctp.c           |    9 ++++-----
 extensions/libnetfilter_conntrack_tcp.c            |    9 ++++-----
 extensions/libnetfilter_conntrack_udp.c            |    7 +++----
 .../libnetfilter_conntrack.h                       |    6 +++---
 .../libnetfilter_conntrack_extensions.h            |    8 ++++----
 .../libnetfilter_conntrack_l3extensions.h          |    7 ++++---
 l3extensions/libnetfilter_conntrack_ipv4.c         |    7 +++----
 l3extensions/libnetfilter_conntrack_ipv6.c         |    7 +++----
 src/libnetfilter_conntrack.c                       |    6 +++---
 10 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/extensions/libnetfilter_conntrack_icmp.c b/extensions/libnetfilter_conntrack_icmp.c
index 72a7eb0..a6efb7b 100644
--- a/extensions/libnetfilter_conntrack_icmp.c
+++ b/extensions/libnetfilter_conntrack_icmp.c
@@ -43,7 +43,7 @@ static void build_tuple_proto(struct nfn
 		       &t->l4src.icmp.id, sizeof(u_int16_t));
 }
 
-static int print_proto(char *buf, struct nfct_tuple *t)
+static int print_proto(char *buf, const struct nfct_tuple *t)
 {
 	/* The ID only makes sense some ICMP messages but we want to
 	 * display the same output that /proc/net/ip_conntrack does */
@@ -52,9 +52,8 @@ static int print_proto(char *buf, struct
 						      ntohs(t->l4src.icmp.id)));
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+		   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & ICMP_TYPE)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l4dst.icmp.type !=
diff --git a/extensions/libnetfilter_conntrack_sctp.c b/extensions/libnetfilter_conntrack_sctp.c
index 3785c2e..1aea39a 100644
--- a/extensions/libnetfilter_conntrack_sctp.c
+++ b/extensions/libnetfilter_conntrack_sctp.c
@@ -44,21 +44,20 @@ static void build_tuple_proto(struct nfn
 		       &t->l4dst.sctp.port, sizeof(u_int16_t));
 }
 
-static int print_protoinfo(char *buf, union nfct_protoinfo *protoinfo)
+static int print_protoinfo(char *buf, const union nfct_protoinfo *protoinfo)
 {
 /*	fprintf(stdout, "%s ", states[protoinfo->sctp.state]); */
 	return 0;
 }
 
-static int print_proto(char *buf, struct nfct_tuple *tuple)
+static int print_proto(char *buf, const struct nfct_tuple *tuple)
 {
 	return(sprintf(buf, "sport=%u dport=%u ", htons(tuple->l4src.sctp.port),
 						  htons(tuple->l4dst.sctp.port)));
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+				   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & SCTP_ORIG_SPORT)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l4src.sctp.port !=
diff --git a/extensions/libnetfilter_conntrack_tcp.c b/extensions/libnetfilter_conntrack_tcp.c
index 9efdbb7..9c6aa04 100644
--- a/extensions/libnetfilter_conntrack_tcp.c
+++ b/extensions/libnetfilter_conntrack_tcp.c
@@ -83,20 +83,19 @@ static void build_protoinfo(struct nfnlh
 	nfnl_nest_end(&req->nlh, nest_proto);
 }
 
-static int print_protoinfo(char *buf, union nfct_protoinfo *protoinfo)
+static int print_protoinfo(char *buf, const union nfct_protoinfo *protoinfo)
 {
 	return(sprintf(buf, "%s ", states[protoinfo->tcp.state]));
 }
 
-static int print_proto(char *buf, struct nfct_tuple *tuple)
+static int print_proto(char *buf, const struct nfct_tuple *tuple)
 {
 	return(sprintf(buf, "sport=%u dport=%u ", htons(tuple->l4src.tcp.port),
 					          htons(tuple->l4dst.tcp.port)));
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+				   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & TCP_ORIG_SPORT)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l4src.tcp.port !=
diff --git a/extensions/libnetfilter_conntrack_udp.c b/extensions/libnetfilter_conntrack_udp.c
index c1d20c3..a329c4a 100644
--- a/extensions/libnetfilter_conntrack_udp.c
+++ b/extensions/libnetfilter_conntrack_udp.c
@@ -27,7 +27,7 @@ static void parse_proto(struct nfattr *c
 			*(u_int16_t *)NFA_DATA(cda[CTA_PROTO_DST_PORT-1]);
 }
 
-static int print_proto(char *buf, struct nfct_tuple *tuple)
+static int print_proto(char *buf, const struct nfct_tuple *tuple)
 {
 	return (sprintf(buf, "sport=%u dport=%u ", htons(tuple->l4src.udp.port),
 					           htons(tuple->l4dst.udp.port)));
@@ -42,9 +42,8 @@ static void build_tuple_proto(struct nfn
 		       &t->l4dst.udp.port, sizeof(u_int16_t));
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+				   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & UDP_ORIG_SPORT)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l4src.udp.port !=
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 3bd30ff..c9ae564 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -299,9 +299,9 @@ extern int nfct_sprintf_id(char *buf, u_
 /*
  * Conntrack comparison
  */
-extern int nfct_conntrack_compare(struct nfct_conntrack *ct1, 
-				  struct nfct_conntrack *ct2,
-				  struct nfct_conntrack_compare *cmp);
+extern int nfct_conntrack_compare(const struct nfct_conntrack *ct1, 
+				  const struct nfct_conntrack *ct2,
+				  const struct nfct_conntrack_compare *cmp);
 
 /* 
  * Expectations
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h b/include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h
index db7828d..c678f01 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack_extensions.h
@@ -27,10 +27,10 @@ struct nfct_proto {
 	void (*parse_protoinfo)(struct nfattr **, struct nfct_conntrack *);
 	void (*build_tuple_proto)(struct nfnlhdr *, int, struct nfct_tuple *);
 	void (*build_protoinfo)(struct nfnlhdr *, int, struct nfct_conntrack *);
-	int (*print_protoinfo)(char *, union nfct_protoinfo *);
-	int (*print_proto)(char *, struct nfct_tuple *);
-	int (*compare)(struct nfct_conntrack *, struct nfct_conntrack *,
-		       unsigned int);
+	int (*print_protoinfo)(char *, const union nfct_protoinfo *);
+	int (*print_proto)(char *, const struct nfct_tuple *);
+	int (*compare)(const struct nfct_conntrack *,
+				   const struct nfct_conntrack *, unsigned int);
 };
 
 extern void nfct_register_proto(struct nfct_proto *h);
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack_l3extensions.h b/include/libnetfilter_conntrack/libnetfilter_conntrack_l3extensions.h
index 86e002a..2f840ec 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack_l3extensions.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack_l3extensions.h
@@ -19,9 +19,10 @@ struct nfct_l3proto {
 	
 	void (*parse_proto)(struct nfattr **, struct nfct_tuple *);
 	void (*build_tuple_proto)(struct nfnlhdr *, int, struct nfct_tuple *);
-	int (*print_proto)(char *, struct nfct_tuple *);
-	int (*compare)(struct nfct_conntrack *, struct nfct_conntrack *,
-		       unsigned int);
+	int (*print_proto)(char *, const struct nfct_tuple *);
+	int (*compare)(const struct nfct_conntrack *,
+				   const struct nfct_conntrack *,
+				   unsigned int);
 };
 
 extern void nfct_register_l3proto(struct nfct_l3proto *h);
diff --git a/l3extensions/libnetfilter_conntrack_ipv4.c b/l3extensions/libnetfilter_conntrack_ipv4.c
index 727ea01..08b24b7 100644
--- a/l3extensions/libnetfilter_conntrack_ipv4.c
+++ b/l3extensions/libnetfilter_conntrack_ipv4.c
@@ -32,7 +32,7 @@ static void build_tuple_proto(struct nfn
 		       sizeof(u_int32_t));
 }
 
-static int print_proto(char *buf, struct nfct_tuple *tuple)
+static int print_proto(char *buf, const struct nfct_tuple *tuple)
 {
 	struct in_addr src = { .s_addr = tuple->src.v4 };
 	struct in_addr dst = { .s_addr = tuple->dst.v4 };
@@ -44,9 +44,8 @@ static int print_proto(char *buf, struct
 	return size;
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+		   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & IPV4_ORIG)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l3protonum !=
diff --git a/l3extensions/libnetfilter_conntrack_ipv6.c b/l3extensions/libnetfilter_conntrack_ipv6.c
index b0c7a3f..ec16b8b 100644
--- a/l3extensions/libnetfilter_conntrack_ipv6.c
+++ b/l3extensions/libnetfilter_conntrack_ipv6.c
@@ -41,7 +41,7 @@ static void build_tuple_proto(struct nfn
 		       sizeof(u_int32_t)*4);
 }
 
-static int print_proto(char *buf, struct nfct_tuple *tuple)
+static int print_proto(char *buf, const struct nfct_tuple *tuple)
 {
 	struct in6_addr src;
 	struct in6_addr dst;
@@ -61,9 +61,8 @@ static int print_proto(char *buf, struct
 	return size;
 }
 
-static int compare(struct nfct_conntrack *ct1,
-		   struct nfct_conntrack *ct2,
-		   unsigned int flags)
+static int compare(const struct nfct_conntrack *ct1,
+		   const struct nfct_conntrack *ct2, unsigned int flags)
 {
 	if (flags & IPV6_ORIG)
 		if (ct1->tuple[NFCT_DIR_ORIGINAL].l3protonum !=
diff --git a/src/libnetfilter_conntrack.c b/src/libnetfilter_conntrack.c
index 0110261..1ec3231 100644
--- a/src/libnetfilter_conntrack.c
+++ b/src/libnetfilter_conntrack.c
@@ -926,9 +926,9 @@ void nfct_conntrack_free(struct nfct_con
 #define L3PROTONUM(ct) ct->tuple[NFCT_DIR_ORIGINAL].l3protonum
 #define L4PROTONUM(ct) ct->tuple[NFCT_DIR_ORIGINAL].protonum
 
-int nfct_conntrack_compare(struct nfct_conntrack *ct1,
-			   struct nfct_conntrack *ct2,
-			   struct nfct_conntrack_compare *cmp)
+int nfct_conntrack_compare(const struct nfct_conntrack *ct1,
+			   const struct nfct_conntrack *ct2,
+			   const struct nfct_conntrack_compare *cmp)
 {
 	struct nfct_l3proto *l3proto;
 	struct nfct_proto *proto;

--ew6BAiZeqk4r7MaW--
