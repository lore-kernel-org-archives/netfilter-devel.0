From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNL_NFA_NEST
Date: Wed, 21 Mar 2007 23:54:14 +0100
Message-ID: <4601B796.5030100@netfilter.org>
References: <4600BDBB.8020205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4600BDBB.8020205@trash.net>
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

Patrick McHardy wrote:
> One of the worst mistakes in nfnetlink in my opinion was the
> introduction of the NFNL_NFA_NEST bit. It prevents us from
> using a large part of the generic netlink stuff, since that
> just interprets it as a really huge attribute type. Since
> its not used even for anything, this is really annoying.

I'm using this bit to convert attribute headers from host byte order to
network byte order in conntrackd. I'm unsure about how I would do the
conversion if we remove such bit.

> Unfortunately there is no easy way to get rid of it, current
> userspace code sends it to the kernel, so even if we stop
> including it in the kernel, we need to deal with it for
> compatibilty.

We have a field in the nfnetlink that contains the protocol version that
we can use for this kind of changes without breaking backward.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
