From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] ebtables: Possible problems found by static analysis of code
Date: Tue, 14 Jun 2011 12:32:14 +0200
Message-ID: <4DF738AE.3060306@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060508090002060400030801"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1FNKcP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:32:15 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5EAWF1N028000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2011 06:32:15 -0400
Received: from zepelin.brq.redhat.com (zepelin.brq.redhat.com [10.34.24.67])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5EAWEsL026313
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2011 06:32:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060508090002060400030801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

we had analyzed the ebtables-v2.0.9-2 code with Coverity.
Coverity is commercial enterprise level tool for
static analysis (analysis based only on compiling of sources,
not based on running of binary) of the code.

As a result I have the following patches that should fix some possible problems.
There's a respective part(s) of the Coverity error log in each patch.

You could also find this link useful:
https://www.securecoding.cert.org/confluence/display/seccode/Coverity+Prevent

With regards,
Jiri Popelka


--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-forward_null.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-forward_null.patch"

Error: FORWARD_NULL
ebtables-v2.0.9-2/communication.c:305: var_compare_op: Comparing "next" to null implies that "next" might be null.
ebtables-v2.0.9-2/communication.c:316: var_deref_op: Dereferencing null variable "next".

Error: FORWARD_NULL
ebtables-v2.0.9-2/communication.c:632: assign_zero: Assigning: "repl->counters" = 0.
ebtables-v2.0.9-2/communication.c:634: var_deref_model: Passing null variable "(char *)repl->counters" to function "fread", which dereferences it.

diff -up ebtables-v2.0.9-2/communication.c.forward_null ebtables-v2.0.9-2/communication.c
--- ebtables-v2.0.9-2/communication.c.forward_null	2010-02-03 22:17:45.000000000 +0100
+++ ebtables-v2.0.9-2/communication.c	2011-06-01 18:20:52.844295103 +0200
@@ -309,6 +309,8 @@ void ebt_deliver_counters(struct ebt_u_r
 			if (chainnr == u_repl->num_chains)
 				break;
 		}
+		if (next == NULL)
+			ebt_print_error("ebt_deliver_counters: next == NULL");
 		if (cc->type == CNT_NORM) {
 			/* 'Normal' rule, meaning we didn't do anything to it
 			 * So, we just copy */
@@ -636,9 +638,9 @@ static int retrieve_from_file(char *file
 	   != repl->entries_size ||
 	   fseek(file, sizeof(struct ebt_replace) + repl->entries_size,
 		 SEEK_SET)
-	   || fread((char *)repl->counters, sizeof(char),
+	   || (repr->counters && fread((char *)repl->counters, sizeof(char),
 	   repl->nentries * sizeof(struct ebt_counter), file)
-	   != repl->nentries * sizeof(struct ebt_counter)) {
+	   != repl->nentries * sizeof(struct ebt_counter))) {
 		ebt_print_error("File %s is corrupt", filename);
 		free(entries);
 		repl->entries = NULL;

--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-no_effect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-no_effect.patch"

Error: NO_EFFECT
ebtables-v2.0.9-2/extensions/ebt_nflog.c:83: unsigned_compare: This less-than-zero comparison of an unsigned value is never true. "i < 0U".
ebtables-v2.0.9-2/extensions/ebt_nflog.c:95: unsigned_compare: This less-than-zero comparison of an unsigned value is never true. "i < 0U".
ebtables-v2.0.9-2/extensions/ebt_nflog.c:107: unsigned_compare: This less-than-zero comparison of an unsigned value is never true. "i < 0U".

diff -up ebtables-v2.0.9-2/extensions/ebt_nflog.c.no_effect ebtables-v2.0.9-2/extensions/ebt_nflog.c
--- ebtables-v2.0.9-2/extensions/ebt_nflog.c.no_effect	2010-02-03 22:17:45.000000000 +0100
+++ ebtables-v2.0.9-2/extensions/ebt_nflog.c	2011-06-01 18:29:41.058691515 +0200
@@ -80,7 +80,7 @@ static int nflog_parse(int c, char **arg
 		i = strtoul(optarg, &end, 10);
 		if (*end != '\0')
 			ebt_print_error2("--nflog-group must be a number!");
-		if (i < 0)
+		if (i == ULONG_MAX)
 			ebt_print_error2("--nflog-group can not be negative");
 		info->group = i;
 		break;
@@ -92,7 +92,7 @@ static int nflog_parse(int c, char **arg
 		i = strtoul(optarg, &end, 10);
 		if (*end != '\0')
 			ebt_print_error2("--nflog-range must be a number!");
-		if (i < 0)
+		if (i == ULONG_MAX)
 			ebt_print_error2("--nflog-range can not be negative");
 		info->len = i;
 		break;
@@ -104,7 +104,7 @@ static int nflog_parse(int c, char **arg
 		i = strtoul(optarg, &end, 10);
 		if (*end != '\0')
 			ebt_print_error2("--nflog-threshold must be a number!");
-		if (i < 0)
+		if (i == ULONG_MAX)
 			ebt_print_error2
 			    ("--nflog-threshold can not be negative");
 		info->threshold = i;

--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-overrun_static.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-overrun_static.patch"

RXJyb3I6IE9WRVJSVU5fU1RBVElDCmVidGFibGVzLXYyLjAuOS0yL2NvbW11bmljYXRpb24u
YzozNzg6IGFzc2lnbm1lbnQ6IEFzc2lnbmluZzogIm9wdGxlbiIgPSAidV9yZXBsLT5uZW50
cmllcyAqIHNpemVvZiAoc3RydWN0IGVidF9jb3VudGVyKSAvKjE2Ki8gKyBzaXplb2YgKHN0
cnVjdCBlYnRfcmVwbGFjZSkgLyoxMjAqLyIuCmVidGFibGVzLXYyLjAuOS0yL2NvbW11bmlj
YXRpb24uYzozODc6IG92ZXJydW4tYnVmZmVyLWFyZzogT3ZlcnJ1bm5pbmcgc3RydWN0IHR5
cGUgc3RydWN0IGVidF9yZXBsYWNlIG9mIHNpemUgMTIwIGJ5dGVzIGJ5IHBhc3NpbmcgaXQg
dG8gYSBmdW5jdGlvbiB3aGljaCBpbmRleGVzIGl0IHdpdGggYXJndW1lbnQgIm9wdGxlbiIg
YXQgYnl0ZSBwb3NpdGlvbiAxMzUuCgpFcnJvcjogVU5JTklUCmVidGFibGVzLXYyLjAuOS0y
L2NvbW11bmljYXRpb24uYzoyODg6IHZhcl9kZWNsOiBEZWNsYXJpbmcgdmFyaWFibGUgInJl
cGwiIHdpdGhvdXQgaW5pdGlhbGl6ZXIuCmVidGFibGVzLXYyLjAuOS0yL2NvbW11bmljYXRp
b24uYzozODc6IHVuaW5pdF91c2VfaW5fY2FsbDogVXNpbmcgdW5pbml0aWFsaXplZCB2YWx1
ZSAicmVwbCI6IGZpZWxkICJyZXBsIi5lbnRyaWVzIGlzIHVuaW5pdGlhbGl6ZWQgd2hlbiBj
YWxsaW5nICJzZXRzb2Nrb3B0Ii4KCkknbSBub3Qgc3VyZSB3aGV0aGVyIHRoaXMgaXMgcmVh
bGx5IGEgcHJvYmxlbSBhbmQgaG93IHRvIHByb3Blcmx5IHRyZWF0IGl0LApzbyB0aGVyZSdz
IGFjdHVhbGx5IG5vIHBhdGNoIGhlcmUgOi0p
--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-resource_leak.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-resource_leak.patch"

Error: RESOURCE_LEAK
ebtables-v2.0.9-2/extensions/ebt_among.c:191: alloc_fn: Calling allocation function "new_wormhash".
ebtables-v2.0.9-2/extensions/ebt_among.c:87: alloc_fn: Storage is returned from allocation function "malloc".
ebtables-v2.0.9-2/extensions/ebt_among.c:87: var_assign: Assigning: "result" = "malloc(size)".
ebtables-v2.0.9-2/extensions/ebt_among.c:92: noescape: Variable "result" is not freed or pointed-to in function "memset".
ebtables-v2.0.9-2/extensions/ebt_among.c:94: return_alloc: Returning allocated memory "result".
ebtables-v2.0.9-2/extensions/ebt_among.c:191: var_assign: Assigning: "workcopy" =  storage returned from "new_wormhash(1024)".
ebtables-v2.0.9-2/extensions/ebt_among.c:205: leaked_storage: Variable "workcopy" going out of scope leaks the storage it points to.
ebtables-v2.0.9-2/extensions/ebt_among.c:210: leaked_storage: Variable "workcopy" going out of scope leaks the storage it points to.

diff -up ebtables-v2.0.9-2/extensions/ebt_among.c.resource_leak ebtables-v2.0.9-2/extensions/ebt_among.c
--- ebtables-v2.0.9-2/extensions/ebt_among.c.resource_leak	2010-02-03 22:17:45.000000000 +0100
+++ ebtables-v2.0.9-2/extensions/ebt_among.c	2011-06-01 19:19:46.886113499 +0200
@@ -202,11 +202,13 @@ static struct ebt_mac_wormhash *create_w
 			if (read_until(&pc, ":", token, 2) < 0
 			    || token[0] == 0) {
 				ebt_print_error("MAC parse error: %.20s", anchor);
+				free(workcopy);
 				return NULL;
 			}
 			mac[i] = strtol(token, &endptr, 16);
 			if (*endptr) {
 				ebt_print_error("MAC parse error: %.20s", anchor);
+				free(workcopy);
 				return NULL;
 			}
 			pc++;

--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-uninit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-uninit.patch"

Error: UNINIT
ebtables-v2.0.9-2/communication.c:59: var_decl: Declaring variable "chain_offsets" without initializer.
ebtables-v2.0.9-2/communication.c:69: alloc_fn: Assigning: "chain_offsets" = "(unsigned int *)malloc(u_repl->num_chains * sizeof (unsigned int) /*4*/)", which is allocated but not initialized.
ebtables-v2.0.9-2/communication.c:169: uninit_use: Using uninitialized value "*chain_offsets".

diff -up ebtables-v2.0.9-2/communication.c.uninit ebtables-v2.0.9-2/communication.c
--- ebtables-v2.0.9-2/communication.c.uninit	2010-02-03 22:17:45.000000000 +0100
+++ ebtables-v2.0.9-2/communication.c	2011-06-01 19:36:52.192295410 +0200
@@ -66,7 +66,10 @@ static struct ebt_replace *translate_use
 	new->nentries = u_repl->nentries;
 	new->num_counters = u_repl->num_counters;
 	new->counters = sparc_cast u_repl->counters;
-	chain_offsets = (unsigned int *)malloc(u_repl->num_chains * sizeof(unsigned int));
+	chain_offsets = (unsigned int *)calloc(u_repl->num_chains, sizeof(unsigned int));
+	if (!chain_offsets)
+		ebt_print_memory();
+	
 	/* Determine size */
 	for (i = 0; i < u_repl->num_chains; i++) {
 		if (!(entries = u_repl->chains[i]))

--------------060508090002060400030801
Content-Type: text/plain;
 name="ebtables-v2.0.9-2-Coverity-use_after_free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ebtables-v2.0.9-2-Coverity-use_after_free.patch"

Error: USE_AFTER_FREE
ebtables-v2.0.9-2/libebtc.c:408: freed_arg: "free" frees "cc".
ebtables-v2.0.9-2/libebtc.c:410: deref_after_free: Dereferencing freed pointer "cc".

diff -up ebtables-v2.0.9-2/libebtc.c.use_after_free ebtables-v2.0.9-2/libebtc.c
--- ebtables-v2.0.9-2/libebtc.c.use_after_free	2010-02-03 22:17:45.000000000 +0100
+++ ebtables-v2.0.9-2/libebtc.c	2011-06-01 19:53:36.764736526 +0200
@@ -407,7 +407,6 @@ void ebt_delete_cc(struct ebt_cntchanges
 		cc->next->prev = cc->prev;
 		free(cc);
 	}
-	cc->type = CNT_DEL;
 }
 
 void ebt_empty_chain(struct ebt_u_entries *entries)

--------------060508090002060400030801--
