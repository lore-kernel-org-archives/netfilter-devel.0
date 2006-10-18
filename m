From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Tue, 17 Oct 2006 22:01:17 -0300
Message-ID: <c0db55360610171801g4bbb8c2co3b940d9a71e90494@mail.gmail.com>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
	<20061017151205.GA6494@minastirith>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Michael Rash" <mbr@cipherdyne.org>
In-Reply-To: <20061017151205.GA6494@minastirith>
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

On 10/17/06, Michael Rash <mbr@cipherdyne.org> wrote:
> On Oct 16, 2006, J. Federico Hernandez wrote:
>
> > >On Oct 14, 2006, Michael Rash wrote:
> > >
> > >> On Oct 13, 2006, J. Federico Hernandez wrote:
> > >>
> > >> >On Oct 12, 2006, Alexey Toptygin wrote:
> > >> >
> > >> >> On Wed, 11 Oct 2006, Luis Floreani wrote:
> > >> >>
> > >> >> >>If you're interested in port knocking, you might want to read this
> > >> >> >>paper:  http://www.acsac.org/2005/abstracts/156.html  It covers
> > >> >security
> > >> >> >>issues relating to port knocking in detail, and presents an
> > >> >architecture
> > >> >> >>for solving most of them.
> > >> >> >>
> > >> >> >>Full disclosure:  I wrote that paper.  Feel free to contact me if
> > >you
> > >> >> >>have questions.
> > >> >> >>
> > >> >> >>Rennie deGraaf
> > >> >> >
> > >> >> >In our implementation, for security, we are using the Tumbler
> > >protocol,
> > >> >we
> > >> >> >found it simple yet powerful, check it out here:
> > >> >> >http://tumbler.sourceforge.net/.
> > >> >>
> > >> >> It seems that Tumbler is not capable of working across NAT, unless the
> > >> >> client can somehow obtain its public IP address. Also, it relies on
> > >> >clocks
> > >> >> being synchronized, since authentication will fail if the UTC time in
> > >> >> minutes is not identical on the client and server. Tumbler is not as
> > >> >> stealthy as the techniques in Rennie deGraaf's paper, since it uses an
> > >> >> open UDP port.
> > >> >
> > >> >Why not use fwknop in Single Packet Authorization mode?:
> > >>
> > >> Why not using iptables to implement port knocking?
> > >> You won't depend on any daemon.
> > >>
> > >> If you know the iptables syntaxis, you don't need to learn the daemon
> > >> syntaxis or its configuration.
> > >>
> > >
> > >Well, I agree that having an implementation that builds some port
> > >knocking capabilities directly into iptables is a good thing for the
> > >reasons you mention.  However, I would say that there are some design
> > >considerations that warrant userspace implementations as well.  Users
> > >should be able to select the system that offers the best security
> > >properties, and putting both the authentication and authorization
> > >verification code in the kernel is not always going to meet everyone's
> > >needs.
> >
> > We think that recognizing a port knocking sequence is an issue of the
> > firewall (netfilter in this case), and if you want to open a port
> > after a correct seq, the firewall is also the place. But sometimes you
> > want to trigger a more complex action from this correct knock seq
> > (e.g. start a webserver), so we allow to send a netlink msg from
> > kernel to a listening userspace application that could decide what
> > action to take. This userspace app is not scanning logs nor sniffing
> > your iface, it's just waiting to receive an important message from
> > kernel.
> >
> > here is a nice intro to netlink sockets:
> >
> > http://www.linuxjournal.com/article/7356
> >
> > >First, port knocking as opposed to single packet strategies have some
> > >serious problems:
> > >
> > >- Hard to solve the replay problem
> > >- Insufficient data transfer rate and reliability because of necessary
> > >  time delays to enforce packet ordering to make reasonably sized
> > >  data transfers (asymmetric encryption is not even an option)
> > >- Knock sequences look like port scans
> >
> > Tumbler is a Single Packet Authorization protocol. We offer 2 modes of
> > operation: the traditional port knock sequence and the SPA way.
>
> Right, I was treating the two modes separately (port knocking vs. SPA).
> I'm trying to make the case that port knocking has enough problems to
> motivate people to use an SPA solution instead.

we agree, that's why we offer both solutions.

<snip>

> > >
> > >- Clients cannot include information that the server might use to
> > >  differentiate them.  For example, the server might require that the
> > >  client include both a valid username and crypt() password on the local
> > >  system that can be verified (or even talking with an LDAP server
> > >  first) before opening the firewall.  If you changed your protocol to
> > >  include the hmac of the <secret, ip, epoch_min> and the appended
> > >  additional information, that would work, but it would have to be sent
> > >  in the clear.
> >
> > Yes, adding users would allow granularity decisions, by now we prefer
> > a more general and simple approach. Maybe in a near future we consider
> > users.
>
> Ok, but doesn't "considering users" imply more user space type functions?
> Sure, I suppose you can read the /etc/shadow file from kernel space and
> then do crypt() from within the kernel, but this is limited and seems
> wrong.  What if you want to tie access to a remote LDAP server for
> example?  Your user space app could do it, but then user-specific
> information would have to be transmitted over the netlink socket as
> well, correct?
>

the listening(netlink sockets) userspace app can receive as much
information as you want, in fact, the bytes received from the socket
are casted to a struct, containing n items.

<snip>

>
> > >- The hmac functionality allows new sessions to be initiated until a
> > >  client decides to close access.  This magnifies the NAT problem.
> > >  In fwknop, because all ACCEPT rules are automatically deleted
> > >  after a configurable amount of time and sessions remain open with
> > >  Netfilter's conntrack facilities, the NAT problem is minimized.
> >
> > Yes, we are thinking about this idea of conntrack to avoid the
> > "manual" close knock, but remember that someone could cause a DoS,
> > spoofing your IP and just trying to establish a connection before you.
>
> I'm not sure I understand.  It seems like this would be an issue only if
> you allow just one follow-on connection per SPA packet, yes?  Fwknop
> uses a timeout window, so it doesn't matter how many connections are
> established as long as it is within the window.
>

ok, in our case, if you do not do the "close" knock, you also have a
timeout window configurable as a the kernel module param.

<snip>

seems that fwknop is an interesting app, but we are looking for a more
kernel oriented feedback. ;-)


regards,

-- 
Federico
