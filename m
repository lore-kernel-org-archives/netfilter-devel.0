From: "Changli Gao" <xiaosuo@gmail.com>
Subject: [IPTABLES] the same options for different kinds of matches don't work
Date: Sat, 16 Aug 2008 00:51:07 +0800
Message-ID: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:16112 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYHOQvI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:51:08 -0400
Received: by ti-out-0910.google.com with SMTP id b6so461443tic.23
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2008 09:51:07 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using iptables to extent the firewall of Linux, I found that: if
there are more than one kinds of iptables matches, only the former
options are parsed correctly, but the later options will be treated
wrongly.

For example:

iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
-m b --mac-source 00:11:22:33:44:55 -j ACCEPT

the above command will fail due to the later match.

Then I checked the source code of iptables. It seems that the extra
options for each match are global for each individual command. It is
out of my exception. I used to think that options are only available
for that match. So I "fixed" this issues quickly. After patching, the
command options contain the default global options and the last match
or the target extra options.

The following is the patch for this issue against iptables-1.3.8. Yea,
it is only for iptables, but not for ip6tables, as I don't know if I
am right or not.

diff -ur iptables-1.3.8/include/iptables.h iptables-1.3.8.new/include/iptables.h
--- iptables-1.3.8/include/iptables.h	2007-01-23 20:49:52.000000000 +0800
+++ iptables-1.3.8.new/include/iptables.h	2008-08-15 22:30:11.000000000 +0800
@@ -35,10 +35,6 @@
 	struct iptables_rule_match *next;

 	struct iptables_match *match;
-
-	/* Multiple matches of the same type: the ones before
-	   the current one are completed from parsing point of view */	
-	unsigned int completed;
 };

 /* Include file for additions: new matches and targets. */
diff -ur iptables-1.3.8/iptables.c iptables-1.3.8.new/iptables.c
--- iptables-1.3.8/iptables.c	2007-04-30 07:03:30.000000000 +0800
+++ iptables-1.3.8.new/iptables.c	2008-08-15 22:29:42.000000000 +0800
@@ -793,12 +793,9 @@

 		newentry = fw_malloc(sizeof(struct iptables_rule_match));

-		for (i = matches; *i; i = &(*i)->next) {
-			if (strcmp(name, (*i)->match->name) == 0)
-				(*i)->completed = 1;
-		}
+		for (i = matches; *i; i = &(*i)->next)
+			/* do nothing */;
 		newentry->match = ptr;
-		newentry->completed = 0;
 		newentry->next = NULL;
 		*i = newentry;
 	}
@@ -2182,6 +2179,7 @@
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t, &fw.nfcache);
+				free_opts(1);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -2234,9 +2232,8 @@
 			set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m, &fw.nfcache);
-			if (m != m->next)
-				/* Merge options for non-cloned matches */
-				opts = merge_options(opts, m->extra_opts, &m->option_offset);
+			free_opts(1);
+			opts = merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;

@@ -2319,18 +2316,13 @@
 					       argv, invert,
 					       &target->tflags,
 					       &fw, &target->t))) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed)
-						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
+				if (m && !m->parse(c - m->option_offset,
 						     argv, invert,
-						     &matchp->match->mflags,
+						     &m->mflags,
 						     &fw,
 						     &fw.nfcache,
-						     &matchp->match->m))
-						break;
-				}
-				m = matchp ? matchp->match : NULL;
+						     &m->m))
+					m = NULL;

 				/* If you listen carefully, you can
 				   actually hear this code suck. */
@@ -2381,6 +2373,7 @@
 					if (m->init != NULL)
 						m->init(m->m, &fw.nfcache);

+					free_opts(1);
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
