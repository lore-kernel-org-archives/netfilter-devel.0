Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BF23793D1;
	Mon, 12 Jan 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238514; cv=none; b=jdjvR9ZxNQEmFAL7DXr1MQbAoe1GGqDwKiUNL/Cx+yamDlIJfZVS619ubcMWqTO/hCKaEipa7JMTvCp4cNTlCgR2InNf6NHMEqT6GRk9auQQuhLiEYXGpAdysux8jut19QwHUNlLYlZF13fBqcw4U4Hr86bQ6ovKUx1e6o/Wbho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238514; c=relaxed/simple;
	bh=FriJ77hn49zbC4lpZfOzwpyItW5/S8uMxDg26uaH/KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtSH+vQ/syuKm1KYGEV426e4ktskHEBkNSx39sjOA+zWJm+DntOp9aRAHT2+9rbToq+TARscbvsBOYnGUO13CT8cm8pK+SZjuO/SHuKVoNDpSSmZFPXIs9o2BYo0woeGQA8sW0wGlIW3NvHchTPvMLuzdlwad63k5toSnoaxEHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0329C607AC; Mon, 12 Jan 2026 18:13:52 +0100 (CET)
Date: Mon, 12 Jan 2026 18:13:52 +0100
From: Florian Westphal <fw@strlen.de>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-riscv@lists.infradead.org, linux-m68k@lists.linux-m68k.org,
	linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [RFC PATCH 0/5] net: make config options NF_LOG_{ARP,IPV4,IPV6}
 transitional
Message-ID: <aWUr0MpAaoPDED-f@strlen.de>
References: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112125432.61218-1-lukas.bulwahn@redhat.com>

Lukas Bulwahn <lbulwahn@redhat.com> wrote:
> Once the general approach and patches are accepted, I plan to send some
> further patch series to transition more net config options. My current
> investigation identified that these further config options in net can be
> transitioned:
>
>   IP_NF_MATCH_ECN -> NETFILTER_XT_MATCH_ECN

[..]

Plan LGTM.

In case you'll target net-next tree for patches 1 and 2:

Acked-by: Florian Westphal <fw@strlen.de>

I can also take them via nf-next if you prefer.
