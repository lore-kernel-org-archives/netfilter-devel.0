From: Stephane Ouellette <stephane.ouellette@uni-comm.ca>
Subject: [PATCH]  libip6t_frag.c
Date: Fri, 05 Sep 2003 02:48:05 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5831A5.3060804@uni-comm.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000105080304000405090104"
Cc: Netfilter Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------000105080304000405090104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald,

   the following patch includes:

1- printf() simplifications,
2- indentation fixes,
3- C99 initializers.

Please apply.

Stephane

--------------000105080304000405090104
Content-Type: text/plain;
 name="libip6t_frag.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libip6t_frag.c.patch"

--- netfilter.orig/userspace/extensions/libip6t_frag.c	Wed May 29 09:08:16 2002
+++ netfilter/userspace/extensions/libip6t_frag.c	Mon Aug 11 22:09:46 2003
@@ -24,13 +24,13 @@
 }
 
 static struct option opts[] = {
-	{ "fragid", 1, 0, '1' },
-	{ "fraglen", 1, 0, '2' },
-	{ "fragres", 0, 0, '3' },
-	{ "fragfirst", 0, 0, '4' },
-	{ "fragmore", 0, 0, '5' },
-	{ "fraglast", 0, 0, '6' },
-	{0}
+	{ .name = "fragid",    .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "fraglen",   .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "fragres",   .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = "fragfirst", .has_arg = 0, .flag = 0, .val = '4' },
+	{ .name = "fragmore",  .has_arg = 0, .flag = 0, .val = '5' },
+	{ .name = "fraglast",  .has_arg = 0, .flag = 0, .val = '6' },
+	{ .name = 0 }
 };
 
 static u_int32_t
@@ -39,7 +39,7 @@
 	unsigned long int id;
 	char* ep;
 
-	id =  strtoul(idstr,&ep,0) ;
+	id = strtoul(idstr, &ep, 0);
 
 	if ( idstr == ep ) {
 		exit_error(PARAMETER_PROBLEM,
@@ -171,16 +171,10 @@
 
 	if (min != 0 || max != 0xFFFFFFFF || invert) {
 		printf("%s", name);
-		if (min == max) {
-			printf(":%s", inv);
-			printf("%u", min);
-		} else {
-			printf("s:%s", inv);
-			printf("%u",min);
-			printf(":");
-			printf("%u",max);
-		}
-		printf(" ");
+		if (min == max)
+			printf(":%s%u ", inv, min);
+		else
+			printf("s:%s%u:%u ", inv, min, max);
 	}
 }
 
@@ -194,16 +188,25 @@
 	printf("frag ");
 	print_ids("id", frag->ids[0], frag->ids[1],
 		    frag->invflags & IP6T_FRAG_INV_IDS);
+
 	if (frag->flags & IP6T_FRAG_LEN) {
-		printf("length");
-		printf(":%s", frag->invflags & IP6T_FRAG_INV_LEN ? "!" : "");
-		printf("%u", frag->hdrlen);
-		printf(" ");
-	}
-	if (frag->flags & IP6T_FRAG_RES) printf("reserved ");
-	if (frag->flags & IP6T_FRAG_FST) printf("first ");
-	if (frag->flags & IP6T_FRAG_MF) printf("more ");
-	if (frag->flags & IP6T_FRAG_NMF) printf("last ");
+		printf("length:%s%u ",
+			frag->invflags & IP6T_FRAG_INV_LEN ? "!" : "",
+			frag->hdrlen);
+	}
+
+	if (frag->flags & IP6T_FRAG_RES)
+		printf("reserved ");
+
+	if (frag->flags & IP6T_FRAG_FST)
+		printf("first ");
+
+	if (frag->flags & IP6T_FRAG_MF)
+		printf("more ");
+
+	if (frag->flags & IP6T_FRAG_NMF)
+		printf("last ");
+
 	if (frag->invflags & ~IP6T_FRAG_INV_MASK)
 		printf("Unknown invflags: 0x%X ",
 		       frag->invflags & ~IP6T_FRAG_INV_MASK);
@@ -234,27 +237,32 @@
 			fraginfo->hdrlen);
 	}
 
-	if (fraginfo->flags & IP6T_FRAG_RES) printf("--fragres ");
-	if (fraginfo->flags & IP6T_FRAG_FST) printf("--fragfirst ");
-	if (fraginfo->flags & IP6T_FRAG_MF) printf("--fragmore ");
-	if (fraginfo->flags & IP6T_FRAG_NMF) printf("--fraglast ");
+	if (fraginfo->flags & IP6T_FRAG_RES)
+		printf("--fragres ");
+
+	if (fraginfo->flags & IP6T_FRAG_FST)
+		printf("--fragfirst ");
+
+	if (fraginfo->flags & IP6T_FRAG_MF)
+		printf("--fragmore ");
 
+	if (fraginfo->flags & IP6T_FRAG_NMF)
+		printf("--fraglast ");
 }
 
 static
-struct ip6tables_match frag
-= { NULL,
-    "frag",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_frag)),
-    IP6T_ALIGN(sizeof(struct ip6t_frag)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_match frag = {
+	.name          = "frag",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_frag)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_frag)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void

--------------000105080304000405090104--
