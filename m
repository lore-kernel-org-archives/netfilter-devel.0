From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_conntrack: make nf_conntrack_max as an unsigned int knob
Date: Sat,  8 Apr 2017 17:32:25 +0800
Message-ID: <1491643945-8557-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:47162 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751523AbdDHJc7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 05:32:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

It doesn't work when we set a large value to the nf_conntrack_max, as
well as the nf_conntrack_expect_max:
  # echo 4294967295 > /proc/sys/net/nf_conntrack_max
  bash: echo: write error: Invalid argument

So convert to use proc_douintvec.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_standalone.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2256147..7f131a3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -479,9 +479,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
 		.data		= &nf_conntrack_max,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_douintvec,
 	},
 	{
 		.procname	= "nf_conntrack_count",
@@ -516,9 +516,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_expect_max",
 		.data		= &nf_ct_expect_max,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_douintvec,
 	},
 	{
 		.procname	= "nf_conntrack_default_on",
@@ -534,9 +534,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
 		.data		= &nf_conntrack_max,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_douintvec,
 	},
 	{ }
 };
-- 
2.5.5


