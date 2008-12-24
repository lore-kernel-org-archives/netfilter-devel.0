From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libxt_rateest: fix segfault
Date: Wed, 24 Dec 2008 20:15:26 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812242015110.8067@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812081818050.2016@fbirervta.pbzchgretzou.qr> <493E7B1D.7030003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45875 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYLXTP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:15:27 -0500
In-Reply-To: <493E7B1D.7030003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-09 15:05, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> When running `ip6tables -m rateest` without any other arguments,
>> rateest did segfault.
>> ---
>>  extensions/libxt_rateest.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
>> index ebea437..f0dd577 100644
>> --- a/extensions/libxt_rateest.c
>> +++ b/extensions/libxt_rateest.c
>> @@ -306,7 +306,7 @@ rateest_final_check(unsigned int flags)
>>  {
>>   struct xt_rateest_match_info *info = rateest_info;
>> 
>> -	if (!(info->flags & XT_RATEEST_MATCH_REL))
>> +	if (info != NULL && !(info->flags & XT_RATEEST_MATCH_REL))
>>    info->flags |= XT_RATEEST_MATCH_ABS;
>
> I think we should print an error message instead. The kernel will
> refuse it anyways.

parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
commit e2ac8eed9cd24bfabedb931c854ab7e0c9de5fd1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Dec 24 20:15:44 2008 +0100

rateest: guard against segfault

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index ebea437..333239d 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -306,6 +306,9 @@ rateest_final_check(unsigned int flags)
 {
 	struct xt_rateest_match_info *info = rateest_info;
 
+	if (info == NULL)
+		exit_error(PARAMETER_PROBLEM, "rateest match: "
+		           "you need to specify some flags");
 	if (!(info->flags & XT_RATEEST_MATCH_REL))
 		info->flags |= XT_RATEEST_MATCH_ABS;
 }
