From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Mon, 23 Oct 2006 10:31:14 -0300
Message-ID: <c0db55360610230631u4acce3bft3f020916341caf0f@mail.gmail.com>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<4534309F.8000200@netfilter.org>
	<c0db55360610170519h5d2b1e21me5716b1b8ea7967b@mail.gmail.com>
	<1161093912.20036.3.camel@localhost.localdomain>
	<c0db55360610171732nfcd4118mfd89cea1c1aad457@mail.gmail.com>
	<45363E4C.4030201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
In-Reply-To: <45363E4C.4030201@netfilter.org>
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

On 10/18/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> J. Federico Hernandez wrote:
> > On 10/17/06, Eric Leblond <eric@inl.fr> wrote:
> >> Le mardi 17 octobre 2006 =E0 09:19 -0300, J. Federico Hernandez a =E9c=
rit :
> >> > On 10/16/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > > J. Federico Hernandez wrote:
> >> > > >> On Oct 14, 2006, Michael Rash wrote:
> >> > > >>
> >> > > >> Well, I agree that having an implementation that builds some po=
rt
> >> > > >> knocking capabilities directly into iptables is a good thing
> >> for the
> >> > >
> >> > > Perhaps I'm just influenced by my first impression but I think
> >> that this
> >> > > thing should be in userspace. We are providing the appropiate
> >> netfilter
> >> > > netlink subsystems (nfqueue, nflog...) to implement this as a
> >> userland
> >> > > daemon.
> >> > >
> >> >
> >> > When all you want is to open a port after a correct sequence of
> >> > knocks, instead of sending from the kernel all the knocks to the
> >> > userspace, and then setting a new iptables rule so the kernel firewa=
ll
> >> > takes an action, it would be better to leave the whole work to the
> >> > kernel and avoid the transition kernel->userspace->kernel.
> >>
> >> kernel->userspace->kernel is really not a problem for nowadays compute=
r.
> >> Simply think about snort-inline which is able to handle a great amount
> >> of traffic.
> >
> > the fact that nowadays computers have much more power, doesn't mean
> > that you can forget about a simple, less complex and correct design.
>
> I'm unsure that putting things in kernel implies less complexity and
> correct design, it depends on the case.
>

Putting things in kernel doesn't mean less complexity, but on port
knocking case means a correct design and better performance.

WIth traditional port knocking applications you have to switch
kernelspace ->userspase->kernelspace several times. Furthermore, you
have to load the regex engine for parsing the firewall logs and you
have to access the hard disk each minute for parsing logs files. In
our opinion, this is not a correct design.

We don't want to say that you don't use port knocking applications, we
just offer an alternative solution for port knocking.


Regards,


--=20
Federico
