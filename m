From: Patrick Schaaf <bof@bof.de>
Subject: Re: rp_filter
Date: Sat, 28 Dec 2002 10:17:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021228091730.GC440@oknodo.bof.de>
References: <20021227211113.GK677@ns>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20021227211113.GK677@ns>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen & all,

>   Can we *please* move the rp_filter cruft into the firewalling code
>   proper?

Upon thinking a bit more about your request, there is one thing
that annoys me about rp_filter, and where iptables may eventually
help: there was (and probably is) the idea of a DROP table, where
you can LOG packets coming from all kinds of drop sites within
the network stack. It would be great if I had a way to LOG packets
rejected by rp_filter. IMHO the big problem to the unwary end-user,
is the _invisibility_ of the drops caused by rp_filter.

A simple net_ratelimit()ed printk() in the appropriate place, would
already help a lot. If you walk your request over to linux-net, maybe
you could make that your fallback position :-)

best regards
  Patrick
