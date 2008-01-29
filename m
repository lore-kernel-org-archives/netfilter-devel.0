From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
Date: Tue, 29 Jan 2008 16:25:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291621000.1185@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr>
 <479F245A.2030509@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYA2PZ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:25:26 -0500
In-Reply-To: <479F245A.2030509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 14:04, Patrick McHardy wrote:
>Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
>
> Jan Engelhardt wrote:
>> Hi,
>> 
>> this patch was previously unmerged because it conflicted with Eric Dumazet's
>> changes. I now rediffed it; please apply.
>
> This adds a huge number of sparse warnings, please fix those up.
> I already fixed those in your other recent patches, but please
> make sure all patches you submit are sparse warning free.

Interestingly enough, I do not get these warnings.
Anyway, please have this patch on top:

The last u_int32_t should be ok as it stands.

commit 4af962ecb31dbd1588f6c8e50226666cc8147d77
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 29 16:24:47 2008 +0100

    [NETFILTER]: xt_hashlimit: fix sparse warnings
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 68c1962..71572f9 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -464,7 +464,7 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
 	dh->rateinfo.prev = now;
 }
 
-static inline u_int32_t maskl(u_int32_t a, unsigned int l)
+static inline __be32 maskl(__be32 a, unsigned int l)
 {
 	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
 }

