From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 05 Apr 2005 09:32:16 +0200
Message-ID: <42523F00.7010902@trash.net>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
	<20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050404204716.GA4067@linuxace.com>
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

Phil Oester wrote:
> On Mon, Apr 04, 2005 at 10:27:30AM +0200, Patrick McHardy wrote:
> 
>>So in conclusion it seems simply doing "seq -= this_way->offset_after"
>>without the seq != this_way->correction_pos check handles all cases
>>correctly. Please someone verify I didn't make a mistake. I think a
>>comment explaining the cases would also be appropriate.
> 
> 
> I think you are only thinking in terms of positive sizediff, while this
> is not always the case.  Perhaps easiest to explain by observed example.

Damn, you're right.

> Ack?

Let me think about it again, I'll get back to you.

Regards
Patrick
