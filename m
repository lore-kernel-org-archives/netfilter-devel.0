From: Thomas Heinz <creatix@hipac.org>
Subject: ipt_do_table
Date: Wed, 07 Jan 2004 20:54:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FFC63D9.70705@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7BF56A0DB8E1319C2914D54C"
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
--------------enig7BF56A0DB8E1319C2914D54C
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Why does ipt_do_table use read_lock_bh instead of read_lock?
The concurrent counter snapshot resp. table modification
operations acquiring the write lock run in process context
and ipt_do_table itself should be reentrant.

What am I missing?


Regards,

Thomas

--------------enig7BF56A0DB8E1319C2914D54C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQE//GPe8oNQPJ8CvngRAuq8AJ9AQEpxyBe33/edFDIZvTDHvmB4cgCbBmvi
bRogieEiqphFSBBoNrY1O10=
=z+C2
-----END PGP SIGNATURE-----

--------------enig7BF56A0DB8E1319C2914D54C--
