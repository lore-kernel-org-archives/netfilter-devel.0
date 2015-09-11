From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-log 2/3] nlmsg: Add NFULA_CT and NFULA_CT_INFO attributes
 support
Date: Fri, 11 Sep 2015 12:14:25 +0900
Message-ID: <20150911031425.GF7380@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34508 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIKDOa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 23:14:30 -0400
Received: by padhy16 with SMTP id hy16so61260554pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 20:14:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150911030530.GA7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch validate NFULA_CT and NFULA_CT_INFO attributes,

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/nlmsg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index 0aa21a0..3ebb364 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -7,7 +7,6 @@
  * (at your option) any later version.
  */
 #include <arpa/inet.h>
-#include <linux/netfilter/nfnetlink_log.h>
 #include <libmnl/libmnl.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 #include <errno.h>
@@ -112,6 +111,7 @@ static int nflog_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFULA_SEQ:			/* instance-local sequence number */
 	case NFULA_SEQ_GLOBAL:		/* global sequence number */
 	case NFULA_GID:			/* group id of socket */
+	case NFULA_CT_INFO:		/* enum ip_conntrack_info */
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			return MNL_CB_ERROR;
 		break;
@@ -139,6 +139,7 @@ static int nflog_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFULA_HWHEADER:		/* hardware header */
 	case NFULA_PAYLOAD:		/* opaque data payload */
+	case NFULA_CT:			/* nf_conntrack_netlink.h */
 		break;
 	}
 	tb[type] = attr;
-- 
2.1.4

