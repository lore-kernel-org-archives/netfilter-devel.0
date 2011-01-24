From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 3/6] ipset: pass ipset_arg argument pointer
Date: Mon, 24 Jan 2011 22:36:34 +0100
Message-ID: <20110124214012.012613658@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1AXVkO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:14 -0500
Content-Disposition: inline; filename=ipset-pass-arg.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/src/ipset.c
===================================================================
--- ipset.orig/src/ipset.c
+++ ipset/src/ipset.c
@@ -208,7 +208,6 @@ call_parser(int *argc, char *argv[], con
 {
 	int i = 1, ret = 0;
 	const struct ipset_arg *arg;
-	const char *optstr;
 	
 	/* Currently CREATE and ADT may have got additional arguments */
 	if (!args)
@@ -221,7 +220,6 @@ call_parser(int *argc, char *argv[], con
 				i++;
 				continue;
 			}
-			optstr = argv[i];
 			/* Shift off matched option */
 			D("match %s", arg->name[0]);
 			ipset_shift_argv(argc, argv, i);
@@ -236,10 +234,7 @@ call_parser(int *argc, char *argv[], con
 				/* Fall through */
 			case IPSET_OPTIONAL_ARG:
 				if (i + 1 <= *argc) {
-					ret = ipset_call_parser(session,
-							arg->parse,
-							optstr, arg->opt,
-							argv[i]);
+					ret = ipset_call_parser(session, arg, argv[i]);
 					if (ret < 0)
 						return ret;
 					ipset_shift_argv(argc, argv, i);
@@ -247,10 +242,7 @@ call_parser(int *argc, char *argv[], con
 				}
 				/* Fall through */
 			default:
-				ret = ipset_call_parser(session,
-							arg->parse,
-							optstr, arg->opt,
-							optstr);
+				ret = ipset_call_parser(session, arg, argv[1]);
 				if (ret < 0)
 					return ret;
 			}
Index: ipset/include/libipset/parse.h
===================================================================
--- ipset.orig/include/libipset/parse.h
+++ ipset/include/libipset/parse.h
@@ -17,6 +17,7 @@
 #define IPSET_PROTO_SEPARATOR	":"
 
 struct ipset_session;
+struct ipset_arg;
 
 typedef int (*ipset_parsefn)(struct ipset_session *s,
 			     enum ipset_opt opt, const char *str);
@@ -84,8 +85,8 @@ extern int ipset_parse_ignored(struct ip
 extern int ipset_parse_elem(struct ipset_session *session,
                             enum ipset_opt opt, const char *str);
 extern int ipset_call_parser(struct ipset_session *session,
-			     ipset_parsefn parse, const char *optstr,
-			     enum ipset_opt optional, const char *str);
+							 const struct ipset_arg *arg,
+							 const char *str);
 
 /* Compatibility parser functions */
 extern int ipset_parse_iptimeout(struct ipset_session *session,
Index: ipset/lib/parse.c
===================================================================
--- ipset.orig/lib/parse.c
+++ ipset/lib/parse.c
@@ -1416,15 +1416,14 @@ ipset_parse_ignored(struct ipset_session
  */
 int
 ipset_call_parser(struct ipset_session *session,
-		  ipset_parsefn parse, const char *optstr,
-		  enum ipset_opt opt, const char *str)
+				  const struct ipset_arg *arg,
+				  const char *str)
 {
 	if (ipset_data_flags_test(ipset_session_data(session),
-				  IPSET_FLAG(opt)))
-		syntax_err("%s already specified", optstr);
+				  IPSET_FLAG(arg->opt)))
+		syntax_err("%s already specified", arg->name[0]);
 
-	return parse(session, opt, parse == ipset_parse_ignored
-				   ? optstr : str);
+	return arg->parse(session, arg->opt, str);
 }
 
 #define parse_elem(s, t, d, str)					\

