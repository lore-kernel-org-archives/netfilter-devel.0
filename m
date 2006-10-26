From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Thu, 26 Oct 2006 00:59:36 -0300
Message-ID: <c0db55360610252059s5eeaebdal27883badce704fa4@mail.gmail.com>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<4534309F.8000200@netfilter.org>
	<c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
	<1161093912.20036.3.camel@localhost.localdomain>
	<c0db55360610171732nfcd4118mfd89cea1c1aad457@mail.gmail.com>
	<45363E4C.4030201@netfilter.org>
	<c0db55360610230631u4acce3bft3f020916341caf0f@mail.gmail.com>
	<1161632812.5359.8.camel@localhost>
	<cd08d610610241621o12c67455rf0c3a7778f6b6f7f@mail.gmail.com>
	<1161757870.11648.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eric Leblond" <eric@inl.fr>
In-Reply-To: <1161757870.11648.9.camel@localhost>
Content-Disposition: inline
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

Hello,

On 10/25/06, Eric Leblond <eric@inl.fr> wrote:
> Hi,
>
> Le mardi 24 octobre 2006 =E0 20:21 -0300, Luis Floreani a =E9crit :
> > On 10/23/06, Eric Leblond <eric@inl.fr> wrote:
> > >
> > > Let's say port knocking is 4138 2345 4577 to open port 22
> > >
> > > Then just do
> > > iptables -A INPUT -p tcp -m multiport --dports 4138,2345,4577,22 -j Q=
UEUE
> > >
> > > Your userspace application wait for packets coming from queue, drop t=
hem
> > > when they come from knocking ports (but store the knock) and accept
> > > packet to port 22 if we just had a correct knocking sequence before.
> > >
> > > This is simple, do not use complex algorithms and should fit on all
> > > small routers.
> >
> > The idea of having an userspace application receiving the queued
> > packets from netfilter is much better than scanning firewall logs.
> >
> > Actually, I see this issues in the userspace solution:
> >
> > 1. (+) Could be safer to run the portknocking logic in userspace,
> > rather than kernel.
> > 2. It is not clear from a admin point of view that a portknocking
> > system is running.
> > 3. The port 22 traffic is suffering a small penalty because of
> > travelling kenel->userspace->kernel before arriving to the service.
>
> By just queuing the SYN Packets you will introduce a ridiculous delay on
> this first packet. The rest of the connectio is handled by conntrack and
> there is thus no differences.

That design is very good. We think that it is the best among all the
"hybrid" port knocking applications that we know.

> > 4. There is not a single point of configuration, if you want to change
> > the knock sequence for instance, you have to change the app and then
> > the iptables rule.
>
> All can be bundle in a single script. A cleaner way could be to use
> ipset to specify the ports list and not to change the rules set.

This is debatable. A cleaner way for who? Someone might want to
configure the firewall only through iptables, without depending on
other applications or daemons.

> > 5. question: Is there a way to set two or more different queues? to
> > avoid receiving in the userspace, packets from other rules with the
> > "-j QUEUE"
>
> No, you have to use NFQUEUE to do so (which come with 2.6.14+). QUEUE is
> limited to one queue.

We didn't know the NFQUEUE target extension. We thought it was very good.

Finally, we don't want to say that other port knocking applications
aren't useful. We just offer an alternative, than in our opinion has
more advantages than other solutions.

We would like know any suggestions about our pknock extension match.
If you have some, they will be welcome.

Regards,


--=20
Federico
