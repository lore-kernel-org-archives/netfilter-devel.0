From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Re: Re:Interesting failure with RPC state tracker
Date: 22 May 2003 11:37:22 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053617841.2072.171.camel@pc>
References: <200305212324.h4LNO6710132@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h3AZFvWJzv84WvRnZt2+"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200305212324.h4LNO6710132@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-h3AZFvWJzv84WvRnZt2+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2003-05-21 at 19:24, Ian Latter wrote:
> Hello Brian and Dev ppls,

Hi All,

>   I'll post a link on it later, but I found a site that discussed the RPC
> module within Firewall-1 in greater detail than I had seen previously.

Cool.

>   One of the things that Firewall-1's RPC code did, that I didn't like, w=
as
> that if you choose to "match" an RPC, then the matching module will
> automatically allow RPC portmapper requests through the firewall.

Hmmmm.  What does this mean exactly?  Simply an implicit:

iptables -I FORWARD -s $client/32 -d $server/32 -p tcp --dport 111 -j ACCEP=
T
iptables -I FORWARD -s $client/32 -d $server/32 -p udp --dport 111 -j ACCEP=
T

is installed if a rule that allowed $client to use RPC service 100003 on
$server was created?

This seems straightforward enough.  Afterall, the rule the user created
will not work work without (at least) the above UDP rule in place.

> I
> don't like the idea of "hidden rules", and hence in the Netfilter version=
,
> you need to permit the RPC portmapper requests explicitly.  So what
> you've seen is correct ... and this sort of ruleset;
>=20
>   Usage:
>=20
>     The intended usage of these modules would be with a ruleset like;
>=20
>       # New session from client to server (portmapper get)
>       -A PREROUTING -t nat -i eth0 -p udp -m rpc --rpcs 100002
>              -s ${client} --sport 0:1023 -d ${server} --dport 111
>              -j ACCEPT

I wish the example did not use PREROUTING -t nat but rather simply
FORWARD or INPUT.  IMHO, it would be more clear what the module is all
about.

>       # Continued session from client to server (portmapper answer)
>       -A PREROUTING -t nat -i eth1 -m state -p udp
>              -s ${server} --sport 111 -d ${client} --dport 0:1023
>              --state ESTABLISHED -j ACCEPT

Why is this needed?  Does conntrack not automatically do this for me
(i.e. just like any other udp rule)?  I don't have any rule of this sort
in my policy and RPCs are working just fine here in my FORWARD chain.


> ... should work ... (was this what you found?) .. except for the "DUMP"
> request.

Yes, an application using the DUMP (i.e rpcinfo -p) request to find port
numbers is kinda cheating.  But it works and there are application(s)
using it.  Linux's mount command is one.

>   I'll need to read up on this one (I remember reading it through
> when I rejigged the module, but I ended up discarding it).

It's simply call that rpcinfo -p uses to get a dump of all registered
RPC routines and their port numbers.

>   There are two other features in the Firewall-1 RPC code that I want
> to add to the Netfilter RPC module;
>=20
>   1)  Cached portmapper resolution -- establishing a slab cache the
>           dynamically stores the port vs the procedure number in memory
>           such that future RPC portmapper requests are redundant

Once you have an RPC GETPORT (which the client will do when it wants to
know a port on the server) is there really much to be saved looking up
the port in a table vs. just parsing the GETPORT reply?

>   2)  A kernel socket call to the RPC portmapper -- in case the RPC
>           module or rule is only activated after the client has already=20
>           performed a portmapper resolution request, currently the RPC
>           module would fail to permit the valid RPC request.

Indeed.  But how is this situation any different than a regular UDP/TCP
session that is ESTABLISHED when a rule is put in place that affects
it's port?

Omce the client has used RPC to find the port of an RPC service it's
just regular TCP/UDP business as usual, is it not?

>   If, however,
>           the RPC port range

"the RPC port range"?  I will have to dig my TCP/IP Illustrated Volume I
out of storage, but IIRC, RPC servers just use ephemeral port numbers
and register them with the portmapper don't they?  I don't recall there
being any "range" of ports reserved for RPC servers.

>  was treated as a possible set of RPC "targets",
>           but for which a valid (matched) IP address had failed to resolv=
e a
>           port for a given procedure; then the RPC module would make its=20
>           own request to the portmapper to resolve the port and validate =
the
>           match.  The resolution could then be added to the local slab ca=
che
>           to accelerate future matches.

But the problem is if the RPC netfilter module does not catch the
GETPORT call, there is nothing afterwards that can indicate to netfilter
that an ESTABLISHED session on a given port is to an RPC server vs. just
any other TCP/UDP server.

>   While it *sounds* like  I'm a great guy ready to do big things, the tru=
th is
> that I haven't fixed my pointer module name problem in three weeks, so=20
> these mods might be a little way off ;-)

I hear ya!

>   I am very appreciative of feedback on the use of this module and your
> successes/failures.  Of particular interest is performance ... let me kno=
w
> how you go with thrashing this thing under NFS ... because that is one
> of the big unanswered questions here ..

Well, beyond initially mounting an NFS filesystem, the RPC module has
nothing to do with NFS.  Once the filesystem is mounted, it's just
regular ol' UDP on whatever port the portmapper told the client (usually
2049).

This does bring up an interesting issue however.  The normal timeouts
for UDP sessions are not nearly long enough for NFS.  NFS can go quite a
long while without sending any traffic back and forth (no accesses to
the filesystem).  Other than a "hard" rule allowing the client to talk
to the server on port 2049, I am not sure how to handle this though.

>   Thanks for the feedback ... I'll check out that DUMP command and see
> what I can do ...

Well, it's an interesting problem because just because a client asks for
the list of service/ports a server is providing, it does not really mean
the client will want to use a service/port, and even if it does, the
netfilter RPC module cannot possibly know which one of the list the
client retrieves that it will want to use.  What expectation do you
install for a port dump?

>  which kernel version are you using?

2.4.20ish.

> (Cool database software, btw, I implemented it for an ISP in AU who
> had heard of it and used it before).

Which database software is that?

b.

--=20
Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-h3AZFvWJzv84WvRnZt2+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+zO6xl3EQlGLyuXARAjqwAJ9kt+5xVPOdlzpWxYQydzrNjGnjAgCfYvsq
PhHIMkctLFSYpvwpF8RtyNU=
=qnAX
-----END PGP SIGNATURE-----

--=-h3AZFvWJzv84WvRnZt2+--
