From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Disallow newlines in LOG target --log-prefix
Date: Tue, 29 Mar 2005 11:34:22 -0800
Message-ID: <20050329193422.GA12848@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
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


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported in bugzilla, iptables currently does not complain about
the following:

# iptables -A foo -j LOG --log-prefix 'asdfasdfa
asdf'

Patch below makes it complain, and closes bugzilla #312.

Phil



--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-logprefix

diff -ru iptables-orig/extensions/libip6t_LOG.c iptables-new/extensions/libip6t_LOG.c
--- iptables-orig/extensions/libip6t_LOG.c	2005-02-19 11:19:17.000000000 -0800
+++ iptables-new/extensions/libip6t_LOG.c	2005-03-29 11:30:19.000000000 -0800
@@ -134,6 +134,10 @@
 				   "Maximum prefix length %u for --log-prefix",
 				   (unsigned int)sizeof(loginfo->prefix) - 1);
 
+		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
+			exit_error(PARAMETER_PROBLEM,
+				   "Newlines not allowed in --log-prefix");
+
 		strcpy(loginfo->prefix, optarg);
 		*flags |= IP6T_LOG_OPT_PREFIX;
 		break;
diff -ru iptables-orig/extensions/libipt_LOG.c iptables-new/extensions/libipt_LOG.c
--- iptables-orig/extensions/libipt_LOG.c	2005-02-19 11:19:17.000000000 -0800
+++ iptables-new/extensions/libipt_LOG.c	2005-03-29 11:27:54.000000000 -0800
@@ -143,6 +143,10 @@
 				   "Maximum prefix length %u for --log-prefix",
 				   (unsigned int)sizeof(loginfo->prefix) - 1);
 
+		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
+			exit_error(PARAMETER_PROBLEM,
+				   "Newlines not allowed in --log-prefix");
+
 		strcpy(loginfo->prefix, optarg);
 		*flags |= IPT_LOG_OPT_PREFIX;
 		break;

--uAKRQypu60I7Lcqm--
