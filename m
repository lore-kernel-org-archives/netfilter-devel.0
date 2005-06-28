From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 05:53:22 +0200
Message-ID: <42C0C9B2.20704@trash.net>
References: <42C03F2E.30706@eurodev.net>
	<20050627202621.GY19928@sunbeam.de.gnumonks.org>
	<42C0AF26.1040705@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C0AF26.1040705@eurodev.net>
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

Pablo Neira wrote:
> Harald Welte wrote:
>>> - Implement ip_conntrack_stats dumping and reset (accounting)
>>
>> you want to dump the statistics via netlink?  i'm not sure whether that
>> is required.  lnstat is the only program using those counters, and using
>> /proc seems fine for that.
> 
> Could this be useful for accounting purposes? I mean, dump and reset as
> a single operation, something similar to conntrack -L -z, say conntrack
> -S -z.

I think it is convenient for anyone wanting to access these statistics
without parsing /proc to have everything accessible through a single
interface.

>>> - Implement get conntrack and destroy (accounting)
>>
>> sorry, what are you referring to?
> 
> An atomical operation to dump conntrack information and then destroy it.
> For example, if someone does:
> 
> conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp
> --orig-src-port 10 --orig-dst-port 20
> 
> the it sends the conntrack info and destroy it. This could be worth it
> for accounting.

destroy notifications are sent anyway, so we get the stats. What's the
difference to normal destruction?

> I could use multicast netlink subscrition, so the client can get
> subscribed to those events that the user considers interesting.

That sounds like the right thing to do.

Regards
Patrick
