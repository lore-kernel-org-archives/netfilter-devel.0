From: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>
Subject: RE: ICMP unreachable (DF) does not report the NATed IP
Date: Mon, 28 Apr 2003 17:57:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4F9AFAF72B246745B6847C7EECD8FF6901D17A81@EXCHANGE1.charite.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Martin Josefsson" <gandalf@wlug.westbo.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: Martin Josefsson [mailto:gandalf@wlug.westbo.se]
> To: Hillmann, Oliver
> Cc: Netfilter-devel
> Subject: Re: ICMP unreachable (DF) does not report the NATed IP
>=20

Hi!

> I'm moving this to the correct list.
>=20
> I see the "10.0.1.2 reports that a packet didn't reach 10.0.1.2 due to
> MTU and DF contraints" problem here (GRE tunnels between networks).
>=20
> I havn't investigated it much yet but please go ahead :)

Thanks for both forwarding this mail and acknowledging this problem. I =
don't use GRE but L2TP, yet both protocols constitute tunnels and suffer =
from that MTU difference... Now I know I haven't done something utterly =
stupid, but that this might be a netfilter issue.. ;)

> (you need to be subscribed to=20
> netfilter-devel@lists.netfilter.org to be
> able to post without your messages beeing held for approval)

I have been subcribed to netfilter-devel, but first wanted to send it to =
a more general list before bothering the developers with this...

As soon as I find some time, I will be looking into this and try to come =
up with a NAT helper module... Any comments and suggestions are welcome!

Regards,

Oliver
