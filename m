From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] driver/netfilter/nfnetlink: removed unused variable
Date: Sun, 1 Jun 2014 11:55:59 +0200
Message-ID: <CAFLxGvwZ4b14CLA7DtqWT9Y4aRZtVePiUx_qVXFNiTz8nXO-MQ@mail.gmail.com>
References: <20140531110628.GA30443@shodan.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	LKML <linux-kernel@vger.kernel.org>
To: Robin Schroer <sulamiification@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140531110628.GA30443@shodan.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 31, 2014 at 1:06 PM, Robin Schroer
<sulamiification@gmail.com> wrote:
> Removes the unused struct net *net = sock_net(skb->sk);
>
> Signed-off-by: Robin Schroer <sulamiification@gmail.com>

Against which tree is that patch?
net-next.git still uses net in nfnetlink_rcv_batch() AFAICT.

---cut---
if (err < 0)
goto ack;

if (nc->call_batch) {
err = nc->call_batch(net->nfnl, skb, nlh,
    (const struct nlattr **)cda);
}

/* The lock was released to autoload some module, we
* have to abort and start from scratch using the
* original skb.
*/
---cut---

> ---
>  net/netfilter/nfnetlink.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index c138b8f..5cc9db2 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -226,7 +226,6 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>                                 u_int16_t subsys_id)
>  {
>         struct sk_buff *nskb, *oskb = skb;
> -       struct net *net = sock_net(skb->sk);
>         const struct nfnetlink_subsystem *ss;
>         const struct nfnl_callback *nc;
>         bool success = true, done = false;
> --
> 1.9.3
>
>
> --
>
> Robin Schroer
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
