From: Quinton Hoole <quinton@hoole.biz>
Subject: Re: changing packet length?
Date: Tue, 07 Jun 2005 09:21:26 +0200
Message-ID: <42A54AF6.4040203@hoole.biz>
References: <20050503213406.GE13894@tigris.renesys.com>	<20050506111410.GG30482@sunbeam.de.gnumonks.org>	<20050506141159.GA17261@tigris.renesys.com>
	<20050529190128.GV13114@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: BJ Premore <bj-netfilter@renesys.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050529190128.GV13114@sunbeam.de.gnumonks.org>
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



Harald Welte wrote:

>On Fri, May 06, 2005 at 10:11:59AM -0400, BJ Premore wrote:
>  
>
>>Hi Harald,
>>
>>On Fri, May 06, 2005 at 01:14:10PM +0200, Harald Welte wrote:
>>    
>>
>>>On Tue, May 03, 2005 at 05:34:06PM -0400, BJ Premore wrote:
>>>      
>>>
>>>>So my hopefully simple question is, can packet sizes be
>>>>changed and then reinjected using ipq_set_verdict?  
>>>>        
>>>>
>>>Of course. you just reinject the packet with a different
>>>data_len.
>>>      
>>>
>>That's what I thought too, but I get the problems described
>>in my original post (subsequent packets start looking
>>mangled, basically).  Have you, or has anyone, gotten this
>>to work?  I've been scouring the net for examples but in no
>>case has any code that I've found actually changed the
>>length of the packets before reinjecting them.
>>    
>>
>
>another thought:  could you double-check (using strace) that the packets
>you reinject are exactly like they are supposed to be?
>  
>
I haven't looked into the detail of what you're doing, but I'm busy 
developing a netfilter target, and in the process realised that the 
kernel recalculates the IP header length, and ignores whatever header 
length I inject (i.e. if I increase the header length in order to have 
open space at the end of the IP options, it recalculates the length on 
the basis of the real option sit finds, and overwrites my increased 
header length).  It could be doing something similar to your packet 
bodies.  Just a thought.
