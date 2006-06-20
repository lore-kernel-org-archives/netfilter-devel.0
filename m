From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] REDIRECT does not accept IP
Date: Mon, 19 Jun 2006 18:22:08 -0700
Message-ID: <20060620012208.GA17152@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
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


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Nicolas Mailhot in bugzilla #483, REDIRECT
does not accept an IP address and when supplied with one,
provides unexpected results.  Patch below fixes this.

Phil



--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-redirect

diff -ruN ipt-orig/extensions/libipt_REDIRECT.c ipt-new/extensions/libipt_REDIRECT.c
--- ipt-orig/extensions/libipt_REDIRECT.c	2005-07-21 23:39:45.000000000 -0700
+++ ipt-new/extensions/libipt_REDIRECT.c	2006-06-19 18:14:37.000000000 -0700
@@ -44,6 +44,9 @@
 
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
+	if (strchr(arg, '.'))
+		exit_error(PARAMETER_PROBLEM, "IP address not permitted\n");
+
 	port = atoi(arg);
 	if (port == 0 || port > 65535)
 		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);

--5vNYLRcllDrimb99--
