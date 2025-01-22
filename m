Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B073D1F76B5;
	Wed, 22 Jan 2025 09:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737539982; cv=none; b=u64USRQjrq4gDXh+BwTMLIu1P7TDdZgSnWQ1gQ93Cls/85Tot2Q9GzLKtRknaQSYWaHbq5EO8o3y0ZeDu/p1Bde05JyYVIZrA/Xcl2g4MWUUBpjQWPP8eThvgGkSR3AZg6gwy1wxrnWWIIdqj+W7brUuaeMcsh5VVq8k/t03jQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737539982; c=relaxed/simple;
	bh=A3twpjoho0r2lM/z6ij4fhp5Yrbb7D6UP+KJ26y1ypM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMGvy5sKX1BosR6CPCkHGVXsjJLP2uXJUCETmy7pWa3YPlygovGs46RCKTx8YgqU0JMtfVRR/TzKOPqChGPop0ygBD28LpmGGzqyLB/dxp9HuxQkmc+qoYpVy0pIAFDp1BCwxvpGjPfiSTMiOwCB9RAG/5dM2rWCyCz41q4qyuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xp3nz9jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xp3nz9jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F51C4CED6;
	Wed, 22 Jan 2025 09:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737539981;
	bh=A3twpjoho0r2lM/z6ij4fhp5Yrbb7D6UP+KJ26y1ypM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xp3nz9jj8xulmfYcTFouOdUIAo3S1PNanlL7eUW04ETy2v1z46E9U0i/h6MeLXTE5
	 OliNmcJ+GsqVW0LWTnR48mrbWhv/UPqmAOLAKtyJLO1pENlZWQCwb+SuarkneS08CE
	 slIvMEC/82lZ9KqNZk/a6bHRaIhwph7pHcdNTdcnHPKP0csKxInaQUHRbACKp+F3ID
	 I3PcI1u57dTcSqZ4OJunhuyXfLMugWKBFlf/mfKarzKJwaFbUhbmzhw09Lei9I3iJa
	 NGnVIh+V2tguNV5pvWUo0x2eMuPpJsgPDFTj+SyiXytsYEfswZltocBXezVYUqKdY0
	 4w4jjZH+yJNuA==
Date: Wed, 22 Jan 2025 09:59:35 +0000
From: Simon Horman <horms@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] net/netfilter: use kvfree_rcu to simplify the code
Message-ID: <20250122095935.GC385045@kernel.org>
References: <20250122074450.3185-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122074450.3185-1-lirongqing@baidu.com>

On Wed, Jan 22, 2025 at 03:44:50PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The callback function of call_rcu() just calls kvfree(), so we can
> use kvfree_rcu() instead of call_rcu() + callback function.
> 
> and move struct rcu_head into struct nf_hook_entries, then struct
> nf_hook_entries_rcu_head can be removed
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Simon Horman <horms@kernel.org>

...
