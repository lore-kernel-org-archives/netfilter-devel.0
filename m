From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]   Less calls to printf()  for libip6t_ah.c
Date: Tue, 12 Aug 2003 14:02:54 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F392BCE.30005@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_WGdfjrkuuFXYD4cfL/hYOw)"
Cc: netfilter-devel@lists.netfilter.org
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

--Boundary_(ID_WGdfjrkuuFXYD4cfL/hYOw)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

    forget about the first patch I've sent you for libip6t_ah.c.

    The attached patch includes all the changes of the first patch but 
adds more printf() simplifications.

Please apply.

Stephane.


--Boundary_(ID_WGdfjrkuuFXYD4cfL/hYOw)
Content-type: text/plain; name=libip6t_ah.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_ah.c.patch

--- netfilter.orig/userspace/extensions/libip6t_ah.c	Wed May 29 09:08:15 2002
+++ netfilter/userspace/extensions/libip6t_ah.c	Tue Aug 12 13:56:32 2003
@@ -21,10 +21,10 @@
 }
 
 static struct option opts[] = {
-	{ "ahspi", 1, 0, '1' },
-	{ "ahlen", 1, 0, '2' },
-	{ "ahres", 0, 0, '3' },
-	{0}
+	{ .name = "ahspi", .has_arg = 1, .flag = 0, .val = '1' },
+	{ .name = "ahlen", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "ahres", .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 
 static u_int32_t
@@ -33,21 +33,21 @@
 	unsigned long int spi;
 	char* ep;
 
-	spi =  strtoul(spistr,&ep,0) ;
+	spi = strtoul(spistr, &ep, 0);
 
-	if ( spistr == ep ) {
+	if ( spistr == ep )
 		exit_error(PARAMETER_PROBLEM,
 			   "AH no valid digits in %s `%s'", typestr, spistr);
-	}
-	if ( spi == ULONG_MAX  && errno == ERANGE ) {
+
+	if ( spi == ULONG_MAX  && errno == ERANGE )
 		exit_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, spistr);
-	}	
-	if ( *spistr != '\0'  && *ep != '\0' ) {
+
+	if ( *spistr != '\0'  && *ep != '\0' )
 		exit_error(PARAMETER_PROBLEM,
 			   "AH error parsing %s `%s'", typestr, spistr);
-	}
+
 	return (u_int32_t) spi;
 }
 
@@ -59,13 +59,13 @@
 
 	buffer = strdup(spistring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_ah_spi(buffer,"spi");
+		spis[0] = spis[1] = parse_ah_spi(buffer, "spi");
 	else {
 		*cp = '\0';
 		cp++;
 
-		spis[0] = buffer[0] ? parse_ah_spi(buffer,"spi") : 0;
-		spis[1] = cp[0] ? parse_ah_spi(cp,"spi") : 0xFFFFFFFF;
+		spis[0] = buffer[0] ? parse_ah_spi(buffer, "spi") : 0;
+		spis[1] = cp[0] ? parse_ah_spi(cp, "spi") : 0xFFFFFFFF;
 	}
 	free(buffer);
 }
@@ -139,17 +139,10 @@
 	const char *inv = invert ? "!" : "";
 
 	if (min != 0 || max != 0xFFFFFFFF || invert) {
-		printf("%s", name);
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
+			printf("%s:%s%u ", name, inv, min);
+		else
+			printf("%ss:%s%u:%u ", name, inv, min, max);
 	}
 }
 
@@ -158,12 +151,8 @@
 {
 	const char *inv = invert ? "!" : "";
 
-	if (len != 0 || invert) {
-		printf("%s", name);
-		printf(":%s", inv);
-		printf("%u", len);
-		printf(" ");
-	}
+	if (len != 0 || invert)
+		printf("%s:%s%u ", name, inv, len);
 }
 
 /* Prints out the union ip6t_matchinfo. */
@@ -178,7 +167,10 @@
 		    ah->invflags & IP6T_AH_INV_SPI);
 	print_len("length", ah->hdrlen, 
 		    ah->invflags & IP6T_AH_INV_LEN);
-	if (ah->hdrres) printf("reserved ");
+
+	if (ah->hdrres)
+		printf("reserved ");
+
 	if (ah->invflags & ~IP6T_AH_INV_MASK)
 		printf("Unknown invflags: 0x%X ",
 		       ah->invflags & ~IP6T_AH_INV_MASK);
@@ -209,26 +201,23 @@
 			ahinfo->hdrlen);
 	}
 
-	if (ahinfo->hdrres != 0 ) {
+	if (ahinfo->hdrres != 0 )
 		printf("--ahres ");
-	}
-
 }
 
 static
-struct ip6tables_match ah
-= { NULL,
-    "ah",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_ah)),
-    IP6T_ALIGN(sizeof(struct ip6t_ah)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+struct ip6tables_match ah = {
+	.name          = "ah",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_ah)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_ah)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };
 
 void

--Boundary_(ID_WGdfjrkuuFXYD4cfL/hYOw)--
