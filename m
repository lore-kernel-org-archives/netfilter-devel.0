From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: Re: [PATCHv3 2/2 nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Mon, 10 Aug 2015 00:50:16 +0200
Message-ID: <55C7D928.9020805@wvnet.at>
References: <1438229221-25959-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150806103911.GA18793@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.134]:52677 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbHIWuX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Aug 2015 18:50:23 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 9FEA56124B
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2015 00:50:20 +0200 (CEST)
Received: from 91.141.1.223.wireless.dyn.drei.com (HELO [172.16.0.5]) (bernhard.thaler@wvnet.at@[91.141.1.223])
           (SMTPAUTH User bernhard.thaler@wvnet.at)
          (envelope-sender <bernhard.thaler@wvnet.at>)
          by smtp.wvnet.at (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <netfilter-devel@vger.kernel.org>; 9 Aug 2015 22:50:20 -0000
In-Reply-To: <20150806103911.GA18793@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

seeing all this I think there is a much simpler solution to the initial
problem that should be fixed (IPv6 packets not traversing the bridge
with CONFIG_IPV6=n).

diff --git a/include/net/netfilter/br_netfilter.h
b/include/net/netfilter/br_netfilter.h
index bab824b..d4c6b5f 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -59,7 +59,7 @@ static inline unsigned int
 br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
                       const struct nf_hook_state *state)
 {
-       return NF_DROP;
+       return NF_ACCEPT;
 }
 #endif


Only downside it has that /proc/sys/net/bridge/bridge-nf-call-ip6tables
and /sys/class/net/brXXX/bridge/nf_call_ip6tables is still exposed with
CONFIG_IPV6=n and changeable, but with no effect.
Despite brnf_call_ip6tables being set to 1 packets will not be available
to ip6tables, which will not be present anyway in this case.

I have both solutions ready

* the (old) one introducing new code and exposing sysctl and sysfs
entries only when changeable
* this newly proposed one with just one line of code changed

Please decide which one I should submit. Personally I think the newly
proposed one is the better way to go.

Regards,
Bernhard

On 06.08.2015 12:39, Pablo Neira Ayuso wrote:
> Hi Bernhard,
> 
> On Thu, Jul 30, 2015 at 06:07:01AM +0200, Bernhard Thaler wrote:
>> 230ac490f7fba introduced a dependency to CONFIG_IPV6 which breaks bridging
>> of IPv6 packets on a bridge with CONFIG_IPV6=n. This is due to the default
>> value 1 for sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables,
>> manually setting it to 0 makes IPv6 packets traverse bridge again.
>>
>> Default /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 if
>> CONFIG_IP6_NF_IPTABLES is not enabled as CONFIG_IP6_NF_IPTABLES depends on
>> CONFIG_IPV6 as well and is needed for ip6tables to work correctly.
>>
>> Do not expose sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables
>> and sysfs entry /sys/class/net/brXXX/bridge/nf_call_ip6tables if
>> CONFIG_IP6_NF_IPTABLES is not enabled.
>>
>> Make br_netfilter_ipv6.o dependent on CONFIG_IP6_NF_IPTABLES instead of
>> CONFIG_IPV6.
> 
> Could you send a patch in first place to
> s/CONFIG_IPV6/CONFIG_IP6_NF_IPTABLES ?
> 
> More comments below.
> 
>> Set global brnf_call_* variables to defaults in br_nf_proc_register() and
>> br_nf_ipv6_proc_register() at module init instead of at variable definition
>> to avoid further #ifdef CONFIG_SYSCTL constructs.
>>
>> Define br_nf_ipv6_proc_register() and br_nf_ipv6_proc_unregister() to avoid
>>
>> Tested with a simple bridge with two interfaces and IPv6 packets trying
>> to pass from host on left side to host on right side of the bridge.
>>
>> Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")
>>
>> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
>> ---
>> ---
>> NOTE:
>> * dependency to CONFIG_IPV6 instead of CONFIG_IP6_NF_IPTABLES would be more
>>   "conservative" approach as br_netfilter_ipv6.o was introduced due to
>>   dependencies in br_validate_ipv6() to CONFIG_IPV6; but CONFIG_IP6_NF_IPTABLES
>>   will be needed for ip6tables so this dependency may be more "holistic"
>> * CONFIG_IP6_NF_IPTABLES=n makes br_validate_ipv6() being imported from
>>   br_netfilter.h; it is used in br_netfilter_hooks.c within br_nf_forward_ip()
>>   and br_nf_dev_queue_xmit() and returns -1 which will lead to NF_DROP;
>>   After defaulting /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 with
>>   CONFIG_IP6_NF_IPTABLES=n these two functions me never see IPV6 packets and 
>>   therefore this may not be a problem; I was not able to fully confirm this
>>
>> Patch history
>>
>> v3
>> * fix checkpatch error in separate patch
>> * changes to reduce #ifdef pollution
>>
>> v2
>> * do not expose sysfs and sysctl if CONFIG_IP6_NF_IPTABLES=n 
>> * change dependency to CONFIG_IP6_NF_IPTABLES as suggested by Florian Westphal
>> * removed changes to br_validate_ipv6() in br_netfilter.h as test show it may
>>   not be needed
>>
>> v1
>> * sysfs and sysctl entry were exposed but not writeable if CONFIG_IPV6=n
>>  include/net/netfilter/br_netfilter.h |   21 +++++++++-
>>  net/bridge/Makefile                  |    2 +-
>>  net/bridge/br_netfilter_hooks.c      |   70 ++++++++++++++++++++--------------
>>  net/bridge/br_netfilter_ipv6.c       |   44 +++++++++++++++++++++
>>  net/bridge/br_sysfs_br.c             |    4 ++
>>  5 files changed, 111 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
>> index bab824b..e2cb715 100644
>> --- a/include/net/netfilter/br_netfilter.h
>> +++ b/include/net/netfilter/br_netfilter.h
>> @@ -44,11 +44,17 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
>>  struct net_device *setup_pre_routing(struct sk_buff *skb);
>>  void br_netfilter_enable(void);
>>  
>> -#if IS_ENABLED(CONFIG_IPV6)
>> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>>  int br_validate_ipv6(struct sk_buff *skb);
>>  unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
>>  				    struct sk_buff *skb,
>>  				    const struct nf_hook_state *state);
>> +#ifdef CONFIG_SYSCTL
>> +int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
>> +			    void __user *buffer, size_t *lenp, loff_t *ppos);
>> +int br_nf_ipv6_proc_register(void);
>> +void br_nf_ipv6_proc_unregister(void);
>> +#endif
>>  #else
>>  static inline int br_validate_ipv6(struct sk_buff *skb)
>>  {
>> @@ -61,6 +67,19 @@ br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
>>  {
>>  	return NF_DROP;
>>  }
>> +
>> +#ifdef CONFIG_SYSCTL
>> +static inline int br_nf_ipv6_proc_register(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline void br_nf_ipv6_proc_unregister(void)
>> +{
>> +}
>>  #endif
>> +#endif
>> +
>> +extern int brnf_call_ip6tables __read_mostly;
>>  
>>  #endif /* _BR_NETFILTER_H_ */
>> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
>> index a1cda5d..3fd8beb 100644
>> --- a/net/bridge/Makefile
>> +++ b/net/bridge/Makefile
>> @@ -13,7 +13,7 @@ bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
>>  bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
>>  
>>  br_netfilter-y := br_netfilter_hooks.o
>> -br_netfilter-$(subst m,y,$(CONFIG_IPV6)) += br_netfilter_ipv6.o
>> +br_netfilter-$(subst m,y,$(CONFIG_IP6_NF_IPTABLES)) += br_netfilter_ipv6.o
>>  obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
>>  
>>  bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
>> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
>> index 624e1f2..b202cfe 100644
>> --- a/net/bridge/br_netfilter_hooks.c
>> +++ b/net/bridge/br_netfilter_hooks.c
>> @@ -42,24 +42,16 @@
>>  #include "br_private.h"
>>  #ifdef CONFIG_SYSCTL
>>  #include <linux/sysctl.h>
>> -#endif
>>  
>> -#ifdef CONFIG_SYSCTL
>>  static struct ctl_table_header *brnf_sysctl_header;
>> -static int brnf_call_iptables __read_mostly = 1;
>> -static int brnf_call_ip6tables __read_mostly = 1;
>> -static int brnf_call_arptables __read_mostly = 1;
>> +#endif
>> +
>> +static int brnf_call_iptables __read_mostly;
>> +int brnf_call_ip6tables __read_mostly;
> 
> You can move brnf_call_ip6tables to br_netfilter_ipv6, then add to the
> header file this:
> 
> #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> extern int brnf_call_ip6tables;
> 
> static inline bool brnf_call_ip6tables_is_set(struct net_bridge *br)
> {
>         return !brnf_call_ip6tables && !br->nf_call_ip6tables;
> }
> #else
> static inline bool brnf_call_ip6tables_is_set(struct net_bridge *br)
> {
>         return false;
> }
> #endif
> 
> from the br netfilter ipv6 header file.
> 
