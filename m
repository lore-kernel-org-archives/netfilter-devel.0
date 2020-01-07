Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB89C33C8C
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 14:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E25D208C4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 14:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=o-t.ch header.i=@o-t.ch header.b="IbjYGnQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgAGOPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:15:02 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:35219 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 09:15:01 -0500
Date:   Tue, 07 Jan 2020 14:14:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o-t.ch;
        s=protonmail; t=1578406498;
        bh=JQGTU1GmEFEm1uYPG3RsCbtAOzc40tqn+kJZcBz45fM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=IbjYGnQcZ2WVddmSQlHu8Bb3DCIvdpMUBuSzqqoDg+oXRQqjQAiPhU1BxWYmmlp5W
         h0+sx5FP0YXG5cBOlzZYPYi9Gg8XTDZt7Ew18NQerWieYtQPFIaLmcjFlP88nSHlI2
         8RRuz2pFYC0k4hjkT1Heyd//6s2JCYCLdCPjnCUs=
To:     Alberto Leiva <ydahhrk@gmail.com>
From:   Laurent Fasnacht <lf@o-t.ch>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Reply-To: Laurent Fasnacht <lf@o-t.ch>
Subject: Re: Adding NAT64 to Netfilter
Message-ID: <rXj5-pS3LGR5qqyPp6xyNkKoDz7cWKa6q9fqsenNu9fsf2erlDbUoOMSB05wwuiBNeQYOwF1VkItgADSmURnjNeV0JRV7n8x_bG4gk1fR8w=@o-t.ch>
In-Reply-To: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
References: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
Feedback-ID: 57pQRvny2FQmWgLHJJAbxKAKqQBFnNNx81A6cwIljfp_GXmFnS-7GQgfTdz7uWKbCUkx1vWr55f9BuhCrwWL9w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="---------------------01260ba3a17472455ad2771779aef3d6"; charset=UTF-8
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
-----------------------01260ba3a17472455ad2771779aef3d6
Content-Type: multipart/mixed;boundary=---------------------9ba5a6241835e4ce0b80fdee860697d4

-----------------------9ba5a6241835e4ce0b80fdee860697d4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

Hello,

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original M=
essage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Friday, January 3, 2020 7:09 PM, Alberto Leiva <ydahhrk@gmail.com> wrot=
e:

> Hello
> =


> I've been working on Jool, an open source IP/ICMP translator for a
> while ([0]). It currently implements SIIT, NAT64 and (if everything
> goes according to plan) will later this year also support MAP-T. It
> currently works both as a Netfilter module (hooking itself to
> PREROUTING) or as an xtables target, and I'm soon going to start
> integrating it into nftables.

That's really great news! We (ProtonVPN) will be following the project, an=
d will be glad to help if possible.

Cheers,

Laurent
ProtonVPN R&D
-----------------------9ba5a6241835e4ce0b80fdee860697d4
Content-Type: application/pgp-keys; filename="publickey - lf@o-t.ch - 0x0007104B.asc"; name="publickey - lf@o-t.ch - 0x0007104B.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - lf@o-t.ch - 0x0007104B.asc"; name="publickey - lf@o-t.ch - 0x0007104B.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tDQpWZXJzaW9uOiBPcGVuUEdQLmpz
IHY0LjYuMg0KQ29tbWVudDogaHR0cHM6Ly9vcGVucGdwanMub3JnDQoNCnhqTUVYY01NOFJZSkt3
WUJCQUhhUnc4QkFRZEEyeUZUQXVQb3VvazNmdXFYbUZwYWdhdUhHRnI3R2g0eg0KTnlZeUFMNElI
TFRORld4bVFHOHRkQzVqYUNBOGJHWkFieTEwTG1Ob1BzSjNCQkFXQ2dBZkJRSmR3d3p4DQpCZ3NK
QndnREFnUVZDQW9DQXhZQ0FRSVpBUUliQXdJZUFRQUtDUkRRK0hrU3ZrRVZZSFRpQVFEVTQwTGIN
CjJRY3UvdjhrdDZxS0x0bHhTcmVnQTBHQ09GN2xaeXN5eTdzTndRRUFqL3ByWEZoeWdpbmdzSE5o
U3pUMw0KSm13Ykh3ME1YUENmU29rUlRFTzgxQXJPT0FSZHd3enhFZ29yQmdFRUFaZFZBUVVCQVFk
QVBTdGlRRGRvDQowazY5dTFySGpBZlViUE9aVzhCcUFnQzRVUUl1UWs0b3JrTURBUWdId21FRUdC
WUlBQWtGQWwzRERQRUMNCkd3d0FDZ2tRMFBoNUVyNUJGV0JnY3dFQSs4aVFMN1dmb2hyY3Rxd2FY
cHViYW9TN2x6bjlENFE5STFkRQ0KQVFrN0J4SUJBS2x1azd6bUFFZmYyQ0VTMDFhSWtTM2NmM0h6
dEJ4RHlhSURqZ2JsWWJrQg0KPU9xY1oNCi0tLS0tRU5EIFBHUCBQVUJMSUMgS0VZIEJMT0NLLS0t
LS0NCg==
-----------------------9ba5a6241835e4ce0b80fdee860697d4--

-----------------------01260ba3a17472455ad2771779aef3d6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wl4EARYKAAYFAl4Ukl0ACgkQ0Ph5Er5BFWD+VQEAyJG0Ap56YuuD4N6FfYF3
pE/OvATtgE/LYSJuiF9z6DoBAMztcdolZot0lEaHDKq775Ugs2owWdAInBND
xsd+iHUG
=pjxI
-----END PGP SIGNATURE-----


-----------------------01260ba3a17472455ad2771779aef3d6--

