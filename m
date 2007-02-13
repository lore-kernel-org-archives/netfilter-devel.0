From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 12/14] nfnetlink_log: possible NULL
 pointer	dereference in nfulnl_recv_config()
Date: Tue, 13 Feb 2007 13:55:49 +0100
Message-ID: <45D1B555.6040302@trash.net>
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl>
	<20070212202224.GC28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212202224.GC28704@rere.qmqm.pl>
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

Micha=C2=B3 Miros=C2=B3aw wrote:
> Eliminate possible NULL pointer dereference in nfulnl_recv_config().
>=20
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>=20
> --- linux-2.6.20/net/netfilter/nfnetlink_log.c.10	2007-02-12 17:05:14.0=
00000000 +0100
> +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:35:50.0000=
00000 +0100
> @@ -853,6 +853,9 @@ nfulnl_recv_config(struct sock *ctnl, st
>  			ret =3D -EINVAL;
>  			break;
>  		}
> +
> +		if (!inst)
> +			goto out_null;

I think we should check that an instance is present before doing
any changes any return an error if the user tries to change the
configuration for a non-existant instance.
