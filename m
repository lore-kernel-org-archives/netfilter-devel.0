From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: `iptables -m tcp --syn` doesn't do what the man says
Date: Fri, 30 Mar 2012 23:19:25 +0200
Message-ID: <1333142365.2325.2579.camel@edumazet-glaptop>
References: <4F761E8E.9000708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Artyom Gavrichenkov <ximaera@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48688 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965679Ab2C3VTa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:30 -0400
Received: by wibhr17 with SMTP id hr17so1007085wib.1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Mar 2012 14:19:29 -0700 (PDT)
In-Reply-To: <4F761E8E.9000708@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2012-03-31 at 00:58 +0400, Artyom Gavrichenkov wrote:
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

=46YI current linux kernel just drops this kind of message (SYN+FIN)

git describe --contains fdf5af0daf8019cec2396cdef8fb042d80fe71fa
v3.3-rc1~182^2~365

commit fdf5af0daf8019cec2396cdef8fb042d80fe71fa
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Fri Dec 2 23:41:42 2011 +0000

    tcp: drop SYN+FIN messages
   =20
    Denys Fedoryshchenko reported that SYN+FIN attacks were bringing hi=
s
    linux machines to their limits.
   =20
    Dont call conn_request() if the TCP flags includes SYN flag
   =20
    Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 78dd38c..0cbb440 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5811,6 +5811,8 @@ int tcp_rcv_state_process(struct sock *sk, struct=
 sk_buff *skb,
 			goto discard;
=20
 		if (th->syn) {
+			if (th->fin)
+				goto discard;
 			if (icsk->icsk_af_ops->conn_request(sk, skb) < 0)
 				return 1;
=20



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

Or it runs linux 3.3

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
>=20
> The patch to fix this is trivial (it is attached below), however, it
> might be a good idea to discuss reasons first and find the best
> solution possible.
>=20
> P. S. Sorry for being so verbose, I'm new to this mailing list and I'=
m
> trying to explain everything as clear as I can.
>=20

Thats perfect, thanks !

> --=20
> | Artyom Gavrichenkov
> | gpg: fa1c670e
> | mailto: ximaera@gmail.com
> | xmpp: ximaera@gmail.com
> | skype: xima_era
> | tel. no: +7 916 515 49 58
>=20
> -- Signed-off-by: Artyom Gavrichenkov <ximaera@gmail.com>
>=20
> diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
> index e849fa2..3af03c4 100644
> --- a/extensions/libxt_tcp.c
> +++ b/extensions/libxt_tcp.c
> @@ -169,7 +169,7 @@ tcp_parse(int c, char **argv, int invert, unsigne=
d int *flags,
>                         xtables_error(PARAMETER_PROBLEM,
>                                    "Only one of `--syn' or `--tcp-fla=
gs' "
>                                    " allowed");
> -               parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", in=
vert);
> +               parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert=
);
>                 *flags |=3D TCP_FLAGS;
>                 break;
> =20
> diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
> index 7a16118..e1698df 100644
> --- a/extensions/libxt_tcp.man
> +++ b/extensions/libxt_tcp.man
> @@ -31,12 +31,12 @@ will only match packets with the SYN flag set, an=
d the ACK, FIN and
>  RST flags unset.
>  .TP
>  [\fB!\fP] \fB\-\-syn\fP
> -Only match TCP packets with the SYN bit set and the ACK,RST and FIN =
bits
> +Only match TCP packets with the SYN bit set and the ACK and RST bits
>  cleared.  Such packets are used to request TCP connection initiation=
;
>  for example, blocking such packets coming in an interface will preve=
nt
>  incoming TCP connections, but outgoing TCP connections will be
>  unaffected.
> -It is equivalent to \fB\-\-tcp\-flags SYN,RST,ACK,FIN SYN\fP.
> +It is equivalent to \fB\-\-tcp\-flags SYN,RST,ACK SYN\fP.
>  If the "!" flag precedes the "\-\-syn", the sense of the
>  option is inverted.
>  .TP
>=20


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
