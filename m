From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Tue, 16 Mar 2010 13:43:21 -0600
Message-ID: <4B9FDF59.4060409@canonical.com>
References: <20100316170915.8F49FF88DA@sepang.rtg.net> <4B9FD4A8.4070704@trash.net>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070800070107090209020106"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1901 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab0CPUG2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:06:28 -0400
In-Reply-To: <4B9FD4A8.4070704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070800070107090209020106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 03/16/2010 12:57 PM, Patrick McHardy wrote:
> Tim Gardner wrote:
>> > From f2b0624b159e3282d348cd045741725a64d71716 Mon Sep 17 00:00:00 2001
>> From: Tim Gardner<tim.gardner@canonical.com>
>> Date: Sat, 27 Feb 2010 20:22:07 -0700
>> Subject: [PATCH] netfilter: xt_recent: Add an entry reaper (V4)
>>
>> One of the problems with the way xt_recent is implemented is that
>> there is no efficient way to remove expired entries. Of course,
>> one can write a rule '-m recent --remove', but you have to know
>> beforehand which entry to delete. This commit adds reaper
>> logic which checks the head of the LRU list when a rule
>> is invoked that has a '--seconds' value and XT_RECENT_REAP set. If an
>> entry ceases to accumulate time stamps, then it will eventually bubble
>> to the top of the LRU list where it is then reaped.
>
> Thanks, this looks fine. My only concern is that we currently
> don't catch unknown flags, so userspace won't get an error if
> the option is used and the kernel doesn't support it. If you
> document this clearly we can ignore it this one time, but I'd
> appreciate if you could send me a patch on top to check for
> unknown flags and refuse them.
>
>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>
> Applied, thanks.

Thusly? (attached)

P.S. I have the iptables extensions patch ready as soon as this kernel 
stuff settles.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------070800070107090209020106
Content-Type: text/x-diff;
 name="0001-xt_recent-Check-for-unsupported-user-space-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xt_recent-Check-for-unsupported-user-space-flags.patch"

>From 5df68a2a150eb158e9348ff0f7cf88e8b407a84f Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 16 Mar 2010 13:31:38 -0600
Subject: [PATCH] xt_recent: Check for unsupported user space flags.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 include/linux/netfilter/xt_recent.h |    3 +++
 net/netfilter/xt_recent.c           |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index bba990e..e21acdf 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -20,6 +20,9 @@ enum {
 /* Only allowed with --rcheck and --update */
 #define XT_RECENT_MODIFIERS (XT_RECENT_TTL|XT_RECENT_REAP)
 
+#define XT_RECENT_VALID_FLAGS (XT_RECENT_CHECK|XT_RECENT_SET|XT_RECENT_UPDATE|\
+	XT_RECENT_REMOVE|XT_RECENT_TTL|XT_RECENT_REAP)
+
 struct xt_recent_mtinfo {
 	__u32 seconds;
 	__u32 hit_count;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 873a101..fe1aa6f 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -322,6 +322,11 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
 		hash_rnd_inited = true;
 	}
+	if (info->check_set & ~XT_RECENT_VALID_FLAGS) {
+		pr_info(KBUILD_MODNAME ": Unsupported user space flags "
+			"(%08x)\n", info->check_set);
+		return false;
+	}
 	if (hweight8(info->check_set &
 		     (XT_RECENT_SET | XT_RECENT_REMOVE |
 		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
-- 
1.7.0


--------------070800070107090209020106--
