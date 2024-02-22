Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C7780C
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Feb 2024 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560937; cv=none; b=da8ghThhFcMRcQyi6VKOtVmMJ5m3CWkVqmSE/HocDMWsFi0yvfPuX03L3k/PZePC9RKWVqFgRjNt7XxzmKjrnZbBqPLRHO1FxIKe4xiTmVebl+pVclxL/AfEuKIoL1oeS+KlvFBH9scOquPIr09qgO4DQwTM9ghV8yypDjaZjcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560937; c=relaxed/simple;
	bh=tWCdJXqyb5FRoGUukiOjgVRq9VZORym9raq79w/tXC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/noBG8+Z6b3OAuU7rIIThh6pB8x71Fjip8lnPJf93rE8KWR4oFWJamq4SkMEp8vme/wbqVgMcOY0cfq16soz4aGHqzffzjzhToraKG0AU6xil18DxpjSuk4X6Mcg/QEZgADZbrmJEIgPpDtVldEZqRzqfz6q1kIiSVkslpMfn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=51020 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rcwkM-00C8su-Ee; Thu, 22 Feb 2024 01:15:32 +0100
Date: Thu, 22 Feb 2024 01:15:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: kadlec@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, kernel-team@cloudflare.com,
	jgriege@cloudflare.com
Subject: Re: [PATCH v2] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
Message-ID: <ZdaSIRv3HBcEUpy9@calendula>
References: <20240220145509.53357-1-ignat@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240220145509.53357-1-ignat@cloudflare.com>
X-Spam-Score: -1.6 (-)

On Tue, Feb 20, 2024 at 02:55:09PM +0000, Ignat Korchagin wrote:
> Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
> some validation of NFPROTO_* families in the nft_compat module, but it broke
> the ability to use legacy iptables modules in dual-stack nftables.
> 
> While with legacy iptables one had to independently manage IPv4 and IPv6 tables,
> with nftables it is possible to have dual-stack tables sharing the rules.
> Moreover, it was possible to use rules based on legacy iptables match/target
> modules in dual-stack nftables. Consider the following program:
> 
> ```
> 
> /* #define TBL_FAMILY NFPROTO_IPV4 */
> 
> /*
>  * creates something like below
>  * table inet testfw {
>  *   chain input {
>  *     type filter hook prerouting priority filter; policy accept;
>  *     bytecode counter packets 0 bytes 0 accept

Upstream nft does not provides this. Please, clarify that this the
output with the out-of-tree patch,

>  *   }
>  * }
>  *
>  * compile:
>  * cc -o nftbpf nftbpf.c -lnftnl -lmnl
>  */
> int main(void)

Please, no program in the commit description, it makes it too long,
I am not sure this is the good place to store this.

> ```
> 
> Above creates an INET dual-stack family table using xt_bpf based rule. After
> d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
> EOPNOTSUPP for the above configuration.
> 
> Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
> restrict the functions to classic iptables hooks.
> 
> Changes in v2:
>   * restrict nft_(match/target)_validate() to classic iptables hooks
>   * rewrite example program to use unmodified libnftnl

Thanks! Please send a v3 with updates.
