From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: Re: [RFC PATCH nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Mon, 6 Jul 2015 23:00:23 +0200
Message-ID: <559AEC67.6020601@wvnet.at>
References: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150705215334.GA16864@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.135]:31223 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbbGFVAb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 17:00:31 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 6F3C519A5D74
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2015 23:00:28 +0200 (CEST)
Received: from 178.115.131.222.wireless.dyn.drei.com (HELO [172.16.0.2]) (bernhard.thaler@wvnet.at@[178.115.131.222])
           (SMTPAUTH User bernhard.thaler@wvnet.at)
          (envelope-sender <bernhard.thaler@wvnet.at>)
          by smtp.wvnet.at (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <netfilter-devel@vger.kernel.org>; 6 Jul 2015 21:00:28 -0000
In-Reply-To: <20150705215334.GA16864@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 05.07.2015 23:53, Florian Westphal wrote:
> Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
>> /sys/class/net/brXXX/bridge/nf_call_ip6tables and
>> /proc/sys/net/bridge/bridge-nf-call-ip6tables can be set to 1 with
>> CONFIG_IPV6=n. But br_nf_pre_routing_ipv6() is not available and
>> ip6tables would not be usable as well.
>>
>> Do not allow to set both flags to 1 with CONFIG_IPV6=n.
>>
>> Change return value of placeholder for br_validate_ipv6() as it is
>> used in br_nf_forward_ip() even with CONFIG_IPV6=n.
>>
>> Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")
>> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
>> ---
>>  static inline unsigned int
>> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
>> index d89f4fa..db0d038 100644
>> --- a/net/bridge/br_netfilter_hooks.c
>> +++ b/net/bridge/br_netfilter_hooks.c
>> @@ -47,14 +47,22 @@
>>  #ifdef CONFIG_SYSCTL
>>  static struct ctl_table_header *brnf_sysctl_header;
>>  static int brnf_call_iptables __read_mostly = 1;
>> +#if IS_ENABLED(CONFIG_IPV6)
> 
> IS_ENABLED(IP6_NF_IPTABLES) ?
> 

br_netfilter_ipv6.o is dependent on CONFIG_IPV6 and contains
br_nf_pre_routing_ipv6()...for this reason I sticked with CONFIG_IPV6 to
stay consistent. Maybe we should check for both here?

>>  static struct ctl_table brnf_table[] = {
>>  	{
>>  		.procname	= "bridge-nf-call-arptables",
>> @@ -985,7 +1004,7 @@ static struct ctl_table brnf_table[] = {
>>  		.data		= &brnf_call_ip6tables,
>>  		.maxlen		= sizeof(int),
>>  		.mode		= 0644,
>> -		.proc_handler	= brnf_sysctl_call_tables,
>> +		.proc_handler	= brnf_sysctl_call_ip6tables,
>>  	},
> 
> Might also make sense to not create the sysctl and sysfs entry in the
> first place if no ip6tables is available.

Totally agree, it would be the best solution.

My idea was that I do not know how admins and their existing scripts
react if sysctl and sysfs entry are gone entirely...and if everybody
assumes the default is 0 if these entry do not exist.

But scripts that do not check the return code of their write operations
on the sysctl and sysfs may not check for the existance of these entries
either...

A message in dmesg log explaining that ip6tables sysctl and sysfs
entries are not exposed due to CONFIG_IPV6=n (and/or IP6_NF_IPTABLES)
may be more helpful to understand what is going on.

I will update the code to remove the entries instead of blocking the write.

> 
