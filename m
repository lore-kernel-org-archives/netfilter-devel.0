From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070620_2
Date: Fri, 22 Jun 2007 13:14:15 +0200
Message-ID: <467BAF07.6020502@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Hi,
> 
> 
> I fixed the crash. Sometimes, I should just look at the regs :) EBP was 
> totally beyond any reasonable value which directed me to the hash 
> function which was missing a "% 256".
> 
> Patrick, please merge. (xt_u32 as posted is functional and already 
> complete, please merge too.)
> Andrew, please see if this works for you too now.
> 
> (Kernel patch below, iptables patch unchanged)
> 
> Thanks!
> 	Jan
> ---
> 
> 
> Subject: Add the connlimit match from POM-NG
> 
> Along comes... the connlimit match that has been in POM-NG for a long time.
> Plus:
> 
>     *	2007-06-02: works with 2.6.22, xtables'ified and all that
> 
>     *	2007-06-02: will request nf_conntrack_ipv4 upon load
> 	(otherwise it hotdrops every packet - a glitch that goes back
> 	to at least 2.6.20.2)
> 
>     *   2007-06-05: fixed: deadlock after OOM
> 
>     *   2007-06-05: UDP support
> 
>     *   2007-06-06: Using jhash, as suggested by Eric Dumazet.
>         ( https://lists.netfilter.org/pipermail/netfilter-devel/2007-June/028056.html )
> 
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  include/linux/netfilter/xt_connlimit.h |   14 +
>  net/netfilter/Kconfig                  |    7 
>  net/netfilter/Makefile                 |    1 
>  net/netfilter/xt_connlimit.c           |  264 +++++++++++++++++++++++++++++++++
>  4 files changed, 286 insertions(+)
> 
> Index: linux-2.6.22/include/linux/netfilter/xt_connlimit.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.22/include/linux/netfilter/xt_connlimit.h
> @@ -0,0 +1,14 @@
> +#ifndef _XT_CONNLIMIT_H
> +#define _XT_CONNLIMIT_H
> +
> +struct xt_connlimit_data;
> +
> +struct xt_connlimit_info {
> +	u_int32_t mask;
> +	unsigned int limit, inverse;
> +
> +	/* this needs to be at the end */
> +	struct xt_connlimit_data *data;


As Pablo mentioned, you need to force 8 byte alignment to
avoid 32/64 bit issues.
> Index: linux-2.6.22/net/netfilter/xt_connlimit.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.22/net/netfilter/xt_connlimit.c
> +static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
> +		      u_int32_t mask, struct nf_conn *ct)
> +{
> +#if DEBUG
> +	static const char const *tcp_state[] = {
> +		"none", "established", "syn_sent", "syn_recv", "fin_wait",
> +		"time_wait", "close", "close_wait", "last_ack", "listen"
> +	};
> +#endif
> +	struct nf_conntrack_tuple_hash *found;
> +	struct nf_conntrack_tuple tuple;
> +	struct xt_connlimit_conn *conn;
> +	const struct list_head *lh;
> +	struct nf_conn *found_ct;
> +	struct list_head *hash;
> +	bool addit = true;
> +	int matches = 0;
> +
> +	tuple = ct->tuplehash[0].tuple;
> +	hash  = &data->iphash[connlimit_iphash(addr & mask)];
> +
> +	/* check the saved connections */
> +	list_for_each(lh, hash) {
> +		conn     = list_entry(lh, struct xt_connlimit_conn, list);

list_for_each_entry_safe

> +		found    = nf_conntrack_find_get(&conn->tuple, ct);
> +		found_ct = NULL;
> +
> +		if (found != NULL &&
> +		    (found_ct = nf_ct_tuplehash_to_ctrack(found)) != NULL &&


Please no assignments in comparisons.

> +		    memcmp(&conn->tuple, &tuple, sizeof(tuple)) == 0 &&
> +		    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT)


It should support other protocols as well. Also nothing guarantees that
you're looking at a TCP connection here.

> +			/*
> +			 * Just to be sure we have it only once in the list.
> +			 * We should not see tuples twice unless someone hooks
> +			 * this into a table without "-p tcp --syn".
> +			 */
> +			addit = false;
> +
> +#if DEBUG
> +		printk(KERN_WARNING "xt_connlimit [%u]: src=%u.%u.%u.%u:%u "
> +		       "dst=%u.%u.%u.%u:%d %s\n",
> +		       connlimit_iphash(addr & mask),
> +		       NIPQUAD(conn->tuple.src.u3.ip),
> +		       ntohs(conn->tuple.src.u.tcp.port),
> +		       NIPQUAD(conn->tuple.dst.u3.ip),
> +		       ntohs(conn->tuple.dst.u.tcp.port),
> +		       (found == NULL) ? "gone" :
> +		       tcp_state[found_ct->proto.tcp.state]);
> +#endif
> +
> +		if (found == NULL) {
> +			/* this one is gone */
> +			lh = lh->prev;

You can remove this with list_for_each_entry_safe

> +			list_del(lh->next);
> +			kfree(conn);
> +			continue;
> +		}
> +
> +		if (found_ct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
> +			/*
> +			 * we do not care about connections which are
> +			 * closed already -> ditch it
> +			 */
> +			lh = lh->prev;
> +			list_del(lh->next);
> +			kfree(conn);
> +			nf_conntrack_put(&found_ct->ct_general);
> +			continue;
> +		}
> +
> +		if ((addr & mask) == (conn->tuple.src.u3.ip & mask))
> +			/* same source network -> be counted! */
> +			++matches;
> +
> +		nf_conntrack_put(&found_ct->ct_general);
> +	}
> +
> +	if (addit) {
> +		/* save the new connection in our list */
> +#if DEBUG
> +		printk(KERN_WARNING "xt_connlimit [%u]: src=%u.%u.%u.%u:%u "
> +		       "dst=%u.%u.%u.%u:%u new\n",
> +		       connlimit_iphash(addr & mask),
> +		       NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
> +		       NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
> +#endif
> +
> +		conn = kzalloc(sizeof(*conn), GFP_ATOMIC);
> +		if (conn == NULL)
> +			return -ENOMEM;
> +
> +		INIT_LIST_HEAD(&conn->list);
> +		conn->tuple = tuple;
> +		list_add(&conn->list, hash);
> +		++matches;
> +	}
> +
> +	return matches;
> +}
> +
> +static bool connlimit_match(const struct sk_buff *skb,
> +			    const struct net_device *in,
> +			    const struct net_device *out,
> +			    const struct xt_match *match,
> +			    const void *matchinfo, int offset,
> +			    unsigned int protoff, bool *hotdrop)
> +{
> +	const struct xt_connlimit_info *info = matchinfo;
> +	enum ip_conntrack_info ctinfo;
> +	const struct iphdr *iph;
> +	int connections, rv;


Thats just me I think, but I have an aversion to "rv" for return value.
"err" or "ret"?

> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct == NULL) {
> +		printk(KERN_INFO "xt_connlimit: INVALID connection\n");
> +		*hotdrop = 1;
> +		return false;
> +	}
> +
> +	iph = ip_hdr(skb);
> +	spin_lock_bh(&info->data->lock);
> +	connections = count_them(info->data, iph->saddr, info->mask, ct);
> +	spin_unlock_bh(&info->data->lock);
> +
> +	if (connections < 0) {
> +		/* kmalloc failed, drop it entirely */
> +		printk(KERN_DEBUG "xt_connlimit: kmalloc failed\n");
> +		*hotdrop = 1;
> +		return false;
> +	}
> +
> +	rv = info->inverse ^ (connections > info->limit);


Switching the two expressions seems more logical.

> +#if DEBUG
> +	printk(KERN_DEBUG "xt_connlimit: src=%u.%u.%u.%u mask=%u.%u.%u.%u "
> +	       "connections=%d limit=%u match=%s\n",
> +	       NIPQUAD(iph->saddr), NIPQUAD(info->mask),
> +	       connections, info->limit, match ? "yes" : "no");


Excessive debugging, also shouldn't use ifdef but pr_debug if
absolutely necessary.

> +#endif
> +
> +	return rv;
> +}
> +
> +static bool connlimit_check(const char *tablename, const void *ip,
> +			    const struct xt_match *match, void *matchinfo,
> +			    unsigned int hook_mask)
> +{
> +	struct xt_connlimit_info *info = matchinfo;
> +	unsigned int i;
> +
> +	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
> +		printk(KERN_WARNING "cannot load conntrack support for "
> +		       "address family %u\n", match->family);
> +		return false;
> +	}
> +
> +	/* init private data */
> +	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);


This will make it forget its state everytime you add or delete _any_
rule. The alternative sucks as well, keep data on a global list and
lookup based on some identifier ..

> +	spin_lock_init(&info->data->lock);
> +	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
> +		INIT_LIST_HEAD(&info->data->iphash[i]);
> +
> +	return true;
> +}
> +
> +static void connlimit_destroy(const struct xt_match *match, void *matchinfo)
> +{
> +	struct xt_connlimit_info *info = matchinfo;
> +	struct xt_connlimit_conn *conn;
> +	struct list_head *hash;
> +	struct list_head *hash_next;
> +	unsigned int i;
> +
> +	nf_ct_l3proto_module_put(match->family);
> +
> +	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
> +		list_for_each_safe(hash, hash_next, &info->data->iphash[i]) {

list_for_each_entry_safe

> +			conn = list_entry(hash, struct xt_connlimit_conn, list);
> +			list_del(hash);
> +			kfree(conn);
> +		}
> +	}
> +
> +	kfree(info->data);
> +}
> +
> +static struct xt_match connlimit_reg = {
> +	.name       = "connlimit",
> +	.family     = AF_INET,
> +	.checkentry = connlimit_check,
> +	.match      = connlimit_match,
> +	.matchsize  = sizeof(struct xt_connlimit_info),
> +	.destroy    = connlimit_destroy,
> +	.me         = THIS_MODULE,
> +};
> +
> +static int __init xt_connlimit_init(void)
> +{
> +	get_random_bytes(&connlimit_iphash_rnd, sizeof(connlimit_iphash_rnd));
> +	return xt_register_match(&connlimit_reg);
> +}
> +
> +static void __exit xt_connlimit_exit(void)
> +{
> +	xt_unregister_match(&connlimit_reg);
> +}
> +
> +module_init(xt_connlimit_init);
> +module_exit(xt_connlimit_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_connlimit");
