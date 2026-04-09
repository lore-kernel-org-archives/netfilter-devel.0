Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4647A3876D7;
	Thu,  9 Apr 2026 22:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775773107; cv=none; b=XExTRLLCo3Aj3fwSueam9YbrsNVhKyp9LAwfaRJN+3JmZInzpcxnu87Ymg42lm2r02uFy5whd8EtOXb8cthPv77ihNpShIvnanRN9DoFKYk9MjldEskxwsVyKxYSeNIoNBLKgYIIYIQDQUDQmknfUXhNtSV25ByoS0VKBlKa7fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775773107; c=relaxed/simple;
	bh=7NHXqhYlaXYZT42HGjbijLVE6ckdTGpyV5UAritebGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXJi2la9mybDtnJnbFMlSi12BteqQCGgrIJVGkAVOKPKk4TKLBuVclxppP93zmtcFpOrUP4u3Jy5qhBh3am9xLvc1aqGQdnAi4n8FGXjUX89+SDYRd9RV1Edxhmo8U4HkLAg4zxoS1TRZjs82oRlMhStNlyIx18EbpXOTeEje1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B6F5760636; Fri, 10 Apr 2026 00:18:22 +0200 (CEST)
Date: Fri, 10 Apr 2026 00:18:22 +0200
From: Florian Westphal <fw@strlen.de>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Kees Cook <kees@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <adglrthId0L5__9w@strlen.de>
References: <adgL5wPm9VpaV3MO@kspp>
 <96b116e4-d91d-456a-9a08-fb3de4822a62@embeddedor.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96b116e4-d91d-456a-9a08-fb3de4822a62@embeddedor.com>

Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index b39017c80548..9dd5957d9ed4 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -819,13 +819,15 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
> 
>   /* non-compat version may have padding after verdict */
>   struct compat_xt_standard_target {
> -       struct compat_xt_entry_target t;
> -       compat_uint_t verdict;
> +       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
> +               compat_uint_t verdict;
> +       );
>   };
> 
>   struct compat_xt_error_target {
> -       struct compat_xt_entry_target t;
> -       char errorname[XT_FUNCTION_MAXNAMELEN];
> +       TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
> +               char errorname[XT_FUNCTION_MAXNAMELEN];
> +       );
>   };
> 
> You tell me what you prefer.

I have no strong opinion. This compat code is needed to run 32bit
iptables binaries on a 64 bit host, not many users these days I think.
I still hope we can remove this eventually.

But as the above diff is smaller I would prefer it.
