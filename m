From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Some dumb questions...
Date: Mon, 4 Nov 2002 12:05:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104120508.O8635@sunbeam.de.gnumonks.org>
References: <F150xCT9EioMhrQkhJn00022e7c@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WcZHMCrhYs4ZC/pD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Joel Linuxdude" <linuxlists@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F150xCT9EioMhrQkhJn00022e7c@hotmail.com>; from linuxlists@hotmail.com on Sun, Nov 03, 2002 at 02:32:34AM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WcZHMCrhYs4ZC/pD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 03, 2002 at 02:32:34AM -0500, Joel Linuxdude wrote:
> I was referred to this list by one of the Netfilter guys on order to glee=
n=20
> some information needed to write a decent tutorial/reference guide.

Joel, I'm happy that you are trying to contribute some documentation.

But I have to agree with the point raised by Martin...

> WARNING: POSSIBLE DUMB QUESTIONS. (But, ask me if I care!)

Questions are not dumb.  But you could have obtained (and still can!) the
anwers without raising this issue on the list again.

> QUESTION: Would a packet created on the Netfilter PC first
> go through the OUTPUT chain and then through POSTROUTING?
> If so, what TABLE??? NAT? What about FILTER? I assume:
> NetFilter system -> (nat)OUTPUT -> (nat)POSTROUTING -> Eth0 -> Internet

This has been answered over and over again. please check the list archives.

Once you have understand the underlying architecture, it should become
obvious anyway.

> QUESTION: Absolutely everything coming INTO an interface
> first goes to (nat)PREROUTING, right?

you seem to confuse netfilter hooks with chain names. Yes, everything
goes to the netfilter NF_IP_PRE_ROUTING hook.  Whataver happens next depends
on your setup/configuration/...=20

> QUESTION: Netfilter PC has 3 workstations over Eth1 and they
> are SNATing through Eth0 and out to the internet. What if
> somebody conversing with the workstation over...say...
> IRC gets the IP of the workstation (It would be the Netfilter
> PC's IP) and pings it.....Of course, it would be pinging
> the Netfilter PC and NOT the workstation, right? The workstation
> would not even see any ICMP packets at all, right?

of course.

> QUESTION: Where is the most effective place to stop spoofed
> packets or block a port?
> A) -t nat PREROUTING ???

the nat table is for _NAT_, not for filtering.

> B) -t filter INPUT (for local) and -t filter FORWARD (for LAN)?

we are talking about filtering packets, so we obviously use the 'filter'
table.

> THANK YOU VERY MUCH! These answers will help me out a lot.

As stated before, if you are wanting to write decent documentation,
please try reading the list (esp. netfilter-devel) archives fist.
Thanks.

> Joel

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--WcZHMCrhYs4ZC/pD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xlRkXaXGVTD0i/8RAvdzAJwMLNO/gNxI4jfl0TkCkkNTFblI4ACgpeZ1
mQukZRavVT5YXF4zSp1EPJ0=
=kjfl
-----END PGP SIGNATURE-----

--WcZHMCrhYs4ZC/pD--
