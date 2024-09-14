Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE8E43ABD;
	Sat, 14 Sep 2024 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726304815; cv=none; b=e8R0ZHm/MtbOsFgVxu/b9SXJGASVSSTQxSExHG7kPembPpGWRilERhGRMp28TWGaz+kfDDjE2zd0usTnHdh6YccIuKQbJQdQIBC+5qz5bdqZM9eama5vYC/U3+k4BaW6kd0dAwV9SrSC+JOJZnoVjTFmF9renBMN1Ro8t5tQYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726304815; c=relaxed/simple;
	bh=I2HD8EAImkIETuUnjmq/03RamGTqpuAW3jkbI0kzfM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7AXu4zPUba/07ivweU5+txPFNrmqDDkNpyT6jhJhjMY+pRqOXVgDdN1Fi1Yk+xWmzO5XzUKjkwHrklnp9ttnmfcwEYMP1OPERPqGdhnrtM6uMljoYtjq+mvUrfETF+EA6d4CNBecykw1K2Hq19j/MmpvuHYIwsUrkH7wr4NFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2UidxHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2UidxHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315B4C4CEC0;
	Sat, 14 Sep 2024 09:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726304815;
	bh=I2HD8EAImkIETuUnjmq/03RamGTqpuAW3jkbI0kzfM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l2UidxHYYFYQttqloIhdcrsoxg/7jR94fFxYVNCiAT8NQGE0Fhg03Tfn59j0ykg81
	 TTIXs8FLMA3sWnsWuIy27ahm5GTM0n9n/2nFAF8NjEeKq6/vhYbWpChHXjuXl8i474
	 6N+R8ql7isVzVR3YghFpdUf4/tVPqmaq2w/OoD5zKKVSFKV3gQgWGNgHxHfE44qjZn
	 sj0Dk+4LqPypaedEqoHAAbRJaYzkMOSaRxS8Qi1+gHPWSZNo3PDroK29WPiGqONOlY
	 i3UvkEt88GdHDzc2birQcHX2oOrwYWrQBqZxIxH+w5zk7tZEHI4DNRR0comdS8XrFm
	 ka10UMBou3XtA==
Date: Sat, 14 Sep 2024 10:06:50 +0100
From: Simon Horman <horms@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nf_reject_ipv6: fix
 nf_reject_ip6_tcphdr_put()
Message-ID: <20240914090650.GD12935@kernel.org>
References: <20240913170615.3670897-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913170615.3670897-1-edumazet@google.com>

On Fri, Sep 13, 2024 at 05:06:15PM +0000, Eric Dumazet wrote:
> syzbot reported that nf_reject_ip6_tcphdr_put() was possibly sending
> garbage on the four reserved tcp bits (th->res1)
> 
> Use skb_put_zero() to clear the whole TCP header,
> as done in nf_reject_ip_tcphdr_put()

...

> Fixes: c8d7b98bec43 ("netfilter: move nf_send_resetX() code to nf_reject_ipvX modules")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <horms@kernel.org>

