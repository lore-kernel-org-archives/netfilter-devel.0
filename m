From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Fri, 14 Jan 2011 12:58:53 +0100
Message-ID: <4D303A7D.30002@netfilter.org>
References: <20110113123030.3407.59986.stgit@decadence> <4D2F4E1F.4070403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1ANL7C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:59:02 -0500
In-Reply-To: <4D2F4E1F.4070403@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/01/11 20:10, Patrick McHardy wrote:
> Am 13.01.2011 13:30, schrieb Pablo Neira Ayuso:
>> This patch adds flow-based timestamping for conntracks. This
>> conntrack extension is disabled by default. Basically, we use
>> two 64-bits variables to store the creation timestamp once the
>> conntrack has been confirmed and the other to store the deletion
>> time. This extension is disabled by default, to enable it, you
>> have to:
>>
>> echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp
>>
>> This patch allows to save memory for user-space flow-based
>> loogers such as ulogd2. In short, ulogd2 does not need to
>> keep a hashtable with the conntrack in user-space to know
>> when they were created and destroyed, instead we use the
>> kernel timestamp. If we want to have a sane IPFIX implementation
>> in user-space, this nanosecs resolution timestamps are also
>> useful. Other custom user-space applications can benefit from
>> this via libnetfilter_conntrack.
> 
> No general objections from me.
> 
>> This patch does not modifies the /proc output to display
>> the start timestamping in nanosecs (which is not very useful).
>> We would need some generic functions similar to those in
>> xt_time to convert that output to local time in the kernel.
>> I think that ctnetlink is better for this, we pass the
>> timestamps in nanosecs and we call localtime() in the
>> user-space application. For that reason, I decided to only
>> modify the ctnetlink part (including dumping and event
>> notifications).
> 
> Just as an idea, showing the time-delta (aka lifetime)
> of the connection could be interesting and doesn't
> require any timezone conversions. But this could
> certainly be done in a follow up patch.

That's interesting indeed. We can obtain the current time in
ct_seq_start and store it in ct_iter_state, then calculate the
time-delta for each flow entry to display this in the /proc output. The
conntrack tool can do similar but in user-space.

>> --- /dev/null
>> +++ b/include/net/netfilter/nf_conntrack_timestamp.h
>> @@ -0,0 +1,45 @@
>> +#ifndef _NF_CONNTRACK_TSTAMP_H
>> +#define _NF_CONNTRACK_TSTAMP_H
>> +
>> +#include <net/net_namespace.h>
>> +#include <linux/netfilter/nf_conntrack_common.h>
>> +#include <linux/netfilter/nf_conntrack_tuple_common.h>
>> +#include <net/netfilter/nf_conntrack.h>
>> +#include <net/netfilter/nf_conntrack_extend.h>
>> +
>> +struct nf_conn_tstamp {
>> +	u_int64_t start;
>> +	u_int64_t stop;
>> +};
>> +
>> +static inline
>> +struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
>> +{
>> +	return nf_ct_ext_find(ct, NF_CT_EXT_TSTAMP);
>> +}
>> +
>> +static inline
>> +struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
>> +{
>> +	struct net *net = nf_ct_net(ct);
>> +
>> +	if (!net->ct.sysctl_tstamp)
>> +		return NULL;
>> +
>> +	return nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
> 
> How about making this configurable at compile time to avoid any overhead
> (memory in ct_extend and runtime) for anyone not needing it like most
> of the other ct_extend options?

I'm fine with this, I'll add it.

Looking at the source, should we do the same with the accounting? I
remember that we decided to remove this compile-time option time ago.
