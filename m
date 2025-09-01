Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73361547EE;
	Mon,  1 Sep 2025 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756759564; cv=none; b=gEaLrLUCr/+WrE7ujj8wE0QPS0EnIvzMm0dyNHdbFA6CT1G9MPRF/TWjuD+hCAqBUfLPDgsj4ajRoS7dEu+Z+gnQQ62BroCsFZrS8Zr6kbqPHXehIWsaQ+PB05otqrDlJFydL6d2tJG6R6tklFX8QLoNuVheIab/CnMozl5bEG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756759564; c=relaxed/simple;
	bh=kSl1RB6K1ezuvGTcXLCbaGcHmeHRowv1je8J4AMsp04=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxFsTnBY3m21uaHTuvgijhBHJryvPb4ja6g7n3/rU4H+iHUA6oeIWBOg16LDUwElEnS7P4Ku3BqjKG7f2JhSXIN2sm7TPCazAxZtpu83Xhv7kjiCJsuXciX1hA10flZ/T6/liDTqc2IRi78/iKuzYozdZFPuiAJWBIySvEKxKlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mahGrigu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mahGrigu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280AFC4CEF0;
	Mon,  1 Sep 2025 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756759563;
	bh=kSl1RB6K1ezuvGTcXLCbaGcHmeHRowv1je8J4AMsp04=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mahGriguCaa9+g+hbu8B4zWTCIX+mL9hPFKBiWe8CmPF1VNSMWOTsIuAxMKf0MWP/
	 /kqQ63DArYJMNk9c5qaiLXobBp9S7jCCGkQZ3qYaINbLWFv7ZsqYYvwBaS7ebVwnuf
	 wy6mFn4oy/rV5DOwixW0XtK/jAJoaBMdr26N97OmGPC+++mWZgwKTnq4A+uffCCUWy
	 E2mS3NYSv8t4zYd9CLb7/pIyBVVB4Ky4Y8Rd+oDlycfMWNFoh3PXplD3QXy1RmComE
	 yjbBXDSTiv2+nYbo4Jn4OggsRCfzH/pMYZqvkxLYN2KjP24EZluMteEuiwPCRf1qmY
	 WUcMt3oCco/8w==
Date: Mon, 1 Sep 2025 13:46:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/8] netfilter: nf_tables: Introduce
 NFTA_DEVICE_PREFIX
Message-ID: <20250901134602.53aaef6b@kernel.org>
In-Reply-To: <20250901080843.1468-6-fw@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
	<20250901080843.1468-6-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 Sep 2025 10:08:39 +0200 Florian Westphal wrote:
> This new attribute is supposed to be used instead of NFTA_DEVICE_NAME
> for simple wildcard interface specs. It holds a NUL-terminated string
> representing an interface name prefix to match on.
> 
> While kernel code to distinguish full names from prefixes in
> NFTA_DEVICE_NAME is simpler than this solution, reusing the existing
> attribute with different semantics leads to confusion between different
> versions of kernel and user space though:
> 
> * With old kernels, wildcards submitted by user space are accepted yet
>   silently treated as regular names.
> * With old user space, wildcards submitted by kernel may cause crashes
>   since libnftnl expects NUL-termination when there is none.
> 
> Using a distinct attribute type sanitizes these situations as the
> receiving part detects and rejects the unexpected attribute nested in
> *_HOOK_DEVS attributes.
> 
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")

Why is this not targeting net? The sooner we adjust the uAPI the better.
