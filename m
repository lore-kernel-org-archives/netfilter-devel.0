From: <alnsn@yandex.ru>
Subject: H.323 status
Date: Wed, 31 Mar 2004 19:11:49 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331151149.GA3644@x1000.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
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


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

{This is second attempt since first attempt to post seems to fail}

Hi,
Do you have any progress in H.323 conntrack since my last post?
http://lists.netfilter.org/pipermail/netfilter-devel/2003-October/012776.html

I've taken a quick look at netfilter-* archive. There is a permanent
interest (though modest, a little bit more then a couple of messages
per month). I saw a post with a promise to implement it this year (not
sure it was a promise, may be it's only a hope).
My questions are, (a) what parser is supposed to be used to parse H.323
data and (b) is there any plan to integrate H.323 with QoS
(CONFIG_NET_SCHED).

I still don't know about new H.323 parser used in ethereal. It may
become a good ground for userspace h323-conntrack. Is this it?
I hope to have some time this year to finish my callback-based parser.
After some optimization applied it could be used even in kernel space.
BTW question. Is it possible in conntrack to change IP verstion during
packet forwarding? I expect a positive answer. If this is the case,
a length of IP address encoded in H.323 data may be changed. It
complicates the implementation but I hope only a little.
--
Alexander Nasonov
Independent Developer & Consultant

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAat+1K8n/CZPtRx4RAsorAKCpMnzmC2sYv5Qa+IF9v9AQxEdj/gCfV7MZ
lVmNZRzFU4cY6nISdFfa//o=
=cAF0
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
