From: Evan Harris <eharris@puremagic.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Tue, 28 Oct 2003 07:44:19 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310280743051.1312-100000@kinison.puremagic.com>
References: <3F980FE5.1000108@Loudoun-Fairfax.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeffrey Laramie <JALaramie@Loudoun-Fairfax.com>
In-Reply-To: <3F980FE5.1000108@Loudoun-Fairfax.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


The PREROUTING chain is only traversed for packets being forwarded through a
host, not locally generated connections.  According to the docs, in order to
DNAT local conns, it must be done in the OUTPUT chain.

Evan


On Thu, 23 Oct 2003, Jeffrey Laramie wrote:

> Evan Harris wrote:
>
> >Ok, I've upgraded to kernel 2.4.22, and the same behaviour is being
> >exhibited.
> >
> >To recap the problem:
> >
> >Packets being nat'd on the OUTPUT chain of a machine are still being sent on
> >the same interface they would have without the nat, and ignoring the route
> >that aims them to the right iface for that dest addr.
> >
> >Evan
> >
> >
> >
>
> I haven't seen the rest of this thread, so I may have missed something,
> but why are you doing DNAT on the nat OUTPUT chain? DNAT is usually done
> on the nat PREROUTING chain and SNAT on the POSTROUTING chain. Anything
> done in filter OUTPUT, mangle POSTROUTING, or nat POSTROUTING could
> change the direction of your packets before they leave your host.
>
> Jeff
>
>
>
