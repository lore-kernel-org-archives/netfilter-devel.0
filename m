From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 1/3] iptables: change 'iface' part in hash:net,iface
 set
Date: Fri, 13 Jul 2012 01:41:44 +0100
Message-ID: <4FFF6EC8.60300@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <09f86300bb1913aa4c6063618fbbcd84fac2e608.1341871200.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101735540.24998@blackhole.kfki.hu> <4FFCBDAD.5010206@googlemail.com> <alpine.DEB.2.00.1207112119460.26540@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58016 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2GMAlv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:41:51 -0400
Received: by weyx8 with SMTP id x8so2114595wey.19
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jul 2012 17:41:49 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207112119460.26540@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> A userspace match/target "works" with the corresponding kernel 
> match/target only when their revision numbers match. The new revisions are 
> our standard way to introduce new features in matches/targets so that it 
> won't break anything and work fine in any old-new kernel-iptables 
> combinations: the system uses (falls back to) the highest revision which 
> is avaliable at both sides.
>
> The new match/target revision in userspace just need the new 
> parse/print/save functions, the matching new match/target revision in 
> kernel space differ from the current one just in revision number.
>   
All noted and tested - that is exactly how it works. Thanks.

>> Similarly, if I rename the new functions to something else, won't that 
>> cause compatibility issues where other programs are going to look for 
>> these functions (from what I remember these functions are defined in the 
>> C header files, so, potentially, after this change they are bound to 
>> break something!). Could you elaborate a bit more please?
>>     
>
> These functions are static. Nothing else uses them.
>   
OK, that's good because I intend to change the parse_dirs function in 
the new "version" and introduce additional parameter called "features" 
so that these are used directly and not rely on the info->flags to store 
these (as was the case up until now). That would also allow for 
additional features to be added in the future, if needed (u8 is almost 
exhausted - you have one spare bit left there!).

> Let there be long spaces, I'll fix those. But with so long lines, it's 
> hard to see the changes.
>   
Noted, will do.

> The header files in include/linux/netfilter in the iptables source are 
> usually not maintained manually. They are generated from the kernel header 
> files by filtering out the kernel specific parts protected by the ifdefs.
>
> At the moment, the enum ip_set_feature definition is kernel specific in 
> the kernel header file. Next time Pablo regenerates the header files for 
> iptables from the kernel ones, your modification above will be lost. 
> Therefore the enum definition must be moved out from the "#ifdef 
> __KERNEL__" region in the kernel header file.
>   
Yep, just saw that too, so I'll just move the ip_set_feature enum just 
above the #ifdef __KERNEL__ part and I assume it would be picked up 
"automatically", is that right?

