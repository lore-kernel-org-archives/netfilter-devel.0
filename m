From: Gregor Maier <gregor@net.in.tum.de>
Subject: API documentation for libnetfilter_log
Date: Fri, 24 Mar 2006 21:13:14 +0100
Message-ID: <442452DA.50407@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: brad@info-link.net
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I've written a first attemp for an API documentation for
libnetfilter_log. Some stuff in it was taken from Brad's
libnetfilter_queue documentation.

I added comments to the header file and used doxygen to generate the
actual docs. A patch that adds these comments to the source tree is
http://www.net.in.tum.de/~projects/doc.libnetfilter_log/doc.libnetfilter_log.patch

You can find the docs at  http://www.net.in.tum.de/~projects/


cu
gregor
- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEJFLadGiwgbikMYMRAqwxAJ9uC7cs2M7I/yhcE4yBD6KyHh9+MgCeL+VG
KbBXo0elWr/u8pmNmfBaUI4=
=6ETH
-----END PGP SIGNATURE-----
