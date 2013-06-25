From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 2/2] nft: mem leak in nft_rule_list_cb
Date: Tue, 25 Jun 2013 09:46:17 +0200
Message-ID: <20130625074617.4665.91288.stgit@localhost>
References: <20130625074606.4665.80766.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44117 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYHqV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:46:21 -0400
Received: by mail-ee0-f54.google.com with SMTP id t10so6489102eei.27
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2013 00:46:19 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.89.105])
        by mx.google.com with ESMTPSA id a4sm33974668eez.0.2013.06.25.00.46.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 25 Jun 2013 00:46:19 -0700 (PDT)
In-Reply-To: <20130625074606.4665.80766.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Memory leak in function nft_rule_list_cb fixed.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 680b2f0..98d602c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1140,6 +1140,7 @@ static int nft_rule_list_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 out:
 	nft_rule_free(r);
+	nft_rule_list_free(list);
 err:
 	return MNL_CB_OK;
 }

