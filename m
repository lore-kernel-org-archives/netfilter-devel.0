From: Michael Richardson <mcr@sandelman.ca>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to per-namespace
Date: Wed, 18 Jul 2018 20:54:03 -0400
Message-ID: <15730.1531961643@localhost>
References: <20180717120651.15748-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: netdev@vger.kernel.org, nikita.leshchenko@oracle.com,
        roopa@cumulusnetworks.com, stephen@networkplumber.org,
        idosch@mellanox.com, jiri@mellanox.com, saeedm@mellanox.com,
        alex.aring@gmail.com, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
To: dsahern@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Type: text/plain

>>>>> David Ahern <dsahern@gmail.com> writes:
dsahern@kernel.org wrote:
    > Nikita Leshenko reported that neighbor entries in one namespace can
    > evict neighbor entries in another. The problem is that the neighbor
    > tables have entries across all namespaces without separate accounting
    > and with global limits on when to scan for entries to evict.

    > Resolve by making the neighbor tables for ipv4, ipv6 and decnet per
    > namespace and making the accounting and threshold limits per namespace.

This is a good improvement, thank you.
We absolutely need to keep a DOS against a single netns from causing
evictions in another netns.

Within a namespace there may be neighbours entries that are more
sure/valid/useful than others.  I would like an API to be able to
mark them explicitely, but that could come leter.

In particular, in the 802.15.4 case, NE that arrive via encrypted
channels should be preferred over entries that arrive over unencrypted
channels.  This is needed for IETF 6tisch secure join work, for instance.

I believe that we could use network namespaces to implement though.

I had not considered that before, and I think that it will work, but
there might be something subtle that I've missed.  (Alex?)
It appears that one can tune the amount of space on a per-namespace basis:

+	nd_tbl->gc_thresh1	= 128;
+	nd_tbl->gc_thresh2	= 512;
+	nd_tbl->gc_thresh3	= 1024;

> Remove open use of arp_tbl and nd_tbl in favor of the new
> ipv{4,6}_neigh_table helpers. Since the existence of the IPv6 table
> is managed by the core networking, the IS_ENABLED checks for IPv6
> can be removed in favor of "is the table non-NULL".

What's the advantage of changing this check? (I am ignorant)


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEVAwUBW0/hJ4CLcPvd0N1lAQIyJQf/bfxvt2k0AgkFh2XrPvTiZ0pdXdicbhHE
XDv5Fgft/iTBcvuDXH0ocIzPQGqyx46RbXBpH+ExJ/9YX3UHkaHQM19aDHZirOWj
WS7Wxhxzcb5Tum/HfaD8vBF9n0qqGrRvDidn8b+UR4E8dnrhb4NRk0XVOUPnYx+J
1dHMTOaPz1ubs/h3U48GpiMn8IdXeqTsQ569zYmM5G3SSMl9bTfCu4GDmcVoFXlZ
U+h5GXZm3COzqMl7UHiAGEcC++7OizvDv/R0dk2rE3jnUACSgk8tkN+t/ymSUfFg
C/VCZuwVUnZoSx5faWHd4OEdW10J5Z6Karuu4m7h0PM4tEYPNZHMGA==
=Tc0V
-----END PGP SIGNATURE-----
--=-=-=--
