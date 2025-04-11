Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DEA278E7C;
	Fri, 11 Apr 2025 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744366993; cv=none; b=bMeWbvRoQqitay5Fq+xMdOvIi/wRbu0pRPgcqgxU0ZD7RjHlmY+07awfiOfOqHx5Pf6CqzuIHjhLf6kF/Jtsa1QO9mAC+/MrdUvaduBjI16mFHz8sQ9Hl8eJvy3cN+jCdAGUurp2wZa2A2TSMMDN/hwtgO0hD3wY+qnGmFJa3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744366993; c=relaxed/simple;
	bh=Atz93oKz2UiAG36ViypesYktnrowE+YmNw7wI/Xmg2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6aJV0933KOmuu6QV+/T1ii+E/V5KVybWb7S2qnWsZbURQd45wTprYjQEkrXR1SYuE0DCb2Vp5tNr2BhIi09IiLedpO4MX0nwuUPpWupuerA7QnK+b2+obLEh9b+J9NKCDBXkAttEnRLB6T+qLLhY9nUGU6nB9sioDK8nqfZMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5POn7xQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5POn7xQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48056C4CEE2;
	Fri, 11 Apr 2025 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744366993;
	bh=Atz93oKz2UiAG36ViypesYktnrowE+YmNw7wI/Xmg2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5POn7xQhMlH+mXmOEgnmOxYGScuLqft0/JihGI2g3FwOtNOPzVI6Xspc5khE+owS
	 Xky8QMJZp52FQq6aJ3oFsgXbDFEjaZS+F8byf4ncgkgvIT/kR5YhGWUt6Pc0HQBvSn
	 uykJyOf1i3gMA6v12d3qaDYZtZmK+azFPTBpWgf73yi3WQ5kvqewP1iXdzIgdusHJs
	 z0KyowxVHhgZ5QDncv3ZGggo3+cCtVMLyq4hcCVOWwyj7L37B0NXci6bhm4OWIwDy7
	 s3vuPD205IpEg/WD1GR6mbRTKHVuqrNF6Y7OSVqF+lmL4yzPlV15fNLqc0cvwNZ4ho
	 bspNVgyR8qdFw==
Date: Fri, 11 Apr 2025 11:23:08 +0100
From: Simon Horman <horms@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_flow_table_core: teardown
 direct xmit when destination changed
Message-ID: <20250411102308.GX395307@horms.kernel.org>
References: <20250408142848.96281-1-ericwouds@gmail.com>
 <20250408142848.96281-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408142848.96281-3-ericwouds@gmail.com>

On Tue, Apr 08, 2025 at 04:28:47PM +0200, Eric Woudstra wrote:
> In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
> used to create the tuple. In case of roaming at layer 2 level, for example
> 802.11r, the destination device is changed in the fdb. The destination
> device of a direct transmitting tuple is no longer valid and traffic is
> send to the wrong destination. Also the hardware offloaded fastpath is not
> valid anymore.
> 
> In case of roaming, a switchdev notification is send to delete the old fdb
> entry. Upon receiving this notification, mark all direct transmitting flows
> with the same ifindex, vid and hardware address as the fdb entry to be
> teared down. The hardware offloaded fastpath is still in effect, so
> minimize the delay of the work queue by setting the delay to zero.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 65 ++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c

...

> +struct notifier_block nf_flow_table_switchdev_nb __read_mostly = {
> +	.notifier_call = nf_flow_table_switchdev_event,
> +};

Hi Eric,

A minor nit from my side:

nf_flow_table_switchdev_nb seems only be used in this file and if so it
should be static.

Flagged by Sparse.

> +
>  void nf_flow_table_free(struct nf_flowtable *flow_table)
>  {
>  	mutex_lock(&flowtable_lock);
> @@ -816,6 +874,10 @@ static int __init nf_flow_table_module_init(void)
>  	if (ret)
>  		goto out_offload;
>  
> +	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
> +	if (ret < 0)
> +		goto out_sw_noti;
> +
>  	ret = nf_flow_register_bpf();
>  	if (ret)
>  		goto out_bpf;
> @@ -823,6 +885,8 @@ static int __init nf_flow_table_module_init(void)
>  	return 0;
>  
>  out_bpf:
> +	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
> +out_sw_noti:
>  	nf_flow_table_offload_exit();
>  out_offload:
>  	unregister_pernet_subsys(&nf_flow_table_net_ops);
> @@ -831,6 +895,7 @@ static int __init nf_flow_table_module_init(void)
>  
>  static void __exit nf_flow_table_module_exit(void)
>  {
> +	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
>  	nf_flow_table_offload_exit();
>  	unregister_pernet_subsys(&nf_flow_table_net_ops);
>  }
> -- 
> 2.47.1
> 
