From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 00/14]: netlink: memory mapped I/O
Date: Wed, 17 Apr 2013 21:40:46 +0200
Message-ID: <20130417194046.GF1408@breakpoint.cc>
References: <1366217229-22705-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1366217229-22705-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy <kaber@trash.net> wrote:
> The following patches contain an implementation of memory mapped I/O for
> netlink. The implementation is modelled after AF_PACKET memory mapped I/O
> with a few differences:

[..]

> Following are some numbers collected by Florian Westphal based on a
> slightly older version, which included an experimental patch for the
> nfnetlink_queue ordering issue.

I'd like to see a comparision with Eric Dumazets nfnetlink_queue zerocopy
patch [ ae08ce0021087a5d812d2714fb2a326ef9f8c450, netfilter:
nfnetlink_queue: zero copy support ].

The nice thing about that patch is its transparency to userspace, and
the avoidance of the 'nfnetlink_queue packet reordering' issue.

Sorry :)

Another issue with mmap is the need to preallocate the ring frame size.
After the gso avoidance change [ no skb_gso_segment calls anymore ],
we will need to be able to queue GSO/GRO skbs, which makes it necessary to
cope with 64k payload in the mmap case...

Cheers,
Florian
