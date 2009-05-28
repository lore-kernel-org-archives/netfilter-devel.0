From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/2] net/netfilter: remove redundant variable
Date: Thu, 28 May 2009 14:45:51 +0200
Message-ID: <20090528124548.21789.63516.stgit@jazzy.zrh.corp.google.com>
References: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:34923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbZE1Mpy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 08:45:54 -0400
In-Reply-To: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/netfilter/nf_log.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 7511aed..b584cc2 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -47,7 +47,6 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {
-		int i;
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 			list_add_tail(&(logger->list[i]), &(nf_loggers_l[i]));
 	} else {

