From: Michael Rash <mbr@cipherdyne.org>
Subject: Re: new match extension to implement port knocking in one
Date: Sat, 14 Oct 2006 13:19:57 -0400
Message-ID: <20061014171957.GA31268@minastirith>
References: <c0db55360610130635p199487adn94e78ed72fb4f57f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <c0db55360610130635p199487adn94e78ed72fb4f57f@mail.gmail.com>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
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

On Oct 13, 2006, J. Federico Hernandez wrote:

> >On Oct 12, 2006, Alexey Toptygin wrote:
> >
> >> On Wed, 11 Oct 2006, Luis Floreani wrote:
> >>
> >> >>If you're interested in port knocking, you might want to read this
> >> >>paper:  http://www.acsac.org/2005/abstracts/156.html  It covers 
> >security
> >> >>issues relating to port knocking in detail, and presents an 
> >architecture
> >> >>for solving most of them.
> >> >>
> >> >>Full disclosure:  I wrote that paper.  Feel free to contact me if you
> >> >>have questions.
> >> >>
> >> >>Rennie deGraaf
> >> >
> >> >In our implementation, for security, we are using the Tumbler protocol, 
> >we
> >> >found it simple yet powerful, check it out here:
> >> >http://tumbler.sourceforge.net/.
> >>
> >> It seems that Tumbler is not capable of working across NAT, unless the
> >> client can somehow obtain its public IP address. Also, it relies on 
> >clocks
> >> being synchronized, since authentication will fail if the UTC time in
> >> minutes is not identical on the client and server. Tumbler is not as
> >> stealthy as the techniques in Rennie deGraaf's paper, since it uses an
> >> open UDP port.
> >
> >Why not use fwknop in Single Packet Authorization mode?:
> 
> Why not using iptables to implement port knocking?
> You won't depend on any daemon.
> 
> If you know the iptables syntaxis, you don't need to learn the daemon
> syntaxis or its configuration.
>
> Federico

Well, I agree that having an implementation that builds some port
knocking capabilities directly into iptables is a good thing for the
reasons you mention.  However, I would say that there are some design
considerations that warrant userspace implementations as well.  Users
should be able to select the system that offers the best security
properties, and putting both the authentication and authorization
verification code in the kernel is not always going to meet everyone's
needs.

(Sorry for the length of this email, but I want to be thorough).

First, port knocking as opposed to single packet strategies have some
serious problems:

- Hard to solve the replay problem
- Insufficient data transfer rate and reliability because of necessary
  time delays to enforce packet ordering to make reasonably sized
  data transfers (asymmetric encryption is not even an option)
- Knock sequences look like port scans
- Trivially easy to bust a knock sequence just by spoofing a duplicate
  packet into the sequence

The NAT issue and the lack of association between a knock sequence and
follow-on connection mentioned in deGraaf's paper are important, but I
think we basically have to live with it in any practical implementation
that is generally deployable.  And, these two limitations extend to
single-packet solutions as well.  (Although, if you run both SPA and the
follow-on SSH connection over the Tor network - at the expense of having
an established TCP connection for the SPA packet - and you use the
MapAddress functionality to request a specific exit router, then it is
possible to overcome the NAT issue, see
http://www.cipherdyne.org/fwknop/docs/talks/dc14_fwknop_slides.pdf).

Still, single-packet solutions are generally the way to go (assuming we
are looking for a scheme that has good security properties).

So, your hmac method from within iptables is the most interesting.  Some
differences between this method and using a userspace daemon with an
encrypted payload include:

- Clients cannot include information that the server might use to
  differentiate them.  For example, the server might require that the
  client include both a valid username and crypt() password on the local
  system that can be verified (or even talking with an LDAP server
  first) before opening the firewall.  If you changed your protocol to
  include the hmac of the <secret, ip, epoch_min> and the appended
  additional information, that would work, but it would have to be sent
  in the clear.  Your userspace daemon could perform these userland
  verifications, but by then the firewall is already open.  (Fwknop
  supports the username/password verification via crypt(), but not the
  LDAP bit yet).

- The above also extends to the clients determining the access rules
  themselves, and also sending complete commands across.  (Neither of
  these are probably a big requirement on the part of users, but they
  are worth mentioning, and fwknop supports both).

- The hmac non-replay functionality does allow replays for up to one
  minute, correct?  I.e. multiple identical hmac packets could be sent
  for up to one minute and all would be honored by iptables?  Suppose
  a user does:

knock.sh opensecret; ssh user@host "do command"; knock.sh closesecret

  Then an attacker would still have one minute in order to replay the
  first opensecret packet, and the IP would be allowed through until
  the attacker decides to voluntarily send the closesecret packet, yes?

  Fwknop never allows duplicate SPA packets, period.

- The hmac functionality allows new sessions to be initiated until a
  client decides to close access.  This magnifies the NAT problem.
  In fwknop, because all ACCEPT rules are automatically deleted
  after a configurable amount of time and sessions remain open with
  Netfilter's conntrack facilities, the NAT problem is minimized.  I
  wonder if you could move to a timeout architecture within your pknock
  match?

- Finally, a userspace implementation is free to support any number of
  encryption schemes (as implemented by projects that concentrate in that
  area), many of which I doubt will ever be put within the kernel.
  Fwknop can take advantage of the benefits of asymmetric ciphers with
  GnuPG (as implemented by the GnuPG project itself) for example.

While I think that having the hmac functionality in iptables would meet
the needs of many users, I think the above shows that the effort of
learning a new daemon syntax is worth having a userspace implementation
with more robust security properties.  If I have misunderstood your
architecture, please correct me.

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
