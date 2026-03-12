Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2631FBC8E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773317750; cv=none; b=DlckEBIwshurQn5xZyZi7S8GVJQZxHXdbz6B8lxk+NLHlOjSgsWJ28wUBXV0STEEBXDBUn049CI8JC/kZvyd6DRwgSXdhQCdzZ9a6b0lm2VAMlVH/0ufxjEv63RwK1NAz0Fxnwz5fA3lwAoBBRrPbD1FqvocOTuqLDwzcTcBlRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773317750; c=relaxed/simple;
	bh=BbA6w1sO0M8Zi5awc/vRTfCk1+66v1vzIB5zIcGRQfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GUVZepzq14Lf1hqjJXo+npqQ6T0Sv1qgDfo96a6to4x4VWShtwJFyVFiqXFeFPGZLi03wWA9Kf/p16Od+366g6IqK/9yBPd9IyKA0JBM/Kofwj6Xw+x5T8czKsHixo3QjBljRbD2JT6+HirMmGCc25RR5sZqbSzw6FCTqn9xHHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yzJzh7NC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q8WeyAOw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yzJzh7NC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q8WeyAOw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yzJzh7NC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q8WeyAOw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yzJzh7NC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q8WeyAOw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5368E3FDA2;
	Thu, 12 Mar 2026 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773317744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iyvo3MyG5/nMqbH5LhEzLuKSDNYzWDBrh0u3whLrNLA=;
	b=yzJzh7NC4i5SJvPNXFzKkSl7390EhDxaokQVdiTFkKZQZztGzHLGWoywfNgBL+T/F4I6KJ
	jC4RdCzkEAn962ftMc/JVH0dlbnUYVn9BjhLyal/6PqxadJTScYA/rtiy8VpT1kXfbjsjD
	DP8kQWUpckzWk09y1IQxKVU2UWPxATo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773317744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iyvo3MyG5/nMqbH5LhEzLuKSDNYzWDBrh0u3whLrNLA=;
	b=Q8WeyAOwVI5ca5hPLyVr07B6H3mK/Lk3F//qLSQaPceZxWRb48X/pgHFsouWy3SX/14Y9M
	u/fC3gp5aWnbROAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yzJzh7NC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q8WeyAOw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773317744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iyvo3MyG5/nMqbH5LhEzLuKSDNYzWDBrh0u3whLrNLA=;
	b=yzJzh7NC4i5SJvPNXFzKkSl7390EhDxaokQVdiTFkKZQZztGzHLGWoywfNgBL+T/F4I6KJ
	jC4RdCzkEAn962ftMc/JVH0dlbnUYVn9BjhLyal/6PqxadJTScYA/rtiy8VpT1kXfbjsjD
	DP8kQWUpckzWk09y1IQxKVU2UWPxATo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773317744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iyvo3MyG5/nMqbH5LhEzLuKSDNYzWDBrh0u3whLrNLA=;
	b=Q8WeyAOwVI5ca5hPLyVr07B6H3mK/Lk3F//qLSQaPceZxWRb48X/pgHFsouWy3SX/14Y9M
	u/fC3gp5aWnbROAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E5993FF70;
	Thu, 12 Mar 2026 12:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngDOE26usmmLZgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 12 Mar 2026 12:15:42 +0000
Message-ID: <09e1535f-59fe-41eb-91ed-2aeb97957bfc@suse.de>
Date: Thu, 12 Mar 2026 13:15:41 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
To: Prasanna S Panchamukhi <panchamukhi@arista.com>,
 netfilter-devel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 coreteam@netfilter.org
References: <20260311194058.13860-1-panchamukhi@arista.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260311194058.13860-1-panchamukhi@arista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,arista.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5368E3FDA2

On 3/11/26 8:40 PM, Prasanna S Panchamukhi wrote:
> The conntrack garbage collection worker uses an adaptive algorithm that
> adjusts the scan interval based on the average timeout of tracked
> entries.  The upper bound of this interval is hardcoded as
> GC_SCAN_INTERVAL_MAX (60 seconds).
> 
> Expose the upper bound as a new sysctl,
> net.netfilter.nf_conntrack_gc_scan_interval_max, so it can be tuned at
> runtime without rebuilding the kernel.  The default remains 60 seconds
> to preserve existing behavior.  The sysctl is global and read-only in
> non-init network namespaces, consistent with nf_conntrack_max and
> nf_conntrack_buckets.
> 
> In environments where long-lived offloaded flows dominate the table,
> the adaptive average drifts toward the maximum, delaying cleanup
> of short-lived expired entries such as those in TCP CLOSE state
> (10s timeout). Adding sysctl to set the maximum GC scan helps to
> tune according to the evironment.
> 
> Signed-off-by: Prasanna S Panchamukhi <panchamukhi@arista.com>
[...]
> ---
>   Documentation/networking/nf_conntrack-sysctl.rst | 11 +++++++++++
>   include/net/netfilter/nf_conntrack.h             |  1 +
>   net/netfilter/nf_conntrack_core.c                |  9 ++++++---
>   net/netfilter/nf_conntrack_standalone.c          | 10 ++++++++++
>   4 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 35f889259fcd..c848eef9bc4f 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -64,6 +64,17 @@ nf_conntrack_frag6_timeout - INTEGER (seconds)
>   
>   	Time to keep an IPv6 fragment in memory.
>   
> +nf_conntrack_gc_scan_interval_max - INTEGER (seconds)
> +	default 60
> +
> +	Maximum interval between garbage collection scans of the connection
> +	tracking table. The GC worker uses an adaptive algorithm that adjusts
> +	the scan interval based on average entry timeouts; this parameter caps
> +	the upper bound. Lower values cause expired entries (e.g. connections
> +	in CLOSE state) to be cleaned up faster, at the cost of slightly more
> +	CPU usage. Minimum value is 1.
> +	This sysctl is only writeable in the initial net namespace.
> +

I think it would be a good idea to add under which situations it is good 
to tweak this setting.

>   nf_conntrack_generic_timeout - INTEGER (seconds)
>   	default 600
>   
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index bc42dd0e10e6..0449577f322e 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -331,6 +331,7 @@ extern struct hlist_nulls_head *nf_conntrack_hash;
>   extern unsigned int nf_conntrack_htable_size;
>   extern seqcount_spinlock_t nf_conntrack_generation;
>   extern unsigned int nf_conntrack_max;
> +extern unsigned int nf_conntrack_gc_scan_interval_max;
>

Could it be just int? so there is no need to cast it to s32 later?

>   /* must be called with rcu read lock held */
>   static inline void
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 27ce5fda8993..54949246f329 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -91,7 +91,7 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
>    * allowing non-idle machines to wakeup more often when needed.
>    */
>   #define GC_SCAN_INITIAL_COUNT	100
> -#define GC_SCAN_INTERVAL_INIT	GC_SCAN_INTERVAL_MAX
> +#define GC_SCAN_INTERVAL_INIT	nf_conntrack_gc_scan_interval_max
>   
>   #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
>   #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
> @@ -204,6 +204,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
>   
>   unsigned int nf_conntrack_max __read_mostly;
>   EXPORT_SYMBOL_GPL(nf_conntrack_max);
> +
> +unsigned int nf_conntrack_gc_scan_interval_max __read_mostly = GC_SCAN_INTERVAL_MAX;
> +
>   seqcount_spinlock_t nf_conntrack_generation __read_mostly;
>   static siphash_aligned_key_t nf_conntrack_hash_rnd;
>   
> @@ -1568,7 +1571,7 @@ static void gc_worker(struct work_struct *work)
>   				delta_time = nfct_time_stamp - gc_work->start_time;
>   
>   				/* re-sched immediately if total cycle time is exceeded */
> -				next_run = delta_time < (s32)GC_SCAN_INTERVAL_MAX;
> +				next_run = delta_time < (s32)nf_conntrack_gc_scan_interval_max;
>   				goto early_exit;
>   			}
>   

READ_ONCE() is required IMHO as it can be modified from sysctl concurrently.

> @@ -1630,7 +1633,7 @@ static void gc_worker(struct work_struct *work)
>   
>   	gc_work->next_bucket = 0;
>   
> -	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
> +	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, nf_conntrack_gc_scan_interval_max);
>   

Likewise here, READ_ONCE() recommended..

Thanks,
Fernando.
