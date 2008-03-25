From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 06/32]: nf_conntrack: introduce expectation classes
 and policies
Date: Tue, 25 Mar 2008 16:51:20 +0100
Message-ID: <47E91F78.8090709@trash.net>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain> <20080325141458.10539.61924.sendpatchset@localhost.localdomain> <alpine.LNX.1.10.0803251635320.9368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:10504 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755969AbYCYPve (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:51:34 -0400
In-Reply-To: <alpine.LNX.1.10.0803251635320.9368@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> 
> On Tuesday 2008-03-25 15:14, Patrick McHardy wrote:
> 
>> /****************************************************************************/ 
>>
>> +static const struct nf_conntrack_expect_policy h245_exp_policy = {
>> +    .max_expected    = H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
>> +    .timeout    = 240,
>> +};
>> +
> 
> Developer questions: what does ->max_expected limit?
> Expectations for one connection, or for the whole helper module?

Unfulfilled expectations per conntrack.

>> @@ -110,7 +110,8 @@ int nf_conntrack_helper_register(struct 
>> nf_conntrack_helper *me)
>> {
>>     unsigned int h = helper_hash(&me->tuple);
>>
>> -    BUG_ON(me->timeout == 0);
>> +    BUG_ON(me->expect_policy == NULL);
>> +    BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
>>
>>     mutex_lock(&nf_ct_helper_mutex);
>>     hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);
> 
> A zero timeout triggered a BUG_ON in nf_conntrack_helper_register,
> now this check is gone!?

Yes, it requires iterating through the policies,
which is too much trouble for checking a developer
bug (and no module in the kernel does this). In fact
the SNMP NAT helper sets a fake timeout to avoid
triggering the BUG_ON since it never registers any
expectations.

