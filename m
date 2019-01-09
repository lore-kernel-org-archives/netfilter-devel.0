From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipset: fix a missing check of nla_parse
Date: Wed, 9 Jan 2019 23:43:35 +0100
Message-ID: <20190109224335.qe6f4x4722qz6x5p@salvia>
References: <20181226035002.73614-1-kjlu@umn.edu>
 <c462e7f4-6c41-78e8-26e9-8ce16ca26a5c@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kangjie Lu <kjlu@umn.edu>, pakki001@umn.edu,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c462e7f4-6c41-78e8-26e9-8ce16ca26a5c@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 26, 2018 at 12:16:25PM +0300, Kirill Tkhai wrote:
> On 26.12.2018 06:50, Kangjie Lu wrote:
> > When nla_parse fails, we should not use the results (the first
> > argument). The fix checks if it fails, and if so, returns its error code
> > upstream.
> > 
> > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> > ---
> >  net/netfilter/ipset/ip_set_core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 1577f2f76060..4dc8057cff02 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -1531,8 +1531,10 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
> >  		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
> >  		cmdattr = (void *)&errmsg->msg + min_len;
> >  
> > -		nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
> > +		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
> >  			  nlh->nlmsg_len - min_len, ip_set_adt_policy, NULL);

@Kangjie: nitpick, could you align this line below? ie.

		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
                                nlh->nlmsg_len - min_len, ip_set_adt_policy,
                                NULL);

> > +		if (ret)
> > +			return ret;
> 
> In this function above nlmsg_new() allocates skb2, but I don't see, where you free it here.

netlink_unicast() is responsible for releasing this skb2.

> >  		errline = nla_data(cda[IPSET_ATTR_LINENO]);
> >  
> > 
