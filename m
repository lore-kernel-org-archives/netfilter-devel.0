From: Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 11:08:00 +0100
Message-ID: <518F6A00.2050205@bootc.net>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>  <1368291713-40132-3-git-send-email-bootc@bootc.net>  <20130511192150.GA10646@localhost> <518EA9B3.8050606@bootc.net>  <20130512004852.GA11205@localhost> <518F4EC7.1050403@bootc.net>  <20130512093405.GA12095@localhost> <1368352062.22387.15.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QPTAMFLAQETVHDCMKKVD"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:50049 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3ELKIW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 06:08:22 -0400
In-Reply-To: <1368352062.22387.15.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QPTAMFLAQETVHDCMKKVD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 12/05/2013 10:47, Eric Leblond wrote:
> Hi,
>=20
> Le dimanche 12 mai 2013 =E0 11:34 +0200, Pablo Neira Ayuso a =E9crit :
>> Hi Chris,
>>
>> On Sun, May 12, 2013 at 09:11:51AM +0100, Chris Boot wrote:
>>> On 12/05/2013 01:48, Pablo Neira Ayuso wrote:
>>>> On Sat, May 11, 2013 at 09:27:31PM +0100, Chris Boot wrote:
>>>> [...]
>>>>> Hi Pablo,
>>>>>
>>>>> I'd argue exactly the opposite point: that when you want multiple
>>>>> instances a PID file can help you work out which is which.
>>>> That new option may break existing setups with multiple instances.
>>>
>>> My patch explicitly doesn't change the behaviour of existing
>>> configurations. If you don't pass '--pidfile /path/to/file.pid', no p=
id
>>> file is written and there is no change in how ulogd works.
>>
>> Existing setups having already two ulogd2 instances will break, as
>> they won't be passing --pidfile, thus clashing on the same default pid=

>> file. One of the instances will not proceed. They will have to add
>> --pidfile to their scripts to get things back working.
>=20
> If I read the patch correctly, the pidfile is not created if the option=

> is not given:

[snip]

> But, as pointed out by Pablo's reading of the code, testing if we need
> to write the file only inside of write_pidfile() is a bit confusing
> something like:
>=20
>   if (ulogd_pidfile) write_pidfile(); // add error handling here
>=20
> would be better.

Yes, that makes sense, I'll change that and resubmit the patch.

Chris

--=20
Chris Boot
bootc@bootc.net


------enig2QPTAMFLAQETVHDCMKKVD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRj2oRAAoJEHG+dgSahnPilhcQAIgzGlM91x1SP9WLyvt7ypLW
057TTDnA2mWBVQ5p7/qqxcOqpd5ZIrQYeaU46PwdPTcvAs3ZF3IHfgqznEOqNQgW
FcH7QQRoj9OSxwBMcjDsKJebEHu53/8LC3BHacyyOFl47KRzBrHFTEvX7ouDdZL0
q1YDzlqWkiXr+LAoWY4IPAZUVgOt98SM5oIAmCWqCo05UOTAW9YvIyNkMQhYFjfE
wc+NMg2SVSQw1ykRaS6eLpQYSur6f3aqPiOjZGrlYD+YHBufqPlC9tTP1MoXPoYe
QQo8yalkCytCmSzbzVW5C/8a6LQ3xxuxCAV4iso1DzK1d9cZ3Cq0Tpp+YNAstOuN
XRgRiUAfwjwRtyOug4zmISWCRZMhuSoyN2DhztImzPxLrsfv06KOKgXl2dwxsPRf
GOUIl+oh7eZBEmNmHMLIb9lBt+b8kiFMjpFMp6MeOb+5rlpPdSW8nTV4/flphudR
8zp+Rd7jnqfHJViGfjrdyZdfu4DxI7B+xBWvWoNZGUqR7hTfys0xOwVV8zeBNjIa
8sESA5KCKtADpg9vyOZPCSauckW7jD1Equfah6aSTsdB++CXqoz7YCD/RV6iL7p8
BQC5x7tG+YzajaYP2FuGuneud4M31ZvX/gckZJtV+eTuf0O3jlMjTDngt9kezlGw
g2F9LzyAkaYPhxvyM/Yo
=rzMh
-----END PGP SIGNATURE-----

------enig2QPTAMFLAQETVHDCMKKVD--
