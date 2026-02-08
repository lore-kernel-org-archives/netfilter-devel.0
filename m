Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CBE27510E
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Feb 2026 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770594780; cv=none; b=SBN/1FhmGj3A+0BMDC3WhJ7ODeED18cZaCgL9oAVLNyW/jJHRcauyuOe4T4FNlPZhvKr9rNLdRkSArps+NK3EKU5FichrGVZ1X+KNXlmwGhemrF79xLu+rBbIJAWcA6XMn7nV0RLuFGzn9OQh/sxC4FY9spN1qEerqjNSD7FWNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770594780; c=relaxed/simple;
	bh=fHSQIHnXb6fjIF48/w1dwgmdE5XC/4XbfaKCSbSItgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpHaeUORhUJJ920fYYdZuRIahaxqIVqNWrICxzYWYEEgyfBOVCaStwXD8AynoVGxqLzUxUHwzoVK1u2mMEu+7idPvHMIFa7JH/IjIQqKsDaDlNw1bKvhOQb5BGipvT2KPt/T1kb6LfXHSrmemN3PqaE7UWakCDJl78fZ9hmFSPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9109160AEF; Mon, 09 Feb 2026 00:52:51 +0100 (CET)
Date: Mon, 9 Feb 2026 00:52:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v17 nf-next 1/4] netfilter: utils: nf_checksum(_partial)
 correct data!=networkheader
Message-ID: <aYkhy9dgUy1cNP36@strlen.de>
References: <20251109192427.617142-1-ericwouds@gmail.com>
 <20251109192427.617142-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109192427.617142-2-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:

As you need to resubmit anyway, one more nit:

> +	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
> +		return 0;

Please switch this to WARN_ON_ONCE().

> +	if (WARN_ON(!skb_pointer_if_linear(skb, nhpull, 0)))
> +		return 0;

and here as well.
