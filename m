From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Idea: string replace
Date: Tue, 1 Oct 2002 03:13:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021001011306.GG16521@noir.cb.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/VI3ydZO+RcZ3Ux"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--w/VI3ydZO+RcZ3Ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

I have an idea, which is IMHO very suitable for China. Er, no, wanted to say
something different, suitable for me. How about adding a --replace-with option
to the string match? Is it difficult? Or could this be done with the NETLINK
target?

Why am I asking? I would like to prevent users behind a router becoming
infected with a virus (a specific one, not the thousands others). I made a
string match for it and direct all pop3/imap trafic through this rule. The
problem is, although I can find it, I can't reasonably get rid of it. The
most reasonable solution seems to be to -j REJECT --reject-with tcp-reset, but
I assume this causes problems.  So I'd rather change the string to something
bogus, which will make the virus unexecutable.

Or do you know a filtering transparent pop3/imap proxy? I have no access to
the dozens of servers the users have emails on. Unless the solution is fully
transparent, it will cause too high organisational overhead which is not
sensible to manage for us. Also not manageable is educating the users about
"safe use of computers".

Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
                   Disc space - The final frontier.

--w/VI3ydZO+RcZ3Ux
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9mPaizogxsPZwLzcRAkNSAJ95b3lO6DKcJePTrnE3R8Jrr9eETACgm2eq
uLHOAkdFYGB6VqG7c8laYXw=
=Osmx
-----END PGP SIGNATURE-----

--w/VI3ydZO+RcZ3Ux--
