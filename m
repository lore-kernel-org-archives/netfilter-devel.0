From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Wed, 16 Mar 2005 22:14:19 +0900 (JST)
Message-ID: <200503161314.j2GDEJLs013640@toshiba.co.jp>
References: <200503160648.j2G6mXVT014699@toshiba.co.jp>
	<42380204.5020201@eurodev.net>
	<Pine.LNX.4.58.0503161107160.9555@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net, kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.58.0503161107160.9555@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo and Jozsef,

> On Wed, 16 Mar 2005, Pablo Neira wrote:
> 
> > Yasuyuki KOZAKAI wrote:
> > > 	3. The symbol "ip_conntrack_untracked" which depends on ip_conntrack.
> > > 	   state, conntrack, NOTRACK use this symbol. How about defining
> > > 	   "void *nf_ct_untracked" in net/core/netfilter.c and
> > > 	   set &ip_conntrack_untracked.general/&nf_conntrack_untracked.general
> > > 	   to it when initializing ip_conntrack/nf_conntrack ?
> >
> > Something I have in mind. I think that we could use one of the bits of
> > nfcache explicitely mark invalid connections. If we get an invalid
> > packet, conntrack can set the NFC_INVALID bit. That way we interpret a
> > NULL pointer in skb->nfct as a untracked connection and kill that fake
> > conntrack.

If we kill the fake conntrack, ip_conntrack cannot decide the skb should be
tracked or not.

But using nfcache sounds good. Instead of NFC_INVALID, how about NFC_NOTRACK ?
If NFC_NOTRACK is set, ip_conntrack can figure out that's untracked skb.
And matches can distinguish between invalid skb and untracked one by checking
nfcache.

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Wed, 16 Mar 2005 11:13:57 +0100 (CET)

> When working on a conntrack-friendly TARPIT target, I added "general" glue
> function support in order to avoid unnecessary cross-dependency. Have a
> look at the attached patch.

That's useful for only NOTRACK target.
The symbol ip_conntrack_untracked remains in state and conntrack matches.

So I think that using nfcache flag is better in the current.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
