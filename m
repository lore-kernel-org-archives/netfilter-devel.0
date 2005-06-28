From: thomasmkling@arcor.de
Subject: Re: buckets-byte per conntrack
Date: Tue, 28 Jun 2005 23:05:44 +0200 (CEST)
Message-ID: <18528506.1119992744485.JavaMail.ngmail@webmail-02.arcor-online.net>
References: <8799348.1119957113603.JavaMail.ngmail@webmail-07.arcor-online.net>
	<20050627151027.GI4225@eychenne.org>
	<29003954.1119882475361.JavaMail.ngmail@webmail-07.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rv@eychenne.org
In-Reply-To: <8799348.1119957113603.JavaMail.ngmail@webmail-07.arcor-online.net>
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

> But one last thing, I did not yet understand:
=20
> I get almost no difference. Why is there not HASHSIZE =3D CONNTRACK_MAX b=
y
> default?
>=20

Forget  this silly question. It is now clear to me,  that it would occupy m=
emory also when there is no connection.

Machen Sie aus 14 Cent spielend bis zu 100 Euro!
Die neue Gaming-Area von Arcor - =FCber 50 Onlinespiele im Angebot.
http://www.arcor.de/rd/emf-gaming-1
