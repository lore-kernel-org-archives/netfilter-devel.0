From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Tue, 29 May 2007 11:54:07 +0200
Message-ID: <465BF83F.2050702@trash.net>
References: <465528CB.4020108@snapgear.com>	
	<200705250044.l4P0i3f8007580@toshiba.co.jp>
	<4656342A.5040202@snapgear.com>	 <4657FBD4.80506@trash.net>
	<1180381991.6505.46.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Philip Craig <philipc@snapgear.com>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180381991.6505.46.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> l=F6r 2007-05-26 klockan 11:20 +0200 skrev Patrick McHardy:
>=20
>=20
>>We can add flags for new features, but not flags that are required to
>>be set to behave compatible since that would break iptables userspace
>>for old kernels.
>=20
>=20
> But the proposed change is completely transparent to userspace... the
> use of the new flags is purely kernel-only and not visible to
> userspace..


Yes, certainly, that statement was not specific to this patch.

> The drawback is that it reduces the possible new flags which might be
> added by two bits, or if put another way reduces the flags field from 8
> to 6 bits, leaving only 3 unused flag bits for future flag type
> expansions.
>
>=20
> But I am a little curious.. how much difference would it yield if simpl=
y
> the loop was instead changed to terminate on string end instead of
> always iterating over the max interface name length..
>=20
>         for (i =3D 0, ret =3D 0; ((const unsigned long *)ipinfo->outifa=
ce_mask)[i] && i < IFNAMSIZ/sizeof(unsigned long); i++) {
> 		...
>         }
>=20
> instead of
>=20
>         for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned long); i+=
+) {
> 		...
> 	}
>=20
> plus a small change to the userspace to zero the mask after the first \=
0
> in the interface name on exact matches.


It already does that I think. This sounds like a good alternative,
I'd be interested to see how much improvement it yields.
