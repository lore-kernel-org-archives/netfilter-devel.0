From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: new match extension to implement port knocking in one
Date: Mon, 16 Oct 2006 12:10:46 -0300
Message-ID: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

> On Oct 14, 2006, Michael Rash wrote:
>
> > On Oct 13, 2006, J. Federico Hernandez wrote:
> >
> > >On Oct 12, 2006, Alexey Toptygin wrote:
> > >
> > >> On Wed, 11 Oct 2006, Luis Floreani wrote:
> > >>
> > >> >>If you're interested in port knocking, you might want to read this
> > >> >>paper:  http://www.acsac.org/2005/abstracts/156.html  It covers
> > >security
> > >> >>issues relating to port knocking in detail, and presents an
> > >architecture
> > >> >>for solving most of them.
> > >> >>
> > >> >>Full disclosure:  I wrote that paper.  Feel free to contact me if you
> > >> >>have questions.
> > >> >>
> > >> >>Rennie deGraaf
> > >> >
> > >> >In our implementation, for security, we are using the Tumbler protocol,
> > >we
> > >> >found it simple yet powerful, check it out here:
> > >> >http://tumbler.sourceforge.net/.
> > >>
> > >> It seems that Tumbler is not capable of working across NAT, unless the
> > >> client can somehow obtain its public IP address. Also, it relies on
> > >clocks
> > >> being synchronized, since authentication will fail if the UTC time in
> > >> minutes is not identical on the client and server. Tumbler is not as
> > >> stealthy as the techniques in Rennie deGraaf's paper, since it uses an
> > >> open UDP port.
> > >
> > >Why not use fwknop in Single Packet Authorization mode?:
> >
> > Why not using iptables to implement port knocking?
> > You won't depend on any daemon.
> >
> > If you know the iptables syntaxis, you don't need to learn the daemon
> > syntaxis or its configuration.
> >
>
> Well, I agree that having an implementation that builds some port
> knocking capabilities directly into iptables is a good thing for the
> reasons you mention.  However, I would say that there are some design
> considerations that warrant userspace implementations as well.  Users
> should be able to select the system that offers the best security
> properties, and putting both the authentication and authorization
> verification code in the kernel is not always going to meet everyone's
> needs.

We think that recognizing a port knocking sequence is an issue of the
firewall (netfilter in this case), and if you want to open a port
after a correct seq, the firewall is also the place. But sometimes you
want to trigger a more complex action from this correct knock seq
(e.g. start a webserver), so we allow to send a netlink msg from
kernel to a listening userspace application that could decide what
action to take. This userspace app is not scanning logs nor sniffing
your iface, it's just waiting to receive an important message from
kernel.

here is a nice intro to netlink sockets:

http://www.linuxjournal.com/article/7356

> First, port knocking as opposed to single packet strategies have some
> serious problems:
>
> - Hard to solve the replay problem
> - Insufficient data transfer rate and reliability because of necessary
>   time delays to enforce packet ordering to make reasonably sized
>   data transfers (asymmetric encryption is not even an option)
> - Knock sequences look like port scans

Tumbler is a Single Packet Authorization protocol. We offer 2 modes of
operation: the traditional port knock sequence and the SPA way.

> - Trivially easy to bust a knock sequence just by spoofing a duplicate
>   packet into the sequence

This is not possible with our anti-replay option.

Luis Floreani: "In our implementation there is no room for replay,
cause each knock must change from minute to minute, and we just allow
one knock per peer(IP) per minute. So if you knock(open), then
connect, then knock(close), in the remaining minute, a replay would be
useless cause that peer is "blocked" in that minute. Look at the
function has_logged_during_this_minute(), that solves this issue."

Rennie deGraaf: "That's quite a clever idea.  I never thought of using
rate-limiting in my system."

> The NAT issue and the lack of association between a knock sequence and
> follow-on connection mentioned in deGraaf's paper are important, but I
> think we basically have to live with it in any practical implementation
> that is generally deployable.  And, these two limitations extend to
> single-packet solutions as well.

The NAT issue is a general problem with portknocking. Doesn't exist
any portknocking application that solves it, for a while.

> (Although, if you run both SPA and the
> follow-on SSH connection over the Tor network - at the expense of having
> an established TCP connection for the SPA packet - and you use the
> MapAddress functionality to request a specific exit router, then it is
> possible to overcome the NAT issue, see
> http://www.cipherdyne.org/fwknop/docs/talks/dc14_fwknop_slides.pdf).

I will read this paper soon.

> Still, single-packet solutions are generally the way to go (assuming we
> are looking for a scheme that has good security properties).
>
> So, your hmac method from within iptables is the most interesting.  Some
> differences between this method and using a userspace daemon with an
> encrypted payload include:
>
> - Clients cannot include information that the server might use to
>   differentiate them.  For example, the server might require that the
>   client include both a valid username and crypt() password on the local
>   system that can be verified (or even talking with an LDAP server
>   first) before opening the firewall.  If you changed your protocol to
>   include the hmac of the <secret, ip, epoch_min> and the appended
>   additional information, that would work, but it would have to be sent
>   in the clear.

Yes, adding users would allow granularity decisions, by now we prefer
a more general and simple approach. Maybe in a near future we consider
users.

> - The above also extends to the clients determining the access rules
>   themselves, and also sending complete commands across.  (Neither of
>   these are probably a big requirement on the part of users, but they
>   are worth mentioning, and fwknop supports both).

Yes, sending commands could be seen as a good feature, but also could
be a security issue, We prefer to "hardcode" the action in the
iptables rule or let the userspace app (see netlink sockets) decide
the action, rather than the client.

> - The hmac non-replay functionality does allow replays for up to one
>   minute, correct?  I.e. multiple identical hmac packets could be sent
>   for up to one minute and all would be honored by iptables?  Suppose
>   a user does:
>
> knock.sh opensecret; ssh user@host "do command"; knock.sh closesecret
>
>   Then an attacker would still have one minute in order to replay the
>   first opensecret packet, and the IP would be allowed through until
>   the attacker decides to voluntarily send the closesecret packet, yes?

as mentioned before, we just allow ONE knock PER peer(IP) PER minute.
Replay attacks are not possible here, cause the epoch min do change
every min.

> - The hmac functionality allows new sessions to be initiated until a
>   client decides to close access.  This magnifies the NAT problem.
>   In fwknop, because all ACCEPT rules are automatically deleted
>   after a configurable amount of time and sessions remain open with
>   Netfilter's conntrack facilities, the NAT problem is minimized.

Yes, we are thinking about this idea of conntrack to avoid the
"manual" close knock, but remember that someone could cause a DoS,
spoofing your IP and just trying to establish a connection before you.

>   I wonder if you could move to a timeout architecture within your pknock
>   match?

We have a garbage collector that runs from time to time to clean
already allowed and "defunct" peers.

> - Finally, a userspace implementation is free to support any number of
>   encryption schemes (as implemented by projects that concentrate in that
>   area), many of which I doubt will ever be put within the kernel.
>   Fwknop can take advantage of the benefits of asymmetric ciphers with
>   GnuPG (as implemented by the GnuPG project itself) for example.

With a port knocking application any users manipulate firewall rules.
Would you allow that any users or application change your firewall
configuration on the fly?

What happens if a port knocking daemon is shutdowned by a remote
attacker. If the daemon dies, then no further authentication is
possible.

> While I think that having the hmac functionality in iptables would meet
> the needs of many users, I think the above shows that the effort of
> learning a new daemon syntax is worth having a userspace implementation
> with more robust security properties.  If I have misunderstood your
> architecture, please correct me.

We think our architecture is flexible enough so you can spread
functionality between kernel and userspace (through netlink sockets),
as we we mention before.

regards,

-- 
Federico
