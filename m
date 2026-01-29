Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DD3803DD;
	Thu, 29 Jan 2026 10:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769681337; cv=none; b=jeN/qkQoGiNaXejrUaAQdKBy6s3GbaC49VaB8rhXJHEqpCYQ0EP0ubz1ScDL7wYNDTN/QZJtjnJO0qa0e/8jXq/IKJ2wd5RRS3Pay620Vta7nUTm/nkzNPt+QTlvgCLZ2oIPiBMlkOSeYd0AHV680Y0p90G3Oxmxz4G/Sg+iDQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769681337; c=relaxed/simple;
	bh=llqbl1StBfL0xh5LU1kWvQbwuFYFuUEBq6UQdB4VAC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPVjrG+pQpr8t+6mGyqqtR4pYanKefxc9DAGjbYh52wEDZ6DVJszh2/NhVlwiZ0gkscLcnCUWwpkf+Rx0wXorELWsnYu+SW24WotWvhQS7Wzato+VLjPApCxvUv/YWlKVkp3yIpOMERETwxs+ErlTWsyMICXdLB9EOJV9qt3hZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45F8360516; Thu, 29 Jan 2026 11:08:53 +0100 (CET)
Date: Thu, 29 Jan 2026 11:08:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 0/9] netfilter: updates for net-next
Message-ID: <aXsxr8KQGFOhnLIa@strlen.de>
References: <20260128154155.32143-1-fw@strlen.de>
 <20260128210313.787486ba@kernel.org>
 <aXsgxfHxTEU1_k6e@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXsgxfHxTEU1_k6e@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > [  580.340726][T19113] sctp: Hash tables configured (bind 32/56)
> > [  601.749973][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  601.985349][    C2] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  602.191750][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  602.555469][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  602.895890][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  603.226543][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  603.435907][    C0] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  603.569421][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  603.672454][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  603.821679][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> > [  618.553975][T19316] ==================================================================
> > [  618.554200][T19316] BUG: KASAN: slab-use-after-free in nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
> > [  618.554424][T19316] Write of size 1 at addr ff1100001cc9ae68 by task socat/19316
> > [  618.554600][T19316] 
> 
> Did not occur here during local testing :-(
> 
> Should I send a v2 without the last two patches or will you pull and
> discard the last two changes?

Alternatively you can also pull this:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-01-29

Which is the same series but without the last two patches, i.e. up to
e19079adcd26a25d7d3e586b1837493361fdf8b6:

  netfilter: nfnetlink_queue: optimize verdict lookup with hash table (2026-01-29 09:52:07 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-01-29

----------------------------------------------------------------
Jinjie Ruan (1):
      netfilter: xt_time: use is_leap_year() helper

Lorenzo Bianconi (5):
      netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
      netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
      netfilter: flowtable: Add IP6IP6 rx sw acceleration
      netfilter: flowtable: Add IP6IP6 tx sw acceleration
      selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest

Scott Mitchell (1):
      netfilter: nfnetlink_queue: optimize verdict lookup with hash table

6 files changed, 408 insertions(+), 81 deletions(-)
