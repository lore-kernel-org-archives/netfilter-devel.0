From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] ctnetlink events drop benchmark
Date: Wed, 14 Jun 2006 09:44:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0606140914220.32191@blackhole.kfki.hu>
References: <448ED2DD.30100@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <448ED2DD.30100@netfilter.org>
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

Hi Pablo,

On Tue, 13 Jun 2006, Pablo Neira Ayuso wrote:

> Finally, I've got some results in my test enviroment about the ctnetlink
> event drop issue. The machine used as firewall is a PIII 866 256 Mbytes
> RAM, two NIC realtek 8139 100Mbits running debian unstable with linux
> kernel 2.6.16.
>
> I have run the same test with three different socket queue sizes:
> 107.520 (default)
> 215.040 (x2)
> 430.080 (x4)
>
> I used netperf to create the connections with a shell script that loops
> calling netperf -H ip -l 3 &.

How can you control the connection rate (i.e NEW events) by netperf?

> To get the number of events dropped I've used the following:
>
> $ conntrackd & (run as daemon)
> $ conntrackd -s (request statistics)
>
> Results are available in:
>
> http://people.netfilter.org/pablo/ctnetlink/events.eps

The results are pretty shocking! One would expect (hope) higher event rate
without event dropping :-(.

> Currently nlmsg_seq is not set in ctnetlink events, if we set it, we can
> do some kind of sequence tracking on netlink. If an event gets lost, we
> can request a resync with the conntrack via dump_conntrack.

Isn't that overkill? I mean, it'd result even more traffic and thus more
packet loss.

> Another choice could be relax conntrackd states transitions, currently
> the valid transition sequence is: NEW -> UPDATE -> DESTROY, if an UPDATE
> event is received but no NEW was seen previously, then the event is
> ignored. Maybe this is too tight, but since I'm validating the whole
> thing I prefer remaining "tight" at the moment.

As I see it does not improve the performance over netlink: the message is
already received by conntrackd.

Can we generalize your results and state that (ct)netlink can handle (on
the given hardvare) max 500-1000 messages/s?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
