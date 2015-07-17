From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: Re: [PATCHv2 nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Sat, 18 Jul 2015 01:37:26 +0200
Message-ID: <55A991B6.3080608@wvnet.at>
References: <20150715174702.GA7407@salvia>
 <1437006884-11116-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150716111732.GB3920@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.132]:59111 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbbGQXhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2015 19:37:38 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 2C6671C51E4F
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Jul 2015 01:37:36 +0200 (CEST)
Received: from 046074151168.atmpu0005.highway.a1.net (HELO [192.168.42.71]) (bernhard.thaler@wvnet.at@[46.74.151.168])
           (SMTPAUTH User bernhard.thaler@wvnet.at)
          (envelope-sender <bernhard.thaler@wvnet.at>)
          by smtp.wvnet.at (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <netfilter-devel@vger.kernel.org>; 17 Jul 2015 23:37:35 -0000
In-Reply-To: <20150716111732.GB3920@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 16.07.2015 13:17, Pablo Neira Ayuso wrote:
> On Thu, Jul 16, 2015 at 02:34:44AM +0200, Bernhard Thaler wrote:
> [...]
>> * checkpatch.pl throws error "ERROR: do not initialise statics to 0 or NULL"
>> but left for consistency with similar declarations
> 
> I'd appreciate if you can address this in first place, so we don't have
> to undo what we've just done for the ip6tables LOCs.
> 

OK, will do so.

>> * dependency to CONFIG_IPV6 instead of CONFIG_IP6_NF_IPTABLES would be more
>>   "conservative" approach as br_netfilter_ipv6.o was introduced due to
>>   dependencies in br_validate_ipv6() to CONFIG_IPV6; but CONFIG_IP6_NF_IPTABLES
>>   will be needed for ip6tables so this dependency may be more "holistic"
> 
> I'm fine if you want to restrict this to ip6tables. This may break
> out-of-tree modules since they may be relying on these hooks, but we
> don't care about those.
> 

Wasn't aware of that. Don't really want to break functionality for
anybody...but if you are fine with the change as it is I leave it as it is.

> I think this s/CONFIG_IPV6/CONFIG_IP6_NF_IPTABLES should come in a
> separated patch, just after the one that removes the checkpatch
> errors I'd suggest.
> 

OK will do so.

>> * CONFIG_IP6_NF_IPTABLES=n makes br_validate_ipv6() being imported from
>>   br_netfilter.h; it is used in br_netfilter_hooks.c within br_nf_forward_ip()
>>   and br_nf_dev_queue_xmit() and returns -1 which will lead to NF_DROP;
>>   After defaulting /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 with
>>   CONFIG_IP6_NF_IPTABLES=n these two functions me never see IPV6 packets and 
>>   therefore this may not be a problem; I was not able to fully confirm this
> 
> It would be great if you can reduce #ifdef pollution. Now that we have
> a br_netfilter_ipv6.c file, I think it should be possible to move the
> IPv6 specific code there, at least the /proc code chunk.
> 
> Could you have a look into this? Thanks!
> 

I don't like the #ifdef pollution as well. But I do not find a good
solution to avoid it for brnf_call_ip6tables definition.
I had a look into putting the /proc entry code into br_netfilter_ipv6.c
but I may need some pointers/help how to do it:

- br_netfilter_init() calls register_net_sysctl() with brnf_table[] as
argument to setup the sysctl entries
- brnf_table[] is initialized with static number of elements in
br_netfilter_hooks.c, with the current code I see no way how to set this
single ip6tables array element in br_netfilter_ipv6.c

Currently I see not other solution than using the #ifdef in the
definition of ip6tables sysctl entry in brnf_table[].
