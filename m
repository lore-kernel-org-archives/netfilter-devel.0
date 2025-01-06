Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3870824;
	Mon,  6 Jan 2025 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173393; cv=none; b=rlOQ7tXW7ZCVak7fXqfR2j1os78khJjEu27cwhLnnfHndknrNgcQ3wQrFGyA8aQ2l/knKQEfUoVBBnK/h4pSB8eV2+WRBppdOLMJPS5hCc6mQnYUcUpmewxoTQWVHIY4WAwfbtSeYvb3B7kFNyLRJRE1nFNFtB1ULlqQx8n08Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173393; c=relaxed/simple;
	bh=i+6K3vJDnr7FR2dA9iClxv0CSvajv1bK9AtmD8P8wC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLoX3mt93wB7TzfXpstPdDnMxtEi2VO1LE4mfPN2+gAEuLNZPulgeG6LzT8HrvdurWCQ0QAM/E8EUPlSqGZ0j+wQchW4CO1y9j1TE8CnQU5mlf6qWIsKwzc16Fyy+AYHMUBgTZnpQhHKrvsiyHox1aQ1+mNtCJp2QBKTB331PsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=iVLYD/Kn; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="iVLYD/Kn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=+FD+9HoUin/ZpvVGmFW+uUicRKdAkNZjtxAYPfqu2LI=; b=iV
	LYD/KnGz/He+gqCEGi9HsGndmb++3lsAwVKYNZ+Gvrn1hjA6x8DyrY9xU9kpdSxBKW7PEBuoIVRQM
	v0yiOe6NbOjlwUbp1AJ/gtEqH5cOZpdQL+YxZvt6CF4kdDg1oYtKPhQKPXoDSd2HT+cSQ61vc1lNE
	0cz1MH/5vNTNu5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tUo0L-001tjH-Pi; Mon, 06 Jan 2025 15:22:53 +0100
Date: Mon, 6 Jan 2025 15:22:53 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v7 2/3] netfilter: x_tables: Merge xt_*.c files which has
 same name.
Message-ID: <6f276b2e-de9d-427e-a3a3-aac9ed340357@lunn.ch>
References: <20250105233157.6814-1-egyszeregy@freemail.hu>
 <20250105233157.6814-3-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250105233157.6814-3-egyszeregy@freemail.hu>

On Mon, Jan 06, 2025 at 12:31:56AM +0100, egyszeregy@freemail.hu wrote:
> From: Benjamin Szőke <egyszeregy@freemail.hu>
> 
> Merge xt_*.c source files, which has same upper and
> lower case name format. Combining these modules should
> provide some decent code size and memory savings.
> 
> Merge licenses, codes and adjuste Kconfig and Makefile
> for backwards-compatibility.
> 
> test-build:
> $ mkdir build
> $ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
> $ make O=./build/ ARCH=x86 -j 16
> 
> x86_64-before:
> text    data     bss     dec     hex filename
>  716     432       0    1148     47c xt_dscp.o
> 1142     432       0    1574     626 xt_DSCP.o
>  593     224       0     817     331 xt_hl.o
>  934     224       0    1158     486 xt_HL.o
> 1099     120       0    1219     4c3 xt_rateest.o
> 2126     365       4    2495     9bf xt_RATEEST.o
>  747     224       0     971     3cb xt_tcpmss.o
> 2824     352       0    3176     c68 xt_TCPMSS.o
> total data: 2373
> 
> x86_64-after:
> text    data     bss     dec     hex filename
> 1709     848       0    2557     9fd xt_dscp.o
> 1352     448       0    1800     708 xt_hl.o
> 3075     481       4    3560     de8 xt_rateest.o
> 3423     576       0    3999     f9f xt_tcpmss.o
> total data: 2353

So you have saved 20 bytes in the data segment. A 0.8% reduction. If i
was developing this patchset, when i see this number, i would
immediately think, why am i bothering? It is not worth the effort for
the gains i'm getting. I'm also at risk of breaking the ABI and
userspace code, and 0.8% does not justify that risk.

This is why we ask for benchmarks. Benchmarks help to justify a
change. So far, there is no good justification for this.

    Andrew

---
pw-bot: cr


