From: Phil Dibowitz <phil@ipom.com>
Subject: Re: Comments on iptstate
Date: Sun, 15 Feb 2004 23:41:59 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40307447.4030703@ipom.com>
References: <20040215190757.GC15567@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF3A6A68700E136278CAFA143"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040215190757.GC15567@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF3A6A68700E136278CAFA143
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> Hi!
> 
> I recently found out about your tool 'iptstate'.
> 
> First of all, I think it serves a good purpose, and it is definitely
> something that netfilter/iptables users need.

Thanks. I post new version the the netfilter mailing list...

> 1) reading /proc/net/ip_conntrack is currently (still) racy on SMP
>    boxes.  This means it cannot be used as reliable source.

I didn't know that. I'll put it in the docs of the next version. Thanks 
for the heads up.

> 2) reading /proc/net/ip_conntrack has a huge impact on the performance
>    of the conntrack system

Really? Also good to know.

> It would be fine if you could inform your users about those issues.
> Feel free to blame the netfilter/iptables developers, since it's our
> fault to offer such a broken interface in the first place.

Will do! =)

> I suggest to consider porting your application on top of ctnetlink (see
> libctnetlink in netfilter cvs and the nfnetlink-ctnetlink patch in
> patch-o-matic).

I might just do that. Do those libraries have hooks to do things like.. 
um, say remove a state from the state table? Its a commonly requested 
feature of iptstate.

> 3) The name of the application is misleading. iptables itself does not
>    track any state information.  it is ip_conntrack who does.  There is
>    almost no relation between both of them.

Sorry, but there's no way I'm renaming my app. =) I don't think its THAT 
misleading. ip_conntrack is an ip tables module. It's not some 
application that sits on top of any firewall, its very ip tables 
specific. It makes ip tables have stateful capabilities.

> Thanks for your attention,

Thanks for your comments!

-- 
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
  - Benjamin Franklin, 1759


--------------enigF3A6A68700E136278CAFA143
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFAMHRHN5XoxaHnMrsRAkkAAJ45+I52zQXXWJZ0bjgarUYsPYMbYACeMCYn
M3823nLuHHK+EY4iMrEBi/Q=
=jZ5O
-----END PGP SIGNATURE-----

--------------enigF3A6A68700E136278CAFA143--
