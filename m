From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: [PATCH] flow statistic match
Date: Thu, 19 Sep 2002 11:34:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020919093447.GE6530@noir.cb.ac.at>
References: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2002 at 11:44:38PM -0700, Jay Schulist wrote:
> Hello Harald,
> Here is a new match which adds per tuple packet and byte statistics along
> with allowing the user to match on the number of bytes and packets for a
> flow.
This is uber-cool. I already see a very nice example of use: I mark the
packets in mangle to achieve different priority later with the prio qdisc.
Currently I mainly use --dport, but with this I can easily mark downloads (=
and
uploads) lower priority (e.g. >100kiB -> set lower priority, >5MiB -> set y=
et
lower priority).

I'll follow the development and when it makes into patch-o-matic I'll build=
 a
new kernel and try it out.
=20
> Thanks,
Thnx as well :-)

> jay-s.
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
            0 and 1. Now what could be so hard about that?

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9iZo3zogxsPZwLzcRApUKAKCWibo8ijIeObTNmGy0fJDGCWbjWwCfbFQB
VyyoqssN5VDuIf20BHArY+s=
=9YTI
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
