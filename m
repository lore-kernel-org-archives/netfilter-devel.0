From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] NAT handles non-linear skbs
Date: Tue, 6 May 2003 15:16:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506131614.GE14822@sunbeam.de.gnumonks.org>
References: <20030506101006.GQ29373@sunbeam.de.gnumonks.org> <20030506.021957.94568784.davem@redhat.com> <20030506110129.GD14822@sunbeam.de.gnumonks.org> <20030506.030538.124071859.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Cc: rusty@rustcorp.com.au, jmorris@intercode.com.au,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030506.030538.124071859.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm starting to Cc' netfilter-devel, since there's nothing secret about
this discussion...

On Tue, May 06, 2003 at 03:05:38AM -0700, David S. Miller wrote:

> You should use skb_copy_bits(), and not linearize anything.  Not even
> post IP/tcp/udp headers.
>=20
> I think you really need to reread the threads where Rusty, Alexey
> and myself were talking about how this needs to be done.

I don't know what exact thread you are talking about, but I've now
re-read the 'De-linearization of conntack' thread.

> Any SKB linearization attempt outside of code that absolutely must
> mangle the packet is effectively a BUG().
>=20
> That's the whole point of this exercise.

Doh. Stupid me ;)

Well, if we are going for the copy_bits() solution, we obviously don't
want to have every match/target create it's own copy of the bits of data
it needs.

Now we have something like:

NF_IP_PRE_ROUTING:

conntrack:
1. ip_conntrack calls tcp_pkt_to_tuple, which calls copy_bits on the
   first 8 bytes of ip payload
2. ip_conntrack_tcp:tcp_packet copies the full tcp header
3. ip_conntrack_tcp:tcp_new copies the full tcp header
4. ip_conntrack_tcp:tcp_exp_for_matches_paket copies the full tcp header

iptable_mangle (PREROUTING)
- run various matches that would probably want to copy l4 header / payload
  even if no mangle target is executed (and thus no make_writable() is call=
ed
  later on)

iptable_nat (PREROUTING)
- run various matches that would probably want to copy l4 header / payload
  even if no nat rule applies (and thus no make_writable() is called
  later on)

iptable_filter (FORWARD):
- run various matches that would probably want to copy l4 header /
  payload

(... to be continued...)

We are going to create copies after copies. I don't like that.
What some generic copy-of-packet handler?   Some generic code that would
maintain copied bytes of a packet in some buffer associated with the
skb?

If we want to make it conntrack-dependent, there could be something like
for avery first packet in ESTABLISHED state, we traverse the ruleset,
and everybody tells theis copy-manager how many bytes it needs.  The
resulting maximum value is stored together with the conntrack entry. For ev=
ery
further (ESTABLIHED) packet, the copy manager would then create a copy
of <num_stored_in_conntrack> bytes.  So we have one-time the on-demand
copying, but for all further packets it should be one copy.

This is based on the assumption that all ESTABLISHED packets are treated
the same way, which is obviously right for most setups.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+t7WeXaXGVTD0i/8RAgPXAJ9P8pFUf6gtTON0KdfQnN2woZL9YQCgo18a
ZrxPbC6g57h+O5RhTKONiTw=
=9QHB
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
