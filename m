From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: `iptables -m tcp --syn` doesn't do what the man says
Date: Sun, 1 Apr 2012 19:42:40 +0200
Message-ID: <20120401174240.GA11306@1984>
References: <4F761E8E.9000708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Artyom Gavrichenkov <ximaera@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab2DARmn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:42:43 -0400
Content-Disposition: inline
In-Reply-To: <4F761E8E.9000708@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 31, 2012 at 12:58:54AM +0400, Artyom Gavrichenkov wrote:
> Hi all,
>=20
> The iptables(8) manpage says:
>=20
> --- [cut here] ---
>    tcp
>        These extensions can be used if `--protocol tcp' is specified.=
 It provides the following options:
>        [!] --syn
>               Only  match  TCP packets with the SYN bit set and the A=
CK,RST and FIN bits cleared.  Such packets are used to request TCP conn=
ection initia=E2=80=90
>               tion; for example, blocking such packets coming in an i=
nterface will prevent incoming TCP connections, but outgoing TCP connec=
tions will  be
>               unaffected.   It  is  equivalent  to  --tcp-flags  SYN,=
RST,ACK,FIN  SYN.   If  the "!" flag precedes the "--syn", the sense of=
 the option is
>               inverted.
> --- [cut here] ---
>=20
> Unfortunately, with current stable Linux kernel release (as well as
> with most of the previous versions) blocking TCP packets with the SYN
> bit set and the ACK,RST and FIN bits cleared won't prevent incoming
> TCP connections.
>=20
> Currently Linux TCP stack considers an incoming TCP segment to be a
> connection initiation request if the segment only has SYN flag set an=
d
> ACK and RST flags cleared. You can easily check it yourself with your
> nearest Linux box, as well as on the netfilter.org (213.95.27.115):
>=20
> # hping3 -c 2 -n -FS -p 80 netfilter.org
> HPING netfilter.org (wlan0 213.95.27.115): SF set, 40 headers + 0 dat=
a bytes
> len=3D44 ip=3D213.95.27.115 ttl=3D52 DF id=3D0 sport=3D80 flags=3DSA =
seq=3D0 win=3D5840 rtt=3D58.8 ms
> len=3D44 ip=3D213.95.27.115 ttl=3D52 DF id=3D0 sport=3D80 flags=3DSA =
seq=3D1 win=3D5840 rtt=3D51.1 ms
>=20
> --- netfilter.org hping statistic ---
> 2 packets transmitted, 2 packets received, 0% packet loss
> round-trip min/avg/max =3D 51.1/55.0/58.8 ms
> #=20
>=20
> As you see, the netfilter.org server sends SYN/ACK in response to an
> incoming SYN/FIN, indicating that a connection is being established.
> It is only a matter of a few checks to make sure that the indication
> is correct and the connection is indeed initialized.
>=20
> This might be a Linux bug as well to accept SYN/FIN as a connection
> initiation attempt. However, there could as well be a reason for kern=
el
> developers to do this, because such thing as T/TCP (RFC 1644) allows =
a
> TCP server to act like this, and though this RFC is experimental and
> obsolete, as far as I know, it is still implemented somewhere, for
> example, in FreeBSD.
>=20
> I guess that most iptables setups probably are not affected by this
> behaviour, because `iptables -m tcp --syn' is often used for somethin=
g
> in lines of this:
>=20
> iptables -A INPUT -p tcp -m tcp --dport 22 --syn -j ACCEPT
> iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCE=
PT
> iptables -A INPUT -j DROP
>=20
> In this case, SYN/FIN segments will be dropped, because they are not
> considered plain SYN and they are not associated with an established
> connection. My guess is that, for example, kernel.org is set up like =
that:
>=20
> # hping3 -c 2 -n -FS -p 80 kernel.org
> HPING kernel.org (wlan0 149.20.4.69): SF set, 40 headers + 0 data byt=
es
>=20
> --- kernel.org hping statistic ---
> 2 packets transmitted, 0 packets received, 100% packet loss
> round-trip min/avg/max =3D 0.0/0.0/0.0 ms
> #
>=20
> However, there are cases when this behaviour produces clear security
> breach, for example, when one is trying to prevent incoming TCP
> connections from a certain IP (as manpage suggests) or when one is
> trying to limit the rate of connection establishment attempts. In
> this case attacker can send SYN/FIN packets which would pass all the
> rules containing --syn and would establish a connection.

I understand your concern, but the info in the manpage is correct:
basically, it can be extracted from it that --syn will not match
SYN+FIN packets.

As you point in your patch, you have to use:

--tcp-flags  SYN,RST,ACK  SYN

in your rule-set for the situation that you describe.

Changing the default behaviour of --syn to catch this case is
delicate, I don't want to break backward compatibility.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
