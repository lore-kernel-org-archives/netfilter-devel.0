Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB54266B2;
	Mon, 29 Jun 2026 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746604; cv=none; b=V2KwQxsCaCmCUJOro1pQ5L4YkNL7dPw0fgZmX5bp88gASkI0VG3L548+C1vuerJ94mRPsPNJb2eY8pC4iJCxCA2oghtzC5gefoCdvY3XcF005lBl/OdLdG1/wg+oNeww0JdyJMvP0vd4gNLecA+cPtO/ZxdbHhx1spLkqrePoPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746604; c=relaxed/simple;
	bh=buJd/u9F+wdKD3YLkBTjVFqrcSmXSGPZ5mhyiIdWO/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=glAkpymYTuCgBt27s6jcMb0K0XdO7qA1UiWnnU0SeAmMzbl/YMSseec8KxnczVyBvqv8HCfi8Wp8MOb/pSjMRYveCl/gOj7PD++mOh/LPLQmQSFkTMYPDKXBPpxBcvHs55CuCppVSk/tPVS5txOiFV/vXqDMmInLxAQmng/G1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 743DE60370; Mon, 29 Jun 2026 17:23:19 +0200 (CEST)
Date: Mon, 29 Jun 2026 17:23:13 +0200
From: Florian Westphal <fw@strlen.de>
To: xietangxin <xietangxin@h-partners.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	gaoxingwang <gaoxingwang1@huawei.com>,
	huyizhen <huyizhen2@huawei.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
Message-ID: <akKN4cywAsFRdefX@strlen.de>
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629093408.3927103-1-xietangxin@h-partners.com>

xietangxin <xietangxin@h-partners.com> wrote:
> Problem observed in Kubernetes environments where MASQUERADE target with
> --random-fully is configured by default. after commit
> 165573e41f2f ("tcp: secure_seq: add back ports to TS offset") TCP short
> connection QPS dropped from ~20000 to ~10000. This added source and
> destination ports into TS offset calculation.
> 
> However, with MASQUERADE --random-fully, when multiple internal connections
> (e.g sport 10000,20000) are mapped to the same external port (e.g 30000),
> their TS offsets are calculated as ts_offset(10000) and ts_offset(20000).
> If the server reuses the TIME_WAIT slot from the first connection, there is
> a chance that ts_offset(20000) < ts_offset(10000), breaking TSval
> monotonicity for the same 4-tuple and causing RST packets:
>   Client -> Server 24870 -> 80 [SYN] TSval=2294041168
>   Server -> Client 80 -> 24870 [ACK] TSecr=2846236456
>   Client -> Server 24870 -> 80 [RST] Seq=855605690
> 
> After nf_nat_setup_info() successfully assigns a new randomized
> source port, recalculate the TS offset using the new port and
> update the SYN packet's TSval accordingly.

I don't think this is related to masquerade but to snat (port address
rewrite) in general.

I think you could place your new helper in nf_nat_core.c and call it
from nf_nat_l4proto_unique_tuple() once we've found a usable tuple:

 668 another_round:
 669         for (i = 0; i < attempts; i++, off++) {
 670                 *keyptr = htons(min + off % range_size);
 671                 if (!nf_nat_used_tuple_harder(tuple, ct, attempts - i))

	 		     ... here.
 672                         return;
 673         }

