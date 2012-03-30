From: Artyom Gavrichenkov <ximaera@gmail.com>
Subject: `iptables -m tcp --syn` doesn't do what the man says
Date: Sat, 31 Mar 2012 00:58:54 +0400
Message-ID: <4F761E8E.9000708@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig21353C5B78103A6773E1703B"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47255 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab2C3UkK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:40:10 -0400
Received: by bkcik5 with SMTP id ik5so975213bkc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Mar 2012 13:40:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig21353C5B78103A6773E1703B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

The iptables(8) manpage says:

--- [cut here] ---
   tcp
       These extensions can be used if `--protocol tcp' is specified. It =
provides the following options:
       [!] --syn
              Only  match  TCP packets with the SYN bit set and the ACK,R=
ST and FIN bits cleared.  Such packets are used to request TCP connection=
 initia=E2=80=90
              tion; for example, blocking such packets coming in an inter=
face will prevent incoming TCP connections, but outgoing TCP connections =
will  be
              unaffected.   It  is  equivalent  to  --tcp-flags  SYN,RST,=
ACK,FIN  SYN.   If  the "!" flag precedes the "--syn", the sense of the o=
ption is
              inverted.
--- [cut here] ---

Unfortunately, with current stable Linux kernel release (as well as
with most of the previous versions) blocking TCP packets with the SYN
bit set and the ACK,RST and FIN bits cleared won't prevent incoming
TCP connections.

Currently Linux TCP stack considers an incoming TCP segment to be a
connection initiation request if the segment only has SYN flag set and
ACK and RST flags cleared. You can easily check it yourself with your
nearest Linux box, as well as on the netfilter.org (213.95.27.115):

# hping3 -c 2 -n -FS -p 80 netfilter.org
HPING netfilter.org (wlan0 213.95.27.115): SF set, 40 headers + 0 data by=
tes
len=3D44 ip=3D213.95.27.115 ttl=3D52 DF id=3D0 sport=3D80 flags=3DSA seq=3D=
0 win=3D5840 rtt=3D58.8 ms
len=3D44 ip=3D213.95.27.115 ttl=3D52 DF id=3D0 sport=3D80 flags=3DSA seq=3D=
1 win=3D5840 rtt=3D51.1 ms

--- netfilter.org hping statistic ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max =3D 51.1/55.0/58.8 ms
#=20

As you see, the netfilter.org server sends SYN/ACK in response to an
incoming SYN/FIN, indicating that a connection is being established.
It is only a matter of a few checks to make sure that the indication
is correct and the connection is indeed initialized.

This might be a Linux bug as well to accept SYN/FIN as a connection
initiation attempt. However, there could as well be a reason for kernel
developers to do this, because such thing as T/TCP (RFC 1644) allows a
TCP server to act like this, and though this RFC is experimental and
obsolete, as far as I know, it is still implemented somewhere, for
example, in FreeBSD.

I guess that most iptables setups probably are not affected by this
behaviour, because `iptables -m tcp --syn' is often used for something
in lines of this:

iptables -A INPUT -p tcp -m tcp --dport 22 --syn -j ACCEPT
iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP

In this case, SYN/FIN segments will be dropped, because they are not
considered plain SYN and they are not associated with an established
connection. My guess is that, for example, kernel.org is set up like that=
:

# hping3 -c 2 -n -FS -p 80 kernel.org
HPING kernel.org (wlan0 149.20.4.69): SF set, 40 headers + 0 data bytes

--- kernel.org hping statistic ---
2 packets transmitted, 0 packets received, 100% packet loss
round-trip min/avg/max =3D 0.0/0.0/0.0 ms
#

However, there are cases when this behaviour produces clear security
breach, for example, when one is trying to prevent incoming TCP
connections from a certain IP (as manpage suggests) or when one is
trying to limit the rate of connection establishment attempts. In
this case attacker can send SYN/FIN packets which would pass all the
rules containing --syn and would establish a connection.

The patch to fix this is trivial (it is attached below), however, it
might be a good idea to discuss reasons first and find the best
solution possible.

P. S. Sorry for being so verbose, I'm new to this mailing list and I'm
trying to explain everything as clear as I can.

--=20
| Artyom Gavrichenkov
| gpg: fa1c670e
| mailto: ximaera@gmail.com
| xmpp: ximaera@gmail.com
| skype: xima_era
| tel. no: +7 916 515 49 58

-- Signed-off-by: Artyom Gavrichenkov <ximaera@gmail.com>

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index e849fa2..3af03c4 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -169,7 +169,7 @@ tcp_parse(int c, char **argv, int invert, unsigned in=
t *flags,
                        xtables_error(PARAMETER_PROBLEM,
                                   "Only one of `--syn' or `--tcp-flags' =
"
                                   " allowed");
-               parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", invert=
);
+               parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);
                *flags |=3D TCP_FLAGS;
                break;
=20
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index 7a16118..e1698df 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -31,12 +31,12 @@ will only match packets with the SYN flag set, and th=
e ACK, FIN and
 RST flags unset.
 .TP
 [\fB!\fP] \fB\-\-syn\fP
-Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits=

+Only match TCP packets with the SYN bit set and the ACK and RST bits
 cleared.  Such packets are used to request TCP connection initiation;
 for example, blocking such packets coming in an interface will prevent
 incoming TCP connections, but outgoing TCP connections will be
 unaffected.
-It is equivalent to \fB\-\-tcp\-flags SYN,RST,ACK,FIN SYN\fP.
+It is equivalent to \fB\-\-tcp\-flags SYN,RST,ACK SYN\fP.
 If the "!" flag precedes the "\-\-syn", the sense of the
 option is inverted.
 .TP


--------------enig21353C5B78103A6773E1703B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk92Ho4ACgkQ9HpYY/ocZw75VQCePneMYuHZCcv06KjkAdWQDx2m
qVsAnj/7fbwVG4LF+b16/N76Yr4ca8ok
=W2BH
-----END PGP SIGNATURE-----

--------------enig21353C5B78103A6773E1703B--
