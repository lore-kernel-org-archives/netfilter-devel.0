From: Stephen Frost <sfrost@snowman.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Tue, 13 Jul 2004 23:00:33 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040714030033.GR21419@ns.snowman.net>
References: <20040415212034.GE7611@obs.bg> <20040713023700.GM21419@ns.snowman.net> <40F34EF2.2010405@trash.net> <20040713115306.GN21419@ns.snowman.net> <40F4062B.9060308@trash.net> <20040713161021.GO21419@ns.snowman.net> <40F48AE6.9090302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSMi1UXgOp435K5S"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40F48AE6.9090302@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VSMi1UXgOp435K5S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick McHardy (kaber@trash.net) wrote:
> Stephen Frost wrote:
> >Okay, thanks.  For --reqid...  Do you think that's sufficient to base
> >firewall rules off of?  Can it be somehow 'faked' by the
> >remote/potentially untrusted side?  That's my main issue.  If it can't
> >and will only match if the ipsec packet is valid and coming from that
> >network then I don't need to care about --spid and will just use
> >--reqid...
>=20
> It can't be faked, it will always match the reqid of the used SA.

Okay, cool.

> But policy checks happen after the PRE_ROUTING/LOCAL_IN/FORWARD
> hooks, so you can't be sure that a packet matching a reqid really
> has a source/destination address that is configured in the policy.

Well, as standard practice I check the source address of any packet
coming in to make sure it matches the interface it's coming in on.  It's
basically rp_filter implemented manually w/ iptables because I have to
turn off iptables due to some complex routing I'm doing.

Anyway, my intent is to use the reqid in my checks to ensure that only
valid source addresses are coming in from ipsec tunnels, as well as to
implement some other rules for each tunnel according to what the remote
side needs access to.  Do you think there'd be any problem with that?

I've also run into an interesting problem that perhaps you can help
with...  First off, is there any way to get the kernel to log packets
which it expects to be IPSEC'd due to 'required' in the policy but
aren't?  I've got the following setup:

Using 192.168.0.0/16 internally for everyone.  Then I have some local
networks at the main site using 192.168.1.0/24, 192.168.2.0/24, etc.
Then I've got a couple of remote sites which have addresses like
192.168.10.0/24, 192.168.11.0/24.  Now, in my IPSEC policy I'd like to
be able to define a policy on the remote side like:
spdadd 192.168.10.0/24 192.168.0.0/16 any -P out ipsec ...
spdadd 192.168.0.0/16 192.168.0.0/24 any -P in ipsec ...

The problem is that when I have these rules in place, the machines
behind the gw on the remote side (192.168.10.x) can't talk to the gw
anyway, everything just gets dropped.  My guess is that this is because
the kernel is expecting them to be IPSEC'd or coming from the remote
side of the tunnel or something.

Any thoughts?

	Thanks,

		Stephen

--VSMi1UXgOp435K5S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA9KHRrzgMPqB3kigRApdIAJ9H7KbLyVRxYLOaRETsOkRRcOnjOQCfRu8o
0mQkFqNc0IJdQi2khmb7iGg=
=WDT8
-----END PGP SIGNATURE-----

--VSMi1UXgOp435K5S--
