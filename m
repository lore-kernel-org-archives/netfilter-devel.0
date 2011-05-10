From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 8/8] netfilter: revert a2361c8735e07322023aedc36e4938b35af31eb0
Date: Tue, 10 May 2011 12:14:16 +0200
Message-ID: <4DC90FF8.90500@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org> <1305021959-2980-9-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070304030604060804040404"
Cc: netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab1EJKOZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:14:25 -0400
In-Reply-To: <1305021959-2980-9-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070304030604060804040404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/05/11 12:05, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch reverts a2361c8735e07322023aedc36e4938b35af31eb0:
> "[PATCH] netfilter: xt_conntrack: warn about use in raw table"
> 
> Florian Wesphal says:
> "... when the packet was sent from the local machine the skb
> already has ->nfct attached, and -m conntrack seems to do
> the right thing."

Sorry, the description and the patch doesn't match, the correct patch is
attached. I have pushed this to my branch.

--------------070304030604060804040404
Content-Type: text/x-patch;
 name="0008-netfilter-revert-a2361c8735e07322023aedc36e4938b35af.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-netfilter-revert-a2361c8735e07322023aedc36e4938b35af.pa";
 filename*1="tch"

>From 93bbce1ad0cd788190dd7d6c17d289f771fe3d0d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 10 May 2011 12:13:36 +0200
Subject: [PATCH] netfilter: revert a2361c8735e07322023aedc36e4938b35af31eb0

This patch reverts a2361c8735e07322023aedc36e4938b35af31eb0:
"[PATCH] netfilter: xt_conntrack: warn about use in raw table"

Florian Wesphal says:
"... when the packet was sent from the local machine the skb
already has ->nfct attached, and -m conntrack seems to do
the right thing."

Acked-by: Jan Engelhardt <jengelh@medozas.de>
Reported-by: Florian Wesphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_conntrack.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 481a86f..61805d7 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -272,11 +272,6 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	int ret;
 
-	if (strcmp(par->table, "raw") == 0) {
-		pr_info("state is undetermined at the time of raw table\n");
-		return -EINVAL;
-	}
-
 	ret = nf_ct_l3proto_try_module_get(par->family);
 	if (ret < 0)
 		pr_info("cannot load conntrack support for proto=%u\n",
-- 
1.7.2.3


--------------070304030604060804040404--
