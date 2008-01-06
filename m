From: Peter Warasin <peter@endian.com>
Subject: [PATCH] Makes little part of iptables target parsing code better
 readable
Date: Sun, 06 Jan 2008 04:37:07 +0100
Message-ID: <47804CE3.8060608@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050809060303070809050203"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:50995 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYAFDhM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:37:12 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 2C3FA598320
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Jan 2008 04:37:06 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z+ugvSY8ebbJ for <netfilter-devel@vger.kernel.org>;
	Sun,  6 Jan 2008 04:37:05 +0100 (CET)
Received: from [10.139.200.197] (host134-110-dynamic.5-87-r.retail.telecomitalia.it [87.5.110.134])
	by solaria.endian.it (Postfix) with ESMTP id BB400598319
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Jan 2008 04:37:04 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050809060303070809050203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch sources out the target getopt parsing into a separate
code-block which before has been done as a side-effect of a check.

This removes also a level of indentation and makes the part more
understandable when reading the code.


Signed-off-by: Peter Warasin <peter@endian.com>

---

--------------050809060303070809050203
Content-Type: text/x-patch;
 name="iptables_readable_targetparsing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables_readable_targetparsing.patch"

Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c	2008-01-06 02:59:40.000000000 +0100
+++ iptables/iptables.c	2008-01-06 03:03:03.000000000 +0100
@@ -1822,83 +1822,88 @@
 			exit_tryhelp(2);
 
 		default:
-			if (!target
-			    || !(target->parse(c - target->option_offset,
-					       argv, invert,
-					       &target->tflags,
-					       &fw, &target->t))) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed) 
-						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
-						     argv, invert,
-						     &matchp->match->mflags,
-						     &fw,
-						     &matchp->match->m))
-						break;
-				}
-				m = matchp ? matchp->match : NULL;
-
-				/* If you listen carefully, you can
-				   actually hear this code suck. */
-
-				/* some explanations (after four different bugs
-				 * in 3 different releases): If we encounter a
-				 * parameter, that has not been parsed yet,
-				 * it's not an option of an explicitly loaded
-				 * match or a target.  However, we support
-				 * implicit loading of the protocol match
-				 * extension.  '-p tcp' means 'l4 proto 6' and
-				 * at the same time 'load tcp protocol match on
-				 * demand if we specify --dport'.
-				 *
-				 * To make this work, we need to make sure:
-				 * - the parameter has not been parsed by
-				 *   a match (m above)
-				 * - a protocol has been specified
-				 * - the protocol extension has not been
-				 *   loaded yet, or is loaded and unused
-				 *   [think of iptables-restore!]
-				 * - the protocol extension can be successively
-				 *   loaded
-				 */
-				if (m == NULL
-				    && protocol
-				    && (!find_proto(protocol, DONT_LOAD,
-						   options&OPT_NUMERIC, NULL) 
-					|| (find_proto(protocol, DONT_LOAD,
-							options&OPT_NUMERIC, NULL)
-					    && (proto_used == 0))
-				       )
-				    && (m = find_proto(protocol, TRY_LOAD,
-						       options&OPT_NUMERIC, &matches))) {
-					/* Try loading protocol */
-					size_t size;
-					
-					proto_used = 1;
-
-					size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-							 + m->size;
-
-					m->m = fw_calloc(1, size);
-					m->m->u.match_size = size;
-					strcpy(m->m->u.user.name, m->name);
-					set_revision(m->m->u.user.name,
-						     m->revision);
-					if (m->init != NULL)
-						m->init(m->m);
-
-					opts = merge_options(opts,
-					    m->extra_opts, &m->option_offset);
+			/* handles targets */
+			if (target && target->parse(c - target->option_offset,
+						argv, invert,
+						&target->tflags,
+						&fw, &target->t)) {
+				continue;
+			}
 
-					optind--;
+			/* handles matches */
+			for (matchp = matches; matchp; matchp = matchp->next) {
+				if (matchp->completed)
 					continue;
-				}
-				if (!m)
-					exit_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'",
-						   argv[optind-1]);
+				if (matchp->match->parse(c - matchp->match->option_offset,
+							argv, invert,
+							&matchp->match->mflags,
+							&fw,
+							&matchp->match->m))
+					break;
 			}
+
+			/* handles options of autoloaded matches (explaination below) */
+			m = matchp ? matchp->match : NULL;
+
+			/* If you listen carefully, you can
+			   actually hear this code suck. */
+
+			/* some explanations (after four different bugs
+			 * in 3 different releases): If we encounter a
+			 * parameter, that has not been parsed yet,
+			 * it's not an option of an explicitly loaded
+			 * match or a target.  However, we support
+			 * implicit loading of the protocol match
+			 * extension.  '-p tcp' means 'l4 proto 6' and
+			 * at the same time 'load tcp protocol match on
+			 * demand if we specify --dport'.
+			 *
+			 * To make this work, we need to make sure:
+			 * - the parameter has not been parsed by
+			 *   a match (m above)
+			 * - a protocol has been specified
+			 * - the protocol extension has not been
+			 *   loaded yet, or is loaded and unused
+			 *   [think of iptables-restore!]
+			 * - the protocol extension can be successively
+			 *   loaded
+			 */
+			if (m == NULL
+			    && protocol
+			    && (!find_proto(protocol, DONT_LOAD,
+						options&OPT_NUMERIC, NULL)
+				|| (find_proto(protocol, DONT_LOAD,
+						options&OPT_NUMERIC, NULL)
+				    && (proto_used == 0))
+			       )
+			    && (m = find_proto(protocol, TRY_LOAD,
+					       options&OPT_NUMERIC, &matches))) {
+				/* Try loading protocol */
+				size_t size;
+
+				proto_used = 1;
+
+				size = IPT_ALIGN(sizeof(struct ipt_entry_match))
+						 + m->size;
+
+				m->m = fw_calloc(1, size);
+				m->m->u.match_size = size;
+				strcpy(m->m->u.user.name, m->name);
+				set_revision(m->m->u.user.name,
+					     m->revision);
+				if (m->init != NULL)
+					m->init(m->m);
+
+				opts = merge_options(opts,
+				    m->extra_opts, &m->option_offset);
+
+				optind--;
+				continue;
+			}
+			if (!m)
+				exit_error(PARAMETER_PROBLEM,
+					   "Unknown arg `%s'",
+					   argv[optind-1]);
 		}
 		invert = FALSE;
 	}

--------------050809060303070809050203--
