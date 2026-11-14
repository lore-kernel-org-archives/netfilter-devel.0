Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622547;
	b=XkPuQXvWMnuNo1bQMM3li/mhNPrL6SvTxOb3EHROrOGNCOxB31xpno2w6/XRS4a5Divc
	 qATl3D2AlRKKViyQ4D82zFl7VtR6Uyf5eHij/yZwDKTvvsRbeUFM0TP/bemmYoGKVu414
	 r6xfbgoLQqiPIEXZuLZdW3LfqRs591duWbOFmf5slFiolZsn8Ly1ayO7GQyzFKV6KRsda
	 fjxd+dMBFRzLDpquWOd7MirVK2ad5qkywlmHO+1Ej8u9AY+MbHLbIHKO3mxgjvdZIz5P7
	 0ZEOIVaH6EvNrEpGMTnAi0zjSMp0R1KaRMPcjbCkTxy/2Xb+y8O4TK/zoPP5lFqgg2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622547;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=R3lG4u0ogjfoUA7tJOEU4hFiSgjPKq7/ykUDDTKGVFM=;
	b=b9b14qglFpFJMYuBD5hHCeMXwFeQ5VyzDixV4vcAcYQzJG72KsJq3S+4hbUUdJQGmgDS
	 4c0ieU94FM26+pPKGPlOerGG/ZPHPk/lTMAGL2GVtnAzw/DkYzgyVEQDvAYiwUGq72og9
	 lLQCXB9EHEoZYoN1Sd2c1gKijE+tW1FLATgR+Sihu9FskpPdsi16HUPNTBQgBDq93lvTt
	 EDpds0IXStsMfNLVf4UeU0MU+TnPaQRHvF7j7EMDilOzrRlBhtGYgErqD+4RcPgLczK/L
	 B76eRTK9qh0EopZMelSBqNxZjYQ4OUuPVlK5BC8xNUe+uaZ7BSmM1C+N1j89DjdiB2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OlUCd9Ed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF00606A329;
	Sat, 14 Nov 2026 02:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OlUCd9Ed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD1C1F000C6;
	Sat, 14 Nov 2026 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622546;
	bh=R3lG4u0ogjfoUA7tJOEU4hFiSgjPKq7/ykUDDTKGVFM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OlUCd9Ed6LLcuKQuAZJ1QHie5KfkLMXIb4tXdYIvM1ODR8CM+/12f0vBkai+HaN6M
	 LFgE9oh4SaevwAm3acsrWeQhnn2sh+nuFsnaMdVLE4/C2XtehDwCykjha3LPNr9tr+
	 JYyhXwzOcy0C1EZhYdUSsmeS8zsA/JllYjaAmFFgDO4/MYcJ3zbt0OCq2yaFD89l1V
	 RDl7vYjziumU9iLSknD2FVgSXetRFurHwemX4itiWi6xJevOnHf0kUH4loYkRwb1IA
	 uW5CFu/9oOIN2/RU4alc5CoPwMuUkEtTj05TkgpoSVHuT1FXFjv3rKUnMKiHkjoqSN
	 2+2Dr0f20sw+Q==
Subject: Re: [PATCH net 10/15] ipvs: honor the overload state and do not enter
 it forever
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:45 +0000
Message-ID: <179462254584.2199510.7662022580962263385@kernel.org>
In-Reply-To: <20261113011447.2357709-11-pablo@netfilter.org>
References: <20261113011447.2357709-11-pablo@netfilter.org>
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

- [Low] The commit message's reason for moving ip_vs_dest_set_min() after
  the set_max/erase cleanup in ip_vs_lblcr_schedule()…

--

ipvs: honor the overload state and do not enter it forever

This commit adds an smp_mb() and a re-read of totalconns in
__ip_vs_dest_update_overload(), so a dest cannot stay in the overload
state forever when it races with ip_vs_unbind_dest(). It also drops the
overload parameter from ip_vs_dest_update_overload() and makes LBLC and
LBLCR honor the overload state for cached dests. In LBLCR it moves the
ip_vs_dest_set_min() call to after the set_max/erase cleanup.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org

> diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
> index dfb5bf83750db..4046608922e7c 100644
> --- a/net/netfilter/ipvs/ip_vs_lblcr.c
> +++ b/net/netfilter/ipvs/ip_vs_lblcr.c

[ ... ]

> @@ -658,9 +659,6 @@ ip_vs_lblcr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
>  	if (en) {
>  		en->lastuse = jiffies;
>  
> -		/* Get the least loaded destination */
> -		dest = ip_vs_dest_set_min(&en->set);
> -
>  		/* More than one destination + enough time passed by, cleanup */
>  		if (atomic_read(&en->set.size) > 1 &&
>  		    time_after(jiffies, en->set.lastmod +
> @@ -676,6 +674,9 @@ ip_vs_lblcr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
>  			spin_unlock_bh(&svc->sched_lock);
>  		}
>  
> +		/* Get the least loaded destination */
> +		dest = ip_vs_dest_set_min(&en->set);
> +
>  		/* If the destination is not overloaded, use it */
>  		if (dest && !is_overloaded(dest, svc))
>  			goto out;

[Severity: Low]
This isn't a bug, and the code change looks right. The commit message
explains the move this way:

  "Also, move the ip_vs_dest_set_min() call in LBLCR after the
  ip_vs_dest_set_erase() call that removes the most-loaded
  server because due to races we may work with dest that is
  in process of removing, i.e. ip_vs_dest_set_min() and
  ip_vs_dest_set_max() may return same dest."

Can the two helpers also return the same dest without any race?

ip_vs_dest_set_min() only replaces its candidate when another member is
strictly less loaded:

    if (((__s64)loh * atomic_read(&dest->weight) >
         (__s64)doh * atomic_read(&least->weight)) &&
        (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {

ip_vs_dest_set_max() only replaces its candidate when another member is
strictly more loaded:

    if (((__s64)moh * atomic_read(&dest->weight) <
         (__s64)doh * atomic_read(&most->weight))
        && (atomic_read(&dest->weight) > 0)) {

Take two weight-1 members with the same ip_vs_dest_conn_overhead(), for
example both idle. Both helpers then return the first list element.

Before this patch, once the set had more than one member and was older
than sysctl_lblcr_expiration, the sequence was:

ip_vs_lblcr_schedule()
    ip_vs_dest_set_min()     -> first member (tie)
    ip_vs_dest_set_max()     -> same first member (tie)
    ip_vs_dest_set_erase()   -> removes it from en->set
    goto out                 -> returns the erased dest

So on load ties the old code returned the dest it had just removed from
the cache set, with no race involved.

Could the commit message say that this also happens on ties, not only
because of races?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
