From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Last minute erratum: I'm stupid. - Re: Side effect? - Re: Changing
 the content of tcp timeouts ...
Date: Thu, 15 Jan 2004 16:29:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4006A3CD.5070104@netlab.hut.fi>
References: <Pine.LNX.4.44.0401141203530.29640-100000@filer.marasystems.com>	 <40053873.6000806@netlab.hut.fi> <1074084643.15865.6.camel@nienna.balabit>	 <400542BD.6050706@netlab.hut.fi>  <40064EA0.3050603@netlab.hut.fi> <1074172485.1305.21.camel@nienna.balabit> <4006A15C.7090908@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Guiton wrote:

> KOVACS Krisztian wrote:
>
>>  Are you sure iptable_nat is loaded in the kernel? And what does your
>> kernel log say?
>>
>>  
>>
> Well, as far as I've modified my sources I can't reproduce the error 
> immediately. But a good guess would be that the module was not loaded 
> and more specifically the problem may simply occured in the 
> ip_conntrack module, thus avoiding iptable_nat to work.
> But the problem is now solved. I have not changed anything except the 
> name of my function which is much shorter than my original one. Now 
> it's working, even the execution produces the result I was expecting. 
> Isn't there a specific bound on the function's name? The first name I 
> used was 44 characters long (it was in fact a longer version of the 
> one I indicated in my previous mail).
>
> Tanks for your help anyway.
>
>          Emmanuel
>
I just noticed the real cause of the problem. A syntax error in the name 
of my function. I thought I had checked it... Please, forget about all 
the previous messages.
Mea culpa.

           Emmanuel
