From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 2/8] iptables: Coverity: FORWARD_NULL
Date: Fri, 10 Jun 2011 15:25:56 +0200
Message-ID: <1307712362-17727-3-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1FJN0l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQfQc018684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:41 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6tables.c:1841: var_compare_op: Comparing "chain" to null implies that "chain" might be null.
ip6tables.c:1863: var_deref_model: Passing null variable "chain" to function "strcmp", which
                  dereferences it. (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)
ip6tables.c:1946: var_deref_model: Passing null variable "chain" to function "ip6tc_delete_num_entry", which dereferences it.
libiptc/libiptc.c:2050: deref_parm_in_call: Function "iptcc_find_label" dereferences parameter "chain".
libiptc/libiptc.c:737: deref_parm_in_call: Function "strcmp" dereferences parameter "name".
                       (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)
ip6tables.c:1967: var_deref_model: Passing null variable "chain" to function "ip6tc_zero_counter", which dereferences it.
ip6tables.c:1999: var_deref_model: Passing null variable "chain" to function "ip6tc_create_chain", which dereferences it.
ip6tables.c:2005: var_deref_model: Passing null variable "chain" to function "ip6tc_rename_chain", which dereferences it.
ip6tables.c:2008: var_deref_model: Passing null variable "chain" to function "ip6tc_set_policy", which dereferences it.

iptables.c:1879: var_compare_op: Comparing "chain" to null implies that "chain" might be null.
iptables.c:1901: var_deref_model: Passing null variable "chain" to function "strcmp", which
                 dereferences it. (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)
iptables.c:1986: var_deref_model: Passing null variable "chain" to function "iptc_delete_num_entry", which dereferences it.
libiptc/libiptc.c:2050: deref_parm_in_call: Function "iptcc_find_label" dereferences parameter "chain".
libiptc/libiptc.c:737: deref_parm_in_call: Function "strcmp" dereferences parameter "name".
                       (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)
iptables.c:2007: var_deref_model: Passing null variable "chain" to function "iptc_zero_counter", which dereferences it.
iptables.c:2039: var_deref_model: Passing null variable "chain" to function "iptc_create_chain", which dereferences it.
iptables.c:2045: var_deref_model: Passing null variable "chain" to function "iptc_rename_chain", which dereferences it.
iptables.c:2048: var_deref_model: Passing null variable "chain" to function "iptc_set_policy", which dereferences it.

iptables.c:1828: var_compare_op: Comparing "policy" to null implies that "policy" might be null.
iptables.c:2048: var_deref_model: Passing null variable "policy" to function "iptc_set_policy", which dereferences it.
libiptc/libiptc.c:2422: deref_parm_in_call: Function "strcmp" dereferences parameter "policy".
                        (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)

iptables-xml.c:745: assign_zero: Assigning: "chain" = 0.
iptables-xml.c:855: var_deref_model: Passing null variable "chain" to function "needChain", which dereferences it.
iptables-xml.c:282: deref_parm_in_call: Function "strcmp" dereferences parameter "chain".
                    (The dereference is assumed on the basis of the 'nonnull' parameter attribute.)
---
 iptables/ip6tables.c    |    5 ++++-
 iptables/iptables-xml.c |    3 ++-
 iptables/iptables.c     |    8 ++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4037acf..b30c9b7 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1770,7 +1770,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	generic_opt_check(command, cs.options);
 
-	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
+	if (chain == NULL)
+		xtables_error(PARAMETER_PROBLEM, "no chain");
+
+	if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 5aa638c..e2cb809 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -847,7 +847,8 @@ main(int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			needChain(chain);// Should we explicitly look for -A
+			if (chain != NULL)
+				needChain(chain);// Should we explicitly look for -A
 			do_rule(pcnt, bcnt, newargc, newargv, newargvattr);
 
 			save_argv();
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 4ae7541..4868e40 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1800,7 +1800,10 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 
 	generic_opt_check(command, cs.options);
 
-	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
+	if (chain == NULL)
+		xtables_error(PARAMETER_PROBLEM, "no chain");
+
+	if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "chain name `%s' too long (must be under %u chars)",
 			   chain, XT_EXTENSION_MAXNAMELEN);
@@ -1978,7 +1981,8 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 		ret = iptc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = iptc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw.counters : NULL, *handle);
+		if (policy != NULL)
+			ret = iptc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
-- 
1.7.5.2

