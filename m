From: "Allain Yoann" <Yoann.Allain@thomson.net>
Subject: RE: IPSec decrypted transport packets don't go through hooks
Date: Thu, 28 Apr 2005 14:28:08 +0200
Message-ID: <9C1918067C3BC14C9C351C206D8A8437377858@rennsmail03.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-
> bounces@lists.netfilter.org] On Behalf Of Allain Yoann
> Sent: mercredi 27 avril 2005 17:47
> To: netfilter-devel@lists.netfilter.org
> Subject: IPSec decrypted transport packets don't go through hooks
>=20
> Hi,
> I'm new to this list.
>=20
> I'm actually studying the IPSec / Netfilter interaction in the 2.6.11
> kernel and there's something I don't catch:
>=20
> The IPSec processing is done after the hooks PRE-ROUTING and INPUT.
>=20
> In Tunnel mode, packets are re-injected in the stack via the netif_rx
> function (this is needed for this mode).
> But in Transport mode, the packets are not re-injected. Why?
>=20
> This could be useful, if we want to filter decrypted packets that
> arrived in transport mode.
>=20
> Is there a way to do this filtering?
>=20
> Thanks in advance for your advices/explanations...
>=20
> Yoann
>=20

Hello,

I need some help. I don't understand why plain text packets are not sent
back to ip_rcv, when they arrived in transport mode...

It seems to me that in OpenBSD/pf, packet filtering can be done after
decryption in both transport and tunnel mode... Why isn't it the same in
Linux with netfilter ?

Am I on the wrong list to ask such questions?
Sorry for disturbing if so but perhaps someone could point me to the
right one...

TIA
Yoann
