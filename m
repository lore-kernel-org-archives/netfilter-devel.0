From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and NAT patches
Date: Wed, 26 Mar 2003 16:20:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326152047.GY21953@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GAoked8QSizNecZ5"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jeff Hall <hall@vdata.com>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GAoked8QSizNecZ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2003 at 03:32:46AM -0500, Jeff Hall wrote:
> Below are patches which correct problems I encountered while testing
> the PPTP conntrack and NAT modules.=20

Thanks for sharing your experience with the pptp helper.

> The ip_conntrack_pptp.c patch prevents a kernel crash caused by an attempt
> to dereference a NULL value. The original code failed when the next link
> pointed to the parent ip_conntrack rather than the next ip_conntrack_expe=
ct.

Ok, I see.  This indeed is a mistake and I will include your patch.

> The ip_nat_core.c patch ensures that the PPTP helper function is called e=
ven
> after the expected GRE connection is established. I have not evaluated any
> other protocols with helper functions to see if this will cause problems.

Again agreed.  This change is necessarry.

> I also noticed that since the helper function is called for each expectat=
ion
> both inbound and outbound packets are sent to ip_nat_mangle_tcp_packet tw=
ice
> until an expected GRE connection is established. However, since this does
> not appear do cause any problems and I was not confident of the best way =
to
> prevent the extra manipulation, I did not attempt any patch.

yes, there is some room for optimization... but I don't think it's worth
the effort.

> I was also having problems running a PoPToP server on the firewall server.
> The reason turned out to be that I had not chosen CONFIG_IP_NF_NAT_LOCAL
> thinking that I did not need to NAT my local connections since my local
> machines IP was not the same as the IP I am using for NAT. It turns out t=
hat
> even if a connection does not satisfy any NAT rule the helper function is
> called in do_bindings. Without CONFIG_IP_NF_NAT_LOCAL set the helper func=
tion
> was being called for DST manipulations but not for SRC manipulations. My
> question to netfilter gurus is shouldn't the helper function be skipped if
> the connection doesn't satisfy any NAT rule?

Mh.  If we don't have any nat mappings, we shouldn't call the helper.

> I did quite a bit of testing of these modules in an environment where we
> are making connections using the Windows RAS client from behind a NAT'ing
> firewall and also need to run PoPToP on the firewall server for employees
> working from home. The modules with these patches never failed. I was even
> able to make two connections from behind a NAT'ing wireless access point=
=20
> to the firewall PoPToP server (with a patch to PoPToP to generate non-
> zero call IDs).

great.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GAoked8QSizNecZ5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcVPXaXGVTD0i/8RAukrAJ46Iy+9JzmJpYfRyraaAFD/dc/lSACeInSx
kQaZEKEpwG+1VHI09uz0T7U=
=n38V
-----END PGP SIGNATURE-----

--GAoked8QSizNecZ5--
