From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] disallow multiple matches of same type
Date: Sun, 19 Feb 2006 21:54:21 -0800
Message-ID: <20060220055421.GA10552@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
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


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In latest iptables SVN, the command:

iptables -A foo -p tcp -m multiport --dport 45,47 -m multiport --sport 45:48

ends up with mangled results of:

... multiport sports  multiport sports  tcp spts:45:48

Since at present, iptables can only handle one match of a given type
per rule.  The below patch makes sure we disallow more than one.

This closes bugzilla #447

Phil



--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nomultimatch

--- ipt-orig/iptables.c	2006-02-11 01:50:11.000000000 -0800
+++ ipt-new/iptables.c	2006-02-19 21:46:03.000000000 -0800
@@ -2125,6 +2125,11 @@
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
+			for (matchp = matches; matchp; matchp = matchp->next) {
+				if (strcmp(optarg, matchp->match->name) == 0)
+					exit_error(PARAMETER_PROBLEM,
+						   "multiple matches of same type not supported");
+			}
 			m = find_match(optarg, LOAD_MUST_SUCCEED, &matches);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;

--tKW2IUtsqtDRztdT--
