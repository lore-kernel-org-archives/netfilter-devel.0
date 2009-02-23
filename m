From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] libxtables: prefix exit_error to xtables_error
Date: Mon, 23 Feb 2009 17:46:14 +0100
Message-ID: <49A2D2D6.8070606@trash.net>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de> <1235186284-31661-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZBWQqR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:46:17 -0500
In-Reply-To: <1235186284-31661-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

> diff --git a/extensions/expr b/extensions/expr
> new file mode 100644
> index 0000000..f00b70d
> --- /dev/null
> +++ b/extensions/expr
> @@ -0,0 +1,179 @@
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <libHX/option.h>
> +
> +enum ttl_rel {
> +	REL_EQ,
> +	REL_LT,
> +	REL_GT,
> +}

What is this file? I see no mentioning in the (non-existant) changelog.
