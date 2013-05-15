From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 09:08:27 +0300
Message-ID: <5193265B.3050605@linux.intel.com>
References: <519216B6.7060701@linux.intel.com> <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com> <20130514222051.GB10082@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3EOGIa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 02:08:30 -0400
In-Reply-To: <20130514222051.GB10082@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
> On Tue, May 14, 2013 at 01:51:22PM +0300, Tomasz Bursztyka wrote:
>> While changing chain's settings, like its policy, it requires either the
>> handle or the name, but not both.
>>
>> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
>> ---
>>   src/chain.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/chain.c b/src/chain.c
>> index 1b1c3fe..e9a7896 100644
>> --- a/src/chain.c
>> +++ b/src/chain.c
>> @@ -263,7 +263,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
>>   		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
>>   		mnl_attr_nest_end(nlh, nest);
>>   	}
>> -	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE))
>> +	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE) &&
>> +	    !(c->flags & (1 << NFT_CHAIN_ATTR_NAME)))
>>   		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE, be64toh(c->handle));
> The kernel will ignore the name if the handle is set. So no need to
> make this artificial restriction in user-space.

No this not the case, have a look at net/netfilter/nf_tables_api.c in 
nf_tables_newchain(), lines 858-860:

if (nla[NFTA_CHAIN_HANDLE] && name &&
     !IS_ERR(nf_tables_chain_lookup(table, nla[NFTA_CHAIN_NAME])))
         return -EEXIST;

When handle and name are both present it means user wants to change the 
chain's name. (see line 882)
But in our case, when changing only the policy we don't touch the name, 
but libnftables provides it anyway thus failing on that test.||||

My patch is bogus anyway: I should add a marker that name has been 
changed first (and if only it was really different), and then handle it 
when building the message.


Tomasz
