From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 07/32]: Add nf_inet_addr_cmp()
Date: Thu, 28 Feb 2008 13:23:55 +0100
Message-ID: <47C6A7DB.5030700@trash.net>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain> <20080228115957.29267.35707.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0802281317360.4324@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:6844 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYB1MYK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:24:10 -0500
In-Reply-To: <Pine.LNX.4.64.0802281317360.4324@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Feb 28 2008 13:00, Patrick McHardy wrote:
>> +static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
>> +				   const union nf_inet_addr *a2)
>> +{
>> +	return a1->all[0] == a2->all[0] &&
>> +	       a1->all[1] == a2->all[1] &&
>> +	       a1->all[2] == a2->all[2] &&
>> +	       a1->all[3] == a2->all[3];
>> +}
>> +
> 
> Humm... this might raise undefined/unexpected behavior for IPv4 addresses,
> for which nf_inet_addr is not properly flattened (zeroed or all-ones,
> or whatever static pattern you want to put in all[1],all[2],all[3]),
> but the problem already existed before I guess:
> 
>> static inline int __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
>> 					  const struct nf_conntrack_tuple *t2)
>> { 
>> -	return (t1->src.u3.all[0] == t2->src.u3.all[0] &&
>> -		t1->src.u3.all[1] == t2->src.u3.all[1] &&
>> -		t1->src.u3.all[2] == t2->src.u3.all[2] &&
>> -		t1->src.u3.all[3] == t2->src.u3.all[3] &&
>> +	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&


Indeed, but so far I'm pretty sure all addresses are initialized
properly. I checked conntrack several times, although its already
some time ago. xtables matches and targets should also be fine
since userspace zeroes everything before initializing it.
