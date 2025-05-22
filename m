Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F1E28983A;
	Thu, 22 May 2025 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747920173; cv=none; b=Z7nZ/YaJNmjkg9NpVqBZZjmfewEyuNUrpqHQOkjcj6syNnl8A7iQBRlSNacct50dNIHI08pYSCgxnI+rnOVwlj0P0zwWpu2wQMFz0sGrDe86rrzs6vR3ssFd42oM5z3YtUhXlWsbTBBNoiJaYO8XIC3UTTV2MdJqFeEDz7UVw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747920173; c=relaxed/simple;
	bh=5FURPwUiKabBhN6PL3QOmJ1rlhPRokHIUYLphhQXZW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlyDyYKkO03aMv7SdDv6FcWSz1aX5v8F/51/E8xAmr0VR4r9Y5H1yJRMThmtoKgSiLLbnEK+fWMZjz+XQ0vAokALei2iFSs5lLP/nV35TUNz4ItmBCaiA2V2O38qyS6FGGwKZ3t8QCaE2mqjJBBwdsf2pvVV7GUelPiLc92ZVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2A0856015E; Thu, 22 May 2025 15:22:49 +0200 (CEST)
Date: Thu, 22 May 2025 15:19:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Lance Yang <ioworker0@gmail.com>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Zi Li <zi.li@linux.dev>
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aC8keoPd6oj4-zIV@strlen.de>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula>
 <aC23TW08pieLxpsf@strlen.de>
 <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev>
 <aC4aNCpZMoYJ7R02@strlen.de>
 <1c21a452-e1f4-42e0-93c0-0c49e4612dcd@linux.dev>
 <aC7Fg0KGari3NQ3Z@strlen.de>
 <ac51507e-28ca-404d-a784-7cc3721ee624@linux.dev>
 <0e89bc09-c0ee-49d0-bbde-430cca361fd6@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e89bc09-c0ee-49d0-bbde-430cca361fd6@linux.dev>

Lance Yang <lance.yang@linux.dev> wrote:
> Does this helper look correct?

Yes, but ...
> /**
>   * nf_log_is_registered - Check if NF_LOG is registered for a protocol
>   * family
>   *
>   * @pf: protocol family (e.g., NFPROTO_IPV4)
>   *
>   * Returns true if NF_LOG is registered, false otherwise.
>   */
> bool nf_log_is_registered(int pf)
> {
>          struct nf_logger *logger;
> 
>          logger = nf_logger_find_get(pf, NF_LOG_TYPE_LOG);
>          if (logger) {
>                  nf_logger_put(pf, NF_LOG_TYPE_LOG);
>                  return true;
>          }
> 
>          logger = nf_logger_find_get(pf, NF_LOG_TYPE_ULOG);
>          if (logger) {
>                  nf_logger_put(pf, NF_LOG_TYPE_ULOG);
>                  return true;
>          }
> 
>          return false;
> }

Why not simply do:

bool nf_log_is_registered(int pf)
{
	int i;

	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
		if (rcu_access_pointer(loggers[pf][i]))
			return true;
	}

	return false;
}

?
