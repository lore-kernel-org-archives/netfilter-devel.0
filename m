From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Checksum problem in tcp-window-tracking
Date: Sat, 12 Jun 2004 21:32:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087068742.1019.53.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XmGOwuovelIFduI0XDpS"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-XmGOwuovelIFduI0XDpS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Jozsef

Upgraded my kernel and started seeing lots of complaints from the
tcp-window-tracking code.

I only get the complaints on localhost<->localhost traffic, all other
traffic is complaint-free and working great :)

Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN=3D OUT=3D MAC=3D
SRC=3D127.0.0.1 DST=3D127.0.0.1 LEN=3D93 TOS=3D00 PREC=3D0x00 TTL=3D64 ID=
=3D6306 DF
PROTO=3DTCP SPT=3D6667 DPT=3D32813 SEQ=3D2226635880 ACK=3D2237541190 WINDOW=
=3D4095
ACK PSH URGP=3D0

"bad T" can only be this code from unclean()

        /* Checksum invalid?  Ignore. */
        /* FIXME: Source route IP option packets --RR */
        if (csum_tcpudp_magic(iph->saddr, iph->daddr,
                              tcplen, IPPROTO_TCP,
                              skb->ip_summed =3D=3D CHECKSUM_HW
                                ? skb->csum
                                : skb_checksum(skb, iph->ihl*4, tcplen, 0))=
) {
                if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
                        nf_log_packet(PF_INET, 0, skb, NULL, NULL,
                                  "ip_conntrack_tcp: INVALID: "
                                  "bad TCP checksum ");
                return 1;
        }

According to tcpdump the checksum is correct (otherwise we'd have a
serious bug in the tcp-stack :)

Any ideas?

--=20
/Martin

--=-XmGOwuovelIFduI0XDpS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAy1pGWm2vlfa207ERAgFMAKC91extkl9O8yGEQNw1E5EDLtAP1QCgqzRK
13U/jv+sF+MIK4ovH2ntHfg=
=JKZh
-----END PGP SIGNATURE-----

--=-XmGOwuovelIFduI0XDpS--
