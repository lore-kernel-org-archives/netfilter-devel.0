Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510656;
	b=p/WeF067V8Iq9arV/bsuTH2L2K4zpmS+6JVvjeLhoKGMAVpVzw4kZ66Prk+YrFJtgmXm
	 w9JBSVVJTlKe9Q82rvRE1EwUMki+9uaEkgQThjyqYX5Hi563Pznwy+i/1cgdtdADM3P3X
	 8tfULo+9K/OcyCsBo9NcqYhaqa6kL7aulNQf4s8PpDP4NUCbfyRqBM5Htr/PFiZv0kipm
	 /XsnHYpUQjihHvDmIQeZbqH7dH4mxdvEaTfilishz36dyvVGnz/m5CzsPvUTvh4Sd6ndx
	 76P8jRBz1nmPxm5Ta9j1VrWCB7LodESzSGOTTex3v21MfvY8ceWSiS84PGbCXc6uq4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510656;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=MgPaeVa1O4c8RDPooyHHn8cbv8AAqk3dwJMcQwrLG/c=;
	b=GkIprVwhM4ZC3MHHmzZ+kUcsKnWtWE4Gj9qVp2Lt4EFQlROMVgQIuDY/24FiRTR7GZY4
	 KN6DVy4daklL10RFt4XlhhkgMXWCvQzGw29+Pk7aeYP0D0t78RcCl95pKV14/wSDUjJJ3
	 YpRUIKcwOYEe6Wqe82XbotreZw8O9cJ2m+JFFFz9FT/MMcvMbrBxgfwsMb7AMe/K1uOb3
	 JhtfRhzq4xDwBqGqTnxbPbGvYXFcDCMzrVlL7mDkbINHUJt7aukYEq4F554FKo6XtqHWA
	 ffeVieCrWAgVqPHVk6icRlji/tGIxKQTBwd0B/rCx5rd08rojww0kwolyxqYkpT0CGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAAD60A381C;
	Tue, 20 Oct 2026 15:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE561F000C4;
	Tue, 20 Oct 2026 15:37:34 +0000 (UTC)
Subject: Re: [PATCH net 04/10] ipvs: skip committing sync_threshold when
 proc_dointvec fails
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:37:04 +0000
Message-ID: <179251062456.3135.7646122634609992432@kernel.org>
In-Reply-To: <20261019150249.1879516-5-pablo@netfilter.org>
References: <20261019150249.1879516-5-pablo@netfilter.org>
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

- [Low] The commit fixes a real bug that users can see, but its message
  has no Fixes: tag and no Cc: stable.

Pre-existing issues:
- [Low] Documentation/networking/ipvs-sysctl.rst (sync_threshold entry,
  around line 311) says "The range of the threshold is from 0 to…
- [Low] proc_do_sync_threshold() (net/netfilter/ipvs/ip_vs_ctl.c:2462)
  updates both elements of ipvs->sysctl_sync_threshold[] with a plain…

--

ipvs: skip committing sync_threshold when proc_dointvec fails

With this patch, proc_do_sync_threshold() returns early when
proc_dointvec() fails. A partly parsed write such as "5 x" now leaves
ipvs->sysctl_sync_threshold[] unchanged. Before, the handler updated
element [0] and still returned -EINVAL.

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 3003547dcabe..ce9fe20d6106 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2452,6 +2452,8 @@ proc_do_sync_threshold(const struct ctl_table *table, int write,
>  	mutex_lock(&ipvs->sync_mutex);
>  	memcpy(val, valp, sizeof(val));
>  	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
> +	if (rc)
> +		goto out;

[Severity: Low]
This fixes a bug that users can see. Should the commit message have a
Fixes: tag, and maybe Cc: stable?

Before this change, writing "5 x" or "5 99999999999" to
/proc/sys/net/ipv4/vs/sync_threshold took this path:

proc_do_sync_threshold()
  proc_dointvec()
    do_proc_vec()
      stores 5 into val[0], then fails on the second element
      returns -EINVAL

The old handler then checked the mixed pair (5, old val[1]). If that
pair was valid, it copied it into ipvs->sysctl_sync_threshold[] and
still returned -EINVAL.

The tmp-copy form of the handler comes from commit 1b90af292e71 ("ipvs:
Improve robustness to the ipvs sysctl"), which kept this partial update.
The older direct-write version behaved the same way.

Every other patch in this series has a Fixes: tag, so stable tooling may
not pick this one up. Would a tag like this one fit?

Fixes: 1b90af292e71 ("ipvs: Improve robustness to the ipvs sysctl")

>  	if (write) {
>  		if (val[0] < 0 || val[1] < 0 ||
>  		    (val[0] >= val[1] && val[1]))

[Severity: Low]
This isn't a bug introduced by this patch, but the entry for this sysctl
in Documentation/networking/ipvs-sysctl.rst says:

    The range of the threshold is from 0 to sync_period.

This check rejects val[0] >= val[1] whenever val[1] is non-zero. So the
upper bound is exclusive, and writing "50 50" fails with -EINVAL.

Could the documentation say that the threshold must be less than
sync_period when sync_period is non-zero? The paragraph after it already
covers the sync_period == 0 case.

> @@ -2459,6 +2461,7 @@ proc_do_sync_threshold(const struct ctl_table *table, int write,
>  		else
>  			memcpy(valp, val, sizeof(val));

[Severity: Low]
This is a pre-existing issue, but this memcpy() updates both elements of
ipvs->sysctl_sync_threshold[] while holding ipvs->sync_mutex, and the
packet-path readers never take that mutex:

include/net/ip_vs.h:
static inline int sysctl_sync_threshold(struct netns_ipvs *ipvs)
{
	return ipvs->sysctl_sync_threshold[0];
}

static inline int sysctl_sync_period(struct netns_ipvs *ipvs)
{
	return READ_ONCE(ipvs->sysctl_sync_threshold[1]);
}

net/netfilter/ipvs/ip_vs_sync.c:ip_vs_sync_conn_needed() {
    ...
	sync_period = sysctl_sync_period(ipvs);
	if (sync_period > 0) {
		if (!(cp->flags & IP_VS_CONN_F_TEMPLATE) &&
		    pkts % sync_period != sysctl_sync_threshold(ipvs))
			return 0;
    ...
}

Element [0] is read with a plain load, element [1] with READ_ONCE(), and
the two are loaded separately.

Can a concurrent sysctl write let ip_vs_sync_conn_needed() see the new
threshold with the old period, or the other way round? The
threshold < period rule would then not hold for that packet, and the
connection could miss one sync.

It can't crash, because sync_period is loaded once and checked before
the modulo. KCSAN would probably flag the unannotated plain load and
store of element [0], though.

Would it be worth using WRITE_ONCE() for each element here and
READ_ONCE() in sysctl_sync_threshold()?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
