From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 14:36:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FA9CE.8000805@trash.net>
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


On Jun 25 2007 13:41, Patrick McHardy wrote:
>> +config NETFILTER_XT_MATCH_CONNLIMIT
>> +	tristate '"connlimit" match support"'
>> +	depends on NETFILTER_XTABLES && NF_CONNTRACK_IPV4
>>   
>
> This doesn't seem right for an x_tables target. Adding IPv6 looks
> trivial, the only thing that really depends on the address length
> seems to be the masked comparison.

Indeed - leftovers from its POM ascendant. But do I have to add ipv6 now?

(It would also be quite a duplicate of count_them() and connlimit_match() -
is there a better way without too many if()s?)

>> +static inline unsigned int connlimit_iphash(u_int32_t addr)
>> +{
>> +	/*
>> +	 * Since iphash (in struct xt_connlimit_data) has 256 entries, we need
>> +	 * to "% 256" it. "& mask" works too, but _only_ if the iphash array
>> +	 * size is exactly a {power of two} minus 1.
>>   
> Incorrect comment, it does use &.

I reword it.

>> +		found_ct = NULL;
>> +
>> +		if (found != NULL)
>> +			found_ct = nf_ct_tuplehash_to_ctrack(found);
>> +
>> +		if (found_ct != NULL &&
>>   
> Can't be NULL here.
> OK it can. But you should probably just continue for found == NULL above.

I doubt I can do that. Is is part of the destruction.
A little more below, there is /* this one is gone */
Also, there is the pr_debug() call.

>> +		if (found == NULL) {
>> +			/* this one is gone */
>> +			list_del(&conn->list);
>> +			kfree(conn);
>> +			continue;
>> +		}

>> +		if ((addr & mask) == (conn->tuple.src.u3.ip & mask))
>> +			/* same source network -> be counted! */
>> +			++matches;
>>   
>
> See comment below about pre-increment.
>
>> +
>> +		nf_conntrack_put(&found_ct->ct_general);
> You're holding the match's private lock here. Would be better
> to avoid this, though I don't see how right now.
>
>> +	}
>> +
>> +	if (addit) {
>> +		/* save the new connection in our list */
>> +#ifdef DEBUG
>>   
>
> Is that #ifdef needed?

No, removed.

>> +static bool connlimit_check(const char *tablename, const void *ip,
>> +			    const struct xt_match *match, void *matchinfo,
>> +			    unsigned int hook_mask)
>> +{
>> +	struct xt_connlimit_info *info = matchinfo;
>> +	unsigned int i;
>> +
>> +	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
>> +		printk(KERN_WARNING "cannot load conntrack support for "
>> +		       "address family %u\n", match->family);
>> +		return false;
>> +	}
>> +
>> +	/* init private data */
>> +	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
>> +	spin_lock_init(&info->data->lock);
>> +	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
>>   
> I prefer post-increment in all cases but those where pre-increment
> is really needed.

Can I ignore that?

>> +static struct xt_match connlimit_reg = {
>>   
> __read_mostly?

No other xt_ modules have it, but I can add it.

>> +static int __init xt_connlimit_init(void)
>> +{
>> +	get_random_bytes(&connlimit_iphash_rnd, sizeof(connlimit_iphash_rnd));
>>   
>
> We usually initialize jhash random values at the time the first
> hash is calculated because there might be not enough entropy
> available during boot.

The routing code (where Eric pointed me to) does it on boot-up.
I have xt_connlimit loaded at boot (in runlevel B), there does not seem to be a
problem.


	Jan
-- 
