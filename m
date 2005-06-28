From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 06:03:31 +0200
Message-ID: <42C0CC13.3090705@trash.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<42C0B2F0.4000104@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C0B2F0.4000104@eurodev.net>
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

Pablo Neira wrote:
> Patrick McHardy wrote:
> 
>> +/* ctnetlink multicast groups: reports any change of ctinfo,
>> + * ctstatus, or protocol state change.
>> + */
>> +#define NFGRP_IPV4_CT_TCP      0x01
>> +#define NFGRP_IPV4_CT_UDP      0x02
>> +#define NFGRP_IPV4_CT_ICMP     0x04
>> +#define NFGRP_IPV4_CT_OTHER    0x08
>>
>> I'm not sure how useful these groups are. I think groups for different
>> event-types might be more useful to reduce the noise.
>
> Yes, this looks fine. So we could kill those and use an event
> subscription.

Yes. The question is how to define the groups. One group per event seems
wasteful, we probably need some sensible grouping. What events types
are there currently?

>> I couldn't find this function, but in 2.6.12 expectations aren't
>> refcounted anymore. If they are again by this patch, the refcnt would
>> be leaked in the following lines:
>>
>> +       skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
>> +       if (!skb2)
>> +               return -ENOMEM;
> 
> 
> Thanks for catching up this, I'll fix it. I recovered the refcounting
> for expectations to avoid any possible race condition since I could be
> working with an expectation whose timeout has expired.

Great. I wanted to restore it anyway for "permanent expectations" for
the H.323 helper.

> Does this help? Hope so.
> http://people.netfilter.org/~pablo/ctnetlink-2.6.12/2.6.11-vs-2.6.12/04ctnetlink.patch

I'll continue tomorrow, its getting late here ..

Regards
Patrick
