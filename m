Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8999616D4D0
	for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2024 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898960; cv=none; b=WPiNIG5q2oWpwCDc9BGWsW9zpixde/bvbNpKhuWWn2sHwzU1UqL1icIiwWLIQt1sTD7SBNI4BiVXmQ6KNxC9kQZ61SQibVNbEi9oXj+3RIFwxdw9/XU6ImtRCV9F5fOb+FW+ZvRgTXS8tdGSeY7mX+ZJAxgduzu+N7mdl4SfAvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898960; c=relaxed/simple;
	bh=UlllpUYD1S395TqSfKy3rSOyZgJvmSvZI7LZtOvdWec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzIxs2BK2ga1mTe8bz3KXDNzje6mUkFCvX689+NXZjoepHeQaGjgz9mO+FLAuzeH+8Q62MqSsVrQVa1nXcfvwlPqOiWNFhAxKh/+IOrmZqngrSCK/eaNh6wCdY7guY9y6f3MD6WbWZdPnhnCk33XhgyIjva8gtLSWcVfOwTqCD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sBvqV-0003PL-Qf; Tue, 28 May 2024 14:22:27 +0200
Date: Tue, 28 May 2024 14:22:27 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: drop duplicate ARP HEADER EXPRESSION
Message-ID: <20240528122227.GA12430@breakpoint.cc>
References: <tencent_AF404BDA8C9E076BA13FEAE795768D9FEF07@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_AF404BDA8C9E076BA13FEAE795768D9FEF07@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

谢致邦 (XIE Zhibang) <Yeking@Red54.com> wrote:
> Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>
> ---
>  doc/payload-expression.txt | 38 --------------------------------------
>  1 file changed, 38 deletions(-)
> 
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index c7c267daee0c..7bc24a8a6502 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -670,44 +670,6 @@ integer (24 bit)
>  netdev filter ingress udp dport 4789 vxlan tcp dport 80 counter
>  ----------------------------------------------------------
>  
> -ARP HEADER EXPRESSION

Weird, its indeed listed twice.  Applied, thanks.
