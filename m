From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] --replace-string and --replace-hex-string options
Date: Tue, 23 Mar 2004 01:53:38 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040323065338.GA4346@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The following two patches against the latest
iptables/extensions/libipt_string.c in the netfilter cvs and
pom-20031219 implement two new options "--replace-string" and
"--replace-hex-string" for the string match extension.  This
allows matching strings to be replaced with strings that are
less than or equal in length.  The tcp checksum is automatically
recalculated, and the udp checksum is recalculated if necessary.
iptables-save/restore functions also work.

Here is an example usage:

iptables -A FORWARD -p tcp --dport 80 -m string --string "/usr/bin/id" \
    --replace-string "/usr/ben/id" -j LOG --log-prefix "nullify SID 1332"

iptables -A FORWARD -p udp --dport 53 -m string --hex-string "|04|bind" \
    --replace-hex-string "|05|lind" -j LOG --log-prefix "nullify SID 1435"


This patch provides similar functionality to the "replace" rule
option in snort_inline.  If we are already examining packet
contents with the string match extension, then the overhead
imposed by this patch is relatively minimal (just enough to
copy data and recalculate checksums).  Comments/suggestions much
appreciated.

--Mike

Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F



--- linux-2.4.24.orig/include/linux/netfilter_ipv4/ipt_string.h	2004-03-23 00:24:17.000000000 -0500
+++ linux-2.4.24/include/linux/netfilter_ipv4/ipt_string.h	2004-03-22 22:04:50.000000000 -0500
@@ -14,8 +14,10 @@
 
 struct ipt_string_info {
     char string[BM_MAX_NLEN];
+    char replace_str[BM_MAX_NLEN];
     u_int16_t invert;
     u_int16_t len;
+    u_int16_t replace_len;
 };
 
 #endif /* _IPT_STRING_H */
--- linux-2.4.24.orig/net/ipv4/netfilter/ipt_string.c	2004-03-23 00:24:17.000000000 -0500
+++ linux-2.4.24/net/ipv4/netfilter/ipt_string.c	2004-03-23 01:25:07.000000000 -0500
@@ -3,6 +3,10 @@
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  * 
  * ChangeLog
+ *	22.03.2004: Michael Rash <mbr@cipherdyne.org>
+ *		Added ability to replace a matching string in packet data
+ *		with a new string (checksum automatically recalculated for
+ *		tcp).
  *	19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
  *		Fixed SMP re-entrancy problem using per-cpu data areas
  *		for the skip/shift tables.
@@ -22,6 +26,8 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_string.h>
@@ -52,7 +58,7 @@
 	/* Setup skip/shift tables */
 	M1 = right_end = needle_len-1;
 	for (i = 0; i < BM_MAX_HLEN; i++) skip[i] = needle_len;  
-	for (i = 0; needle[i]; i++) skip[needle[i]] = M1 - i;  
+	for (i = 0; (int) needle[i]; i++) skip[(int) needle[i]] = M1 - i;  
 
 	for (i = 1; i < needle_len; i++) {   
 		for (j = 0; j < needle_len && needle[M1 - j] == needle[M1 - i - j]; j++);  
@@ -77,7 +83,7 @@
 			return haystack+(right_end - M1);
 		}
 		
-		sk = skip[haystack[right_end - i]];  
+		sk = skip[(int) haystack[right_end - i]];  
 		sh = shift[i];
 		right_end = max(right_end - i + sk, right_end + sh);  
 	}
@@ -113,18 +119,27 @@
 {
 	const struct ipt_string_info *info = matchinfo;
 	struct iphdr *ip = skb->nh.iph;
-	int hlen, nlen;
-	char *needle, *haystack;
+	struct tcphdr *tcph;
+	struct udphdr *udph;
+	int hlen, nlen, rlen, rctr;
+	char *needle, *haystack, *repl_str, *repl_ptr;
 	proc_ipt_search search=search_linear;
 
 	if ( !ip ) return 0;
 
-	/* get lenghts, and validate them */
+	/* get lengths, and validate them */
 	nlen=info->len;
+	rlen=info->replace_len;
 	hlen=ntohs(ip->tot_len)-(ip->ihl*4);
 	if ( nlen > hlen ) return 0;
 
+	/* if we are altering packet data, make absolutely sure
+	 * replace length is less than or equal to needle length.
+	 * We cannot start breaking protocols! */
+	if ( rlen > 0 && rlen > nlen ) return 0;
+
 	needle=(char *)&info->string;
+	repl_str=(char *)&info->replace_str;
 	haystack=(char *)ip+(ip->ihl*4);
 
 	/* The sublinear search comes in to its own
@@ -141,7 +156,44 @@
 		}
 	}
 	
-    return ((search(needle, haystack, nlen, hlen)!=NULL) ^ info->invert);
+	repl_ptr = search(needle, haystack, nlen, hlen);
+
+	if (repl_ptr != NULL && rlen > 0) {
+		/* if we change the data portion of the packet we recalculate
+		 * the transport layer checksum (mandatory for TCP). */
+		if (skb->nh.iph->protocol == IPPROTO_TCP) {
+			/* repl_ptr points to the start of the needle
+			 * in the packet, and we know the entire needle
+			 * is there so we can just replace. */
+			for (rctr=0; rctr < rlen; rctr++)
+				repl_ptr[rctr] = repl_str[rctr];
+
+			tcph = (struct tcphdr *)((u_int32_t*)skb->nh.iph + skb->nh.iph->ihl);
+			unsigned int tcplen = skb->len - (skb->nh.iph->ihl<<2);
+			tcph->check = 0;
+			tcph->check = tcp_v4_check(tcph, tcplen, skb->nh.iph->saddr,
+							skb->nh.iph->daddr,
+							csum_partial((char *)tcph, tcplen, 0));
+		} else if (skb->nh.iph->protocol == IPPROTO_UDP) {
+			/* repl_ptr points to the start of the needle
+			 * in the packet, and we know the entire needle
+			 * is there so we can just replace. */
+			for (rctr=0; rctr < rlen; rctr++)
+				repl_ptr[rctr] = repl_str[rctr];
+			/* recalculate UDP checksum only if it was previously
+			 * calculated */
+			udph = (struct udphdr *)((char *)skb->nh.iph + (skb->nh.iph->ihl<<2));
+			unsigned int udplen = skb->len - (skb->nh.iph->ihl<<2);
+			if (udph->check) {
+				udph->check = 0;
+				udph->check = csum_tcpudp_magic(skb->nh.iph->saddr,
+								skb->nh.iph->daddr,
+								udplen, IPPROTO_UDP,
+								csum_partial((char *)udph, udplen, 0));
+			}
+		}
+	}
+    return ((repl_ptr!=NULL) ^ info->invert);
 }
 
 static int



Index: extensions/libipt_string.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_string.c,v
retrieving revision 1.11
diff -u -r1.11 libipt_string.c
--- extensions/libipt_string.c	5 Jan 2004 09:50:12 -0000	1.11
+++ extensions/libipt_string.c	23 Mar 2004 05:05:38 -0000
@@ -32,8 +32,10 @@
 {
 	printf(
 "STRING match v%s options:\n"
-"--string [!] string          Match a string in a packet\n"
-"--hex-string [!] string      Match a hex string in a packet\n",
+"--string [!] string          Match a string in a packet.\n"
+"--hex-string [!] string      Match a hex string in a packet.\n"
+"--replace-string             Replace matching string with a new string.\n"
+"--replace-hex-string         Replace matching string with a new hex string.\n",
 IPTABLES_VERSION);
 }
 
@@ -41,6 +43,8 @@
 static struct option opts[] = {
 	{ .name = "string",     .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "hex-string", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "replace-string", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = "replace-hex-string", .has_arg = 1, .flag = 0, .val = '4' },
 	{ .name = 0 }
 };
 
@@ -54,15 +58,15 @@
 
 
 static void
-parse_string(const unsigned char *s, struct ipt_string_info *info)
+parse_string(const unsigned char *s, char *string)
 {	
-	if (strlen(s) <= BM_MAX_NLEN) strcpy(info->string, s);
+	if (strlen(s) <= BM_MAX_NLEN) strcpy(string, s);
 	else exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 }
 
 
 static void
-parse_hex_string(const unsigned char *s, struct ipt_string_info *info)
+parse_hex_string(const unsigned char *s, char *string, u_int16_t *len)
 {
 	int i=0, slen, sindex=0, schar;
 	short hex_f = 0, literal_f = 0;
@@ -101,7 +105,7 @@
 				exit_error(PARAMETER_PROBLEM,
 					"Bad literal placement at end of string");
 			}
-			info->string[sindex] = s[i+1];
+			string[sindex] = s[i+1];
 			i += 2;  /* skip over literal char */
 			literal_f = 0;
 		} else if (hex_f) {
@@ -123,20 +127,20 @@
 			if (! sscanf(hextmp, "%x", &schar))
 				exit_error(PARAMETER_PROBLEM,
 					"Invalid hex char `%c'", s[i]);
-			info->string[sindex] = (char) schar;
+			string[sindex] = (char) schar;
 			if (s[i+2] == ' ')
 				i += 3;  /* spaces included in the hex block */
 			else
 				i += 2;
 		} else {  /* the char is not part of hex data, so just copy */
-			info->string[sindex] = s[i];
+			string[sindex] = s[i];
 			i++;
 		}
 		if (sindex > BM_MAX_NLEN)
 			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
 		sindex++;
 	}
-	info->len = sindex;
+	*len = sindex;
 }
 
 
@@ -157,7 +161,7 @@
 				   "Can't specify multiple strings");
 
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_string(argv[optind-1], stringinfo);
+		parse_string(argv[optind-1], stringinfo->string);
 		if (invert)
 			stringinfo->invert = 1;
 		stringinfo->len=strlen((char *)&stringinfo->string);
@@ -167,15 +171,51 @@
 	case '2':
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple strings");
+				   "Can't specify multiple hex strings");
 
 		check_inverse(optarg, &invert, &optind, 0);
-		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
+		parse_hex_string(argv[optind-1], stringinfo->string, &stringinfo->len);
 		if (invert)
 			stringinfo->invert = 1;
 		*flags = 1;
 		break;
 
+	case '3':
+		if (! *flags)
+			exit_error(PARAMETER_PROBLEM,
+				"Must specify a string to replace with --string or --hex-string");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't negate --replace-string");
+		parse_string(argv[optind-1], stringinfo->replace_str);
+		stringinfo->replace_len=strlen((char *)&stringinfo->replace_str);
+		/* make absolutely sure the replace string length is less than
+		 * or equal to the length of the string to be replaced */
+		if (stringinfo->replace_len > stringinfo->len)
+			exit_error(PARAMETER_PROBLEM,
+				"Length of replace string must be <= length of string to be replaced");
+		break;
+
+	case '4':
+		if (! *flags)
+			exit_error(PARAMETER_PROBLEM,
+				"Must specify a string to replace with --string or --hex-string");
+
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				"Can't negate --replace-hex-string");
+		parse_hex_string(argv[optind-1], stringinfo->replace_str,
+			&stringinfo->replace_len);
+		/* make absolutely sure the replace string length is less than
+		 * or equal to the length of the string to be replaced */
+		if (stringinfo->replace_len > stringinfo->len)
+			exit_error(PARAMETER_PROBLEM,
+				"Length of replace string must be <= length of string to be replaced");
+		break;
+
 	default:
 		return 0;
 	}
@@ -253,6 +293,16 @@
 		printf("STRING match %s", (info->invert) ? "!" : "");
 		print_string(info->string, info->len);
 	}
+	/* print replace string (if any) */
+	if (info->replace_len > 0) {
+		if (is_hex_string(info->replace_str, info->replace_len)) {
+			printf("REPLACE ");
+			print_hex_string(info->replace_str, info->replace_len);
+		} else {
+			printf("REPLACE ");
+			print_string(info->replace_str, info->replace_len);
+		}
+	}
 }
 
 
@@ -269,6 +319,16 @@
 	} else {
 		printf("--string %s", (info->invert) ? "! ": "");
 		print_string(info->string, info->len);
+	}
+	/* print out --replace-string args (if necessary) */
+	if (info->replace_len > 0) {
+		if (is_hex_string(info->replace_str, info->replace_len)) {
+			printf("--replace-hex-string ");
+			print_hex_string(info->replace_str, info->replace_len);
+		} else {
+			printf("--replace-string ");
+			print_string(info->replace_str, info->replace_len);
+		}
 	}
 }
 
