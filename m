From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Fri, 29 Jun 2007 13:27:49 +0200
Message-ID: <4684ECB5.9070402@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
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
> Add the xt_connlimit match

There's still one bug and a few things that seem suboptimal, please
see below.


> 
> +static inline unsigned int connlimit_iphash(u_int32_t addr)
> +{
> +	if (unlikely(!connlimit_rnd_inited)) {
> +		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
> +		connlimit_rnd_inited = true;
> +	}
> +	return jhash_1word(addr, connlimit_rnd) & 0xFF;
> +}
> +
> +static inline unsigned int
> +connlimit_iphash6(const union nf_conntrack_address *addr,
> +                  const union nf_conntrack_address *mask)
> +{
> +	union nf_conntrack_address res;
> +	unsigned int i;
> +
> +	if (unlikely(!connlimit_rnd_inited)) {
> +		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
> +		connlimit_rnd_inited = true;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i)
> +		res.ip6[i] = addr->ip6[i] & mask->ip6[i];
> +
> +	return jhash2(res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
> +}


Are two hash functions really necessary? A single hash would have
the advantage that it would make it easier to deal with IPv4 mapped
addresses (thats assuming that an IPv4 mapped address and a regular
address should be counted as the same thing).

> +
> +static const char *ct_state(const struct nf_conn *conn)
> +{
> +#ifdef DEBUG
> +	static const char const *tcp_state[] = {
> +		"none", "established", "syn_sent", "syn_recv", "fin_wait",
> +		"time_wait", "close", "close_wait", "last_ack", "listen"
> +	};

^newline after local variables

> +	if (conn == NULL)
> +		return "gone";
> +	if (conn->tuplehash[0].tuple.dst.protonum == IPPROTO_TCP)
> +		return tcp_state[found_ct->proto.tcp.state]);
> +#endif
> +	return "";
> +}
> +
> +static inline bool already_closed(const struct nf_conn *conn)
> +{
> +	u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;

^newline

> +	if (proto == IPPROTO_TCP)
> +		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
> +	else
> +		return 0;
> +}
> +
> +static inline void
> +connlimit_debug(const struct xt_connlimit_conn *conn,
> +                const struct nf_conn *found_ct,
> +                const union nf_conntrack_address *addr,
> +                const union nf_conntrack_address *mask,
> +                unsigned int family)
> +{
> +#define U3_NIP6(x) NIP6(*(const struct in6_addr *)&(x))
> +	if (family == AF_INET6)
> +		pr_debug(KERN_WARNING "xt_connlimit [%u]: src=" NIP6_FMT ":%u "
> +		         "dst=" NIP6_FMT ":%u %s\n",
> +		         connlimit_iphash6(addr, mask),
> +		         U3_NIP6(conn->tuple.src.u3),
> +		         ntohs(conn->tuple.src.u.tcp.port),
> +		         U3_NIP6(conn->tuple.dst.u3),
> +		         ntohs(conn->tuple.dst.u.tcp.port),
> +		         ct_state(found_ct));
> +	else
> +		pr_debug(KERN_WARNING "xt_connlimit [%u]: src=%u.%u.%u.%u:%u "
> +		         "dst=%u.%u.%u.%u:%u %s\n",
> +		         connlimit_iphash(addr->ip & mask->ip),
> +		         NIPQUAD(conn->tuple.src.u3.ip),
> +		         ntohs(conn->tuple.src.u.tcp.port),
> +		         NIPQUAD(conn->tuple.dst.u3.ip),
> +		         ntohs(conn->tuple.dst.u.tcp.port),
> +			 ct_state(found_ct));
> +#undef U3_NIP6
> +}


Thats a lot of debugging considering that this is something quite
simple. I trust you tested this match, is it really necessary to
keep this?

> +
> +static inline unsigned int
> +same_source_net(const union nf_conntrack_address *addr,
> +                const union nf_conntrack_address *mask,
> +                const union nf_conntrack_address *u3, unsigned int family)
> +{
> +	if (family == AF_INET) {
> +		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
> +	} else {
> +		union nf_conntrack_address lh, rh;
> +		unsigned int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i) {
> +			lh.ip6[i] = addr->ip6[i] & mask->ip6[i];
> +			rh.ip6[i] = u3->ip6[i] & mask->ip6[i];
> +		}
> +
> +		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6)) == 0;
> +	}
> +}
> +
> +static int count_them(struct xt_connlimit_data *data,
> +                      const union nf_conntrack_address *addr,
> +		      const union nf_conntrack_address *mask,
> +		      struct nf_conn *ct, unsigned int family)
> +{
> +	struct nf_conntrack_tuple_hash *found;
> +	struct nf_conntrack_tuple tuple;
> +	struct xt_connlimit_conn *conn;
> +	struct xt_connlimit_conn *tmp;
> +	struct nf_conn *found_ct;
> +	struct list_head *hash;
> +	bool addit = true;
> +	int matches = 0;
> +
> +	tuple = ct->tuplehash[0].tuple;
> +
> +	if (family == AF_INET6)
> +		hash = &data->iphash[connlimit_iphash6(addr, mask)];
> +	else
> +		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
> +
> +	/* check the saved connections */
> +	list_for_each_entry_safe(conn, tmp, hash, list) {
> +		found    = nf_conntrack_find_get(&conn->tuple, ct);


I didn't notice this before. I just removed this "ignored_conntrack"
argument from nf_conntrack_find_get because it was unused so far and
seems to imply someone doing more complicated hash table fiddling
than they should be. Why exactly are you using it?

Another thing is that you're grabbing and releasing nf_conntrack_lock
once for each call, additionally you have an atomic_inc and an
atomic_dec_and_test per entry. Since you were worried about speed,
that part is what you should worry about. I'd suggest to hold
nf_conntrack_lock around the entire iteration and use
__nf_conntrack_find.


> +		found_ct = NULL;
> +
> +		if (found != NULL)
> +			found_ct = nf_ct_tuplehash_to_ctrack(found);
> +
> +		if (found_ct != NULL &&
> +		    nf_ct_tuple_equal(&conn->tuple, &tuple) &&
> +		    !already_closed(found_ct))
> +			/*
> +			 * Just to be sure we have it only once in the list.
> +			 * We should not see tuples twice unless someone hooks
> +			 * this into a table without "-p tcp --syn".
> +			 */
> +			addit = false;
> +
> +		connlimit_debug(conn, found_ct, addr, mask, family);
> +
> +		if (found == NULL) {
> +			/* this one is gone */
> +			list_del(&conn->list);
> +			kfree(conn);

Minor optimization possible: you could reuse this memory in case
addit = true

> +			continue;
> +		}
> +
> +		if (already_closed(found_ct)) {
> +			/*
> +			 * we do not care about connections which are
> +			 * closed already -> ditch it
> +			 */
> +			list_del(&conn->list);
> +			kfree(conn);
> +			nf_conntrack_put(&found_ct->ct_general);
> +			continue;
> +		}
> +
> +		if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
> +			/* same source network -> be counted! */
> +			++matches;
> +
> +		nf_conntrack_put(&found_ct->ct_general);
> +	}
> +
> +	if (addit) {
> +		/* save the new connection in our list */
> +		connlimit_debug(conn, found_ct, addr, mask, family);
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
> +	union nf_conntrack_address addr, mask;
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +	int connections;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct == NULL) {
> +		printk(KERN_INFO "xt_connlimit: INVALID connection\n");


No printks without net_ratelimit, this one seems like it shouldn't exist
at all. And hotdropping is quite unfriendly, it seems that as long as
you're able to read the addresses (which you're always), you can still
count the other connections.

> +		*hotdrop = true;
> +		return false;
> +	}
> +
> +	if (match->family == AF_INET6) {
> +		const struct ipv6hdr *iph = ipv6_hdr(skb);
> +		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
> +		memcpy(&mask.ip6, info->v6_mask, sizeof(info->v6_mask));
> +	} else {
> +		const struct iphdr *iph = ip_hdr(skb);
> +		addr.ip = iph->saddr;
> +		mask.ip = info->v4_mask;
> +	}
> +
> +	spin_lock_bh(&info->data->lock);
> +	connections = count_them(info->data, &addr, &mask, ct, match->family);
> +	spin_unlock_bh(&info->data->lock);
> +
> +	if (connections < 0) {
> +		/* kmalloc failed, drop it entirely */
> +		*hotdrop = 1;

That one is fine.

> +		return false;
> +	}
> +
> +	return (connections > info->limit) ^ info->inverse;
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

Missing check for failure (and don't forget to release the module
reference).

> +	spin_lock_init(&info->data->lock);
> +	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
> +		INIT_LIST_HEAD(&info->data->iphash[i]);
> +
> +	return true;
> +}
