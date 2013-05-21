From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH] rule: display rule handle as comment
Date: Tue, 21 May 2013 21:06:49 +0200
Message-ID: <06c0d6b3-993c-4e28-b78b-14d62e3a83bc@email.android.com>
References: <1369091340-29211-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35393 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3EUTG5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 May 2013 15:06:57 -0400
In-Reply-To: <1369091340-29211-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Eric Leblond <eric@regit.org> schrieb:

>Knowing the rule handle is necessary to be able to delete a single
>rule. It was not displayed till now in the output and it was thus
>impossible to remove a single rule.
>This patch modify the listing output to add a comment containing
>the handle.
>
>Signed-off-by: Eric Leblond <eric@regit.org>
>---
> src/rule.c |    2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/src/rule.c b/src/rule.c
>index 9d9eaee..b2d7844 100644
>--- a/src/rule.c
>+++ b/src/rule.c
>@@ -13,6 +13,7 @@
> #include <stdio.h>
> #include <stdint.h>
> #include <string.h>
>+#include <inttypes.h>
> 
> #include <statement.h>
> #include <rule.h>
>@@ -136,6 +137,7 @@ void rule_print(const struct rule *rule)
> 		printf(" ");
> 		stmt->ops->print(stmt);
> 	}
>+	printf(" # handle %" PRIu64, rule->handle.handle);
> 	printf("\n");
> }
> 

The output is supposed to be parsable again and should also remain as readable as possible. I discussed this with Pablo, we agreed on adding a command line switch for this.
