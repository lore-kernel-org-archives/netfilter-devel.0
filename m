From: Phil Dibowitz <phil@ipom.com>
Subject: REPOST: nfnetlink / ctnetlink / iptables2 questions
Date: Fri, 17 Dec 2004 21:48:35 -0800
Message-ID: <41C3C4B3.2060003@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary=------------enigBA121E421DAAD2C0ABE2DDC3
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA121E421DAAD2C0ABE2DDC3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

NOTE: I'm reposting this as I never got a response. I independently 
posted to both netfilter and netfilter-devel before, but am now posting 
to both. Hopefully _someone_ can answer this.


Hey folks,

A while back Herald Welte emailed me (and CC'd the list) and suggested I 
port my application (iptstate) to use the new ctnetlink/nfnetlink 
framework (as opposed to reading data out of /proc).

I haven't had much time since then, but I decided to sit down and look 
at this, and I'm a bit confused by what I found. I found libnfnetlink here:
http://ftp.iasi.roedu.net/netfilter/libnfnetlink/snapshot/
and libctnetlink here:
http://ftp.iasi.roedu.net/netfilter/libctnetlink/snapshot/

And since cfnetlink requires nfnetlink, I went to compile that first. 
And ran into some problems. So I started browsing the archives, and it 
seems people refer to an old "ctnetlink/nfnetlink" and a new one... and 
the new one is part of "iptables2" ? I haven't followed 
netfilter/iptables developement very carefully, so I don't know what 
iptables2 is, but seems to be the latest suite of "frontend" 
applications to netfilter.

At the very least, libnfnetlink requires nfnetlink.h, which I would have 
thought was part of libnfnetlink, but it appears it's not. I found a 
mention of a "release" of iptables2 here:

http://lists.netfilter.org/pipermail/netfilter/2001-November/016646.html

but the download requires a password which I don't have. Additionally 
the post talkes about a whole lot of kernel incompatibilities between 
old versions and new versions and it doesn't appear the latest versions 
have made it into the main kernel tree yet. Is this correct? If so, this 
doesn't actually sound like something ready for primetime yet...

Perhaps someone can relate ctnetlink/nfnetlink (old and new) to 
libcfnetlink/libnfnetlink and iptables2, and the current kernels for me?

Thanks...
-- 
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
  - Benjamin Franklin, 1759


--------------enigBA121E421DAAD2C0ABE2DDC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBw8SzN5XoxaHnMrsRAvE7AJ4/kfpR0NBppSshbobanFv7ZKG9+QCgqAkn
Q/pMYco5X+TNvn07cstXMoA=
=Hetd
-----END PGP SIGNATURE-----

--------------enigBA121E421DAAD2C0ABE2DDC3--
