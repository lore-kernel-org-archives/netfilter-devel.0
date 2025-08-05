Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6483283FEE;
	Tue,  5 Aug 2025 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754408592; cv=none; b=K/6HZj5zP4v+QcDmOwiACiW/Te1qmDL/PJTHr9zP+fXQypgqlK5lXf/ScpkamlBCHCuviX67+QPXrCDsVuOHmorEQGw7aLN7rUbZsbQ+/E5SCawUpZNT7i4p8PyuCdtGKZZgiPjeBY2WBFCN07hMoYinJbabK/X/02Yt2A7k0t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754408592; c=relaxed/simple;
	bh=BfL2RjEcyCaLn9HxlnC8b4yC/2qDp9kmpyofEFBavas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+di4YFzpJ94DBVUFcmMs28kOloDrPK/9BRxuYGvJppgIVZlGstDFw+FyUhojF8SvwpIoSY8nEuhNKOBZVd5KQn6MiH9QTNt44JGROIH/NY2IVUzGtSuExF3gvWFzl3DrGqiGYRWNI2b/bB5qw2++PlAYBZpbMA/L7cXQ8Vqopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21BF61424;
	Tue,  5 Aug 2025 08:43:01 -0700 (PDT)
Received: from [10.1.26.194] (unknown [10.1.26.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B84653F673;
	Tue,  5 Aug 2025 08:43:07 -0700 (PDT)
Message-ID: <81bdc56d-a3da-4fc4-b2d0-2561b4d96723@arm.com>
Date: Tue, 5 Aug 2025 16:43:06 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 06/19] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Content-Language: en-GB
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, fw@strlen.de, horms@kernel.org,
 Aishwarya Rambhadran <Aishwarya.Rambhadran@arm.com>
References: <20250725170340.21327-1-pablo@netfilter.org>
 <20250725170340.21327-7-pablo@netfilter.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250725170340.21327-7-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pablo,

On 25/07/2025 18:03, Pablo Neira Ayuso wrote:
> The seqcount xt_recseq is used to synchronize the replacement of
> xt_table::private in xt_replace_table() against all readers such as
> ipt_do_table()
> 
> To ensure that there is only one writer, the writing side disables
> bottom halves. The sequence counter can be acquired recursively. Only the
> first invocation modifies the sequence counter (signaling that a writer
> is in progress) while the following (recursive) writer does not modify
> the counter.
> The lack of a proper locking mechanism for the sequence counter can lead
> to live lock on PREEMPT_RT if the high prior reader preempts the
> writer. Additionally if the per-CPU lock on PREEMPT_RT is removed from
> local_bh_disable() then there is no synchronisation for the per-CPU
> sequence counter.
> 
> The affected code is "just" the legacy netfilter code which is replaced
> by "netfilter tables". That code can be disabled without sacrificing
> functionality because everything is provided by the newer
> implementation. This will only requires the usage of the "-nft" tools
> instead of the "-legacy" ones.
> The long term plan is to remove the legacy code so lets accelerate the
> progress.
> 
> Relax dependencies on iptables legacy, replace select with depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
> NETFILTER_XTABLES_LEGACY. Hide xt_recseq and its users,
> xt_register_table() and xt_percpu_counter_alloc() behind
> NETFILTER_XTABLES_LEGACY. Let NETFILTER_XTABLES_LEGACY depend on
> !PREEMPT_RT.
> 
> This will break selftest expecing the legacy options enabled and will be
> addressed in a following patch.
> 
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/bridge/netfilter/Kconfig | 10 +++++-----
>  net/ipv4/netfilter/Kconfig   | 24 ++++++++++++------------
>  net/ipv6/netfilter/Kconfig   | 19 +++++++++----------
>  net/netfilter/Kconfig        | 10 ++++++++++
>  net/netfilter/x_tables.c     | 16 +++++++++++-----
>  5 files changed, 47 insertions(+), 32 deletions(-)

[...]

> +config NETFILTER_XTABLES_LEGACY
> +	bool "Netfilter legacy tables support"
> +	depends on !PREEMPT_RT
> +	help
> +	  Say Y here if you still require support for legacy tables. This is
> +	  required by the legacy tools (iptables-legacy) and is not needed if
> +	  you use iptables over nftables (iptables-nft).
> +	  Legacy support is not limited to IP, it also includes EBTABLES and
> +	  ARPTABLES.
> +

This has caused some minor pain for me using Docker on Ubuntu 22.04, which I
guess is still using iptables-legacy. I've had to debug why Docker has stopped
working and eventually ended here. Explcitly enabling NETFILTER_XTABLES_LEGACY
solved the problem.

I thought I'd try my luck at convincing you to default this to enabled for
!PREEMPT_RT to save others from such issues?

Thanks,
Ryan

