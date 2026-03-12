Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB61B388E47
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 12:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773317537; cv=none; b=sYg/lauwyZLs2rRclas+tOAUxK+jtJuZ7auWmSLTTwZrdlvdmpMEshSrSf3SppBOJofAt0X2ghCrAtVjrR5p/Kaqr7aLEEj+oMkra1muFyTyeA2R8O4jLjTgDhB86voG2A4848KSfDJZgNCR/3Y7wCGPfdr8b2oXqKixqGazo1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773317537; c=relaxed/simple;
	bh=BAobcb9CuFaakDdqoHMPQ+3oqwZVEllsE729QCLW8YU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUpcHYsub8YFo+q7vJXFJCcv5qsWpxj6Ki8QjXluaj9GzbeaHYJYLKsLzKmZEcsc3sseF1AkMFloQ03pc+eRVuDO758/IK/7tQTgbFwqDJJCMPkVi18rv7EblqoEV0UKVvnlgBkjFpcgYKFOLcBwv6WiHdi7r21rOMyg+y/j3Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NIOqQdnb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S4EIcnpz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NIOqQdnb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S4EIcnpz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NIOqQdnb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S4EIcnpz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NIOqQdnb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S4EIcnpz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A205E4D3CA;
	Thu, 12 Mar 2026 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773317531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StxNDEEJm/MKfQMlWCh7AudfdlhtE98aLWBisrKX4EA=;
	b=NIOqQdnbEYh+pqxm3TY/oimbRa5hOKHYbUtH1jVAn/I52vBgJx2SpDRlQNcg0smmk/Cq9H
	yJiEb/B04zxWVv4WyMP0aebhfAePEudiipb26ZHgykUenIhcor8hHxILqUbJ0FOQMUykeN
	p3RIa2zLjvWSFGlv67a6PnhTtSyWNPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773317531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StxNDEEJm/MKfQMlWCh7AudfdlhtE98aLWBisrKX4EA=;
	b=S4EIcnpz+mreO6XXUTk4yVupHGKh3BhPGl8HWOlt01B85263TlOyqMdpOjqeVHSJTQCgmv
	/fKroxjDWUduLgCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773317531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StxNDEEJm/MKfQMlWCh7AudfdlhtE98aLWBisrKX4EA=;
	b=NIOqQdnbEYh+pqxm3TY/oimbRa5hOKHYbUtH1jVAn/I52vBgJx2SpDRlQNcg0smmk/Cq9H
	yJiEb/B04zxWVv4WyMP0aebhfAePEudiipb26ZHgykUenIhcor8hHxILqUbJ0FOQMUykeN
	p3RIa2zLjvWSFGlv67a6PnhTtSyWNPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773317531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StxNDEEJm/MKfQMlWCh7AudfdlhtE98aLWBisrKX4EA=;
	b=S4EIcnpz+mreO6XXUTk4yVupHGKh3BhPGl8HWOlt01B85263TlOyqMdpOjqeVHSJTQCgmv
	/fKroxjDWUduLgCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A589F3FF6E;
	Thu, 12 Mar 2026 12:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 740IJZqtsmnIXQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 12 Mar 2026 12:12:10 +0000
Message-ID: <a18f93d5-af8c-4e67-90ae-f386af86ca0f@suse.de>
Date: Thu, 12 Mar 2026 13:12:09 +0100
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
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo,arista.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

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
> @@ -1630,7 +1633,7 @@ static void gc_worker(struct work_struct *work)
>   
>   	gc_work->next_bucket = 0;
>   
> -	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
> +	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, nf_conntrack_gc_scan_interval_max);
>   
>   	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
>   	if (next_run > (unsigned long)delta_time)
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 207b240b14e5..f8cab779763f 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -637,6 +637,7 @@ enum nf_ct_sysctl_index {
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
>   #endif
> +	NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX,
>   
>   	NF_SYSCTL_CT_LAST_SYSCTL,
>   };
> @@ -920,6 +921,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>   		.proc_handler   = proc_dointvec_jiffies,
>   	},
>   #endif
> +	[NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX] = {
> +		.procname	= "nf_conntrack_gc_scan_interval_max",
> +		.data		= &nf_conntrack_gc_scan_interval_max,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_jiffies,
> +		.extra1		= SYSCTL_ONE,
> +	},
>   };
>   
>   static struct ctl_table nf_ct_netfilter_table[] = {
> @@ -1043,6 +1052,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>   		table[NF_SYSCTL_CT_MAX].mode = 0444;
>   		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
>   		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
> +		table[NF_SYSCTL_CT_GC_SCAN_INTERVAL_MAX].mode = 0444;
>   	}
>   
>   	cnet->sysctl_header = register_net_sysctl_sz(net, "net/netfilter",

