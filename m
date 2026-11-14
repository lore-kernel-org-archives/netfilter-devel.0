Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626625;
	b=1JIv6sdJV0TS3t+8wm7vXGAF/MeVyF12Vp9GYiJltA4YHJX8B2hVO6I/TQbnBLfK0daA
	 h7faxjypf61BWmUL970VXzzQZcUx9ABwb2BHZaR82JNdJpJEKHDOqxmr21f/YLDDNi2Bk
	 syXKjE5jz+dnqq//fP9Qu/+qE2asLyb6aLo04wmjgSWSHkvee9wAdZI5IgFKAoMI49WeR
	 2U9tG2wU/EffqXGXCMol/eYMx+dk9mAdbbh2K/JjWfsfFQqZklfQOn1ex6CfOh8K4mQn3
	 y1v5reUc5vGujfJtkiBPb4QrEPPyCWv6wGwDsHmsSB4rBKoS4auOAKhz0rxT6aSV7ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626625;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=l/QG+WRhBMZZQ6SOoNj08ao6Y6x1dsfiuoE/yjkwvZY=;
	b=C2nEWaw5Fg9sAOLxsZQRVl2+NKLHSiZKlnGaWHSJyKsFH82O3LwlCV98WeXpwLzOdnqm
	 w+dl04ZzhnEhl+XguehnpKK/6pNO/p2GZhC+gEGSF0klPV9f8fzOgY4sa1Qwy6oaW2dxv
	 YW2O8Vhc9fqpZO5X3Jh4GFpp+PLxkelVs+u6s3FsjIqtkRl+m/TQWdUCYAYcfxDRvoHg6
	 kGDtvjsjCV1TczeQb+T/eHTqkSjIjBcQUtx+C/pbUT0QW9BQLJGVBjJTJQMomh5AePN1W
	 nbPlPerkOMj+02RWIADzjjKyHT3rVkd9fmv4ewTO4wc0x3LT154+HgxAT3XofchR4xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5vUKbTa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92CF606A8A9;
	Sat, 14 Nov 2026 03:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5vUKbTa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADA71F000C4;
	Sat, 14 Nov 2026 03:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626625;
	bh=l/QG+WRhBMZZQ6SOoNj08ao6Y6x1dsfiuoE/yjkwvZY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=M5vUKbTaU5Zz2/sNP7eoYkl7paspBa6JPgw4tlmOFs1KFkwGCi9OXt4FiNfDymXqx
	 pVEmHEmpH4Obz2Naljrk8rqwbmmsPALUUR33YoOcjxPsbImj3FVRxjHzzX2UqW+rFs
	 LLGPGct/RRekswuf4wzbDSdCOcEM3A9ap7vK7PM2TvPUe5SXi/sAhHdyCxaiD+UnLn
	 ocP1V9zdMpRbL3APt3Ebam4XI3EYasRD7r8UPNKhYiESqGvUmRIHglDb0wx4ZglwTh
	 QajwLGHsszqLOSktvVoheNPzVDUtAyCED0xDBvwUhqYP/1Sds2TA0nrfyt23QJLm+1
	 CoOLKAm3mJioA==
Subject: Re: [PATCH net-next 06/15] netfilter: xt_time: fix monthday
 computation for dates past 2039
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 03:23:44 +0000
Message-ID: <179462662444.2199510.8463648532411328010@kernel.org>
In-Reply-To: <20261113031251.2437074-7-pablo@netfilter.org>
References: <20261113031251.2437074-7-pablo@netfilter.org>
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

- [Low] The commit "netfilter: xt_time: fix monthday computation for
  dates past 2039" fixes a long-standing bug but has no `Fixes:` tag and…
- [Low] Two comments in net/netfilter/xt_time.c no longer match the code
  after this patch.

--

netfilter: xt_time: fix monthday computation for dates past 2039

This replaces the days_since_epoch[] table walk in localtime_3() with
time64_to_tm(). With the change, r->monthday stays in the 1-31 range for
dates from 2040-01-01 on. Removing the lookup tables also shrinks the
xt_time object.

> netfilter: xt_time: fix monthday computation for dates past 2039
>
> iocaltime_3() derives the year from days_since_epoch[], which only has
> entries up to 2039. For any date from 2040-01-01 on, the lookup stays on
> the 2039 entry, so the day-of-year offset is 365 or more. That value is
> used to compute r->monthday, which ends up larger than 31 (32 on
> 2040-01-01, and it wraps in the u8 later in the year).

[ ... ]

> Only the real-time clock reaches localtime_3(), so this is not
> triggerable before the clock passes 2040-01-01 UTC.

[Severity: Low]
This isn't a bug, but there's a typo in the first paragraph:
iocaltime_3() should be localtime_3().

Should the first paragraph also say what the out-of-range value leads to?
time_mt() uses it as a shift count:

    if (!(info->monthdays_match & (1U << current_time.monthday)))
        return false;

On 2040-01-01 monthday is 32. Later in 2040 it wraps in the u8 (for
example, 397 becomes 141). A shift of 32 or more is undefined behaviour,
so UBSAN would report shift-out-of-bounds. Monthday rules would then
match or miss arbitrary days.

Is the "not triggerable before ... 2040-01-01 UTC" statement accurate?
A CAP_SYS_TIME holder can set CLOCK_REALTIME past 2040 today with
settimeofday() or clock_settime(). A bad RTC or NTP source can do the
same.

There is also the XT_TIME_LOCAL_TZ adjustment in time_mt():

    if (info->flags & XT_TIME_LOCAL_TZ)
        /* Adjust for local timezone */
        stamp -= 60 * sys_tz.tz_minuteswest;

kernel/time/time.c limits tz_minuteswest to +/-15*60. East of UTC, the
local stamp can therefore reach 2040 up to 15 hours before UTC does.

The patch also has no Fixes: tag. days_since_epoch[], the
DSE_FIRST = 2039 year walk and the monthday computation all come from
ee4411a1b1e0. Should this carry:

Fixes: ee4411a1b1e0 ("[NETFILTER]: x_tables: add xt_time match")
Cc: stable@vger.kernel.org

That would let stable and long-term kernels that will still run in 2040,
such as CIP SLTS, pick up the fix. Other fixes in the same netfilter
batch carry Fixes: tags, for example "netfilter: flowtable: do not clear
the offload bit twice" and "netfilter: nfnetlink_queue: make skb
writable before writing NFQA_L2HDR".

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
> -	/*
> -	 * In each year, a certain number of days-since-the-epoch have passed.
> -	 * Find the year that is closest to said days.

[ ... ]

> +	time64_to_tm(time, 0, &tm);
>  
> -	r->month    = i + 1;
> +	r->monthday = tm.tm_mday;	/* 1-31 */
> +	r->month    = tm.tm_mon + 1;	/* 1-12 */
>  }

[Severity: Low]
The dietlibc-derived tables and table walk are gone now. Does the file
header comment still match the code?

 *	It is using some modified code from dietlibc (localtime() function)
 *	that you can find at https://www.fefe.de/dietlibc/

Date conversion now comes from time64_to_tm() in kernel/time/timeconv.c.

The comment in localtime_2() still says it handles monthday:

	/*
	 * Here comes the rest (weekday, monthday). First, divide the SSTE
	 * by seconds-per-day to get the number of _days_ since the epoch.
	 */

But localtime_2() only sets r->dse and r->weekday. That comment was
already inaccurate before this patch. Now localtime_3() doesn't read
r->dse at all, so the mismatch is larger.

Could both comments be updated to match the new code?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113031251.2437074-2-pablo%40netfilter.org
