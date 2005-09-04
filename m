From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] Implement private protocol info changing
Date: Sun, 04 Sep 2005 20:02:22 +0200
Message-ID: <431B36AE.2080505@trash.net>
References: <430E2DE3.3020700@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <430E2DE3.3020700@eurodev.net>
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

Pablo Neira wrote:
> This patch add support to change the state of the private protocol 
> information via conntrack_netlink.

The patches look fine to me, besides the two issues mentioned below.
I have a couple of fixes which conflict with them though, please
resend after they hit Linus's tree.

> ------------------------------------------------------------------------
> 
> Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
> ===================================================================
> --- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-13 10:45:09.000000000 +0200
> +++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-13 10:51:34.000000000 +0200
> @@ -948,6 +948,36 @@
>  	return 0;
>  }
>  
> +static inline int
> +ctnetlink_change_protoinfo(struct ip_conntrack *ct, struct nfattr *cda[])
> +{
> +	struct nfattr *tb[CTA_PROTOINFO_MAX], *attr = cda[CTA_PROTOINFO-1];
> +	struct ip_conntrack_protocol *proto;
> +	u_int16_t npt = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
> +	int err;
> +
> +	if (nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr) < 0)
> +		goto nfattr_failure;

nfattr_failure is usually used when there isn't enough space in
the skb, not when parsing. So I would prefer to only use it in
functions putting data in the skb to avoid confusion. Also
-1 (-EPERM) isn't a suitable error to return to userspace.

> +
> +	proto = ip_conntrack_proto_find_get(npt);
> +	if (!proto)
> +		return -EINVAL;
> +
> +	if (proto->from_nfattr) {
> +		err = proto->from_nfattr(tb, ct);
> +		if (err < 0) {
> +			ip_conntrack_proto_put(proto);
> +			return -EINVAL;
> +		}
> +	}
> +	ip_conntrack_proto_put(proto);
> +
> +	return 0;

This would be simpler and would propagate the error properly if you
would write it like this:

...
if (proto->from_nfattr)
	err = proto->from_nfattr(tb, ct);
ip_conntrack_proto_put(proto);

return err;
