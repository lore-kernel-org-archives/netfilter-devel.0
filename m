From: "Ruud van den Brink" <ruud@stress.utwente.nl>
Subject: RE: Bug in ip_nat_core.c, introduced in 2.4.19pre4 and still persisting in 2.4.20
Date: Sun, 26 Jan 2003 11:23:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c2c525$06ead3f0$026ba8c0@DEEPBLUE>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: 
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Earlier this month, I reported the bug below. At that time, you asked if =
I
did enable the feature "NAT of local connections". I didn't. However,
enabling this feature doesn't solve the problem. Also with this feature
turned on; when I undo the patch introduced in 2.4.19-pre3 it works, =
when I
use the "standard" 2.4.20 kernel it doesn't work.

Let me know if I can be of any help again...

Regards,
Ruud.

Ps. I lost my Inbox short after you sent me your e-mail. You asked me to =
use
another mailinglist than coreteam@netfilter.org, I hope I picked the =
good
one.

> -----Original Message-----
> From: Ruud van den Brink [mailto:ruud@stress.utwente.nl]
> Sent: maandag 6 januari 2003 20:32
> To: 'coreteam@netfilter.org'
> Subject: Bug in ip_nat_core.c, introduced in 2.4.19pre4 and still
> persisting in 2.4.20
>=20
> Hi netfilter team,
>=20
> I have been using the 2.4.16 kernel for a while, and recently I =
upgraded
> to 2.4.19. At that time, CIPE (a VPN application) refused to work in
> conjunction with NAT. Today I finally found some time to trace the =
problem
> in the Kernel source.
>=20
> In the patch from 2.4.19-pre2 to 2.4.19-pre3, you applied a patch for
> ip_nat_core.c:
>=20
> @@ -494,7 +498,10 @@
>  static unsigned int opposite_hook[NF_IP_NUMHOOKS]
>  =3D { [NF_IP_PRE_ROUTING] =3D NF_IP_POST_ROUTING,
>      [NF_IP_POST_ROUTING] =3D NF_IP_PRE_ROUTING,
> -    [NF_IP_LOCAL_OUT] =3D NF_IP_POST_ROUTING
> +#ifdef CONFIG_IP_NF_NAT_LOCAL
> +    [NF_IP_LOCAL_OUT] =3D NF_IP_LOCAL_IN,
> +    [NF_IP_LOCAL_IN] =3D NF_IP_LOCAL_OUT,
> +#endif
>  };
>=20
> If I undo this patch, everything works fine again. My knowledge about =
the
> kernel and about the netfilter in particular is not sufficient to give =
any
> input on what exactly is incorrect here, or if it is correct but it is =
a
> bug in Cipe - for that reason I cc'ed Olaf Titz in.
>=20
> Kind regards,
> Ruud.
