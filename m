From: Stefan Metzmacher <stefan.metzmacher@metzemix.de>
Subject: Re: [netfilter-core] [PATCH] add CONFIG_IP_NF_MASQUERADE_LOCAL
Date: Tue, 04 Feb 2003 10:01:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.2.20030204094217.021a5fd0@post.webmailer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

At 16:04 03.02.2003 +0100, you wrote:
>On Thu, Jan 23, 2003 at 12:16:24PM +0100, Stefan (metze) Metzmacher wrote:
> > Hi *,
> >
> > I have patches witch allow the masuerading of local packets.
> > Now support for DNAT of local packets are in the kernel.
> >
> > But somebody (like me) could need masuerading of local packets.
>
>why do you need MASQUERADE?  isn't SNAT enough?  and SNAT of local
>connections is supported by the stock linux kernel for a very long time.
>
>DNAT has been added  recently.

I need masquerading because I have some daemon's listening on 
internal(specified) ip's only and they(a squid and postfix,...) should only 
use this ip for all incoming and outging connections exept when they go 
through my dsl-link witch have a *dynamic* ip(then the connection should be 
*masqueraded*!)

I don't really understand where the problem is to not support masquerading 
of local packets...

you should only remove two lines of code
(witch where added because of an routing bug in 2.3.49 )

I have removed this two lines and run it since 2.4.3 WITHOUT ANY PROBLEM :-)

It would be nice if anyone could test it :-)

I would also accept when there is an option in make config to compile it in
or it could be the default.

Please help me, that I would not have to patch/compile kernels by myself 
each time...
so that I can simply use standart kernels.


>
> > Feedback please!!!:-)

It would be so great to get this in the standart kernel!
thanks for feedback:-)

>--
>- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/

-----------------------------------------------

Stefan Metzmacher

stefan.metzmacher@metzemix.de 
