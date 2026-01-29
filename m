Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80823D2A3;
	Thu, 29 Jan 2026 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769677004; cv=none; b=M6NlbFszozrWdDvhR4NpI1RckhFkJ9YWKckjpu6l3H+x3VJRceVvVvRE1JAXbkvWEuLiddnrmOn38raiuowbELOSDoJOedSJMv/Q9obnrCpmY5HyCGl6oDVaYOSjFx8Mtt6IJVxIBXaEdDPorBx15QqobC5T6u80dF33dJ6aPlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769677004; c=relaxed/simple;
	bh=ToC0hayZ5RUXa0lLgtH80BGH2DNYKPCwzBgqHsrG5OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9OT0LnJPUXzBYbAC6z0n/UDdzh/XfgWFUxhNZbkNwcBxVYrR6KyWBwdSkW3rSDQL83IRwEfTeYribniSm3WqZzjsFskWpc9IzXRa0FNJBtdCi/KoJqafJX8i5KTmVfsV00R3HbQONw+nT7YPKmr0XyFsbiGDyoIcYIiPlmUDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3114F603A1; Thu, 29 Jan 2026 09:56:39 +0100 (CET)
Date: Thu, 29 Jan 2026 09:56:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 0/9] netfilter: updates for net-next
Message-ID: <aXsgxfHxTEU1_k6e@strlen.de>
References: <20260128154155.32143-1-fw@strlen.de>
 <20260128210313.787486ba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128210313.787486ba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 28 Jan 2026 16:41:46 +0100 Florian Westphal wrote:
> > Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
> > infrastructure.  Patch 5 extends test coverage for this.
> > From Lorenzo Bianconi.
> > 
> > Patch 6 removes a duplicated helper from xt_time extension, we can
> > use an existing helper for this, from Jinjie Ruan.
> > 
> > Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
> > verdict processing.  Before this list walk was required due to in-order
> > design assumption.
> > 
> > Patch 8 fixes an esoteric packet-drop problem with UDPGRO and nfqueue added
> > in v6.11. Patch 9 adds a test case for this.
> 
> Hi!
> 
> There's a UAF in the CI:
> 
> https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/494261/vm-crash-thr0-0
> 
> [  580.340726][T19113] sctp: Hash tables configured (bind 32/56)
> [  601.749973][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  601.985349][    C2] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  602.191750][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  602.555469][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  602.895890][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  603.226543][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  603.435907][    C0] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  603.569421][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  603.672454][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  603.821679][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
> [  618.553975][T19316] ==================================================================
> [  618.554200][T19316] BUG: KASAN: slab-use-after-free in nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
> [  618.554424][T19316] Write of size 1 at addr ff1100001cc9ae68 by task socat/19316
> [  618.554600][T19316] 

Did not occur here during local testing :-(

Should I send a v2 without the last two patches or will you pull and
discard the last two changes?
