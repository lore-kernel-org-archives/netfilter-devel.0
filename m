From: Phil Dibowitz <phil@ipom.com>
Subject: nfnetlink / ctnetlink / iptables2 questions
Date: Mon, 22 Nov 2004 21:31:46 -0800
Message-ID: <41A2CB42.4000009@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary=------------enig377E007635BE12B895EA9044
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------enig377E007635BE12B895EA9044
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

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
iptables2 is.

At the very least, libnfnetlink requires nfnetlink.h, which I would have 
thought was part of libnfnetlink, but it appears it's not. I found a 
"release" of iptables2 here:

http://lists.netfilter.org/pipermail/netfilter/2001-November/016646.html

which talkes about a whole lot of kernel incompatibilities between old 
versions and new versions and it doesn't appear the latest versions have 
made it into the kernel.org kernel tree yet. Is this correct? If so, 
this doesn't actually sound like something ready for primetime yet...

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


--------------enig377E007635BE12B895EA9044
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBostCN5XoxaHnMrsRArUfAJ9H+rExWzM8nrNzzQCmWEd/0v2A+ACglsOa
ca/OqnrZ7qImvtyi6MR5ixA=
=n7ah
-----END PGP SIGNATURE-----

--------------enig377E007635BE12B895EA9044--
