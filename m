From: Bo YU <tsu.yubo@gmail.com>
Subject: Re: [PATCH ipset] fix compilation with musl libc
Date: Sat, 16 Sep 2017 08:39:54 -0400
Message-ID: <20170916123953.GB21065@yubo-2>
References: <20170916110510.2234-1-kaarle.ritvanen@datakunkku.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38866 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdIPMkC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Sep 2017 08:40:02 -0400
Received: by mail-pf0-f193.google.com with SMTP id q76so2484602pfq.5
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Sep 2017 05:40:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170916110510.2234-1-kaarle.ritvanen@datakunkku.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
On Sat, Sep 16, 2017 at 02:05:10PM +0300, Kaarle Ritvanen wrote:
>Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>

Maybe you miss the git commit

>---
> src/ipset.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/src/ipset.c b/src/ipset.c
>index 79f56b8..dffc74e 100644
>--- a/src/ipset.c
>+++ b/src/ipset.c
>@@ -14,6 +14,7 @@
> #include <stdio.h>			/* fprintf, fgets */
> #include <stdlib.h>			/* exit */
> #include <string.h>			/* str* */
>+#include <sys/types.h>			/* u_int8_t */
>
> #include <config.h>

Best Regards,
Bo
>
>--
>2.9.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
