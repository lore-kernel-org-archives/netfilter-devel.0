From: Nigel Kukard <nkukard@lbsd.net>
Subject: Re: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 20:21:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030615182139.GF2103@lbsd.net>
References: <20030615155352.GD2103@lbsd.net> <3EECA7B2.5090300@trash.net> <20030615180031.GE2103@lbsd.net> <3EECB5F4.7010004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EECB5F4.7010004@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Probably not much, but did you make sure you also increased
> /proc/sys/net/core/rmem_max ? If you don't mind your statistics
> beeing wrong (better than high drop rates imho) you could
> modify ip_queue so it nf_reinjects packets which could not
> be sent instead of returning a error to nf_queue.

This is very strange, i'm sure i'm doing something wrong.

I have rmem_max set to 272144, i use setsockopt to set the
options for the socket, namely SO_RCVBUF, this i set to 1048576.

The socket i create with  socket(PF_NETLINK,SOCK_RAW,NETLINK_FIREWALL).

(this is basicallly all in libipq, i've not changed more than the
rcvbuf).

now the strange thing is, when receiving data, i get IPQ_ERR_TIMEOUT's,
this being basically impossible imho because of the high packet rate.

after these timeouts, i get no data at all... data hits the queue, but
my small proggie doesn't get any (using a 1/4 timeout), funny enough i
don't get IPQ_ERR_TIMEOUTS... *shrug*... any help would be very much
appreciated!


-Nigel


--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7LkzKoUGSidwLE4RAobgAKCNLjqqPAllRyNHbMNmVyGsljOT0ACZAQYD
uBvQGaqm8g+zzIcTbUijLRc=
=rhbw
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
