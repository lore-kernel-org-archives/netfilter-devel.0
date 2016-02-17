From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 0/6] Namespacify various ip sysctl knobs
Date: Wed, 17 Feb 2016 09:47:41 +0200
Message-ID: <56C4259D.9080202@kyup.com>
References: <1455530583-23053-1-git-send-email-kernel@kyup.com>
 <20160216.204328.1217913168570304116.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
	pabeni@redhat.com, jmorris@namei.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34788 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcBQHrn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Feb 2016 02:47:43 -0500
Received: by mail-wm0-f49.google.com with SMTP id b205so143255877wmb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 23:47:43 -0800 (PST)
In-Reply-To: <20160216.204328.1217913168570304116.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 02/17/2016 03:43 AM, David Miller wrote:
> From: Nikolay Borisov <kernel@kyup.com>
> Date: Mon, 15 Feb 2016 12:02:57 +0200
> 
>> This series continues namespacifying more net related knobs.
>> The focus here is on ip options. Patches 1,3,4,5 namespacify
>> the respective sysctl knobs. Patch 2 moves some igmp code to the 
>> correct file (and function) and also adds some #ifdef guards to 
>> silence compilation warnings. 
>>
>> Finally, patch 5 exposes the ip fragmentation related sysctls 
>> since all of the knobs are namespaced.
> 
> Series applied, but I found Arnd's fix for the unused local variable
> problems much nicer.  I wish you had fixed it that way.

I agree, but frankly I haven't really thought about that, but will keep
it in mind the next time I deal with code :)

Can't you apply his fix on top of my commit?
