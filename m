From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH v3] iptables: libxt_recent: Add support for --reap option
Date: Fri, 02 Dec 2011 11:46:07 -0700
Message-ID: <4ED91CEF.1080006@canonical.com>
References: <1322789373-30474-1-git-send-email-tim.gardner@canonical.com> <alpine.LNX.2.01.1112021628190.5296@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030708070703000004060408"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2695 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab1LBTjW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:39:22 -0500
In-Reply-To: <alpine.LNX.2.01.1112021628190.5296@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030708070703000004060408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/02/2011 08:30 AM, Jan Engelhardt wrote:
>
> On Friday 2011-12-02 02:29, Tim Gardner wrote:
>> @@ -34,6 +36,8 @@ static const struct xt_option_entry recent_opts[] = {
>> 	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
>> 	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
>> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
>> +	{.name = "reap", .id = O_REAP, .type = XTTYPE_NONE,
>> +	 .also = F_SECONDS },
>> 	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
>> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
>> 	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
>
>> +
>> +	if ((info->check_set&  XT_RECENT_REAP)&&  !info->seconds)
>> +		xtables_error(PARAMETER_PROBLEM,
>> +			"recent: you must specify `--seconds' with `--reap'");
>> }
>
> Well, I did mean that .also = F_SECONDS makes the extra
> "info->check_set&  XT_RECENT_REAP)&&  !info->seconds" test
> redundant. Or, the error message is wrong, because you are
> actually testing for seconds==0 rather than "reap was specified
> without seconds".
> Is seconds=0 even useful for non-reap cases?

Its not meaningful in that 0 is the default value in the kernel filter 
and implies no timeout.

> If not, we should probably consider using .min=1 on the --seconds
> parameter, in which case the test is also redundant.
>

Done. Tested with the following combinations and received the expected 
failures on the first 2:

iptables -A FORWARD -m recent --rcheck --seconds 0 -j DROP
iptables -A FORWARD -m recent --rcheck --reap -j DROP
iptables -A FORWARD -m recent --rcheck --seconds 10 --reap -j DROP

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------030708070703000004060408
Content-Type: text/x-patch;
 name="0001-libxt_recent-Add-support-for-reap-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-libxt_recent-Add-support-for-reap-option.patch"

>From 0957b0f655506852b8a612910d7d9a6176bc58b0 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 30 Nov 2011 08:16:53 -0700
Subject: [PATCH v3] libxt_recent: Add support for --reap option

Support for the reap option was merged in the kernel as of 2.6.35.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 extensions/libxt_recent.c   |   17 ++++++++++++++++-
 extensions/libxt_recent.man |    5 +++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 1e1a111..46b8fe9 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -10,6 +10,7 @@ enum {
 	O_UPDATE,
 	O_REMOVE,
 	O_SECONDS,
+	O_REAP,
 	O_HITCOUNT,
 	O_RTTL,
 	O_NAME,
@@ -19,6 +20,7 @@ enum {
 	F_RCHECK = 1 << O_RCHECK,
 	F_UPDATE = 1 << O_UPDATE,
 	F_REMOVE = 1 << O_REMOVE,
+	F_SECONDS = 1 << O_SECONDS,
 	F_ANY_OP = F_SET | F_RCHECK | F_UPDATE | F_REMOVE,
 };
 
@@ -33,7 +35,9 @@ static const struct xt_option_entry recent_opts[] = {
 	{.name = "remove", .id = O_REMOVE, .type = XTTYPE_NONE,
 	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
 	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds), .min = 1},
+	{.name = "reap", .id = O_REAP, .type = XTTYPE_NONE,
+	 .also = F_SECONDS },
 	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
 	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
@@ -57,6 +61,8 @@ static void recent_help(void)
 "    --seconds seconds           For check and update commands above.\n"
 "                                Specifies that the match will only occur if source address last seen within\n"
 "                                the last 'seconds' seconds.\n"
+"    --reap                      Purge entries older then 'seconds'.\n"
+"                                Can only be used in conjunction with the seconds option.\n"
 "    --hitcount hits             For check and update commands above.\n"
 "                                Specifies that the match will only occur if source address seen hits times.\n"
 "                                May be used in conjunction with the seconds option.\n"
@@ -117,11 +123,16 @@ static void recent_parse(struct xt_option_call *cb)
 	case O_RDEST:
 		info->side = XT_RECENT_DEST;
 		break;
+	case O_REAP:
+		info->check_set |= XT_RECENT_REAP;
+		break;
 	}
 }
 
 static void recent_check(struct xt_fcheck_call *cb)
 {
+	struct xt_recent_mtinfo *info = cb->data;
+
 	if (!(cb->xflags & F_ANY_OP))
 		xtables_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
@@ -146,6 +157,8 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" REMOVE");
 	if(info->seconds) printf(" seconds: %d", info->seconds);
+	if(info->check_set & XT_RECENT_REAP)
+		printf(" reap");
 	if(info->hit_count) printf(" hit_count: %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" TTL-Match");
@@ -172,6 +185,8 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 	if (info->check_set & XT_RECENT_REMOVE)
 		printf(" --remove");
 	if(info->seconds) printf(" --seconds %d", info->seconds);
+	if(info->check_set & XT_RECENT_REAP)
+		printf(" --reap");
 	if(info->hit_count) printf(" --hitcount %d", info->hit_count);
 	if (info->check_set & XT_RECENT_TTL)
 		printf(" --rttl");
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 0392c2c..8043df4 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -41,6 +41,11 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
+\fB\-\-reap\fP
+This option can only be used in conjunction with \fB\-\-seconds\fP.
+When used, this will cause entries older than the last given number of seconds
+to be purged.
+.TP
 \fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
-- 
1.7.0.4


--------------030708070703000004060408--
