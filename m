From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ip6tables: check for valid init prior to calling
Date: Sun, 3 Jul 2005 10:03:45 -0700
Message-ID: <20050703170345.GA20892@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Unlike iptables, ip6tables does not check that match|target->init
is !NULL prior to calling, leading to problems in those extensions
which don't define init, like owner:

# ip6tables -m owner
Segmentation fault

The below patch copies iptables checks.

Phil



--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ip6tinit

diff -ruN ipt-orig/ip6tables.c ipt-new/ip6tables.c
--- ipt-orig/ip6tables.c	2005-02-19 11:19:17.000000000 -0800
+++ ipt-new/ip6tables.c	2005-07-03 09:57:48.000000000 -0700
@@ -1919,7 +1919,8 @@
 				target->t = fw_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				target->init(target->t, &fw.nfcache);
+				if (target->init != NULL)
+					target->init(target->t, &fw.nfcache);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -1963,7 +1964,8 @@
 			m->m = fw_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			m->init(m->m, &fw.nfcache);
+			if (m->init != NULL)
+				m->init(m->m, &fw.nfcache);
 			opts = merge_options(opts, m->extra_opts, &m->option_offset);
 		}
 		break;
@@ -2104,7 +2106,8 @@
 					m->m = fw_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					m->init(m->m, &fw.nfcache);
+					if (m->init != NULL)
+						m->init(m->m, &fw.nfcache);
 
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);
@@ -2232,7 +2235,8 @@
 			target->t = fw_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
-			target->init(target->t, &fw.nfcache);
+			if (target->init != NULL)
+				target->init(target->t, &fw.nfcache);
 		}
 
 		if (!target) {

--ZPt4rx8FFjLCG7dd--
