From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Wed, 18 Jul 2012 00:29:22 +0100
Message-ID: <5005F552.9060301@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu> <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com> <alpine.DEB.2.00.1207152041270.4159@blackhole.k
 fki.hu> <500340DF.6070207@googlemail.com> <alpine.DEB.2.00.1207160924370.5297@blackhole.kfki.hu> <50040B6A.608@googlemail.com> <alpine.DEB.2.00.1207161549410.5297@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36314 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2GQX31 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:29:27 -0400
Received: by wibhm11 with SMTP id hm11so4198423wib.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jul 2012 16:29:25 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207161549410.5297@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> What you wrote was:
>
> You:> What I have suggested to you was that you allow in/out to be 
> You:> *entered*, as input, in a list:set (i.e. in the iptables statement), 
> You:> but treated internally in the same way as src/dst ('in' to be 
> You:> treated internally as 'src', 'out' as 'dst' obviously). In that way, 
> You:> there won't be any discrepancies and the results from both 
> You:> "solutions" will be the same. In other words (using the example you 
> You:> gave earlier), typing:
> You:> 
> You:> -bash-~# iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
> You:> 
> You:> and
> You:> 
> You:> -bash-~# iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
> You:> 
> You:> to be both accepted  and 'in', as *entered* above, to be interpreted 
> You:> in the same way as 'src'. That way there won't be any "different" 
> You:> results.
>
> So if list1 contains a hash:ip,port type alone, the rule
>
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> is perfectly fine and logical. We circled again and I'm fed up.
>   
So? I fail to see where I have contradicted myself (if that was indeed 
your intention to show me when you sent the above) or how the above is 
wrong, but please feel free to elaborate if you so wish.

>> You keep banging on about "send me the patches according to solution a", but
>> you are unwilling or unable to address the consequences of this and the issues
>> I raised in this regard. Once this is done and I am convinced that this is the
>> way to go, I'll send you the new patches.
>>
>> This isn't some sort of Stalin-like republic where you can just order me to
>> "send you the patches" and I do as I am told, OK? This is a free forum where
>> we, as peers, are allowed to discuss these issues. If you are unable to hold
>> to your arguments after I shot them to pieces, do you think that by ordering
>> me to "send you the patches" I am going to concede and do as I am told?
>>
>> Or do you think that just because you've written parts of the ipset code you
>> could just order me to "send you the patches" I'll bow my head and say "yes,
>> sir, I'll do it sir, right away sir"? Really? Get a grip of yourself Jozsef!
>>     
>
> Stop this, now. I don't tolerate your style anymore.
>   
Stop what now? If I think that you've overstepped the mark by giving me 
orders to "send you the patches" instead of supporting your own 
viewpoints and arguments when I challenge them, I'll pull you up on it 
as I did with my post above.

> I don't care what you do. I accept patches which I believe fit fine into 
> the current system.
>   
As I already pointed out, if you present your points and you are not 
prepared to be challenged by others (particularly if there is some 
disagreement, as is the case here), then you are in the wrong place I am 
afraid.

I clearly disagree with your view to prevent in/out being used in 
list:set (one reason I asked you to let me know what do you think in/out 
is - I am yet to receive a response from you on that), given that 
hash:net,iface could be a member of that set and also given the fact 
that in/out is used there.

As soon as I start asking questions and digging up holes in your 
arguments, you revert to type and I either get a response like "I've had 
enough", "I am fed up" or, as above, I am given orders to submit those 
patches regardless.

That is not how it works and you should know better - the last time I 
checked, this is a forum for discussion among peers, not some sort of 
totalitarian setup where someone starts barking orders and others follow 
in line - this is precisely what I meant with my post above.

Again, if you make your view points, you should be prepared those views 
to be challenged, particularly if there is a disagreement, and not hide 
away and start giving orders for others to follow. I hope I have made 
myself clear.

