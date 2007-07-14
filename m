From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 37/43] Unifies libip[6]t_esp.c into libxt_esp.c
Date: Sun, 15 Jul 2007 03:12:45 +0900 (JST)
Message-ID: <200707141812.l6EICkZj003333@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


---
 extensions/.esp-test6                   |    2 -
 extensions/Makefile                     |    4 +-
 extensions/libip6t_esp.c                |  185 ----------------------------
 extensions/libipt_esp.c                 |  193 -----------------------------
 extensions/libxt_esp.c                  |  204 +++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_esp.h        |   14 ++
 include/linux/netfilter_ipv4/ipt_esp.h  |   16 ---
 include/linux/netfilter_ipv6/ip6t_esp.h |   23 ----
 8 files changed, 220 insertions(+), 421 deletions(-)
 delete mode 100755 extensions/.esp-test6
 delete mode 100644 extensions/libip6t_esp.c
 delete mode 100644 extensions/libipt_esp.c
 create mode 100644 extensions/libxt_esp.c
 create mode 100644 include/linux/netfilter/xt_esp.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_esp.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_esp.h

diff --git a/extensions/.esp-test6 b/extensions/.esp-test6
deleted file mode 100755
index 7ded945..0000000
--- a/extensions/.esp-test6
+++ /dev/null
@@ -1,2 +0,0 @@
-#!/bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_esp.h ] && echo esp
diff --git a/extensions/Makefile b/extensions/Makefile
index 7a76ce0..6b9a3e9 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn hashlimit helper icmp iprange owner policy realm state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
 PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 owner policy state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
+PFX_EXT_SLIB:=esp length limit mac mark multiport physdev pkttype sctp standard tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_esp.c b/extensions/libip6t_esp.c
deleted file mode 100644
index 04cc546..0000000
--- a/extensions/libip6t_esp.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/* Shared library add-on to ip6tables to add ESP support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6t_esp.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"ESP v%s options:\n"
-" --espspi [!] spi[:spi]        match spi (range)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ .name = "espspi", .has_arg = 1, .flag = 0, .val = '1' },
-	{ .name = 0 }
-};
-
-static u_int32_t
-parse_esp_spi(const char *spistr)
-{
-	unsigned long int spi;
-	char* ep;
-
-	spi = strtoul(spistr, &ep, 0);
-
-	if ( spistr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "ESP no valid digits in spi `%s'", spistr);
-	}
-	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "spi `%s' specified too big: would overflow", spistr);
-	}	
-	if ( *spistr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "ESP error parsing spi `%s'", spistr);
-	}
-	return (u_int32_t) spi;
-}
-
-static void
-parse_esp_spis(const char *spistring, u_int32_t *spis)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(spistring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_esp_spi(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
-		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
-		if (spis[0] > spis[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "Invalid ESP spi range: %s", spistring);
-	}
-	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ip6t_esp *espinfo = (struct ip6t_esp *)m->data;
-
-	espinfo->spis[1] = 0xFFFFFFFF;
-}
-
-#define ESP_SPI 0x01
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_esp *espinfo = (struct ip6t_esp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & ESP_SPI)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--espspi' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_esp_spis(argv[optind-1], espinfo->spis);
-		if (invert)
-			espinfo->invflags |= IP6T_ESP_INV_SPI;
-		*flags |= ESP_SPI;
-		break;
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
-static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
-{
-	const char *inv = invert ? "!" : "";
-
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
-		if (min == max)
-			printf("%s:%s%u ", name, inv, min);
-		else
-			printf("%ss:%s%u:%u ", name, inv, min, max);
-	}
-}
-
-/* Prints out the union ip6t_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ip6t_esp *esp = (struct ip6t_esp *)match->data;
-
-	printf("esp ");
-	print_spis("spi", esp->spis[0], esp->spis[1],
-		    esp->invflags & IP6T_ESP_INV_SPI);
-	if (esp->invflags & ~IP6T_ESP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       esp->invflags & ~IP6T_ESP_INV_MASK);
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ip6t_esp *espinfo = (struct ip6t_esp *)match->data;
-
-	if (!(espinfo->spis[0] == 0
-	    && espinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("--espspi %s", 
-			(espinfo->invflags & IP6T_ESP_INV_SPI) ? "! " : "");
-		if (espinfo->spis[0]
-		    != espinfo->spis[1])
-			printf("%u:%u ",
-			       espinfo->spis[0],
-			       espinfo->spis[1]);
-		else
-			printf("%u ",
-			       espinfo->spis[0]);
-	}
-
-}
-
-static
-struct ip6tables_match esp = {
-	.name          = "esp",
-	.version       = IPTABLES_VERSION,
-	.size          = IP6T_ALIGN(sizeof(struct ip6t_esp)),
-	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_esp)),
-	.help          = &help,
-	.init          = &init,
-	.parse         = &parse,
-	.final_check   = &final_check,
-	.print         = &print,
-	.save          = &save,
-	.extra_opts    = opts
-};
-
-void
-_init(void)
-{
-	register_match6(&esp);
-}
diff --git a/extensions/libipt_esp.c b/extensions/libipt_esp.c
deleted file mode 100644
index b675f5b..0000000
--- a/extensions/libipt_esp.c
+++ /dev/null
@@ -1,193 +0,0 @@
-/* Shared library add-on to iptables to add ESP support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <errno.h>
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_esp.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"ESP v%s options:\n"
-" --espspi [!] spi[:spi]\n"
-"				match spi (range)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "espspi", 1, 0, '1' },
-	{0}
-};
-
-static u_int32_t
-parse_esp_spi(const char *spistr)
-{
-	unsigned long int spi;
-	char* ep;
-
-	spi =  strtoul(spistr,&ep,0) ;
-
-	if ( spistr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "ESP no valid digits in spi `%s'", spistr);
-	}
-	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "spi `%s' specified too big: would overflow", spistr);
-	}	
-	if ( *spistr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
-			   "ESP error parsing spi `%s'", spistr);
-	}
-	return (u_int32_t) spi;
-}
-
-static void
-parse_esp_spis(const char *spistring, u_int32_t *spis)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(spistring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		spis[0] = spis[1] = parse_esp_spi(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
-		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
-		if (spis[0] > spis[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "Invalid ESP spi range: %s", spistring);
-	}
-	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ipt_esp *espinfo = (struct ipt_esp *)m->data;
-
-	espinfo->spis[1] = 0xFFFFFFFF;
-}
-
-#define ESP_SPI 0x01
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_esp *espinfo = (struct ipt_esp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & ESP_SPI)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--espspi' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_esp_spis(argv[optind-1], espinfo->spis);
-		if (invert)
-			espinfo->invflags |= IPT_ESP_INV_SPI;
-		*flags |= ESP_SPI;
-		break;
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
-static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
-{
-	const char *inv = invert ? "!" : "";
-
-	if (min != 0 || max != 0xFFFFFFFF || invert) {
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
-	}
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ipt_esp *esp = (struct ipt_esp *)match->data;
-
-	printf("esp ");
-	print_spis("spi", esp->spis[0], esp->spis[1],
-		    esp->invflags & IPT_ESP_INV_SPI);
-	if (esp->invflags & ~IPT_ESP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       esp->invflags & ~IPT_ESP_INV_MASK);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_esp *espinfo = (struct ipt_esp *)match->data;
-
-	if (!(espinfo->spis[0] == 0
-	    && espinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("--espspi %s", 
-			(espinfo->invflags & IPT_ESP_INV_SPI) ? "! " : "");
-		if (espinfo->spis[0]
-		    != espinfo->spis[1])
-			printf("%u:%u ",
-			       espinfo->spis[0],
-			       espinfo->spis[1]);
-		else
-			printf("%u ",
-			       espinfo->spis[0]);
-	}
-
-}
-
-static struct iptables_match esp = { 
-	.next 		= NULL,
-	.name 		= "esp",
-	.version 	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_esp)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_esp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void
-_init(void)
-{
-	register_match(&esp);
-}
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
new file mode 100644
index 0000000..401c104
--- /dev/null
+++ b/extensions/libxt_esp.c
@@ -0,0 +1,204 @@
+/* Shared library add-on to iptables to add ESP support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <errno.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_esp.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"ESP v%s options:\n"
+" --espspi [!] spi[:spi]\n"
+"				match spi (range)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "espspi", 1, 0, '1' },
+	{0}
+};
+
+static u_int32_t
+parse_esp_spi(const char *spistr)
+{
+	unsigned long int spi;
+	char* ep;
+
+	spi =  strtoul(spistr,&ep,0) ;
+
+	if ( spistr == ep ) {
+		exit_error(PARAMETER_PROBLEM,
+			   "ESP no valid digits in spi `%s'", spistr);
+	}
+	if ( spi == ULONG_MAX  && errno == ERANGE ) {
+		exit_error(PARAMETER_PROBLEM,
+			   "spi `%s' specified too big: would overflow", spistr);
+	}	
+	if ( *spistr != '\0'  && *ep != '\0' ) {
+		exit_error(PARAMETER_PROBLEM,
+			   "ESP error parsing spi `%s'", spistr);
+	}
+	return (u_int32_t) spi;
+}
+
+static void
+parse_esp_spis(const char *spistring, u_int32_t *spis)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(spistring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		spis[0] = spis[1] = parse_esp_spi(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
+		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
+		if (spis[0] > spis[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid ESP spi range: %s", spistring);
+	}
+	free(buffer);
+}
+
+/* Initialize the match. */
+static void
+init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+	struct xt_esp *espinfo = (struct xt_esp *)m->data;
+
+	espinfo->spis[1] = 0xFFFFFFFF;
+}
+
+#define ESP_SPI 0x01
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_esp *espinfo = (struct xt_esp *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & ESP_SPI)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--espspi' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_esp_spis(argv[optind-1], espinfo->spis);
+		if (invert)
+			espinfo->invflags |= XT_ESP_INV_SPI;
+		*flags |= ESP_SPI;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; we don't care. */
+static void
+final_check(unsigned int flags)
+{
+}
+
+static void
+print_spis(const char *name, u_int32_t min, u_int32_t max,
+	    int invert)
+{
+	const char *inv = invert ? "!" : "";
+
+	if (min != 0 || max != 0xFFFFFFFF || invert) {
+		if (min == max)
+			printf("%s:%s%u ", name, inv, min);
+		else
+			printf("%ss:%s%u:%u ", name, inv, min, max);
+	}
+}
+
+/* Prints out the union ipt_matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_esp *esp = (struct xt_esp *)match->data;
+
+	printf("esp ");
+	print_spis("spi", esp->spis[0], esp->spis[1],
+		    esp->invflags & XT_ESP_INV_SPI);
+	if (esp->invflags & ~XT_ESP_INV_MASK)
+		printf("Unknown invflags: 0x%X ",
+		       esp->invflags & ~XT_ESP_INV_MASK);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
+
+	if (!(espinfo->spis[0] == 0
+	    && espinfo->spis[1] == 0xFFFFFFFF)) {
+		printf("--espspi %s", 
+			(espinfo->invflags & XT_ESP_INV_SPI) ? "! " : "");
+		if (espinfo->spis[0]
+		    != espinfo->spis[1])
+			printf("%u:%u ",
+			       espinfo->spis[0],
+			       espinfo->spis[1]);
+		else
+			printf("%u ",
+			       espinfo->spis[0]);
+	}
+
+}
+
+static struct xtables_match esp = { 
+	.next 		= NULL,
+	.family		= AF_INET,
+	.name 		= "esp",
+	.version 	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_esp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static struct xtables_match esp6 = { 
+	.next 		= NULL,
+	.family		= AF_INET6,
+	.name 		= "esp",
+	.version 	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_esp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&esp);
+	xtables_register_match(&esp6);
+}
diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
new file mode 100644
index 0000000..9380fb1
--- /dev/null
+++ b/include/linux/netfilter/xt_esp.h
@@ -0,0 +1,14 @@
+#ifndef _XT_ESP_H
+#define _XT_ESP_H
+
+struct xt_esp
+{
+	u_int32_t spis[2];	/* Security Parameter Index */
+	u_int8_t  invflags;	/* Inverse flags */
+};
+
+/* Values for "invflags" field in struct xt_esp. */
+#define XT_ESP_INV_SPI	0x01	/* Invert the sense of spi. */
+#define XT_ESP_INV_MASK	0x01	/* All possible flags. */
+
+#endif /*_XT_ESP_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_esp.h b/include/linux/netfilter_ipv4/ipt_esp.h
deleted file mode 100644
index c782a83..0000000
--- a/include/linux/netfilter_ipv4/ipt_esp.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _IPT_ESP_H
-#define _IPT_ESP_H
-
-struct ipt_esp
-{
-	u_int32_t spis[2];			/* Security Parameter Index */
-	u_int8_t  invflags;			/* Inverse flags */
-};
-
-
-
-/* Values for "invflags" field in struct ipt_esp. */
-#define IPT_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
-#define IPT_ESP_INV_MASK	0x01	/* All possible flags. */
-
-#endif /*_IPT_ESP_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_esp.h b/include/linux/netfilter_ipv6/ip6t_esp.h
deleted file mode 100644
index 01142b9..0000000
--- a/include/linux/netfilter_ipv6/ip6t_esp.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _IP6T_ESP_H
-#define _IP6T_ESP_H
-
-struct ip6t_esp
-{
-	u_int32_t spis[2];			/* Security Parameter Index */
-	u_int8_t  invflags;			/* Inverse flags */
-};
-
-#define MASK_HOPOPTS    128
-#define MASK_DSTOPTS    64
-#define MASK_ROUTING    32
-#define MASK_FRAGMENT   16
-#define MASK_AH         8
-#define MASK_ESP        4
-#define MASK_NONE       2
-#define MASK_PROTO      1
-
-/* Values for "invflags" field in struct ip6t_esp. */
-#define IP6T_ESP_INV_SPI		0x01	/* Invert the sense of spi. */
-#define IP6T_ESP_INV_MASK	0x01	/* All possible flags. */
-
-#endif /*_IP6T_ESP_H*/
-- 
1.5.2.2
