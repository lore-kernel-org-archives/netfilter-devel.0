Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068230;
	b=EOKyfZ1gXz5LPG8Kp3r0OEym070wz94SlKLuBSV71k+vrJZqc886hWHDo34vGZXQAqDw
	 6kveaxfDGBkTyt8qhf2OK9/RAvBhByTu7rEGcGfQqgUxo3ZsSqKlEg4aGCgtRd6I6m4fo
	 TmAt7Ugmye0Nz1vOnzrnCHBAbbERQ+tSHBL5yK+Jm3ZFsKOxWgRUiOTdiQ2ahc6c6iOPy
	 Z6oe3Vs4l2V0UsuCcBMAP8clCbGBmrMb6cwkBw9wZsENp5AFTyRMB2GoY3VlClSJA5XGT
	 Md3o9YdNgUaAia7JO3LRu1aTKM+AJfnhcNur10GHvAjx156+rE6xePNWLNUl0JVa3Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068230;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=++Y4t3I2LxFieW0DE+Iv+aWRaMn7lkMaXY5hYUyoqnY=;
	b=mKlMAe+CDBFwTnsLkiVyJwBBFOFIWtWdl8s668VQ9gvX2e65ca4ArdqtL2/WC7fMQ2eR
	 XbC4CN0t/pCVI6kx1bjbOFEfLUFRXhGXpZMPta2YR5uJ3nQXw31sUckVSxMNYx+tkm6gZ
	 8sAaBwmDlwQfMBcyFGl/t9UGTOUUHhJLIiPy+AVn168tGyymeqS03uYrWbW6iG7jVcLHj
	 FQkwPHwkwf+WuULY5huaqgwEuecwcdoqE4vBUx59SwX34Y+lUQVinMJTmvqmmLQdDlj6d
	 UBFfFigc3TFtWwC0/yqsqTlr+yU/UMC+7EeX5HTLJE3YhOhPX0qGxj5h5Vzbcfe01eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCB606D834;
	Sat,  7 Nov 2026 16:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7BCB606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A1460609FC; Sat, 07 Nov 2026 17:17:00 +0100 (CET)
Date: Sat, 7 Nov 2026 17:17:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Tamaki Yanagawa <ty@000ty.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: unclone skb before
 writing NFQA_L2HDR
Message-ID: <au9O_KyLej8ckT5V@strlen.de>
References: <20261107160517.726-1-ty@000ty.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107160517.726-1-ty@000ty.net>

Tamaki Yanagawa <ty@000ty.net> wrote:
> nfqa_parse_bridge() copies the NFQA_L2HDR attribute over the mac header
> of the queued skb in place. Bridge flooding queues clones that share
> their data with the copies sent to the other ports, so the rewritten
> header also shows up on frames that never went through the queue, and
> is changed while those may already be in transmission. Unclone the skb
> before the copy, as nfqnl_mangle() does for NFQA_PAYLOAD via
> skb_ensure_writable().

Can you explain in changelog why full unclone is needed rather than
skb_ensure_writable()?
