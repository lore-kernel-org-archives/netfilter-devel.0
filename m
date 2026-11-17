Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874969;
	b=5YLiODoeUnyGhAWqc6+84H1I2q+oiQxLWIg21uVtiay3NuJNn2qSbp3MgS141B64fdeI
	 81q4BTcJ5L1n6ygTo7gpqM0YGW3NWSOfuxxqEr2SvOi/SQKHk9di2sIll7+0mIRoZTBre
	 +cXgXwz2B8VZ9IuS5GX27vi05kN3f1cpaqOgVC01xAKXS35H8+c5yF9aTgpF3HmfvzUXs
	 rKyBDq418hQRSK8VVawb7PyuxsrEV8iXZRwOoqz8ff0v+a2QDyGuPx3JJXCFyF6qUkDxU
	 uTMpTM2Zphz5cRh0W/p/ctPls/9clZ97nqfqFrUCN0lRLf6NQtskQ8hglkG/i9wK5pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874969;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vmRR9pCJ/Q25C5FM/CDfQ6SI3FAF+xqbBv++EEr+IWE=;
	b=R/olmVg6f/R/njnim+zjsBQBOHjQd/STYAorxFj5UG29f+EH3O2MXcsGOXByRM2YHXk0
	 WGRaQsdgHfpDTIzQBJkttzD5NvrLe7FLfjCh+3nDKeUNlNd2uWpJo/ulCyVA/K2QEgOnW
	 pC7Qgz+rVQ0pA7hxYAYYR0jTdQVLIctbLCHixcLPJ4sqgEyqg/Ktf6vXhC79xIl/e5xyd
	 lMkPkZ8//TNTB2VUmpE53MVe/R5JLQ4uYFrZ+f73xoqmspwRbuXuz/a0zOx/NqqiTvLLe
	 5KtJjw1jQaZZRWwe126nu2xl4yMkXBtddJkFCeJxuTiCMWmZRcxwqAL5Nz60p+dtPDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqDQKVNq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20D9606A33A;
	Tue, 17 Nov 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqDQKVNq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6231F000C8;
	Tue, 17 Nov 2026 00:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794874969;
	bh=vmRR9pCJ/Q25C5FM/CDfQ6SI3FAF+xqbBv++EEr+IWE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iqDQKVNq/zZNeT6IpOsl0PaZP9fKrFrMhzoNIdMYHVjcJexJqRSIeACtrYKnRRyWM
	 PJGnts5zVBCmK1LKnTViIYzv5zp934rj2x8chmq4mHtD/TMHiKZ7wHXlP2nMiOEU3V
	 6AGkGoxaDfOnyOYF3LedOba0nkrUrd5xUex0hB57efqvE7rRwHDyuzCvoVHoqNPjwI
	 YeSIAWh/ksWOUr1Q9eCggelkBMNBzFyd9EYwvIIEmvXRAWt1rNXukB/Ozw1QgxdWSB
	 VKB8P2oWJL19w7LftiGeZeSTyXtQ6BmkvXVi/XqNiStoZyEnPjkRUrOcfafzUCc9BZ
	 QGPd/+G6BD15g==
Subject: Re: [PATCH net-next 05/13] netfilter: xt_time: fix monthday
 computation for dates past 2039
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 17 Nov 2026 00:22:48 +0000
Message-ID: <179487496872.3136.7616374385796675511@kernel.org>
In-Reply-To: <20261116001612.2806263-6-pablo@netfilter.org>
References: <20261116001612.2806263-6-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch fixes a real, user-visible correctness bug: `-m time
  --monthdays` rules give wrong results once the clock reaches…
- [Low] The commit message has three inaccuracies, and it understates the
  impact.
- [Low] After the patch, some comments and state in
  net/netfilter/xt_time.c still describe the removed table-based date…

--

netfilter: xt_time: fix monthday computation for dates past 2039

This patch replaces the days_since_epoch[] table walk in localtime_3()
with time64_to_tm(). This keeps r->monthday and r->month in range for
dates from 2040-01-01 on. The lookup tables and the 2039 limit are
removed, which also shrinks the xt_time object.

> iocaltime_3() derives the year from days_since_epoch[], which only has
> entries up to 2039. For any date from 2040-01-01 on, the lookup stays on
> the 2039 entry, so the day-of-year offset is 365 or more. That value is
> used to compute r->monthday, which ends up larger than 31 (32 on
> 2040-01-01, and it wraps in the u8 later in the year).

[ ... ]

> Only the real-time clock reaches localtime_3(), so this is not
> triggerable before the clock passes 2040-01-01 UTC.

[Severity: Low]
This isn't a bug, but there's a typo: iocaltime_3() should be
localtime_3().

Is the "2040-01-01 UTC" part accurate when XT_TIME_LOCAL_TZ is set?
time_mt() adjusts the stamp before it calls localtime_3():

    if (info->flags & XT_TIME_LOCAL_TZ)
        /* Adjust for local timezone */
        stamp -= 60 * sys_tz.tz_minuteswest;

For timezones east of UTC, tz_minuteswest is negative, so stamp moves
forward. do_sys_settimeofday64() accepts tz_minuteswest down to -15*60.
That means the old code could produce a bad monthday up to 15 hours
before 2040-01-01 UTC.

Could the message also say what the out-of-range monthday leads to?
time_mt() uses it as a shift count:

    if (!(info->monthdays_match & (1U << current_time.monthday)))

With the old code, a monthday of 32 or more makes this shift undefined
behaviour, and the rule silently fails to match. Once the u8 wraps back
into 1-31 later in 2040, rules match on the wrong days.

> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[Severity: Low]
Should this have a Fixes: tag? The days_since_epoch[] table and
DSE_FIRST = 2039 came in with the original match:

Fixes: ee4411a1b1e0 ("[NETFILTER]: x_tables: add xt_time match")

Without the tag, stable backporters could read this as only the size
cleanup suggested by the bloat-o-meter numbers.

> diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
> index 2065fce8ef81b..f0c4c1d1bc4a0 100644
> --- a/net/netfilter/xt_time.c
> +++ b/net/netfilter/xt_time.c

[ ... ]

> @@ -102,51 +71,12 @@ static inline void localtime_2(struct xtm *r, time64_t time)
>
>  static void localtime_3(struct xtm *r, time64_t time)
>  {
> -	unsigned int year, i, w = r->dse;
> -

[ ... ]

> +	time64_to_tm(time, 0, &tm);
>
> -	r->month    = i + 1;
> +	r->monthday = tm.tm_mday;	/* 1-31 */
> +	r->month    = tm.tm_mon + 1;	/* 1-12 */
>  }

[Severity: Low]
This isn't a bug, but localtime_3() now works only from time and no
longer reads r->dse. Are some comments and struct xtm now out of date?

The file header still credits dietlibc:

 *	It is using some modified code from dietlibc (localtime() function)
 *	that you can find at https://www.fefe.de/dietlibc/

The table walk removed here was the last of that code.

The comment in localtime_2() still says it computes monthday:

	/*
	 * Here comes the rest (weekday, monthday). First, divide the SSTE
	 * by seconds-per-day to get the number of _days_ since the epoch.
	 */

It now computes only dse and weekday.

struct xtm also keeps this field:

	unsigned int dse;

It used to carry days-since-epoch from localtime_2() to localtime_3().
Now it is only read inside localtime_2(). Could this lead readers to
think localtime_3() depends on localtime_2() running first?

There is also a small side effect. Weekday comes from the unsigned
div_u64() in localtime_2(). Monthday comes from the signed,
floor-corrected division in time64_to_tm(). The two only differ for a
negative stamp. That needs a time within the first day of 1970, plus
either the XT_TIME_CONTIGUOUS one-day subtraction or a timezone west of
UTC.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116001612.2806263-2-pablo%40netfilter.org
