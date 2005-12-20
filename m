From: Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: [PATCH] fxp support for ip_conntrack_ftp.c
Date: Tue, 20 Dec 2005 14:38:50 +0100
Message-ID: <20051220143850.50b9edea.gmsoft@tuxicoman.be>
References: <20051220141315.44643c09.gmsoft@tuxicoman.be>
	<Pine.LNX.4.64.0512201422420.31684@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0512201422420.31684@bizon.gios.gov.pl>
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




Mhh good question. loose=3D1 never worked in my setup but I'm natting port =
20 to inside my lan.
I guess it didn't worked because it bypass the nat hook. The out_put_expect=
: should then be moved before the nat hook.

I'll try to fix it that way if I have time.

Also the loose parameter is not very explicit about what it does unless you=
 look at the code. I must admit I didn't looked at it very carefully before.


Cheers,
  Guy


On Tue, 20 Dec 2005 14:23:19 +0100 (CET)
Krzysztof Oledzki <olenf@ans.pl> wrote:

>=20
>=20
> On Tue, 20 Dec 2005, Guy Martin wrote:
>=20
> > Hi netfilter hackers,
> >
> > This patch enables you to allow so called FXP transfer by allowing=20
> > connection from a different source address than the one which initiated=
=20
> > the transfer.
> >
> > To enable, simply modprobe ip_conntrack_ftp fxp=3D1.
>=20
> How it is different from loose=3D1?
>=20
> Best regards,
>=20
>  			Krzysztof Ol=EAdzki
