From: Patrick Schaaf <bof@bof.de>
Subject: Re: MAC address matching. Or other ideas.
Date: Sat, 10 May 2003 12:59:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030510105942.GB28426@oknodo.bof.de>
References: <3EB5A38C.4090606@dev-zone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel <daniel@dev-zone.org>
Content-Disposition: inline
In-Reply-To: <3EB5A38C.4090606@dev-zone.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Is it possible to get the MAC match module to match on dst MAC address 
> rather than just src MAC?

Not without much much work. The destination MAC is not known, generally,
while the packet traverses the network stack; only on output, after
a potentially long time waiting for an ARP reply, will a destination
MAC be available for checking.

You could, maybe, be lucky to have it in the POSTROUTING table. But I
doubt that.

> So I want to be able to say only gimme traffic that is coming in and
> out via gateway X, the only way I can figure to do that is by matching
> the MAC address of the gateway,

Why not the IP address of the gateway? That is known after routing,
i.e. in both the INPUT and FORWARD chains, and a 'route' match
is trivial to write, as far as I know. There is already a nice
ROUTE target in patch-o-matic, such a route-match could A) be
patterned after the target (take the same options), and it
could B) look at the exact same structure (skb->dst) that the
ROUTE target sets up. Nice mirror work.

If that's a solution for you, and you set out to implement it,
just mail me if you have detail questions.

best regards
  Patrick
