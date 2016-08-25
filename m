From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: imm: Fix immediate verdict comparison
Date: Thu, 25 Aug 2016 17:19:30 +0200
Message-ID: <20160825151930.GA3482@salvia>
References: <20160825145658.29391-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756401AbcHYP0v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 11:26:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B4DC18CDC1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 17:19:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00553100798
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 17:19:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1DE9114D63
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 17:19:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160825145658.29391-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Aug 25, 2016 at 04:56:58PM +0200, Carlos Falgueras García wrote:
> An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
> or goto), in this cases we must compare its 'union nftnl_data_reg' using
> 'DATA_CHAIN' flag instead of 'DATA_VERDICT'
> 
> Before this patch compare expressions "jump -> chain_a" and
> "jump -> chain_b" returns they are equals.
> 
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  src/expr/immediate.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
> index cb8a81b..b26fc8d 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -329,10 +329,16 @@ static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
>  
>  	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
>  		eq &= (i1->dreg == i2->dreg);
> -	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
> -		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
> -	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
> +	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
> +		if (e1->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
> +			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
> +						 DATA_CHAIN);
> +		else
> +			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
> +						 DATA_VERDICT);

Probably better with this patch below? You don't need to split the
lines.

No need to resend, just review and confirm this change is OK and I'll
apply this here.

--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="y.patch"
Content-Transfer-Encoding: 8bit

>From 521b6b1a7cc99445cf983403add23f373836d1a8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Date: Thu, 25 Aug 2016 16:56:58 +0200
Subject: [PATCH] expr: imm: Fix immediate verdict comparison
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
or goto), in this cases we must compare its 'union nftnl_data_reg' using
'DATA_CHAIN' flag instead of 'DATA_VERDICT'

Before this patch compare expressions "jump -> chain_a" and
"jump -> chain_b" returns they are equals.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/immediate.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index cb8a81b..8636738 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -326,13 +326,20 @@ static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
 	struct nftnl_expr_immediate *i1 = nftnl_expr_data(e1);
 	struct nftnl_expr_immediate *i2 = nftnl_expr_data(e2);
 	bool eq = true;
+	int type;
 
 	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
 		eq &= (i1->dreg == i2->dreg);
-	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
-		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
-	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
+	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
+		if (e1->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
+			type = DATA_CHAIN;
+		else
+			type = DATA_VERDICT;
+
+		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, type);
+	} else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
 		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VALUE);
+	}
 
 	return eq;
 }
-- 
2.1.4


--liOOAslEiF7prFVr--
