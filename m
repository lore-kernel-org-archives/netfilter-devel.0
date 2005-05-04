From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 04 May 2005 13:30:02 +0200
Message-ID: <4278B23A.7050406@trash.net>
References: <424747E3.7000300@eurodev.net>
	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>
	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42789366.20702@ufomechanic.net>
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

Amin Azez wrote:

> It is entirely possible that a new conntrack with the same tuples is
> created before the user program can be aware the old one has been
> destroyed.
> 
> Defining multiple successive connections as "one flow" is convenient,
> but as user space clients are notified of "interuptions and
> restorations" to this "one flow", it would be also convenient if they
> could safely take advantage of such notifications.

Agreed. Besides, this is an interface to conntrack, not flowtrack :)

> If an ID is not desirable as part of the tuple (and I can see that it is
> not) perhaps a "created time-stamp" per conntrack would suffice as an
> extra "guard" which MAY be provided to conntrack manipulation routines,
> and if so provided MUST also be satisified for the operation to take place.
> 
> That is my suggestion. It does not introduce an alternative ID, it does
> avoid the problem of race conditions.
> 
> Comments?

Why is that better than a unique ID? It needs space as well, but can't
be used to identify the conntrack without further information.

Regards
Patrick
