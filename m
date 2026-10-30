Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370960;
	b=NMST/zKRY+URysrqaQIYkf8R0ieRCA3+R9AwCxz8cg2HAnJ52akppev7RPkh/ooci3aC
	 nmqjGqRsLB32XwXqaDbqk0dhnK60g4PwvTealnfnOVcYg9gsAHFB5RnzViihbeGdPcZEg
	 h6e1TfiQL2V1VXil+M2pVb91HNUcof/vxcRtoyWv7jf3ZappLBJ4mX6DF5q5O6EUhSdT2
	 s9v7kW0hTGtdpiWEY0pzXf9vYCynB/CQqcKrAXEARDlA/f0Czg0DkyAYYZR6UE2+TsESL
	 r/iwpuA8AID57VxZ2gwZQyy3HXag4l7iY3PFdgzoAn872gvmCIqqIalrRHKDlaDsGZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370960;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2GKiJkYacpCHnStSv1ZmJOMTaI15yMxyL8nBonbW1bw=;
	b=BSjJQ/1gwPRx+oYJIuzcExaCoLhsrSy73w8iKGQp1qnw8+W2sEDQYJJPdE75DVLt3sYT
	 pEb9K61ebW8frrs2HNB/H7OQX1qebr9eYz+UucL8fzRC6LKHUTXJJ9md/xuXcl4R1o1y/
	 V7UXFClsvam46i5CNUCV9Ob41GMQikAw042F9sHfPtqKdlXNmlPQpSkUqa45so1xO2d3u
	 9dLTTGlxHq+niNAvqXpAH34gdHoYhqb3is7KOSBQ3n8tAT8/h8+vnkBKtfn+0TI3oZtwt
	 TqoRFiJ4gcrH43NL4KtBO96YbuhWJ+hKTEN2NK0Qr+IYqhkvAgz7xjQ/FdtqqBNvmtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4731606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 14:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4731606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 02A49603A1; Fri, 30 Oct 2026 15:35:56 +0100 (CET)
Date: Fri, 30 Oct 2026 15:35:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership
 when expanding skb
Message-ID: <auSrTEnc8tibSGs2@strlen.de>
References: <20261030135750.4452-1-fmancera@suse.de>
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
In-Reply-To: <20261030135750.4452-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
> grows a packet beyond its tailroom. skb_copy_expand() does not copy
> skb->sk, so the replacement is unowned and freeing the original drops
> its socket memory charge.
> 
> The expanded packet is no longer associated with the process that sent
> it. Therefore xt_owner or xt_cgroup and other socket based matches in
> later rules no longer matches and a later NFQUEUE reports no uid/gid. In
> addition, the expanded packet's memory is not counted towards the
> sender's SO_SNDBUF limit, so the sender can keep producing them while
> they sit in a queue.

A proper fix requires wmem/truesize fixups and will have to deal with
wmem-accounted vs. non-wmem accounted.

I dont think its worth fixing this, there are many other ways to
get OOM when you have CAP_NET_ADMIN.
