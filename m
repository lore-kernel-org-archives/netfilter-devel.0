From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 09/10] nfnetlink_log: fix NULL pointer dereference
Date: Tue, 13 Feb 2007 13:48:44 +0100
Message-ID: <45D1B3AC.5070902@trash.net>
References: <20070212004030.GJ8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212004030.GJ8262@rere.qmqm.pl>
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
> Fix the nasty NULL dereference on multiple packets per netlink message.
>=20
> --- linux-2.6.20/net/netfilter/nfnetlink_log.c.7	2007-02-11 22:41:18.00=
0000000 +0100
> +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 23:59:01.0000=
00000 +0100
> @@ -560,6 +560,7 @@ __build_packet_message(struct nfulnl_ins
>  	}
>  	=09
>  	nlh->nlmsg_len =3D inst->skb->tail - old_tail;
> +	inst->lastnlh =3D nlh;
>  	return 0;
> =20
>  nlmsg_failure:
>=20

Applied, thanks. I'll send this one to -stable too.
