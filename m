From: Harald Welte <laforge@netfilter.org>
Subject: Re: IDLEDETECT target
Date: Thu, 19 Aug 2004 12:29:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819102935.GF3921@sunbeam.de.gnumonks.org>
References: <4120CCF4.60003@nokia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZljC5FVPx7rxDQQ8"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Timo =?iso-8859-1?Q?Ter=E4s?= <ext-timo.teras@nokia.com>
Content-Disposition: inline
In-Reply-To: <4120CCF4.60003@nokia.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZljC5FVPx7rxDQQ8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 16, 2004 at 06:04:20PM +0300, Timo Ter=E4s wrote:

> Usually this sort of thing can be accomplished by ppp modules=20
> PPPIOCGIDLE ioctl. However I need this sort of "IDLE detection" for=20
> interfaces other than ppp too. And usage of PPIOCGIDLE needs polling=20
> which I consider bad.
>=20
> I came up with a couple of choices:
> 1. Use PF_PACKET and filter all packets that will be considered to reset=
=20
> the IDLE timer
> 2. Use iptables and QUEUE all packets as above
> 3. Poll match count of some iptable rule
> 4. Write a custom iptables target to send notification when interface=20
> goes to idle

5. use ULOG target (and only copy packet metadata, using reasonable
buffer size this should give you very little kernel/userspace
transitions) just '-j ULOG --ulog-cprange 0' all packets that reset the
timeout.  Set the --ulog-qthreshold to a high value, and make the
'flushtimeout' module parameter as large as possible within your given
granularity.  Let's say you use a 128k ulog netlink buffer, you would
fit about 640 of such packets into one buffer before it gets flushed to
userspace.  Not ideal, I agree :(

> Options 1 and 2 involve great amounts of kernel to userland traffic.=20

1) Not if you use a mmap'ed packet socket (there's a mmap ring enabled
   libpacp out there)
2) Not if you ulog instead of QUEUE, and you especially don't cause any
   packet delays.

> And option 3 would require polling with relatively small interval to
> be accurate enough.

And reading the whole iptables ruleset with such a small interval is not
a cheap operation either (because all per-cpu per-rule counters need to
get added up, etc).

> So looks like the option four is ideal for my situation. I'd propably=20
> use netlink to send the events when interface seems to be idle. Other=20
> possibility is to use d-bus if it gets included in vanilla kernel (see=20
> http://vrfy.org/projects/kdbusd/).

Adding a new netlink family just for this would also definitely not get
into the mainline kernel, since we're slowly but steadily running out of
netlink numbers.

As for d-bus, I haven't heared any core kernel developer's opionion so
far.

> Basically when ever a packet matches the IDLEDETECT target it would=20
> reset the interfaces idle timer. When the timer would expire a netlink=20
> message would be sent.

mh. What about basing this on conntrack?  whenever a packet matching a
connection arrives, it also resets the timeout of those conntracks.

So using ctnetlink, you could read out the conntrack table in regular
intervals (let's say every 10 seconds).   Then you filter out only those
ESTABLISHED connections that you're interested in, and compare their
timeout values with the default timeouts.

If all of them are mor than <itldetimeout> seconds away from the default
timeout, you know that none of those connections have seen a packet so
far.

> If this approach seems to be okay I'd be willing to implement it=20
> (assuming no one has done this yet). In this case would this be useful=20
> enough to be included in the patch-o-matic (and possibly even mainstream=
=20
> kernel)?

Yes, you can do it your own way.  I would include it in patch-o-matic.
But I am still not sure whether it's really worth having yet another
over-specialized target.


> Cheers,
>   Timo



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZljC5FVPx7rxDQQ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJIEPXaXGVTD0i/8RAjO7AKCG3zi2x3Eo/UyvE5zz12VA3LksgACgo4YE
Fh6KMatVF5sR5ElRiBFgrig=
=vZzl
-----END PGP SIGNATURE-----

--ZljC5FVPx7rxDQQ8--
