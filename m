From: jamal <hadi@cyberus.ca>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 27 Sep 2004 22:41:17 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096339276.8660.30.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040927133904.GP3236@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald,

On Mon, 2004-09-27 at 09:39, Harald Welte wrote:

> I totally agree with you, jamal.  And in fact this is exactly what we
> have.  You tell one box it is master, and it becomes master.   You tell
> a box it is slave, and it becomes slave.
>
> There is just a minor addition in one case, where we want to safeguard
> against a (currently) invalid mode of operation.  As soon as ct_sync
> supports multiple master, this safeguard will certainly be removed.

So if understood correctly the issue is as described by Krisztian:

On Mon, 2004-09-27 at 09:30, KOVACS Krisztian wrote:
> The main problem is with NAT and preserving the uniqueness of
> tuples in the whole cluster, and unfortunately this would make a lot of
> things much more complicated. So, even if the protocol would be
> completely multi-master compatible ct_sync would be capable of
> single-master operation.

If you have two machines A and B, assuming they are symetric (exactly 
same internal and external IPs) then i should be able to send state from 
A->B and B->A and have both B and A updated (if such state doesnt exist).

With above if i decide i want to have two nodes as master, they both
generate and accept state update messages.

> But for the current code, unless somebody shows to me that it severely
> limits some use of ct_sync, or it causes practical problems, I don't see
> why we should remove this safeguard.

As i see it you need 3 states:
Master - accepts and generates sync messages
slave - only accepts syncs
init - unknown; does neither

If you didnt have this safeguard then i should be able to achive
master/master on two nodes (even if for starters i assume symetric
setup). ct_sync in itself should not attempt to be too smart and have a
built-in protocol IMO - there is no point in reinventing the wheel;
people have spent years researching HA protocols, good idea to just use
that.

cheers,
jamal
