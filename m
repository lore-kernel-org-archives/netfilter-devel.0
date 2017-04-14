From: Khem Raj <raj.khem@gmail.com>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
Date: Thu, 13 Apr 2017 18:22:54 -0700
Message-ID: <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com> <20170413233719.GB8577@salvia>
 <20170413234911.GA9656@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="45XBOiiHnSwkhLtuwpLbvJ0elQjlPlESU"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34446 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdDNBXC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:23:02 -0400
Received: by mail-pf0-f194.google.com with SMTP id o126so13428377pfb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 18:23:01 -0700 (PDT)
In-Reply-To: <20170413234911.GA9656@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--45XBOiiHnSwkhLtuwpLbvJ0elQjlPlESU
Content-Type: multipart/mixed; boundary="i0cfkAmUMlx6gcJ0WvRBw0gguE3FQ3EdH";
 protected-headers="v1"
From: Khem Raj <raj.khem@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com> <20170413233719.GB8577@salvia>
 <20170413234911.GA9656@salvia>
In-Reply-To: <20170413234911.GA9656@salvia>

--i0cfkAmUMlx6gcJ0WvRBw0gguE3FQ3EdH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 4/13/17 4:49 PM, Pablo Neira Ayuso wrote:
> On Fri, Apr 14, 2017 at 01:37:19AM +0200, Pablo Neira Ayuso wrote:
>> On Mon, Apr 10, 2017 at 12:58:04PM -0700, Khem Raj wrote:
>>> clang ignores the visibility attribute if its not
>>> defined before the definition. As a result these
>>> symbols become hidden and consumers of this library
>>> fail to link due to these missing symbols
>>
>> Also applied, thanks.
>=20
> Argh. Now we have two different ways to do this accross different
> libraries.
>=20
> Moreover, in you patch:
>=20
> http://patchwork.ozlabs.org/patch/749223/
>=20
> +int __EXPORTED nftnl_chain_set_data(struct nftnl_chain *c, uint16_t at=
tr,
>                          const void *data, uint32_t data_len)
>=20
> for what it used to be:
>=20
> +int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
>                          const void *data, uint32_t data_len)
>=20
> I wonder if there is a way to do this without a follow up patch to fix
> all these indentations.
>=20
> If this is just to fix clang, can you probably follow this patch instea=
d?
>=20
> http://git.netfilter.org/libmnl/commit/?id=3Ddcdb47373a375087d2dd8cee5e=
2a9c66fcc147eb
>=20

I tried similar patch but then thought of defining __EXPORT macro as
there was another netfliter component using same aproach as defining
__EXPORT.

> It would be good if you send me a patch for libnetfilter_queue that
> applies on top of you previous patch, or I can simply revert.

I will send a patch which uses EXPORT_FUNCTION instead and declare it
before definition like libmnl

I am fine with revert or patch on top, I can do both just let me know

>=20
> I just would like to keep this consistent for all libraries while
> fixing this clang issue.
>=20


--i0cfkAmUMlx6gcJ0WvRBw0gguE3FQ3EdH--

--45XBOiiHnSwkhLtuwpLbvJ0elQjlPlESU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iEYEARECAAYFAljwJHMACgkQuwUzVZGdMxTPCQCfZfUQxKO90Vbhf1JDqniym46e
z8IAn1o4lVH9YOMLxUUWf50Gai0Xp/BV
=9mvp
-----END PGP SIGNATURE-----

--45XBOiiHnSwkhLtuwpLbvJ0elQjlPlESU--
