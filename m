From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Replace direct exit_error() calls inside
	libxtables
Date: Mon, 09 Feb 2009 22:33:51 -0500
Message-ID: <1234236831.20903.36.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-cOFr7fT4Cv0epptCWgeo"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:28202 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbZBJDfp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:35:45 -0500
Received: by ey-out-2122.google.com with SMTP id 25so571448eya.37
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 19:35:43 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-cOFr7fT4Cv0epptCWgeo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Ok, finally - with this can compile and link xtables to:

    -----
     #include <xtables.h>
     int main(int argc, char **argv) {

            return 0;
     }
    ----

cheers,
jamal

--=-cOFr7fT4Cv0epptCWgeo
Content-Disposition: attachment; filename=iptv2-4
Content-Type: text/plain; name=iptv2-4; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit fcdc4e404fb31e0cc171000bd87e081f40818959
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Mon Feb 9 22:19:07 2009 -0500

    Replace direct exit_error() calls inside libxtables with
    xt_params->exit_error().
    
    With this change; i can now compile the useless app:
    -----
     #include <xtables.h>
     int main(int argc, char **argv) {
    
            return 0;
     }
    ----
    
    with "gcc useless.c -lxtables -ldl"
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/xtables.c b/xtables.c
index d0fc478..a7425ec 100644
--- a/xtables.c
+++ b/xtables.c
@@ -359,7 +359,7 @@ u_int16_t xtables_parse_port(const char *port, const char *proto)
 	    (portnum = xtables_service_to_port(port, proto)) != (unsigned)-1)
 		return portnum;
 
-	exit_error(PARAMETER_PROBLEM,
+	xt_params->exit_error(PARAMETER_PROBLEM,
 		   "invalid port/service `%s' specified", port);
 }
 
@@ -373,7 +373,7 @@ void xtables_parse_interface(const char *arg, char *vianame,
 	memset(vianame, 0, IFNAMSIZ);
 
 	if (vialen + 1 > IFNAMSIZ)
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 			   "interface name `%s' must be shorter than IFNAMSIZ"
 			   " (%i)", arg, IFNAMSIZ-1);
 
@@ -495,7 +495,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		      name, false);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load match `%s':%s\n",
 				   name, dlerror());
 	}
@@ -507,7 +507,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 			ptr = NULL;
 	}
 	if(!ptr && (tryload == XTF_LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 			   "Couldn't find match `%s'\n", name);
 	}
 #endif
@@ -555,7 +555,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		      name, true);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
 				   name, dlerror());
 	}
@@ -567,7 +567,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 			ptr = NULL;
 	}
 	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 			   "Couldn't find target `%s'\n", name);
 	}
 #endif
@@ -820,7 +820,7 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b  = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option may only be specified once",
 		           p1, p2);
 		break;
@@ -829,13 +829,13 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b  = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option cannot be inverted", p1, p2);
 		break;
 	case XTF_BAD_VALUE:
 		p2 = va_arg(args, const char *);
 		p3 = va_arg(args, const char *);
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 		           "%s: Bad value for \"%s\" option: \"%s\"",
 		           p1, p2, p3);
 		break;
@@ -843,11 +843,11 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 		b = va_arg(args, unsigned int);
 		if (!b)
 			return;
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 		           "%s: At most one action is possible", p1);
 		break;
 	default:
-		exit_error(status, p1, args);
+		xt_params->exit_error(status, p1, args);
 		break;
 	}
 
@@ -1030,7 +1030,7 @@ ipparse_hostnetwork(const char *name, unsigned int *naddrs)
 	if ((addrptmp = host_to_ipaddr(name, naddrs)) != NULL)
 		return addrptmp;
 
-	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	xt_params->exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
 }
 
 static struct in_addr *parse_ipmask(const char *mask)
@@ -1048,7 +1048,7 @@ static struct in_addr *parse_ipmask(const char *mask)
 		/* dotted_to_addr already returns a network byte order addr */
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 32))
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
 		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
@@ -1259,7 +1259,7 @@ ip6parse_hostnetwork(const char *name, unsigned int *naddrs)
 	if ((addrp = host_to_ip6addr(name, naddrs)) != NULL)
 		return addrp;
 
-	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	xt_params->exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
 }
 
 static struct in6_addr *parse_ip6mask(char *mask)
@@ -1276,7 +1276,7 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	if ((addrp = xtables_numeric_to_ip6addr(mask)) != NULL)
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 128))
-		exit_error(PARAMETER_PROBLEM,
+		xt_params->exit_error(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
 		char *p = (void *)&maskaddr;
@@ -1376,13 +1376,13 @@ int xtables_check_inverse(const char option[], int *invert,
 		        "extrapositioned (`! --option this`).\n");
 
 		if (*invert)
-			exit_error(PARAMETER_PROBLEM,
+			xt_params->exit_error(PARAMETER_PROBLEM,
 				   "Multiple `!' flags not allowed");
 		*invert = true;
 		if (my_optind != NULL) {
 			++*my_optind;
 			if (argc && *my_optind > argc)
-				exit_error(PARAMETER_PROBLEM,
+				xt_params->exit_error(PARAMETER_PROBLEM,
 					   "no argument following `!'");
 		}
 
@@ -1433,7 +1433,7 @@ xtables_parse_protocol(const char *s)
 				}
 			}
 			if (i == ARRAY_SIZE(xtables_chain_protos))
-				exit_error(PARAMETER_PROBLEM,
+				xt_params->exit_error(PARAMETER_PROBLEM,
 					   "unknown protocol `%s' specified",
 					   s);
 		}

--=-cOFr7fT4Cv0epptCWgeo--

