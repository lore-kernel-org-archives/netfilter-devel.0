From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 17:31:07 +0100
Message-ID: <4EE8CF4B.9010005@trash.net>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <1323860443-7129-2-git-send-email-pablo@netfilter.org> <4EE88729.7010507@trash.net> <20111214131802.GB2749@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40935 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1LNQbQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:31:16 -0500
In-Reply-To: <20111214131802.GB2749@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.12.2011 14:18, Pablo Neira Ayuso wrote:
> On Wed, Dec 14, 2011 at 12:23:21PM +0100, Patrick McHardy wrote:
> [...]
>>> +nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>>> +	     const struct nlmsghdr *nlh, const struct nlattr * const tb[])
>>> +{
>>> +	int ret;
>>> +	struct nf_acct *acct, *matching = NULL;
>>> +	char *acct_name;
>>> +
>>> +	if (!tb[NFACCT_NAME])
>>> +		return -EINVAL;
>>> +
>>> +	acct_name = nla_data(tb[NFACCT_NAME]);
>>> +
>>> +	rcu_read_lock();
>>> +	list_for_each_entry(acct,&nfnl_acct_list, head) {
>>
>> I don't really get the locking concept. All netlink operations happen under
>> the nfnl mutex, so using RCU for the lookup shouldn't be necessary
>> (applied to all netlink operations).
> 
> If you add one iptables rule with NFACCT, you have to iterate over the
> list (without the mutex). Very unlikely, but we may delete one
> accounting object via nfnetlink at the same time of adding the rule
> that refers to it.

Sure. But we don't need it for any of the netlink operations.

> 
>>> +        }
>>> +	rcu_read_unlock();
>>> +
>>> +	acct = kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
>>> +	if (acct == NULL) {
>>> +		ret = -ENOMEM;
>>> +		goto err;
>>> +	}
>>> +	spin_lock_init(&acct->lock);
>>> +	strncpy(acct->name, nla_data(tb[NFACCT_NAME]), NFACCT_NAME_MAX);
>>> +	if (tb[NFACCT_BYTES])
>>> +		acct->bytes = be64_to_cpu(nla_get_u64(tb[NFACCT_BYTES]));
>>> +	if (tb[NFACCT_PKTS])
>>> +		acct->pkts = be64_to_cpu(nla_get_u64(tb[NFACCT_PKTS]));
>>> +
>>> +	atomic_inc(&acct->refcnt);
>>> +
>>> +	/* We are protected by nfnl mutex. */
>>> +	if (matching) {
>>
>> This seems to be a replace operation, so I think you should
>> require NLM_F_REPLACE. Also it seems you could just
>> reinitialize the existing counter instead of unconditionally
>> allocating a new one.
> 
> I think it's easier to return -EBUSY as you suggested.

That was for deletion. For addition supporting replace is fine, but
we should use the correct netlink flags.
