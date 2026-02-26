Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B00378831;
	Thu, 26 Feb 2026 03:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077283; cv=none; b=foDhiRQO0e4MvKpnHOeMI5hCA0kbU8CB8vA47nSdFkFU40DoDPgOQYeAWcVwdiUQLABCPRN0eoIZJNnzvsTamnec8dn24FIm5wdiANJUrK99sTDCQOq3/cXxFGP+QHAIc6yZoBH6NFLMNEtDbn47+8+ohx5abKol5LTCbDOsCdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077283; c=relaxed/simple;
	bh=XvS2+cXKK7OcRlv0RIytvjjtbwKuLS7MSH7ih0LqEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhRPHI8ukKbhB3SIJcppv4K550ngFjjQxa0+4DkC/4YUyoLgl3qqboUEXlhj1c/HkIf9oRS0oCk6RJtU1v0HtnmvwDTFqp5msL2MplaT3JTbauHJrtMKX6G7jz+GY3qDoRdDHS/ijZrEkNrIE8muA/SzSOcSnTBjvXo3IzJA/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icBkU0SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icBkU0SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6701DC116C6;
	Thu, 26 Feb 2026 03:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772077282;
	bh=XvS2+cXKK7OcRlv0RIytvjjtbwKuLS7MSH7ih0LqEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icBkU0SLkrPPXlhVojpnxpLQ8pKHqhZk12zZxIF0efcshe9Acg2QPRpXEku+v+yVm
	 imPVWpdnvKnpZ00UOhd5AL1mFmDVjlNlZ2tVCcssiTtjqpn6qQHdtlA4bW3VMQ7ne+
	 mXql76N3DTlH9pkIMMmnvjn3hmIr11ITzSQ9Jj4Me3dId8C7QqBilIAvVf3hJ0NTV7
	 D2t9VII/pcrVcybvuVOvww6SJycIEx/cD3pB99I1jczvqiLbrrKfHY4J+KbldbhGfc
	 8kfgj1UNiuyv+SUZ/xtokuaF/2WP7LrVB+6jHfh+0zMqwBV2wWWkFJqfnSM5q3WSoo
	 YI7dPUxzxmfdA==
From: Jakub Kicinski <kuba@kernel.org>
To: fw@strlen.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [net-next,1/9] ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table per netns
Date: Wed, 25 Feb 2026 19:41:14 -0800
Message-ID: <20260226034114.1806906-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224205048.4718-2-fw@strlen.de>
References: <20260224205048.4718-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "FYI"

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table per netns

This commit converts the global IPVS service tables and their
associated mutex from global to per-netns, improving lookup
performance in large-scale deployments with multiple network
namespaces.

> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 29a36709e7f3..074a204ec6db 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -33,6 +33,12 @@
>
>  #define IP_VS_HDR_INVERSE	1
>  #define IP_VS_HDR_ICMP		2
> +/*
> + *	Hash table: for virtual service lookups
> + */
> +#define IP_VS_SVC_TAB_BITS 8
> +#define IP_VS_SVC_TAB_SIZE BIT(IP_VS_SVC_TAB_BITS)
> +#define IP_VS_SVC_TAB_MASK (IP_VS_SVC_TAB_SIZE - 1)

The patch removes the global mutex definition DEFINE_MUTEX(__ip_vs_mutex)
from net/netfilter/ipvs/ip_vs_ctl.c and replaces all usage sites with the
per-netns ipvs->service_mutex. However, the extern declaration at line 52
of include/net/ip_vs.h is still present:

    extern struct mutex __ip_vs_mutex;

Since no in-tree code references __ip_vs_mutex after this conversion,
should this declaration be removed for consistency?

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 068702894377..d871273ce917 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c

[ ... ]

> @@ -2306,9 +2282,9 @@ static struct ip_vs_service *ip_vs_info_array(struct seq_file *seq, loff_t pos)
>
>  	/* look in hash by protocol */
>  	for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
> -		hlist_for_each_entry_rcu(svc, &ip_vs_svc_table[idx], s_list) {
> -			if ((svc->ipvs == ipvs) && pos-- == 0) {
> -				iter->table = ip_vs_svc_table;
> +		hlist_for_each_entry_rcu(svc, &ipvs->svc_table[idx], s_list) {
> +			if (pos-- == 0) {
> +				iter->table = ipvs->svc_table;
>  				iter->bucket = idx;
>  				return svc;
>  			}
> @@ -2317,10 +2293,10 @@ static struct ip_vs_service *ip_vs_info_array(struct seq_file *seq, loff_t pos)
>
>  	/* keep looking in fwmark */
>  	for (idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++) {
> -		hlist_for_each_entry_rcu(svc, &ip_vs_svc_fwm_table[idx],
> +		hlist_for_each_entry_rcu(svc, &ipvs->svc_fwm_table[idx],
>  					 f_list) {
> -			if ((svc->ipvs == ipvs) && pos-- == 0) {
> -				iter->table = ip_vs_svc_fwm_table;
> +			if (pos-- == 0) {
> +				iter->table = ipvs->svc_fwm_table;
>  				iter->bucket = idx;
>  				return svc;
>  			}

[ ... ]

> @@ -2414,7 +2392,7 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
>
>  		if (svc->ipvs != ipvs)
>  			return 0;
> -		if (iter->table == ip_vs_svc_table) {
> +		if (iter->table == ipvs->svc_table) {
>  #ifdef CONFIG_IP_VS_IPV6
>  			if (svc->af == AF_INET6)
>  				seq_printf(seq, "%s  [%pI6]:%04X %s ",

The conversion to per-netns tables makes 'svc->ipvs != ipvs' always false
here in ip_vs_info_seq_show(). Every service in ipvs->svc_table belongs
to that netns by construction.

Looking at the patch, similar checks were removed everywhere else:
- ip_vs_flush(): removed 'svc->ipvs == ipvs' check
- ip_vs_dst_event(): removed 'svc->ipvs == ipvs' check
- ip_vs_zero_all(): removed 'svc->ipvs == ipvs' check
- __ip_vs_service_find(): removed 'svc->ipvs == ipvs' check
- __ip_vs_svc_fwm_find(): removed 'svc->ipvs == ipvs' check
- ip_vs_genl_dump_services(): removed 'svc->ipvs != ipvs' check
- __ip_vs_get_service_entries(): removed 'svc->ipvs != ipvs' check
- ip_vs_info_array(): removed 'svc->ipvs == ipvs' check

But this one in ip_vs_info_seq_show() was left behind. Should it also
be removed for consistency?
