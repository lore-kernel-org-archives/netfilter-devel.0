From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] conntracker/nat helper for Microsoft Media Services
Date: Tue, 24 Sep 2002 13:39:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020924133925.M3810@sunbeam.de.gnumonks.org>
References: <1032732902.574.99.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RlRfhCwT9rWq1FZx"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Content-Disposition: inline
In-Reply-To: <1032732902.574.99.camel@exile>; from filip.sneppe@cronos.be on Mon, Sep 23, 2002 at 12:15:01AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RlRfhCwT9rWq1FZx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2002 at 12:15:01AM +0200, Filip Sneppe (Cronos) wrote:
> Hi,
>=20
> This is a connection tracking/nat helper for Microsoft (Streaming) Media
> Services, both in patch-o-matic format and as a diff against
> 2.4.20-pre7 (the patch requires newnat).

Thanks a lot for contributing this helper to the netfilter project, I have
committed your patch to CVS right now.

However, there is a small remaining issue:

@@ -60,12 +60,14 @@                                                        =
    =20
 /* Add protocol helper include file here */                               =
    =20
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>                        =
    =20
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>                        =
    =20
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>                        =
    =20
                                                                           =
    =20
 /* per expectation: application helper private data */                    =
    =20
 union ip_conntrack_expect_help {                                          =
    =20
        /* insert conntrack helper private data (expect) here */           =
    =20
        struct ip_ct_ftp_expect exp_ftp_info;                              =
    =20
        struct ip_ct_irc_expect exp_irc_info;                              =
    =20
+       struct ip_ct_mms_expect exp_mms_info;                              =
    =20
                                                                           =
    =20
 #ifdef CONFIG_IP_NF_NAT_NEEDED                                            =
    =20
        union {                                                            =
    =20
@@ -79,6 +81,7 @@                                                          =
    =20
        /* insert conntrack helper private data (master) here */           =
    =20
        struct ip_ct_ftp_master ct_ftp_info;                               =
    =20
        struct ip_ct_irc_master ct_irc_info;                               =
    =20
+       struct ip_ct_mms_master ct_mms_info;                               =
    =20
 };                                                                        =
    =20
                                                                           =
    =20
 #ifdef CONFIG_IP_NF_NAT_NEEDED                           =20


Those hunks should not be part of the .patch itself, but seperate pom-files,
since this clashes with other helpers.  See=20
netfilter/patch-o-matic/talk-conntrack-nat.patch.ip_conntrack.h*

Please submit an incremental diff against the code which is now in CVS.
Thanks.

> Regards,
> Filip

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--RlRfhCwT9rWq1FZx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9kE7tXaXGVTD0i/8RAvNHAJ9R71bfIlNBYmEwO45qiYMjslidKgCfa671
p20iG5+J+4hOjbr8PNlz+mk=
=junW
-----END PGP SIGNATURE-----

--RlRfhCwT9rWq1FZx--
