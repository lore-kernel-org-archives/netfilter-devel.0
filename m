Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A9344CF55;
	Thu, 26 Feb 2026 19:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772133949; cv=none; b=Av1Lle/v2HVKuBJsN8Wxyy7ewBDRkSOBL2IBCYDZniCwlNNNPJ/qim7o3SAQQN3aUgmgTkw29TO0A/vTlv0AvG53m8xCR0jSKE7ljN1abhT12vRiu9tCru3qKQ/uT0aTaKkz43FdIxwPaO6vpF2znOzCxjTDGH0hXYUEnFF72kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772133949; c=relaxed/simple;
	bh=i3wKPYd8EFlc8IZ73L+p7gW+K0o00fx/yJw+0Jptrls=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZZPj5BK886Ok3JFCOwIZYa/r65zrWUYXxr/hiZYd5pj6rr3gpd/GCXoNOw61uQgXsis2CXKwKDP1gLsedokz58gLJk9FLjWEJExECZlGUfei6g17J3FbAp4rZSoPon9gRuJw8J96K1DRhq1ks3IbwzDPmyLnYv5reH0cjMYr6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=vwHaHfhU; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="vwHaHfhU"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id BAD5C21D4F;
	Thu, 26 Feb 2026 21:19:57 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=Exe2tq+Qjn8oUB9BaUlHxkZcSCOCRHMqp4FnkJz94AA=; b=vwHaHfhUI3ig
	HqMDxpDmjZtDDoNUW0vdk5vA1ZUiCEb+TOtFQJWazf0ycFFYQ8ad4mVFYEdwHlMc
	QHQ3N/MKMKI08qtrpPXAs0VqctHG8vBVhok6snlwBWmH3O4iLTZjVbw8VPDl4JFL
	jdukUF9LW9PfA6HNUrmfwlFoozuo/YJGu0GsuTXSKn18ECk36j5setNOpLWSxUeH
	bXD7hEF0t1Nz3Y6WAouOkkurY5oLu7r9S89sPynTMC7XpBEGAROTwxo7sUhv7o7v
	7AG30BPppCXanbbtBy99fujFEJlGdZP6J77zxb2s+pze8NnINqYR9T7VDUFcAXDF
	4I/Qx/5+MeOlM1yvXZ2BS7JlAdH274hxSPaOuVu/5lsmvL887TPZ4ho6CDtpepg6
	jNPzgdR1kbc/CC6ZBYEqCPRyUCIMqGKMgdvI+LFMjMmtj9oEwOGPjnK4XgpRGN4y
	IM+T5tIRegh0Jo+yp0tQFYthWjVX9B6Xd9k7Sas2EDWRISphDiMNegH4cEqR+vm1
	THe+Xck2d/VLBFk8/3tS8RJlZroze6tM1/6B80jMFEPEtQ/i0Y70OpFSfbpJRnGJ
	W3tvNOvYEK+IBLSWK8KLcuTB4iJqZHRtpT5xjWFEQmXzJ3FnN8sajocVjhym0IJF
	Pr95suJflirl2+2JJaEh3a6DepqRQpk=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Thu, 26 Feb 2026 21:19:56 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 911EA60973;
	Thu, 26 Feb 2026 21:19:54 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.1/8.18.1) with ESMTP id 61QJJhQF062224;
	Thu, 26 Feb 2026 21:19:44 +0200
Date: Thu, 26 Feb 2026 21:19:43 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: fw@strlen.de, netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: [net-next,1/9] ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table
 per netns
In-Reply-To: <20260226034114.1806906-1-kuba@kernel.org>
Message-ID: <2b88af71-9294-e4a6-968a-cb9b314bc87f@ssi.bg>
References: <20260224205048.4718-2-fw@strlen.de> <20260226034114.1806906-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Wed, 25 Feb 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email says "FYI"
> 
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> ---
> ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table per netns
> 
> This commit converts the global IPVS service tables and their
> associated mutex from global to per-netns, improving lookup
> performance in large-scale deployments with multiple network
> namespaces.
> 
> > diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> > index 29a36709e7f3..074a204ec6db 100644
> > --- a/include/net/ip_vs.h
> > +++ b/include/net/ip_vs.h
> > @@ -33,6 +33,12 @@
> >
> >  #define IP_VS_HDR_INVERSE	1
> >  #define IP_VS_HDR_ICMP		2
> > +/*
> > + *	Hash table: for virtual service lookups
> > + */
> > +#define IP_VS_SVC_TAB_BITS 8
> > +#define IP_VS_SVC_TAB_SIZE BIT(IP_VS_SVC_TAB_BITS)
> > +#define IP_VS_SVC_TAB_MASK (IP_VS_SVC_TAB_SIZE - 1)
> 
> The patch removes the global mutex definition DEFINE_MUTEX(__ip_vs_mutex)
> from net/netfilter/ipvs/ip_vs_ctl.c and replaces all usage sites with the
> per-netns ipvs->service_mutex. However, the extern declaration at line 52
> of include/net/ip_vs.h is still present:
> 
>     extern struct mutex __ip_vs_mutex;

	I have fixes for all these issues in a followup
patches. Sorry that I forgot to push them to the right
patch.

> Since no in-tree code references __ip_vs_mutex after this conversion,
> should this declaration be removed for consistency?

	It will be removed in a followup patchset, in its patch 3/5.

> 
> [ ... ]
> 
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index 068702894377..d871273ce917 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> 
> [ ... ]
> 
> > @@ -2306,9 +2282,9 @@ static struct ip_vs_service *ip_vs_info_array(struct seq_file *seq, loff_t pos)
> >
> >  	/* look in hash by protocol */
> >  	for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
> > -		hlist_for_each_entry_rcu(svc, &ip_vs_svc_table[idx], s_list) {
> > -			if ((svc->ipvs == ipvs) && pos-- == 0) {
> > -				iter->table = ip_vs_svc_table;
> > +		hlist_for_each_entry_rcu(svc, &ipvs->svc_table[idx], s_list) {
> > +			if (pos-- == 0) {
> > +				iter->table = ipvs->svc_table;
> >  				iter->bucket = idx;
> >  				return svc;
> >  			}
> > @@ -2317,10 +2293,10 @@ static struct ip_vs_service *ip_vs_info_array(struct seq_file *seq, loff_t pos)
> >
> >  	/* keep looking in fwmark */
> >  	for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
> > -		hlist_for_each_entry_rcu(svc, &ip_vs_svc_fwm_table[idx],
> > +		hlist_for_each_entry_rcu(svc, &ipvs->svc_fwm_table[idx],
> >  					 f_list) {
> > -			if ((svc->ipvs == ipvs) && pos-- == 0) {
> > -				iter->table = ip_vs_svc_fwm_table;
> > +			if (pos-- == 0) {
> > +				iter->table = ipvs->svc_fwm_table;
> >  				iter->bucket = idx;
> >  				return svc;
> >  			}
> 
> [ ... ]
> 
> > @@ -2414,7 +2392,7 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
> >
> >  		if (svc->ipvs != ipvs)
> >  			return 0;
> > -		if (iter->table == ip_vs_svc_table) {
> > +		if (iter->table == ipvs->svc_table) {
> >  #ifdef CONFIG_IP_VS_IPV6
> >  			if (svc->af == AF_INET6)
> >  				seq_printf(seq, "%s  [%pI6]:%04X %s ",
> 
> The conversion to per-netns tables makes 'svc->ipvs != ipvs' always false
> here in ip_vs_info_seq_show(). Every service in ipvs->svc_table belongs
> to that netns by construction.
> 
> Looking at the patch, similar checks were removed everywhere else:
> - ip_vs_flush(): removed 'svc->ipvs == ipvs' check
> - ip_vs_dst_event(): removed 'svc->ipvs == ipvs' check
> - ip_vs_zero_all(): removed 'svc->ipvs == ipvs' check
> - __ip_vs_service_find(): removed 'svc->ipvs == ipvs' check
> - __ip_vs_svc_fwm_find(): removed 'svc->ipvs == ipvs' check
> - ip_vs_genl_dump_services(): removed 'svc->ipvs != ipvs' check
> - __ip_vs_get_service_entries(): removed 'svc->ipvs != ipvs' check
> - ip_vs_info_array(): removed 'svc->ipvs == ipvs' check
> 
> But this one in ip_vs_info_seq_show() was left behind. Should it also
> be removed for consistency?

	It was removed later in patch 3 ("ipvs: use single svc table").

	Comments about patch 3/9:

- svc_fwm_table in comments will be removed in a followup
patchset, in its patch 3/5.

	Comments about patch 4/9:

- bitwise ops have precedence over the logical ops but as the
series is already applied we can make it less confusing later

Regards

--
Julian Anastasov <ja@ssi.bg>

