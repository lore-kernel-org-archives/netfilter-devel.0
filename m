Return-Path: <SRS0=dbJk=VL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35247C73C66
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F712063F
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfGNXUB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jul 2019 19:20:01 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46910 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728754AbfGNXUA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jul 2019 19:20:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmnmg-000174-Bp; Mon, 15 Jul 2019 01:19:58 +0200
Date:   Mon, 15 Jul 2019 01:19:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190714231958.wtyiusnqpazmwbgl@breakpoint.cc>
References: <20190707205531.6628-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707205531.6628-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> an hour in the day (which is converted to the number of seconds since midnight) and a day of week.

[ Pablo, please see below for a usability question ]

This patch causes following compiler warnings for me:
meta.c: In function 'hour_type_print':
meta.c:582:26: warning: '%02d' directive output may be truncated writing between 2 and 10 bytes into a region of size 9 [-Wformat-truncation=]
   snprintf(out, buflen, "%02d:%02d:%02d", hours, minutes, seconds);
                          ^~~~
meta.c:582:25: note: directive argument in the range [0, 2147483647]
   snprintf(out, buflen, "%02d:%02d:%02d", hours, minutes, seconds);
                         ^~~~~~~~~~~~~~~~
meta.c:582:25: note: directive argument in the range [0, 60]
In file included from /usr/include/stdio.h:867, from meta.c:17:
/usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk' output between 9 and 26 bytes into a destination of size 9
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
meta.c:580:26: warning: '%02d' directive output may be truncated writing between 2 and 10 bytes into a region of size 9 [-Wformat-truncation=]
   snprintf(out, buflen, "%02d:%02d", hours, minutes);
meta.c:580:25: note: directive argument in the range [0, 2147483647] snprintf(out, buflen, "%02d:%02d", hours, minutes);
                         ^~~~~~~~~~~
meta.c:580:25: note: directive argument in the range [0, 60] In file included from /usr/include/stdio.h:867, from meta.c:17:
/usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk' output between 6 and 14 bytes into a destination of size 9
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
There is no bug here, compiler doesn't know that those intergers only contains numbers
in the two digit range.

I suggest to "fix" this by increasing out[] to 32 bytes.

> diff --git a/src/meta.c b/src/meta.c
> index 1e8964e..00ff267 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -37,6 +37,10 @@
>  #include <iface.h>
>  #include <json.h>
>  
> +#define _XOPEN_SOURCE
> +#define __USE_XOPEN
> +#include <time.h>
> +
>  static struct symbol_table *realm_tbl;
>  void realm_table_meta_init(void)
>  {
> @@ -383,6 +387,313 @@ const struct datatype ifname_type = {
>  	.basetype	= &string_type,
>  };
>  
> +static void date_type_print(const struct expr *expr, struct output_ctx *octx)
> +{
> +	char timestr[21];
> +	struct tm *tm, *cur_tm;
> +	uint64_t tstamp = mpz_get_uint64(expr->value);

I would suggest to always order in reverse xmas tree, i.e.

> +	uint64_t tstamp = mpz_get_uint64(expr->value);
> +	struct tm *tm, *cur_tm;
> +	char timestr[21];

just to get used to this.  The networking maintainer (David Miller) prefers
it this way for kernel patches (yes, this is an nftables patch but getting
used to this ordering is a good idea.

> +	/* Convert from nanoseconds to seconds */
> +	tstamp /= 1000000000L;

[..]

This looks good to me, but there are three usability issues.

The worst one first:

nft add rule filter input hour 23:15-00:22 counter

This works. But this fails:
nft add rule filter input hour 23:15-03:22  counter
Error: Range has zero or negative size

Because values are converted to UTC, the first one will be a range from
21:15 to 22:22 UTC, so left < right. Second one is not.

The obvious workaround:

meta hour < "04:22" will NOT match at 00:28 (GMT+2), as its still 22:28 in
the UTC time zone.

It will match once local time is past 0 hours UTC.

I suggest to try to fix this from the evaluation step, by
swapping left and right and inverting the match.

So 76500-8520 (left larger right) turns into "!= 8520-76500",
which appears to do the right thing.

shape and I have no idea how to fix this without using/relying on kernel time zone.

Even when relying on kernel time zone for everything, I don't see
how we can support cross-day ("22:23-00:42") matching, as the range is
invalid.

Second problem:
For same reason, "Weekday" matching is broken.
If its Monday (00:31), rule that asks for monday won't match, because
day is relative to UTC, and since its 22:31 UTC, its still Sunday.

This is unusable when in a time zone much further away.

Only solution I see is to change kernel patch to rely on
sys_tz, just like xt_time, with all the pain this brings.

Third problem, but NOT directly related to this patch, its due to
existing range expression forcing numeric output:

All time based ranges get printed like this:
meta hour 72600-72720
meta time 1563142680000000000-1563143400000000000

I think we should relax range printing and only force numeric for
the new time/hour/day when user did specify the --seconds option.

Ander, you can fix this by finding out where the range print
function gets called and by only propagating NFT_CTX_OUTPUT_NUMERIC_TIME
when user asked for it instead of doing so unconditionally.

Currently we always force numeric because something like
"ssh-http" or "daemon-ftpd" looks very silly, but in case of hours and
days I don't think it makes sense to do the raw-printing by default.

> +static struct error_record *hour_type_parse(const struct expr *sym,
> +					    struct expr **res)
> +{
> +	time_t ts;
> +	char *endptr;
> +	struct tm tm, *cur_tm;
> +	uint64_t result = 0;
> +	struct error_record *er;
> +
> +	memset(&tm, 0, sizeof(struct tm));
> +
> +	/* First, try to parse it as a number */
> +	result = strtoul(sym->identifier, (char **) &endptr, 10);
> +	if (*endptr == '\0' && endptr != sym->identifier)
> +		goto success;
> +
> +	result = 0;
> +
> +	/* Obtain current tm, so that we can substract tm_gmtoff */
> +	ts = time(NULL);
> +	cur_tm = localtime(&ts);
> +
> +	if (strptime(sym->identifier, "%T", &tm))
> +		goto convert;
> +	if (strptime(sym->identifier, "%R", &tm))
> +		goto convert;
> +
> +	if ((er = time_parse(&sym->location, sym->identifier, &result)) == NULL) {
> +		result /= 1000;
> +		goto convert;
> +	}

Seems this function accepts 'meta hour "04:22-23:15"'.   This should cause
an error instead of letting user wonder why things don't work as expected:

This passes the string "04:22-23:15" as "04:22".

So this should fail, as this contains invalid '-' character, respectively
has too many ":".

> +	[NFT_META_TIME_HOUR]	= META_TEMPLATE("hour", &hour_type,
> +						8 * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),

Why does hour need 64bits of register space?  I think u32 is enough?

>  static bool meta_key_is_unqualified(enum nft_meta_keys key)
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 670e91f..26b64da 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -415,6 +415,7 @@ int nft_lex(void *, void *, void *);
>  %token IIFGROUP			"iifgroup"
>  %token OIFGROUP			"oifgroup"
>  %token CGROUP			"cgroup"
> +%token TIME			"time"
>  
>  %token CLASSID			"classid"
>  %token NEXTHOP			"nexthop"
> @@ -3886,6 +3887,9 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
>  			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
>  			|       CGROUP		{ $$ = NFT_META_CGROUP; }
>  			|       IPSEC		{ $$ = NFT_META_SECPATH; }
> +			|       TIME		{ $$ = NFT_META_TIME; }
> +			|       DAY		{ $$ = NFT_META_TIME_DAY; }
> +			|       HOUR		{ $$ = NFT_META_TIME_HOUR; }
>  			;
>  
>  meta_stmt		:	META	meta_key	SET	stmt_expr
> diff --git a/src/scanner.l b/src/scanner.l
> index d1f6e87..bd28141 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -411,7 +411,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "sack2"			{ return SACK2; }
>  "sack3"			{ return SACK3; }
>  "sack-permitted"	{ return SACK_PERMITTED; }
> -"timestamp"		{ return TIMESTAMP; }

Won't that break the tcp timestamp option?  I think this token needs
to stay where it is.

> +"time"			{ return TIME; }
> +"day"			{ return DAY; }
> +"hour"			{ return HOUR; }

Causes:
src/scanner.l:424: warning, rule cannot be matched
src/scanner.l:425: warning, rule cannot be matched

as DAY and HOUR rules are duplicates, just remove them.
 
> diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
> index 322c087..c9bc09f 100644
> --- a/tests/py/ip/meta.t.payload
> +++ b/tests/py/ip/meta.t.payload
> @@ -1,3 +1,87 @@
> +# meta time "1970-05-23 21:07:14" drop
> +ip meta-test input
> +  [ meta load unknown => reg 1 ]

This "unknown" is coming from libnftnl.
You need to fix up meta_key2str_array[] in src/expr/meta.c in libnftnl.

This should say "time", "time_day" or similar.
Also, shouldn't this come in patch #2 when those tests get added?

Alternatively, you can squash your three patches into one, it would
 be fine I think.
