From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables segfault on -D
Date: Thu, 3 Feb 2005 16:55:37 -0800
Message-ID: <20050204005537.GA25682@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
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


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Using latest 1.3.0-rc1 snapshot, a rule delete causes a segfault:

# iptables -A foo -p tcp --dport 1234   
# iptables -D foo -p tcp --dport 1234
Segmentation fault

Problem is caused by a superfluous memset which memsets a greater-
than-malloced area.  Patch below.

Phil



--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-sigsegv

--- ipt-orig/libiptc/libiptc.c	2005-02-01 08:45:56.000000000 -0800
+++ ipt-new/libiptc/libiptc.c	2005-02-03 16:51:46.000000000 -0800
@@ -2047,7 +2047,6 @@
 
 	counterlen = sizeof(STRUCT_COUNTERS_INFO)
 			+ sizeof(STRUCT_COUNTERS) * new_number;
-	memset(repl, 0, sizeof(*repl) + (*handle)->entries->size);
 
 	/* These are the old counters we will get from kernel */
 	repl->counters = malloc(sizeof(STRUCT_COUNTERS)

--nFreZHaLTZJo0R7j--
