From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter problem with new 2.4.22
Date: Sun, 21 Sep 2003 16:34:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921143423.GE20986@sunbeam.de.gnumonks.org>
References: <3F697788.8080103@isfera.ru> <3F6A2632.6030005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Cc: Diadon <diadon@isfera.ru>, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F6A2632.6030005@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2003 at 11:40:02PM +0200, Patrick McHardy wrote:
> Hi Diadon,
> the problem seems to be that a dst for local input doesn't carry pmtu=20
> information, the pmtu is set by rt_set_nexthop which is skipped for
> local input.=20

Thanks for debugging the problem, Patrick.
=20
> I've attached two possible fixes for this. The first one restores
> behaviour from before the routing changes for LOCAL_OUT, the other one
> removes the check since obviously "Never happens" is not true anymore
> (and it is not an error). Another possibility would be something like
> "if (nskb->dst->pmtu && nskb->len > nskb->dst->pmtu)  ..."
> Someone from the coreteam should comment which solution is prefered.

I'd actually prefer the last solution (together with a comment why
nskb->dst-pmtu can be zero).=20

I've included the patch into 'submitted' (will send it to davem later)

> Regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbbvXaXGVTD0i/8RAtznAKCvy2RlBQ4y86iWkWe3G37q5RQjmgCeI6lT
lZOtnNKD22rDNhDO5nhBUfA=
=qDBP
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
