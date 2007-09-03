From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 3 Sep 2007 12:15:04 +0200
Message-ID: <20070903101504.GI18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<46DBD8CD.9060804@trash.net>
	<20070903100148.GG18480@postel.suug.ch>
	<46DBDCBB.8080903@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DBDCBB.8080903@trash.net>
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

* Patrick McHardy <kaber@trash.net> 2007-09-03 12:06
> Thomas Graf wrote:
> > I think I can live with checking for the bit on the receiving side,
> > the only problem it could cause is when the attribute type is used
> > to encode information such as a port number. So if we are willing
> > to take that risk the receiving path could be merged as well.
> 
> 
> That kind of information should be stored as attribute value, no?

Yes it should but we've already got code like this:
for (i = 0; i < cnt; i++)
        nla_put(skb, i, ....);

It's only a matter of time until someone comes up with
something like this:
nla_put(skb, dstport, sizeof(port_info), &port_info);

Maybe we could put a WARN_ON(bit_set) in nla_put() on kernel side
to make sure such behaviour is not being introduced by accident.
