From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <ext-timo.teras@nokia.com>
Subject: IDLEDETECT target
Date: Mon, 16 Aug 2004 18:04:20 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4120CCF4.60003@nokia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD893600B080009AA497E0E74"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------enigD893600B080009AA497E0E74
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I'm currently planning to write a new target to detect when ever a 
network interface has been idle for a configurable amount of time.

First some background:

Usually this sort of thing can be accomplished by ppp modules 
PPPIOCGIDLE ioctl. However I need this sort of "IDLE detection" for 
interfaces other than ppp too. And usage of PPIOCGIDLE needs polling 
which I consider bad.

I came up with a couple of choices:
1. Use PF_PACKET and filter all packets that will be considered to reset 
the IDLE timer
2. Use iptables and QUEUE all packets as above
3. Poll match count of some iptable rule
4. Write a custom iptables target to send notification when interface 
goes to idle

Options 1 and 2 involve great amounts of kernel to userland traffic. And
option 3 would require polling with relatively small interval to be 
accurate enough.

So looks like the option four is ideal for my situation. I'd propably 
use netlink to send the events when interface seems to be idle. Other 
possibility is to use d-bus if it gets included in vanilla kernel (see 
http://vrfy.org/projects/kdbusd/).

Basically when ever a packet matches the IDLEDETECT target it would 
reset the interfaces idle timer. When the timer would expire a netlink 
message would be sent.

Now I'm asking if this is a good idea? And has anyone tried to do such a 
thing before?

If this approach seems to be okay I'd be willing to implement it 
(assuming no one has done this yet). In this case would this be useful 
enough to be included in the patch-o-matic (and possibly even mainstream 
kernel)?

Cheers,
   Timo

--------------enigD893600B080009AA497E0E74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBIMz3FlRU9HaAsIcRAoXQAJ9gBm1gxi0opyoJF12bhUYd/39zSQCeJfAz
a5pkaTRWGbcMVHjgZsh3qM0=
=eJ1D
-----END PGP SIGNATURE-----

--------------enigD893600B080009AA497E0E74--
