From: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
Subject: [Patch] ip{,6}tables-restore -n with existing user defined chain
Date: Wed, 18 May 2005 12:07:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


I want to redefine an existing chain atomically. I can't do that with the 
iptables command, but can almost do it with iptables-restore -n. When I 
try, iptables barfs because the chain already exists. Duh! Yeah, I know 
it exists, but I want to redefine it.

I don't see the semantics of this case defined anywhere, and I can't find 
discussion of it in the archives. So I suggest that the semantics be 
redefined, so that iptables-restore -n can redefine an existing chain 
(iptables-restore without -n already does that). I really can't think why 
anyone would depend on the current semantics.

Index: ip6tables-restore.c
===================================================================
--- ip6tables-restore.c	(revision 3922)
+++ ip6tables-restore.c	(working copy)
@@ -233,12 +233,21 @@
  			}

  			if (ip6tc_builtin(chain, handle) <= 0) {
-				DEBUGP("Creating new chain '%s'\n", chain);
-				if (!ip6tc_create_chain(chain, &handle))
-					exit_error(PARAMETER_PROBLEM,
-						   "error creating chain "
-						   "'%s':%s\n", chain,
-						   strerror(errno));
+				if (noflush && ip6tc_is_chain(chain, handle)) {
+					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
+					if (!ip6tc_flush_entries(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error flushing chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				} else {
+					DEBUGP("Creating new chain '%s'\n", chain);
+					if (!ip6tc_create_chain(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error creating chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				}
  			}

  			policy = strtok(NULL, " \t\n");
Index: iptables-restore.c
===================================================================
--- iptables-restore.c	(revision 3922)
+++ iptables-restore.c	(working copy)
@@ -236,12 +236,21 @@
  			}

  			if (iptc_builtin(chain, handle) <= 0) {
-				DEBUGP("Creating new chain '%s'\n", chain);
-				if (!iptc_create_chain(chain, &handle))
-					exit_error(PARAMETER_PROBLEM,
-						   "error creating chain "
-						   "'%s':%s\n", chain,
-						   strerror(errno));
+				if (noflush && iptc_is_chain(chain, handle)) {
+					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
+					if (!iptc_flush_entries(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error flushing chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				} else {
+					DEBUGP("Creating new chain '%s'\n", chain);
+					if (!iptc_create_chain(chain, &handle))
+						exit_error(PARAMETER_PROBLEM,
+							   "error creating chain "
+							   "'%s':%s\n", chain,
+							   strerror(errno));
+				}
  			}

  			policy = strtok(NULL, " \t\n");
