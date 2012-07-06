From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 23:25:43 +0100
Message-ID: <4FF765E7.6020809@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2GFWZw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:25:52 -0400
Received: by werb14 with SMTP id b14so6680813wer.19
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 15:25:51 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  

>> Explain the above comment please?
>>     
>
> Are you deliberately deaf to the arguments?
>   
My hearing is still quite sharp, thank you. As for the "arguments" bit - 
as far as I understand it (well, hoping, at least anyway), this is a 
discussion, and nobody's "arguing".

> You want a choice to be introduced which lead to confusion - I'm repeating 
> it countless times and you just ignore it.
How am I ignoring it? I asked you before and I am asking you again to 
explain what that "confusion" is? It is quite clear to me what the 
meaning of "in" and "out" is (again, if it is not made clear in the 
various man pages, I would certainly appreciate any suggestions you - or 
anyone else following this - might have). Again, if there is something 
"confusing" in that meaning, then I'd like to know.

To reiterate once again - 'in' is for matches of incoming interfaces 
only and should only be used for that particular purpose (it is one 
reason why I am dead against your idea for this to be used "everywhere" 
- to answer your other query below). Similar with 'out', but for 
outgoing interfaces.

I don't know how much more clearer that could be, to be honest, but if 
you have something on your mind, I am certainly all eyes/ears!

>  In order to prevent such 
> confusions, I offered that let "in/out" be alias to "src/dst": accepted as 
> input everywhere but printed/saved with hash:net,iface only. You point 
> blank refused it.
That is correct, and I also remember asking the question to whom do you 
think that solution would be "easier"? You declined to answer that 
particular query. It certainly won't be for the end user, that's for sure!

As for your suggestion above, I'll repeat what I've already posted - of 
course I'll refuse it, because it is completely nonsensical. Do you not 
think that referring to a destination IP address, for example, as "out" 
IP address isn't confusing in the slightest? I mean, really Jozsef, you 
could do better than that!

>  Then come up with a better solution than the submitted 
> one.
>   
I will, if you let me know what is wrong, in your view, with the one I 
submitted yesterday.
