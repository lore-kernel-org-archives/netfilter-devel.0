From: Phil Dibowitz <phil@ipom.com>
Subject: Re: mss to pmtu clamping partially broken?
Date: Mon, 2 Jul 2007 12:35:41 -0700
Message-ID: <20070702193541.GA14961@ipom.com>
References: <4684E853.20900@domdv.de>
	<Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
	<4689300C.9050802@domdv.de> <20070702182850.GB14507@ipom.com>
	<Pine.LNX.4.64.0707022113330.25153@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org, Andreas Steinmetz <ast@domdv.de>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707022113330.25153@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 02, 2007 at 09:16:57PM +0200, Krzysztof Oledzki wrote:
>
>
> On Mon, 2 Jul 2007, Phil Dibowitz wrote:
>
>> On Mon, Jul 02, 2007 at 07:04:12PM +0200, Andreas Steinmetz wrote:
>>> Jan Engelhardt wrote:
>>>> Do you really need clamping? It's a hack, since TCP should do MSS=20
>>>> negotiation
>>>> itself. (Of course it may happen that some routers are broken.) But=20
>>>> usually not
>>>> for incoming packets.
>>>
>>> You never know when you hit ICMP blackholes, broken routers and other
>>> evil things. Better safe than sorry so clamping is the way to go for me.
>>
>> I encourage you to report PMTUD Blackholes to the MSS Initiative at
>> http://www.phildev.net/mss/
>
> Any chances for similar initiative for "SACK vandals"? ;)

There's already a counterpart for ECN blackholes, so I'm not opposed to it.
However, keeping up with new reports, re-testing existing offenders, etc.
takes up a good chunk of time, so I don't have the time to do it myself. I'm
happy to reference such a site, however.

Though - I'm not familiar with the problem of SACK vandals either. There
appears to be a thread on here, I'll go read it...

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGiVONN5XoxaHnMrsRAq/sAJ9LU8QSHmWweicfOeZIH6aVnkxliACfY3P2
Lk50bXqfRzg3G1mCZvbFbpg=
=SomG
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
