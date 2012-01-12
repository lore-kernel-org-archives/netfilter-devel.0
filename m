From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: AW: Ulog/filter device name does not match effective device name of
 data flow: expected?
Date: Thu, 12 Jan 2012 09:50:24 +0100
Message-ID: <9F69795E29C890408AC2DAF646C89BB379CFB1FA18@MAILBOX.arc.local>
References: <9F69795E29C890408AC2DAF646C89BB379CF93964B@MAILBOX.arc.local>
 <20120112024654.GD12255@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcss01.ait.ac.at ([62.218.164.126]:15334 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752698Ab2ALIu2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:50:28 -0500
In-Reply-To: <20120112024654.GD12255@1984>
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> -----Urspr=FCngliche Nachricht-----
> Von: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Gesendet: Donnerstag, 12. Januar 2012 03:47
> An: Fiedler Roman
> Cc: netfilter-devel@vger.kernel.org
> Betreff: Re: Ulog/filter device name does not match effective device =
name
> of data flow: expected?
>=20
> On Tue, Jan 10, 2012 at 02:04:12PM +0100, Fiedler Roman wrote:
> > Hi,
> >
> > Just a question, if this is intended behavior in NAT/logging with u=
log/filter, I
> know it should be some border case:
> >
> >
> > In test environment, all 10/8 IPs are routed via lo by default to a=
void test
> data from 10/8 net leaving the host.
> >
> > 10.0.0.0/8 dev lo  scope link  src 10.0.0.1
> >
> > To allow some connections to reach machines outside, these connecti=
ons
> are natted, e.g.
> >
> > Iptables -t nat -A OUTPUT -o lo -d 10.0.0.5 -p tcp -m tcp --dport 8=
0 -j DNAT -
> -to-destination xxx.172:80
> >
> > This allows to create the connection, but with two side effects:
> >
> > Although the package leaves via eth0, ulog will report OUT=3Dlo:
> >
> > Jan 10 12:06:13 v3lsn1105 iptables:ACCEPT-INFO IN=3D OUT=3Dlo MAC=3D
> SRC=3D10.xx.xx.3 DST=3Dxxxx.172 LEN=3D60 TOS=3D00 PREC=3D0x00 TTL=3D6=
4 ID=3D46425 CE
> DF PROTO=3DTCP SPT=3D48808 DPT=3D80 SEQ=3D1237479374 ACK=3D0 WINDOW=3D=
32792
> SYN URGP=3D0
>=20
> You forgot to paste your NFLOG rule. Where is it?

Sorry about that:

* Accept and log chain:

Iptables -A ACCEPT-INFO -j ULOG --ulog-prefix "iptables:ACCEPT-INFO"=20
Iptables -A ACCEPT-INFO -j ACCEPT

* Accept TCP chain:

Iptables -A ACCEPT-INFO-TCP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK S=
YN -j ACCEPT-INFO

Output rule:

* Iptables -A OUTPUT -s 10.xx.xx.3 -d xxxx.172/32 -p tcp -m tcp --dport=
 80 -m conntrack --ctstate NEW -j ACCEPT-INFO-TCP=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
