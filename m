From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fw: Fw: [Bugme-new] [Bug 4180] New: masquarade and source ip
Date: Tue, 08 Feb 2005 13:21:31 +1100
Message-ID: <1107829291.19407.9.camel@localhost.localdomain>
References: <20050207114212.024a09bb.davem@davemloft.net>
	<4207CC76.8040500@trash.net>
	<20050207121425.53c34af2.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: spied@yandex.ru,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050207121425.53c34af2.davem@davemloft.net>
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

On Mon, 2005-02-07 at 12:14 -0800, David S. Miller wrote:
> On Mon, 07 Feb 2005 21:15:50 +0100
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > >Didn't this get changed on purpose?
> >
> > Yes. One thing we could do to make it more consistent is treat
> > local packets the same way as forwarded ones in MASQUERADE, then
> > at least all packets would have the same source address. This check
> > currently prevents local packets from beeing masqueraded:
> > 
> >         /* FIXME: For the moment, don't do local packets, breaks
> >            testsuite for 2.3.49 --RR */
> >         if ((*pskb)->sk)
> >                 return NF_ACCEPT;
> > 
> > I'm not sure if we can simply remove it, maybe Rusty remembers :)

Remove it; nothing should break.  The network code used to hate local
packets getting changed, but we do the right thing these days (if not,
that's another bug).

> Ok, when you figure out what's going on please post the analysis to
> netdev et al., and in particular Andrew or Stephen, so the bugzilla
> can get closed properly.

We vastly simplified the masquerade code to use inet_select_addr(),
because its purpose is for dynamic links.  This user should be using
SNAT to specify exactly what he/she wants.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
