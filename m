From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: add a typedef for the recurring okfn use
Date: Sat, 15 Jan 2011 15:45:54 +0100
Message-ID: <4D31B322.2070305@trash.net>
References: <alpine.LNX.2.01.1101142253330.15697@obet.zrqbmnf.qr> <4D31B08A.4020101@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58959 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1AOOp6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:45:58 -0500
In-Reply-To: <4D31B08A.4020101@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.01.2011 15:34, schrieb Pablo Neira Ayuso:
> On 14/01/11 22:54, Jan Engelhardt wrote:
>> parent 0134e89c7bcc9fde1da962c82a120691e185619f (v2.6.37-3800-g0134e89)
>> commit 7994a5e014b1b85469a83463e35145aa5e17333c
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Fri Jan 14 22:03:19 2011 +0100
>>
>> netfilter: add a typedef for the recurring okfn use
>>
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>>  include/linux/netfilter.h                      |   42 ++++++------
>>  include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    2 +-
>>  include/net/netfilter/nf_queue.h               |    2 +-
>>  net/bridge/br_netfilter.c                      |   57 ++++++++--------
>>  net/bridge/netfilter/ebtable_filter.c          |    4 +-
>>  net/bridge/netfilter/ebtable_nat.c             |    9 ++-
>>  net/decnet/netfilter/dn_rtmsg.c                |    8 +--
>>  net/ipv4/netfilter/arptable_filter.c           |    2 +-
>>  net/ipv4/netfilter/ipt_CLUSTERIP.c             |    7 +--
>>  net/ipv4/netfilter/iptable_filter.c            |    2 +-
>>  net/ipv4/netfilter/iptable_mangle.c            |    8 +--
>>  net/ipv4/netfilter/iptable_raw.c               |    2 +-
>>  net/ipv4/netfilter/iptable_security.c          |    3 +-
>>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   27 +++----
>>  net/ipv4/netfilter/nf_defrag_ipv4.c            |    9 +--
>>  net/ipv4/netfilter/nf_nat_standalone.c         |   32 +++------
>>  net/ipv6/netfilter/ip6table_filter.c           |    2 +-
>>  net/ipv6/netfilter/ip6table_mangle.c           |    2 +-
>>  net/ipv6/netfilter/ip6table_raw.c              |    2 +-
>>  net/ipv6/netfilter/ip6table_security.c         |    3 +-
>>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   34 ++++-----
>>  net/ipv6/netfilter/nf_conntrack_reasm.c        |    2 +-
>>  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    9 +--
>>  net/netfilter/core.c                           |   18 ++---
>>  net/netfilter/ipvs/ip_vs_core.c                |   22 +++---
>>  net/netfilter/nf_internals.h                   |   23 ++----
>>  net/netfilter/nf_queue.c                       |   21 ++----
>>  security/selinux/hooks.c                       |   45 ++++++-------
>>  28 files changed, 172 insertions(+), 227 deletions(-)
>>
>> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
>> index 0ab7ca7..40392b7 100644
>> --- a/include/linux/netfilter.h
>> +++ b/include/linux/netfilter.h
>> @@ -89,11 +89,12 @@ extern void netfilter_init(void);
>>  
>>  struct sk_buff;
>>  
>> +typedef int (*nf_okfn_t)(struct sk_buff *);
>>  typedef unsigned int nf_hookfn(unsigned int hooknum,
>>  			       struct sk_buff *skb,
>>  			       const struct net_device *in,
>>  			       const struct net_device *out,
>> -			       int (*okfn)(struct sk_buff *));
>> +			       nf_okfn_t okfn);
> 
> This typedef makes the source code less readable in my opinion. You have
> to look for nf_okfn_t to look what it actually is.

I agree. This also violates the CodingStyle rules for use of typedefs.

