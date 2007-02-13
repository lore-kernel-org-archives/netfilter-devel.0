From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20 13/14] nfnetlink_log: fix reference counting
Date: Tue, 13 Feb 2007 13:58:34 +0100
Message-ID: <45D1B5FA.5050704@trash.net>
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl>
	<20070212202255.GD28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212202255.GD28704@rere.qmqm.pl>
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
> Fix reference counting (memory leak) problem in __nfulnl_send() and cal=
lers
> related to packet queueing.
>=20
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>=20
> --- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:50.0=
00000000 +0100
> +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:01.0000=
00000 +0100
> @@ -223,6 +223,11 @@ _instance_destroy2(struct nfulnl_instanc
> =20
>  	spin_lock_bh(&inst->lock);
>  	if (inst->skb) {
> +		/* timer "holds" one reference (we have one more) */
> +		if (timer_pending(&inst->timer)) {
> +			del_timer(&inst->timer);
> +			instance_put(inst);

This should be done outside of the locked section and using
del_timer_sync to make sure the timer is not already active
and waiting for the lock.

Please combine this with 07/10 if possible.
