From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: l4_packet returning NF_DROP
Date: Thu, 12 Mar 2009 14:44:30 +0100
Message-ID: <200903121444.37625.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1622377.IAn0MISYdE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46915 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZCLNop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:44:45 -0400
Received: by ewy25 with SMTP id 25so361098ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2009 06:44:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart1622377.IAn0MISYdE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I have a question regarding the call to l4_packet, in nf_conntrack_in(...)=
=20
from nf_conntrack_core.c

When a module like TCP returns -NF_DROP in tcp_packet(...), the packet won'=
t=20
get dropped, because NF_DROP =3D 0, and in nf_conntrack_in the return of th=
e=20
call to l4_packet is checked:
if (ret < 0) {
	...
}

So, there is no way to drop packets after l4_packet.

Why does this is implemented that way?

There are several points in tcp_packet where the function returns -NF_DROP =
and=20
the comments in this function say that the packet will get blocked.

=46or example (from tcp_packet):

	if (index =3D=3D TCP_SYNACK_SET
		    && ct->proto.tcp.last_index =3D=3D TCP_SYN_SET
		    && ct->proto.tcp.last_dir !=3D dir
		    && ntohl(th->ack_seq) =3D=3D ct->proto.tcp.last_end) {
			/* b) This SYN/ACK acknowledges a SYN that we earlier
			 * ignored as invalid. This means that the client and
			 * the server are both in sync, while the firewall is
			 * not. We kill this session and block the SYN/ACK so
			 * that the client cannot but retransmit its SYN and
			 * thus initiate a clean new session.
			 */
			write_unlock_bh(&tcp_lock);
			if (LOG_INVALID(net, IPPROTO_TCP))
				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
					  "nf_ct_tcp: killing out of sync session ");
			nf_ct_kill(ct);
			return -NF_DROP;
		}

I hope, that I was clear.
Could someone please explain this to me?
And how can I block packets after the call to l4_packet?

Thanks

=2D-
Christoph Paasch

www.rollerbulls.be
=2D-

--nextPart1622377.IAn0MISYdE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm5Eb8ACgkQLHtZTroOLZuMDACgoKudAyUxUlhU78hbuKkPuHTg
NJUAoJH6c/TURgDRs/fFrFyhXpp/Lwbf
=zLPZ
-----END PGP SIGNATURE-----

--nextPart1622377.IAn0MISYdE--
