From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: GnomeMeeting STUN
Date: Fri, 2 Jan 2004 20:37:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401022037.24303.lists@ohlmeier.de>
References: <1072260947.722.25.camel@golgoth01> <20031224143851.GD941@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>, Damien Sandras <dsandras@seconix.com>
In-Reply-To: <20031224143851.GD941@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

On Wednesday 24 December 2003 15:38, Harald Welte wrote:
> On Wed, Dec 24, 2003 at 11:16:14AM +0100, Damien Sandras wrote:
> > I have a few questions for you if you don't mind. You probably guess
> > that getting gnomemeeting (and voip apps in general) behind a NAT
> > gateway is hard for average users for which even port forwarding is
> > hard.
>
> yes, unfortunately those protocols are not very NAT friendly.
>
> > Cisco has come up with a solution called STUN, I suppose you know what
> > it is. GnomeMeeting could get STUN support soon, but Linux Nat appears
> > as being of type "Blocked" (RFC3489).
>
> The Linux >= 2.4.x implementation of NA(P)T is what the IETF tends to
> call 'fully symmetric NAPT', i.e. the most sophisticated version of
> network and port address translation.

The detected NA(P)T type depends on various factors. How long are the bindings 
in connection tracking and how fast/often the STUN clients retry to check 
their status. How many STUN clients are used behind the NAT.

> With old, 'more stupid' NA(P)T implementations in ipfwadm and ipchains,
> you would be able to do STUN.

You are able to do STUN behind any type of NA(P)T. Only the detection results 
and depending on that the choices on how you can proceed are diffenrent :)

> So it seems like linux is too advanced for the tricks that STUN tries to
> do.

Yes, STUN works well if you are sitting behind one of these small hardware 
boxes, because the experiences shows that most of them are 'full cone 
NAT' (which means an IP port combination on the NAT box accepts pakcets from 
any IP or port combination for this destination and delivers it to the 
private destination).
But with netfilter and if i'm not wrong with the BSD's STUN is no help (except 
that you can detect that you are lost :)

> netfilter/iptables would AFAICT interoperate quite well with what the
> ITEF MIDCOM people are designing, though.

If it ever gets launched.

> > So my question is: is there a way to make Linux NAT gateways work with
> > STUN?
>
> No, I honestly don't see any way.
> The fundamental principles behind the iptables NAT design are:
>
> 1) try to change as little information as possible
> 	i.e. we only do NAT as long as it is possible. port numbers
> 	 are only changed if absolutely necessarry.  Also, as opposed
> 	 to ipchains, you cannot tell that NAT is used just by looking
> 	 at the source port numbers.
>
> 2) try to use as little resources as possible
> 	this especially means that any given (srcport,srcip) tuple
> 	at the NAT gateway can be used for many different connections,
> 	as long as the (dstip,dstport) tuple differs
>
> 3) provide as much 'security' as possible
> 	we get this for free if we do '2)'.  This means we don't accept
> 	any incoming reply packets from a differnet srcip/srcport than
> 	the original request was sent to.

The best solution at the moment for 'symmetric NAT's' like Linux seems to be 
media relay in the public internet.
To be able to live just with STUN you had to change Netfilter back to the more 
"unsecure"  'full cone NAT' as with ipchains. Which will probably rejected by 
the Netfilter team :)

Greets
  Nils
