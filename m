From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070628 kernel
Date: Sun, 1 Jul 2007 16:11:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
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
	<4684ECB5.9070402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4684ECB5.9070402@trash.net>
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

Hi,

On Jun 29 2007 13:27, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> Add the xt_connlimit match
>
>There's still one bug and a few things that seem suboptimal, please
>see below.
>
>> +static inline unsigned int connlimit_iphash(u_int32_t addr)
>> +{
[...]
>> +	return jhash_1word(addr, connlimit_rnd) & 0xFF;
>> +}
>> +
>> +static inline unsigned int
>> +connlimit_iphash6(const union nf_conntrack_address *addr,
>> +                  const union nf_conntrack_address *mask)
>> +{
[...]
>> +	return jhash2(res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
>> +}
>
>Are two hash functions really necessary?

It is the same hash. jhash_1word just does it over 32 bits, while the jhash2()
call does it over 4x32 bits. If I wanted, I could use jhash(), but jhash_1word
and jhash2() are optimized variants.

>A single hash would have the advantage that it would make it easier to deal
>with IPv4 mapped addresses (thats assuming that an IPv4 mapped address and a
>regular address should be counted as the same thing).

Huwee :)
Mathematically seen, all that is required is a hash function that is pure (GCC
slang for "produces always the same for same input") for a tuple of
<ipaddress, struct xt_connlimit_data>. So I could use xhash for ipv4 and yhash
for ipv6 even and a per-connlimit_data rnd.

Right, to the topic: I think we're fine here.

>> +static const char *ct_state(const struct nf_conn *conn)
>> +{
[..].
>> +}
>> +
>> +static inline void
>> +connlimit_debug(const struct xt_connlimit_conn *conn,
>> +                const struct nf_conn *found_ct,
>> +                const union nf_conntrack_address *addr,
>> +                const union nf_conntrack_address *mask,
>> +                unsigned int family)
>> +{
>> +}
>
>Thats a lot of debugging considering that this is something quite
>simple. I trust you tested this match, is it really necessary to
>keep this?

I certainly don't need it. Though, it's #ifdefed anyway, so... roll a dice and
tell me :)

>> +static inline unsigned int
>> +same_source_net(const union nf_conntrack_address *addr,
>> +                const union nf_conntrack_address *mask,
>> +                const union nf_conntrack_address *u3, unsigned int family)
>> +{
>> +	if (family == AF_INET) {
>> +		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
>> +	} else {
>> +		union nf_conntrack_address lh, rh;
>> +		unsigned int i;
>> +
>> +		for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i) {
>> +			lh.ip6[i] = addr->ip6[i] & mask->ip6[i];
>> +			rh.ip6[i] = u3->ip6[i] & mask->ip6[i];
>> +		}
>> +
>> +		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6)) == 0;
>> +	}
>> +}
>> +
>> +static int count_them(struct xt_connlimit_data *data,
>> +                      const union nf_conntrack_address *addr,
>> +		      const union nf_conntrack_address *mask,
>> +		      struct nf_conn *ct, unsigned int family)
>> +{
>> +	struct nf_conntrack_tuple_hash *found;
>> +	struct nf_conntrack_tuple tuple;
>> +	struct xt_connlimit_conn *conn;
>> +	struct xt_connlimit_conn *tmp;
>> +	struct nf_conn *found_ct;
>> +	struct list_head *hash;
>> +	bool addit = true;
>> +	int matches = 0;
>> +
>> +	tuple = ct->tuplehash[0].tuple;
>> +
>> +	if (family == AF_INET6)
>> +		hash = &data->iphash[connlimit_iphash6(addr, mask)];
>> +	else
>> +		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
>> +
>> +	/* check the saved connections */
>> +	list_for_each_entry_safe(conn, tmp, hash, list) {
>> +		found    = nf_conntrack_find_get(&conn->tuple, ct);
>
>
>I didn't notice this before. I just removed this "ignored_conntrack"
>argument from nf_conntrack_find_get because it was unused so far and
>seems to imply someone doing more complicated hash table fiddling
>than they should be. Why exactly are you using it?

This is "original code" (from POM). I can replace the last argument with NULL
if that looks better.

>Another thing is that you're grabbing and releasing nf_conntrack_lock
>once for each call, additionally you have an atomic_inc and an
>atomic_dec_and_test per entry. Since you were worried about speed,
>that part is what you should worry about. I'd suggest to hold
>nf_conntrack_lock around the entire iteration and use
>__nf_conntrack_find.

Does this look reasonable? (Just removing the ///nf_conntrack_put lines and
doing the locking ourselves.)

        read_lock_bh(&nf_conntrack_lock);

        /* check the saved connections */
        list_for_each_entry_safe(conn, tmp, hash, list) {
                found    = __nf_conntrack_find(&conn->tuple, NULL);
                found_ct = NULL;

                if (found != NULL)
                        found_ct = nf_ct_tuplehash_to_ctrack(found);

                if (found_ct != NULL &&
                    nf_ct_tuple_equal(&conn->tuple, &tuple) &&
                    !already_closed(found_ct))
                        /*
                         * Just to be sure we have it only once in the list.
                         * We should not see tuples twice unless someone hooks
                         * this into a table without "-p tcp --syn".
                         */
                        addit = false;

                connlimit_debug(conn, found_ct, addr, mask, family);

                if (found == NULL) {
                        /* this one is gone */
                        list_del(&conn->list);
                        kfree(conn);
                        continue;
                }

                if (already_closed(found_ct)) {
                        /*
                         * we do not care about connections which are
                         * closed already -> ditch it
                         */
                        list_del(&conn->list);
                        kfree(conn);
                        ////nf_conntrack_put(&found_ct->ct_general);
                        continue;
                }

                if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
                        /* same source network -> be counted! */
                        ++matches;

                ////nf_conntrack_put(&found_ct->ct_general);
        }

        read_unlock_bh(&nf_conntrack_lock);


>> +		connlimit_debug(conn, found_ct, addr, mask, family);
>> +
>> +		if (found == NULL) {
>> +			/* this one is gone */
>> +			list_del(&conn->list);
>> +			kfree(conn);
>
>Minor optimization possible: you could reuse this memory in case
>addit = true

I think that would make it more complex - need to have the last pointer around.

>> +static bool connlimit_match(const struct sk_buff *skb,
>> +			    const struct net_device *in,
>> +			    const struct net_device *out,
>> +			    const struct xt_match *match,
>> +			    const void *matchinfo, int offset,
>> +			    unsigned int protoff, bool *hotdrop)
>> +{
>> +	const struct xt_connlimit_info *info = matchinfo;
>> +	union nf_conntrack_address addr, mask;
>> +	enum ip_conntrack_info ctinfo;
>> +	struct nf_conn *ct;
>> +	int connections;
>> +
>> +	ct = nf_ct_get(skb, &ctinfo);
>> +	if (ct == NULL) {
>> +		printk(KERN_INFO "xt_connlimit: INVALID connection\n");
>
>
>No printks without net_ratelimit, this one seems like it shouldn't exist
>at all.
Removed.

>And hotdropping is quite unfriendly, it seems that as long as
>you're able to read the addresses (which you're always), you can still
>count the other connections.

This is nf_ct_get that can fail. Without a connection, we can't figure
anything.

>> +static bool connlimit_check(const char *tablename, const void *ip,
>> +			    const struct xt_match *match, void *matchinfo,
>> +			    unsigned int hook_mask)
>> +{
[...]
>> +	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
[...]
>> +	/* init private data */
>> +	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
>
>Missing check for failure (and don't forget to release the module
>reference).

Ok.



Thanks,
	Jan
-- 
