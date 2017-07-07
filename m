From: valdis.kletnieks@vt.edu
Subject: Re: how to get consistent value of "nf_conntrack_htable_size" and
	"nf_conntrack_hash" in a kernel module ?
Date: Fri, 07 Jul 2017 12:30:03 -0400
Message-ID: <7036.1499445003@turing-police.cc.vt.edu>
References: <1DAD1BCA-3138-4A7E-B64E-405EA12E6111@introo.me>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6444842417860573845=="
Cc: netfilter-devel@vger.kernel.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>
To: Shiyao Ma <i@introo.me>
Return-path: <kernelnewbies-bounces+glkk-kernelnewbies=gmane.org@kernelnewbies.org>
In-Reply-To: <1DAD1BCA-3138-4A7E-B64E-405EA12E6111@introo.me>
List-Unsubscribe: <https://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=unsubscribe>
List-Archive: <http://lists.kernelnewbies.org/pipermail/kernelnewbies>
List-Post: <mailto:kernelnewbies@kernelnewbies.org>
List-Help: <mailto:kernelnewbies-request@kernelnewbies.org?subject=help>
List-Subscribe: <https://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies>,
	<mailto:kernelnewbies-request@kernelnewbies.org?subject=subscribe>
Sender: kernelnewbies-bounces+glkk-kernelnewbies=gmane.org@kernelnewbies.org
Errors-To: kernelnewbies-bounces+glkk-kernelnewbies=gmane.org@kernelnewbies.org
List-Id: netfilter-devel.vger.kernel.org

--===============6444842417860573845==
Content-Type: multipart/signed; boundary="==_Exmh_1499445003_2904P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1499445003_2904P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Jul 2017 23:55:25 +0800, Shiyao Ma said:

> I want to foreach all the `struct nf_conn's in my out-of-tree kernel module.

What are you trying to do?  Hint: the very concept of "all" the nf_conn's is a
very racy one, especially on high-powered servers that have multiple 40 gigabit
ethernet cards on them, talking to other high-powered servers on the same
subnet. It's possible to get several million TCP connections in TIME_WAIT in a
matter of seconds.  The end result is that the kernel code is very much
optimized for the problem of "find *THIS* one nf_conn related to the packet
we're looking at before the next one shows up in a few microseconds", and
things like 'netstat -a' can basically go pound sand if they want to be 100%
accurate.

Summary:  It's quite possible for hundreds or even thousands of nf_conn's
to come and go in the time it takes you to walk the list.

> How to get a consistent value of `nf_conntrack_htable_size' and `nf_conntrack_hash' ?

What makes you think that "consistent value" is a concept that applies
to these numbers?  As mentioned above, they can be bouncing all over
the place on timespans smaller than the time needed to walk the list...

--==_Exmh_1499445003_2904P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWV+3C40DS38y7CIcAQJ3JAf8DPBAf12RXjnue7vqVoapcxGPgbkSr0I+
pyly3IGhEcbOwsYISnbFgtKnVnTKTlZRYu191I40rz/t5cCgIkrxD3JZut3//N0O
Z0OGyRjzZDrq85QxhFaQUTGs2JgzQyVHuqaZ4gbYdwVoULiWQBKdXp9tgFEOYGrn
2v7j0W19D0OqOcBxBDZhMU01MwC4U2bHQhC8uT/5/+FxxfMHCA5ho/u7oIi5aFnv
jG3CqZuv7s9YuwGHo25UmH18aqvJGKvE4wLYOynK+wHJKY+thFOIA+5eMkYJwjfz
bFnDONWLr5gbk9Hfkw5rZn1kqgJUh7yKdIfKRpn2bCu8JjspRjneIg==
=S7oc
-----END PGP SIGNATURE-----

--==_Exmh_1499445003_2904P--


--===============6444842417860573845==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Kernelnewbies mailing list
Kernelnewbies@kernelnewbies.org
https://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies

--===============6444842417860573845==--
