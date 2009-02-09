From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/16] libxtables: prefix - misc functions
Date: Mon,  9 Feb 2009 18:34:56 +0100
Message-ID: <1234200900-5964-13-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51472 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbZBIRfF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:05 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_REDIRECT.c |    2 +-
 extensions/libxt_dccp.c      |    6 +++---
 extensions/libxt_multiport.c |    6 +++---
 extensions/libxt_physdev.c   |    4 ++--
 extensions/libxt_sctp.c      |    6 +++---
 extensions/libxt_tcp.c       |    6 +++---
 extensions/libxt_udp.c       |    6 +++---
 include/xtables.h.in         |    6 +++---
 ip6tables.c                  |    4 ++--
 iptables.c                   |    4 ++--
 xtables.c                    |    9 +++++----
 11 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 64ab737..1ef2b2e 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -48,7 +48,7 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 
 	port = atoi(arg);
 	if (port == 0)
-		port = service_to_port(arg, NULL);
+		port = xtables_service_to_port(arg, NULL);
 
 	if (port == 0 || port > 65535)
 		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index b7b55e2..9be0658 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -62,14 +62,14 @@ parse_dccp_ports(const char *portstring,
 	buffer = strdup(portstring);
 	DEBUGP("%s\n", portstring);
 	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = parse_port(buffer, "dccp");
+		ports[0] = ports[1] = xtables_parse_port(buffer, "dccp");
 	}
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_port(buffer, "dccp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "dccp") : 0xFFFF;
+		ports[0] = buffer[0] ? xtables_parse_port(buffer, "dccp") : 0;
+		ports[1] = cp[0] ? xtables_parse_port(cp, "dccp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index dae6e33..a7db2a8 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -81,7 +81,7 @@ parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 	{
 		next=strchr(cp, ',');
 		if (next) *next++='\0';
-		ports[i] = parse_port(cp, proto);
+		ports[i] = xtables_parse_port(cp, proto);
 	}
 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
 	free(buffer);
@@ -113,10 +113,10 @@ parse_multi_ports_v1(const char *portstring,
 					   "too many ports specified");
 			*range++ = '\0';
 		}
-		multiinfo->ports[i] = parse_port(cp, proto);
+		multiinfo->ports[i] = xtables_parse_port(cp, proto);
 		if (range) {
 			multiinfo->pflags[i] = 1;
-			multiinfo->ports[++i] = parse_port(range, proto);
+			multiinfo->ports[++i] = xtables_parse_port(range, proto);
 			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
 				exit_error(PARAMETER_PROBLEM,
 					   "invalid portrange specified");
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 0572aba..6152cb3 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -44,7 +44,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_PHYSDEV_OP_IN)
 			goto multiple_use;
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physindev,
+		xtables_parse_interface(argv[optind-1], info->physindev,
 				(unsigned char *)info->in_mask);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_IN;
@@ -56,7 +56,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_PHYSDEV_OP_OUT)
 			goto multiple_use;
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_interface(argv[optind-1], info->physoutdev,
+		xtables_parse_interface(argv[optind-1], info->physoutdev,
 				(unsigned char *)info->out_mask);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_OUT;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 37a6423..6348a2f 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -85,14 +85,14 @@ parse_sctp_ports(const char *portstring,
 	buffer = strdup(portstring);
 	DEBUGP("%s\n", portstring);
 	if ((cp = strchr(buffer, ':')) == NULL) {
-		ports[0] = ports[1] = parse_port(buffer, "sctp");
+		ports[0] = ports[1] = xtables_parse_port(buffer, "sctp");
 	}
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_port(buffer, "sctp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "sctp") : 0xFFFF;
+		ports[0] = buffer[0] ? xtables_parse_port(buffer, "sctp") : 0;
+		ports[1] = cp[0] ? xtables_parse_port(cp, "sctp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 56bdba5..bb66747 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -44,13 +44,13 @@ parse_tcp_ports(const char *portstring, u_int16_t *ports)
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "tcp");
+		ports[0] = ports[1] = xtables_parse_port(buffer, "tcp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
+		ports[0] = buffer[0] ? xtables_parse_port(buffer, "tcp") : 0;
+		ports[1] = cp[0] ? xtables_parse_port(cp, "tcp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index f64fd1c..4012841 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -36,13 +36,13 @@ parse_udp_ports(const char *portstring, u_int16_t *ports)
 
 	buffer = strdup(portstring);
 	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "udp");
+		ports[0] = ports[1] = xtables_parse_port(buffer, "udp");
 	else {
 		*cp = '\0';
 		cp++;
 
-		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
+		ports[0] = buffer[0] ? xtables_parse_port(buffer, "udp") : 0;
+		ports[1] = cp[0] ? xtables_parse_port(cp, "udp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
 			exit_error(PARAMETER_PROBLEM,
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 936bbcc..abde4d8 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -194,10 +194,10 @@ extern bool xtables_strtoul(const char *, char **, unsigned long *,
 	unsigned long, unsigned long);
 extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
-extern int service_to_port(const char *name, const char *proto);
-extern u_int16_t parse_port(const char *port, const char *proto);
+extern int xtables_service_to_port(const char *name, const char *proto);
+extern u_int16_t xtables_parse_port(const char *port, const char *proto);
 extern void
-parse_interface(const char *arg, char *vianame, unsigned char *mask);
+xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
diff --git a/ip6tables.c b/ip6tables.c
index f741c52..fd73276 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1700,7 +1700,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			xtables_parse_interface(argv[optind-1],
 					fw.ipv6.iniface,
 					fw.ipv6.iniface_mask);
 			break;
@@ -1709,7 +1709,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			xtables_parse_interface(argv[optind-1],
 					fw.ipv6.outiface,
 					fw.ipv6.outiface_mask);
 			break;
diff --git a/iptables.c b/iptables.c
index d3906fc..aeb40d8 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1705,7 +1705,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			xtables_parse_interface(argv[optind-1],
 					fw.ip.iniface,
 					fw.ip.iniface_mask);
 			break;
@@ -1714,7 +1714,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			xtables_parse_interface(argv[optind-1],
 					fw.ip.outiface,
 					fw.ip.outiface_mask);
 			break;
diff --git a/xtables.c b/xtables.c
index 859a82a..a387ae0 100644
--- a/xtables.c
+++ b/xtables.c
@@ -236,7 +236,7 @@ bool xtables_strtoui(const char *s, char **end, unsigned int *value,
 	return ret;
 }
 
-int service_to_port(const char *name, const char *proto)
+int xtables_service_to_port(const char *name, const char *proto)
 {
 	struct servent *service;
 
@@ -246,19 +246,20 @@ int service_to_port(const char *name, const char *proto)
 	return -1;
 }
 
-u_int16_t parse_port(const char *port, const char *proto)
+u_int16_t xtables_parse_port(const char *port, const char *proto)
 {
 	unsigned int portnum;
 
 	if (xtables_strtoui(port, NULL, &portnum, 0, UINT16_MAX) ||
-	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
+	    (portnum = xtables_service_to_port(port, proto)) != (unsigned)-1)
 		return portnum;
 
 	exit_error(PARAMETER_PROBLEM,
 		   "invalid port/service `%s' specified", port);
 }
 
-void parse_interface(const char *arg, char *vianame, unsigned char *mask)
+void xtables_parse_interface(const char *arg, char *vianame,
+			     unsigned char *mask)
 {
 	int vialen = strlen(arg);
 	unsigned int i;
-- 
1.6.1.2

