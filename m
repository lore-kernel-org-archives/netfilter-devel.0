From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 26 Jan 2011 12:57:16 +0100
Message-ID: <4D400C1C.3000008@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <alpine.DEB.2.00.1101212232290.10581@blackhole.kfki.hu> <4D3EE277.9070804@trash.net> <alpine.DEB.2.00.1101252150450.19648@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from HSI-KBW-109-192-188-061.hsi6.kabel-badenwuerttemberg.de ([109.192.188.61]:37960
	"EHLO x100e.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245Ab1A0BFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:05:17 -0500
In-Reply-To: <alpine.DEB.2.00.1101252150450.19648@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 25.01.2011 22:23, schrieb Jozsef Kadlecsik:
> On Tue, 25 Jan 2011, Patrick McHardy wrote:
> 
>>> +static int
>>> +ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
>>> +{
>>> +	ip_set_id_t index = IPSET_INVALID_ID, max;
>>> +	struct ip_set *set = NULL;
>>> +	struct nlmsghdr *nlh = NULL;
>>> +	unsigned int flags = NETLINK_CB(cb->skb).pid ? NLM_F_MULTI : 0;
>>> +	int ret = 0;
>>> +
>>> +	if (cb->args[0] == DUMP_INIT) {
>>> +		ret = dump_init(cb);
>>> +		if (ret < 0) {
>>> +			/* We have to create and send the error message
>>> +			 * manually :-( */
>>> +			netlink_ack(cb->skb, nlmsg_hdr(cb->skb), ret);
>>
>> This should probably only be done if the NLM_F_ACK flag was set
>> on the request.
> 
> I never thought to set NLM_F_ACK for dumping. I'll set the flag in the 
> request but I believe I have to send the error message regardless of the 
> flag: the dump initialization fails iff the named set does not exist and 
> it should be reported.

netlink_dump() will already include the errno code in the final
(in this case only) message. Perhaps we should also return it
back from sendmsg() if the first call to ->dump() fails without
putting anything in the message.

>  
>>> +
>>> +	if (attr[IPSET_ATTR_DATA]) {
>>> +		ret = call_ad(skb, attr,
>>> +			      set, attr[IPSET_ATTR_DATA], IPSET_ADD, flags);
>>> +	} else {
>>> +		int nla_rem;
>>> +
>>> +		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
>>> +			if (nla_type(nla) != IPSET_ATTR_DATA ||
>>> +			    !flag_nested(nla))
>>> +				return -IPSET_ERR_PROTOCOL;
>>
>> Since addition can fail due to size problems anyways it not very
>> important, but we could perform validation before attempting to
>> add members so the operation either succeeds or fails entirely.
> 
> Yeah, it's a protocol check, so it should come first. But the call again 
> to nla_for_each_nested wouldn't be too ugly? Wrapping the condition into 
> unlikely() would make it better?

I guess it would make sense if we could make sure the following
operations won't fail. Unless that is done I'd leave it as it is.

> 
>> To really make sense that would require to test for existance of
>> members on deletion and for enough space (+ possibly pre-allocation)
>> on addition though, so for now we can ignore it I guess.
> 
>>> +
>>> +	read_lock_bh(&set->lock);
>>> +	ret = set->variant->uadt(set,
>>> +				 nla_data(attr[IPSET_ATTR_DATA]),
>>> +				 nla_len(attr[IPSET_ATTR_DATA]),
>>> +				 IPSET_TEST, NULL, 0);
>>> +	read_unlock_bh(&set->lock);
>>> +	/* Userspace can't trigger element to be re-added */
>>> +	if (ret == -EAGAIN)
>>> +		ret = 1;
>>
>> This value is returned to userspace, what does '1' mean?
> 
> The test functions return a positive integer for success. The only 
> exception is the -EAGAIN return value, which means an incomplete element 
> was tested and it triggers the core to re-add the element. However 
> re-adding is meaningful for kernel side tests only. So for the sake of 
> consistency, the return value is corrected to a positive integer.
> 
> The bitmap:ip,mac type uses -EAGAIN: if the element was added without the 
> MAC part then when it's tested as a kernel requests, by re-adding the 
> element we can fill out the MAC part from the tested packet.

Yes, but since this is a nfnetlink callback, we'll return that
value in the ACK message. Is that really intended? Usually we
indicate success to userspace using the value '0'.


>>> +	set = ip_set_list[index];
>>> +
>>> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>>> +	if (skb2 == NULL)
>>> +		return -ENOMEM;
>>> +
>>> +	nlh2 = start_msg(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 0,
>>> +			 IPSET_CMD_HEADER);
>>> +	if (!nlh2)
>>> +		goto nlmsg_failure;
>>> +	NLA_PUT_U8(skb2, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
>>> +	NLA_PUT_STRING(skb2, IPSET_ATTR_SETNAME, set->name);
>>> +	NLA_PUT_STRING(skb2, IPSET_ATTR_TYPENAME, set->type->name);
>>> +	NLA_PUT_U8(skb2, IPSET_ATTR_FAMILY, set->family);
>>> +	NLA_PUT_U8(skb2, IPSET_ATTR_REVISION, set->type->revision);
>>> +	nlmsg_end(skb2, nlh2);
>>> +
>>> +	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
>>> +	if (ret < 0)
>>> +		return -EFAULT;
>>
>> Why not propagate the error?
> 
> I don't quite understand what do you mean. Should I attempt to send a 
> second message?

No, just return "ret" instead of EFAULT. netlink_rcv_skb() will include
it in the ACK message.
