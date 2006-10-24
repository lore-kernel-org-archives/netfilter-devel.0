From: "Luis Floreani" <lucholaf@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Tue, 24 Oct 2006 20:21:55 -0300
Message-ID: <cd08d610610241621o12c67455rf0c3a7778f6b6f7f@mail.gmail.com>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<4534309F.8000200@netfilter.org>
	<c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
	<1161093912.20036.3.camel@localhost.localdomain>
	<c0db55360610171732nfcd4118mfd89cea1c1aad457@mail.gmail.com>
	<45363E4C.4030201@netfilter.org>
	<c0db55360610230631u4acce3bft3f020916341caf0f@mail.gmail.com>
	<1161632812.5359.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"J. Federico Hernandez" <fede.hernandez@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eric Leblond" <eric@inl.fr>
In-Reply-To: <1161632812.5359.8.camel@localhost>
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

On 10/23/06, Eric Leblond <eric@inl.fr> wrote:
> Le lundi 23 octobre 2006 =E0 10:31 -0300, J. Federico Hernandez a =E9crit=
 :
> > On 10/18/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > J. Federico Hernandez wrote:
> > > > On 10/17/06, Eric Leblond <eric@inl.fr> wrote:
> > > >> >
> > > >> > When all you want is to open a port after a correct sequence of
> > > >> > knocks, instead of sending from the kernel all the knocks to the
> > > >> > userspace, and then setting a new iptables rule so the kernel fi=
rewall
> > > >> > takes an action, it would be better to leave the whole work to t=
he
> > > >> > kernel and avoid the transition kernel->userspace->kernel.
> > > >>
> > > >> kernel->userspace->kernel is really not a problem for nowadays com=
puter.
> > > >> Simply think about snort-inline which is able to handle a great am=
ount
> > > >> of traffic.
> > > >
> > > > the fact that nowadays computers have much more power, doesn't mean
> > > > that you can forget about a simple, less complex and correct design=
.
> > >
> > > I'm unsure that putting things in kernel implies less complexity and
> > > correct design, it depends on the case.
> > >
> >
> > Putting things in kernel doesn't mean less complexity, but on port
> > knocking case means a correct design and better performance.
> >
> > WIth traditional port knocking applications you have to switch
> > kernelspace ->userspase->kernelspace several times. Furthermore, you
> > have to load the regex engine for parsing the firewall logs and you
> > have to access the hard disk each minute for parsing logs files. In
> > our opinion, this is not a correct design.
>
> We do not understand each other about the way I (and pablo I think)
> propose you to do because the solution I thought off do not use log
> analysis...
>
> Let's say port knocking is 4138 2345 4577 to open port 22
>
> Then just do
> iptables -A INPUT -p tcp -m multiport --dports 4138,2345,4577,22 -j QUEUE
>
> Your userspace application wait for packets coming from queue, drop them
> when they come from knocking ports (but store the knock) and accept
> packet to port 22 if we just had a correct knocking sequence before.
>
> This is simple, do not use complex algorithms and should fit on all
> small routers.
>

The idea of having an userspace application receiving the queued
packets from netfilter is much better than scanning firewall logs.

Actually, I see this issues in the userspace solution:

1. (+) Could be safer to run the portknocking logic in userspace,
rather than kernel.
2. It is not clear from a admin point of view that a portknocking
system is running.
3. The port 22 traffic is suffering a small penalty because of
travelling kenel->userspace->kernel before arriving to the service.
4. There is not a single point of configuration, if you want to change
the knock sequence for instance, you have to change the app and then
the iptables rule.
5. question: Is there a way to set two or more different queues? to
avoid receiving in the userspace, packets from other rules with the
"-j QUEUE"

Luis.
