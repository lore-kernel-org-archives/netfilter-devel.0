From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] note owner match brokenness
Date: Fri, 01 Oct 2004 23:30:06 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415DCC5E.2030407@trash.net>
References: <20041001204447.GA30390@linuxace.com> <415DC791.3060409@trash.net>
	<20041001211251.GA30542@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041001211251.GA30542@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>On Fri, Oct 01, 2004 at 11:09:37PM +0200, Patrick McHardy wrote:
>  
>
>>If we warn in userspace, we should warn when then options are used
>>instead of in the helptext.
>>    
>>
>
>Agreed, but do we want to:
>
>   1) warn on every single use of owner match?
>   2) have iptables determine if we are running on an SMP box, and
>      only warn in that case?
>
>I didn't think either of these were terribly appealing.
>  
>

Agreed, I'm going to apply your patch. Thanks.

Regards
Patrick
