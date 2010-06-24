From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH 1/3] netfilter: Expose connection tracking accounting
 toggles
Date: Thu, 24 Jun 2010 10:07:20 -0600
Message-ID: <4C2382B8.3050601@canonical.com>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-2-git-send-email-tim.gardner@canonical.com> <4C237B6D.5010904@trash.net>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002030907090103030705"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4068 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0FXQHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:07:42 -0400
In-Reply-To: <4C237B6D.5010904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030002030907090103030705
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 06/24/2010 09:36 AM, Patrick McHardy wrote:
> Tim Gardner wrote:
>> nf_ct_acct_enabled() - Get CT accounting state.
>> nf_ct_set_acct() - Enable/disable CT accountuing.
>
> Thanks for taking care of this. Just one final comment:
>
>> diff --git a/include/net/netfilter/nf_conntrack_acct.h
>> b/include/net/netfilter/nf_conntrack_acct.h
>> index 03e218f..31f5cd3 100644
>> --- a/include/net/netfilter/nf_conntrack_acct.h
>> +++ b/include/net/netfilter/nf_conntrack_acct.h
>> @@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct
>> nf_conn *ct, gfp_t gfp)
>> extern unsigned int
>> seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
>>
>> +/* Check if connection tracking accounting is enabled */
>> +static inline bool nf_ct_acct_enabled(const struct xt_mtchk_param *par)
>
>  From an API point of view its cleaner to have the caller just pass
> in the net pointer. Accounting has no direct relationship to xtables.
>

Of course I noticed that 100 msec after sending the email. Doh! You are 
absolutely correct.

> It would also make sense to fold this patch into 2/3 since this is
> where these functions are actually getting used.
>

Thusly ?

The following changes since commit fe6fb552858f686f39e33d7b0a33fe56dacea0bf:
   Arnd Hannemann (1):
         netfilter: fix simple typo in KConfig for netfiltert xt_TEE

are available in the git repository at:

   git://kernel.ubuntu.com/rtg/nf-next-2.6 CONFIG_NF_CT_ACCT

Tim Gardner (2):
       netfilter: xt_connbytes: Force CT accounting to be enabled
       netfilter: Complete the deprecation of CONFIG_NF_CT_ACCT

  Documentation/feature-removal-schedule.txt |    9 ---------
  Documentation/kernel-parameters.txt        |    3 +--
  include/net/netfilter/nf_conntrack_acct.h  |   12 ++++++++++++
  net/netfilter/Kconfig                      |   22 ----------------------
  net/netfilter/nf_conntrack_acct.c          |   10 ----------
  net/netfilter/xt_connbytes.c               |   10 ++++++++++
  6 files changed, 23 insertions(+), 43 deletions(-)

-- 
Tim Gardner tim.gardner@canonical.com

--------------030002030907090103030705
Content-Type: text/x-patch;
 name="0001-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-xt_connbytes-Force-CT-accounting-to-be-ena.pa";
 filename*1="tch"

>From c382de4aa85c5d0f95e35686cf417666d93498e9 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 22 Jun 2010 09:25:48 -0600
Subject: [PATCH 1/2] netfilter: xt_connbytes: Force CT accounting to be enabled

Check at rule install time that CT accounting is enabled. Force it
to be enabled if not while also emitting a warning since this is not
the default state.

This is in preparation for deprecating CONFIG_NF_CT_ACCT upon which
CONFIG_NETFILTER_XT_MATCH_CONNBYTES depended being set.

Added 2 CT accounting support functions:

nf_ct_acct_enabled() - Get CT accounting state.
nf_ct_set_acct() - Enable/disable CT accountuing.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/net/netfilter/nf_conntrack_acct.h |   12 ++++++++++++
 net/netfilter/xt_connbytes.c              |   10 ++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 03e218f..2e95723 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -45,6 +45,18 @@ struct nf_conn_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 extern unsigned int
 seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
 
+/* Check if connection tracking accounting is enabled */
+static inline bool nf_ct_acct_enabled(struct net *net)
+{
+	return net->ct.sysctl_acct == 0 ? false : true;
+}
+
+/* Enable/disable connection tracking accounting */
+static inline void nf_ct_set_acct(struct net *net, bool enable)
+{
+	net->ct.sysctl_acct = enable == true ? 1 : 0;
+}
+
 extern int nf_conntrack_acct_init(struct net *net);
 extern void nf_conntrack_acct_fini(struct net *net);
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7351783..d5944a7 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
+
+	/*
+	 * This filter cannot function correctly unless connection tracking
+	 * accounting is enabled, so complain in the hope that someone notices.
+	 */
+	if (nf_ct_acct_enabled(par->net) == false) {
+		pr_warning("Forcing CT accounting to be enabled\n");
+		nf_ct_set_acct(par->net, true);
+	}
+
 	return ret;
 }
 
-- 
1.7.0.4


--------------030002030907090103030705
Content-Type: text/x-patch;
 name="0002-netfilter-Complete-the-deprecation-of-CONFIG_NF_CT_A.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-netfilter-Complete-the-deprecation-of-CONFIG_NF_CT_A.pa";
 filename*1="tch"

>From cae6161618a774aa2fddf8b041db208ae65bffe2 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 22 Jun 2010 09:30:49 -0600
Subject: [PATCH 2/2] netfilter: Complete the deprecation of CONFIG_NF_CT_ACCT

CONFIG_NF_CT_ACCT has been deprecated for awhile and
was originally scheduled for removal by 2.6.29.

Removing support for this config option also stops
this deprecation warning message in the kernel log.

[   61.669627] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   61.669850] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   61.669852] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   61.669853] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 Documentation/feature-removal-schedule.txt |    9 ---------
 Documentation/kernel-parameters.txt        |    3 +--
 net/netfilter/Kconfig                      |   22 ----------------------
 net/netfilter/nf_conntrack_acct.c          |   10 ----------
 4 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 672be01..92f021a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -303,15 +303,6 @@ Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
 
-What: CONFIG_NF_CT_ACCT
-When: 2.6.29
-Why:  Accounting can now be enabled/disabled without kernel recompilation.
-      Currently used only to set a default value for a feature that is also
-      controlled by a kernel/module/sysfs/sysctl parameter.
-Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
-
----------------------------
-
 What:	sysfs ui for changing p4-clockmod parameters
 When:	September 2009
 Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1808f11..a7279d0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1597,8 +1597,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			[NETFILTER] Enable connection tracking flow accounting
 			0 to disable accounting
 			1 to enable accounting
-			Default value depends on CONFIG_NF_CT_ACCT that is
-			going to be removed in 2.6.29.
+			Default value is 1
 
 	nfsaddrs=	[NFS]
 			See Documentation/filesystems/nfs/nfsroot.txt.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21be535..aa2f106 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -40,27 +40,6 @@ config NF_CONNTRACK
 
 if NF_CONNTRACK
 
-config NF_CT_ACCT
-	bool "Connection tracking flow accounting"
-	depends on NETFILTER_ADVANCED
-	help
-	  If this option is enabled, the connection tracking code will
-	  keep per-flow packet and byte counters.
-
-	  Those counters can be used for flow-based accounting or the
-	  `connbytes' match.
-
-	  Please note that currently this option only sets a default state.
-	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
-	  parameter or by loading the nf_conntrack module with acct=0/1.
-
-	  You may also disable/enable it on a running system with:
-	   sysctl net.netfilter.nf_conntrack_acct=0/1
-
-	  This option will be removed in 2.6.29.
-
-	  If unsure, say `N'.
-
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on NETFILTER_ADVANCED
@@ -630,7 +609,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
-	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index ab81b38..57059aa 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -17,11 +17,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 
-#ifdef CONFIG_NF_CT_ACCT
 #define NF_CT_ACCT_DEFAULT 1
-#else
-#define NF_CT_ACCT_DEFAULT 0
-#endif
 
 static int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
 
@@ -114,12 +110,6 @@ int nf_conntrack_acct_init(struct net *net)
 	net->ct.sysctl_acct = nf_ct_acct;
 
 	if (net_eq(net, &init_net)) {
-#ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
-		printk(KERN_WARNING "nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or\n");
-		printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
-#endif
-
 		ret = nf_ct_extend_register(&acct_extend);
 		if (ret < 0) {
 			printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
-- 
1.7.0.4


--------------030002030907090103030705--
