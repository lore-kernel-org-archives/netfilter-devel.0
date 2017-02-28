From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnfct 1/2] conntrack: fix missing break
Date: Tue, 28 Feb 2017 13:55:26 +0900
Message-ID: <20170228045526.GB21582@gmail.com>
References: <20170228045359.GA21582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35155 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdB1E45 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 23:56:57 -0500
Received: by mail-pf0-f194.google.com with SMTP id y23so199273pfk.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 20:55:29 -0800 (PST)
Received: from gmail.com (softbank218138040024.bbtec.net. [218.138.40.24])
        by smtp.gmail.com with ESMTPSA id 19sm860360pft.46.2017.02.27.20.55.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 20:55:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170228045359.GA21582@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/objopt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index 119a83a..fb43d6c 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -81,6 +81,7 @@ static void setobjopt_undo_dnat(struct nf_conntrack *ct)
 		ct->dnat.max_ip.v4 = ct->dnat.min_ip.v4;
 		ct->repl.src.v4 = ct->head.orig.dst.v4;
 		set_bit(ATTR_DNAT_IPV4, ct->head.set);
+		break;
 	case AF_INET6:
 		memcpy(&ct->dnat.min_ip.v6, &ct->repl.src.v6,
 		       sizeof(struct in6_addr));
-- 
2.11.0

