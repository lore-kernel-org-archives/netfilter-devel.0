From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: [PATCH net-next] bridge: ebtables: Avoid resetting
 limit rule state
Date: Mon, 4 Dec 2017 05:53:35 +0100
Message-ID: <20171204045335.GE3307@otheros>
References: <20171125074418.16537-1-linus.luessing@c0d3.blue>
	<20171127233008.GA1418@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S . Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <bridge-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20171127233008.GA1418@salvia>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Thanks for your reply!

On Tue, Nov 28, 2017 at 12:30:08AM +0100, Pablo Neira Ayuso wrote:
> [...]
> > diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
> > index 61a9f1be1263..f74b48633feb 100644
> > --- a/net/bridge/netfilter/ebt_limit.c
> > +++ b/net/bridge/netfilter/ebt_limit.c
> > @@ -69,6 +69,10 @@ static int ebt_limit_mt_check(const struct xt_mtchk_param *par)
> >  {
> >  	struct ebt_limit_info *info = par->matchinfo;
> >  
> > +	/* Do not reset state on unrelated table changes */
> > +	if (info->prev)
> > +		return 0;
> 
> What kernel version are you using? I suspect you don't have this
> applied?

I'm indeed using a 4.4.102 kernel, as LEDE is still in the process
of updating to 4.14. So 4.4 with LEDE is where I got the measurement
results from.

> 
> commit ec23189049651b16dc2ffab35a4371dc1f491aca
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Mon Jan 2 17:19:46 2017 -0500
> 
>     xtables: extend matches and targets with .usersize

And so, no I do not have this patch. I looked at it now, but it
does not seem to have any relation with .matchinfo, does it?

I also had a quick look at a 4.15-rc1 kernel in a VM now. I still
end up in ebt_limit_mt_check() with the variables being reset
when editing the table somewhere.

Regards, Linus
