From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 1/3] iptables: change 'iface' part in hash:net,iface
 set
Date: Fri, 13 Jul 2012 14:56:52 +0100
Message-ID: <50002924.5040404@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <09f86300bb1913aa4c6063618fbbcd84fac2e608.1341871200.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101735540.24998@blackhole.kfki.hu> <4FFCBDAD.5010206@googlemail.com> <alpine.DEB.2.00.1207112119460.26540@blackhole.kfki.hu> <4FFF6EC8.60300@googlemail.com> <alpine.DEB.2.00.1207131003540.31126@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42207 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2GMN5A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:57:00 -0400
Received: by eaak11 with SMTP id k11so1081011eaa.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jul 2012 06:56:58 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207131003540.31126@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  

>> OK, that's good because I intend to change the parse_dirs function in 
>> the new "version" and introduce additional parameter called "features" 
>> so that these are used directly and not rely on the info->flags to store 
>> these (as was the case up until now). That would also allow for 
>> additional features to be added in the future, if needed (u8 is almost 
>> exhausted - you have one spare bit left there!).
>>     
>
> The almost exhausted u8 is an additional reason why it's better to use 
> unsigned int in the *protocol* between the kernel-userspace 
> (struct ip_set_req_get_features).
>   
Yeah, I got it Jozsef - I'll alter ip_set_req_get_features to use 
unsigned in instead of u8. Jesus!

Are you happy for the extra parameter called "features" to be included 
in the print function (iptables - userspace) as this is where I will 
store the features, not by using info->flags anymore?

>> Yep, just saw that too, so I'll just move the ip_set_feature enum just 
>> above the #ifdef __KERNEL__ part and I assume it would be picked up 
>> "automatically", is that right?
>>     
>
> No, let the patchset be complete in itself, i.e. include the patches both 
> for the kernel and iptables header files.
>   
Fair enough.

