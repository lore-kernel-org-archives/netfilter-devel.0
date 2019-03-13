Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4314EC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE16213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfCMTqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:46:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48594 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfCMTqo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:46:44 -0400
Received: from localhost ([::1]:33452 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h49pq-0001B9-Uk; Wed, 13 Mar 2019 20:46:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/6] xtables-save: Point at existing man page in help text
Date:   Wed, 13 Mar 2019 20:46:17 +0100
Message-Id: <20190313194617.31071-7-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313194617.31071-1-phil@nwl.cc>
References: <20190313194617.31071-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-save.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 87ebb913f33b7..2cc5a7c7540be 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -187,7 +187,8 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 			exit(0);
 		default:
 			fprintf(stderr,
-				"Look at manual page `xtables-save.8' for more information.\n");
+				"Look at manual page `%s.8' for more information.\n",
+				prog_name);
 			exit(1);
 		}
 	}
@@ -333,7 +334,8 @@ int xtables_eb_save_main(int argc_, char *argv_[])
 			exit(0);
 		default:
 			fprintf(stderr,
-				"Look at manual page `xtables-save.8' for more information.\n");
+				"Look at manual page `%s.8' for more information.\n",
+				prog_name);
 			exit(1);
 		}
 	}
@@ -380,7 +382,8 @@ int xtables_arp_save_main(int argc, char **argv)
 			exit(0);
 		default:
 			fprintf(stderr,
-				"Look at manual page `xtables-save.8' for more information.\n");
+				"Look at manual page `%s.8' for more information.\n",
+				prog_name);
 			exit(1);
 		}
 	}
-- 
2.21.0

