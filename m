From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 13 Jul 2012 15:22:55 +0100
Message-ID: <50002F3F.5020408@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64639 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2GMOXD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:23:03 -0400
Received: by eaak11 with SMTP id k11so1090765eaa.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jul 2012 07:23:02 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I'm talking about the same sets, but two rules, in two cases. The result 
> of the rules depend on the syntax of yours.
>   
[...]
> That's the problem: they are not always interchangeable. Sometimes they 
> are, sometimes they aren't. 
>   
[...]
>> And that is because the second dimension parameter is accounted for and you
>> have a member of the list1 set which is not of type hash:net,iface - that is
>> where the definition of in/out are different. Show me where the
>> "inconsistency" or the "confusion" is here then?
>>     
>
> And this is what I call inconsistency and leads to confusion.
>   
[...]
>>> 4. step
>>>
>>> 	ipset del list1 netiface0
>>>
>>>     Rule a. and rule b. produce again the same result.
>>>   
>>>       
>> Oh yeah? Are you for real? They produce different results! The reason for that
>> is because the second dimension ('dst' and 'out') differ - by definition - for
>> sets other than hash:net,iface, which is the case here (ipport0 is still a
>> member of list1) - the same as step 3 above. Show me where the "inconsistency"
>> or the "confusion" is here then?
>>     
>
> No, I'm mistaken here. Yeah, I myself were confused with your damned 
> syntax.
>   
Let me ask you a question then - if I send you the patches where in/out 
is allowed in list:set and produces "consistent" (by your own 
high-standards) result would that be OK with you (if not, why not)?

