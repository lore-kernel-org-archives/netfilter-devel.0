From: Harald Welte <laforge@netfilter.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Tue, 7 Sep 2004 10:41:51 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040907084151.GG16651@obroa-skai.de.gnumonks.org>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgApRN/oydYDdnYz"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Karsten Desler <kdesler@soohrt.org>
Content-Disposition: inline
In-Reply-To: <20040906205653.GA4626@soohrt.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--OgApRN/oydYDdnYz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 06, 2004 at 10:56:53PM +0200, Karsten Desler wrote:
> Hi,
>=20
> again referring to your Weblog about the Sun V20z boxes for high-speed
> packet filtering:
> After spending a few days googling and trying to recreate results that
> are at least somewhere around your numbers, I'm out of ideas.
> Just two quick questions:
>         a) How? :), or
>         b) is that the expected 'ip_tables performance sucks'-performance?

no, you're definitely getting worse results.  However, I never tested
with packet sizes > 64bytes, since I was only interested in the worst
case performance.
=20
> I'm using two Opteron 244 on a Tyan S2882 mainboard with 2gb of RAM
> and a vanilla 64bit 2.6.9-rc1-bk11 kernel.

- 32bit kernels are faster for packet formwarding (5-10%)
- how fast are your pci busses?  (I had PCI-X 133)
- how fast is your memory (I had DDR400) _VERY_ important!

> - e1000 is compiled with NAPI.
> - tso is activated for both cards

tso doesn't make any difference for packet filtering

> - I've increased ip_conntrack_htable_size to 65536.

maybe still too little,

> - My traffic is largely udp traffic (around 90%) with a distribution of:
>     20%  0  -   75 bytes,
>     60% 76  -  150 bytes,
>     10% 151 -  225 bytes and
>     10% 226 - 1500 bytes
>=20
> Thanks in advance,
>  Karsten
>=20
> eth0 is:
> 0000:01:01.0 Ethernet controller: Intel Corp. 82545EM Gigabit Ethernet Co=
ntroller (Fiber) (rev 01)
> eth1 is:
> 0000:01:03.0 Ethernet controller: Intel Corp. 82546GB Gigabit Ethernet Co=
ntroller (rev 03)

This seems like both e1000 seem to be attached to the same PCI bus,
which is probably also not good for highest performance
> /proc/interrupts:
>            CPU0       CPU1
>   0:   67093304          0    IO-APIC-edge  timer
>   8:          4          0    IO-APIC-edge  rtc
>   9:          0          0   IO-APIC-level  acpi
> 169:     117226          0   IO-APIC-level  libata
> 201:  213918484          0   IO-APIC-level  eth0
> 209:         11  211891491   IO-APIC-level  eth1

are you sure you have NAPI enabled?  You shouldn't get that much
interrupts if using NAPI and going into saturation

> net/ipv4/conf/all/rp_filter=3D1

never ever enable rp_filter, that makes a huge difference.  rp_filter is
not even recommended as default, and probably Debian is the only
distribution doing that mistake (read netdev archives on this).

> wc -l /proc/net/ip_conntrack
> 54243 /proc/net/ip_conntrack

Ok.  I was testing single-flow UDP performance, not 50k different
flows...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OgApRN/oydYDdnYz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBPXRNXaXGVTD0i/8RAp5bAJ9Jh0IzSeAFPWp6giGZPSrbAbci2gCfS79T
VZf1Anz70Tnxzz3yp+PIw6E=
=3/91
-----END PGP SIGNATURE-----

--OgApRN/oydYDdnYz--
