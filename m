From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 19:50:44 +0200
Message-ID: <42669674.3020905@trash.net>
References: <20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com> <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>
	<20050406044806.GA9711@linuxace.com> <4263108E.1030707@trash.net>
	<20050419005847.GA591@linuxace.com> <42666F4C.5080706@trash.net>
	<20050420155308.GA7057@linuxace.com> <42667E51.3060005@trash.net>
	<20050420172406.GB7057@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050420172406.GB7057@linuxace.com>
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
> On Wed, Apr 20, 2005 at 06:07:45PM +0200, Patrick McHardy wrote:
> 
>>You forget about the network, which can duplicate, delay and reorder
>>packets. If we don't handle this is it will screw up the state.
> 
> I'm aware of that, but again I claim that it is irrelevant in this case
> because the PORT commands will not be processed out of order (even if the
> data packets are), and thus the adjustments will occur sequentially.

Why wouldn't they be processed out of order by nat?

>>No, but this function should do the right thing anyway.
> 
> Agreed, but IMHO my approach is currently the best available fix for a problem
> which is affecting many people.  If further testing shows it can be improved,
> that is great -- but I certainly don't think it's any worse than the current
> broken behaviour.

I agree that the problem should be fixed ASAP. I'll do a proper fix
now - either by moving seq adjustment after NAT helpers or by adding
a flag to the skb.

Regards
Patrick
