From: Martijn Lievaart <m@rtij.nl>
Subject: Re: condition for 2.6.16
Date: Thu, 20 Apr 2006 21:44:24 +0200
Message-ID: <4447E498.7060006@rtij.nl>
References: <200604201919.19246.max@nucleus.it> <4447D7AA.1010602@trash.net>
	<200604202139.02931.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604202139.02931.max@nucleus.it>
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

Massimiliano Hofer wrote:

>On Thursday 20 April 2006 8:49 pm, Patrick McHardy wrote:
>  
>
>>We have already decided that the condition match will not be merged
>>because the same thing can easily be done by adding/removing rules
>>from userspace.
>>    
>>
>
>Sorry, I missed that discussion.
>Is it still possible to include it in the external patches?
>
>Anyway I think condition allows for a much more elegant solution in cases 
>where adding and removing rules would lead to a messy and unpredictable 
>sequence of overlapping rules, not to mention races between different 
>modifications.
>Just my humble opinion.
>  
>

I concur. The condition match is much more elegant then dynamically 
messing with the rules.

M4
