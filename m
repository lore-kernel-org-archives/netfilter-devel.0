From: "Pavel A. Nekrasov" <pnekras@gmail.com>
Subject: Re: [1/3] OSF: code beautification.
Date: Wed, 1 Jun 2005 00:37:05 +0200
Message-ID: <cede307105053115377afb8aac@mail.gmail.com>
Reply-To: "Pavel A. Nekrasov" <pnekras@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, johnpol@2ka.mipt.ru,
	laforge@netfilter.org, kaber@trash.net
Content-Disposition: inline
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

hello!

>@@ -186,12 +181,10 @@
> =09df =3D ((ntohs(ip->frag_off) & IP_DF)?1:0);
> =09window =3D ntohs(tcp->window);
> =09
>-=09if (tcp->doff*4 > sizeof(struct tcphdr))
>-=09{
>+=09if (tcp->doff*4 > sizeof(struct tcphdr)) {
> =09=09optsize =3D tcp->doff*4 - sizeof(struct tcphdr);

This won't work with fragments, you consider here that the tcp header
is linear and that isn't always true.

BTW, fix a deadlock. match() can be called from both bh and process context=
.

kind regards,
Pavel
