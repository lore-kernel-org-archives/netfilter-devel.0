From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/2] net/netfilter: make symbol static
Date: Thu, 28 May 2009 14:45:43 +0200
Message-ID: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:34915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZE1Mps (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 08:45:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix this sparse warning:
  net/netfilter/nf_log.c:219:17: warning: symbol 'nf_log_sysctl_path' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/netfilter/nf_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index beb3731..7511aed 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -216,7 +216,7 @@ static const struct file_operations nflog_file_ops = {
 #endif /* PROC_FS */
 
 #ifdef CONFIG_SYSCTL
-struct ctl_path nf_log_sysctl_path[] = {
+static struct ctl_path nf_log_sysctl_path[] = {
 	{ .procname = "net", .ctl_name = CTL_NET, },
 	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
 	{ .procname = "nf_log", .ctl_name = CTL_UNNUMBERED, },

