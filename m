From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 10:50:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608240940130.8098@blackhole.kfki.hu>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<44EBE13E.9020605@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44EBE13E.9020605@trash.net>
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

Hi,

On Wed, 23 Aug 2006, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > My views on how to communicate is a little bit old-fashioned as I'm
> > perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
> > but a hack. But reliable, which cannot absolutely be said about netlink.
> > I shudder to think about the situation when a DDoS attack could prevent or
> > just delay me to reconfigure a firewall. And please note even if we accept
> > delaying it assumes that we are willing to face reimplementing a TCP-alike
> > protocol over netlink to guarantee reliable message passing.
>
> I don't think a DoS attack could prevent you from using netlink any
> more than it could from setsockopt (netlink is even more efficient due
> to less data copied around).

What makes me uneasy is that we want to control the network traffic (do
firewalling) over a protocol which is managed by the network core itself.
Somehow it hurts compartmentalization.

> Reliability is not hard to achieve on the userspace->kernel path if you
> don't mind eating one RTT for each rule update (which is not very
> large), just send the update and wait for an ACK or an error, then
> handle it.

And how should the error be handled? Re-send the same request immediately
and thus hammering the system? Or should we use a linear/exponential
backoff? :-) What if it's a RESTORE operation and we are in the middle of
adding thousands of rules to the kernel. Should we then implement
transactions and all successfully added rules be removed in the case of a
fatal failure? (Allowing multiple alternate tables can solve it of
course.)

> Having more than one message in flight introduces another problem
> besides congestion control and reliable transmission, the resulting
> ruleset in the kernel might depend on the order in which messages are
> received, if messages are dropped in the middle and are simply
> retransmitted it will be wrong. This should probably not be done.

Yes, to handle that would be halfway toward TCP :-)

> > Yes. And I'd add one more priciple:
> >
> > + All parts must be designed to take into account rule- and
> >   (match/target) state-replication between firewalls in active-active
> >   setups.
>
> Agreed, that would be nice to have (and not very hard).

+ Match/target versioning support, i.e. be able to specify
  version-dependent features. That might require OR operation
  support at some level in one rule:

# Handle two versions of the same module:
-m foo --foo-version 2 <flags 2> --OR --foo-version 1 <flags 1>
# Handle new or possibly missing module
-m bar --bar-version 1 <flags 1> --OR --false|true|fatal-error|ignore-rule

Interesting question is how to handle such rules in the kernel, taking
into account that we want the 'SAVE' operation to work correctly.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
