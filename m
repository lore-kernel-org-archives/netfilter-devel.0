From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 24/29] add packets and bytes mark capability
 to nfacct
Date: Thu, 11 Jul 2013 19:56:59 +0100
Message-ID: <51DEFFFB.9060903@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com> <20130711011446.GA7065@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:49782 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3GKS5I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:57:08 -0400
Received: by mail-la0-f53.google.com with SMTP id fs12so7118822lab.12
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 11:57:06 -0700 (PDT)
In-Reply-To: <20130711011446.GA7065@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Pablo Neira Ayuso wrote:
> On Wed, Jul 10, 2013 at 07:25:22PM +0100, Michael Zintakis wrote:
>> * add two variables to each nfacct object - 'pmark' and 'bmark', allowing
>> short-term traffic accounting to be implemented by placing a "mark" against
>> that object.
>>
>> This enables counting of traffic (both bytes and packets) since that mark has
>> been enabled/set, in addition to the main packet and byte counters.
>>
>> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
>> ---
>>  include/uapi/linux/netfilter/nfnetlink_acct.h |  8 +++-
>>  net/netfilter/nfnetlink_acct.c                | 56 +++++++++++++++++++++++++++
>>  2 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
>> index 18cd28e..809fa35 100644
>> --- a/net/netfilter/nfnetlink_acct.c
>> +++ b/net/netfilter/nfnetlink_acct.c
>> @@ -33,6 +33,8 @@ struct nf_acct {
>>  	atomic64_t		pkts;
>>  	atomic64_t		bytes;
>>  	u64			bthr;
>> +	u64			pmark;
>> +	u64			bmark;
>>  	u16			fmt;
>>  	u16			flags;
>>  	struct list_head	head;
> 
> Oh my...
> 
> You insist on your idea of using the kernel as a database to simplify
> your user-space program. All these fields are set/unset from
> userspace, they are not altered by packets at all. This does not
> belong here.
I don't "insist" on anything Pablo and I am not using the kernel as a database either.

The way these variables are structured and information is gathered/presented is the most efficient way - both memory and performance-wise, compared to what you were suggesting we do up until now (with separate file access and so on), not to mention the security aspect of it and the fact that protecting this within the kernel is much more secure and less error-prone compared to your suggestion with file access. That, at the end of the day, is what matters here.
