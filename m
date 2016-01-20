From: =?UTF-8?Q?st=c3=a9phane_bryant?= <stephane.ml.bryant@gmail.com>
Subject: Re: [PATCH nf-next 1/3] netfilter: bridge: add nf_afinfo to enable
 queuing to userspace
Date: Wed, 20 Jan 2016 15:34:05 +0100
Message-ID: <569F9ADD.40500@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-2-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115094905.GA7462@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34687 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbcATOeL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 09:34:11 -0500
Received: by mail-wm0-f66.google.com with SMTP id b14so4554909wmb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 06:34:11 -0800 (PST)
In-Reply-To: <20160115094905.GA7462@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/15/2016 10:49 AM, Florian Westphal wrote:
> 
>> --- a/net/bridge/br_netfilter_hooks.c
>> +++ b/net/bridge/br_netfilter_hooks.c
>> @@ -999,6 +999,46 @@ static struct ctl_table brnf_table[] = {
>>  };
>>  #endif
>>  
>> +static void nf_br_saveroute(const struct sk_buff *skb,
>> +			    struct nf_queue_entry *entry)
> 
> Please put all of these functions into a new file.
> CONFIG_BRIDGE_NETFILTER will be deprecated, this is the glue part
> that allows a bridge to use arp and /ip(6)tables.
> 

Sorry if i am a bit of a slow-learner, but i assume you mean following
what's done for, e.g., ipv4, and have this into a bridge/netfilter.c and
initializing this part of the subsystem.

