From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Wed, 06 Jun 2007 08:13:13 +0200
Message-ID: <46665079.80108@cosmosbay.com>
References: <465528CB.4020108@snapgear.com>	<200705250044.l4P0i3f8007580@toshiba.co.jp>	<4656342A.5040202@snapgear.com>	<4657FBD4.80506@trash.net>	<1180381991.6505.46.camel@henriknordstrom.net>	<465B72C0.5000907@snapgear.com>	<1180488846.6505.310.camel@henriknordstrom.net>
	<46664AE8.7020901@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46664AE8.7020901@snapgear.com>
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

Philip Craig a =E9crit :
> Henrik Nordstrom wrote:
>> tis 2007-05-29 klockan 10:24 +1000 skrev Philip Craig:
>>> I'll try that, but that will also prevent loop unrolling if you're
>>> using -funroll-loops.  Not sure if any builds use this, but the
>>> comment in the code implies some do.
>> My GCC unrolls that loop just fine...
>>
>> x86_64 gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-51)
>=20
> You're right, I should check things before making statements.
>=20
>> Here is a corrected version of the for loop:
>>
>> for (i =3D 0, ret =3D 0;  i < IFNAMSIZ/sizeof(unsigned long) && ((cons=
t unsigned long *)ipinfo->outiface_mask)[i]; i++) {
>>
>>
>> but for modern 64-bit CPUs I suspect the original is actually fastest =
as
>> IFNAMSIZ is only 16 bytes and fits in two parallel 64-bit operations..
>=20
> For my ARM platform, changing the for loop is a win for no interface
> matches, or short interface names (I didn't test longer interface names=
).
>=20
> But looking at the generated assembly for x86_64, this results in more
> instructions and branches, and I can't see this being a win.  (I'm not
> set up to profile this.)=20
>=20
> Also, the two optimisations are not mutually exclusive: one is to skip
> the whole comparison completely (including inversion), and one is to
> terminate the for loop early.  So we can use your loop termination
> condition to skip the whole comparison too.
>=20
> The attached patch is logically equivalent to my first (assuming a
> contiguous and zero padded mask), but it avoids messing with flags.  In
> practice, my profiling says it is slightly slower than the first patch
> for 0 interface matches, but slightly faster for 1 or 2.
>=20
> Note: this patch (and the original patch) change the behaviour when
> inverting a zero length mask.  That is for either of:
> 	iptables -A INPUT ! -i +
> 	iptables -A INPUT ! -i ""
> Not sure if this matters.
>=20
> I also tried testing just the first byte, instead of a long, but that
> was slower.
>=20
>=20

In my analysis (oprofiling), I found instructions were not really a probl=
em.

The big problem comes from the size of data that have to be read by the C=
PU to=20
perform a typical table lookup.

I consider 16 bytes masks (32 bytes per rule, one for iface, one for ofac=
e) is=20
a waste of memory. And on current CPUS, with 64 bytes cache lines, memory=
=20
bandwidth is the limiting factor.

We probably could use a mask length (one byte for iface, one for oface) t=
o=20
reduce memory footprint, and have better chance to keep tables in cpu cac=
hes.
