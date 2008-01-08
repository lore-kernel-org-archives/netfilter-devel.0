From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Tue, 8 Jan 2008 17:56:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801081753430.3032@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr>
 <4783A5CD.4050705@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48384 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYAHQ4t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:56:49 -0500
In-Reply-To: <4783A5CD.4050705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 17:33, Patrick McHardy wrote:
>
> Since I've lost the overview of your kernel patches I'm going to
> stop at the ones I have now. Please resend everything relevant
> once I've pushed my tree to Dave.
>
You did not miss any patches, thanks.

Could you take care of this one and let it sift through ->dave->linus->;
what do you think, or same verdict as for the previous patch changing
int->int32_t?

A few xtable modules use aligned_u64, which is how I found this one.

commit 35f2e577e432b28969710bc1fd4d9a4c0875f81b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:30:18 2008 +0100

    linux/types.h: Use __u64 for aligned_u64
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/types.h b/include/linux/types.h
index f4f8d19..b94c0e4 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef		__s64		int64_t;
 #endif
 
 /* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+#define aligned_u64 __u64 __attribute__((aligned(8)))
 #define aligned_be64 __be64 __attribute__((aligned(8)))
 #define aligned_le64 __le64 __attribute__((aligned(8)))
 
