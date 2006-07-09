From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: early_drop() not working correctly?
Date: Sun, 9 Jul 2006 17:06:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0607091658070.11722@blackhole.kfki.hu>
References: <44AD1D10.6000208@netboxblue.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
In-Reply-To: <44AD1D10.6000208@netboxblue.com>
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

On Thu, 6 Jul 2006, Menno Smits wrote:

> At one customer site we have a situation where a netfilter box sees half
>   of some connections due to asymmetric routing.

As it was already written, conntrack cannot reliably work in such setups.

> This causes lots of ESTABLISHED but unreplied connections to fill the
> conntrack table with long (5 day) timeouts. Eventually the table
> completely fills up. The "nf_conntrack: table full, dropping packet"
> message is reported, packets
>   are dropped and the customer starts complaining.
>
> According to discussions with Patrick McHardy off list and my own
> examinations of the code, early_drop() should free up some of the
> conntrack table when the table is full by removing unreplied
> connections.

If you have got a pretty flat hash table (large hashsize parameter), then
early_drop has got bad chance to find any unreplied connection in the
given bucket. If you set hashsize relatively small (compared to the usual
traffic) then early_drop has got better chances but it hurts the
performance. I believe there is only bad and worse solutions to your
problem.

> In practice, this doesn't actually happen.

Sorry, but I think there should be more facts which supports your
assumption.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
