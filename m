From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 15 Jul 2012 12:54:16 +0100
Message-ID: <5002AF68.9070204@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu> <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38767 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2GOLy2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:54:28 -0400
Received: by wibhm11 with SMTP id hm11so1940960wib.1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 04:54:26 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  

>> There is a flip side to that particular coin - I could argue that since 
>> in/out *is* allowed to be used in hash:net,iface, why can't it be used 
>> in list:set where I could have hash:net,iface type sets accepted as 
>> members? You are imposing an unnecessary restriction where none is 
>> needed.
>>     
>
> Both a. and b. must satisfy that the result must not depend on the syntax. 
> If "in/out" is allowed in a rule then replacing by "src/dst" the result of 
> the iptables rule must remain the same. Whatever sets are in a list:set.
>   
I fail to see how your answer addresses my point above, which I raised 
in response to the restriction imposed by "solution a." of not allowing 
in/out in a list:set where there could be hash:net,iface members 
registered.

You know very well that by allowing in/out alongside src/dst in a 
list:set this *will* produce the same members match - that was your 
previous objection for not allowing in/out to be used alongside src/dst 
in list:set, until I found you this solution and then you swiftly moved 
the goalposts, again!

> I don't favour b. Ugly like hell, a. were much cleaner.
>   
You couldn't make this up! I mean, really Jozsef?

In a couple of hours yesterday, you went from:

"Solution b. is also acceptable but it's more controversial", then

"Therefore I'm not really happy with solution b. but I can stomach it", 
and finally, the above answer, not to mention that you started all of 
this with you being "unhappy" with users being "forced" to use src/dst 
only on list:set types.

In other words - you have gone full circle - twice - in a space of just 
a couple of days. I see that "debating" with you is becoming a bit of a 
pointless exercise.

