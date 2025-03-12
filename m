Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452CD1F949;
	Wed, 12 Mar 2025 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741783452; cv=none; b=p0iJQvqE+aWf1H4d3gkSRDc5UOdRiywAqs0ZGw7QON8E/rkBPnu7gIPKMC63MDnRmVtqN+C1vNKEiGITTkRBIXl6BN5tV8pDqo9c6MCM2piThsWu+/nZZvC6P/HMzGbT2KnFZoAxCJJkKsjtMZrt7LRWtkajk6xfgHl9LVjO62M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741783452; c=relaxed/simple;
	bh=vWQA3sccFsAja7SYL3ZOCgnwwCe73v+dZK0nfBhnluE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3QAatsuvSACzfkDMp7PfWo3ZIbLDlH1L336L7HV8DBA21+eKQ1hpNBQjQaT277in4QY6S2TSpcXSnMWNDofs7nI55iN1jm/tT08OLCECgGn14uWpuVmnZbmcy3Q/fRNWmC1LmyXvV1Po6Lfo3vGYW+sINzCVpMbpEX2iFOiIKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obgl52uM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obgl52uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437E8C4CEE3;
	Wed, 12 Mar 2025 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741783451;
	bh=vWQA3sccFsAja7SYL3ZOCgnwwCe73v+dZK0nfBhnluE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obgl52uMUBXXa+wYm1Irij/9I1QZJtaBivhOvy8CzyP6NzY7JinfSiog3ZJV/cONq
	 acVsSgqjcvYy+p340LxPZ5bnEpPoG/icj4OLk2t2pJ+FRIhLZY+YsmSgbapdnzoaQT
	 W5OP48U/8KEXt0rlawCfg4SL6Hl1Cake+aUzEQAfunEB31avcaw1581+nSzy2//jFi
	 JafGQLDgU9Z8TFetGwoFGxtV4xVdEN1gfmkQE6jnESMoLZa6mp8cy6ru8syXxnlBUx
	 NkrCcYzRuEcXcGXswM3btgmavYg1FdzdhNEVS8L1Uop0ud+MRpVG1n62bYEa5WNdiC
	 PlNz9v1EpOwDQ==
Date: Wed, 12 Mar 2025 13:43:40 +0100
From: Simon Horman <horms@kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, corbet@lwn.net, andrew+netdev@lunn.ch,
	pablo@netfilter.org, kadlec@netfilter.org
Subject: Re: [PATCH net-next] net: revert to lockless TC_SETUP_BLOCK and
 TC_SETUP_FT
Message-ID: <20250312124340.GR4159220@kernel.org>
References: <20250308044726.1193222-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308044726.1193222-1-sdf@fomichev.me>

On Fri, Mar 07, 2025 at 08:47:26PM -0800, Stanislav Fomichev wrote:
> There is a couple of places from which we can arrive to ndo_setup_tc
> with TC_SETUP_BLOCK/TC_SETUP_FT:
> - netlink
> - netlink notifier
> - netdev notifier
> 
> Locking netdev too deep in this call chain seems to be problematic
> (especially assuming some/all of the call_netdevice_notifiers
> NETDEV_UNREGISTER) might soon be running with the instance lock).
> Revert to lockless ndo_setup_tc for TC_SETUP_BLOCK/TC_SETUP_FT. NFT
> framework already takes care of most of the locking. Document
> the assumptions.
> 
> ndo_setup_tc TC_SETUP_BLOCK
>   nft_block_offload_cmd
>     nft_chain_offload_cmd
>       nft_flow_block_chain
>         nft_flow_offload_chain
> 	  nft_flow_rule_offload_abort
> 	    nft_flow_rule_offload_commit
> 	  nft_flow_rule_offload_commit
> 	    nf_tables_commit
> 	      nfnetlink_rcv_batch
> 	        nfnetlink_rcv_skb_batch
> 		  nfnetlink_rcv
> 	nft_offload_netdev_event
> 	  NETDEV_UNREGISTER notifier
> 
> ndo_setup_tc TC_SETUP_FT
>   nf_flow_table_offload_cmd
>     nf_flow_table_offload_setup
>       nft_unregister_flowtable_hook
>         nft_register_flowtable_net_hooks
> 	  nft_flowtable_update
> 	  nf_tables_newflowtable
> 	    nfnetlink_rcv_batch (.call NFNL_CB_BATCH)
> 	nft_flowtable_update
> 	  nf_tables_newflowtable
> 	nft_flowtable_event
> 	  nf_tables_flowtable_event
> 	    NETDEV_UNREGISTER notifier
>       __nft_unregister_flowtable_net_hooks
>         nft_unregister_flowtable_net_hooks
> 	  nf_tables_commit
> 	    nfnetlink_rcv_batch (.call NFNL_CB_BATCH)
> 	  __nf_tables_abort
> 	    nf_tables_abort
> 	      nfnetlink_rcv_batch
> 	__nft_release_hook
> 	  __nft_release_hooks
> 	    nf_tables_pre_exit_net -> module unload
> 	  nft_rcv_nl_event
> 	    netlink_register_notifier (oh boy)
>       nft_register_flowtable_net_hooks
>       	nft_flowtable_update
> 	  nf_tables_newflowtable
>         nf_tables_newflowtable
> 
> Fixes: c4f0f30b424e ("net: hold netdev instance lock during nft ndo_setup_tc")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Thanks Stan,

Thinking aloud: the dev_setup_tc() helper checked if ndo_setup_tc is
non-NULL, but that is not the case here. But that seems ok because it was
also the case prior to the cited commit.

Reviewed-by: Simon Horman <horms@kernel.org>

...
