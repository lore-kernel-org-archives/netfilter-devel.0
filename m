From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the net-next tree with the netfilter
 tree
Date: Tue, 7 Aug 2018 12:49:32 +1000
Message-ID: <20180807124932.73422224@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5oHuR.sWIpxOyl4ZQBWjMrI"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>, Julian Anastasov <ja@ssi.bg>
To: David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/5oHuR.sWIpxOyl4ZQBWjMrI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/netfilter/ipvs/ip_vs_conn.c

between commit:

  16e98cec49a4 ("ipvs: don't show negative times in ip_vs_conn")

from the netfilter tree and commit:

  ec1b28ca9674 ("ipvs: provide just conn to ip_vs_state_name")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/netfilter/ipvs/ip_vs_conn.c
index 615286dcf4c0,0edc62910ebf..000000000000
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@@ -1107,10 -1122,8 +1122,10 @@@ static int ip_vs_conn_seq_show(struct s
  				&cp->caddr.in6, ntohs(cp->cport),
  				&cp->vaddr.in6, ntohs(cp->vport),
  				dbuf, ntohs(cp->dport),
- 				ip_vs_state_name(cp->protocol, cp->state),
+ 				ip_vs_state_name(cp),
 -				(cp->timer.expires-jiffies)/HZ, pe_data);
 +				jiffies_delta_to_msecs(cp->timer.expires -
 +						       jiffies) / 1000,
 +				pe_data);
  		else
  #endif
  			seq_printf(seq,
@@@ -1120,10 -1133,8 +1135,10 @@@
  				ntohl(cp->caddr.ip), ntohs(cp->cport),
  				ntohl(cp->vaddr.ip), ntohs(cp->vport),
  				dbuf, ntohs(cp->dport),
- 				ip_vs_state_name(cp->protocol, cp->state),
+ 				ip_vs_state_name(cp),
 -				(cp->timer.expires-jiffies)/HZ, pe_data);
 +				jiffies_delta_to_msecs(cp->timer.expires -
 +						       jiffies) / 1000,
 +				pe_data);
  	}
  	return 0;
  }
@@@ -1173,10 -1184,9 +1188,10 @@@ static int ip_vs_conn_sync_seq_show(str
  				&cp->caddr.in6, ntohs(cp->cport),
  				&cp->vaddr.in6, ntohs(cp->vport),
  				dbuf, ntohs(cp->dport),
- 				ip_vs_state_name(cp->protocol, cp->state),
+ 				ip_vs_state_name(cp),
  				ip_vs_origin_name(cp->flags),
 -				(cp->timer.expires-jiffies)/HZ);
 +				jiffies_delta_to_msecs(cp->timer.expires -
 +						       jiffies) / 1000);
  		else
  #endif
  			seq_printf(seq,
@@@ -1186,10 -1196,9 +1201,10 @@@
  				ntohl(cp->caddr.ip), ntohs(cp->cport),
  				ntohl(cp->vaddr.ip), ntohs(cp->vport),
  				dbuf, ntohs(cp->dport),
- 				ip_vs_state_name(cp->protocol, cp->state),
+ 				ip_vs_state_name(cp),
  				ip_vs_origin_name(cp->flags),
 -				(cp->timer.expires-jiffies)/HZ);
 +				jiffies_delta_to_msecs(cp->timer.expires -
 +						       jiffies) / 1000);
  	}
  	return 0;
  }

--Sig_/5oHuR.sWIpxOyl4ZQBWjMrI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltpCLwACgkQAVBC80lX
0GxyAQf+NVGK9Cmolhg6Gv6zrJRV/cCYPTo4/aigQUpVa/0YkaABbnb0oRtwUw7v
06uT4YcyVZH6OncGq7z54Ee1JrkpkH/jTVqpogSuHTZOls9NIlXRV2u8+BzNE+In
3Jx2YiWniH37bCt8nCXnf8GzAKNxfG+uLQyfSgfUyWjPtY6kzr9KfP1T03Pmx7iN
hdmo9ffjqnO1GByGvjeE6sBXFA8lUibR1citQj9ix8hi5fzgcAwQCKX27qVINv7z
9BiNQytzZPIz52SWIHEaJBmsnrl3FAuWyfc4xlbnCLaE0DcOJjvxh/6M/2BnkN/T
TRE/J9t7SmAVyySR6VK34XZaOyBO0w==
=OpEJ
-----END PGP SIGNATURE-----

--Sig_/5oHuR.sWIpxOyl4ZQBWjMrI--
