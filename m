From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Sat, 15 Feb 2003 18:58:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030215175841.GL30133@calix.csn.tu-chemnitz.de>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030214080612.GN14794@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I hope this discussion is not already over. Sorry, but it took me a
while to understand all the implications and to skip through some RFC's.

On Fri, Feb 14, 2003 at 09:06:12AM +0100, Harald Welte wrote:
> From https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D48

>> ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
>> refragments them at POST_ROUTING without careing about IP_DF. packets

What has IP_DF (I hope you mean the "Don't Fragment" bit in the
IP-header) to do with _de_-fragmentation? As far as I understood RFC791
("Any internet datagram so marked is not to be internet fragmented under
any circumstances.") this should never happen, and if so another host
down the route has already f***ed up the packet.=20
I haven't tested whether iptables really ignores IP_DF in POST_ROUTING,
but if so, this is a serious bug and should be fixed.

>> with IP_DF|IP_MF can be refragmented with a different size, so path
>> mtu discovery is broken.  Linux nfs itself sends out packets with
>> IP_DF|IP_MF.

Could somebody please explain the notation: "IP_DF|IP_MF" to me? Does
this mean at least one of both flags is set? And if so this is against
my understanding of the above mentioned RFC791. If IP_DF is set, the
packet _must not_ be fragmented, so IP_MF can't be set.

Let me go through an example of PMTUD and correct me if I am wrong with
my view of this protocol:

Assume host A wants to send a packet to host B and pmtud is enabled=20
(/proc/sys/net/ipv4/ip_no_pmtu_disc =3D 0) the IP_DF flag will be set in
the packet sent. In case this packet will not pass through the eye of a
needle further down the line, it will be droped and an ICMP Message
(type 3 code 4: fragmentation needed and DF set) will be sent to A.
Host A will then resend smaller packets (again with IP_DF set) until the
packet reaches host B.=20
The way I understand it, there won't be any fragmented packet on the
line in this connection, so iptables will not break anything.

If on the other hand the IP_DF bit is not set, any host on the route
from A to B is allowed to refragment the packet to fit the MTU of the
next connection.

Now I can't see any reason why iptables should not be allowed to
reassemble and refragment a packet with IP_DF not set.

>> The problem is that we _need_ to defragment at NF_IP_PRE_ROUTING in
>> order to have the be able to do connection tracking.  So at this point
>> we would need to save the sizes of all individual fragments.  This
>> would enable us to re-fragment to exactly the same size at
>> POST_ROUTING.=20

Do we really have to re-fragment to exactly the same size? Wouldn't it
be sufficient to re-fragment to fragments not bigger in size than the
biggest incoming fragment of this connection?

>> And then, what happens if NAT has to resize (enlarge/shrink) a packet.
>> How should we deal with this while re-fragmenting?=20

In my opinion we should just refragment it, as any router would do it.

> And if we go for my first propsal, how/where would we store the
> list-of-fragment-sizes?  We certainly don't want it to be dynamically
> allocated... but according to RFC791 there kan be 8192 fragments of 8
> octets each...

I think we have to store fragment sizes of each connection, but storing
the maximum fragment size should be enough. Anyhow, iptables can do lots
and lots of mangling with any packet, so what is it good for to stick
with the original fragments.

As a final comment: What are overlapping fragments good for, except
trying to fool NIDS's? As I could not find any comment on how to deal
with those in the RFC's, we will not break an RFC by "fixing" the
fragments.

Oh allow me another comment: No matter how you are going to fix the
problem, please don't try to fix problems with programs, but rather
stick to the RFC's as close as possible. But well, thats probably what
you have been doing for years now, so forget this comment. ;-)

Ciao!
    Thomas

--=20
"Those puny RFC's are all that separates us from animals."

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD4DBQE+Tn/RT7fd1jhuy5cRAiEzAKCHtvV5ah59O1oOBtQ9Z3ri8YQ1zACWNLcH
+L4NH8U7Z9Jq1270ORnyZA==
=beB1
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
