Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C988C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 19:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCPTJW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCPTJV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 15:09:21 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1341B2D2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 12:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y5NJ+DyzvZszj1NpA3UaJduVoS6+QiviL0eoODEhuLw=; b=Llx+t0OC40372Cs+fr8J6t0QQF
        buEtgustagKpQJsL+a9aN2dm1d7FRM66MZO1NHOoTPYqs5/uPdUL0rMj1PYI3wYAzjSFncI9Qj2bl
        TtiZS4RmosCJ3VEyp/TIGTxkwvSG6OwiUMiVR4pBaSah0HCWDtySMCDkzXy0VD4P+43bE88M8yWbH
        DAeBdQanJbdSYctMGZBjSSyQem2tR3k2UYd9B7uyPmK9K34w2SE0EgMVOZyCK3Ro9E8zjKVaQPx4e
        ElXXVTfpW4B96UEI02WTKES3EHFVac5lmPVElYrUJYdXwgXO7bq+/PXVjAZDZt6Xx8F5ZvXQ9bG41
        ZEIFPz+g==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcsyT-00BAQP-14; Thu, 16 Mar 2023 19:09:17 +0000
Date:   Thu, 16 Mar 2023 19:09:15 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v3 1/2] pcap: simplify opening of output file
Message-ID: <20230316190915.GA51110@celephais.dreamlands>
References: <20230316110754.260967-1-jeremy@azazel.net>
 <20230316110754.260967-2-jeremy@azazel.net>
 <ZBNnt5POeEw1sr0v@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PI5h45y20eTnlCMh"
Content-Disposition: inline
In-Reply-To: <ZBNnt5POeEw1sr0v@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--PI5h45y20eTnlCMh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-16, at 20:02:15 +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 16, 2023 at 11:07:53AM +0000, Jeremy Sowden wrote:
> > Instead of statting the file, and choosing the mode with which to open
> > it and whether to write the PCAP header based on the result, always open
> > it with mode "a" and _then_ stat it.  This simplifies the flow-control
> > and avoids a race between statting and opening.
> >=20
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  output/pcap/ulogd_output_PCAP.c | 42 ++++++++++++---------------------
> >  1 file changed, 15 insertions(+), 27 deletions(-)
> >=20
> > diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output=
_PCAP.c
> > index e7798f20c8fc..220fc6dec5fe 100644
> > --- a/output/pcap/ulogd_output_PCAP.c
> > +++ b/output/pcap/ulogd_output_PCAP.c
> > @@ -220,33 +220,21 @@ static int append_create_outfile(struct ulogd_plu=
ginstance *upi)
> >  {
> >  	struct pcap_instance *pi =3D (struct pcap_instance *) &upi->private;
> >  	char *filename =3D upi->config_kset->ces[0].u.string;
> > -	struct stat st_dummy;
> > -	int exist =3D 0;
> > -
> > -	if (stat(filename, &st_dummy) =3D=3D 0 && st_dummy.st_size > 0)
> > -		exist =3D 1;
> > -
> > -	if (!exist) {
> > -		pi->of =3D fopen(filename, "w");
> > -		if (!pi->of) {
> > -			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
> > -				  filename,
> > -				  strerror(errno));
> > -			return -EPERM;
> > -		}
> > -		if (!write_pcap_header(pi)) {
> > -			ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
> > -				  strerror(errno));
> > -			return -ENOSPC;
> > -		}
> > -	} else {
> > -		pi->of =3D fopen(filename, "a");
> > -		if (!pi->of) {
> > -			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",=20
> > -				filename,
> > -				strerror(errno));
> > -			return -EPERM;
> > -		}	=09
> > +	struct stat st_of;
> > +
> > +	pi->of =3D fopen(filename, "a");
> > +	if (!pi->of) {
> > +		ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
> > +			  filename,
> > +			  strerror(errno));
> > +		return -EPERM;
> > +	}
> > +	if (fstat(fileno(pi->of), &st_of) =3D=3D 0 && st_of.st_size =3D=3D 0)=
 {
> > +	    if (!write_pcap_header(pi)) {
>         ^^^^
> coding style nitpick,

Whoops.  Not sure what happened there.

> it can be fixed before applying it.

Please.

J.

> > +		    ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
> > +			      strerror(errno));
> > +		    return -ENOSPC;
> > +	    }
> >  	}
> > =20
> >  	return 0;
> > --=20
> > 2.39.2
> >=20
>=20

--PI5h45y20eTnlCMh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQTaVsACgkQKYasCr3x
BA3f9A/+Pu+LjVRK8y2+B1TtOnzapIkzvDlZ7BiRHd3oss0Xux2KTAEDAUOzVcBg
ozWT4Rrv+8RXjoWa9OS/x84NYzQ7y59FTBPQT+KT+fyBiP67mN1eCqdkyFnQp9OY
q4BMJRyK6DG7oGtFPa+J8n1HIhQQ5cnlvx6Ot957oB9qFB0xt37pA/k9LxR9kBXw
1sfHdkCq26H09sRb+0sRirmm1Vak757Io/qgp1GFoLuXIZkZxWuJXxCNIWK5qflU
ALaY0SfIRB2HnTcJSOjN+vk69f4dZJX9nBxIgz91ocs9hrHC6v5m5AXvjLtjEhvV
JkhMBXDuQyXH0Kcwyxk4rtpqHvkTDb0QkK2Y51hoPzeqcNd4nq28bb4VkG4MCBBG
DUbus4rwSFzQ6Jt9+UP/YVUwF9Q3BysJh/KCHCKDd9BglPole3pMVgTudVzZnB3v
uy1py492HzMZVFZoCfc6bxToF2Qb6ZLSNx3RjextTmu8RoXE3OhQBtSL/1dlk+NQ
YVzAk+lQgMkOlcbI9mi2RGR5ha+CgyLAhdnlos1SpUqr79uviSrRtYUYFhLH39PO
Vl/yv+Q67rgQ50r4DczK0B+/4Mbx9mHv+V88UDZRkD4d/iYy44FkKDljKhuty87M
0xRZSK77FvkXo6bSi3CFxwpHIVBAfxf/inSZ/o8ZQggLdfw7VI0=
=A3WB
-----END PGP SIGNATURE-----

--PI5h45y20eTnlCMh--
