From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/16] src: remove redundant casts
Date: Mon,  9 Feb 2009 18:34:46 +0100
Message-ID: <1234200900-5964-3-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51462 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZBIRfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:03 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All of them are implicitly convertable without any wanted side effects.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_ah.c         |    2 +-
 extensions/libip6t_dst.c        |    7 +++----
 extensions/libip6t_frag.c       |    2 +-
 extensions/libip6t_hbh.c        |    7 +++----
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_rt.c         |    2 +-
 extensions/libipt_CLUSTERIP.c   |    4 ++--
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libxt_DSCP.c         |    4 ++--
 extensions/libxt_dccp.c         |    2 +-
 extensions/libxt_dscp.c         |    4 ++--
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_tcp.c          |    2 +-
 extensions/libxt_tcpmss.c       |    2 +-
 xtables.c                       |    2 +-
 19 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 40a551f..1b21d5d 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -91,7 +91,7 @@ parse_level(const char *level)
 				   "log-level `%s' unknown", level);
 	}
 
-	return (u_int8_t)lev;
+	return lev;
 }
 
 #define IP6T_LOG_OPT_LEVEL 0x01
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 0bbd475..63d1573 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -45,7 +45,7 @@ parse_ah_spi(const char *spistr, const char *typestr)
 		exit_error(PARAMETER_PROBLEM,
 			   "AH error parsing %s `%s'", typestr, spistr);
 
-	return (u_int32_t) spi;
+	return spi;
 }
 
 static void
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 215e2d9..43562c1 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -49,7 +49,7 @@ parse_opts_num(const char *idstr, const char *typestr)
 		exit_error(PARAMETER_PROBLEM,
 		           "dst: error parsing %s `%s'", typestr, idstr);
 	}
-	return (u_int32_t) id;
+	return id;
 }
 
 static int
@@ -78,13 +78,12 @@ parse_options(const char *optsstr, u_int16_t *opts)
                         *range++ = '\0';
                 }
 
-                opts[i] = (u_int16_t)((parse_opts_num(cp,"opt") & 0x000000FF)<<8); 
+		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
         			exit_error(PARAMETER_PROBLEM,
 					"PAD0 hasn't got length");
-                        opts[i] |= (u_int16_t)(parse_opts_num(range,"length") &
-					0x000000FF);
+			opts[i] |= parse_opts_num(range, "length") & 0xFF;
                 } else
                         opts[i] |= (0x00FF);
 
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 5ded1c6..7c22429 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -51,7 +51,7 @@ parse_frag_id(const char *idstr, const char *typestr)
 		exit_error(PARAMETER_PROBLEM,
 			   "FRAG error parsing %s `%s'", typestr, idstr);
 	}
-	return (u_int32_t) id;
+	return id;
 }
 
 static void
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 419c250..6c7458d 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -52,7 +52,7 @@ parse_opts_num(const char *idstr, const char *typestr)
 		exit_error(PARAMETER_PROBLEM,
 			   "hbh: error parsing %s `%s'", typestr, idstr);
 	}
-	return (u_int32_t) id;
+	return id;
 }
 
 static int
@@ -75,12 +75,11 @@ parse_options(const char *optsstr, u_int16_t *opts)
                                            "too many ports specified");
                         *range++ = '\0';
                 }
-                opts[i] = (u_int16_t)((parse_opts_num(cp,"opt") & 0x000000FF)<<8); 
+		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
         			exit_error(PARAMETER_PROBLEM, "PAD0 hasn't got length");
-                        opts[i] |= (u_int16_t)(parse_opts_num(range,"length") &
-					0x000000FF);
+			opts[i] |= parse_opts_num(range, "length") & 0xFF;
                 } else {
                         opts[i] |= (0x00FF);
 		}
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 1fc9b7e..ea8870a 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -110,7 +110,7 @@ name_to_proto(const char *s)
         			s);
         }
 
-        return (u_int16_t)proto;
+        return proto;
 }
 
 static unsigned int 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 9468da1..49d86fa 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -58,7 +58,7 @@ parse_rt_num(const char *idstr, const char *typestr)
 		exit_error(PARAMETER_PROBLEM,
 			   "RT error parsing %s `%s'", typestr, idstr);
 	}
-	return (u_int32_t) id;
+	return id;
 }
 
 static void
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 4718496..e93290a 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -122,7 +122,7 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM, "Can only specify total node number once\n");
 		if (string_to_number(optarg, 1, CLUSTERIP_MAX_NODES, &num) < 0)
 			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
-		cipinfo->num_total_nodes = (u_int16_t)num;
+		cipinfo->num_total_nodes = num;
 		*flags |= PARAM_TOTALNODE;
 		break;
 	case '5':
@@ -133,7 +133,7 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (string_to_number(optarg, 1, CLUSTERIP_MAX_NODES, &num) < 0)
 			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
 		cipinfo->num_local_nodes = 1;
-		cipinfo->local_nodes[0] = (u_int16_t)num;
+		cipinfo->local_nodes[0] = num;
 		*flags |= PARAM_LOCALNODE;
 		break;
 	case '6':
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 668b565..2aee910 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -91,7 +91,7 @@ parse_level(const char *level)
 				   "log-level `%s' unknown", level);
 	}
 
-	return (u_int8_t)lev;
+	return lev;
 }
 
 #define IPT_LOG_OPT_LEVEL 0x01
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index fec87a7..10998d8 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -41,7 +41,7 @@ parse_ah_spi(const char *spistr)
 		exit_error(PARAMETER_PROBLEM,
 			   "AH error parsing spi `%s'", spistr);
 	}
-	return (u_int32_t) spi;
+	return spi;
 }
 
 static void
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 5af2fd4..22cbe27 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -173,7 +173,7 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 			if (id == -1)
 				exit_error(PARAMETER_PROBLEM,
 					   "Realm `%s' not found", optarg);
-			realminfo->id = (u_int32_t)id;
+			realminfo->id = id;
 			realminfo->mask = 0xffffffff;
 		}
 		if (invert)
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index c9b0327..409fa19 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -56,7 +56,7 @@ parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 		exit_error(PARAMETER_PROBLEM,
 			   "DSCP `%d` out of range\n", dscp);
 
-    	dinfo->dscp = (u_int8_t )dscp;
+	dinfo->dscp = dscp;
 }
 
 
@@ -66,7 +66,7 @@ parse_class(const char *s, struct xt_DSCP_info *dinfo)
 	unsigned int dscp = class_to_dscp(s);
 
 	/* Assign the value */
-	dinfo->dscp = (u_int8_t)dscp;
+	dinfo->dscp = dscp;
 }
 
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 24bf6f7..b1ae62e 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -125,7 +125,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
 			   optstring);
 
-	return (u_int8_t)ret;
+	return ret;
 }
 
 static int
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index bb794f5..315e219 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -56,7 +56,7 @@ parse_dscp(const char *s, struct xt_dscp_info *dinfo)
 		exit_error(PARAMETER_PROBLEM,
 			   "DSCP `%d` out of range\n", dscp);
 
-    	dinfo->dscp = (u_int8_t )dscp;
+	dinfo->dscp = dscp;
 }
 
 
@@ -66,7 +66,7 @@ parse_class(const char *s, struct xt_dscp_info *dinfo)
 	unsigned int dscp = class_to_dscp(s);
 
 	/* Assign the value */
-	dinfo->dscp = (u_int8_t)dscp;
+	dinfo->dscp = dscp;
 }
 
 
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 999733c..34df876 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -43,7 +43,7 @@ parse_esp_spi(const char *spistr)
 		exit_error(PARAMETER_PROBLEM,
 			   "ESP error parsing spi `%s'", spistr);
 	}
-	return (u_int32_t) spi;
+	return spi;
 }
 
 static void
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 98e8167..e350431 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -29,7 +29,7 @@ parse_length(const char *s)
 	if (string_to_number(s, 0, 0xFFFF, &len) == -1)
 		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
 	else
-		return (u_int16_t )len;
+		return len;
 }
 
 /* If a single value is provided, min and max are both set to the value */
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 14d8c18..a9039f0 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -124,7 +124,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 	if (string_to_number(option, 1, 255, &ret) == -1)
 		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
 
-	*result = (u_int8_t)ret;
+	*result = ret;
 }
 
 static void tcp_init(struct xt_entry_match *m)
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 000d85a..a720c42 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -27,7 +27,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 	unsigned int mssvaluenum;
 
 	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
-		return (u_int16_t)mssvaluenum;
+		return mssvaluenum;
 
 	exit_error(PARAMETER_PROBLEM,
 		   "Invalid mss `%s' specified", mssvalue);
diff --git a/xtables.c b/xtables.c
index 849dc7d..10a2268 100644
--- a/xtables.c
+++ b/xtables.c
@@ -265,7 +265,7 @@ u_int16_t parse_port(const char *port, const char *proto)
 
 	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
 	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
-		return (u_int16_t)portnum;
+		return portnum;
 
 	exit_error(PARAMETER_PROBLEM,
 		   "invalid port/service `%s' specified", port);
-- 
1.6.1.2

