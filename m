From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 02 Feb 2011 07:40:08 +0100
Message-ID: <4D48FC48.3000807@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net> <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1BBGk0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:40:26 -0500
In-Reply-To: <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.02.2011 20:43, Jozsef Kadlecsik wrote:
> On Tue, 1 Feb 2011, Patrick McHardy wrote:
> 
>> Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
>>> +static int
>>> +call_ad(struct sk_buff *skb, struct ip_set *set,
>>> +	struct nlattr *tb[], enum ipset_adt adt,
>>> +	u32 flags, bool use_lineno)
>>> +{
>>> +	int ret, retried = 0;
>>> +	u32 lineno = 0;
>>> +	bool eexist = flags & IPSET_FLAG_EXIST;
>>> +
>>> +	do {
>>> +		write_lock_bh(&set->lock);
>>> +		ret = set->variant->uadt(set, tb, adt, &lineno, flags);
>>> +		write_unlock_bh(&set->lock);
>>> +	} while (ret == -EAGAIN &&
>>> +		 set->variant->resize &&
>>> +		 (ret = set->variant->resize(set, retried++)) == 0);
>>> +
>>> +	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
>>> +		return 0;
>>> +	if (lineno && use_lineno) {
>>> +		/* Error in restore/batch mode: send back lineno */
>>> +		struct nlmsghdr *nlh = nlmsg_hdr(skb);
>>> +		int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
>>> +		struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
>>> +		struct nlattr *cmdattr = (void *)nlh + min_len;
>>> +		u32 *errline;
>>> +
>>> +		nla_parse(cda, IPSET_ATTR_CMD_MAX,
>>> +			  cmdattr, nlh->nlmsg_len - min_len,
>>> +			  ip_set_adt_policy);
>>> +
>>> +		errline = nla_data(cda[IPSET_ATTR_LINENO]);
>>> +
>>> +		*errline = lineno;
>>
>> This is still not correct. I didn't mean to remove the const attributes
>> (the message is still considered const by the higher layers, the netlink
>> functions just cast this away). You're modifying the received message,
>> I don't see how this can be useful to userspace.
> 
> I can't find where the message is considered const in netlink/nfnetlink.
> It seems to be freely writable via skb.
>  
>> I guess you're relying on that the original message is appended to a
>> nlmsgerr message. That doesn't seem right though, if you want to return
>> something to userspace, you should construct a new message.
> 
> The message we are processing here carried multiple commands (each having 
> an attribute with the line number of the given command) and one failed 
> from some reason. We have to notify the userspace which command, at what 
> line failed. For this reason the multi-command messages have got an 
> attribute, which can be filled out with the line number - that happens 
> here. The attribute is already there, the message is not enlarged, just
> the empty value is overwritten with the proper value.
> 
> The line number reporting works this way, tested in the testsuite too.

I'm still not really clear how this works since the message contents
have been copied from userspace, so modifying the contents seems
useless. I'll have a closer look at userspace to understand how this
works.

> If I had to construct a completely new message and sent it, that'd be more 
> or less the duplication of netlink_ack. Additionally I had to suppress 
> netlink from sending an errmsg/ack too.
> 
> If one can't rely on the modifiable message and nlmsgerr, then the error 
> reporting in netlink is, hm, not really useful :-(

I'm mainly not clear about how this works at all, will have a closer
look at userspace :)
