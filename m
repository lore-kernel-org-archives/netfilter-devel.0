From: Markus Schaber <markus.schaber@student.uni-ulm.de>
Subject: Re: Problem with IP-Pools
Date: Thu, 5 Dec 2002 22:43:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205224314.3c38afec.markus.schaber@student.uni-ulm.de>
References: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>
	<20021205201113.GD11068@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1"; boundary="=.lE8iGs8MNcKMC."
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021205201113.GD11068@naboo.club.berlin.ccc.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=.lE8iGs8MNcKMC.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

Harald Welte wrote:

> > I'm using the IP Pools extension form Patch-O-matic, and now have
> > the problem that it tends to kill the machine on SMP. (I just killed
> > our backup firewall two times this day...)
> 
> I think the pool stuff is pretty much unmaintained as of now, sorry.
> It was a contribution to the project, and the original author (Gerd
> Knorr, IIRC) has abandoned it.

Thanks for your information.

That's rather sad, because we have several groups of hosts in our subnet
that have different rules each, and pools are just the most efficient
way to match those groups we found.

You see, we're doing Gigabit ethernet here (about 600 MBit upstream
bandwidth), and our largest host group currently has 9497 Entries.
That's just too much for the usual O(n) method, one table containing one
match rule per host, and building some tree-like tables to cut down the
pass time to O(log(n)) is a maintenance nightmare.

Not to mention the time to load an iptable with some tens of thousands
of entries, we cannot wait half an hour for our firewall to boot up.

Currently, my Boss does real-life testing using single processor
kernels, and it seems that it works using current hardware (although I
don't know yet how it performed during the peak times), and it seems to
manage the traffic and to be rather stable.

If you know another method of managing such high traffic and host number
combinations, we'd love to hear about it, because we _really_ want to
leave Checkpoint.

Markus

-- 
Schabi's Flohmarkt: http://www.uni-ulm.de/~s_mschab/flohmarkt/

Der Dienstweg ist die Verbindung der Sackgasse mit dem Holzweg!
[DoLi in unibwm.studium]

--=.lE8iGs8MNcKMC.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (GNU/Linux)

iD8DBQE978hy6IhVmcufrl4RAjU7AJ9mXBWjPHqmQqlFv9Xoa7Nhip2zlwCgi5sN
5oLqQl4gSaq2A8nGlmiBEZQ=
=UG1V
-----END PGP SIGNATURE-----

--=.lE8iGs8MNcKMC.--
