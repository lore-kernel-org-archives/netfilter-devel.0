From: Tim Gardner <timg@tpi.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 14:40:48 -0600
Message-ID: <4BA13E50.9050706@tpi.com>
References: <20100317184852.89F0DF89BB@sepang.rtg.net> <1268854497.2894.2.camel@edumazet-laptop>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060107070406060309040402"
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4276 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0CQUlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:41:08 -0400
In-Reply-To: <1268854497.2894.2.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060107070406060309040402
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/17/2010 01:34 PM, Eric Dumazet wrote:
> Le mercredi 17 mars 2010 à 12:48 -0600, Tim Gardner a écrit :
>> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
>> index 532c328..26e4fb9 100644
>> --- a/extensions/libxt_recent.man
>> +++ b/extensions/libxt_recent.man
>> @@ -41,6 +41,11 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
>>   \fB\-\-update\fP. When used, this will narrow the match to only happen when the
>>   address is in the list and was seen within the last given number of seconds.
>>   .TP
>> +\fB\-\-reap\fP \fIreap\fP
>> +This option must be used in conjunction with \fB\-\-seconds\fP. When used, this
>> +will remove entries with the most recent timestamp older then \fB\-\-seconds\fP
>> +since the last packet was received.
>> +.TP
>>   \fB\-\-hitcount\fP \fIhits\fP
>>   This option must be used in conjunction with one of \fB\-\-rcheck\fP or
>>   \fB\-\-update\fP. When used, this will narrow the match to only happen when the
>
> Are you sure this "most recent timestamp older then " is correct ? ;)
>
>
>

How about this (attached):

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357

--------------060107070406060309040402
Content-Type: text/x-diff;
 name="0001-xt_recent-Simplified-and-corrected-some-man-page-ver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xt_recent-Simplified-and-corrected-some-man-page-ver.pa";
 filename*1="tch"

>From e89de2a97d4336795503bb3406ba494338a06292 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 17 Mar 2010 14:36:17 -0600
Subject: [PATCH] xt_recent: Simplified and corrected some man page verbage about --reap

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 extensions/libxt_recent.man |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 26e4fb9..342c383 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -41,10 +41,10 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
-\fB\-\-reap\fP \fIreap\fP
-This option must be used in conjunction with \fB\-\-seconds\fP. When used, this
-will remove entries with the most recent timestamp older then \fB\-\-seconds\fP
-since the last packet was received.
+\fB\-\-reap\fP
+This option may be used in conjunction with \fB\-\-seconds\fP. When used, this
+will remove entries that have not received a packet within the time specified by
+\fB\-\-seconds\fP.
 .TP
 \fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
-- 
1.7.0


--------------060107070406060309040402--
