From: Harald Welte <laforge@netfilter.org>
Subject: Re: pptp connection tracking in iptables
Date: Tue, 17 Jun 2003 18:28:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030617162817.GL936@naboo>
References: <B44230956615E549B1DA9D4FF0A6294702D182@mail.remoteops.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRwESHC7KXlqFpSs"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brent DeWitt <brent@remoteops.net>
Content-Disposition: inline
In-Reply-To: <B44230956615E549B1DA9D4FF0A6294702D182@mail.remoteops.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--XRwESHC7KXlqFpSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2003 at 11:29:34AM -0600, Brent DeWitt wrote:

> I have been using connection tracking for pptp in the 2.4.19 kernel using=
 a
> kernel patch I downloaded called "netfilter_pptp_patch_2.4.19_rev1"  This
> allows me to make connections in and out and multiple sessions. =20

I am not familiar with a patch of this name.  However, I assume it is
based on my pptp/gre ct+nat helper.

> With the 2.4.20 kernel. I have been using the Iptables POM to apply the p=
ptp
> connection tracking.  I apply the pending scripts and the pptp patch in
> extra.  I compile the kernel with all the IPtables options included or as
> modules, like I did with the 2.4.19 kernel.  But when I go to make the
> connection, it times out and an error is posted ip_conntrack_pptp.c : bad
> csum

the timeout should not happen.  Are you sure your ruleset is correct?
What happens to the GRE entries in /proc/net/ip_conntrack while you try
to establish the session?  What does tcpdump/ethereal tell you during
the connection setup?

the 'bad csum' is just a debugging statement.
=20
> I looked through the patch code at it seems that windows pptp isn't being
> passed right to post that message.  What I don't understand is how it wor=
ked
> with 2.4.19 but not with 2.4.20.

no, it is passed through.  and the windows pptp implementation has to
retransmit the erroneous packet anyway.

> Brent

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XRwESHC7KXlqFpSs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+70GgXaXGVTD0i/8RAnd/AJ9osUwNEpVr/ZUIG+ascDzZ3MmJ5ACggQQu
bpvJ3I0x4MBLlbUEVmqB3TE=
=D9pH
-----END PGP SIGNATURE-----

--XRwESHC7KXlqFpSs--
