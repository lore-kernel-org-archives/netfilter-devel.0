From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Unconditionaly push mark to conntrack structure
Date: Mon, 12 Jun 2006 00:00:53 +0200
Message-ID: <448C9295.9080102@netfilter.org>
References: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr> <447CD8AA.2040502@trash.net>
	<447CDB83.1090606@trash.net> <447CE2B0.8000504@trash.net>
	<447CE4ED.9010706@netfilter.org> <447CEAF3.5030903@trash.net>
	<44856875.2020108@netfilter.org> <4487D0E2.4030705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4487D0E2.4030705@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>Pablo Neira Ayuso wrote:
>>>
>>>
>>>>To be frank, I can't see how the timer can be useful from userspace. I
>>>>think that we should remove it.
>>>
>>>
>>>
>>>Don't you need it for synchronization? One example where it could be
>>>useful is to implement different timeout strategies (for example
>>>something like pf's adaptive timeouts) in userspace.
>>
>>
>>But these adaptive timeouts could be implemented in kernelspace. 
> 
> Thats not a good argument .. by that logic we wouldn't need ctnetlink
> at all :)

Indeed, weak argument. I've been working today on conntrackd to 
generalize it more, now it's fairly extensible I think, so this feature 
can be easily added

>>Unfortunately, ctnetlink is not doing any sequence tracking of the
>>events at the moment :( and we have to. Here my old PIII 866MHz with a
>>100Mbits network card starts dropping events when it reaches ~300
>>simultaneos short TCP connections (2 seconds) with netperf. I'm going to
>>cook a patch for this.
> 
> That seems to be pretty poor performance - by sequence tracking you
> mean TCP state updates? Is that poor performance with or without
> them?

I meant that nlmsg_seq is not set in the events sent by ctnetlink. I 
sent you a RFC patch some days ago, please let me know what you think. 
About the performance test, I'll do some testing to get some results 
tomorrow again, then I'll post them so we could comment them.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
