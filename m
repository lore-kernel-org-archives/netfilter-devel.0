From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH v2 5/5] nft: replace args.family
Date: Tue, 23 Jul 2013 18:13:45 +0200
Message-ID: <20130723161316.10040.78293.stgit@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64386 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab3GWQOC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:14:02 -0400
Received: by mail-wg0-f41.google.com with SMTP id y10so3658906wgg.2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2013 09:14:00 -0700 (PDT)
Received: from [127.0.0.1] (adsl-ull-226-41.46-151.net24.it. [151.46.41.226])
        by mx.google.com with ESMTPSA id fb2sm6994033wic.4.2013.07.23.09.13.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 09:13:59 -0700 (PDT)
In-Reply-To: <20130723161017.10040.6256.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index d4b8709..d1b04cb 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1096,7 +1096,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (h->family == AF_UNSPEC)
 		h->family = args.family;
 
-	h->ops = nft_family_ops_lookup(args.family);
+	h->ops = nft_family_ops_lookup(h->family);
 	if (h->ops == NULL)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 

